<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class AtencionMedicamento extends Model
{
    use HasFactory;

    protected $table = 'atencion_medicamentos';

    protected $fillable = [
        'atencion_id','nombre_generico','presentacion','posologia','frecuencia','duracion','orden'
    ];

    public function atencion(){ return $this->belongsTo(Atencion::class, 'atencion_id'); }
}
