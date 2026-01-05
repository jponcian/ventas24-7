<?php

namespace App\Channels;

use App\Services\WhatsAppService;
use Illuminate\Notifications\Notification;

class WhatsAppChannel
{
    protected $whatsappService;

    public function __construct(WhatsAppService $whatsappService)
    {
        $this->whatsappService = $whatsappService;
    }

    /**
     * Send the given notification.
     *
     * @param  mixed  $notifiable
     * @param  \Illuminate\Notifications\Notification  $notification
     * @return void
     */
    public function send($notifiable, Notification $notification)
    {
        if (!method_exists($notification, 'toWhatsapp')) {
            return;
        }

        $data = $notification->toWhatsapp($notifiable);
        
        if (empty($data['telefono']) || empty($data['message'])) {
            return;
        }

        // Formatear el número de teléfono
        $phoneNumber = $this->formatPhoneNumber($data['telefono']);
        
        if (!$phoneNumber) {
            \Log::warning('WhatsApp: Número de teléfono inválido', [
                'notifiable_id' => $notifiable->id,
                'telefono' => $data['telefono']
            ]);
            return;
        }

        // Enviar el mensaje
        $result = $this->whatsappService->sendMessage($phoneNumber, $data['message']);

        if (!$result['success']) {
            \Log::error('WhatsApp: Error al enviar notificación', [
                'notifiable_id' => $notifiable->id,
                'error' => $result['error'] ?? 'Unknown error'
            ]);
        }
    }

    /**
     * Formatear número de teléfono venezolano a formato internacional
     * Operadoras: Movistar (0414, 0424), Digitel (0412, 0422), Movilnet (0416, 0426)
     */
    private function formatPhoneNumber($phone)
    {
        $phone = preg_replace('/[^0-9+]/', '', $phone);
        
        // Si ya tiene el formato internacional correcto
        if (preg_match('/^\+58(41[24]|42[246])\d{7}$/', $phone)) {
            return $phone;
        }
        
        // Si es formato local venezolano
        if (preg_match('/^0(41[24]|42[246])(\d{7})$/', $phone, $matches)) {
            return '+58' . $matches[1] . $matches[2];
        }
        
        // Si ya tiene 58 pero sin el +
        if (preg_match('/^58(41[24]|42[246])\d{7}$/', $phone)) {
            return '+' . $phone;
        }
        
        return null;
    }
}
