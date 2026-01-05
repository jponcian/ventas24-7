@extends('layouts.adminlte')

@section('title', 'Detalle de Cita | SomosSalud')

@section('sidebar')
    @include('panel.partials.sidebar')
@endsection

@push('styles')
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
    :root {
        --primary-gradient: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%);
        --glass-bg: rgba(255, 255, 255, 0.95);
        --card-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.05);
    }

    body {
        font-family: 'Outfit', sans-serif !important;
        background-color: #f0f4f8;
        color: #1e293b;
    }

    .content-wrapper {
        background-color: #f0f4f8 !important;
    }

    .page-header {
        background: white;
        padding: 2rem 1.5rem;
        border-radius: 0 0 2rem 2rem;
        box-shadow: 0 4px 20px -5px rgba(0,0,0,0.05);
        margin-bottom: 2rem;
        position: relative;
        overflow: hidden;
    }
    
    .page-header::before {
        content: '';
        position: absolute;
        top: 0; left: 0; right: 0; height: 4px;
        background: var(--primary-gradient);
    }

    .back-link {
        color: #64748b;
        font-weight: 500;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        transition: all 0.2s;
        margin-bottom: 1rem;
    }

    .back-link:hover {
        color: #0ea5e9;
        transform: translateX(-3px);
        text-decoration: none;
    }

    .detail-card {
        background: white;
        border-radius: 1.5rem;
        border: none;
        box-shadow: var(--card-shadow);
        overflow: hidden;
        margin-bottom: 1.5rem;
    }

    .detail-card .card-header {
        background: white;
        border-bottom: 1px solid #f1f5f9;
        padding: 1.5rem;
    }

    .detail-card .card-title {
        font-weight: 700;
        color: #0f172a;
        font-size: 1.1rem;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .info-box {
        background: #f8fafc;
        border-radius: 1rem;
        padding: 1.25rem;
        height: 100%;
        transition: all 0.2s;
        border: 1px solid transparent;
    }

    .info-box:hover {
        background: #fff;
        border-color: #e2e8f0;
        box-shadow: 0 4px 12px rgba(0,0,0,0.03);
    }

    .info-label {
        font-size: 0.75rem;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        color: #64748b;
        font-weight: 600;
        margin-bottom: 0.5rem;
        display: block;
    }

    .info-value {
        font-size: 1.1rem;
        font-weight: 600;
        color: #1e293b;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .status-badge {
        padding: 0.5rem 1rem;
        border-radius: 2rem;
        font-size: 0.85rem;
        font-weight: 600;
        letter-spacing: 0.02em;
        text-transform: uppercase;
        display: inline-block;
    }

    .status-pendiente { background: #fff7ed; color: #c2410c; border: 1px solid #ffedd5; }
    .status-confirmada { background: #eff6ff; color: #0369a1; border: 1px solid #dbeafe; }
    .status-cancelada { background: #fef2f2; color: #b91c1c; border: 1px solid #fee2e2; }
    .status-concluida { background: #f0fdf4; color: #15803d; border: 1px solid #dcfce7; }

    .form-control {
        border-radius: 0.75rem;
        border: 2px solid #e2e8f0;
        padding: 0.75rem 1rem;
        font-size: 0.95rem;
        transition: all 0.2s;
    }

    .form-control:focus {
        border-color: #0ea5e9;
        box-shadow: 0 0 0 4px rgba(14, 165, 233, 0.1);
    }

    .medicamento-item {
        background: #fff;
        border: 1px solid #e2e8f0;
        border-radius: 1rem;
        padding: 1.25rem;
        margin-bottom: 1rem;
        transition: all 0.2s;
    }

    .medicamento-item:hover {
        border-color: #cbd5e1;
        box-shadow: 0 4px 12px rgba(0,0,0,0.03);
    }

    .btn-primary-custom {
        background: var(--primary-gradient);
        border: none;
        color: white;
        padding: 0.75rem 1.5rem;
        border-radius: 0.75rem;
        font-weight: 600;
        box-shadow: 0 4px 12px rgba(14, 165, 233, 0.25);
        transition: all 0.2s;
    }

    .btn-primary-custom:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(14, 165, 233, 0.35);
        color: white;
    }

    .btn-outline-danger-custom {
        color: #ef4444;
        border: 2px solid #fee2e2;
        background: #fff;
        padding: 0.5rem 1rem;
        border-radius: 0.75rem;
        font-weight: 600;
        transition: all 0.2s;
    }

    .btn-outline-danger-custom:hover:not(:disabled) {
        background: #fef2f2;
        border-color: #fecaca;
        color: #dc2626;
    }

    .btn-outline-danger-custom:disabled {
        opacity: 0.6;
        cursor: not-allowed;
    }

    @media (max-width: 768px) {
        .page-header {
            padding: 1.5rem 1rem;
            border-radius: 0 0 1.5rem 1.5rem;
        }
        .info-box {
            margin-bottom: 1rem;
        }
    }
</style>
@endpush

@section('content')
<div class="container-fluid px-0 px-md-3">
    <!-- Header -->
    <div class="page-header">
        <div class="container-fluid px-0">
            <a href="{{ route('citas.index') }}" class="back-link">
                <i class="fas fa-arrow-left"></i>
                <span>Volver a mis citas</span>
            </a>
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mt-2">
                <div>
                    <h1 class="h3 font-weight-bold mb-1" style="color: #0f172a;">Detalle de Cita</h1>
                    <p class="text-muted mb-0">Información completa de tu consulta médica</p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <span class="status-badge status-{{ $cita->estado }}">
                        {{ ucfirst($cita->estado) }}
                    </span>
                </div>
            </div>
        </div>
    </div>

    <div class="container-fluid pb-5">
        <!-- Información Principal -->
        <div class="detail-card">
            <div class="card-body p-4">
                <div class="row g-4">
                    <div class="col-12 col-md-6 col-lg-3">
                        <div class="info-box">
                            <span class="info-label">Fecha y Hora</span>
                            <div class="info-value">
                                <i class="far fa-calendar-alt text-primary"></i>
                                {{ \Illuminate\Support\Carbon::parse($cita->fecha)->format('d/m/Y H:i') }}
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-3">
                        <div class="info-box">
                            <span class="info-label">Especialista</span>
                            <div class="info-value">
                                <i class="fas fa-user-md text-info"></i>
                                {{ optional($cita->especialista)->name ?? '—' }}
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-3">
                        <div class="info-box">
                            <span class="info-label">Clínica</span>
                            <div class="info-value">
                                <i class="fas fa-hospital text-success"></i>
                                {{ optional($cita->clinica)->nombre ?? '—' }}
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-3">
                        <div class="info-box d-flex align-items-center justify-content-between">
                            <div>
                                <span class="info-label">Acciones</span>
                                <div class="text-muted small">Gestionar esta cita</div>
                            </div>
                            <form action="{{ route('citas.cancelar', $cita) }}" method="POST" class="form-cancelar-cita">
                                @csrf
                                <button class="btn-outline-danger-custom" @disabled($cita->estado==='cancelada' || $cita->estado==='concluida')>
                                    <i class="fas fa-ban mr-1"></i>Cancelar
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        @php($yo = auth()->user())
        @if(($yo->id === $cita->especialista_id) || $yo->hasRole(['super-admin','admin_clinica']))
            <!-- Gestión de la consulta -->
            <div class="detail-card" id="gestion">
                <div class="card-header">
                    <h3 class="card-title">
                        <div class="bg-primary-light rounded-circle p-2 text-primary">
                            <i class="fas fa-stethoscope"></i>
                        </div>
                        Gestión Médica
                    </h3>
                </div>
                <div class="card-body p-4">
                    @if(session('success'))
                        <div class="alert alert-success border-0 shadow-sm rounded-lg mb-4" style="background: #dcfce7; color: #166534;">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-check-circle mr-2 text-success"></i>
                                {{ session('success') }}
                            </div>
                        </div>
                    @endif
                    
                    @php($bloqueada = in_array($cita->estado,['cancelada','concluida']))
                    @if($bloqueada)
                        <div class="alert alert-warning border-0 shadow-sm rounded-lg mb-4" style="background: #fffbeb; color: #92400e;">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-exclamation-triangle mr-2"></i>
                                <strong>Atención:</strong>&nbsp;Esta cita está {{ $cita->estado }}. No es posible modificar la gestión.
                            </div>
                        </div>
                    @endif
                    
                    <form action="{{ route('citas.gestion', $cita) }}" method="POST" enctype="multipart/form-data" id="form-gestion-cita">
                        @csrf
                        
                        <!-- Diagnóstico -->
                        <div class="form-group mb-4">
                            <label class="font-weight-bold text-uppercase small text-muted mb-2">Diagnóstico *</label>
                            <textarea name="diagnostico" class="form-control" rows="3" required {{ $bloqueada ? 'disabled' : '' }} placeholder="Describe el diagnóstico del paciente...">{{ old('diagnostico', $cita->diagnostico) }}</textarea>
                            @error('diagnostico')<div class="text-danger small mt-1">{{ $message }}</div>@enderror
                        </div>

                        <!-- Medicamentos -->
                        <div class="form-group mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <label class="font-weight-bold text-uppercase small text-muted mb-0">Medicamentos Recetados</label>
                                <span class="badge badge-light border">Máx 10</span>
                            </div>
                            
                            <div id="medicamentos-wrapper">
                                @php($oldMeds = old('medicamentos', $cita->medicamentos->map(fn($m)=>[
                                    'nombre_generico'=>$m->nombre_generico,
                                    'presentacion'=>$m->presentacion,
                                    'posologia'=>$m->posologia,
                                    'frecuencia'=>$m->frecuencia,
                                    'duracion'=>$m->duracion,
                                ])->toArray()))
                                
                                @forelse($oldMeds as $idx => $med)
                                    <div class="medicamento-item">
                                        <div class="row g-3 align-items-center">
                                            <div class="col-12 col-md-4">
                                                <label class="small text-muted mb-1">Medicamento</label>
                                                <input type="text" name="medicamentos[{{ $idx }}][nombre_generico]" class="form-control form-control-sm" placeholder="Ej: Ibuprofeno 800mg" value="{{ trim(($med['nombre_generico'] ?? '') . ' ' . ($med['presentacion'] ?? '')) }}" {{ $bloqueada ? 'disabled' : '' }}>
                                            </div>
                                            <div class="col-6 col-md-3">
                                                <label class="small text-muted mb-1">Posología</label>
                                                <input type="text" name="medicamentos[{{ $idx }}][posologia]" class="form-control form-control-sm" placeholder="Ej: 1 tableta" value="{{ $med['posologia'] ?? '' }}" {{ $bloqueada ? 'disabled' : '' }}>
                                            </div>
                                            <div class="col-6 col-md-2">
                                                <label class="small text-muted mb-1">Frecuencia</label>
                                                <input type="text" name="medicamentos[{{ $idx }}][frecuencia]" class="form-control form-control-sm" placeholder="Ej: 12h" value="{{ $med['frecuencia'] ?? '' }}" {{ $bloqueada ? 'disabled' : '' }}>
                                            </div>
                                            <div class="col-6 col-md-2">
                                                <label class="small text-muted mb-1">Duración</label>
                                                <input type="text" name="medicamentos[{{ $idx }}][duracion]" class="form-control form-control-sm" placeholder="Ej: 7d" value="{{ $med['duracion'] ?? '' }}" {{ $bloqueada ? 'disabled' : '' }}>
                                            </div>
                                            <div class="col-6 col-md-1 text-center pt-4">
                                                <button type="button" class="btn btn-sm text-danger remove-med" title="Eliminar" {{ $bloqueada ? 'disabled' : '' }}>
                                                    <i class="fas fa-trash-alt"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                @empty
                                @endforelse
                            </div>
                            
                            @unless($bloqueada)
                                <button type="button" class="btn btn-light border text-primary w-100 py-2 mt-2" id="btn-add-med" style="border-style: dashed !important;">
                                    <i class="fas fa-plus mr-1"></i>Añadir medicamento
                                </button>
                            @endunless
                        </div>

                        <!-- Observaciones -->
                        <div class="form-group mb-4">
                            <label class="font-weight-bold text-uppercase small text-muted mb-2">Observaciones</label>
                            <textarea name="observaciones" class="form-control" rows="2" {{ $bloqueada ? 'disabled' : '' }} placeholder="Observaciones adicionales...">{{ old('observaciones', $cita->observaciones) }}</textarea>
                        </div>

                        <!-- Adjuntos -->
                        <div class="form-group mb-4">
                            <label class="font-weight-bold text-uppercase small text-muted mb-2">Adjuntos (imágenes / PDF)</label>
                            <div class="custom-file">
                                <input type="file" name="adjuntos[]" class="form-control" accept="image/*,application/pdf" multiple {{ $bloqueada ? 'disabled' : '' }}>
                                <small class="text-muted mt-1 d-block">Máx 6 archivos, 5MB c/u.</small>
                            </div>
                        </div>
                        
                        @if($cita->adjuntos()->exists())
                            <div class="mb-4 p-3 bg-light rounded-lg">
                                <div class="text-muted small mb-2 font-weight-bold">Archivos adjuntos:</div>
                                <div class="d-flex flex-wrap gap-2">
                                    @foreach($cita->adjuntos as $adj)
                                        <a href="{{ Storage::disk('public')->url($adj->ruta) }}" target="_blank" class="btn btn-sm btn-white border shadow-sm">
                                            <i class="fas fa-file-alt text-primary mr-1"></i>{{ $adj->nombre_original ?? basename($adj->ruta) }}
                                        </a>
                                    @endforeach
                                </div>
                            </div>
                        @endif

                        <!-- Concluir cita -->
                        <div class="d-flex align-items-center p-3 bg-light rounded-lg mb-4">
                            <div class="custom-control custom-switch">
                                <input class="custom-control-input" type="checkbox" id="concluirSwitch" name="concluir" value="1" @checked($cita->estado==='concluida') {{ $bloqueada ? 'disabled' : '' }}>
                                <label class="custom-control-label font-weight-bold text-dark" for="concluirSwitch">Marcar cita como concluida</label>
                            </div>
                        </div>

                        <!-- Botones -->
                        <div class="d-flex justify-content-end gap-3 pt-3 border-top">
                            @if($cita->medicamentos()->exists())
                                <a href="{{ route('citas.receta', $cita) }}" class="btn btn-light border text-primary font-weight-bold">
                                    <i class="fas fa-prescription-bottle-medical mr-2"></i>Ver receta
                                </a>
                            @endif
                            @unless($bloqueada)
                                <button class="btn-primary-custom">
                                    <i class="fas fa-save mr-2"></i>Guardar Gestión
                                </button>
                            @endunless
                        </div>
                    </form>
                </div>
            </div>
        @else
            @if($cita->medicamentos()->exists())
                <div class="text-center mt-4">
                    <a href="{{ route('citas.receta', $cita) }}" class="btn-primary-custom text-decoration-none">
                        <i class="fas fa-prescription-bottle-medical mr-2"></i>Ver receta médica
                    </a>
                </div>
            @endif
        @endif
    </div>
</div>
@endsection

@push('scripts')
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
(function(){
    const wrapper = document.getElementById('medicamentos-wrapper');
    if(!wrapper) return;
    const btnAdd = document.getElementById('btn-add-med');
    function currentCount(){ return wrapper.querySelectorAll('.medicamento-item').length; }
    
    if(btnAdd) {
        btnAdd.addEventListener('click', () => {
            if(currentCount() >= 10) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Límite alcanzado',
                    text: 'Máximo 10 medicamentos permitidos',
                    confirmButtonColor: '#0ea5e9'
                });
                return;
            }
            const idx = Date.now();
            const div = document.createElement('div');
            div.className = 'medicamento-item';
            div.innerHTML = `
                <div class="row g-3 align-items-center">
                    <div class="col-12 col-md-4">
                        <label class="small text-muted mb-1">Medicamento</label>
                        <input type="text" name="medicamentos[\${idx}][nombre_generico]" class="form-control form-control-sm" placeholder="Ej: Ibuprofeno 800mg">
                    </div>
                    <div class="col-6 col-md-3">
                        <label class="small text-muted mb-1">Posología</label>
                        <input type="text" name="medicamentos[\${idx}][posologia]" class="form-control form-control-sm" placeholder="Ej: 1 tableta">
                    </div>
                    <div class="col-6 col-md-2">
                        <label class="small text-muted mb-1">Frecuencia</label>
                        <input type="text" name="medicamentos[\${idx}][frecuencia]" class="form-control form-control-sm" placeholder="Ej: 12h">
                    </div>
                    <div class="col-6 col-md-2">
                        <label class="small text-muted mb-1">Duración</label>
                        <input type="text" name="medicamentos[\${idx}][duracion]" class="form-control form-control-sm" placeholder="Ej: 7d">
                    </div>
                    <div class="col-6 col-md-1 text-center pt-4">
                        <button type="button" class="btn btn-sm text-danger remove-med" title="Eliminar">
                            <i class="fas fa-trash-alt"></i>
                        </button>
                    </div>
                </div>`;
            wrapper.appendChild(div);
        });
    }
    
    wrapper.addEventListener('click', e => {
        if(e.target.closest('.remove-med')){
            e.target.closest('.medicamento-item').remove();
        }
    });
})();

// Confirmaciones con SweetAlert2
(function(){
    const fCancel = document.querySelector('.form-cancelar-cita');
    if(fCancel){
        fCancel.addEventListener('submit', function(e){
            e.preventDefault();
            Swal.fire({
                title: 'Cancelar cita',
                text: '¿Confirmas que deseas cancelar esta cita?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Sí, cancelar',
                cancelButtonText: 'Volver',
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#64748b',
                reverseButtons: true,
                customClass: {
                    popup: 'rounded-xl',
                    confirmButton: 'rounded-lg',
                    cancelButton: 'rounded-lg'
                }
            }).then(r=> { if(r.isConfirmed) this.submit(); });
        });
    }
    
    const formGestion = document.getElementById('form-gestion-cita');
    if(formGestion){
        const chk = formGestion.querySelector('#concluirSwitch');
        formGestion.addEventListener('submit', function(e){
            if(!chk || !chk.checked || formGestion.dataset.confirmed==='1') return;
            e.preventDefault();
            Swal.fire({
                title: 'Concluir cita',
                text: '¿Confirmas que deseas concluir esta cita? Luego no podrás modificarla.',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Sí, concluir',
                cancelButtonText: 'Cancelar',
                confirmButtonColor: '#0ea5e9',
                cancelButtonColor: '#64748b',
                reverseButtons: true,
                customClass: {
                    popup: 'rounded-xl',
                    confirmButton: 'rounded-lg',
                    cancelButton: 'rounded-lg'
                }
            }).then(r=> { 
                if(r.isConfirmed){ 
                    formGestion.dataset.confirmed='1'; 
                    formGestion.submit(); 
                } 
            });
        });
    }
})();
</script>
@endpush
