<?php

namespace App\Console;

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    protected function schedule(Schedule $schedule): void
    {
        // Programa la sincronización diaria a las 09:05 hora de Caracas
        $schedule->command('exchange:sync-bcv')->dailyAt('09:05')->timezone('America/Caracas');
        
        // Enviar recordatorios de citas cada 15 minutos
        $schedule->command('citas:recordatorios')->everyFifteenMinutes();
    }

    protected function commands(): void
    {
        $this->load(__DIR__.'/Commands');
    }
}
