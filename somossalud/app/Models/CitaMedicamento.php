<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CitaMedicamento extends Model
{
    use HasFactory;

    protected $table = 'cita_medicamentos';

    protected $fillable = [
        'cita_id', 'nombre_generico', 'presentacion', 'posologia', 'frecuencia', 'duracion', 'orden'
    ];

    public function cita()
    {
        return $this->belongsTo(Cita::class, 'cita_id');
    }
}
