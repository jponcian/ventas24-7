@extends('layouts.auth')


@section('content')
    <div class="auth-card">
        <div class="auth-card-header">
            <div class="d-flex justify-content-between align-items-start mb-3">
                <div>
                    <h1>Inicia sesión</h1>
                    <p class="auth-card-subtitle">Accede a tu cuenta de paciente</p>
                </div>
                <span class="brand-pill">
                    <i class="fa-solid fa-shield-heart"></i>
                    Seguro
                </span>
            </div>
        </div>

        @if(session('status'))
            <div class="alert alert-info mb-4">
                <i class="fa-solid fa-circle-info me-2"></i>{{ session('status') }}
            </div>
        @endif

        <form method="POST" action="{{ route('login') }}" novalidate>
            @csrf
            @if(request()->has('perfil'))
                <input type="hidden" name="perfil" value="{{ request()->query('perfil') }}">
            @endif
            
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
                    autofocus 
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
                        autocomplete="current-password" 
                        placeholder="Ingresa tu contraseña"
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

            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" value="1" id="remember_me" name="remember">
                    <label class="form-check-label" for="remember_me">
                        Recuérdame
                    </label>
                </div>
                @if (Route::has('password.request'))
                    <a href="{{ route('password.request') }}">
                        ¿Olvidaste tu contraseña?
                    </a>
                @endif
            </div>

            <div class="d-grid mb-4">
                <button class="btn btn-primary" type="submit" id="loginBtn">
                    <span id="btnContent">
                        <i class="fa-solid fa-right-to-bracket me-2"></i>
                        Ingresar
                    </span>
                    <span id="btnLoading" style="display: none;">
                        <i class="fa-solid fa-spinner fa-spin me-2"></i>
                        Ingresando...
                    </span>
                </button>
            </div>

            <div class="text-center">
                <span style="color: #718096;">¿No tienes cuenta?</span>
                <a href="{{ route('register') }}" class="ms-1">
                    Regístrate aquí
                </a>
            </div>
        </form>
    </div>
@endsection

@push('scripts')
<script src="{{ asset('js/cedula-validator.js') }}"></script>
<script>
document.addEventListener('DOMContentLoaded', () => {
    // Toggle de contraseña
    const toggleBtn = document.getElementById('togglePass');
    const passInput = document.getElementById('password');
    
    toggleBtn.addEventListener('click', () => {
        const visible = passInput.type === 'text';
        passInput.type = visible ? 'password' : 'text';
        toggleBtn.innerHTML = visible ? '<i class="fa-regular fa-eye"></i>' : '<i class="fa-regular fa-eye-slash"></i>';
    });

    // Validación y formateo de cédula con el nuevo validador
    const cedulaValidator = new CedulaValidator('cedula');

    // Prevención de múltiples clics en el login
    const loginForm = document.querySelector('form');
    const loginBtn = document.getElementById('loginBtn');
    const btnContent = document.getElementById('btnContent');
    const btnLoading = document.getElementById('btnLoading');
    let isSubmitting = false;

    loginForm.addEventListener('submit', function(e) {
        // Si ya se está enviando, prevenir
        if (isSubmitting) {
            e.preventDefault();
            return false;
        }

        // Validación básica antes de deshabilitar
        const cedula = cedulaValidator.getValue().trim();
        const password = document.getElementById('password').value.trim();

        if (!cedula || !password) {
            // Dejar que la validación HTML5 funcione
            return true;
        }

        // Validar formato de cédula antes de enviar
        if (!cedulaValidator.isValid()) {
            e.preventDefault();
            return false;
        }

        // Marcar como enviando
        isSubmitting = true;

        // Deshabilitar el botón
        loginBtn.disabled = true;
        loginBtn.style.cursor = 'not-allowed';
        loginBtn.style.opacity = '0.7';

        // Cambiar el contenido del botón
        btnContent.style.display = 'none';
        btnLoading.style.display = 'inline';

        // Por seguridad, re-habilitar después de 10 segundos en caso de error de red
        setTimeout(() => {
            if (isSubmitting) {
                isSubmitting = false;
                loginBtn.disabled = false;
                loginBtn.style.cursor = 'pointer';
                loginBtn.style.opacity = '1';
                btnContent.style.display = 'inline';
                btnLoading.style.display = 'none';
            }
        }, 10000);
    });
});
</script>
@endpush