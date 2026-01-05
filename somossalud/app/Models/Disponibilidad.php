<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Disponibilidad extends Model
{
    use HasFactory;

    protected $table = 'disponibilidades';

    protected $fillable = [
        'especialista_id',
        'dia_semana',
        'hora_inicio',
        'hora_fin',
    ];

    public function especialista()
    {
        return $this->belongsTo(User::class, 'especialista_id');
    }
}
