@extends('layouts.adminlte')

@section('title', 'SomosSalud | Nuevo usuario')

@section('sidebar')
    @include('panel.partials.sidebar')
@endsection

{{-- Breadcrumb removido para creación de usuario --}}

@section('content')
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-lg rounded-lg overflow-hidden">
                <div class="card-header text-white p-4" style="background: linear-gradient(to right, #0ea5e9, #10b981);">
                    <div class="d-flex align-items-center">
                        <h3 class="card-title mb-0 font-weight-bold text-white">
                            <i class="fas fa-user-plus mr-2"></i>Nuevo Usuario
                        </h3>
                        <span class="mx-3 text-white-50">|</span>
                        <p class="mb-0 small text-white-50">Registra un nuevo usuario en el sistema</p>
                    </div>
                </div>
                
                <form action="{{ route('admin.users.store') }}" method="POST">
                    @csrf
                    
                    <div class="card-body p-4">
                        @if ($errors->any())
                            <div class="alert alert-danger border-left-danger shadow-sm rounded-lg mb-4" role="alert">
                                <div class="d-flex align-items-center mb-2">
                                    <i class="fas fa-exclamation-circle mr-2 text-lg"></i>
                                    <h5 class="alert-heading mb-0 font-weight-bold">Por favor corrige los siguientes errores:</h5>
                                </div>
                                <ul class="mb-0 pl-4 small">
                                    @foreach ($errors->all() as $error)
                                        <li>{{ $error }}</li>
                                    @endforeach
                                </ul>
                            </div>
                        @endif

                        <div class="row">
                            <div class="col-md-12 mb-4">
                                <h5 class="text-muted font-weight-bold text-uppercase small border-bottom pb-2 mb-3">
                                    <i class="fas fa-info-circle mr-1"></i> Información Personal
                                </h5>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="name" class="font-weight-bold text-dark small text-uppercase">Nombre completo <span class="text-danger">*</span></label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i class="fas fa-user text-muted"></i></span>
                                        </div>
                                        <input type="text" name="name" id="name" value="{{ old('name') }}"
                                            class="form-control border-left-0 @error('name') is-invalid @enderror" 
                                            placeholder="Ej: Juan Pérez" required autofocus>
                                    </div>
                                    @error('name')
                                        <span class="invalid-feedback d-block" role="alert"><strong>{{ $message }}</strong></span>
                                    @enderror
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="font-weight-bold text-dark small text-uppercase">Tipo de Usuario</label>
                                    <div class="custom-control custom-checkbox mt-2">
                                        <input type="checkbox" class="custom-control-input" id="es_dependiente" name="es_dependiente" value="1" {{ old('es_dependiente') ? 'checked' : '' }}>
                                        <label class="custom-control-label font-weight-bold" for="es_dependiente">
                                            <i class="fas fa-child mr-1"></i> Es un dependiente (hijo/a)
                                        </label>
                                    </div>
                                    <small class="form-text text-muted mt-1">
                                        <i class="fas fa-info-circle mr-1"></i>Marca si es un niño sin cédula propia.
                                    </small>
                                </div>
                            </div>

                            <div id="representante-field" class="col-md-12" style="{{ old('es_dependiente') ? '' : 'display: none;' }}">
                                <div class="form-group">
                                    <label for="representante_id" class="font-weight-bold text-dark small text-uppercase">
                                        Representante (Padre/Madre) <span class="text-danger">*</span>
                                    </label>
                                    <div class="input-group shadow-sm flex-nowrap">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i class="fas fa-user-friends text-muted"></i></span>
                                        </div>
                                        <select name="representante_id" id="representante_id" class="form-control select2-representante" style="width: 100%;">
                                            <option value="">Buscar representante por nombre o cédula...</option>
                                            @foreach($posiblesRepresentantes as $rep)
                                                <option value="{{ $rep->id }}"
                                                    data-cedula="{{ $rep->cedula }}"
                                                    data-email="{{ $rep->email }}"
                                                    {{ old('representante_id') == $rep->id ? 'selected' : '' }}>
                                                    {{ $rep->name }} ({{ $rep->cedula }})
                                                </option>
                                            @endforeach
                                        </select>
                                    </div>
                                    <small class="form-text text-muted mt-1">
                                        <i class="fas fa-info-circle mr-1"></i>La cédula y email se copiarán automáticamente del representante.
                                    </small>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="cedula" class="font-weight-bold text-dark small text-uppercase">Cédula <span class="text-danger">*</span></label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i class="fas fa-id-card text-muted"></i></span>
                                        </div>
                                        <input type="text" name="cedula" id="cedula" value="{{ old('cedula') }}"
                                            class="form-control border-left-0 @error('cedula') is-invalid @enderror" 
                                            placeholder="Ej: V-12345678" required {{ old('es_dependiente') ? 'readonly' : '' }}>
                                    </div>
                                    <small class="form-text text-muted mt-1" id="cedula-help">
                                        @if(old('es_dependiente'))
                                            <i class="fas fa-lock mr-1"></i>La cédula se genera automáticamente basada en el representante.
                                        @else
                                            <i class="fas fa-info-circle mr-1"></i>Si empiezas con un número, se asume V- automáticamente.
                                        @endif
                                    </small>
                                    @error('cedula')
                                        <span class="invalid-feedback d-block" role="alert"><strong>{{ $message }}</strong></span>
                                    @enderror
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="email" class="font-weight-bold text-dark small text-uppercase">Correo electrónico <span class="text-danger">*</span></label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i class="fas fa-envelope text-muted"></i></span>
                                        </div>
                                        <input type="email" name="email" id="email" value="{{ old('email') }}"
                                            class="form-control border-left-0 @error('email') is-invalid @enderror" 
                                            placeholder="correo@ejemplo.com" required {{ old('es_dependiente') && old('representante_id') ? 'readonly' : '' }}>
                                    </div>
                                    @error('email')
                                        <span class="invalid-feedback d-block" role="alert"><strong>{{ $message }}</strong></span>
                                    @enderror
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="telefono" class="font-weight-bold text-dark small text-uppercase">Teléfono <span class="text-muted font-weight-normal text-lowercase">(WhatsApp)</span></label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i class="fab fa-whatsapp text-muted"></i></span>
                                        </div>
                                        <input type="text" name="telefono" id="telefono" value="{{ old('telefono') }}"
                                            class="form-control border-left-0 @error('telefono') is-invalid @enderror" 
                                            placeholder="Ej: 0414-1234567" maxlength="20">
                                    </div>
                                    <small class="form-text text-muted mt-1"><i class="fas fa-info-circle mr-1"></i>Formato: 0414-1234567 (Movistar, Digitel, Movilnet)</small>
                                    @error('telefono')
                                        <span class="invalid-feedback d-block" role="alert"><strong>{{ $message }}</strong></span>
                                    @enderror
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="fecha_nacimiento" class="font-weight-bold text-dark small text-uppercase">Fecha de Nacimiento <span class="text-danger">*</span></label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i class="fas fa-calendar text-muted"></i></span>
                                        </div>
                                        <input type="date" name="fecha_nacimiento" id="fecha_nacimiento" value="{{ old('fecha_nacimiento') }}"
                                            class="form-control border-left-0 @error('fecha_nacimiento') is-invalid @enderror" 
                                            max="{{ date('Y-m-d') }}" required>
                                    </div>
                                    <small class="form-text text-muted mt-1"><i class="fas fa-info-circle mr-1"></i>Importante para el historial médico.</small>
                                    @error('fecha_nacimiento')
                                        <span class="invalid-feedback d-block" role="alert"><strong>{{ $message }}</strong></span>
                                    @enderror
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="sexo" class="font-weight-bold text-dark small text-uppercase">Sexo <span class="text-danger">*</span></label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i class="fas fa-venus-mars text-muted"></i></span>
                                        </div>
                                        <select name="sexo" id="sexo" class="form-control border-left-0 @error('sexo') is-invalid @enderror" required>
                                            <option value="">Seleccione...</option>
                                            <option value="M" {{ old('sexo') == 'M' ? 'selected' : '' }}>Masculino</option>
                                            <option value="F" {{ old('sexo') == 'F' ? 'selected' : '' }}>Femenino</option>
                                        </select>
                                    </div>
                                    <small class="form-text text-muted mt-1"><i class="fas fa-info-circle mr-1"></i>Necesario para valores de referencia de laboratorio.</small>
                                    @error('sexo')
                                        <span class="invalid-feedback d-block" role="alert"><strong>{{ $message }}</strong></span>
                                    @enderror
                                </div>
                            </div>

                            <div class="col-md-12 mt-3 mb-4">
                                <h5 class="text-muted font-weight-bold text-uppercase small border-bottom pb-2 mb-3">
                                    <i class="fas fa-lock mr-1"></i> Seguridad
                                </h5>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="password" class="font-weight-bold text-dark small text-uppercase">Contraseña <span class="text-danger">*</span></label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i class="fas fa-key text-muted"></i></span>
                                        </div>
                                        <input type="password" name="password" id="password"
                                            class="form-control border-left-0 @error('password') is-invalid @enderror" 
                                            placeholder="Mínimo 8 caracteres" required autocomplete="new-password">
                                    </div>
                                    @error('password')
                                        <span class="invalid-feedback d-block" role="alert"><strong>{{ $message }}</strong></span>
                                    @enderror
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="password_confirmation" class="font-weight-bold text-dark small text-uppercase">Confirmar Contraseña <span class="text-danger">*</span></label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i class="fas fa-check-double text-muted"></i></span>
                                        </div>
                                        <input type="password" name="password_confirmation" id="password_confirmation"
                                            class="form-control border-left-0" 
                                            placeholder="Repite la contraseña" required autocomplete="new-password">
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-12 mt-3 mb-4">
                                <h5 class="text-muted font-weight-bold text-uppercase small border-bottom pb-2 mb-3">
                                    <i class="fas fa-user-tag mr-1"></i> Roles y Permisos
                                </h5>
                            </div>

                            <div class="col-md-12">
                                <div class="form-group">
                                    <label class="font-weight-bold text-dark small text-uppercase mb-3">Roles Asignados</label>
                                    @if (auth()->user()->hasRole('recepcionista') && !auth()->user()->hasAnyRole(['super-admin','admin_clinica']))
                                        <div class="alert alert-info shadow-sm border-0">
                                            <i class="fas fa-info-circle mr-2"></i>
                                            <span class="font-weight-bold">Rol: Paciente</span>
                                            <input type="hidden" name="roles[]" value="paciente">
                                            <div class="mt-1 small">Como recepcionista, solo puedes crear usuarios con rol de Paciente.</div>
                                        </div>
                                    @else
                                        <div class="bg-light p-3 rounded border">
                                            <div class="d-flex flex-wrap gap-3">
                                                @foreach ($roles as $role)
                                                    @php
                                                        $roleId = 'role-' . \Illuminate\Support\Str::slug($role);
                                                        $isChecked = in_array($role, old('roles', []), true);
                                                        $badgeClass = match($role) {
                                                            'admin' => 'danger',
                                                            'especialista' => 'success',
                                                            'recepcionista' => 'warning',
                                                            'paciente' => 'info',
                                                            default => 'secondary'
                                                        };
                                                    @endphp
                                                    <div class="custom-control custom-checkbox mr-4 mb-2">
                                                        <input type="checkbox" class="custom-control-input role-checkbox" id="{{ $roleId }}"
                                                            name="roles[]" value="{{ $role }}" {{ $isChecked ? 'checked' : '' }}>
                                                        <label class="custom-control-label font-weight-bold text-{{ $badgeClass }}" for="{{ $roleId }}">
                                                            {{ ucfirst(str_replace('_', ' ', $role)) }}
                                                        </label>
                                                    </div>
                                                @endforeach
                                            </div>
                                        </div>
                                        @error('roles')
                                            <span class="text-danger d-block mt-2 small font-weight-bold"><i class="fas fa-exclamation-triangle mr-1"></i>{{ $message }}</span>
                                        @enderror
                                    @endif
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="especialidades" class="font-weight-bold text-dark small text-uppercase">Especialidades <span class="text-muted font-weight-normal text-lowercase">(Solo para especialistas)</span></label>
                                    <div class="input-group shadow-sm flex-nowrap">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i class="fas fa-stethoscope text-muted"></i></span>
                                        </div>
                                        <select name="especialidades[]" id="especialidades" class="form-control border-left-0 @error('especialidades') is-invalid @enderror" multiple {{ (auth()->user()->hasRole('recepcionista') && !auth()->user()->hasAnyRole(['super-admin','admin_clinica'])) ? 'disabled' : '' }} style="width: 100%;">
                                            @php
                                                $selectedEspecialidades = old('especialidades', []);
                                            @endphp
                                            @foreach ($especialidades as $especialidad)
                                                <option value="{{ $especialidad->id }}" {{ in_array($especialidad->id, $selectedEspecialidades) ? 'selected' : '' }}>
                                                    {{ $especialidad->nombre }}
                                                </option>
                                            @endforeach
                                        </select>
                                    </div>
                                    <small class="form-text text-muted mt-1">
                                        @if (auth()->user()->hasRole('recepcionista') && !auth()->user()->hasAnyRole(['super-admin','admin_clinica']))
                                            <i class="fas fa-lock mr-1"></i>Campo no disponible para recepcionistas.
                                        @else
                                            <i class="fas fa-info-circle mr-1"></i>Se habilita cuando el rol "Especialista" está seleccionado.
                                        @endif
                                    </small>
                                    @error('especialidades')
                                        <span class="invalid-feedback d-block" role="alert"><strong>{{ $message }}</strong></span>
                                    @enderror
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card-footer bg-light p-4 d-flex justify-content-between align-items-center">
                        <a href="{{ route('admin.users.index') }}" class="btn btn-outline-secondary font-weight-bold px-4">
                            <i class="fas fa-arrow-left mr-2"></i>Cancelar
                        </a>
                        <button type="submit" class="btn btn-primary font-weight-bold px-5 shadow-sm">
                            <i class="fas fa-save mr-2"></i>Guardar Usuario
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
@endsection

@push('styles')
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/choices.js/public/assets/styles/choices.min.css" />
{{-- Select2 CSS: ya se carga globalmente en `layouts.adminlte` --}}
<style>
    /* Normalize Select2 appearance to match form controls */
    .select2-container--bootstrap4 .select2-selection {
        border: 1px solid #ced4da !important;
        border-left: 0 !important; /* Merge with icon */
        border-radius: 0 0.25rem 0.25rem 0 !important;
        min-height: calc(2.25rem + 2px) !important;
        padding: 0.375rem 0.75rem !important;
        display: flex !important;
        align-items: center !important;
    }

    /* Focus state */
    .select2-container--bootstrap4.select2-container--focus .select2-selection {
        border-color: #80bdff !important;
        box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25) !important;
    }

    /* Multiple select specific */
    .select2-container--bootstrap4 .select2-selection--multiple {
        padding: 0.25rem 0.5rem !important;
    }

    /* Chips styling */
    .select2-container--bootstrap4 .select2-selection__choice {
        background-color: #e3f2fd !important;
        border: 1px solid #90caf9 !important;
        color: #1565c0 !important;
        border-radius: 20px !important;
        padding: 2px 8px !important;
        font-size: 0.85rem !important;
        margin-top: 4px !important;
        margin-right: 4px !important;
    }

    .select2-container--bootstrap4 .select2-selection__choice__remove {
        color: #1565c0 !important;
        margin-right: 5px !important;
        font-weight: bold !important;
    }

    .select2-container--bootstrap4 .select2-selection__choice__remove:hover {
        color: #0d47a1 !important;
    }

    /* Dropdown styling */
    .select2-container--bootstrap4 .select2-dropdown {
        border-color: #ced4da !important;
        border-radius: 0.25rem !important;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15) !important;
    }

    .select2-results__option {
        padding: 8px 12px !important;
        font-size: 0.95rem !important;
    }

    .select2-container--bootstrap4 .select2-results__option--highlighted[aria-selected] {
        background-color: #0ea5e9 !important; /* Premium blue */
        background: linear-gradient(to right, #0ea5e9, #0284c7) !important;
    }

    /* Ensure full width in input groups */
    .input-group .select2-container--bootstrap4 {
        flex: 1 1 auto !important;
        width: 1% !important; /* Force flex behavior */
    }

    /* Fix search field alignment and text position */
    .select2-container--bootstrap4 .select2-search__field {
        text-align: left !important;
        margin-top: 7px !important;
        margin-left: 4px !important;
    }

    /* Ensure the container aligns items to the start */
    .select2-container--bootstrap4 .select2-selection__rendered {
        text-align: left !important;
        display: flex !important;
        flex-wrap: wrap !important;
        align-items: center !important;
        width: 100% !important;
    }

    /* Choices.js Custom Styles for Premium Look */
    .choices {
        flex-grow: 1;
        margin-bottom: 0;
        width: 1% !important; /* Force flex behavior in input-group */
    }
    
    .choices__inner {
        min-height: calc(2.25rem + 2px);
        padding: 0.25rem 0.75rem;
        background-color: #fff;
        border: 1px solid #ced4da;
        border-left: 0;
        border-radius: 0 0.25rem 0.25rem 0;
        font-size: 1rem;
        display: flex;
        align-items: center;
        flex-wrap: wrap;
    }

    .choices.is-focused .choices__inner {
        border-color: #80bdff;
        box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
    }

    .choices__list--multiple .choices__item {
        background: linear-gradient(to right, #0ea5e9, #0284c7);
        border: none;
        border-radius: 20px;
        padding: 4px 10px;
        font-size: 0.85rem;
        margin-right: 5px;
    }

    .choices__list--multiple .choices__item.is-highlighted {
        background: #0284c7;
        border: none;
    }

    .choices__input {
        background-color: transparent;
        margin-bottom: 0;
        padding: 4px 0;
    }

    .choices__list--dropdown {
        border-color: #ced4da;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        border-radius: 0.25rem;
        margin-top: 5px;
    }

    .choices__list--dropdown .choices__item--selectable.is-highlighted {
        background-color: #e3f2fd;
        color: #0284c7;
    }

</style>
@endpush

@push('scripts')
<script src="https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"></script>
<script src="{{ asset('js/cedula-validator.js') }}"></script>
<script>
$(document).ready(function() {
    // Inicializar Select2 para representante (Mantenemos Select2 aquí por su soporte AJAX robusto)
    $('.select2-representante').select2({
        theme: 'bootstrap4',
        placeholder: 'Buscar representante por nombre o cédula...',
        allowClear: true,
        width: '100%'
    });
    
    // Inicializar validador de cédula
    if (typeof CedulaValidator !== 'undefined') {
        new CedulaValidator('cedula');
    }
});

document.addEventListener('DOMContentLoaded', function () {
    // Inicializar Choices.js para especialidades
    const especialidadSelect = document.getElementById('especialidades');
    let choicesInstance = null;

    if (especialidadSelect) {
        choicesInstance = new Choices(especialidadSelect, {
            removeItemButton: true,
            placeholder: true,
            placeholderValue: 'Selecciona especialidades',
            searchPlaceholderValue: 'Buscar especialidad...',
            itemSelectText: '',
            noResultsText: 'No se encontraron resultados',
            noChoicesText: 'No hay más opciones',
            loadingText: 'Cargando...',
        });

        // Lógica para roles y especialidades
        const roleCheckboxes = Array.from(document.querySelectorAll('.role-checkbox'));

        function toggleEspecialidad() {
            const specialistSelected = roleCheckboxes.some(function (checkbox) {
                return checkbox.checked && checkbox.value === 'especialista';
            });
            
            if (specialistSelected) {
                choicesInstance.enable();
            } else {
                choicesInstance.disable();
            }
        }

        roleCheckboxes.forEach(function (checkbox) {
            checkbox.addEventListener('change', toggleEspecialidad);
        });
        
        // Ejecutar al inicio
        toggleEspecialidad();
    }

    // Lógica para dependientes
    const esDependienteCheckbox = document.getElementById('es_dependiente');
    const representanteField = document.getElementById('representante-field');
    const cedulaInput = document.getElementById('cedula');
    const emailInput = document.getElementById('email');
    const cedulaHelp = document.getElementById('cedula-help');

    // Función para manejar la selección del representante
    function handleRepresentativeSelection(cedula, email) {
        if (cedula && email) {
            generarCedulaDependiente(cedula);
            emailInput.value = email;
            emailInput.readOnly = true;
        } else {
            // Si se limpia la selección
            if (esDependienteCheckbox.checked) {
                cedulaInput.value = '';
                emailInput.value = '';
                emailInput.readOnly = false;
            }
        }
    }

    // Evento de cambio en Select2 de representante
    $('.select2-representante').on('select2:select', function (e) {
        var data = e.params.data;
        // Obtenemos los atributos data del elemento option seleccionado
        var element = $(data.element);
        var cedula = element.data('cedula');
        var email = element.data('email');
        handleRepresentativeSelection(cedula, email);
    });

    $('.select2-representante').on('select2:clear', function (e) {
        cedulaInput.value = '';
        emailInput.value = '';
        emailInput.readOnly = false;
    });

    // Toggle de campos de dependiente
    esDependienteCheckbox.addEventListener('change', function () {
        if (this.checked) {
            representanteField.style.display = 'block';
            cedulaInput.readOnly = true;
            cedulaInput.placeholder = 'Se generará automáticamente';
            cedulaHelp.innerHTML = '<i class="fas fa-lock mr-1"></i>La cédula se genera automáticamente basada en el representante.';
            
            // Si ya hay un representante seleccionado, asegurar que los campos estén bloqueados
            if ($('.select2-representante').val()) {
                emailInput.readOnly = true;
            }
        } else {
            representanteField.style.display = 'none';
            cedulaInput.readOnly = false;
            cedulaInput.placeholder = 'Ej: V-12345678';
            cedulaInput.value = '';
            emailInput.value = '';
            emailInput.readOnly = false;
            cedulaHelp.innerHTML = '<i class="fas fa-info-circle mr-1"></i>Si empiezas con un número, se asume V- automáticamente.';
            
            // Limpiar selección de representante
            $('.select2-representante').val(null).trigger('change');
        }
    });

    function generarCedulaDependiente(cedulaRepresentante) {
        // Obtener el ID del representante seleccionado
        const representanteId = $('.select2-representante').val();
        if (!representanteId) return;

        const url = `{{ url('admin/users/next-dependent-number') }}/${representanteId}`;
        
        cedulaInput.value = 'Generando...';
        
        fetch(url)
            .then(response => response.json())
            .then(data => {
                const siguienteNumero = data.next_number || 1;
                const cedulaDependiente = `${cedulaRepresentante}-H${siguienteNumero}`;
                cedulaInput.value = cedulaDependiente;
            })
            .catch(error => {
                console.error('Error generando cédula:', error);
                const cedulaDependiente = `${cedulaRepresentante}-H1`;
                cedulaInput.value = cedulaDependiente;
            });
    }
});
</script>
@endpush