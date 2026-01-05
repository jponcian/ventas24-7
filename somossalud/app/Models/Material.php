<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Material extends Model
{
    use SoftDeletes;
    
    protected $table = 'materiales';
    
    protected $fillable = [
        'clinica_id',
        'codigo',
        'nombre',
        'descripcion',
        'unidad_medida_default',
        'categoria_default',
        'stock_minimo',
        'stock_actual',
        'activo'
    ];
    
    // Scopes
    public function scopeActivos($query)
    {
        return $query->where('activo', true);
    }
    
    public function scopePorCategoria($query, $categoria)
    {
        return $query->where('categoria_default', $categoria);
    }
    
    public function scopeBuscar($query, $termino)
    {
        if (empty($termino)) {
            return $query;
        }
        
        return $query->where(function($q) use ($termino) {
            $q->where('nombre', 'like', "%{$termino}%")
              ->orWhere('codigo', 'like', "%{$termino}%");
        });
    }
    
    // Relaciones
    public function clinica(): BelongsTo
    {
        return $this->belongsTo(Clinica::class);
    }
}
