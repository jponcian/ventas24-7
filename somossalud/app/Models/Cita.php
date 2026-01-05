<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Cita extends Model
{
    use HasFactory;

    protected $table = 'citas';

    protected $fillable = [
        'usuario_id',
        'clinica_id',
        'especialista_id',
        'fecha',
        'precio',
        'precio_descuento',
        'estado',
        'diagnostico',
        'tratamiento',
        'medicamentos_texto',
        'observaciones',
        'concluida_at',
        'motivo',
    ];

    public function usuario()
    {
        return $this->belongsTo(User::class, 'usuario_id');
    }

    public function clinica()
    {
        return $this->belongsTo(Clinica::class, 'clinica_id');
    }

    public function especialista()
    {
        return $this->belongsTo(User::class, 'especialista_id');
    }

    public function adjuntos()
    {
        return $this->hasMany(CitaAdjunto::class, 'cita_id');
    }

    public function medicamentos()
    {
        return $this->hasMany(CitaMedicamento::class, 'cita_id')->orderBy('orden');
    }

    public function getEstadoBadgeAttribute()
    {
        return match ($this->estado) {
            'pendiente' => 'secondary',
            'confirmada' => 'success',
            'cancelada' => 'danger',
            'concluida' => 'info',
            default => 'light',
        };
    }
}
