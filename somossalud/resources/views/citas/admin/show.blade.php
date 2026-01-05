@extends('layouts.adminlte')

@section('title', 'Detalle de cita | SomosSalud')

{{-- Breadcrumb removido para vista show de cita --}}

@section('content')
<style>
/* Diseño personalizado para la gestión (Premium) */
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
<div class="card shadow-sm mb-4">
    <div class="card-body">
        <div class="row g-3">
            <div class="col-md-3">
                <div class="text-muted small">Fecha y hora</div>
                @php($f = \Illuminate\Support\Carbon::parse($cita->fecha))
                <div class="fw-semibold">{{ $f->format('d/m/Y') }} {{ str_replace(' ', '', $f->format('h:i a')) }}</div>
            </div>
            <div class="col-md-3">
                <div class="text-muted small">Estado</div>
                <span class="badge badge-secondary">{{ ucfirst($cita->estado) }}</span>
            </div>
            <div class="col-md-3">
                <div class="text-muted small">Clínica</div>
                <div class="fw-medium">{{ optional($cita->clinica)->nombre ?? '—' }}</div>
            </div>
            <div class="col-md-3">
                <div class="text-muted small">Especialista</div>
                <div class="fw-medium">{{ optional($cita->especialista)->name ?? '—' }}</div>
            </div>
        </div>
        <div class="mt-3 d-flex justify-content-between">
            <a href="{{ route('citas.index') }}" class="btn btn-outline-secondary btn-sm"><i
                    class="fas fa-arrow-left mr-1"></i> Volver</a>
            <form action="{{ route('citas.cancelar', $cita) }}" method="POST" class="form-cancelar-cita">
                @csrf
                <button class="btn btn-outline-danger btn-sm" @disabled($cita->estado === 'cancelada' || $cita->estado === 'concluida') title="Cancelar"><i class="fas fa-ban"></i></button>
            </form>
        </div>
    </div>
</div>

@php($yo = auth()->user())
@if(($yo->id === $cita->especialista_id) || $yo->hasRole(['super-admin', 'admin_clinica']))
<div class="card atencion-form-card shadow-sm mb-4" id="gestion">
    <div class="atencion-header-bar d-flex align-items-center justify-content-between">
        <div><i class="fas fa-stethoscope mr-2"></i> Gestión de la consulta</div>
    </div>
    <div class="atencion-form-section">
        @if(session('success'))
            <div class="alert alert-success small py-2 mb-3">{{ session('success') }}</div>
        @endif
        {{-- Historial movido al final y con tipografía mayor --}}

        <!-- Modal Detalle Historial -->
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
                                <div class="col-md-4">
                                    <div class="text-muted">Fecha</div>
                                    <div id="h-fecha" class="fw-semibold">—</div>
                                </div>
                                <div class="col-md-4">
                                    <div class="text-muted">Profesional</div>
                                    <div id="h-especialista" class="fw-semibold">—</div>
                                </div>
                                <div class="col-md-4">
                                    <div class="text-muted">Origen</div>
                                    <div id="h-tipo" class="fw-semibold">—</div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <div class="text-muted">Diagnóstico</div>
                                <div id="h-diagnostico" class="border rounded p-2 bg-light"
                                    style="white-space:pre-wrap">—</div>
                            </div>
                            <div class="mb-3">
                                <div class="text-muted">Observaciones</div>
                                <div id="h-observaciones" class="border rounded p-2 bg-light"
                                    style="white-space:pre-wrap">—</div>
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
                (function () {
                    const data = @json($historial);
                    function fmtFecha(s) { try { return new Date(s.date ?? s).toLocaleDateString('es-VE'); } catch (e) { return s; } }
                    function renderMed(m) {
                        const pres = m.presentacion ? ` <span class="text-muted">— ${m.presentacion}</span>` : '';
                        const pos = m.posologia ? `<div class="small"><strong>Posología:</strong> ${m.posologia}</div>` : '';
                        const fre = m.frecuencia ? `<div class="small"><strong>Frecuencia:</strong> ${m.frecuencia}</div>` : '';
                        const dur = m.duracion ? `<div class="small"><strong>Duración:</strong> ${m.duracion}</div>` : '';
                        return `<div class="list-group-item py-2">
                                    <div class="fw-semibold">${m.nombre || ''}${pres}</div>
                                    ${pos}${fre}${dur}
                                </div>`;
                    }
                    document.querySelectorAll('.btn-ver-historial').forEach(btn => {
                        btn.addEventListener('click', function () {
                            const i = parseInt(this.dataset.index, 10);
                            const h = data[i];
                            if (!h) return;
                            document.getElementById('h-fecha').textContent = fmtFecha(h.momento);
                            document.getElementById('h-especialista').textContent = h.especialista || '—';
                            document.getElementById('h-tipo').textContent = h.tipo === 'cita' ? 'Cita' : 'Atención';
                            document.getElementById('h-diagnostico').textContent = h.diagnostico || '—';
                            document.getElementById('h-observaciones').textContent = h.observaciones || '—';
                            const list = document.getElementById('h-meds-list');
                            list.innerHTML = '';
                            const meds = (h.meds_list || []);
                            document.getElementById('h-meds-count').textContent = meds.length;
                            meds.forEach(m => { list.insertAdjacentHTML('beforeend', renderMed(m)); });
                            // Mostrar modal (Bootstrap 4 AdminLTE)
                            $('#modalHistorial').modal('show');
                        });
                    });
                })();
            </script>
        @endpush
        @if(in_array($cita->estado, ['concluida']))
            <div class="alert alert-info small mb-3"><i class="fa fa-lock me-1"></i> La cita está concluida. Los datos se
                muestran en modo solo lectura.</div>
        @elseif(in_array($cita->estado, ['cancelada']))
            <div class="alert alert-warning small mb-3"><i class="fa fa-ban me-1"></i> La cita fue cancelada. No se puede
                gestionar.</div>
        @endif
        <h5 class="mb-3"><i class="fas fa-notes-medical text-primary mr-1"></i> Datos clínicos</h5>
        <div class="gradient-divider"></div>

        <form action="{{ route('citas.gestion', $cita) }}" method="POST" enctype="multipart/form-data" class="small" id="form-gestion-cita">
            @csrf
            <div class="mb-3">
                <label class="form-label fw-semibold">Diagnóstico *</label>
                <textarea name="diagnostico" class="form-control form-control-sm" rows="2" required
                    @disabled(in_array($cita->estado, ['cancelada', 'concluida']))>{{ old('diagnostico', $cita->diagnostico) }}</textarea>
                @error('diagnostico')<div class="text-danger small">{{ $message }}</div>@enderror
            </div>
            {{-- Campo de tratamiento eliminado: el tratamiento se expresa con el detalle de medicamentos --}}
            <div class="mb-3">
                <label class="form-label fw-semibold d-flex align-items-center gap-2">Medicamentos estructurados <span
                        class="badge badge-light">Máx 10</span></label>
                <div id="medicamentos-wrapper" class="d-grid gap-3"
                    @class(['opacity-50' => in_array($cita->estado, ['cancelada', 'concluida'])])>
                    @php($oldMeds = old('medicamentos', $cita->medicamentos->map(fn($m) => [
                                                'nombre_generico' => $m->nombre_generico,
                                                'presentacion' => $m->presentacion,
                                                'posologia' => $m->posologia,
                                                'frecuencia' => $m->frecuencia,
                                                'duracion' => $m->duracion,
                                            ])->toArray()))
                                            @forelse($oldMeds as $idx => $med)
                                                <div class="border rounded p-2 bg-light medicamento-item">
                                                    <div class="row g-2">
                                                        <div class="col-md-4">
                                                            <input type="text" name="medicamentos[{{ $idx }}][nombre_generico]"
                                                                class="form-control form-control-sm"
                                                                placeholder="Medicamento (nombre + presentación)"
                                                                value="{{ trim(($med['nombre_generico'] ?? '') . ' ' . ($med['presentacion'] ?? '')) }}"
                                                                @disabled(in_array($cita->estado, ['cancelada', 'concluida']))>
                                                            <small class="form-text text-muted">Ej.: Ibuprofeno 800 mg</small>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <input type="text" name="medicamentos[{{ $idx }}][posologia]"
                                                                class="form-control form-control-sm" placeholder="Posología"
                                                                value="{{ $med['posologia'] ?? '' }}"
                                                                @disabled(in_array($cita->estado, ['cancelada', 'concluida']))>
                                                            <small class="form-text text-muted">Ej.: Tomar 1 pastilla</small>
                                                        </div>
                                                        <div class="col-md-2">
                                                            <input type="text" name="medicamentos[{{ $idx }}][frecuencia]"
                                                                class="form-control form-control-sm" placeholder="Frecuencia"
                                                                value="{{ $med['frecuencia'] ?? '' }}"
                                                                @disabled(in_array($cita->estado, ['cancelada', 'concluida']))>
                                                            <small class="form-text text-muted">Ej.: Cada 8 horas</small>
                                                        </div>
                                                        <div class="col-md-2">
                                                            <input type="text" name="medicamentos[{{ $idx }}][duracion]"
                                                                class="form-control form-control-sm" placeholder="Duración"
                                                                value="{{ $med['duracion'] ?? '' }}"
                                                                @disabled(in_array($cita->estado, ['cancelada', 'concluida']))>
                                                            <small class="form-text text-muted">Ej.: 5 días</small>
                                                        </div>
                                                        <div class="col-md-1 d-flex align-items-start justify-content-center pt-1">
                                                            <button type="button" class="btn btn-outline-danger btn-sm btn-close-custom" aria-label="Eliminar" title="Eliminar">
                                                                <i class="fas fa-times"></i>
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            @empty
                                            @endforelse
                                        </div>
                                        <div class="mt-2">
                                            @if(!in_array($cita->estado, ['cancelada', 'concluida']))
                                                <button type="button" class="btn btn-outline-primary btn-sm" id="btn-add-med"><i
                                                        class="fas fa-plus mr-1"></i> Añadir medicamento</button>
                                            @endif
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">Observaciones</label>
                                        <textarea name="observaciones" class="form-control form-control-sm" rows="2"
                                            @disabled(in_array($cita->estado, ['cancelada', 'concluida']))>{{ old('observaciones', $cita->observaciones) }}</textarea>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">Adjuntos (imágenes / PDF)</label>
                                        <input type="file" name="adjuntos[]" class="form-control form-control-sm"
                                            accept="image/*,application/pdf" multiple
                                            @disabled(in_array($cita->estado, ['cancelada', 'concluida']))>
                                        <div class="form-text">Máx 6 archivos, 5MB c/u.</div>
                                    </div>
                                    @if($cita->adjuntos()->exists())
                                        <div class="mb-3">
                                            <div class="text-muted small mb-1">Archivos existentes</div>
                                            <div class="d-flex flex-wrap gap-2">
                                                @foreach($cita->adjuntos as $adj)
                                                    <a href="{{ Storage::disk('public')->url($adj->ruta) }}" target="_blank"
                                                        class="badge badge-light text-decoration-none">{{ $adj->nombre_original ?? basename($adj->ruta) }}</a>
                                                @endforeach
                                            </div>
                                        </div>
                                    @endif
                                    <div class="d-flex align-items-center p-3 mb-3 bg-white rounded shadow-sm border" style="border-left: 5px solid #10b981 !important;">
                                        <div class="flex-grow-1">
                                            <h6 class="mb-1 fw-bold text-dark" style="font-size: 1rem;"><i class="fas fa-check-circle text-success me-2"></i>Concluir Consulta y Generar Récipe</h6>
                                            <div class="small text-muted" style="line-height: 1.2;">Activa esta opción para finalizar la atención médica.</div>
                                        </div>
                                        <div class="form-check form-switch ms-3">
                                            <input class="form-check-input" type="checkbox" role="switch" id="concluirSwitch" name="concluir" value="1"
                                                @checked($cita->estado === 'concluida')
                                                @disabled(in_array($cita->estado, ['cancelada', 'concluida'])) 
                                                style="transform: scale(1.4); margin-left: -2.5em; cursor: pointer;">
                                        </div>
                                    </div>
                                    <div class="d-flex justify-content-end gap-2 mt-3">
                                        @if(!in_array($cita->estado, ['cancelada', 'concluida']))
                                            <button class="btn btn-primary btn-sm"><i class="fas fa-save mr-1"></i> Guardar gestión</button>
                                        @endif
                                        @if($cita->medicamentos()->exists())
                                            <a href="{{ route('citas.receta', $cita) }}" class="btn btn-outline-primary btn-sm"><i
                                                    class="fas fa-prescription-bottle-alt mr-1"></i> Ver receta</a>
                                        @endif
                                    </div>
                                </form>
                            </div>
                        </div>
                    @else
@if($cita->medicamentos()->exists())
    <div class="mt-4">
        <a href="{{ route('citas.receta', $cita) }}" class="btn btn-outline-primary btn-sm"><i
                class="fas fa-prescription-bottle-alt mr-1"></i> Ver receta</a>
    </div>
@endif
@endif
@if(isset($historial) && $historial->count())
<div class="card collapsed-card mt-4" id="historial-final">
    <div class="card-header p-2 d-flex align-items-center">
        <h3 class="card-title h6 mb-0">Historial clínico del paciente <span
                class="badge badge-info ml-1">{{ $historial->count() }}</span></h3>
        <div class="card-tools ml-auto">
            <button type="button" class="btn btn-tool" data-card-widget="collapse" title="Mostrar/ocultar"><i
                    class="fas fa-plus"></i></button>
        </div>
    </div>
    <div class="card-body p-0" style="display:none;">
        <div class="table-responsive">
            <table class="table table-hover mb-0" id="tabla-historial">
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
                                <span class="d-inline-block text-truncate" style="max-width:410px"
                                    title="{{ $h['diagnostico'] }}">{{ $h['diagnostico'] }}</span>
                            @else
                                <span class="text-muted">—</span>
                            @endif
                        </td>
                        <td class="text-right">
                            <button type="button" class="btn btn-outline-secondary btn-sm btn-ver-historial"
                                data-index="{{ $i }}"><i class="fas fa-eye mr-1"></i> Ver</button>
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
    </div>
</div>
<!-- Modal (reutilizado) -->
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
                <div class="row mb-3" style="font-size:.85rem;">
                    <div class="col-md-4 mb-2">
                        <div class="text-muted text-uppercase small">Fecha</div>
                        <div id="h-fecha" class="font-weight-semibold">—</div>
                    </div>
                    <div class="col-md-4 mb-2">
                        <div class="text-muted text-uppercase small">Profesional</div>
                        <div id="h-especialista" class="font-weight-semibold">—</div>
                    </div>
                    <div class="col-md-4 mb-2">
                        <div class="text-muted text-uppercase small">Origen</div>
                        <div id="h-tipo" class="font-weight-semibold">—</div>
                    </div>
                </div>
                <div class="mb-3" style="font-size:.85rem;">
                    <div class="text-muted text-uppercase small">Diagnóstico</div>
                    <div id="h-diagnostico" class="border rounded p-2 bg-light"
                        style="white-space:pre-wrap;min-height:42px">—</div>
                </div>
                <div class="mb-3" style="font-size:.85rem;">
                    <div class="text-muted text-uppercase small">Observaciones</div>
                    <div id="h-observaciones" class="border rounded p-2 bg-light"
                        style="white-space:pre-wrap;min-height:42px">—</div>
                </div>
                <div style="font-size:.85rem;">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-muted text-uppercase small">Medicamentos</span>
                        <span class="badge badge-info" id="h-meds-count">0</span>
                    </div>
                    <div id="h-meds-list" class="list-group"></div>
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
        (function () {
            const data = @json($historial);
            function fmtFecha(s) { try { return new Date(s.date ?? s).toLocaleDateString('es-VE'); } catch (e) { return s; } }
            function renderMed(m) {
                const pres = m.presentacion ? ` <span class="text-muted">— ${m.presentacion}</span>` : '';
                const pos = m.posologia ? `<div class="small"><strong>Posología:</strong> ${m.posologia}</div>` : '';
                const fre = m.frecuencia ? `<div class="small"><strong>Frecuencia:</strong> ${m.frecuencia}</div>` : '';
                const dur = m.duracion ? `<div class="small"><strong>Duración:</strong> ${m.duracion}</div>` : '';
                return `<div class="list-group-item py-2">
                        <div class="font-weight-semibold">${m.nombre || ''}${pres}</div>
                        ${pos}${fre}${dur}
                    </div>`;
            }
            document.querySelectorAll('#tabla-historial .btn-ver-historial').forEach(btn => {
                btn.addEventListener('click', function () {
                    const i = parseInt(this.dataset.index, 10);
                    const h = data[i];
                    if (!h) return;
                    document.getElementById('h-fecha').textContent = fmtFecha(h.momento);
                    document.getElementById('h-especialista').textContent = h.especialista || '—';
                    document.getElementById('h-tipo').textContent = h.tipo === 'cita' ? 'Cita' : 'Atención';
                    document.getElementById('h-diagnostico').textContent = h.diagnostico || '—';
                    document.getElementById('h-observaciones').textContent = h.observaciones || '—';
                    const list = document.getElementById('h-meds-list');
                    list.innerHTML = '';
                    const meds = Array.isArray(h.meds_list) ? h.meds_list : [];
                    if (!Array.isArray(h.meds_list)) { console.warn('Registro historial sin meds_list esperado:', h); }
                    document.getElementById('h-meds-count').textContent = meds.length;
                    meds.forEach(m => { list.insertAdjacentHTML('beforeend', renderMed(m)); });
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
        (function () {
            const wrapper = document.getElementById('medicamentos-wrapper');
            if (!wrapper) return;
            const btnAdd = document.getElementById('btn-add-med');
            function count() { return wrapper.querySelectorAll('.medicamento-item').length; }
            if (btnAdd) {
                btnAdd.addEventListener('click', () => {
                    if (count() >= 10) return alert('Máximo 10 medicamentos');
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
                            <button type="button" class="btn btn-outline-danger btn-sm btn-close-custom" aria-label="Eliminar" title="Eliminar">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                    </div>`;
                    wrapper.appendChild(div);
                });
            }
            wrapper.addEventListener('click', e => {
                const btn = e.target.closest('.btn-close-custom');
                if (btn) {
                    btn.closest('.medicamento-item').remove();
                }
            });
        })();

        // SweetAlert2: Confirmaciones para cancelar y concluir cita (admin)
        (function () {
            function ensureSwal(cb) { if (window.Swal) return cb(); const s = document.createElement('script'); s.src = 'https://cdn.jsdelivr.net/npm/sweetalert2@11'; s.onload = cb; document.head.appendChild(s); }
            const fCancel = document.querySelector('.form-cancelar-cita');
            if (fCancel) {
                fCancel.addEventListener('submit', function (e) {
                    e.preventDefault();
                    ensureSwal(() => {
                        Swal.fire({
                            title: 'Cancelar cita',
                            text: '¿Confirmas que deseas cancelar esta cita?',
                            icon: 'warning',
                            showCancelButton: true,
                            confirmButtonText: 'Sí, cancelar',
                            cancelButtonText: 'Volver',
                            confirmButtonColor: '#d33'
                        }).then(r => { if (r.isConfirmed) this.submit(); });
                    });
                });
            }

            const formGestion = document.getElementById('form-gestion-cita');
            if (formGestion) {
                const chk = formGestion.querySelector('#concluirSwitch');
                formGestion.addEventListener('submit', function (e) {
                    if (formGestion.dataset.confirmed === '1') return; // permit submit if already confirmed
                    e.preventDefault();
                    
                    if (chk && chk.checked) {
                        // Caso: Marcó concluir -> Confirmar cierre irreversible
                        ensureSwal(() => {
                            Swal.fire({
                                title: '¿Concluir Consulta?',
                                text: 'Se cerrará la cita y se generará el récipe final. No podrás editar después.',
                                icon: 'question',
                                showCancelButton: true,
                                confirmButtonText: 'Sí, concluir',
                                cancelButtonText: 'Revisar',
                                confirmButtonColor: '#10b981'
                            }).then(r => { 
                                if (r.isConfirmed) { 
                                    formGestion.dataset.confirmed = '1'; 
                                    formGestion.submit(); 
                                } 
                            });
                        });
                    } else {
                        // Caso: No marcó concluir -> Preguntar qué desea hacer
                        ensureSwal(() => {
                            Swal.fire({
                                title: 'Guardar Gestión',
                                text: 'No has marcado la opción de concluir. ¿Qué deseas hacer?',
                                icon: 'info',
                                showCancelButton: true,
                                showDenyButton: true,
                                confirmButtonText: 'Guardar y Seguir Editando', // Submit sin concluir
                                denyButtonText: 'Concluir y Finalizar',     // Marcar check y submit
                                cancelButtonText: 'Cancelar',
                                confirmButtonColor: '#3b82f6',
                                denyButtonColor: '#10b981' 
                            }).then(r => { 
                                if (r.isConfirmed) {
                                    // Guardar sin concluir
                                    formGestion.dataset.confirmed = '1';
                                    formGestion.submit();
                                } else if (r.isDenied) {
                                    // Marcar check y guardar
                                    chk.checked = true;
                                    formGestion.dataset.confirmed = '1';
                                    formGestion.submit();
                                }
                            });
                        });
                    }
                });
            }
        })();
    </script>
@endpush