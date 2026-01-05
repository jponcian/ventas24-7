<?php

namespace App\Mail;

use App\Models\Suscripcion;
use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class SuscripcionAprobada extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    public User $usuario;
    public Suscripcion $suscripcion;

    public function __construct(User $usuario, Suscripcion $suscripcion)
    {
        $this->usuario = $usuario;
        $this->suscripcion = $suscripcion;
    }

    public function build(): self
    {
        return $this
            ->subject('Tu suscripción ha sido aprobada')
            ->markdown('emails.suscripcion.aprobada', [
                'usuario' => $this->usuario,
                'suscripcion' => $this->suscripcion,
            ]);
    }
}
