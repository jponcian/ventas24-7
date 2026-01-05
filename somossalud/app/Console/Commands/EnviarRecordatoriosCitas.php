<?php

namespace App\Console\Commands;

use App\Models\Cita;
use App\Notifications\CitaRecordatorio;
use Carbon\Carbon;
use Illuminate\Console\Command;

class EnviarRecordatoriosCitas extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'citas:recordatorios';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Envía recordatorios de citas programadas (24h y 2h antes)';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $this->info('Iniciando envío de recordatorios de citas...');

        $enviados = 0;

        // Recordatorios de 24 horas antes
        $enviados += $this->enviarRecordatorios24Horas();

        // Recordatorios de 2 horas antes
        $enviados += $this->enviarRecordatorios2Horas();

        $this->info("✓ Proceso completado. Total de recordatorios enviados: {$enviados}");

        return Command::SUCCESS;
    }

    /**
     * Enviar recordatorios 24 horas antes
     */
    private function enviarRecordatorios24Horas()
    {
        $this->line('Buscando citas para recordatorio de 24 horas...');

        // Buscar citas que sean en exactamente 24 horas (con margen de 30 minutos)
        $manana = Carbon::now()->addDay();
        $inicio = $manana->copy()->subMinutes(15);
        $fin = $manana->copy()->addMinutes(15);

        $citas = Cita::whereBetween('fecha', [$inicio, $fin])
            ->whereIn('estado', ['pendiente', 'confirmada'])
            ->with(['usuario', 'especialista', 'clinica'])
            ->get();

        $enviados = 0;

        foreach ($citas as $cita) {
            if ($cita->usuario && $cita->usuario->email) {
                try {
                    $cita->usuario->notify(new CitaRecordatorio($cita, '24h'));
                    $enviados++;
                    $this->line("  ✓ Recordatorio 24h enviado a: {$cita->usuario->name} (Cita #{$cita->id})");
                } catch (\Exception $e) {
                    $this->error("  ✗ Error enviando a {$cita->usuario->name}: {$e->getMessage()}");
                }
            }
        }

        $this->info("Recordatorios 24h: {$enviados} de {$citas->count()} enviados");

        return $enviados;
    }

    /**
     * Enviar recordatorios 2 horas antes
     */
    private function enviarRecordatorios2Horas()
    {
        $this->line('Buscando citas para recordatorio de 2 horas...');

        // Buscar citas que sean en exactamente 2 horas (con margen de 15 minutos)
        $enDosHoras = Carbon::now()->addHours(2);
        $inicio = $enDosHoras->copy()->subMinutes(7);
        $fin = $enDosHoras->copy()->addMinutes(7);

        $citas = Cita::whereBetween('fecha', [$inicio, $fin])
            ->whereIn('estado', ['pendiente', 'confirmada'])
            ->with(['usuario', 'especialista', 'clinica'])
            ->get();

        $enviados = 0;

        foreach ($citas as $cita) {
            if ($cita->usuario && $cita->usuario->email) {
                try {
                    $cita->usuario->notify(new CitaRecordatorio($cita, '2h'));
                    $enviados++;
                    $this->line("  ✓ Recordatorio 2h enviado a: {$cita->usuario->name} (Cita #{$cita->id})");
                } catch (\Exception $e) {
                    $this->error("  ✗ Error enviando a {$cita->usuario->name}: {$e->getMessage()}");
                }
            }
        }

        $this->info("Recordatorios 2h: {$enviados} de {$citas->count()} enviados");

        return $enviados;
    }
}
