@extends('layouts.adminlte')

@section('title','Atenciones | Recepción')

@section('content')
<div class="row">
    <div class="col-md-5">
        <div class="card shadow-sm border-0 rounded-lg overflow-hidden h-100">
            <div class="card-header border-0" style="background: linear-gradient(135deg, #dbeafe 0%, #dcfce7 100%); border-bottom: 1px solid #cbd5e1;">
                <h3 class="card-title font-weight-bold text-primary mb-0">
                    <i class="fas fa-plus-circle mr-2"></i> Nueva atención
                </h3>
            </div>
            <div class="card-body">
                <form method="POST" action="{{ route('atenciones.store') }}">
                    @csrf

                    <div class="form-group mt-2">
                        <label class="small font-weight-bold text-uppercase text-muted">Paciente</label>
                        <select name="paciente_id" id="paciente_id" class="form-control form-control-sm select2" required>
                            <option value="">Seleccione paciente...</option>
                            @foreach(App\Models\User::role('paciente')->orderBy('name')->get() as $p)
                                <option value="{{ $p->id }}">{{ $p->name }} ({{ $p->cedula ?? $p->email }})</option>
                            @endforeach
                        </select>
                    </div>

                    <div class="form-group mt-3">
                        <label class="small font-weight-bold text-uppercase text-muted">Empresa donde labora</label>
                        <input type="text" name="empresa" class="form-control form-control-sm bg-light border-0" placeholder="Empresa habitual del paciente">
                    </div>

                    <div class="row mt-3">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="small font-weight-bold text-uppercase text-muted">Aseguradora</label>
                                <input type="text" name="aseguradora" class="form-control form-control-sm bg-light border-0">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="small font-weight-bold text-uppercase text-muted">N° Siniestro</label>
                                <input type="text" name="numero_siniestro" class="form-control form-control-sm bg-light border-0" placeholder="Ej: Siniestro 123">
                            </div>
                        </div>
                    </div>

                    <div class="form-group mt-3">
                        <label class="small font-weight-bold text-uppercase text-muted">Nombre del operador que atendió</label>
                        <input type="text" name="nombre_operador" class="form-control form-control-sm bg-light border-0" placeholder="Nombre del operador">
                    </div>

                    <div class="form-group form-check mt-3">
                        <div class="custom-control custom-switch">
                            <input type="checkbox" class="custom-control-input" id="seguro_validado" name="seguro_validado" value="1" checked>
                            <label class="custom-control-label font-weight-bold text-dark" for="seguro_validado">Seguro validado</label>
                        </div>
                    </div>

                    <div class="mt-4">
                        <button class="btn btn-primary btn-block shadow-sm font-weight-bold" type="submit">
                            <i class="fas fa-save mr-2"></i> Crear atención
                        </button>
                    </div>
                    <script>
                        document.addEventListener('DOMContentLoaded', function() {
                            function toggleTitularFields() {
                                var esTitular = document.querySelector('input[name="es_titular"]:checked').value;
                                document.getElementById('titular_fields').style.display = esTitular == '0' ? 'block' : 'none';
                            }
                            document.querySelectorAll('input[name="es_titular"]').forEach(function(radio) {
                                radio.addEventListener('change', toggleTitularFields);
                            });
                            toggleTitularFields();

                            // Inicializar select2 si está disponible
                            if (window.$ && $.fn.select2) {
                                $('#paciente_id').select2({width:'100%',placeholder:'Seleccione paciente...'});
                                $('#titular_id').select2({width:'100%',placeholder:'Seleccione titular...'});
                            }
                        });
                    </script>
                </form>
            </div>
        </div>
    </div>

    <div class="col-md-7">
        <div class="card shadow-sm border-0 rounded-lg overflow-hidden h-100">
            <div class="card-header border-0 d-flex justify-content-between align-items-center" style="background: linear-gradient(135deg, #dbeafe 0%, #dcfce7 100%); border-bottom: 1px solid #cbd5e1;">
                <h3 class="card-title font-weight-bold text-primary mb-0">
                    <i class="fas fa-list-ul mr-2"></i> Atenciones recientes
                </h3>
                <form method="GET" action="{{ route('atenciones.index') }}" class="form-inline d-flex gap-2 small">
                    @php
                        $mapEstados = [
                            'validado' => ['label'=>'Validada','class'=>'badge-info'],
                            'en_consulta' => ['label'=>'En proceso','class'=>'badge-warning'],
                            'cerrado' => ['label'=>'Cerrada','class'=>'badge-success'],
                        ];
                    @endphp
                    <select name="estado" class="custom-select custom-select-sm border-0 shadow-sm bg-white text-dark font-weight-bold" onchange="this.form.submit()">
                        <option value="">Todos los estados</option>
                        @foreach($mapEstados as $k=>$v)
                            <option value="{{ $k }}" {{ request('estado')===$k?'selected':'' }}>{{ $v['label'] }}</option>
                        @endforeach
                    </select>
                    <input type="number" name="medico_id" value="{{ request('medico_id') }}" class="form-control form-control-sm mr-1 d-none" placeholder="ID médico">
                    <input type="number" name="paciente_id" value="{{ request('paciente_id') }}" class="form-control form-control-sm mr-1 d-none" placeholder="ID paciente">
                </form>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive mb-0">
                    <table class="table table-hover mb-0 align-middle">
                        <thead style="background-color: #f8fafc;">
                            <tr>
                                <th class="border-top-0 text-uppercase text-secondary small font-weight-bold pl-4">ID</th>
                                <th class="border-top-0 text-uppercase text-secondary small font-weight-bold">Paciente</th>
                                <th class="border-top-0 text-uppercase text-secondary small font-weight-bold">Titular</th>
                                <th class="border-top-0 text-uppercase text-secondary small font-weight-bold">Empresa</th>
                                <th class="border-top-0 text-uppercase text-secondary small font-weight-bold">N° Siniestro</th>
                                <th class="border-top-0 text-uppercase text-secondary small font-weight-bold">Operador</th>
                                <th class="border-top-0 text-uppercase text-secondary small font-weight-bold">Seguro</th>
                                <th class="border-top-0 text-uppercase text-secondary small font-weight-bold">Estado</th>
                                <th class="border-top-0"></th>
                            </tr>
                        </thead>
                        <tbody>
                        @forelse($atenciones as $a)
                            <tr>
                                <td class="pl-4 font-weight-bold text-muted">#{{ $a->id }}</td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="rounded-circle bg-light d-flex align-items-center justify-content-center mr-2 text-primary font-weight-bold" style="width: 32px; height: 32px; font-size: 0.8rem;">
                                            {{ substr(optional($a->paciente)->name ?? '?', 0, 1) }}
                                        </div>
                                        <div class="font-weight-bold text-dark">{{ optional($a->paciente)->name ?? '—' }}</div>
                                    </div>
                                </td>
                                <td>
                                    @if($a->titular_id && $a->titular_id != $a->paciente_id)
                                        <span class="font-weight-bold text-info">{{ $a->titular_nombre }}</span><br>
                                        <span class="text-muted small">Cédula: {{ $a->titular_cedula }}</span>
                                    @else
                                        <span class="text-muted small font-italic">El paciente es el titular</span>
                                    @endif
                                </td>
                                <td>
                                    <span class="text-dark">{{ $a->empresa ?? '—' }}</span>
                                </td>
                                <td>
                                    <span class="text-dark">{{ $a->numero_siniestro ?? '—' }}</span>
                                </td>
                                <td>
                                    <span class="text-dark">{{ $a->nombre_operador ?? '—' }}</span>
                                </td>
                                <td>
                                    @if($a->seguro_validado)
                                        <i class="fas fa-check-circle text-success mr-1" title="Validado"></i>
                                    @else
                                        <i class="fas fa-clock text-warning mr-1" title="Pendiente"></i>
                                    @endif
                                    @if($a->aseguradora)
                                        <span class="small text-muted">{{ $a->aseguradora }}</span>
                                    @else
                                        <span class="small text-muted font-italic">Particular</span>
                                    @endif
                                </td>
                                <td>
                                    @php
                                        $infoEstado = $mapEstados[$a->estado] ?? ['label'=>ucfirst($a->estado),'class'=>'badge-light'];
                                        $badgeClass = match($a->estado) {
                                            'validado' => 'badge-info',
                                            'en_consulta' => 'badge-warning',
                                            'cerrado' => 'badge-success',
                                            default => 'badge-secondary'
                                        };
                                    @endphp
                                    <span class="badge {{ $badgeClass }} px-3 py-1 rounded-pill small">
                                        {{ $infoEstado['label'] }}
                                    </span>
                                </td>
                                <td class="text-right pr-4">
                                    @if($a->estado!=='cerrado')
                                        <form method="POST" action="{{ route('atenciones.cerrar', $a) }}" class="d-inline ml-2">
                                            @csrf
                                            <button class="btn btn-light btn-sm rounded-circle shadow-sm text-danger btn-cerrar-atencion" type="submit" data-id="{{ $a->id }}" title="Cerrar atención">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </form>
                                    @endif
                                </td>
                            </tr>
                        @empty
                            <tr><td colspan="9" class="text-center text-muted py-5">
                                <i class="fas fa-clipboard-list fa-3x mb-3 opacity-50"></i>
                                <p class="mb-0">No hay atenciones registradas</p>
                            </td></tr>
                        @endforelse
                        </tbody>
                    </table>
                </div>
                @if($atenciones->hasPages())
                <div class="d-flex justify-content-center py-3 border-top">
                    {{ $atenciones->links() }}
                </div>
                @endif
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
(function(){
    function setupAutocomplete(inputId, listId, hiddenId, url, labelFn, opts={}){
        const $input = document.getElementById(inputId);
        const $list = document.getElementById(listId);
        const $hidden = document.getElementById(hiddenId);
        const floating = !!opts.floating; // si true, mover la lista al body para evitar recortes en tablas
        let controller = null;
        function hide(){
            $list.style.display='none';
            $list.innerHTML='';
        }
        $input.addEventListener('input', async () => {
            const q = $input.value.trim();
            if(q.length < 2){ hide(); return; }
            if(controller) controller.abort();
            controller = new AbortController();
            try{
                const res = await fetch(url+`?q=${encodeURIComponent(q)}`, {signal: controller.signal});
                const json = await res.json();
                const items = json.data || [];
                if(!items.length){ hide(); return; }
                $list.innerHTML = items.map(it=>`<button type="button" class="list-group-item list-group-item-action" data-id="${it.id}">${labelFn(it)}</button>`).join('');
                if(floating){
                    const rect = $input.getBoundingClientRect();
                    $list.style.position = 'absolute';
                    $list.style.top = (rect.bottom + window.scrollY) + 'px';
                    $list.style.left = (rect.left + window.scrollX) + 'px';
                    $list.style.width = rect.width + 'px';
                    $list.style.zIndex = 5000;
                    if($list.parentElement !== document.body){
                        document.body.appendChild($list);
                    }
                }
                $list.style.display='block';
            }catch(e){ /* abort/silencio */ }
        });
        $list.addEventListener('click', e => {
            const btn = e.target.closest('button[data-id]');
            if(!btn) return;
            const id = btn.getAttribute('data-id');
            const text = btn.textContent.trim();
            $hidden.value = id; $input.value = text; hide();
        });
        document.addEventListener('click', e => { if(!e.target.closest('#'+listId) && !e.target.closest('#'+inputId)) hide(); });
        if(floating){
            window.addEventListener('scroll', hide, {passive:true});
            window.addEventListener('resize', hide);
        }
    }
    setupAutocomplete('buscar_paciente','lista_pacientes','paciente_id','{{ route('ajax.pacientes') }}', it => `${it.nombre} <span class="text-muted small">(${it.email ?? ''})</span>`);
    setupAutocomplete('buscar_medico','lista_medicos','medico_id','{{ route('ajax.medicos') }}', it => it.nombre);

    // Autocomplete dinámico para cada fila (asignar médico)
    document.querySelectorAll('[id^="buscar_medico_row_"]').forEach(inp => {
        const id = inp.id.replace('buscar_medico_row_','');
        setupAutocomplete(inp.id, 'lista_medicos_row_'+id, 'medico_id_row_'+id, '{{ route('ajax.medicos') }}', it => it.nombre, {floating:true});
    });
})();

// Confirmación SweetAlert2 al cerrar atención desde recepción
(function(){
    function ensureSwal(cb){
        if(window.Swal) return cb();
        const s=document.createElement('script'); s.src='https://cdn.jsdelivr.net/npm/sweetalert2@11'; s.onload=cb; document.head.appendChild(s);
    }
    document.querySelectorAll('.btn-cerrar-atencion').forEach(btn => {
        btn.addEventListener('click', function(e){
            e.preventDefault();
            const form = this.closest('form');
            ensureSwal(()=>{
                Swal.fire({
                    title: 'Cerrar atención',
                    text: '¿Confirmas que deseas cerrar esta atención? No se podrá seguir gestionando.',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'Sí, cerrar',
                    cancelButtonText: 'Cancelar',
                    confirmButtonColor: '#d33'
                }).then(r => { if(r.isConfirmed) form.submit(); });
            });
        });
    });
})();
</script>
@endpush


{{-- Botón de Ayuda Contextual --}}
<x-help-button title="Atenciones - Ayuda Rápida" :helpLink="route('help.show', 'gestion-atenciones')">
    <div class="help-quick-guide">
        <h5 class="text-primary"><i class="fas fa-lightbulb mr-2"></i> Guía Rápida: Atenciones</h5>
        
        <h6 class="font-weight-bold mt-3"><i class="fas fa-plus-circle text-success mr-2"></i> Crear Atención</h6>
        <ol class="small">
            <li>Selecciona el <strong>paciente</strong></li>
            <li>Completa datos de la empresa y aseguradora (si aplica)</li>
            <li>Ingresa el <strong>N° de siniestro</strong> y nombre del operador</li>
            <li>Activa/desactiva el switch <strong>"Seguro validado"</strong></li>
            <li>Haz clic en "Crear atención"</li>
        </ol>

        <h6 class="font-weight-bold mt-3"><i class="fas fa-shield-alt text-info mr-2"></i> Validar Seguro</h6>
        <p class="small">El switch "Seguro validado" indica si la aseguradora aprobó la cobertura:</p>
        <ul class="small">
            <li><i class="fas fa-check-circle text-success"></i> <strong>Activado:</strong> Seguro validado</li>
            <li><i class="fas fa-clock text-warning"></i> <strong>Desactivado:</strong> Pendiente de validación</li>
        </ul>

        <h6 class="font-weight-bold mt-3"><i class="fas fa-tasks text-primary mr-2"></i> Estados</h6>
        <ul class="small">
            <li><span class="badge badge-info">Validada</span> - Creada, esperando atención</li>
            <li><span class="badge badge-warning">En proceso</span> - Siendo atendida por especialista</li>
            <li><span class="badge badge-success">Cerrada</span> - Atención completada</li>
        </ul>

        <div class="callout callout-warning mt-3">
            <h6><i class="fas fa-times-circle mr-2"></i> Cerrar Atención</h6>
            <p class="small mb-0">Haz clic en el botón rojo <i class="fas fa-times text-danger"></i> para cerrar una atención. Esta acción no se puede deshacer.</p>
        </div>
    </div>
</x-help-button>
