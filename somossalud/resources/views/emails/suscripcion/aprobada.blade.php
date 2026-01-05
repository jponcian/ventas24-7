@component('mail::message')
# ¡Suscripción aprobada!

Hola {{ $usuario->name }},

Tu suscripción ha sido aprobada y ya está activa.

- Número de afiliación: **{{ $suscripcion->numero ?? '—' }}**
- Plan: **{{ ucfirst($suscripcion->plan) }}**
- Vigencia: **{{ \Illuminate\Support\Carbon::parse($suscripcion->periodo_inicio)->format('d/m/Y') }}** hasta **{{ \Illuminate\Support\Carbon::parse($suscripcion->periodo_vencimiento)->format('d/m/Y') }}**

@component('mail::button', ['url' => route('suscripcion.carnet')])
Ver mi carnet digital
@endcomponent

Si este correo no era para ti, puedes ignorarlo.

Gracias,
{{ config('app.name') }}
@endcomponent