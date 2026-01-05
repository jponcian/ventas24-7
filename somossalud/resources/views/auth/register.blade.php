@extends('layouts.auth')

@section('content')
    <div class="auth-card">
        <div class="auth-card-header">
            <div class="d-flex justify-content-between align-items-start mb-3">
                <div>
                    <h1>Crear cuenta</h1>
                    <p class="auth-card-subtitle">Regístrate como paciente</p>
                </div>
                <span class="brand-pill">
                    <i class="fa-solid fa-user-plus"></i>
                    Nuevo
                </span>
            </div>
        </div>

        <form method="POST" action="{{ route('register') }}" novalidate id="registerForm">
            @csrf

            <!-- Nombre -->
            <div class="mb-4">
                <label for="name" class="form-label">
                    <i class="fa-solid fa-user me-1"></i> Nombre completo
                </label>
                <input 
                    id="name" 
                    type="text" 
                    name="name" 
                    value="{{ old('name') }}" 
                    class="form-control @error('name') is-invalid @enderror" 
                    required 
                    autofocus 
                    autocomplete="name"
                    placeholder="Ej: Juan Pérez"
                >
                @error('name')
                    <div class="invalid-feedback">
                        <i class="fa-solid fa-circle-exclamation me-1"></i>{{ $message }}
                    </div>
                @enderror
            </div>

            <!-- Correo electrónico -->
            <div class="mb-4">
                <label for="email" class="form-label">
                    <i class="fa-solid fa-envelope me-1"></i> Correo electrónico
                </label>
                <input 
                    id="email" 
                    type="email" 
                    name="email" 
                    value="{{ old('email') }}" 
                    class="form-control @error('email') is-invalid @enderror" 
                    required 
                    autocomplete="email"
                    placeholder="correo@ejemplo.com"
                >
                @error('email')
                    <div class="invalid-feedback">
                        <i class="fa-solid fa-circle-exclamation me-1"></i>{{ $message }}
                    </div>
                @enderror
            </div>

            <!-- Cédula -->
            <div class="mb-4">
                <label for="cedula" class="form-label">
                    <i class="fa-solid fa-id-card me-1"></i> Cédula
                </label>
                <input 
                    id="cedula" 
                    type="text" 
                    name="cedula" 
                    value="{{ old('cedula') }}" 
                    class="form-control @error('cedula') is-invalid @enderror" 
                    required 
                    autocomplete="username"
                    placeholder="Ej: V-12345678"
                    maxlength="12"
                >
                <small class="form-text text-muted">
                    <i class="fa-solid fa-info-circle me-1"></i>
                    Escribe tu cédula. Si empiezas con un número, se asume V- automáticamente. Ej: 12345678 → V-12345678
                </small>
                @error('cedula')
                    <div class="invalid-feedback">
                        <i class="fa-solid fa-circle-exclamation me-1"></i>{{ $message }}
                    </div>
                @enderror
            </div>

            <!-- Fecha de Nacimiento -->
            <div class="mb-4">
                <label for="fecha_nacimiento" class="form-label">
                    <i class="fa-solid fa-calendar me-1"></i> Fecha de Nacimiento
                </label>
                <input 
                    id="fecha_nacimiento" 
                    type="date" 
                    name="fecha_nacimiento" 
                    value="{{ old('fecha_nacimiento') }}" 
                    class="form-control @error('fecha_nacimiento') is-invalid @enderror" 
                    required 
                    max="{{ date('Y-m-d') }}"
                >
                <small class="form-text text-muted">
                    <i class="fa-solid fa-info-circle me-1"></i>
                    Este dato es importante para tu historial médico
                </small>
                @error('fecha_nacimiento')
                    <div class="invalid-feedback">
                        <i class="fa-solid fa-circle-exclamation me-1"></i>{{ $message }}
                    </div>
                @enderror
            </div>

            <!-- Sexo -->
            <div class="mb-4">
                <label for="sexo" class="form-label">
                    <i class="fa-solid fa-venus-mars me-1"></i> Sexo
                </label>
                <select 
                    id="sexo" 
                    name="sexo" 
                    class="form-control @error('sexo') is-invalid @enderror" 
                    required
                >
                    <option value="">Selecciona tu sexo...</option>
                    <option value="M" {{ old('sexo') == 'M' ? 'selected' : '' }}>Masculino</option>
                    <option value="F" {{ old('sexo') == 'F' ? 'selected' : '' }}>Femenino</option>
                </select>
                <small class="form-text text-muted">
                    <i class="fa-solid fa-info-circle me-1"></i>
                    Necesario para los valores de referencia de laboratorio
                </small>
                @error('sexo')
                    <div class="invalid-feedback">
                        <i class="fa-solid fa-circle-exclamation me-1"></i>{{ $message }}
                    </div>
                @enderror
            </div>

            <!-- Contraseña -->
            <div class="mb-4">
                <label for="password" class="form-label">
                    <i class="fa-solid fa-lock me-1"></i> Contraseña
                </label>
                <div class="input-group">
                    <input 
                        id="password" 
                        type="password" 
                        name="password" 
                        class="form-control @error('password') is-invalid @enderror" 
                        required 
                        autocomplete="new-password"
                        placeholder="Mínimo 8 caracteres"
                    >
                    <button type="button" class="btn btn-outline-secondary" id="togglePass" tabindex="-1">
                        <i class="fa-regular fa-eye"></i>
                    </button>
                </div>
                @error('password')
                    <div class="invalid-feedback d-block">
                        <i class="fa-solid fa-circle-exclamation me-1"></i>{{ $message }}
                    </div>
                @enderror
            </div>

            <!-- Confirmar contraseña -->
            <div class="mb-4">
                <label for="password_confirmation" class="form-label">
                    <i class="fa-solid fa-lock-keyhole me-1"></i> Confirmar contraseña
                </label>
                <div class="input-group">
                    <input 
                        id="password_confirmation" 
                        type="password" 
                        name="password_confirmation" 
                        class="form-control" 
                        required 
                        autocomplete="new-password"
                        placeholder="Repite tu contraseña"
                    >
                    <button type="button" class="btn btn-outline-secondary" id="togglePassConfirm" tabindex="-1">
                        <i class="fa-regular fa-eye"></i>
                    </button>
                </div>
            </div>

            <div class="d-grid mb-4">
                <button class="btn btn-primary" type="submit" id="registerBtn">
                    <i class="fa-solid fa-user-plus me-2"></i>
                    <span class="btn-text">Crear cuenta</span>
                </button>
            </div>

            <div class="text-center">
                <span style="color: #718096;">¿Ya tienes cuenta?</span>
                <a href="{{ route('login') }}" class="ms-1">
                    Inicia sesión aquí
                </a>
            </div>
        </form>
    </div>
@endsection

@push('scripts')
<script src="{{ asset('js/cedula-validator.js') }}"></script>
<script>
document.addEventListener('DOMContentLoaded', () => {
    // Toggle password visibility
    const togglePass = document.getElementById('togglePass');
    const password = document.getElementById('password');
    const togglePassConfirm = document.getElementById('togglePassConfirm');
    const passwordConfirm = document.getElementById('password_confirmation');
    
    if (togglePass && password) {
        togglePass.addEventListener('click', () => {
            const visible = password.type === 'text';
            password.type = visible ? 'password' : 'text';
            togglePass.innerHTML = visible ? '<i class="fa-regular fa-eye"></i>' : '<i class="fa-regular fa-eye-slash"></i>';
        });
    }
    
    if (togglePassConfirm && passwordConfirm) {
        togglePassConfirm.addEventListener('click', () => {
            const visible = passwordConfirm.type === 'text';
            passwordConfirm.type = visible ? 'password' : 'text';
            togglePassConfirm.innerHTML = visible ? '<i class="fa-regular fa-eye"></i>' : '<i class="fa-regular fa-eye-slash"></i>';
        });
    }

    // Validación y formateo de cédula con el nuevo validador
    const cedulaValidator = new CedulaValidator('cedula');

    // Prevent double submission
    const registerForm = document.getElementById('registerForm');
    const registerBtn = document.getElementById('registerBtn');
    let isSubmitting = false;

    if (registerForm && registerBtn) {
        registerForm.addEventListener('submit', (e) => {
            // Prevenir doble envío
            if (isSubmitting) {
                e.preventDefault();
                return false;
            }

            // Validar formato de cédula antes de enviar
            if (!cedulaValidator.isValid()) {
                e.preventDefault();
                return false;
            }

            isSubmitting = true;

            // Disable button
            registerBtn.disabled = true;
            
            // Change text and add spinner
            const originalContent = registerBtn.innerHTML;
            registerBtn.innerHTML = `
                <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
                Procesando...
            `;
            
            // Re-habilitar después de 10 segundos por seguridad
            setTimeout(() => {
                if (isSubmitting) {
                    isSubmitting = false;
                    registerBtn.disabled = false;
                    registerBtn.innerHTML = originalContent;
                }
            }, 10000);
        });
    }
});
</script>
@endpush