@extends('layouts.adminlte')

@section('title', 'Mi Perfil')

@push('styles')
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Outfit', sans-serif !important;
            background-color: #f8fafc;
        }
        .content-wrapper {
            background-color: #f8fafc !important;
        }
        .card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
            transition: all 0.3s ease;
            background: white;
            overflow: hidden;
        }
        .card:hover {
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }
        .card-header {
            background: linear-gradient(135deg, #dbeafe 0%, #dcfce7 100%);
            border-bottom: 1px solid #cbd5e1;
            padding: 1.25rem 1.5rem;
        }
        .card-title {
            font-weight: 600;
            color: #1e293b;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin: 0;
        }
        .form-group label {
            font-weight: 500;
            color: #334155;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }
        .form-control {
            border-radius: 8px;
            border: 1px solid #e2e8f0;
            padding: 0.625rem 0.875rem;
            font-size: 0.95rem;
            transition: all 0.2s ease;
        }
        .form-control:focus {
            border-color: #0ea5e9;
            box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
        }
        .btn {
            border-radius: 8px;
            padding: 0.625rem 1.25rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        .btn-primary {
            background: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%);
            border: none;
            box-shadow: 0 2px 4px rgba(14, 165, 233, 0.2);
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #0284c7 0%, #0369a1 100%);
            box-shadow: 0 4px 8px rgba(14, 165, 233, 0.3);
            transform: translateY(-1px);
        }
        .btn-secondary {
            background: linear-gradient(135deg, #64748b 0%, #475569 100%);
            border: none;
            box-shadow: 0 2px 4px rgba(100, 116, 139, 0.2);
        }
        .btn-secondary:hover {
            background: linear-gradient(135deg, #475569 0%, #334155 100%);
            box-shadow: 0 4px 8px rgba(100, 116, 139, 0.3);
            transform: translateY(-1px);
        }
        .invalid-feedback {
            font-size: 0.85rem;
            margin-top: 0.25rem;
        }
        .text-success {
            color: #10b981 !important;
            font-weight: 500;
        }
        .content-header h1 {
            font-weight: 600;
            color: #1e293b;
        }
    </style>
@endpush

@section('content-header')
    <div class="row mb-2">
        <div class="col-sm-6">
            <h1 class="m-0"><i class="fas fa-user-circle text-primary mr-2"></i>Mi Perfil</h1>
        </div>
        <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
                <li class="breadcrumb-item"><a href="{{ route('panel.clinica') }}">Panel</a></li>
                <li class="breadcrumb-item active">Perfil</li>
            </ol>
        </div>
    </div>
@endsection

@section('content')
    <div class="row">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">
                        <i class="fas fa-user-edit text-primary"></i>
                        Información del Perfil
                    </h3>
                </div>
                <div class="card-body">
                    <form method="post" action="{{ route('profile.update', ['context' => 'clinica']) }}" enctype="multipart/form-data">
                        @csrf
                        @method('patch')

                        <div class="form-group">
                            <label for="name">
                                <i class="fas fa-user text-muted mr-1"></i>
                                Nombre Completo
                            </label>
                            <input type="text" class="form-control @error('name') is-invalid @enderror" id="name" name="name" value="{{ old('name', $user->name) }}" required autofocus autocomplete="name" placeholder="Ingresa tu nombre completo">
                            @error('name')
                                <span class="invalid-feedback" role="alert">
                                    <strong>{{ $message }}</strong>
                                </span>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label for="email">
                                <i class="fas fa-envelope text-muted mr-1"></i>
                                Correo Electrónico
                            </label>
                            <input type="email" class="form-control @error('email') is-invalid @enderror" id="email" name="email" value="{{ old('email', $user->email) }}" required autocomplete="username" placeholder="correo@ejemplo.com">
                            @error('email')
                                <span class="invalid-feedback" role="alert">
                                    <strong>{{ $message }}</strong>
                                </span>
                            @enderror
                        </div>

                            <div class="form-group">
                                <label for="sexo">
                                    <i class="fas fa-venus-mars text-muted mr-1"></i>
                                    Género / Sexo
                                </label>
                                <select class="form-control @error('sexo') is-invalid @enderror" id="sexo" name="sexo" required>
                                    <option value="">Selecciona una opción</option>
                                    <option value="M" {{ old('sexo', $user->sexo) == 'M' ? 'selected' : '' }}>Masculino</option>
                                    <option value="F" {{ old('sexo', $user->sexo) == 'F' ? 'selected' : '' }}>Femenino</option>
                                    <option value="O" {{ old('sexo', $user->sexo) == 'O' ? 'selected' : '' }}>Otro</option>
                                </select>
                                @error('sexo')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                @enderror
                            </div>

                            <div class="form-group">
                                <label for="fecha_nacimiento">
                                    <i class="fas fa-calendar-alt text-muted mr-1"></i>
                                    Fecha de nacimiento
                                </label>
                                <input type="date" class="form-control @error('fecha_nacimiento') is-invalid @enderror" id="fecha_nacimiento" name="fecha_nacimiento" value="{{ old('fecha_nacimiento', (is_object($user->fecha_nacimiento) ? $user->fecha_nacimiento->format('Y-m-d') : $user->fecha_nacimiento)) }}" required>
                                @error('fecha_nacimiento')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                @enderror
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="mpps">
                                            <i class="fas fa-id-card text-muted mr-1"></i>
                                            M.P.P.S
                                        </label>
                                        <input type="text" class="form-control @error('mpps') is-invalid @enderror" id="mpps" name="mpps" value="{{ old('mpps', $user->mpps) }}" placeholder="Registro MPPS">
                                        @error('mpps')
                                            <span class="invalid-feedback" role="alert">
                                                <strong>{{ $message }}</strong>
                                            </span>
                                        @enderror
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="colegio_bioanalista">
                                            <i class="fas fa-university text-muted mr-1"></i>
                                            C.B. (Colegio de Bioanalistas)
                                        </label>
                                        <input type="text" class="form-control @error('colegio_bioanalista') is-invalid @enderror" id="colegio_bioanalista" name="colegio_bioanalista" value="{{ old('colegio_bioanalista', $user->colegio_bioanalista) }}" placeholder="Registro C.B.">
                                        @error('colegio_bioanalista')
                                            <span class="invalid-feedback" role="alert">
                                                <strong>{{ $message }}</strong>
                                            </span>
                                        @enderror
                                    </div>
                                </div>
                            </div>

                        <hr class="my-4">

                        <h4 class="mb-3">
                            <i class="fas fa-signature text-info mr-2"></i>
                            Firma Digitalizada
                        </h4>

                        @if($user->firma)
                            <div class="text-center mb-3">
                                @if(\Storage::disk('public')->exists($user->firma))
                                    @php
                                        $firmaContent = \Storage::disk('public')->get($user->firma);
                                        $firmaMime = \Storage::disk('public')->mimeType($user->firma);
                                    @endphp
                                    <img src="data:{{ $firmaMime }};base64,{{ base64_encode($firmaContent) }}" alt="Firma" class="img-fluid" style="max-height: 150px; border: 1px solid #e2e8f0; border-radius: 8px; padding: 10px; background: white;">
                                @else
                                    <p class="text-danger">Archivo de firma no encontrado en el servidor.</p>
                                @endif
                            </div>
                            <div class="text-center mb-3">
                                <button type="button" class="btn btn-danger btn-sm" data-toggle="modal" data-target="#deleteFirmaModal">
                                    <i class="fas fa-trash mr-1"></i>
                                    Eliminar Firma
                                </button>
                            </div>
                        @endif

                        <div class="form-group">
                            <label for="firma">
                                <i class="fas fa-upload text-muted mr-1"></i>
                                {{ $user->firma ? 'Cambiar Firma' : 'Subir Firma' }}
                            </label>
                            <input type="file" class="form-control-file @error('firma') is-invalid @enderror" id="firma" name="firma" accept="image/*">
                            @error('firma')
                                <span class="invalid-feedback" role="alert">
                                    <strong>{{ $message }}</strong>
                                </span>
                            @enderror
                                Formatos permitidos: JPG, PNG, GIF, BMP, WEBP. Tamaño máximo: 10MB
                            </small>
                        </div>

                        <div class="d-flex align-items-center gap-3">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save mr-1"></i>
                                Guardar Cambios
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">
                        <i class="fas fa-lock text-secondary"></i>
                        Actualizar Contraseña
                    </h3>
                </div>
                <div class="card-body">
                    <form method="post" action="{{ route('password.update') }}">
                        @csrf
                        @method('put')

                        <div class="form-group">
                            <label for="current_password">
                                <i class="fas fa-key text-muted mr-1"></i>
                                Contraseña Actual
                            </label>
                            <input type="password" class="form-control @error('current_password') is-invalid @enderror" id="current_password" name="current_password" autocomplete="current-password" placeholder="Ingresa tu contraseña actual">
                            @error('current_password')
                                <span class="invalid-feedback" role="alert">
                                    <strong>{{ $message }}</strong>
                                </span>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label for="password">
                                <i class="fas fa-lock text-muted mr-1"></i>
                                Nueva Contraseña
                            </label>
                            <input type="password" class="form-control @error('password') is-invalid @enderror" id="password" name="password" autocomplete="new-password" placeholder="Ingresa tu nueva contraseña">
                            @error('password')
                                <span class="invalid-feedback" role="alert">
                                    <strong>{{ $message }}</strong>
                                </span>
                            @enderror
                            <small class="form-text text-muted">
                                <i class="fas fa-info-circle mr-1"></i>
                                Mínimo 8 caracteres
                            </small>
                        </div>

                        <div class="form-group">
                            <label for="password_confirmation">
                                <i class="fas fa-lock text-muted mr-1"></i>
                                Confirmar Contraseña
                            </label>
                            <input type="password" class="form-control @error('password_confirmation') is-invalid @enderror" id="password_confirmation" name="password_confirmation" autocomplete="new-password" placeholder="Confirma tu nueva contraseña">
                            @error('password_confirmation')
                                <span class="invalid-feedback" role="alert">
                                    <strong>{{ $message }}</strong>
                                </span>
                            @enderror
                        </div>

                        <div class="d-flex align-items-center gap-3">
                            <button type="submit" class="btn btn-secondary">
                                <i class="fas fa-shield-alt mr-1"></i>
                                Actualizar Contraseña
                            </button>

                            @if (session('status') === 'password-updated')
                                <span class="text-success fade-out">
                                    <i class="fas fa-check-circle mr-1"></i>
                                    Actualizado correctamente
                                </span>
                            @endif
                        </div>
                    </form>
                </div>
            </div>
        </div>

    </div>
@endsection

@push('scripts')
    @if (session('status') === 'profile-updated')
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                Swal.fire({
                    toast: true,
                    position: 'bottom-end',
                    icon: 'success',
                    title: 'Guardado correctamente',
                    showConfirmButton: false,
                    timer: 3000,
                    timerProgressBar: true,
                    customClass: {
                        popup: 'swal2-toast swal2-success-toast'
                    }
                });
            });
        </script>
    @endif

    @if (session('status') === 'firma-deleted')
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                Swal.fire({
                    toast: true,
                    position: 'bottom-end',
                    icon: 'success',
                    title: 'Firma eliminada correctamente',
                    showConfirmButton: false,
                    timer: 3000,
                    timerProgressBar: true,
                    customClass: {
                        popup: 'swal2-toast swal2-success-toast'
                    }
                });
            });
        </script>
    @endif
@endpush
