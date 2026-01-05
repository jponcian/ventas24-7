@extends('layouts.adminlte')

@section('title', 'Crear Examen')

@section('content_header')
    <h1>Crear Nuevo Examen</h1>
@stop

@section('content')
<div class="container-fluid">
    <div class="row">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header" style="background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%); color: white;">
                    <h3 class="card-title mb-0">
                        <i class="fas fa-flask mr-2"></i> Datos del Examen
                    </h3>
                </div>
                <form action="{{ route('lab.management.store') }}" method="POST">
                    @csrf
                    <div class="card-body">
                        @if($errors->any())
                            <div class="alert alert-danger">
                                <ul class="mb-0">
                                    @foreach($errors->all() as $error)
                                        <li>{{ $error }}</li>
                                    @endforeach
                                </ul>
                            </div>
                        @endif

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="code">Código <span class="text-danger">*</span></label>
                                    <input type="text" name="code" id="code" class="form-control @error('code') is-invalid @enderror" value="{{ old('code') }}" required>
                                    @error('code')
                                        <span class="invalid-feedback">{{ $message }}</span>
                                    @enderror
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="abbreviation">Abreviatura</label>
                                    <input type="text" name="abbreviation" id="abbreviation" class="form-control @error('abbreviation') is-invalid @enderror" value="{{ old('abbreviation') }}">
                                    @error('abbreviation')
                                        <span class="invalid-feedback">{{ $message }}</span>
                                    @enderror
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="name">Nombre del Examen <span class="text-danger">*</span></label>
                            <input type="text" name="name" id="name" class="form-control @error('name') is-invalid @enderror" value="{{ old('name') }}" required>
                            @error('name')
                                <span class="invalid-feedback">{{ $message }}</span>
                            @enderror
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="lab_category_id">Categoría <span class="text-danger">*</span></label>
                                    <select name="lab_category_id" id="lab_category_id" class="form-control @error('lab_category_id') is-invalid @enderror" required>
                                        <option value="">Seleccione una categoría...</option>
                                        @foreach($categories as $category)
                                            <option value="{{ $category->id }}" {{ old('lab_category_id') == $category->id ? 'selected' : '' }}>
                                                {{ $category->name }}
                                            </option>
                                        @endforeach
                                    </select>
                                    @error('lab_category_id')
                                        <span class="invalid-feedback">{{ $message }}</span>
                                    @enderror
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="price">Precio (USD) <span class="text-danger">*</span></label>
                                    <input type="number" step="0.01" name="price" id="price" class="form-control @error('price') is-invalid @enderror" value="{{ old('price') }}" required>
                                    @error('price')
                                        <span class="invalid-feedback">{{ $message }}</span>
                                    @enderror
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save mr-2"></i> Crear Examen
                        </button>
                        <a href="{{ route('lab.management.index') }}" class="btn btn-secondary">
                            <i class="fas fa-times mr-2"></i> Cancelar
                        </a>
                    </div>
                </form>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card bg-light">
                <div class="card-header" style="background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%); color: white;">
                    <h3 class="card-title mb-0">
                        <i class="fas fa-info-circle mr-2"></i> Información
                    </h3>
                </div>
                <div class="card-body">
                    <p class="text-muted">
                        <strong>Código:</strong> Identificador único del examen (ej: HEM001)
                    </p>
                    <p class="text-muted">
                        <strong>Abreviatura:</strong> Nombre corto para reportes (ej: HMG)
                    </p>
                    <p class="text-muted">
                        <strong>Categoría:</strong> Agrupa exámenes similares
                    </p>
                    <hr>
                    <p class="small text-info">
                        <i class="fas fa-lightbulb mr-1"></i> Después de crear el examen, podrá agregar los parámetros individuales y sus rangos de referencia.
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

{{-- Botón de Ayuda Contextual --}}
<x-help-button title="Crear Examen - Ayuda Rápida" :helpLink="route('help.show', 'gestion-laboratorio')">
    <div class="help-quick-guide">
        <h5 class="text-primary"><i class="fas fa-lightbulb mr-2"></i> Guía Rápida: Crear Examen</h5>
        
        <div class="alert alert-info">
            <strong>Campos del formulario:</strong>
        </div>

        <table class="table table-sm table-bordered">
            <tr>
                <td width="35%"><strong>Código</strong> <span class="text-danger">*</span></td>
                <td>Identificador único (ej: <code>HEM001</code>, <code>GLU001</code>)</td>
            </tr>
            <tr>
                <td><strong>Nombre</strong> <span class="text-danger">*</span></td>
                <td>Nombre completo del examen (ej: Hematología Completa)</td>
            </tr>
            <tr>
                <td><strong>Abreviatura</strong></td>
                <td>Nombre corto opcional (ej: HMG, GLU)</td>
            </tr>
            <tr>
                <td><strong>Categoría</strong> <span class="text-danger">*</span></td>
                <td>Grupo al que pertenece el examen</td>
            </tr>
            <tr>
                <td><strong>Precio (USD)</strong> <span class="text-danger">*</span></td>
                <td>Costo del examen en dólares</td>
            </tr>
        </table>

        <div class="callout callout-success mt-3">
            <h6><i class="fas fa-check-circle mr-2"></i> Siguiente Paso</h6>
            <p class="small mb-0">Después de crear el examen, serás redirigido automáticamente a la página de edición donde podrás agregar los <strong>parámetros individuales</strong> y sus <strong>rangos de referencia</strong>.</p>
        </div>

        <div class="callout callout-info mt-3">
            <h6><i class="fas fa-lightbulb mr-2"></i> Consejo</h6>
            <p class="small mb-0">Usa códigos consistentes para facilitar la búsqueda. Por ejemplo: HEM001, HEM002 para Hematología; GLU001, GLU002 para Glucosa, etc.</p>
        </div>
    </div>
</x-help-button>
@stop