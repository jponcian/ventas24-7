<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class LabCategory extends Model
{
    protected $table = 'lab_categories';
    
    protected $fillable = ['code', 'name', 'active'];

    protected $casts = [
        'active' => 'boolean'
    ];

    // Relaciones
    public function exams()
    {
        return $this->hasMany(LabExam::class, 'lab_category_id');
    }

    // Scopes
    public function scopeActive($query)
    {
        return $query->where('active', true);
    }
}
