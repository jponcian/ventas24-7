<?php

namespace App\Notifications;

use App\Models\LabOrder;
use App\Services\WhatsAppService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class ResultadoLaboratorioListo extends Notification implements ShouldQueue
{
    use Queueable;

    protected $order;

    /**
     * Create a new notification instance.
     */
    public function __construct(LabOrder $order)
    {
        $this->order = $order;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @return array<int, string>
     */
    public function via(object $notifiable): array
    {
        $channels = ['mail']; // Siempre envía email
        
        // Si tiene WhatsApp habilitado y el usuario tiene teléfono
        if (config('whatsapp.enabled') && !empty($notifiable->telefono)) {
            $channels[] = 'whatsapp';
        }
        
        return $channels;
    }

    /**
     * Get the mail representation of the notification.
     */
    public function toMail(object $notifiable): MailMessage
    {
        $clinica = $this->order->clinica->nombre ?? 'SomosSalud';
        $orderNumber = $this->order->order_number;
        $examCount = $this->order->details->count();

        return (new MailMessage)
                    ->subject('Resultados de Laboratorio Listos - SomosSalud')
                    ->greeting("¡Hola {$notifiable->name}!")
                    ->line("Tus resultados de laboratorio ya están disponibles.")
                    ->line("**Detalles de la orden:**")
                    ->line("📋 Orden: {$orderNumber}")
                    ->line("🔬 Exámenes realizados: {$examCount}")
                    ->line("🏥 Clínica: {$clinica}")
                    ->action('Descargar Resultados', route('lab.orders.download', $this->order->id))
                    ->line('También puedes verificar tus resultados con el código: **' . $this->order->verification_code . '**')
                    ->line('Ingresa a: ' . route('lab.orders.verify', $this->order->verification_code))
                    ->salutation('Saludos, Equipo SomosSalud');
    }

    /**
     * Get the WhatsApp representation of the notification.
     */
    public function toWhatsapp(object $notifiable)
    {
        $clinica = $this->order->clinica->nombre ?? 'SomosSalud';
        $orderNumber = $this->order->order_number;
        $examCount = $this->order->details->count();
        $verificationUrl = route('lab.orders.verify', $this->order->verification_code);

        $message = "🏥 *SomosSalud - Resultados Listos*\n\n";
        $message .= "Hola {$notifiable->name} 👋\n\n";
        $message .= "¡Buenas noticias! Tus resultados de laboratorio ya están disponibles. 🔬✅\n\n";
        $message .= "📋 *Orden:* {$orderNumber}\n";
        $message .= "🧪 *Exámenes:* {$examCount}\n";
        $message .= "🏥 *Clínica:* {$clinica}\n\n";
        $message .= "🔐 *Código de verificación:* {$this->order->verification_code}\n\n";
        $message .= "📥 *Descarga tus resultados aquí:*\n";
        $message .= "{$verificationUrl}\n\n";
        $message .= "_Gracias por confiar en SomosSalud_ 💚";

        return [
            'message' => $message,
            'telefono' => $notifiable->telefono
        ];
    }

    /**
     * Get the array representation of the notification.
     *
     * @return array<string, mixed>
     */
    public function toArray(object $notifiable): array
    {
        return [
            'order_id' => $this->order->id,
            'order_number' => $this->order->order_number,
            'verification_code' => $this->order->verification_code,
        ];
    }
}
