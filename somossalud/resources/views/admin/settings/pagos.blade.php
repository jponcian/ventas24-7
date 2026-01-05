@extends('layouts.adminlte')

@section('title', 'Ajustes Generales')

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
            line-height: 1.5;
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
        .alert-info {
            background-color: #e0f2fe;
            border-color: #bae6fd;
            color: #0369a1;
            border-radius: 8px;
        }
    </style>
@endpush

@section('content')
    <div class="card">
        <div class="card-header">
            <h3 class="card-title">
                <i class="fas fa-cogs text-primary"></i>
                Ajustes Generales
            </h3>
            @if(session('success'))
                <span class="badge badge-success ml-auto" style="background-color: #10b981;">{{ session('success') }}</span>
            @endif
        </div>
        <form method="POST" action="{{ route('admin.settings.pagos.guardar') }}">
            @csrf
            <div class="card-body">
                <!-- Sección Clínica -->
                <h5 class="font-weight-bold text-dark mb-3"><i class="fas fa-hospital mr-2"></i>Datos de la Clínica (Reportes PDF)</h5>
                <div class="row mb-4">
                    <div class="col-md-12">
                        <div class="form-group">
                            <label for="clinica_nombre">Nombre de la Clínica</label>
                            <input type="text" id="clinica_nombre" name="clinica_nombre" value="{{ old('clinica_nombre', $clinica_nombre) }}" class="form-control" placeholder="Ej: Clínica SaludSonrisa">
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div class="form-group">
                            <label for="clinica_direccion">Dirección Fiscal / Sede</label>
                            <input type="text" id="clinica_direccion" name="clinica_direccion" value="{{ old('clinica_direccion', $clinica_direccion) }}" class="form-control" placeholder="Ej: Av. Bolívar, Edif. Doña Josefa...">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="clinica_telefono">Teléfonos de Contacto</label>
                            <input type="text" id="clinica_telefono" name="clinica_telefono" value="{{ old('clinica_telefono', $clinica_telefono) }}" class="form-control" placeholder="Ej: 0246-1234567">
                        </div>
                    </div>
                </div>

                <hr class="my-4">

                <!-- Sección Pago Móvil -->
                <h5 class="font-weight-bold text-dark mb-3"><i class="fa-solid fa-mobile-screen-button mr-2"></i>Datos del Pago Móvil (Suscripciones)</h5>
                <div class="alert alert-info mb-4">
                    <i class="fas fa-info-circle mr-2"></i>
                    Estos datos se mostrarán a los pacientes cuando deban reportar su pago móvil de la suscripción.
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="banco">
                                <i class="fas fa-university text-muted mr-1"></i>
                                Banco
                            </label>
                            <input type="text" id="banco" name="banco" value="{{ old('banco', $banco) }}" class="form-control @error('banco') is-invalid @enderror" required>
                            @error('banco')<div class="invalid-feedback">{{ $message }}</div>@enderror
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="identificacion">
                                <i class="fas fa-id-card text-muted mr-1"></i>
                                RIF/Cédula
                            </label>
                            <input type="text" id="identificacion" name="identificacion" value="{{ old('identificacion', $identificacion) }}" class="form-control @error('identificacion') is-invalid @enderror" placeholder="V-12345678 o J-12345678-9" required>
                            @error('identificacion')<div class="invalid-feedback">{{ $message }}</div>@enderror
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="telefono">
                                <i class="fas fa-phone text-muted mr-1"></i>
                                Teléfono
                            </label>
                            <input type="text" id="telefono" name="telefono" value="{{ old('telefono', $telefono) }}" class="form-control @error('telefono') is-invalid @enderror" placeholder="0414-1234567" required>
                            @error('telefono')<div class="invalid-feedback">{{ $message }}</div>@enderror
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="nombre">
                                <i class="fas fa-user text-muted mr-1"></i>
                                Nombre del titular/cuenta
                            </label>
                            <input type="text" id="nombre" name="nombre" value="{{ old('nombre', $nombre) }}" class="form-control @error('nombre') is-invalid @enderror" required>
                            @error('nombre')<div class="invalid-feedback">{{ $message }}</div>@enderror
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-footer bg-white border-top-0 d-flex justify-content-end pb-4 pr-4">
                <button class="btn btn-primary" type="submit">
                    <i class="fas fa-save mr-1"></i>
                    Guardar cambios
                </button>
            </div>
        </form>
    </div>
@endsection
