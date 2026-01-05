@extends('layouts.adminlte')

@section('title', 'Ingresos de Inventario')

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
        .table thead th {
            border-top: none;
            border-bottom: 2px solid #f1f5f9;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #64748b;
            font-weight: 600;
            padding: 1rem 1.5rem;
        }
        .table td {
            vertical-align: middle;
            border-top: 1px solid #f1f5f9;
            padding: 1rem 1.5rem;
            color: #334155;
        }
        .table-striped tbody tr:nth-of-type(odd) {
            background-color: #f8fafc;
        }
        .table-hover tbody tr:hover {
            background-color: #f1f5f9;
        }
        .btn {
            border-radius: 8px;
            padding: 0.625rem 1.25rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        .btn-success {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            border: none;
            box-shadow: 0 2px 4px rgba(16, 185, 129, 0.2);
        }
        .btn-success:hover {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            box-shadow: 0 4px 8px rgba(16, 185, 129, 0.3);
            transform: translateY(-1px);
        }
        .badge {
            padding: 0.5em 0.8em;
            border-radius: 6px;
            font-weight: 500;
            letter-spacing: 0.02em;
        }
        .badge-success {
            background-color: #dcfce7;
            color: #166534;
        }
        .content-header h1 {
            font-weight: 600;
            color: #1e293b;
        }
    </style>
@endpush

@section('content')
    {{-- Filtros --}}
    <div class="card mb-4">
        <div class="card-header">
            <h3 class="card-title">
                <i class="fas fa-filter text-primary"></i>
                Filtros de Búsqueda
            </h3>
            <div class="card-tools">
                <a href="{{ route('inventario.ingresos.create') }}" class="btn btn-success btn-sm mr-2">
                    <i class="fas fa-plus-circle mr-1"></i>
                    Nuevo Ingreso
                </a>
                <button type="button" class="btn btn-tool" data-card-widget="collapse">
                    <i class="fas fa-minus"></i>
                </button>
            </div>
        </div>
        <div class="card-body">
            <form method="GET" action="{{ route('inventario.ingresos.index') }}">
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>
                                <i class="fas fa-box text-muted mr-1"></i>
                                Material
                            </label>
                            <select name="material_id" class="form-control select2">
                                <option value="">Todos los materiales</option>
                                @foreach(\App\Models\Material::orderBy('nombre')->get() as $mat)
                                    <option value="{{ $mat->id }}" {{ request('material_id') == $mat->id ? 'selected' : '' }}>
                                        {{ $mat->nombre }}
                                    </option>
                                @endforeach
                            </select>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>
                                <i class="fas fa-calendar text-muted mr-1"></i>
                                Desde
                            </label>
                            <input type="date" name="fecha_desde" class="form-control" value="{{ request('fecha_desde') }}">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>
                                <i class="fas fa-calendar text-muted mr-1"></i>
                                Hasta
                            </label>
                            <input type="date" name="fecha_hasta" class="form-control" value="{{ request('fecha_hasta') }}">
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label>&nbsp;</label>
                            <button type="submit" class="btn btn-primary btn-block">
                                <i class="fas fa-search mr-1"></i>
                                Buscar
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <h3 class="card-title">
                <i class="fas fa-history text-primary"></i>
                Historial de Ingresos
            </h3>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-striped mb-0">
                    <thead>
                        <tr>
                            <th class="pl-4">Fecha</th>
                            <th>Material</th>
                            <th>Usuario</th>
                            <th>Motivo / Referencia</th>
                            <th class="text-center">Cantidad</th>
                            <th class="text-center">Stock Resultante</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($movimientos as $mov)
                            <tr>
                                <td class="pl-4 align-middle">
                                    <i class="far fa-calendar-alt text-muted mr-1"></i>
                                    {{ $mov->created_at->format('d/m/Y H:i') }}
                                </td>
                                <td class="align-middle">
                                    <div class="font-weight-bold">{{ $mov->material->nombre }}</div>
                                    <small class="text-muted">{{ $mov->material->codigo }}</small>
                                </td>
                                <td class="align-middle">
                                    <i class="fas fa-user text-muted mr-1"></i>
                                    {{ $mov->user->name }}
                                </td>
                                <td class="align-middle">
                                    <div>{{ $mov->motivo }}</div>
                                    @if($mov->referencia)
                                        <small class="text-muted"><i class="fas fa-hashtag"></i> {{ $mov->referencia }}</small>
                                    @endif
                                </td>
                                <td class="align-middle text-center">
                                    <span class="badge badge-success px-3 py-2" style="font-size: 1rem;">
                                        +{{ $mov->cantidad }}
                                    </span>
                                </td>
                                <td class="align-middle text-center">
                                    <span class="font-weight-bold text-dark">{{ $mov->stock_nuevo }}</span>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">
                                    <i class="fas fa-box-open fa-3x mb-3 d-block"></i>
                                    <p class="mb-0">No hay registros de ingresos.</p>
                                </td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>
        @if($movimientos->hasPages())
            <div class="card-footer bg-white">
                {{ $movimientos->links() }}
            </div>
        @endif
    </div>

    {{-- Botón de Ayuda Contextual --}}
    <x-help-button section="registro-ingresos">
        <x-slot name="quickGuide">
            <h6 class="font-weight-bold mb-3">Guía Rápida - Registro de Ingresos</h6>
            
            <div class="mb-3">
                <strong class="text-primary"><i class="fas fa-plus-circle mr-1"></i> Registrar Ingreso:</strong>
                <ol class="small mb-0 mt-1">
                    <li>Haz clic en "Nuevo Ingreso"</li>
                    <li>Completa fecha, tipo y proveedor</li>
                    <li>Agrega los materiales con cantidades</li>
                    <li>Guarda el ingreso</li>
                </ol>
            </div>

            <div class="mb-3">
                <strong class="text-success"><i class="fas fa-tag mr-1"></i> Tipos de Ingreso:</strong>
                <ul class="small mb-0 mt-1">
                    <li><strong>Compra:</strong> Materiales adquiridos a proveedores</li>
                    <li><strong>Donación:</strong> Materiales recibidos sin costo</li>
                    <li><strong>Ajuste:</strong> Correcciones de inventario</li>
                </ul>
            </div>

            <div class="mb-3">
                <strong class="text-warning"><i class="fas fa-exclamation-triangle mr-1"></i> Importante:</strong>
                <ul class="small mb-0 mt-1">
                    <li>Registra los ingresos el mismo día que se reciben</li>
                    <li>Verifica físicamente las cantidades antes de registrar</li>
                    <li>Incluye siempre el número de factura o referencia</li>
                </ul>
            </div>

            <div class="alert alert-info small mb-0">
                <i class="fas fa-info-circle mr-1"></i>
                <strong>Tip:</strong> El stock se actualiza automáticamente al guardar el ingreso.
            </div>
        </x-slot>
    </x-help-button>
@endsection

@push('scripts')
<script>
$(document).ready(function() {
    // Inicializar select2
    $('.select2').select2({
        theme: 'bootstrap4',
        width: '100%'
    });
});
</script>
@endpush
