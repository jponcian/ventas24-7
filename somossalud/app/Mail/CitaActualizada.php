<?php

namespace App\Mail;

use App\Models\Cita;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class CitaActualizada extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    public Cita $cita;
    public string $tipo; // 'cancelada' | 'reprogramada'
    public ?string $fechaAnterior;

    public function __construct(Cita $cita, string $tipo, ?string $fechaAnterior = null)
    {
        $this->cita = $cita->loadMissing(['usuario', 'especialista', 'clinica']);
        $this->tipo = $tipo;
        $this->fechaAnterior = $fechaAnterior;
    }

    public function build(): self
    {
        $fechaNueva = \Illuminate\Support\Carbon::parse($this->cita->fecha)->format('d/m/Y H:i');
        $doctor = optional($this->cita->especialista)->name ?? 'Especialista';

        $subject = $this->tipo === 'cancelada'
            ? 'Tu cita ha sido cancelada'
            : "Tu cita fue reprogramada · $fechaNueva con $doctor";

        return $this
            ->subject($subject)
            ->markdown('emails.citas.actualizada', [
                'cita' => $this->cita,
                'tipo' => $this->tipo,
                'fechaAnterior' => $this->fechaAnterior,
            ]);
    }
}
