<?php

namespace App\Console\Commands;

use App\Models\LabOrder;
use App\Notifications\ResultadoLaboratorioListo;
use Illuminate\Console\Command;

class TestWhatsAppNotification extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'whatsapp:test-resultado {order_id}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Probar envío de notificación de WhatsApp para resultados de laboratorio';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $orderId = $this->argument('order_id');
        
        $this->info("Probando notificación de WhatsApp para orden #{$orderId}...");
        
        // Buscar la orden
        $order = LabOrder::with('patient')->find($orderId);
        
        if (!$order) {
            $this->error("Orden #{$orderId} no encontrada");
            return Command::FAILURE;
        }
        
        $this->info("Orden encontrada: {$order->order_number}");
        $this->info("Paciente: {$order->patient->name}");
        $this->info("Email: {$order->patient->email}");
        $this->info("Teléfono: " . ($order->patient->telefono ?? 'NO TIENE'));
        
        // Verificar configuración de WhatsApp
        $this->line("\n--- Configuración de WhatsApp ---");
        $this->info("WHATSAPP_ENABLED: " . (config('whatsapp.enabled') ? 'true' : 'false'));
        $this->info("WHATSAPP_INSTANCE_ID: " . (config('whatsapp.instance_id') ?? 'NO CONFIGURADO'));
        $this->info("WHATSAPP_TOKEN: " . (config('whatsapp.token') ? 'CONFIGURADO' : 'NO CONFIGURADO'));
        $this->info("WHATSAPP_API_URL: " . (config('whatsapp.api_url') ?? 'NO CONFIGURADO'));
        
        // Verificar si el paciente tiene teléfono
        if (empty($order->patient->telefono)) {
            $this->warn("\n⚠️  El paciente NO tiene número de teléfono registrado");
            $this->info("El WhatsApp no se enviará, solo el email.");
        }
        
        // Verificar canales de notificación
        $notification = new ResultadoLaboratorioListo($order);
        $channels = $notification->via($order->patient);
        
        $this->line("\n--- Canales de Notificación ---");
        $this->info("Canales activos: " . implode(', ', $channels));
        
        // Intentar enviar la notificación
        if ($this->confirm('¿Desea enviar la notificación de prueba?', true)) {
            try {
                $order->patient->notify($notification);
                $this->info("\n✓ Notificación enviada exitosamente");
                $this->info("Revisa los logs en storage/logs/laravel.log para más detalles");
            } catch (\Exception $e) {
                $this->error("\n✗ Error al enviar notificación: " . $e->getMessage());
                return Command::FAILURE;
            }
        }
        
        return Command::SUCCESS;
    }
}
