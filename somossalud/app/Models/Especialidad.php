<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Especialidad extends Model
{
    use HasFactory;

    protected $table = 'especialidades';

    protected $fillable = [
        'nombre',
        'slug',
        'descripcion',
    ];

    // Relación individual (legacy)
    public function especialistas(): HasMany
    {
        return $this->hasMany(User::class, 'especialidad_id');
    }

    // Relación muchos a muchos (nuevo)
    public function usuarios()
    {
        return $this->belongsToMany(User::class, 'especialidad_usuario', 'especialidad_id', 'usuario_id')->withTimestamps();
    }
}
