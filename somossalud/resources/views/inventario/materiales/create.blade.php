@extends('layouts.adminlte')

@section('title', 'Nuevo Material')

@section('content_header')
    <div class="d-flex justify-content-between align-items-center">
        <h1><i class="fas fa-box text-primary"></i> Nuevo Material</h1>
        <a href="{{ route('inventario.materiales.index') }}" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Volver
        </a>
    </div>
@stop

@section('content')
    <div class="card shadow-sm">
        <div class="card-body">
            <form action="{{ route('inventario.materiales.store') }}" method="POST">
                @csrf
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>Código <span class="text-danger">*</span></label>
                            <input type="text" name="codigo" class="form-control @error('codigo') is-invalid @enderror" value="{{ old('codigo') }}" required>
                            @error('codigo') <span class="invalid-feedback">{{ $message }}</span> @enderror
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>Nombre del Material <span class="text-danger">*</span></label>
                            <input type="text" name="nombre" class="form-control @error('nombre') is-invalid @enderror" value="{{ old('nombre') }}" required>
                            @error('nombre') <span class="invalid-feedback">{{ $message }}</span> @enderror
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label>Descripción</label>
                    <textarea name="descripcion" class="form-control" rows="2">{{ old('descripcion') }}</textarea>
                </div>

                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>Categoría <span class="text-danger">*</span></label>
                            <select name="categoria_default" class="form-control @error('categoria_default') is-invalid @enderror" required>
                                <option value="">Seleccione...</option>
                                @foreach($categorias as $cat)
                                    <option value="{{ $cat }}" {{ old('categoria_default') == $cat ? 'selected' : '' }}>{{ $cat }}</option>
                                @endforeach
                            </select>
                            @error('categoria_default') <span class="invalid-feedback">{{ $message }}</span> @enderror
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>Unidad de Medida <span class="text-danger">*</span></label>
                            <select name="unidad_medida_default" class="form-control @error('unidad_medida_default') is-invalid @enderror" required>
                                <option value="">Seleccione...</option>
                                @foreach($unidades as $u)
                                    <option value="{{ $u }}" {{ old('unidad_medida_default') == $u ? 'selected' : '' }}>{{ $u }}</option>
                                @endforeach
                            </select>
                            @error('unidad_medida_default') <span class="invalid-feedback">{{ $message }}</span> @enderror
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>Stock Inicial</label>
                            <input type="number" name="stock_inicial" class="form-control @error('stock_inicial') is-invalid @enderror" value="{{ old('stock_inicial', 0) }}" min="0" step="1">
                            <small class="form-text text-muted">
                                <i class="fas fa-info-circle"></i> Cantidad inicial en inventario (opcional)
                            </small>
                            @error('stock_inicial') <span class="invalid-feedback">{{ $message }}</span> @enderror
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>Stock Mínimo (Alerta) <span class="text-danger">*</span></label>
                            <input type="number" name="stock_minimo" class="form-control @error('stock_minimo') is-invalid @enderror" value="{{ old('stock_minimo', 10) }}" min="0" required>
                            @error('stock_minimo') <span class="invalid-feedback">{{ $message }}</span> @enderror
                        </div>
                    </div>
                </div>

                <hr>
                <button type="submit" class="btn btn-success btn-lg shadow-sm">
                    <i class="fas fa-save"></i> Guardar Material
                </button>
            </form>
        </div>
    </div>
@stop
