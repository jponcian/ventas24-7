<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Atencion extends Model
{
    use HasFactory;

    protected $table = 'atenciones';

    protected $fillable = [
        'paciente_id','clinica_id','recepcionista_id','especialidad_id',
        'aseguradora','numero_siniestro','seguro_validado','validado_at','validado_por',
        'estado','iniciada_at','atendida_at','cerrada_at','diagnostico','observaciones',
        'empresa','titular_id','titular_nombre','titular_cedula','titular_telefono','nombre_operador'
    ];

    protected $casts = [
        'seguro_validado' => 'boolean',
        'validado_at' => 'datetime',
        'iniciada_at' => 'datetime',
        'atendida_at' => 'datetime',
        'cerrada_at' => 'datetime',
    ];

    // Relaciones
    public function paciente(){ return $this->belongsTo(User::class, 'paciente_id'); }
    public function clinica(){ return $this->belongsTo(Clinica::class, 'clinica_id'); }
    public function recepcionista(){ return $this->belongsTo(User::class, 'recepcionista_id'); }
    // public function medico(){ return $this->belongsTo(User::class, 'medico_id'); }
    public function titular(){ return $this->belongsTo(User::class, 'titular_id'); }
    public function especialidad(){ return $this->belongsTo(Especialidad::class, 'especialidad_id'); }
    public function medicamentos(){ return $this->hasMany(AtencionMedicamento::class, 'atencion_id'); }
    public function adjuntos(){ return $this->hasMany(AtencionAdjunto::class, 'atencion_id'); }

    // Scopes
    public function scopeAbiertas($q){ return $q->whereIn('estado',['validado','en_consulta']); }
}
