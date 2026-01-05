<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">Receta médica</h2>
    </x-slot>
    <style>
        /* Estilos suaves y agradables para la vista de receta */
        .receta-card { background: linear-gradient(180deg, #ffffff 0%, #f7f3ff 100%); border-top: 4px solid #6f42c1; }
        .receta-header { color: #6f42c1; }
        .receta-section .label { color: #6c757d; font-size: .85rem; margin-bottom: .25rem; }
        .receta-box { background: #f8f9fa; border: 1px solid #e9ecef; border-left: 4px solid #6f42c1; border-radius: .5rem; padding: .5rem .75rem; }
        .receta-meds .list-group-item { border: 1px solid #e6ebff; border-left: 4px solid #0d6efd; background: #fff; }
        .receta-meds .list-group-item + .list-group-item { border-top: none; }
        .receta-pill { display: inline-flex; align-items: center; gap: .4rem; font-size: .75rem; color: #6f42c1; background: #efe7ff; border: 1px solid #e0d4ff; border-radius: 999px; padding: .25rem .6rem; }
        @media print {
            .receta-card { box-shadow: none !important; background: #fff !important; border-top-color: #000 !important; }
            header, nav, .btn, .main-footer { display: none !important; }
            .container { max-width: 100% !important; }
        }
    </style>
    <div class="container py-4">
        <h1 class="h5 mb-3 d-flex align-items-center gap-2 receta-header"><i class="fa-solid fa-prescription-bottle-med"></i> Receta de la cita</h1>
        <div class="card shadow-sm mb-4 receta-card">
            <div class="card-body">
                <div class="row small mb-3">
                    <div class="col-md-6">
                        <div class="text-muted">Paciente</div>
                        <div class="fw-semibold">{{ optional($cita->usuario)->name }}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="text-muted">Especialista</div>
                        <div class="fw-semibold">{{ optional($cita->especialista)->name }}</div>
                    </div>
                    <div class="col-md-6 mt-3">
                        <div class="text-muted">Fecha de la cita</div>
                        <div class="fw-medium">{{ \Illuminate\Support\Carbon::parse($cita->fecha)->format('d/m/Y H:i') }}</div>
                    </div>
                    <div class="col-md-6 mt-3">
                        <div class="text-muted">Clínica</div>
                        <div class="fw-medium">{{ optional($cita->clinica)->nombre ?? '—' }}</div>
                    </div>
                </div>

                @if($cita->diagnostico)
                    <div class="mb-3 receta-section">
                        <div class="label">Diagnóstico</div>
                        <div class="receta-box small" style="white-space:pre-wrap">{{ $cita->diagnostico }}</div>
                    </div>
                @endif

                @if($cita->medicamentos->count())
                    <div class="mb-3 receta-section">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <span class="label">Medicamentos prescritos</span>
                            <span class="receta-pill"><i class="fas fa-pills"></i> {{ $cita->medicamentos->count() }}</span>
                        </div>
                        <div class="list-group receta-meds">
                            @foreach($cita->medicamentos as $m)
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

                @if($cita->tratamiento)
                    <div class="mb-3 receta-section">
                        <div class="label">Indicaciones adicionales (legado)</div>
                        <div class="receta-box small" style="white-space:pre-wrap">{{ $cita->tratamiento }}</div>
                    </div>
                @endif
                @if($cita->observaciones)
                    <div class="mb-3 receta-section">
                        <div class="label">Observaciones</div>
                        <div class="receta-box small" style="white-space:pre-wrap">{{ $cita->observaciones }}</div>
                    </div>
                @endif

                <div class="d-flex justify-content-between">
                    <a href="{{ route('citas.index') }}" class="btn btn-outline-secondary btn-sm"><i class="fa-solid fa-arrow-left me-1"></i> Volver al listado</a>
                    @if($cita->medicamentos->count())
                        <button onclick="window.print()" class="btn btn-outline-primary btn-sm"><i class="fa-solid fa-print me-1"></i> Imprimir</button>
                    @endif
                </div>
            </div>
        </div>
    </div>
</x-app-layout>
