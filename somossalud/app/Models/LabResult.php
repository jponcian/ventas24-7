<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class LabResult extends Model
{
    protected $table = 'lab_results';
    protected $fillable = ['lab_order_detail_id', 'lab_exam_item_id', 'value', 'observation'];

    public function orderDetail()
    {
        return $this->belongsTo(LabOrderDetail::class, 'lab_order_detail_id');
    }

    public function examItem()
    {
        return $this->belongsTo(LabExamItem::class, 'lab_exam_item_id');
    }
}
?>
