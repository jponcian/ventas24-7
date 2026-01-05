@extends('layouts.adminlte')
@section('title','Detalle atención')
@section('content')
<div class="container-fluid py-3">
    <h1 class="h5 mb-3">Atención #{{ $atencion->id }}</h1>
    <div class="card mb-3 shadow-sm">
        <div class="card-body small">
            <div class="row g-3">
                <div class="col-md-3">
                    <div class="text-muted">Estado</div>
                    @php $label = match($atencion->estado){ 'validado'=>'Validada','en_consulta'=>'En proceso','cerrado'=>'Cerrada', default=> ucfirst($atencion->estado)}; $badge = match($atencion->estado){ 'validado'=>'info','en_consulta'=>'warning','cerrado'=>'success', default=>'secondary'}; @endphp
                    <span class="badge text-bg-{{ $badge }}">{{ $label }}</span>
                </div>
                <div class="col-md-3">
                    <div class="text-muted">Médico</div>
                    <div>{{ optional($atencion->medico)->name ?? '—' }}</div>
                </div>
                <div class="col-md-3">
                    <div class="text-muted">Aseguradora</div>
                    <div>{{ $atencion->aseguradora ?? '—' }} @if($atencion->numero_seguro) <span class="text-muted">• {{ $atencion->numero_seguro }}</span> @endif</div>
                </div>
                <div class="col-md-3">
                    <div class="text-muted">Fecha inicial</div>
                    <div>{{ ($atencion->iniciada_at ?? $atencion->created_at)->format('d/m/Y H:i') }}</div>
                </div>
            </div>
        </div>
    </div>

    <div class="card mb-3 shadow-sm">
        <div class="card-header py-2"><strong class="small">Diagnóstico y observaciones</strong></div>
        <div class="card-body small">
            @if($atencion->diagnostico)
                <p><strong>Diagnóstico:</strong> {{ $atencion->diagnostico }}</p>
            @else
                <p class="text-muted mb-0">Aún no hay diagnóstico registrado.</p>
            @endif
            @if($atencion->observaciones)
                <p class="mb-0"><strong>Observaciones:</strong> {{ $atencion->observaciones }}</p>
            @endif
        </div>
    </div>

    <div class="card mb-3 shadow-sm">
        <div class="card-header py-2"><strong class="small">Medicamentos indicados</strong></div>
        <div class="card-body small">
            @forelse($atencion->medicamentos->sortBy('orden') as $m)
                <div class="border rounded p-2 mb-2">
                    <div class="fw-semibold">{{ $m->nombre_generico }} @if($m->presentacion)<span class="text-muted">— {{ $m->presentacion }}</span>@endif</div>
                    @if($m->posologia)<div class="text-muted"><span class="fw-medium">Posología:</span> {{ $m->posologia }}</div>@endif
                    @if($m->frecuencia)<div class="text-muted"><span class="fw-medium">Frecuencia:</span> {{ $m->frecuencia }}</div>@endif
                    @if($m->duracion)<div class="text-muted"><span class="fw-medium">Duración:</span> {{ $m->duracion }}</div>@endif
                </div>
            @empty
                <p class="text-muted mb-0">No hay medicamentos registrados.</p>
            @endforelse
        </div>
    </div>

    <a href="{{ route('citas.index') }}" class="btn btn-sm btn-outline-secondary"><i class="fa fa-arrow-left me-1"></i> Volver al listado</a>
</div>
@endsection
