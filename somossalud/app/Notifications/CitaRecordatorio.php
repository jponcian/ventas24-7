<?php

namespace App\Notifications;

use App\Models\Cita;
use App\Services\WhatsAppService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class CitaRecordatorio extends Notification implements ShouldQueue
{
    use Queueable;

    protected $cita;
    protected $tipoRecordatorio; // '24h' o '2h'

    /**
     * Create a new notification instance.
     */
    public function __construct(Cita $cita, string $tipoRecordatorio = '24h')
    {
        $this->cita = $cita;
        $this->tipoRecordatorio = $tipoRecordatorio;
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
        $cuando = $this->tipoRecordatorio === '24h' ? 'mañana' : 'en 2 horas';
        $fecha = \Carbon\Carbon::parse($this->cita->fecha)->format('d/m/Y H:i');
        $especialista = $this->cita->especialista->name ?? 'Especialista';

        return (new MailMessage)
                    ->subject('Recordatorio de Cita - SomosSalud')
                    ->greeting("¡Hola {$notifiable->name}!")
                    ->line("Te recordamos que tienes una cita médica {$cuando}.")
                    ->line("**Detalles de la cita:**")
                    ->line("📅 Fecha: {$fecha}")
                    ->line("👨‍⚕️ Especialista: {$especialista}")
                    ->line("🏥 Clínica: " . ($this->cita->clinica->nombre ?? 'SomosSalud'))
                    ->action('Ver Mi Cita', route('citas.show', $this->cita->id))
                    ->line('Por favor, llega 15 minutos antes de tu cita.')
                    ->line('Si necesitas cancelar o reprogramar, házlo con anticipación.')
                    ->salutation('Saludos, Equipo SomosSalud');
    }

    /**
     * Get the WhatsApp representation of the notification.
     */
    public function toWhatsapp(object $notifiable)
    {
        $cuando = $this->tipoRecordatorio === '24h' ? 'mañana' : 'en 2 horas';
        $fecha = \Carbon\Carbon::parse($this->cita->fecha)->format('d/m/Y H:i');
        $especialista = $this->cita->especialista->name ?? 'Especialista';
        $clinica = $this->cita->clinica->nombre ?? 'SomosSalud';

        $message = "🏥 *SomosSalud - Recordatorio de Cita*\n\n";
        $message .= "Hola {$notifiable->name} 👋\n\n";
        $message .= "Te recordamos que tienes una cita médica *{$cuando}*.\n\n";
        $message .= "📅 *Fecha y hora:* {$fecha}\n";
        $message .= "👨‍⚕️ *Especialista:* {$especialista}\n";
        $message .= "🏥 *Clínica:* {$clinica}\n\n";
        $message .= "⏰ *Por favor llega 15 minutos antes.*\n\n";
        $message .= "Si necesitas cancelar o reprogramar, házlo con anticipación.\n\n";
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
            'cita_id' => $this->cita->id,
            'tipo_recordatorio' => $this->tipoRecordatorio,
            'fecha_cita' => $this->cita->fecha,
        ];
    }
}
