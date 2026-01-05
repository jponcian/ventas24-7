<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CitaAdjunto extends Model
{
    use HasFactory;

    protected $table = 'cita_adjuntos';

    protected $fillable = [
        'cita_id', 'ruta', 'nombre_original', 'mime', 'size'
    ];

    public function cita()
    {
        return $this->belongsTo(Cita::class, 'cita_id');
    }
}
