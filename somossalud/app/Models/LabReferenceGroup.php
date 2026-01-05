<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class LabReferenceGroup extends Model
{
    protected $table = 'lab_reference_groups';
    
    protected $fillable = [
        'code',
        'description',
        'sex',
        'age_start_day',
        'age_start_month',
        'age_start_year',
        'age_end_day',
        'age_end_month',
        'age_end_year',
        'active'
    ];

    public function ranges()
    {
        return $this->hasMany(LabReferenceRange::class, 'lab_reference_group_id');
    }
}
