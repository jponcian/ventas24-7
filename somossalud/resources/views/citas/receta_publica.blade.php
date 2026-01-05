<x-guest-layout>
    <style>
        /* Estilos suaves para la vista de receta en móvil/public */
        .receta-header { color: #6f42c1; text-align: center; margin-bottom: 1.5rem; }
        .receta-section .label { color: #6c757d; font-size: .8rem; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: .25rem; font-weight: 600; }
        .receta-box { background: #f8f9fa; border: 1px solid #e9ecef; border-left: 4px solid #6f42c1; border-radius: .5rem; padding: .75rem; margin-bottom: 1rem; }
        .receta-meds .list-group-item { border: 1px solid #e6ebff; border-left: 4px solid #0d6efd; background: #fff; margin-bottom: 0.5rem; border-radius: 0.5rem !important; }
        .receta-pill { display: inline-flex; align-items: center; gap: .4rem; font-size: .75rem; color: #6f42c1; background: #efe7ff; border: 1px solid #e0d4ff; border-radius: 999px; padding: .25rem .6rem; }
        .img-brand { max-width: 80px; margin: 0 auto 1rem; display: block; border-radius: 50%; }
        
        @media print {
            .no-print { display: none !important; }
            body, .card { background: #fff !important; box-shadow: none !important; padding: 0 !important; margin: 0 !important; }
            .receta-box { border: 1px solid #000; }
        }
    </style>

    <div class="text-center mb-4">
        <h2 class="h4 fw-bold text-dark mb-1">Receta Médica Digital</h2>
        <div class="text-muted small">Clínica SaludSonrisa</div>
    </div>

    <div class="small mb-4 pb-3 border-bottom">
        <div class="row g-2">
            <div class="col-6">
                <div class="text-muted text-uppercase" style="font-size: 0.7rem;">Paciente</div>
                <div class="fw-bold">{{ optional($cita->usuario)->name }}</div>
            </div>
            <div class="col-6 text-end">
                <div class="text-muted text-uppercase" style="font-size: 0.7rem;">Fecha</div>
                <div class="fw-bold">{{ \Illuminate\Support\Carbon::parse($cita->fecha)->format('d/m/Y') }}</div>
            </div>
            <div class="col-12 mt-2">
                <div class="text-muted text-uppercase" style="font-size: 0.7rem;">Especialista</div>
                <div class="fw-bold text-primary">{{ optional($cita->especialista)->name }}</div>
                <div class="small text-muted">{{ optional($cita->especialista)->especialidad->nombre ?? 'General' }}</div>
            </div>
        </div>
    </div>

    @if($cita->diagnostico)
        <div class="mb-3">
            <div class="receta-section">
                <div class="label">Diagnóstico</div>
                <div class="receta-box small">{{ $cita->diagnostico }}</div>
            </div>
        </div>
    @endif

    @if($cita->medicamentos->count())
        <div class="mb-3 receta-section">
            <div class="d-flex align-items-center justify-content-between mb-2">
                <div class="label mb-0">Medicamentos</div>
                <span class="receta-pill"><i class="fas fa-pills"></i> {{ $cita->medicamentos->count() }}</span>
            </div>
            <div class="list-group receta-meds list-unstyled">
                @foreach($cita->medicamentos as $m)
                    <div class="list-group-item p-3 shadow-sm mb-3 border-0" style="background-color: #f8fbff; border-left: 6px solid #0ea5e9 !important;">
                        <div class="d-flex align-items-start">
                            <div class="w-100">
                                <div class="fw-bold text-dark mb-1 text-uppercase" style="font-size: 1.4rem; letter-spacing: 0.5px; line-height: 1.2;">
                                    {{ $m->nombre_generico }}
                                </div>
                                @if($m->presentacion) 
                                    <div class="text-secondary fw-semibold mb-3 text-uppercase" style="font-size: 1rem;">
                                        {{ $m->presentacion }}
                                    </div> 
                                @endif
                                
                                <div class="d-flex flex-column gap-2 text-dark p-3 rounded border" style="background-color: #f1f2f4;">
                                    @if($m->posologia) 
                                        <div class="d-flex align-items-center">
                                            <i class="fas fa-check-circle me-2 text-secondary fa-lg"></i> 
                                            <span class="fw-bold me-1">Dosis:</span> {{ $m->posologia }}
                                        </div>
                                    @endif
                                    @if($m->frecuencia)
                                        <div class="d-flex align-items-center">
                                            <i class="fas fa-clock me-2 text-secondary fa-lg"></i> 
                                            <span class="fw-bold me-1">Frecuencia:</span> {{ $m->frecuencia }}
                                        </div>
                                    @endif
                                    @if($m->duracion)
                                        <div class="d-flex align-items-center">
                                            <i class="fas fa-calendar-day me-2 text-secondary fa-lg"></i> 
                                            <span class="fw-bold me-1">Duración:</span> {{ $m->duracion }}
                                        </div>
                                    @endif
                                </div>
                            </div>
                        </div>
                    </div>
                @endforeach
            </div>
        </div>
    @endif

    @if($cita->observaciones)
        <div class="mb-4">
            <div class="receta-section">
                <div class="label">Indicaciones / Observaciones</div>
                <div class="receta-box small" style="white-space:pre-wrap">{{ $cita->observaciones }}</div>
            </div>
        </div>
    @endif

    <div class="mt-4 pt-3 border-top text-center no-print">
        <button onclick="window.print()" class="btn btn-primary w-100 mb-3">
            <i class="fas fa-print me-2"></i> Descargar / Imprimir
        </button>
        <div class="small text-muted">Documento generado digitalmente por SomosSalud.</div>
    </div>
</x-guest-layout>
