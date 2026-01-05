@component('mail::message')
@php($fechaNueva = \Illuminate\Support\Carbon::parse($cita->fecha)->format('d/m/Y H:i'))
# @if($tipo==='cancelada') Cita cancelada @else Cita reprogramada @endif

Hola {{ $cita->usuario->name }},

@if($tipo==='cancelada')
Tu cita programada para **{{ $fechaAnterior ? \Illuminate\Support\Carbon::parse($fechaAnterior)->format('d/m/Y H:i') : $fechaNueva }}** con **{{ optional($cita->especialista)->name ?? '—' }}** ha sido cancelada.

Si necesitas una nueva cita, ingresa al panel y agenda nuevamente.
@else
Tu cita ha sido reprogramada.

**Fecha anterior:** {{ $fechaAnterior ? \Illuminate\Support\Carbon::parse($fechaAnterior)->format('d/m/Y H:i') : '—' }}  
**Nueva fecha:** {{ $fechaNueva }}  
**Especialista:** {{ optional($cita->especialista)->name ?? '—' }}  
**Clínica:** {{ optional($cita->clinica)->nombre ?? '—' }}

Verifica si el nuevo horario te conviene.
@endif

@component('mail::button', ['url' => route('citas.show', $cita)])
Ver detalle de la cita
@endcomponent

Gracias,
{{ config('app.name') }}
@endcomponent
