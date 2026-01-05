<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class SolicitudInventario extends Model
{
    protected $table = 'solicitudes_inventario';
    
    protected $fillable = [
        'numero_solicitud',
        'solicitante_id',
        'clinica_id',
        'categoria',
        'estado',
        'observaciones_solicitante',
        'observaciones_aprobador',
        'aprobado_por',
        'fecha_aprobacion',
        'despachado_por',
        'fecha_despacho'
    ];
    
    protected $casts = [
        'fecha_aprobacion' => 'datetime',
        'fecha_despacho' => 'datetime'
    ];
    
    // Boot para generar número de solicitud automáticamente
    protected static function boot()
    {
        parent::boot();
        
        static::creating(function ($solicitud) {
            if (empty($solicitud->numero_solicitud)) {
                $year = date('Y');
                $ultimo = static::whereYear('created_at', $year)
                    ->orderBy('id', 'desc')
                    ->first();
                
                $numero = $ultimo ? intval(substr($ultimo->numero_solicitud, -4)) + 1 : 1;
                $solicitud->numero_solicitud = 'SOL-' . $year . '-' . str_pad($numero, 4, '0', STR_PAD_LEFT);
            }
        });
    }
    
    // Relaciones
    public function solicitante(): BelongsTo
    {
        return $this->belongsTo(User::class, 'solicitante_id');
    }
    
    public function clinica(): BelongsTo
    {
        return $this->belongsTo(Clinica::class);
    }
    
    public function aprobadoPor(): BelongsTo
    {
        return $this->belongsTo(User::class, 'aprobado_por');
    }
    
    public function despachadoPor(): BelongsTo
    {
        return $this->belongsTo(User::class, 'despachado_por');
    }
    
    public function items(): HasMany
    {
        return $this->hasMany(ItemSolicitudInventario::class, 'solicitud_id');
    }
    
    // Scopes
    public function scopePendientes($query)
    {
        return $query->where('estado', 'pendiente');
    }
    
    public function scopeAprobadas($query)
    {
        return $query->where('estado', 'aprobada');
    }
    
    public function scopeDespachadas($query)
    {
        return $query->where('estado', 'despachada');
    }
    
    // Métodos auxiliares
    public function isPendiente(): bool
    {
        return $this->estado === 'pendiente';
    }
    
    public function isAprobada(): bool
    {
        return $this->estado === 'aprobada';
    }
    
    public function isDespachada(): bool
    {
        return $this->estado === 'despachada';
    }
    
    public function getTotalItemsAttribute(): int
    {
        return $this->items()->count();
    }
    
    public function getBadgeColorAttribute(): string
    {
        return match($this->estado) {
            'pendiente' => 'warning',
            'aprobada' => 'info',
            'despachada' => 'success',
            'rechazada' => 'danger',
            default => 'secondary'
        };
    }
}
