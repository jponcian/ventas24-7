@component('mail::message')
# Cita agendada

Hola {{ $cita->usuario->name }},

Tu cita ha sido registrada correctamente.

**Fecha y hora:** {{ \Illuminate\Support\Carbon::parse($cita->fecha)->format('d/m/Y H:i') }}  
**Especialista:** {{ optional($cita->especialista)->name ?? '—' }}  
**Clínica:** {{ optional($cita->clinica)->nombre ?? '—' }}  
**Estado:** {{ ucfirst($cita->estado) }}

@component('mail::button', ['url' => route('citas.show', $cita)])
Ver detalle de la cita
@endcomponent

Si necesitas reprogramar o cancelar, accede al panel de citas.

Gracias,
{{ config('app.name') }}
@endcomponent
