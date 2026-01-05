@extends('layouts.adminlte')

@section('title', 'Nueva Orden de Laboratorio')

@section('content')
<div class="container-fluid pb-5">
    <form action="{{ route('lab.orders.store') }}" method="POST" id="formOrden">
        @csrf
        <div class="row">
            <!-- Left Column: Order Info -->
            <div class="col-lg-4 col-md-12 mb-4">
                <div class="card shadow-sm border-0 rounded-lg overflow-hidden">
                    <div class="card-header border-0" style="background: linear-gradient(135deg, #dbeafe 0%, #dcfce7 100%); border-bottom: 1px solid #cbd5e1;">
                        <h3 class="card-title font-weight-bold text-primary mb-0">
                            <i class="fas fa-file-invoice mr-2"></i> Datos de la Orden
                        </h3>
                    </div>
                    <div class="card-body">
                        @if($errors->any())
                        <div class="alert alert-danger alert-dismissible fade show">
                            <button type="button" class="close" data-dismiss="alert">&times;</button>
                            <ul class="mb-0 pl-3">
                                @foreach($errors->all() as $error)
                                <li>{{ $error }}</li>
                                @endforeach
                            </ul>
                        </div>
                        @endif

                        <!-- Patient -->
                        <div class="form-group">
                            <label class="small font-weight-bold text-uppercase text-muted">Paciente <span class="text-danger">*</span></label>
                            <div class="d-flex align-items-center">
                                <div class="bg-light border-0 rounded-left d-flex align-items-center justify-content-center" style="width: 38px; height: calc(1.5em + .5rem + 2px); border: 1px solid #e2e8f0; border-right: 0;">
                                    <i class="fas fa-user text-muted"></i>
                                </div>
                                <div class="flex-grow-1">
                                    <select name="patient_id" id="patient_id" class="form-control form-control-sm select2" required>
                                        <option value="">Seleccione un paciente...</option>
                                        @foreach($patients as $patient)
                                        <option value="{{ $patient->id }}" {{ old('patient_id') == $patient->id ? 'selected' : '' }}>
                                            {{ $patient->name }} - {{ $patient->cedula }}
                                        </option>
                                        @endforeach
                                    </select>
                                </div>
                                <button type="button" 
                                   data-toggle="modal" 
                                   data-target="#modalRegistrarPaciente"
                                   class="btn btn-sm btn-primary rounded-right ml-0 d-flex align-items-center justify-content-center" 
                                   style="height: calc(1.5em + .5rem + 2px); width: 38px; border-radius: 0 .25rem .25rem 0 !important;"
                                   title="Registrar nuevo paciente">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </div>
                        </div>

                        <!-- Clinic -->
                        <div class="form-group">
                            <label class="small font-weight-bold text-uppercase text-muted">Clínica <span class="text-danger">*</span></label>
                            <div class="input-group input-group-sm">
                                <div class="input-group-prepend">
                                    <span class="input-group-text bg-light border-0"><i class="fas fa-hospital text-muted"></i></span>
                                </div>
                                <select name="clinica_id" id="clinica_id" class="form-control bg-light border-0" required>
                                    @foreach($clinicas as $clinica)
                                    <option value="{{ $clinica->id }}" {{ old('clinica_id', Auth::user()->clinica_id) == $clinica->id ? 'selected' : '' }}>
                                        {{ $clinica->nombre }}
                                    </option>
                                    @endforeach
                                </select>
                            </div>
                        </div>

                        <!-- Date -->
                        <div class="form-group">
                            <label class="small font-weight-bold text-uppercase text-muted">Fecha de Orden <span class="text-danger">*</span></label>
                            <div class="input-group input-group-sm">
                                <div class="input-group-prepend">
                                    <span class="input-group-text bg-light border-0"><i class="fas fa-calendar text-muted"></i></span>
                                </div>
                                <input type="date" 
                                       name="order_date" 
                                       id="order_date" 
                                       class="form-control bg-light border-0" 
                                       value="{{ date('Y-m-d') }}"
                                       readonly
                                       required>
                            </div>
                            <!-- <small class="text-muted"><i class="fas fa-info-circle mr-1"></i>La fecha de orden siempre es la fecha actual.</small> -->
                        </div>


                    </div>
                </div>
                
                <!-- Total Card (Desktop Only) -->
                 <div class="card shadow-sm border-0 rounded-lg overflow-hidden d-none d-lg-block" style="background: linear-gradient(135deg, #f0fdf4 0%, #dbeafe 100%);">
                    <div class="card-body text-center">
                        <p class="text-uppercase text-muted small font-weight-bold mb-1">Total a Pagar</p>
                        <h3 class="mb-0 font-weight-bold text-primary">$<span class="total-amount-display">0.00</span></h3>
                    </div>
                 </div>

                 <div class="mt-3 mb-4 d-none d-lg-block">
                    <button type="submit" class="btn btn-primary btn-block shadow-sm font-weight-bold">
                        <i class="fas fa-save mr-2"></i> Crear Orden
                    </button>
                    <a href="{{ route('lab.orders.index') }}" class="btn btn-light btn-block border shadow-sm">
                        <i class="fas fa-times mr-2"></i> Cancelar
                    </a>
                 </div>
            </div>

            <!-- Right Column: Exams -->
            <div class="col-lg-8 col-md-12">
                <div class="card shadow-sm border-0 rounded-lg overflow-hidden exam-card-container">
                    <div class="card-header border-0 d-flex align-items-center" style="background: linear-gradient(135deg, #dbeafe 0%, #dcfce7 100%); border-bottom: 1px solid #cbd5e1;">
                        <h3 class="card-title font-weight-bold text-primary mb-0">
                            <i class="fas fa-flask mr-2"></i> Exámenes Solicitados
                        </h3>
                        <div class="ml-auto">
                            <div class="input-group input-group-sm" style="width: 250px;">
                                <div class="input-group-prepend">
                                    <span class="input-group-text bg-white border-0"><i class="fas fa-search text-muted"></i></span>
                                </div>
                                <input type="text" id="searchExam" class="form-control bg-white border-0" placeholder="Buscar examen...">
                            </div>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="exam-list-container" style="height: 600px; overflow-y: auto; padding: 20px;">
                            @error('exams')
                                <div class="alert alert-danger mx-3">{{ $message }}</div>
                            @enderror

                            @foreach($categories as $category)
                                <div class="category-section mb-4">
                                    <h5 class="text-primary border-bottom pb-2 mb-3 category-title font-weight-bold">
                                        <i class="fas fa-folder-open mr-2"></i> {{ $category->name }}
                                    </h5>
                                    <div class="row">
                                        @foreach($category->exams as $exam)
                                            <div class="col-md-6 exam-item mb-2" data-name="{{ strtolower($exam->name) }}" data-category="{{ strtolower($category->name) }}">
                                                <div class="custom-control custom-checkbox exam-checkbox-wrapper">
                                                    <input class="custom-control-input exam-checkbox" 
                                                           type="checkbox" 
                                                           name="exams[]" 
                                                           value="{{ $exam->id }}" 
                                                           id="exam_{{ $exam->id }}"
                                                           data-price="{{ $exam->price }}"
                                                           {{ in_array($exam->id, old('exams', [])) ? 'checked' : '' }}>
                                                    <label class="custom-control-label w-100 d-flex justify-content-between align-items-center" for="exam_{{ $exam->id }}" style="cursor: pointer;">
                                                        <span class="text-dark">{{ $exam->name }}</span>
                                                        <span class="badge badge-light border px-2 py-1">${{ number_format($exam->price, 2) }}</span>
                                                    </label>
                                                </div>
                                            </div>
                                        @endforeach
                                    </div>
                                </div>
                            @endforeach
                            
                            <div id="noResults" class="text-center text-muted mt-5 py-5" style="display: none;">
                                <i class="fas fa-search fa-3x mb-3" style="color: #cbd5e1;"></i>
                                <p class="mb-0">No se encontraron exámenes que coincidan con la búsqueda.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        </div>
    </form>
    
    <!-- Mobile Sticky Actions Bar -->
    <div class="mobile-actions-bar d-lg-none">
        <div class="container-fluid d-flex align-items-center justify-content-between px-0">
            <div class="d-flex flex-column">
                <span class="text-muted small text-uppercase font-weight-bold" style="font-size: 0.7rem;">Total a Pagar</span>
                <span class="h4 font-weight-bold text-primary mb-0">$<span class="total-amount-display">0.00</span></span>
            </div>
            <div class="d-flex">
                <a href="{{ route('lab.orders.index') }}" class="btn btn-outline-secondary mr-2 d-none d-sm-block">
                    Cancelar
                </a>
                <button type="submit" form="formOrden" class="btn btn-primary font-weight-bold shadow-sm px-4">
                    <i class="fas fa-save mr-2"></i> Crear
                </button>
            </div>
        </div>
    </div>

    <!-- Modal Registrar Paciente -->
    <div class="modal fade" id="modalRegistrarPaciente" tabindex="-1" role="dialog" aria-labelledby="modalRegistrarPacienteLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header text-white" style="background: linear-gradient(to right, #0ea5e9, #10b981);">
                    <h5 class="modal-title font-weight-bold" id="modalRegistrarPacienteLabel">
                        <i class="fas fa-user-plus mr-2"></i>Registrar Nuevo Paciente
                    </h5>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form id="formRegistrarPaciente" method="POST" action="{{ route('admin.users.store') }}">
                    @csrf
                    
                    <div class="modal-body p-4">
                        <!-- Es Dependiente Checkbox -->
                        <div class="form-group bg-light p-3 rounded mb-3 border">
                            <div class="custom-control custom-checkbox">
                                <input type="checkbox" class="custom-control-input" id="check_es_dependiente" name="es_dependiente" value="1">
                                <label class="custom-control-label font-weight-bold text-primary" for="check_es_dependiente">
                                    <i class="fas fa-child mr-1"></i> ¿Es menor de edad / dependiente?
                                </label>
                            </div>
                            <small class="text-muted ml-4 d-block mt-1">Marque si el paciente es un niño que usa la cédula de su representante.</small>
                        </div>

                        <!-- Representante Select (Hidden by default) -->
                        <div class="form-group" id="div_representante" style="display: none;">
                            <label class="font-weight-bold text-dark small text-uppercase">Representante <span class="text-danger">*</span></label>
                            <div class="input-group shadow-sm">
                                <div class="input-group-prepend">
                                    <span class="input-group-text bg-white border-right-0"><i class="fas fa-user-friends text-muted"></i></span>
                                </div>
                                <select name="representante_id" id="select_representante" class="form-control" style="width: 100%;">
                                    <!-- Ajax -->
                                </select>
                            </div>
                            <small class="form-text text-muted mt-1"><i class="fas fa-info-circle mr-1"></i>Busque por nombre o cédula del representante.</small>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="modal_name" class="font-weight-bold text-dark small text-uppercase">Nombre completo <span class="text-danger">*</span></label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i class="fas fa-user text-muted"></i></span>
                                        </div>
                                        <input type="text" name="name" id="modal_name" class="form-control border-left-0" placeholder="Ej: Juan Pérez" required>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="modal_cedula" class="font-weight-bold text-dark small text-uppercase">Cédula <span class="text-danger">*</span></label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i class="fas fa-id-card text-muted"></i></span>
                                        </div>
                                        <input type="text" name="cedula" id="modal_cedula" class="form-control border-left-0" placeholder="Ej: V-12345678" required>
                                    </div>
                                    <small class="form-text text-muted mt-1"><i class="fas fa-info-circle mr-1"></i>Si empiezas con un número, se asume V- automáticamente.</small>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="modal_email" class="font-weight-bold text-dark small text-uppercase">Correo electrónico <span class="text-danger">*</span></label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i class="fas fa-envelope text-muted"></i></span>
                                        </div>
                                        <input type="email" name="email" id="modal_email" class="form-control border-left-0" placeholder="correo@ejemplo.com" required>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="modal_telefono" class="font-weight-bold text-dark small text-uppercase">Teléfono <span class="text-muted font-weight-normal text-lowercase">(WhatsApp)</span></label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i class="fab fa-whatsapp text-muted"></i></span>
                                        </div>
                                        <input type="text" name="telefono" id="modal_telefono" class="form-control border-left-0" placeholder="Ej: 0414-1234567" maxlength="20">
                                    </div>
                                    <small class="form-text text-muted mt-1"><i class="fas fa-info-circle mr-1"></i>Formato: 0414-1234567 (Movistar, Digitel, Movilnet)</small>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="modal_fecha_nacimiento" class="font-weight-bold text-dark small text-uppercase">Fecha de Nacimiento <span class="text-danger">*</span></label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i class="fas fa-calendar text-muted"></i></span>
                                        </div>
                                        <input type="date" name="fecha_nacimiento" id="modal_fecha_nacimiento" class="form-control border-left-0" max="{{ date('Y-m-d') }}" required>
                                    </div>
                                    <small class="form-text text-muted mt-1"><i class="fas fa-info-circle mr-1"></i>Importante para el historial médico.</small>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="modal_sexo" class="font-weight-bold text-dark small text-uppercase">Sexo <span class="text-danger">*</span></label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i class="fas fa-venus-mars text-muted"></i></span>
                                        </div>
                                        <select name="sexo" id="modal_sexo" class="form-control border-left-0" required>
                                            <option value="">Seleccione...</option>
                                            <option value="M">Masculino</option>
                                            <option value="F">Femenino</option>
                                        </select>
                                    </div>
                                    <small class="form-text text-muted mt-1"><i class="fas fa-info-circle mr-1"></i>Necesario para valores de referencia de laboratorio.</small>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-outline-secondary" data-dismiss="modal">
                            <i class="fas fa-times mr-2"></i>Cancelar
                        </button>
                        <button type="button" id="btnGuardarPaciente" class="btn btn-primary font-weight-bold" onclick="guardarPacienteModal()">
                            <i class="fas fa-save mr-2"></i>Guardar Paciente
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
    // Formateo automático de cédula en tiempo real mientras se escribe
    document.addEventListener('DOMContentLoaded', function() {
        const cedulaInput = document.getElementById('modal_cedula');
        if (cedulaInput) {
            cedulaInput.addEventListener('input', function(e) {
                let value = this.value.toUpperCase();
                let cursorPos = this.selectionStart;
                
                // Remover caracteres no permitidos
                value = value.replace(/[^VEJGP0-9-]/g, '');
                
                // Si empieza con número, agregar V-
                if (/^\d/.test(value)) {
                    value = 'V-' + value;
                    cursorPos += 2;
                }
                // Si tiene letra al inicio sin guión, agregar guión
                else if (/^[VEJGP]\d/.test(value)) {
                    value = value.charAt(0) + '-' + value.substring(1);
                    cursorPos += 1;
                }
                
                this.value = value;
                this.setSelectionRange(cursorPos, cursorPos);
            });
        }
        
        // Convertir nombre a mayúsculas en tiempo real
        const nameInput = document.getElementById('modal_name');
        if (nameInput) {
            nameInput.addEventListener('input', function(e) {
                const start = this.selectionStart;
                const end = this.selectionEnd;
                this.value = this.value.toUpperCase();
                this.setSelectionRange(start, end);
            });
        }
        
        // Convertir email a mayúsculas en tiempo real
        const emailInput = document.getElementById('modal_email');
        if (emailInput) {
            emailInput.addEventListener('input', function(e) {
                const start = this.selectionStart;
                const end = this.selectionEnd;
                this.value = this.value.toUpperCase();
                this.setSelectionRange(start, end);
            });
        }
    });
    
    function guardarPacienteModal() {
        const form = document.getElementById('formRegistrarPaciente');
        
        // Formatear cédula ANTES de validar
        const cedulaInput = document.getElementById('modal_cedula');
        let cedula = cedulaInput.value.trim().toUpperCase();
        
        // Si solo tiene números, agregar V- al inicio
        if (/^\d{6,8}$/.test(cedula)) {
            cedula = 'V-' + cedula;
            cedulaInput.value = cedula;
        }
        // Si tiene letra y números sin guión, agregar el guión
        else if (/^([VEJGP])(\d{6,8})$/i.test(cedula)) {
            cedula = cedula.charAt(0) + '-' + cedula.substring(1);
            cedulaInput.value = cedula;
        }
        
        // Validar campos requeridos
        if (!form.checkValidity()) {
            form.reportValidity();
            return false;
        }
        
        // Crear FormData DESPUÉS de formatear la cédula
        const formData = new FormData(form);
        formData.append('roles[]', 'paciente');
        formData.append('password', 'temporal123');
        formData.append('password_confirmation', 'temporal123');
        
        const btn = document.getElementById('btnGuardarPaciente');
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Guardando...';
        
        fetch('{{ route("admin.users.store") }}', {
            method: 'POST',
            body: formData,
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Cerrar modal
                $('#modalRegistrarPaciente').modal('hide');
                
                // Agregar al select
                const option = new Option(data.user.name + ' - ' + data.user.cedula, data.user.id, true, true);
                document.getElementById('patient_id').appendChild(option);
                $('#patient_id').trigger('change');
                
                // Limpiar formulario
                form.reset();
                
                // Mensaje de éxito
                if (typeof Swal !== 'undefined') {
                    Swal.fire({
                        icon: 'success',
                        title: '¡Paciente registrado!',
                        text: 'El paciente ha sido registrado exitosamente.',
                        timer: 3000,
                        showConfirmButton: false
                    });
                } else {
                    alert('¡Paciente registrado exitosamente!');
                }
            } else if (data.errors) {
                // Mostrar errores de validación
                let errorMsg = 'Errores de validación:\n\n';
                Object.keys(data.errors).forEach(key => {
                    data.errors[key].forEach(error => {
                        errorMsg += '• ' + error + '\n';
                    });
                });
                
                if (typeof Swal !== 'undefined') {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error de validación',
                        html: errorMsg.replace(/\n/g, '<br>')
                    });
                } else {
                    alert(errorMsg);
                }
            }
        })
        .catch(error => {
            alert('Error al guardar: ' + error.message);
        })
        .finally(() => {
            btn.disabled = false;
            btn.innerHTML = '<i class="fas fa-save mr-2"></i>Guardar Paciente';
        });
    }
    </script>
</div>
@stop

@push('styles')
<style>
    .exam-checkbox-wrapper {
        padding: 10px 15px;
        border-radius: 8px;
        transition: all 0.2s ease;
        background-color: #f8fafc;
    }
    
    .exam-checkbox-wrapper:hover {
        background-color: #e0f2fe;
        transform: translateX(3px);
    }
    
    .exam-checkbox:checked ~ label {
        font-weight: 600;
        color: #0ea5e9 !important;
    }

    .exam-checkbox:checked ~ label .badge {
        background-color: #0ea5e9 !important;
        color: white !important;
        border-color: #0ea5e9 !important;
    }

    .category-section {
        animation: fadeIn 0.3s ease-in;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    .exam-list-container::-webkit-scrollbar {
        width: 8px;
    }

    .exam-list-container::-webkit-scrollbar-track {
        background: #f1f1f1;
        border-radius: 10px;
    }

    .exam-list-container::-webkit-scrollbar-thumb {
        background: #cbd5e1;
        border-radius: 10px;
    }

    .exam-list-container::-webkit-scrollbar-thumb:hover {
        background: #94a3b8;
    }

    /* Select2 en Modal - Alineado exactamente como los inputs normales */
    #div_representante .select2-container .select2-selection--single {
        height: calc(1.5em + 0.75rem + 2px) !important;
        min-height: calc(1.5em + 0.75rem + 2px) !important;
        border: 1px solid #ced4da !important;
        border-left: 0 !important;
        border-radius: 0 0.25rem 0.25rem 0 !important;
        background-color: #fff !important;
        padding: 0.375rem 0.75rem !important;
        line-height: 1.5 !important;
    }

    #div_representante .select2-container .select2-selection--single .select2-selection__rendered {
        padding: 0 !important;
        padding-right: 20px !important;
        line-height: 1.5 !important;
        color: #495057;
    }

    #div_representante .select2-container .select2-selection--single .select2-selection__arrow {
        height: calc(1.5em + 0.75rem) !important;
        top: 1px !important;
        right: 1px !important;
    }

    #div_representante .input-group-prepend {
        display: flex;
        align-items: center;
    }

    #div_representante .input-group-text {
        background-color: #fff !important;
        border-right: 0 !important;
        height: calc(1.5em + 0.75rem + 2px);
        display: flex;
        align-items: center;
    }

    #div_representante .select2-container {
        flex: 1 1 auto;
        width: 1% !important;
    }
</style>
@endpush

@push('scripts')
<script>
// Inicialización de Select2 y cálculo de totales
$(document).ready(function() {
    
    // Select2 en try-catch para evitar que rompa el resto
    try {
        if ($.fn.select2) {
            $('#patient_id').select2({
                placeholder: 'Buscar paciente por nombre o cédula...',
                allowClear: false,
                width: '100%'
            });
        }
    } catch (e) {
        // Silent error
    }

    // --- LÓGICA DEPENDIENTES (MENORES) ---
    
    // Inicializar Select2 para Representante con AJAX
    $('#select_representante').select2({
        dropdownParent: $('#modalRegistrarPaciente'),
        placeholder: 'Buscar representante (Padre/Madre)...',
        width: '100%',
        minimumInputLength: 1,
        language: {
            inputTooShort: function() {
                return 'Escribe al menos 1 carácter para buscar';
            },
            searching: function() {
                return 'Buscando...';
            },
            noResults: function() {
                return 'No se encontraron resultados';
            }
        },
        ajax: {
            url: '{{ route("admin.users.search-representantes") }}',
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return {
                    q: params.term || ''
                };
            },
            processResults: function (data) {
                return {
                    results: data.results || []
                };
            },
            cache: true
        }
    });

    // Toggle Checkbox Dependiente
    $('#check_es_dependiente').change(function() {
        const isDependent = $(this).is(':checked');
        const cedulaInput = $('#modal_cedula');
        const emailInput = $('#modal_email');
        const repSelect = $('#select_representante');

        if(isDependent) {
            $('#div_representante').slideDown();
            repSelect.prop('required', true);
            cedulaInput.prop('readonly', true).attr('placeholder', 'Se generará automáticamente...');
            emailInput.prop('readonly', true);
        } else {
            $('#div_representante').slideUp();
            repSelect.prop('required', false).val(null).trigger('change');
            cedulaInput.prop('readonly', false).val('').attr('placeholder', 'Ej: V-12345678');
            emailInput.prop('readonly', false).val('');
        }
    });

    // Al seleccionar representante
    $('#select_representante').on('select2:select', function (e) {
        const data = e.params.data;
        
        // Copiar email (padres e hijos pueden compartir email)
        $('#modal_email').val(data.email);

        // Generar Cédula de dependiente (V-PADRE-H1)
        $('#modal_cedula').val('Generando ID...');
        $.get('{{ url("admin/users/next-dependent-number") }}/' + data.id)
            .done(function(resp) {
                const nextNum = resp.next_number || 1;
                // Formato: CEDULA_PADRE-H1
                const childCedula = data.cedula + '-H' + nextNum;
                $('#modal_cedula').val(childCedula);
            })
            .fail(function() {
                $('#modal_cedula').val(data.cedula + '-H1');
            });
    });

    // Modal Events
    $('#modalRegistrarPaciente').on('hidden.bs.modal', function () {
        const form = $('#formRegistrarPaciente')[0];
        if(form) form.reset();
        $('#formRegistrarPaciente').find('.is-invalid').removeClass('is-invalid');
    });
});

// Lógica del Buscador de Exámenes (Aislada para asegurar ejecución)
document.addEventListener('DOMContentLoaded', function() {
    
    const searchInput = document.getElementById('searchExam');
    if (!searchInput) {
        return;
    }

    const examItems = Array.from(document.querySelectorAll('.exam-item'));
    const categorySections = Array.from(document.querySelectorAll('.category-section'));
    const noResults = document.getElementById('noResults');

    const normalize = (text) => text
        .toLowerCase()
        .normalize('NFD')
        .replace(/\p{Diacritic}/gu, '')
        .trim();

    function filterExams(query) {
        const value = normalize(query);
        let hasVisible = false;

        if (value === '') {
            examItems.forEach(item => item.classList.remove('d-none'));
            categorySections.forEach(section => section.classList.remove('d-none'));
            if (noResults) noResults.style.display = 'none';
            return;
        }

        examItems.forEach(item => {
            const name = normalize(String(item.dataset.name || ''));
            const category = normalize(String(item.dataset.category || ''));
            const match = name.includes(value) || category.includes(value);
            item.classList.toggle('d-none', !match);
            if (match) hasVisible = true;
        });

        categorySections.forEach(section => {
            const visibleChildren = section.querySelectorAll('.exam-item:not(.d-none)').length;
            section.classList.toggle('d-none', visibleChildren === 0);
        });

        if (noResults) {
            noResults.style.display = hasVisible ? 'none' : 'block';
        }
    }

    searchInput.addEventListener('input', (e) => filterExams(e.target.value));

    if (searchInput.value) {
        filterExams(searchInput.value);
    }
});

// Cálculo de Totales (Aislado)
document.addEventListener('DOMContentLoaded', function() {
    const checkboxes = document.querySelectorAll('.exam-checkbox');
    // const totalElement = document.getElementById('totalAmount'); // Deprecated

    function updateTotal() {
        let total = 0;
        checkboxes.forEach(checkbox => {
            if (checkbox.checked) {
                // Asegurar que price sea número
                const price = parseFloat(checkbox.dataset.price) || 0;
                total += price;
            }
        });
        
        // Actualizar todos los elementos que muestran el total
        document.querySelectorAll('.total-amount-display').forEach(el => {
            el.textContent = total.toFixed(2);
        });
    }

    checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', updateTotal);
    });
    
    updateTotal();
});
</script>
@endpush


{{-- Botón de Ayuda Contextual --}}
<x-help-button title="Crear Orden - Ayuda Rápida" :helpLink="route('help.show', 'ordenes-laboratorio')">
    <div class="help-quick-guide">
        <h5 class="text-primary"><i class="fas fa-lightbulb mr-2"></i> Guía Rápida: Crear Orden</h5>
        
        <h6 class="font-weight-bold mt-3"><i class="fas fa-list-ol text-primary mr-2"></i> Pasos:</h6>
        <ol class="small">
            <li><strong>Selecciona el paciente</strong> (o regístralo si no existe)</li>
            <li><strong>Elige la clínica</strong> donde se realizará</li>
            <li><strong>Marca los exámenes</strong> necesarios</li>
            <li><strong>Revisa el total</strong> y confirma</li>
            <li><strong>Guarda la orden</strong></li>
        </ol>

        <h6 class="font-weight-bold mt-3"><i class="fas fa-search text-info mr-2"></i> Buscar Exámenes</h6>
        <p class="small">Usa el campo de búsqueda para filtrar exámenes por nombre o categoría. La búsqueda es en tiempo real.</p>

        <h6 class="font-weight-bold mt-3"><i class="fas fa-user-plus text-success mr-2"></i> Registrar Paciente Nuevo</h6>
        <p class="small">Si el paciente no existe, haz clic en "Registrar Nuevo Paciente". Completa el formulario y se seleccionará automáticamente.</p>

        <div class="callout callout-warning mt-3">
            <h6><i class="fas fa-exclamation-triangle mr-2"></i> Datos Importantes</h6>
            <p class="small mb-0">Asegúrate de que el paciente tenga <strong>fecha de nacimiento</strong> y <strong>sexo</strong> correctos. Esto es crucial para los rangos de referencia.</p>
        </div>

        <div class="callout callout-info mt-3">
            <h6><i class="fas fa-mobile-alt mr-2"></i> Versión Móvil</h6>
            <p class="small mb-0">En móviles y tablets, el total y botones están siempre visibles en una barra inferior fija.</p>
        </div>
    </div>
</x-help-button>
