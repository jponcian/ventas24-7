@extends('layouts.adminlte')

@section('title','Gestionar atención')

@section('content')
<style>
/* Diseño personalizado para la gestión de atención */
.atencion-form-card { border:0; }
.atencion-header-bar { background:linear-gradient(135deg, #dbeafe 0%, #dcfce7 100%); color:#1e293b; padding:.75rem 1rem; border-radius:.65rem .65rem 0 0; font-size:.95rem; font-weight:600; box-shadow:0 2px 4px rgba(0,0,0,.08); border-bottom: 1px solid #cbd5e1; }
.atencion-header-bar .estado-badge { background:rgba(255,255,255,.15); backdrop-filter:blur(2px); }
.atencion-form-section { background:#f8f9fb; border:1px solid #e2e6ea; border-top:0; border-radius:0 0 .65rem .65rem; padding:1.25rem 1.35rem 1.35rem; position:relative; }
.atencion-form-section:before { content:''; position:absolute; top:0; left:0; width:4px; height:100%; background:#17a2b8; border-radius:0 0 0 .65rem; }
.atencion-form-section h5 { font-weight:600; font-size:1rem; }
.atencion-form-section label.form-label { font-weight:600; font-size:.75rem; letter-spacing:.5px; text-transform:uppercase; color:#495057; }
.medicamento-item { transition:background .2s,border-color .2s; }
.medicamento-item:hover { background:#eef4ff !important; border-color:#c8d9f6 !important; }
.btn-remove-med i { pointer-events:none; }
.atencion-form-section .badge-light { background:#eef4ff; }
.gradient-divider { height:3px; background:linear-gradient(90deg,#6610f2,#17a2b8); border-radius:2px; margin:-.25rem 0 1rem; }
@media (min-width:768px){ .atencion-header-bar { font-size:1rem; } }
</style>
<div class="card atencion-form-card shadow-sm mb-4">
    <div class="atencion-header-bar d-flex align-items-center justify-content-between">
        <div><i class="fas fa-user-md mr-2"></i> Registro de Atención Médica</div>
        <span class="badge estado-badge badge-pill">{{ ucfirst($atencion->estado) }}</span>
    </div>
    <div class="atencion-form-section">
        <h5 class="mb-3"><i class="fas fa-notes-medical text-primary mr-1"></i> Atención #{{ $atencion->id }} <span class="text-muted">| Paciente:</span> {{ optional($atencion->paciente)->name }}</h5>
        <div class="gradient-divider"></div>
    {{-- Historial movido al final y con tipografía mayor --}}
        @php($bloqueada = $atencion->estado === 'cerrado')
        @if($bloqueada)
            <div class="alert alert-warning py-2 small">Esta atención está cerrada. No es posible modificarla.</div>
        @endif
    <form method="POST" action="{{ route('atenciones.gestion.post', $atencion) }}" enctype="multipart/form-data" id="form-gestion-atencion" class="small">
            @csrf
            <div class="mb-3">
                <label class="form-label">Diagnóstico</label>
                <textarea name="diagnostico" class="form-control form-control-sm" rows="2" required {{ $bloqueada ? 'disabled' : '' }}>{{ old('diagnostico', $atencion->diagnostico) }}</textarea>
            </div>
            <div class="mb-3">
                <label class="form-label d-flex align-items-center">Medicamentos <span class="badge badge-light ml-2">Máx 10</span></label>
                <div id="meds-wrapper" class="d-grid gap-3">
                    @php($oldMeds = old('medicamentos', $atencion->medicamentos->map(fn($m)=>[
                        'nombre_generico'=>$m->nombre_generico.
                            ($m->presentacion? ' — '.$m->presentacion:''),
                        'posologia'=>$m->posologia,
                        'frecuencia'=>$m->frecuencia,
                        'duracion'=>$m->duracion,
                    ])->toArray()))
                    @forelse($oldMeds as $idx => $med)
                        <div class="border rounded p-2 bg-light medicamento-item">
                            <div class="row g-2">
                                <div class="col-md-4">
                                    <input type="text" name="medicamentos[{{ $idx }}][nombre_generico]" class="form-control form-control-sm" placeholder="Medicamento (nombre + presentación)" value="{{ $med['nombre_generico'] ?? '' }}" {{ $bloqueada ? 'disabled' : '' }}>
                                        <small class="form-text text-muted">Ej.: Ibuprofeno 800 mg</small>
                                </div>
                                <div class="col-md-3">
                                    <input type="text" name="medicamentos[{{ $idx }}][posologia]" class="form-control form-control-sm" placeholder="Posología" value="{{ $med['posologia'] ?? '' }}" {{ $bloqueada ? 'disabled' : '' }}>
                                        <small class="form-text text-muted">Ej.: Tomar 1 pastilla</small>
                                </div>
                                <div class="col-md-2">
                                    <input type="text" name="medicamentos[{{ $idx }}][frecuencia]" class="form-control form-control-sm" placeholder="Frecuencia" value="{{ $med['frecuencia'] ?? '' }}" {{ $bloqueada ? 'disabled' : '' }}>
                                        <small class="form-text text-muted">Ej.: Cada 8 horas</small>
                                </div>
                                <div class="col-md-2">
                                    <input type="text" name="medicamentos[{{ $idx }}][duracion]" class="form-control form-control-sm" placeholder="Duración" value="{{ $med['duracion'] ?? '' }}" {{ $bloqueada ? 'disabled' : '' }}>
                                        <small class="form-text text-muted">Ej.: 5 días</small>
                                </div>
                                <div class="col-md-1 d-flex align-items-start justify-content-center pt-1">
                                    @unless($bloqueada)
                                        <button type="button" class="btn btn-outline-danger btn-sm btn-remove-med" title="Eliminar" aria-label="Eliminar">
                                            <i class="fas fa-times"></i>
                                        </button>
                                    @endunless
                                </div>
                            </div>
                        </div>
                    @empty
                    @endforelse
                </div>
                <div class="mt-2">
                    @unless($bloqueada)
                        <button type="button" id="btn-add-med" class="btn btn-outline-primary btn-sm"><i class="fas fa-plus mr-1"></i> Añadir medicamento</button>
                    @endunless
                </div>
            </div>
            <div class="mb-3">
                <label class="form-label">Observaciones</label>
                <textarea name="observaciones" class="form-control form-control-sm" rows="2" {{ $bloqueada ? 'disabled' : '' }}>{{ old('observaciones', $atencion->observaciones) }}</textarea>
            </div>
            <div class="mb-3">
                <label class="form-label">Adjuntos (imágenes / PDF)</label>
                <input type="file" name="adjuntos[]" class="form-control form-control-sm" accept="image/*,application/pdf" multiple {{ $bloqueada ? 'disabled' : '' }}>
            </div>
            @if($atencion->adjuntos()->exists())
                <div class="mb-3">
                    <div class="text-muted small mb-1">Adjuntos existentes</div>
                    <div class="d-flex flex-wrap gap-2">
                        @foreach($atencion->adjuntos as $adj)
                            <a href="{{ Storage::disk('public')->url($adj->ruta) }}" target="_blank" class="badge badge-light text-decoration-none">{{ $adj->nombre_original ?? basename($adj->ruta) }}</a>
                        @endforeach
                    </div>
                </div>
            @endif
            <div class="form-check mb-3">
                <input type="checkbox" name="concluir" value="1" id="concluir" class="form-check-input" {{ $bloqueada ? 'disabled' : '' }}>
                <label for="concluir" class="form-check-label small">Concluir atención</label>
            </div>
            <div class="d-flex justify-content-end gap-2 mt-2">
                <a href="{{ route('atenciones.index') }}" class="btn btn-outline-secondary btn-sm"><i class="fas fa-arrow-left mr-1"></i> Volver</a>
                @unless($bloqueada)
                    <button class="btn btn-primary btn-sm" type="submit"><i class="fas fa-save mr-1"></i> Guardar gestión</button>
                @endunless
            </div>
        </form>
    </div>
</div>
@if(isset($historial) && $historial->count())
    <div class="card collapsed-card mt-4" id="historial-final-atencion">
        <div class="card-header p-2 d-flex align-items-center">
            <h3 class="card-title h6 mb-0">Historial clínico del paciente <span class="badge badge-info ml-1">{{ $historial->count() }}</span></h3>
            <div class="card-tools ml-auto">
                <button type="button" class="btn btn-tool" data-card-widget="collapse" title="Mostrar/ocultar"><i class="fas fa-plus"></i></button>
            </div>
        </div>
        <div class="card-body p-0" style="display:none;">
            
            <div class="table-responsive">
                <table class="table table-hover mb-0" id="tabla-historial-atencion">
                    <thead class="thead-light">
                        <tr class="text-uppercase text-muted" style="font-size:.7rem;letter-spacing:.5px;">
                            <th style="width:110px">Fecha</th>
                            <th style="width:160px">Especialista</th>
                            <th>Diagnóstico</th>
                            <th class="text-right" style="width:110px">Acción</th>
                        </tr>
                    </thead>
                    <tbody style="font-size:.85rem;">
                        @foreach($historial as $i => $h)
                            @php($fechaH = \Illuminate\Support\Carbon::parse($h['momento'])->format('d/m/Y'))
                            <tr>
                                <td>{{ $fechaH }}</td>
                                <td>{{ $h['especialista'] ?? '—' }}</td>
                                <td style="max-width:420px">
                                    @if($h['diagnostico'])
                                        <span class="d-inline-block text-truncate" style="max-width:410px" title="{{ $h['diagnostico'] }}">{{ $h['diagnostico'] }}</span>
                                    @else
                                        <span class="text-muted">—</span>
                                    @endif
                                </td>
                                <td class="text-right">
                                    <button type="button" class="btn btn-outline-secondary btn-sm btn-ver-historial" data-index="{{ $i }}"><i class="fas fa-eye mr-1"></i> Ver</button>
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <!-- Modal Detalle Historial (Atención) -->
                    <div class="modal fade" id="modalHistorial" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg modal-dialog-scrollable">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Detalle de la consulta</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <div class="small">
                                        <div class="row g-3 mb-3">
                                            <div class="col-md-4"><div class="text-muted">Fecha</div><div id="h-fecha" class="fw-semibold">—</div></div>
                                            <div class="col-md-4"><div class="text-muted">Profesional</div><div id="h-especialista" class="fw-semibold">—</div></div>
                                            <div class="col-md-4"><div class="text-muted">Origen</div><div id="h-tipo" class="fw-semibold">—</div></div>
                                        </div>
                                        <div class="mb-3">
                                            <div class="text-muted">Diagnóstico</div>
                                            <div id="h-diagnostico" class="border rounded p-2 bg-light" style="white-space:pre-wrap">—</div>
                                        </div>
                                        <div class="mb-3">
                                            <div class="text-muted">Observaciones</div>
                                            <div id="h-observaciones" class="border rounded p-2 bg-light" style="white-space:pre-wrap">—</div>
                                        </div>
                                        <div>
                                            <div class="d-flex align-items-center justify-content-between mb-2">
                                                <span class="text-muted">Medicamentos</span>
                                                <span class="badge badge-info" id="h-meds-count">0</span>
                                            </div>
                                            <div id="h-meds-list" class="list-group"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary btn-sm" data-dismiss="modal">Cerrar</button>
                                </div>
                            </div>
                        </div>
                    </div>

        @push('scripts')
        <script>
        (function(){
            const data = @json($historial);
            function fmtFecha(s){ try { return new Date(s.date ?? s).toLocaleDateString('es-VE'); } catch(e){ return s; } }
            function renderMed(m){
                const pres = m.presentacion ? ` <span class="text-muted">— ${m.presentacion}</span>` : '';
                const pos = m.posologia ? `<div class="small"><strong>Posología:</strong> ${m.posologia}</div>` : '';
                const fre = m.frecuencia ? `<div class="small"><strong>Frecuencia:</strong> ${m.frecuencia}</div>` : '';
                const dur = m.duracion ? `<div class="small"><strong>Duración:</strong> ${m.duracion}</div>` : '';
                return `<div class="list-group-item py-2">
                    <div class="font-weight-semibold">${m.nombre || ''}${pres}</div>
                    ${pos}${fre}${dur}
                </div>`;
            }
            document.querySelectorAll('#tabla-historial-atencion .btn-ver-historial').forEach(btn=>{
                btn.addEventListener('click', function(){
                    const i = parseInt(this.dataset.index,10);
                    const h = data[i];
                    if(!h) return;
                    document.getElementById('h-fecha').textContent = fmtFecha(h.momento);
                    document.getElementById('h-especialista').textContent = h.especialista || '—';
                    document.getElementById('h-tipo').textContent = h.tipo === 'cita' ? 'Cita' : 'Atención';
                    document.getElementById('h-diagnostico').textContent = h.diagnostico || '—';
                    document.getElementById('h-observaciones').textContent = h.observaciones || '—';
                    const list = document.getElementById('h-meds-list');
                    list.innerHTML = '';
                        const meds = Array.isArray(h.meds_list) ? h.meds_list : [];
                        if(!Array.isArray(h.meds_list)) { console.warn('Historial sin meds_list array:', h); }
                    document.getElementById('h-meds-count').textContent = meds.length;
                    meds.forEach(m=>{ list.insertAdjacentHTML('beforeend', renderMed(m)); });
                    $('#modalHistorial').modal('show');
                });
            });
        })();
        </script>
        @endpush
    @endif
@endsection

@push('scripts')
<script>
(function(){
    const wrapper = document.getElementById('meds-wrapper');
    const btn = document.getElementById('btn-add-med');
    if(!wrapper || !btn) return;
    btn.addEventListener('click', () => {
        if(wrapper.querySelectorAll('.medicamento-item').length >= 10) return alert('Máximo 10 medicamentos');
        const idx = Date.now();
        const div = document.createElement('div');
        div.className = 'border rounded p-2 bg-light medicamento-item';
        div.innerHTML = `
            <div class="row g-2">
                <div class="col-md-4">
                    <input type="text" name="medicamentos[${idx}][nombre_generico]" class="form-control form-control-sm" placeholder="Medicamento (nombre + presentación)">
                        <small class="form-text text-muted">Ej.: Ibuprofeno 800 mg</small>
                </div>
                <div class="col-md-3">
                    <input type="text" name="medicamentos[${idx}][posologia]" class="form-control form-control-sm" placeholder="Posología">
                        <small class="form-text text-muted">Ej.: Tomar 1 pastilla</small>
                </div>
                <div class="col-md-2">
                    <input type="text" name="medicamentos[${idx}][frecuencia]" class="form-control form-control-sm" placeholder="Frecuencia">
                        <small class="form-text text-muted">Ej.: Cada 8 horas</small>
                </div>
                <div class="col-md-2">
                    <input type="text" name="medicamentos[${idx}][duracion]" class="form-control form-control-sm" placeholder="Duración">
                        <small class="form-text text-muted">Ej.: 5 días</small>
                </div>
                <div class="col-md-1 d-flex align-items-start justify-content-center pt-1">
                    <button type="button" class="btn btn-outline-danger btn-sm btn-remove-med" title="Eliminar" aria-label="Eliminar">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>`;
        wrapper.appendChild(div);
    });
    wrapper.addEventListener('click', e => {
        const btn = e.target.closest('.btn-remove-med');
        if(btn){
            btn.closest('.medicamento-item').remove();
        }
    });
})();

// Confirmación al concluir la atención (SweetAlert2)
(function(){
    const form = document.getElementById('form-gestion-atencion');
    if(!form) return;
    const chk = form.querySelector('input[name="concluir"]');
    if(!chk) return;
    function ensureSwal(cb){
        if(window.Swal) return cb();
        const s=document.createElement('script');
        s.src='https://cdn.jsdelivr.net/npm/sweetalert2@11';
        s.onload=cb; document.head.appendChild(s);
    }
    form.addEventListener('submit', function(e){
        if(!chk.checked || form.dataset.confirmed==='1') return; // no concluye o ya confirmado
        e.preventDefault();
        ensureSwal(()=>{
            Swal.fire({
                title: 'Concluir atención',
                text: '¿Confirmas que deseas concluir esta atención? Luego no podrás modificarla.',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Sí, concluir',
                cancelButtonText: 'Cancelar',
                confirmButtonColor: '#d33',
            }).then(r=>{
                if(r.isConfirmed){
                    form.dataset.confirmed='1';
                    form.submit();
                }
            });
        });
    });
})();
</script>
@endpush
