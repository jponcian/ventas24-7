<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use App\Models\Especialidad;
use App\Models\Disponibilidad;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Spatie\Permission\Traits\HasRoles;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    protected $table = 'usuarios';

    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable, HasRoles, HasApiTokens;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'telefono',
        'firma',
        'password',
        'clinica_id',
        'cedula',
        'fecha_nacimiento',
        'sexo',
        'especialidad_id',
        'representante_id',
        'mpps',
        'colegio_bioanalista',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    /**
     * Boot del modelo para establecer valores por defecto
     */
    protected static function boot()
    {
        parent::boot();
        
        // Asignar clinica_id = 1 por defecto a nuevos usuarios
        static::creating(function ($user) {
            if (empty($user->clinica_id)) {
                $user->clinica_id = 1;
            }
        });
    }

    public function clinica()
    {
        return $this->belongsTo(Clinica::class);
    }

    // Relación individual (legacy)
    public function especialidad()
    {
        return $this->belongsTo(Especialidad::class, 'especialidad_id');
    }

    // Relación muchos a muchos (nuevo)
    public function especialidades()
    {
        return $this->belongsToMany(Especialidad::class, 'especialidad_usuario', 'usuario_id', 'especialidad_id')->withTimestamps();
    }

    public function disponibilidades()
    {
        return $this->hasMany(Disponibilidad::class, 'especialista_id');
    }

    // Relación con el representante (padre/madre)
    public function representante()
    {
        return $this->belongsTo(User::class, 'representante_id');
    }

    // Relación con los dependientes (hijos)
    public function dependientes()
    {
        return $this->hasMany(User::class, 'representante_id');
    }

    // Accesores para nombres en español (lectura)
    public function getNombreAttribute()
    {
        return $this->attributes['name'] ?? null;
    }

    public function getCorreoAttribute()
    {
        return $this->attributes['email'] ?? null;
    }

    /**
     * Calcular la edad del usuario a partir de su fecha de nacimiento
     *
     * @return int|null
     */
    public function getEdadAttribute()
    {
        if (!empty($this->attributes['fecha_nacimiento'])) {
            return \Carbon\Carbon::parse($this->attributes['fecha_nacimiento'])->age;
        }
        return null;
    }

    /**
     * Send the password reset notification.
     *
     * @param  string  $token
     * @return void
     */
    public function sendPasswordResetNotification($token)
    {
        $this->notify(new \App\Notifications\ResetPasswordNotification($token));
    }

    /**
     * Route notifications for the WhatsApp channel.
     *
     * @return string
     */
    public function routeNotificationForWhatsapp()
    {
        return \App\Channels\WhatsAppChannel::class;
    }
}
