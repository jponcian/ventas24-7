<?php

namespace App\Mail;

use App\Models\Cita;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class CitaAgendada extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    public Cita $cita;

    public function __construct(Cita $cita)
    {
        // Cargamos relaciones básicas para usar en la vista sin N+1
        $this->cita = $cita->loadMissing(['usuario', 'especialista', 'clinica']);
    }

    public function build(): self
    {
        $fecha = \Illuminate\Support\Carbon::parse($this->cita->fecha)->format('d/m/Y H:i');
        $doctor = optional($this->cita->especialista)->name ?? 'Especialista';

        return $this
            ->subject("Cita médica agendada · $fecha con $doctor")
            ->markdown('emails.citas.agendada', [
                'cita' => $this->cita,
            ]);
    }
}
