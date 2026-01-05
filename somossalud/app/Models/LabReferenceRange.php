<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class LabReferenceRange extends Model
{
    protected $table = 'lab_reference_ranges';
    
    protected $fillable = [
        'lab_exam_item_id',
        'lab_reference_group_id',
        'condition',
        'value_min',
        'value_max',
        'value_text',
        'order'
    ];

    public function item()
    {
        return $this->belongsTo(LabExamItem::class, 'lab_exam_item_id');
    }

    public function group()
    {
        return $this->belongsTo(LabReferenceGroup::class, 'lab_reference_group_id');
    }
}
