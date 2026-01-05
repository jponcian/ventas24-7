<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class LabExam extends Model
{
    protected $table = 'lab_exams';
    
    protected $fillable = [
        'code',
        'lab_category_id',
        'name',
        'abbreviation',
        'price',
        'active'
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'active' => 'boolean'
    ];

    // Relaciones
    public function category()
    {
        return $this->belongsTo(LabCategory::class, 'lab_category_id');
    }

    public function items()
    {
        return $this->hasMany(LabExamItem::class, 'lab_exam_id')->orderBy('order');
    }

    // Scopes
    public function scopeActive($query)
    {
        return $query->where('active', true);
    }
}
