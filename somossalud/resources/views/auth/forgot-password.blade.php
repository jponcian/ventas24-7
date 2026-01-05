<x-guest-layout>
    <div class="card-header">
        <h1>¿Olvidaste tu contraseña?</h1>
        <p>No te preocupes, te enviaremos un enlace para que puedas restablecerla de forma segura.</p>
    </div>

    <!-- Session Status -->
    @if (session('status'))
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <span>{{ session('status') }}</span>
        </div>
    @endif

    <form method="POST" action="{{ route('password.email') }}" id="forgotPasswordForm">
        @csrf

        <!-- Email Address -->
        <div class="form-group">
            <label for="email" class="form-label">Correo electrónico</label>
            <input 
                id="email" 
                class="form-control" 
                type="email" 
                name="email" 
                value="{{ old('email') }}" 
                required 
                autofocus 
                placeholder="tu@email.com"
            >
            @error('email')
                <div class="input-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>{{ $message }}</span>
                </div>
            @enderror
        </div>

        <button type="submit" class="btn btn-primary" id="forgotPasswordBtn">
            <i class="fas fa-paper-plane"></i>
            <span class="btn-text">Enviar enlace de restablecimiento</span>
        </button>
    </form>

    <div class="back-link">
        <a href="{{ route('login') }}">
            <i class="fas fa-arrow-left"></i>
            Volver al inicio de sesión
        </a>
    </div>

    @push('scripts')
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const forgotForm = document.getElementById('forgotPasswordForm');
            const forgotBtn = document.getElementById('forgotPasswordBtn');

            if (forgotForm && forgotBtn) {
                forgotForm.addEventListener('submit', (e) => {
                    // Disable button
                    forgotBtn.disabled = true;
                    
                    // Change text and add spinner
                    forgotBtn.innerHTML = `
                        <i class="fas fa-spinner fa-spin"></i>
                        Enviando...
                    `;
                });
            }
        });
    </script>
    @endpush
</x-guest-layout>
