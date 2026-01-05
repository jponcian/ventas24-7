<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class LabOrder extends Model
{
    protected $table = 'lab_orders';

    protected $fillable = [
        'order_number',
        'patient_id',
        'doctor_id',
        'clinica_id',
        'order_date',
        'sample_date',
        'result_date',
        'status',
        'daily_exam_count',
        'total',
        'observations',
        'verification_code',
        'created_by',
        'results_loaded_by'
    ];

    protected $casts = [
        'order_date' => 'date',
        'sample_date' => 'date',
        'result_date' => 'datetime',
        'total' => 'decimal:2'
    ];

    // Relaciones
    public function details()
    {
        return $this->hasMany(LabOrderDetail::class, 'lab_order_id');
    }

    public function patient()
    {
        return $this->belongsTo(User::class, 'patient_id');
    }

    public function doctor()
    {
        return $this->belongsTo(User::class, 'doctor_id');
    }

    public function clinica()
    {
        return $this->belongsTo(Clinica::class, 'clinica_id');
    }

    public function createdBy()
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    public function resultsLoadedBy()
    {
        return $this->belongsTo(User::class, 'results_loaded_by');
    }

    // Scopes
    public function scopePending($query)
    {
        return $query->where('status', 'pending');
    }

    public function scopeInProgress($query)
    {
        return $query->where('status', 'in_progress');
    }

    public function scopeCompleted($query)
    {
        return $query->where('status', 'completed');
    }

    // Métodos auxiliares
    public static function generateOrderNumber()
    {
        $year = date('Y');
        $lastOrder = self::whereYear('created_at', $year)->latest('id')->first();
        $number = $lastOrder ? intval(substr($lastOrder->order_number, -6)) + 1 : 1;
        return 'LAB-' . $year . '-' . str_pad($number, 6, '0', STR_PAD_LEFT);
    }

    public static function generateVerificationCode()
    {
        do {
            $code = strtoupper(Str::random(12));
        } while (self::where('verification_code', $code)->exists());

        return $code;
    }

    public function isPending()
    {
        return $this->status === 'pending';
    }

    public function isInProgress()
    {
        return $this->status === 'in_progress';
    }

    public function isCompleted()
    {
        return $this->status === 'completed';
    }

    public function hasResults()
    {
        return $this->details()->whereHas('results')->exists();
    }
}
