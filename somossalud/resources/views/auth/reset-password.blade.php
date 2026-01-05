<x-guest-layout>
    <div class="card-header">
        <h1>Restablecer contraseña</h1>
        <p>Ingresa tu nueva contraseña para recuperar el acceso a tu cuenta.</p>
    </div>

    <form method="POST" action="{{ route('password.store') }}">
        @csrf

        <!-- Password Reset Token -->
        <input type="hidden" name="token" value="{{ $request->route('token') }}">

        <!-- Email Address -->
        <div class="form-group">
            <label for="email" class="form-label">Correo electrónico</label>
            <input 
                id="email" 
                class="form-control" 
                type="email" 
                name="email" 
                value="{{ old('email', $request->email) }}" 
                required 
                autofocus 
                autocomplete="username"
                placeholder="tu@email.com"
            >
            @error('email')
                <div class="input-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>{{ $message }}</span>
                </div>
            @enderror
        </div>

        <!-- Password -->
        <div class="form-group">
            <label for="password" class="form-label">Nueva contraseña</label>
            <input 
                id="password" 
                class="form-control" 
                type="password" 
                name="password" 
                required 
                autocomplete="new-password"
                placeholder="Mínimo 8 caracteres"
            >
            @error('password')
                <div class="input-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>{{ $message }}</span>
                </div>
            @enderror
        </div>

        <!-- Confirm Password -->
        <div class="form-group">
            <label for="password_confirmation" class="form-label">Confirmar contraseña</label>
            <input 
                id="password_confirmation" 
                class="form-control" 
                type="password" 
                name="password_confirmation" 
                required 
                autocomplete="new-password"
                placeholder="Repite tu contraseña"
            >
            @error('password_confirmation')
                <div class="input-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>{{ $message }}</span>
                </div>
            @enderror
        </div>

        <button type="submit" class="btn btn-primary">
            <i class="fas fa-key"></i>
            Restablecer contraseña
        </button>
    </form>

    <div class="back-link">
        <a href="{{ route('login') }}">
            <i class="fas fa-arrow-left"></i>
            Volver al inicio de sesión
        </a>
    </div>
</x-guest-layout>
