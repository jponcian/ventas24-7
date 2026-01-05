<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class LabOrderDetail extends Model
{
    protected $table = 'lab_order_details';
    protected $fillable = ['lab_order_id','lab_exam_id','price'];

    public function order()
    {
        return $this->belongsTo(LabOrder::class, 'lab_order_id');
    }

    public function exam()
    {
        return $this->belongsTo(LabExam::class, 'lab_exam_id');
    }

    public function results()
    {
        return $this->hasMany(LabResult::class, 'lab_order_detail_id');
    }
}
?>
