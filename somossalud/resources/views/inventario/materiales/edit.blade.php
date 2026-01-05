@extends('layouts.adminlte')

@section('title', 'Editar Material')

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
        .form-control, .custom-select {
            border-radius: 8px;
            border: 1px solid #e2e8f0;
            padding: 0.625rem 0.875rem;
            font-size: 0.95rem;
            transition: all 0.2s ease;
        }
        select.form-control {
            height: calc(2.75rem + 2px);
            padding: 0.625rem 0.875rem;
            line-height: 1.5;
        }
        .form-control:focus, .custom-select:focus {
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
        .custom-control-label {
            font-weight: 500;
            color: #334155;
        }
        .custom-switch .custom-control-label::before {
            border-radius: 1rem;
        }
        .custom-switch .custom-control-input:checked ~ .custom-control-label::before {
            background-color: #10b981;
            border-color: #10b981;
        }
        .text-danger {
            color: #ef4444 !important;
        }
        .invalid-feedback {
            font-size: 0.85rem;
            margin-top: 0.25rem;
        }
        .content-header h1 {
            font-weight: 600;
            color: #1e293b;
        }
    </style>
@endpush

@section('content')
    <div class="card">
        <div class="card-header">
            <h3 class="card-title">
                <i class="fas fa-box text-primary"></i>
                Información del Material
            </h3>
            <div class="card-tools">
                <a href="{{ route('inventario.materiales.index') }}" class="btn btn-secondary btn-sm">
                    <i class="fas fa-arrow-left mr-1"></i>
                    Volver
                </a>
            </div>
        </div>
        <div class="card-body">
            <form action="{{ route('inventario.materiales.update', $material) }}" method="POST">
                @csrf
                @method('PUT')
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>
                                <i class="fas fa-barcode text-muted mr-1"></i>
                                Código 
                                <span class="text-danger">*</span>
                            </label>
                            <input type="text" name="codigo" class="form-control @error('codigo') is-invalid @enderror" value="{{ old('codigo', $material->codigo) }}" required placeholder="Ej: MAT-001">
                            @error('codigo') 
                                <span class="invalid-feedback">
                                    <strong>{{ $message }}</strong>
                                </span> 
                            @enderror
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>
                                <i class="fas fa-tag text-muted mr-1"></i>
                                Nombre del Material 
                                <span class="text-danger">*</span>
                            </label>
                            <input type="text" name="nombre" class="form-control @error('nombre') is-invalid @enderror" value="{{ old('nombre', $material->nombre) }}" required placeholder="Nombre descriptivo del material">
                            @error('nombre') 
                                <span class="invalid-feedback">
                                    <strong>{{ $message }}</strong>
                                </span> 
                            @enderror
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label>
                        <i class="fas fa-align-left text-muted mr-1"></i>
                        Descripción
                    </label>
                    <textarea name="descripcion" class="form-control" rows="3" placeholder="Descripción detallada del material (opcional)">{{ old('descripcion', $material->descripcion) }}</textarea>
                </div>

                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>
                                <i class="fas fa-folder text-muted mr-1"></i>
                                Categoría 
                                <span class="text-danger">*</span>
                            </label>
                            <select name="categoria_default" class="form-control @error('categoria_default') is-invalid @enderror" required>
                                <option value="">Seleccione...</option>
                                @foreach($categorias as $cat)
                                    <option value="{{ $cat }}" {{ old('categoria_default', $material->categoria_default) == $cat ? 'selected' : '' }}>{{ $cat }}</option>
                                @endforeach
                            </select>
                            @error('categoria_default') 
                                <span class="invalid-feedback">
                                    <strong>{{ $message }}</strong>
                                </span> 
                            @enderror
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>
                                <i class="fas fa-balance-scale text-muted mr-1"></i>
                                Unidad de Medida 
                                <span class="text-danger">*</span>
                            </label>
                            <select name="unidad_medida_default" class="form-control @error('unidad_medida_default') is-invalid @enderror" required>
                                <option value="">Seleccione...</option>
                                @foreach($unidades as $u)
                                    <option value="{{ $u }}" {{ old('unidad_medida_default', $material->unidad_medida_default) == $u ? 'selected' : '' }}>{{ $u }}</option>
                                @endforeach
                            </select>
                            @error('unidad_medida_default') 
                                <span class="invalid-feedback">
                                    <strong>{{ $message }}</strong>
                                </span> 
                            @enderror
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>
                                <i class="fas fa-exclamation-triangle text-muted mr-1"></i>
                                Stock Mínimo (Alerta) 
                                <span class="text-danger">*</span>
                            </label>
                            <input type="number" name="stock_minimo" class="form-control @error('stock_minimo') is-invalid @enderror" value="{{ old('stock_minimo', $material->stock_minimo) }}" min="0" required placeholder="0">
                            @error('stock_minimo') 
                                <span class="invalid-feedback">
                                    <strong>{{ $message }}</strong>
                                </span> 
                            @enderror
                            <small class="form-text text-muted">
                                <i class="fas fa-info-circle mr-1"></i>
                                Cantidad mínima antes de generar alerta
                            </small>
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <div class="custom-control custom-switch">
                        <input type="hidden" name="activo" value="0">
                        <input type="checkbox" class="custom-control-input" id="activoSwitch" name="activo" value="1" {{ old('activo', $material->activo) ? 'checked' : '' }}>
                        <label class="custom-control-label" for="activoSwitch">
                            <i class="fas fa-check-circle text-success mr-1"></i>
                            Material Activo
                        </label>
                    </div>
                    <small class="form-text text-muted ml-4">
                        Los materiales inactivos no aparecerán en las solicitudes
                    </small>
                </div>

                <hr class="my-4">
                
                <div class="d-flex justify-content-between align-items-center">
                    <button type="submit" class="btn btn-primary btn-lg">
                        <i class="fas fa-save mr-2"></i>
                        Actualizar Material
                    </button>
                    <a href="{{ route('inventario.materiales.index') }}" class="btn btn-secondary">
                        <i class="fas fa-times mr-1"></i>
                        Cancelar
                    </a>
                </div>
            </form>
        </div>
    </div>
@endsection
