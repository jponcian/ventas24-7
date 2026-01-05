<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ExchangeRate extends Model
{
    use HasFactory;

    protected $fillable = [
        'date','source','from','to','rate'
    ];

    protected $casts = [
        'date' => 'date',
        'rate' => 'decimal:6'
    ];

    public function scopeLatestRate($query, $from = 'USD', $to = 'VES')
    {
        return $query->where(compact('from','to'))->orderByDesc('date');
    }

    public function scopeLatestEffective($query, $from = 'USD', $to = 'VES')
    {
        $today = date('Y-m-d');
        return $query->where(compact('from','to'))
            ->whereDate('date', '<=', $today)
            ->orderByDesc('date');
    }

    public static function storeIfNotExists(string $date, float $rate, string $source = 'BCV', string $from = 'USD', string $to = 'VES'): bool
    {
        $exists = static::where(compact('date','source','from','to'))->exists();
        if ($exists) return false;
        static::create([
            'date' => $date,
            'source' => $source,
            'from' => $from,
            'to' => $to,
            'rate' => $rate,
        ]);
        return true;
    }
}
