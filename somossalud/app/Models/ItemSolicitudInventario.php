<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ItemSolicitudInventario extends Model
{
    protected $table = 'items_solicitud_inventario';
    
    protected $fillable = [
        'solicitud_id',
        'material_id',
        'nombre_item',
        'descripcion',
        'unidad_medida',
        'cantidad_solicitada',
        'cantidad_aprobada',
        'cantidad_despachada',
        'observaciones'
    ];
    
    // Relaciones
    public function solicitud(): BelongsTo
    {
        return $this->belongsTo(SolicitudInventario::class, 'solicitud_id');
    }
    
    public function material(): BelongsTo
    {
        return $this->belongsTo(Material::class, 'material_id');
    }
    
    // Métodos auxiliares
    public function getCantidadFinalAttribute(): int
    {
        return $this->cantidad_despachada ?? $this->cantidad_aprobada ?? $this->cantidad_solicitada;
    }
}
