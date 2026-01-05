@extends('layouts.adminlte')

@section('title', 'Solicitudes de Inventario')

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
            align-items-center;
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
        .form-group label {
            font-weight: 500;
            color: #334155;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }
        .form-control, .select2-container--bootstrap4 .select2-selection {
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
        .btn-sm {
            padding: 0.375rem 0.75rem;
            font-size: 0.875rem;
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
        .btn-success {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            border: none;
        }
        .btn-success:hover {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            transform: translateY(-1px);
        }
        .btn-outline-primary {
            border: 1px solid #0ea5e9;
            color: #0ea5e9;
        }
        .btn-outline-primary:hover {
            background: #0ea5e9;
            color: white;
        }
        .btn-outline-warning {
            border: 1px solid #f59e0b;
            color: #f59e0b;
        }
        .btn-outline-warning:hover {
            background: #f59e0b;
            color: white;
        }
        .btn-outline-danger {
            border: 1px solid #ef4444;
            color: #ef4444;
        }
        .btn-outline-danger:hover {
            background: #ef4444;
            color: white;
        }
        .small-box {
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        .badge {
            padding: 0.5em 0.8em;
            border-radius: 6px;
            font-weight: 500;
            letter-spacing: 0.02em;
        }
        .badge-warning {
            background-color: #fef9c3;
            color: #854d0e;
        }
        .badge-info {
            background-color: #e0f2fe;
            color: #0284c7;
        }
        .badge-success {
            background-color: #dcfce7;
            color: #166534;
        }
        .badge-danger {
            background-color: #fee2e2;
            color: #991b1b;
        }
        .content-header h1 {
            font-weight: 600;
            color: #1e293b;
        }
        .avatar-circle {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 14px;
            background-color: #e0f2fe;
            color: #0284c7;
        }
    </style>
@endpush

@section('content')
    {{-- Estadísticas --}}
    <div class="row mb-4">
        <div class="col-md-4">
            <div class="small-box bg-warning shadow-sm">
                <div class="inner">
                    <h3>{{ $stats['pendientes'] }}</h3>
                    <p>Pendientes de Aprobación</p>
                </div>
                <div class="icon">
                    <i class="fas fa-clock"></i>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="small-box bg-info shadow-sm">
                <div class="inner">
                    <h3>{{ $stats['aprobadas'] }}</h3>
                    <p>Aprobadas / Por Despachar</p>
                </div>
                <div class="icon">
                    <i class="fas fa-check-circle"></i>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="small-box bg-success shadow-sm">
                <div class="inner">
                    <h3>{{ $stats['despachadas_mes'] }}</h3>
                    <p>Despachadas en {{ now()->locale('es')->translatedFormat('F Y') }}</p>
                </div>
                <div class="icon">
                    <i class="fas fa-truck-loading"></i>
                </div>
            </div>
        </div>
    </div>

    {{-- Filtros --}}
    <div class="card mb-4">
        <div class="card-header">
            <h3 class="card-title">
                <i class="fas fa-filter text-primary"></i>
                Filtros de Búsqueda
            </h3>
            <div class="card-tools">
                @can('create', App\Models\SolicitudInventario::class)
                    <a href="{{ route('inventario.solicitudes.create') }}" class="btn btn-primary btn-sm mr-2">
                        <i class="fas fa-plus-circle mr-1"></i>
                        Nueva Solicitud
                    </a>
                @endcan
                <button type="button" class="btn btn-tool" data-card-widget="collapse">
                    <i class="fas fa-minus"></i>
                </button>
            </div>
        </div>
        <div class="card-body">
            <form method="GET" action="{{ route('inventario.solicitudes.index') }}">
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>
                                <i class="fas fa-info-circle text-muted mr-1"></i>
                                Estado
                            </label>
                            <select name="estado" class="form-control select2" data-minimum-results-for-search="Infinity">
                                <option value="">Todos los estados</option>
                                <option value="pendiente" {{ request('estado') == 'pendiente' ? 'selected' : '' }}>Pendiente</option>
                                <option value="aprobada" {{ request('estado') == 'aprobada' ? 'selected' : '' }}>Aprobada</option>
                                <option value="despachada" {{ request('estado') == 'despachada' ? 'selected' : '' }}>Despachada</option>
                                <option value="rechazada" {{ request('estado') == 'rechazada' ? 'selected' : '' }}>Rechazada</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>
                                <i class="fas fa-folder text-muted mr-1"></i>
                                Categoría
                            </label>
                            <select name="categoria" class="form-control select2" data-minimum-results-for-search="Infinity">
                                <option value="">Todas las categorías</option>
                                <option value="ENFERMERIA" {{ request('categoria') == 'ENFERMERIA' ? 'selected' : '' }}>Enfermería</option>
                                <option value="QUIROFANO" {{ request('categoria') == 'QUIROFANO' ? 'selected' : '' }}>Quirófano</option>
                                <option value="UCI" {{ request('categoria') == 'UCI' ? 'selected' : '' }}>UCI</option>
                                <option value="OFICINA" {{ request('categoria') == 'OFICINA' ? 'selected' : '' }}>Oficina</option>
                                <option value="LABORATORIO" {{ request('categoria') == 'LABORATORIO' ? 'selected' : '' }}>Laboratorio</option>
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
                </div>
            </form>
        </div>
    </div>

    {{-- Lista de solicitudes --}}
    <div class="card">
        <div class="card-header">
            <h3 class="card-title">
                <i class="fas fa-list-alt text-primary"></i>
                Listado de Solicitudes
            </h3>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-striped mb-0">
                    <thead>
                        <tr>
                            <th class="pl-4">Número</th>
                            <th>Fecha</th>
                            <th>Solicitante</th>
                            <th>Categoría</th>
                            <th class="text-center">Items</th>
                            <th class="text-center">Estado</th>
                            <th class="text-right pr-4">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($solicitudes as $solicitud)
                            <tr>
                                <td class="pl-4 align-middle">
                                    <span class="font-weight-bold text-dark">{{ $solicitud->numero_solicitud }}</span>
                                </td>
                                <td class="align-middle">
                                    <i class="far fa-calendar-alt text-muted mr-1"></i>
                                    {{ $solicitud->created_at->format('d/m/Y H:i') }}
                                </td>
                                <td class="align-middle">
                                    <div class="d-flex align-items-center">
                                        <div class="avatar-circle mr-2">
                                            {{ substr($solicitud->solicitante->name, 0, 1) }}
                                        </div>
                                        {{ $solicitud->solicitante->name }}
                                    </div>
                                </td>
                                <td class="align-middle">
                                    <span class="badge badge-light border px-2 py-1">
                                        {{ $solicitud->categoria }}
                                    </span>
                                </td>
                                <td class="align-middle text-center">
                                    <span class="badge badge-pill badge-info px-3">
                                        {{ $solicitud->total_items }}
                                    </span>
                                </td>
                                <td class="align-middle text-center">
                                    <span class="badge badge-{{ $solicitud->badge_color }} px-3 py-2 rounded-pill shadow-sm">
                                        {{ ucfirst($solicitud->estado) }}
                                    </span>
                                </td>
                                <td class="align-middle text-right pr-4">
                                    <div class="btn-group">
                                        <a href="{{ route('inventario.solicitudes.show', $solicitud) }}" 
                                           class="btn btn-sm btn-outline-primary" 
                                           title="Ver detalle">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        
                                        @can('approve', $solicitud)
                                            @if($solicitud->isPendiente())
                                                <a href="{{ route('inventario.solicitudes.edit', $solicitud) }}" 
                                                   class="btn btn-sm btn-outline-warning" 
                                                   title="Gestionar Aprobación">
                                                    <i class="fas fa-tasks"></i>
                                                </a>
                                            @endif
                                        @endcan
                                        
                                        @can('delete', $solicitud)
                                            @if($solicitud->isPendiente())
                                                <form action="{{ route('inventario.solicitudes.destroy', $solicitud) }}" 
                                                      method="POST" 
                                                      style="display: inline-block;"
                                                      onsubmit="return confirm('¿Está seguro de eliminar esta solicitud?');">
                                                    @csrf
                                                    @method('DELETE')
                                                    <button type="submit" class="btn btn-sm btn-outline-danger" title="Eliminar">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </form>
                                            @endif
                                        @endcan
                                    </div>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="7" class="text-center py-5">
                                    <div class="empty-state">
                                        <i class="fas fa-inbox fa-4x text-muted mb-3 d-block"></i>
                                        <h5 class="text-muted">No se encontraron solicitudes</h5>
                                        <p class="text-muted small">Intente ajustar los filtros o cree una nueva solicitud.</p>
                                    </div>
                                </td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>
        @if($solicitudes->hasPages())
            <div class="card-footer bg-white">
                {{ $solicitudes->links() }}
            </div>
        @endif
    </div>

    {{-- Botón de Ayuda Contextual --}}
    <x-help-button section="gestion-solicitudes">
        <x-slot name="quickGuide">
            <h6 class="font-weight-bold mb-3">Guía Rápida - Solicitudes de Inventario</h6>
            
            <div class="mb-3">
                <strong class="text-primary"><i class="fas fa-plus-circle mr-1"></i> Crear Solicitud:</strong>
                <ol class="small mb-0 mt-1">
                    <li>Haz clic en "Nueva Solicitud"</li>
                    <li>Selecciona la categoría</li>
                    <li>Agrega los materiales necesarios</li>
                    <li>Guarda la solicitud</li>
                </ol>
            </div>

            <div class="mb-3">
                <strong class="text-success"><i class="fas fa-check-circle mr-1"></i> Aprobar Solicitud:</strong>
                <p class="small mb-0 mt-1">Solo Jefe de Almacén puede aprobar. Revisa cantidades y confirma o modifica según disponibilidad.</p>
            </div>

            <div class="mb-3">
                <strong class="text-info"><i class="fas fa-truck-loading mr-1"></i> Estados:</strong>
                <ul class="small mb-0 mt-1">
                    <li><span class="badge badge-warning">Pendiente</span> - Esperando aprobación</li>
                    <li><span class="badge badge-info">Aprobada</span> - Lista para despachar</li>
                    <li><span class="badge badge-success">Despachada</span> - Entregada</li>
                    <li><span class="badge badge-danger">Rechazada</span> - No aprobada</li>
                </ul>
            </div>
        </x-slot>
    </x-help-button>
@endsection

@push('scripts')
<script>
$(document).ready(function() {
    // Aplica select2 con tema bootstrap4 a todos los select2
    $('select.select2').select2({
        theme: 'bootstrap4',
        width: '100%'
    });
});
</script>
@endpush
