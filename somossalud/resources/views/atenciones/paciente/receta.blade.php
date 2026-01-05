<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">Receta de la atención</h2>
    </x-slot>
    <style>
        .receta-card { background: linear-gradient(180deg, #ffffff 0%, #eaf7ff 100%); border-top: 4px solid #0d6efd; }
        .receta-header { color: #0d6efd; }
        .receta-section .label { color: #6c757d; font-size: .85rem; margin-bottom: .25rem; }
        .receta-box { background: #f8f9fa; border: 1px solid #e9ecef; border-left: 4px solid #0d6efd; border-radius: .5rem; padding: .5rem .75rem; }
        .receta-meds .list-group-item { border: 1px solid #cfe2ff; border-left: 4px solid #0d6efd; background: #fff; }
        .receta-meds .list-group-item + .list-group-item { border-top: none; }
        .receta-pill { display: inline-flex; align-items: center; gap: .4rem; font-size: .75rem; color: #0d6efd; background: #e7f1ff; border: 1px solid #cfe2ff; border-radius: 999px; padding: .25rem .6rem; }
        @media print {
            .receta-card { box-shadow: none !important; background: #fff !important; border-top-color: #000 !important; }
            header, nav, .btn, .main-footer { display: none !important; }
            .container { max-width: 100% !important; }
        }
    </style>
    <div class="container py-4">
        <h1 class="h5 mb-3 d-flex align-items-center gap-2 receta-header"><i class="fa-solid fa-prescription-bottle-med"></i> Receta de la atención</h1>
        <div class="card shadow-sm mb-4 receta-card">
            <div class="card-body">
                <div class="row small mb-3">
                    <div class="col-md-6">
                        <div class="text-muted">Paciente</div>
                        <div class="fw-semibold">{{ optional(auth()->user())->name }}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="text-muted">Médico</div>
                        <div class="fw-semibold">{{ optional($atencion->medico)->name }}</div>
                    </div>
                    <div class="col-md-6 mt-3">
                        <div class="text-muted">Fecha de atención</div>
                        <div class="fw-medium">{{ ($atencion->iniciada_at ?? $atencion->created_at)->format('d/m/Y H:i') }}</div>
                    </div>
                    <div class="col-md-6 mt-3">
                        <div class="text-muted">Clínica</div>
                        <div class="fw-medium">{{ optional($atencion->clinica)->nombre ?? '—' }}</div>
                    </div>
                </div>

                @if($atencion->diagnostico)
                    <div class="mb-3 receta-section">
                        <div class="label">Diagnóstico</div>
                        <div class="receta-box small" style="white-space:pre-wrap">{{ $atencion->diagnostico }}</div>
                    </div>
                @endif

                @if($atencion->medicamentos->count())
                    <div class="mb-3 receta-section">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <span class="label">Medicamentos indicados</span>
                            <span class="receta-pill"><i class="fas fa-pills"></i> {{ $atencion->medicamentos->count() }}</span>
                        </div>
                        <div class="list-group receta-meds">
                            @foreach($atencion->medicamentos as $m)
                                <div class="list-group-item py-2">
                                    <div class="fw-semibold">Medicamento {{ $loop->iteration }}: {{ $m->nombre_generico }} @if($m->presentacion) <span class="text-muted">— {{ $m->presentacion }}</span>@endif</div>
                                    @if($m->posologia)
                                        <div class="small"><strong>Posología:</strong> {{ $m->posologia }}</div>
                                    @endif
                                    @if($m->frecuencia)
                                        <div class="small"><strong>Frecuencia:</strong> {{ $m->frecuencia }}</div>
                                    @endif
                                    @if($m->duracion)
                                        <div class="small"><strong>Duración:</strong> {{ $m->duracion }}</div>
                                    @endif
                                </div>
                            @endforeach
                        </div>
                    </div>
                @endif

                @if($atencion->observaciones)
                    <div class="mb-3 receta-section">
                        <div class="label">Observaciones</div>
                        <div class="receta-box small" style="white-space:pre-wrap">{{ $atencion->observaciones }}</div>
                    </div>
                @endif

                <div class="d-flex justify-content-between">
                    <a href="{{ route('citas.index') }}" class="btn btn-outline-secondary btn-sm"><i class="fa-solid fa-arrow-left me-1"></i> Volver al listado</a>
                    @if($atencion->medicamentos->count())
                        <button onclick="window.print()" class="btn btn-outline-primary btn-sm"><i class="fa-solid fa-print me-1"></i> Imprimir</button>
                    @endif
                </div>
            </div>
        </div>
    </div>
</x-app-layout>
