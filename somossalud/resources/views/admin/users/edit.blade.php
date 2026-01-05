@extends('layouts.adminlte')

@section('title', 'SomosSalud | Editar usuario')

@section('sidebar')
    @include('panel.partials.sidebar')
@endsection

{{-- Breadcrumb removido para edición de usuario --}}

@section('content')
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-lg rounded-lg overflow-hidden">
                <div class="card-header text-white p-4" style="background: linear-gradient(to right, #0ea5e9, #10b981);">
                    <div class="d-flex align-items-center">
                        <h3 class="card-title mb-0 font-weight-bold text-white">
                            <i class="fas fa-user-edit mr-2"></i>Editar Usuario
                        </h3>
                        <span class="mx-3 text-white-50">|</span>
                        <p class="mb-0 small text-white-50">Actualiza la información del usuario en el sistema</p>
                    </div>
                </div>

                <form id="user-form" action="{{ route('admin.users.update', $usuario) }}" method="POST" enctype="multipart/form-data">
                    @csrf
                    @method('PUT')

                    <div class="card-body p-4">
                        @if ($errors->any())
                            <div class="alert alert-danger border-left-danger shadow-sm rounded-lg mb-4" role="alert">
                                <div class="d-flex align-items-center mb-2">
                                    <i class="fas fa-exclamation-circle mr-2 text-lg"></i>
                                    <h5 class="alert-heading mb-0 font-weight-bold">Por favor corrige los siguientes errores:
                                    </h5>
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
                                    <label for="name" class="font-weight-bold text-dark small text-uppercase">Nombre
                                        completo <span class="text-danger">*</span></label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i
                                                    class="fas fa-user text-muted"></i></span>
                                        </div>
                                        <input type="text" name="name" id="name" value="{{ old('name', $usuario->name) }}"
                                            class="form-control border-left-0 @error('name') is-invalid @enderror"
                                            placeholder="Ej: Juan Pérez" required autofocus>
                                    </div>
                                    @error('name')
                                        <span class="invalid-feedback d-block"
                                            role="alert"><strong>{{ $message }}</strong></span>
                                    @enderror
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="cedula" class="font-weight-bold text-dark small text-uppercase">Cédula <span
                                            class="text-danger">*</span></label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i
                                                    class="fas fa-id-card text-muted"></i></span>
                                        </div>
                                        <input type="text" name="cedula" id="cedula"
                                            value="{{ old('cedula', $usuario->cedula) }}"
                                            class="form-control border-left-0 @error('cedula') is-invalid @enderror"
                                            placeholder="Ej: V-12345678" required>
                                    </div>
                                    <small class="form-text text-muted mt-1"><i class="fas fa-info-circle mr-1"></i>Si
                                        empiezas con un número, se asume V- automáticamente.</small>
                                    @error('cedula')
                                        <span class="invalid-feedback d-block"
                                            role="alert"><strong>{{ $message }}</strong></span>
                                    @enderror
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="email" class="font-weight-bold text-dark small text-uppercase">Correo
                                        electrónico <span class="text-danger">*</span></label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i
                                                    class="fas fa-envelope text-muted"></i></span>
                                        </div>
                                        <input type="email" name="email" id="email"
                                            value="{{ old('email', $usuario->email) }}"
                                            class="form-control border-left-0 @error('email') is-invalid @enderror"
                                            placeholder="correo@ejemplo.com" required>
                                    </div>
                                    @error('email')
                                        <span class="invalid-feedback d-block"
                                            role="alert"><strong>{{ $message }}</strong></span>
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
                                        <input type="text" name="telefono" id="telefono" value="{{ old('telefono', $usuario->telefono) }}"
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
                                    <label for="fecha_nacimiento"
                                        class="font-weight-bold text-dark small text-uppercase">Fecha de Nacimiento <span
                                            class="text-danger">*</span></label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i
                                                    class="fas fa-calendar text-muted"></i></span>
                                        </div>
                                        <input type="date" name="fecha_nacimiento" id="fecha_nacimiento"
                                            value="{{ old('fecha_nacimiento', $usuario->fecha_nacimiento) }}"
                                            class="form-control border-left-0 @error('fecha_nacimiento') is-invalid @enderror"
                                            max="{{ date('Y-m-d') }}" required>
                                    </div>
                                    <small class="form-text text-muted mt-1"><i
                                            class="fas fa-info-circle mr-1"></i>Importante para el historial médico.</small>
                                    @error('fecha_nacimiento')
                                        <span class="invalid-feedback d-block"
                                            role="alert"><strong>{{ $message }}</strong></span>
                                    @enderror
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="sexo" class="font-weight-bold text-dark small text-uppercase">Sexo <span
                                            class="text-danger">*</span></label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i
                                                    class="fas fa-venus-mars text-muted"></i></span>
                                        </div>
                                        <select name="sexo" id="sexo"
                                            class="form-control border-left-0 @error('sexo') is-invalid @enderror" required>
                                            <option value="">Seleccione...</option>
                                            <option value="M" {{ old('sexo', $usuario->sexo) == 'M' ? 'selected' : '' }}>
                                                Masculino</option>
                                            <option value="F" {{ old('sexo', $usuario->sexo) == 'F' ? 'selected' : '' }}>
                                                Femenino</option>
                                        </select>
                                    </div>
                                    <small class="form-text text-muted mt-1"><i
                                            class="fas fa-info-circle mr-1"></i>Necesario para valores de referencia de
                                        laboratorio.</small>
                                    @error('sexo')
                                        <span class="invalid-feedback d-block"
                                            role="alert"><strong>{{ $message }}</strong></span>
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
                                    <label for="password" class="font-weight-bold text-dark small text-uppercase">Nueva
                                        Contraseña</label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i
                                                    class="fas fa-key text-muted"></i></span>
                                        </div>
                                        <input type="password" name="password" id="password"
                                            class="form-control border-left-0 @error('password') is-invalid @enderror"
                                            placeholder="Mínimo 8 caracteres" autocomplete="new-password">
                                    </div>
                                    <small class="form-text text-muted mt-1"><i class="fas fa-info-circle mr-1"></i>Dejar en
                                        blanco para mantener la actual.</small>
                                    @error('password')
                                        <span class="invalid-feedback d-block"
                                            role="alert"><strong>{{ $message }}</strong></span>
                                    @enderror
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="password_confirmation"
                                        class="font-weight-bold text-dark small text-uppercase">Confirmar Contraseña</label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0"><i
                                                    class="fas fa-check-double text-muted"></i></span>
                                        </div>
                                        <input type="password" name="password_confirmation" id="password_confirmation"
                                            class="form-control border-left-0" placeholder="Repite la contraseña"
                                            autocomplete="new-password">
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-12 mt-3 mb-4">
                                <h5 class="text-muted font-weight-bold text-uppercase small border-bottom pb-2 mb-3">
                                    <i class="fas fa-signature mr-1"></i> Firma Digitalizada
                                </h5>
                            </div>

                            @if($usuario->firma)
                                <div class="col-md-12">
                                    <div class="alert alert-info border-0 shadow-sm">
                                        <div class="row align-items-center">
                                            <div class="col-md-8">
                                                <div class="text-center mb-3">
                                                    @if(\Storage::disk('public')->exists($usuario->firma))
                                                        @php
                                                            $firmaContent = \Storage::disk('public')->get($usuario->firma);
                                                            $firmaMime = \Storage::disk('public')->mimeType($usuario->firma);
                                                        @endphp
                                                        <img src="data:{{ $firmaMime }};base64,{{ base64_encode($firmaContent) }}" alt="Firma" class="img-fluid" style="max-height: 150px; border: 1px solid #e2e8f0; border-radius: 8px; padding: 10px; background: white;">
                                                    @else
                                                        <p class="text-danger">Archivo de firma no encontrado.</p>
                                                    @endif
                                                </div>
                                            </div>
                                            <div class="col-md-4 text-right">
                                                <button type="button" class="btn btn-danger btn-sm" id="btn-delete-firma">
                                                    <i class="fas fa-trash mr-1"></i> Eliminar Firma
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            @endif

                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="firma" class="font-weight-bold text-dark small text-uppercase">
                                        {{ $usuario->firma ? 'Cambiar Firma' : 'Subir Firma' }}
                                    </label>
                                    <div class="input-group shadow-sm">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-right-0">
                                                <i class="fas fa-upload text-muted"></i>
                                            </span>
                                        </div>
                                        <div class="custom-file">
                                            <input type="file" name="firma" id="firma" class="custom-file-input @error('firma') is-invalid @enderror" accept="image/*">
                                            <label class="custom-file-label" for="firma">Seleccionar imagen...</label>
                                        </div>
                                    </div>
                                    <small class="form-text text-muted mt-1">
                                        <i class="fas fa-info-circle mr-1"></i>Formatos permitidos: JPG, PNG, GIF. Tamaño máximo: 2MB
                                    </small>
                                    @error('firma')
                                        <span class="invalid-feedback d-block" role="alert"><strong>{{ $message }}</strong></span>
                                    @enderror
                                </div>
                            </div>

                            <div class="col-md-12 mt-3 mb-4">
                                <h5 class="text-muted font-weight-bold text-uppercase small border-bottom pb-2 mb-3">
                                    <i class="fas fa-user-tag mr-1"></i> Roles y Permisos
                                </h5>
                            </div>

                            <div class="col-md-12">
                                <div class="form-group">
                                    <label class="font-weight-bold text-dark small text-uppercase mb-3">Roles
                                        Asignados</label>
                                    @if (auth()->user()->hasRole('recepcionista') && !auth()->user()->hasAnyRole(['super-admin', 'admin_clinica']))
                                        <div class="alert alert-info shadow-sm border-0">
                                            <i class="fas fa-info-circle mr-2"></i>
                                            <span class="font-weight-bold">Rol: Paciente</span>
                                            <input type="hidden" name="roles[]" value="paciente">
                                            <div class="mt-1 small">Como recepcionista, solo puedes gestionar usuarios con rol
                                                de Paciente.</div>
                                        </div>
                                    @else
                                        <div class="bg-light p-3 rounded border">
                                            <div class="d-flex flex-wrap gap-3">
                                                @php
                                                    $selectedRoles = old('roles', $assignedRoles ?? []);
                                                @endphp
                                                @foreach ($roles as $role)
                                                    @php
                                                        $roleId = 'role-' . \Illuminate\Support\Str::slug($role);
                                                        $isChecked = in_array($role, $selectedRoles, true);
                                                        $badgeClass = match ($role) {
                                                            'admin' => 'danger',
                                                            'especialista' => 'success',
                                                            'recepcionista' => 'warning',
                                                            'paciente' => 'info',
                                                            default => 'secondary'
                                                        };
                                                    @endphp
                                                    <div class="custom-control custom-checkbox mr-4 mb-2">
                                                        <input type="checkbox" class="custom-control-input role-checkbox"
                                                            id="{{ $roleId }}" name="roles[]" value="{{ $role }}" {{ $isChecked ? 'checked' : '' }}>
                                                        <label class="custom-control-label font-weight-bold text-{{ $badgeClass }}"
                                                            for="{{ $roleId }}">
                                                            {{ ucfirst(str_replace('_', ' ', $role)) }}
                                                        </label>
                                                    </div>
                                                @endforeach
                                            </div>
                                        </div>
                                        @error('roles')
                                            <span class="text-danger d-block mt-2 small font-weight-bold"><i
                                                    class="fas fa-exclamation-triangle mr-1"></i>{{ $message }}</span>
                                        @enderror
                                    @endif
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="especialidades"
                                        class="font-weight-bold text-dark small text-uppercase">Especialidades <span
                                            class="text-muted font-weight-normal text-lowercase">(Solo para
                                            especialistas)</span></label>
                                    <div
                                        class="d-flex align-items-stretch shadow-sm border rounded overflow-hidden bg-white">
                                        <div class="d-flex align-items-center px-3 bg-white border-right">
                                            <i class="fas fa-stethoscope text-muted"></i>
                                        </div>
                                        <div class="flex-grow-1">
                                            <select name="especialidades[]" id="especialidades"
                                                class="form-control border-0 @error('especialidades') is-invalid @enderror"
                                                multiple {{ (auth()->user()->hasRole('recepcionista') && !auth()->user()->hasAnyRole(['super-admin', 'admin_clinica'])) ? 'disabled' : '' }} style="width: 100%;">
                                                @php
                                                    $selectedEspecialidades = old('especialidades', $usuario->especialidades->pluck('id')->toArray() ?? []);
                                                @endphp
                                                @foreach ($especialidades as $especialidad)
                                                    <option value="{{ $especialidad->id }}" {{ in_array($especialidad->id, $selectedEspecialidades) ? 'selected' : '' }}>
                                                        {{ $especialidad->nombre }}
                                                    </option>
                                                @endforeach
                                            </select>
                                        </div>
                                    </div>
                                    <small class="form-text text-muted mt-1">
                                        @if (auth()->user()->hasRole('recepcionista') && !auth()->user()->hasAnyRole(['super-admin', 'admin_clinica']))
                                            <i class="fas fa-lock mr-1"></i>Campo no disponible para recepcionistas.
                                        @else
                                            <i class="fas fa-info-circle mr-1"></i>Se habilita cuando el rol "Especialista" está
                                            seleccionado.
                                        @endif
                                    </small>
                                    @error('especialidades')
                                        <span class="invalid-feedback d-block"
                                            role="alert"><strong>{{ $message }}</strong></span>
                                    @enderror
                                </div>
                            </div>
                        </div>
                    </div>

                </form>

                <div class="card-footer bg-light p-4 d-flex justify-content-between align-items-center">
                    <a href="{{ route('admin.users.index') }}" class="btn btn-outline-secondary font-weight-bold px-4">
                        <i class="fas fa-arrow-left mr-2"></i>Cancelar
                    </a>
                    <div class="d-flex gap-2">
                        <button type="button" id="btn-password-reset" class="btn btn-warning font-weight-bold px-4 shadow-sm mr-2"
                            data-reset-url="{{ route('admin.users.password-reset', $usuario) }}"
                            title="Enviar correo de recuperación de contraseña">
                            <i class="fas fa-envelope mr-2"></i>Solicitar cambio de contraseña
                        </button>
                        <button type="submit" form="user-form" class="btn btn-primary font-weight-bold px-5 shadow-sm">
                            <i class="fas fa-save mr-2"></i>Guardar Cambios
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection

@push('styles')
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
@endpush

@push('scripts')
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script src="{{ asset('js/cedula-validator.js') }}"></script>
    <script>
        $(document).ready(function () {
            $('#especialidades').select2({
                placeholder: "Selecciona especialidades",
                allowClear: true,
                width: '100%'
            });

            // Inicializar validador de cédula
            new CedulaValidator('cedula');
        });
    </script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const roleCheckboxes = Array.from(document.querySelectorAll('.role-checkbox'));
            const especialidadSelect = document.getElementById('especialidades'); // ID corrected to match the select element

            if (!especialidadSelect) {
                return;
            }

            function toggleEspecialidad() {
                const specialistSelected = roleCheckboxes.some(function (checkbox) {
                    return checkbox.checked && checkbox.value === 'especialista';
                });

                especialidadSelect.disabled = !specialistSelected;
                // If using Select2, we might need to trigger an update or re-init, 
                // but standard disabled attribute usually works if Select2 respects it.
                // If Select2 is used, we can also disable the underlying select.

                // Also toggle the disabled class for visual feedback if needed, 
                // though standard disabled attribute handles this for native inputs.
            }

            roleCheckboxes.forEach(function (checkbox) {
                checkbox.addEventListener('change', toggleEspecialidad);
            });

            // Run on load to set initial state
            toggleEspecialidad();
        });

        // Password reset button handler
        document.addEventListener('DOMContentLoaded', function () {
            const btnPasswordReset = document.getElementById('btn-password-reset');
            
            if (btnPasswordReset) {
                btnPasswordReset.addEventListener('click', function () {
                    const resetUrl = this.getAttribute('data-reset-url');
                    const btn = this;
                    const originalHtml = btn.innerHTML;
                    
                    // Deshabilitar botón y mostrar estado de carga
                    btn.disabled = true;
                    btn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Enviando...';
                    
                    // Realizar petición AJAX
                    fetch(resetUrl, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
                        }
                    })
                    .then(response => response.json())
                    .then(data => {
                        // Restaurar botón
                        btn.disabled = false;
                        btn.innerHTML = originalHtml;
                        
                        // Mostrar toast de éxito
                        Swal.fire({
                            toast: true,
                            position: 'bottom-end',
                            icon: 'success',
                            title: 'Correo enviado correctamente',
                            text: 'Se ha enviado el enlace de recuperación al usuario',
                            showConfirmButton: false,
                            timer: 4000,
                            timerProgressBar: true
                        });
                    })
                    .catch(error => {
                        // Restaurar botón
                        btn.disabled = false;
                        btn.innerHTML = originalHtml;
                        
                        // Mostrar toast de error
                        Swal.fire({
                            toast: true,
                            position: 'bottom-end',
                            icon: 'error',
                            title: 'Error al enviar correo',
                            text: 'No se pudo enviar el enlace de recuperación',
                            showConfirmButton: false,
                            timer: 4000,
                            timerProgressBar: true
                        });
                    });
                });
            }
        });
    </script>
    <script>
        // Actualizar nombre del archivo seleccionado
        document.addEventListener('DOMContentLoaded', function() {
            const firmaInput = document.querySelector('#firma');
            if (firmaInput) {
                firmaInput.addEventListener('change', function(e) {
                    const fileName = e.target.files[0]?.name || 'Seleccionar imagen...';
                    const label = e.target.nextElementSibling;
                    label.textContent = fileName;
                });
            }

            // Eliminar firma
            const btnDeleteFirma = document.getElementById('btn-delete-firma');
            if (btnDeleteFirma) {
                btnDeleteFirma.addEventListener('click', function() {
                    Swal.fire({
                        title: '¿Eliminar firma?',
                        text: 'Esta acción eliminará permanentemente la firma digitalizada del usuario.',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#d33',
                        cancelButtonColor: '#3085d6',
                        confirmButtonText: 'Sí, eliminar',
                        cancelButtonText: 'Cancelar'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            // Crear formulario para enviar DELETE request
                            const form = document.createElement('form');
                            form.method = 'POST';
                            form.action = '{{ route("admin.users.firma.delete", $usuario) }}';
                            
                            const csrfToken = document.createElement('input');
                            csrfToken.type = 'hidden';
                            csrfToken.name = '_token';
                            csrfToken.value = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
                            
                            const methodField = document.createElement('input');
                            methodField.type = 'hidden';
                            methodField.name = '_method';
                            methodField.value = 'DELETE';
                            
                            form.appendChild(csrfToken);
                            form.appendChild(methodField);
                            document.body.appendChild(form);
                            form.submit();
                        }
                    });
                });
            }
        });
    </script>
@endpush