<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ReportePago extends Model
{
    use HasFactory;

    protected $table = 'pagos_reportados';

    protected $fillable = [
        'usuario_id',
        'cedula_pagador',
        'telefono_pagador',
        'fecha_pago',
        'referencia',
        'monto',
        'estado',
        'observaciones',
        'reviewed_by',
        'reviewed_at',
    ];

    protected $casts = [
        'fecha_pago' => 'date',
        'reviewed_at' => 'datetime',
    ];

    public function usuario()
    {
        return $this->belongsTo(User::class, 'usuario_id');
    }

    public function revisor()
    {
        return $this->belongsTo(User::class, 'reviewed_by');
    }
}
