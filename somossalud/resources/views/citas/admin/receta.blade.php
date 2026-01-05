@extends('layouts.adminlte')

@section('title','Receta | SomosSalud')

{{-- Breadcrumb removido para vista receta admin --}}

@section('content')
    <div class="card shadow-sm">
        <div class="card-body">
            <h5 class="mb-3 d-flex align-items-center gap-2"><i class="fas fa-prescription-bottle-alt text-primary mr-2"></i> Tratamiento indicado</h5>
            <div class="mb-3 small text-muted">Fecha de la cita: {{ \Illuminate\Support\Carbon::parse($cita->fecha)->format('d/m/Y') }}</div>
            <div class="mb-3">
                <strong>Especialista:</strong> {{ optional($cita->especialista)->name ?? '—' }}<br>
                <strong>Clínica:</strong> {{ optional($cita->clinica)->nombre ?? '—' }}
            </div>
            <hr>
            <h6 class="fw-semibold">Medicamentos</h6>
            @if($cita->medicamentos->isEmpty())
                <p class="small text-muted">No se registraron medicamentos estructurados.</p>
            @else
                <ul class="list-group mb-3">
                    @foreach($cita->medicamentos as $m)
                        <li class="list-group-item small">
                            <div class="fw-semibold">{{ $m->nombre_generico }} @if($m->presentacion) <span class="text-muted">— {{ $m->presentacion }}</span>@endif</div>
                            @if($m->posologia || $m->frecuencia || $m->duracion)
                                <div class="mt-1 d-flex flex-wrap gap-2">
                                    @if($m->posologia)<span class="badge badge-info">Posología: {{ $m->posologia }}</span>@endif
                                    @if($m->frecuencia)<span class="badge badge-secondary">Frecuencia: {{ $m->frecuencia }}</span>@endif
                                    @if($m->duracion)<span class="badge badge-light">Duración: {{ $m->duracion }}</span>@endif
                                </div>
                            @endif
                        </li>
                    @endforeach
                </ul>
            @endif
            @if($cita->tratamiento)
                <h6 class="fw-semibold">Indicaciones adicionales (legado)</h6>
                <p class="small">{{ $cita->tratamiento }}</p>
            @endif
            @if($cita->observaciones)
                <h6 class="fw-semibold">Observaciones</h6>
                <p class="small">{{ $cita->observaciones }}</p>
            @endif
            <a href="{{ route('citas.index') }}" class="btn btn-outline-secondary btn-sm"><i class="fas fa-arrow-left mr-1"></i> Volver al listado</a>
        </div>
    </div>
@endsection
