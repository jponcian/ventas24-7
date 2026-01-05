<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class AtencionAdjunto extends Model
{
    use HasFactory;

    protected $table = 'atencion_adjuntos';

    protected $fillable = [
        'atencion_id','ruta','nombre_original','mime','size'
    ];

    public function atencion(){ return $this->belongsTo(Atencion::class, 'atencion_id'); }
}
