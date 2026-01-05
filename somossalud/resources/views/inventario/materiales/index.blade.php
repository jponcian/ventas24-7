@extends('layouts.adminlte')

@section('title', 'Gestión de Materiales')

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
        .btn-sm {
            padding: 0.375rem 0.75rem;
            font-size: 0.875rem;
        }
        .btn-warning {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            border: none;
            color: white;
        }
        .btn-warning:hover {
            background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
            color: white;
            transform: translateY(-1px);
        }
        .btn-danger {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            border: none;
        }
        .btn-danger:hover {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
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
        .badge-warning {
            background-color: #fef9c3;
            color: #854d0e;
        }
        .badge-danger {
            background-color: #fee2e2;
            color: #991b1b;
        }
        .content-header h1 {
            font-weight: 600;
            color: #1e293b;
        }
    </style>
@endpush

@section('content')
    <div class="card mb-4">
        <div class="card-header">
            <h3 class="card-title">
                <i class="fas fa-filter text-primary"></i>
                Filtros de Búsqueda
            </h3>
            <div class="card-tools">
                <a href="{{ route('inventario.materiales.create') }}" 
                   class="btn text-white shadow-sm font-weight-bold btn-sm" 
                   style="background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%); transition: all 0.3s ease;"
                   onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 12px rgba(14, 165, 233, 0.4)'"
                   onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow=''">
                    <i class="fas fa-plus mr-1"></i>
                    Nuevo Material
                </a>
                <button type="button" class="btn btn-tool" data-card-widget="collapse">
                    <i class="fas fa-minus"></i>
                </button>
            </div>
        </div>
        <div class="card-body">
            <form method="GET" action="{{ route('inventario.materiales.index') }}">
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>
                                <i class="fas fa-search text-muted mr-1"></i>
                                Buscar
                            </label>
                            <input type="text" name="search" class="form-control" placeholder="Buscar por nombre o código..." value="{{ request('search') }}">
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
                                @foreach($categorias as $cat)
                                    <option value="{{ $cat }}" {{ request('categoria') == $cat ? 'selected' : '' }}>{{ $cat }}</option>
                                @endforeach
                            </select>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>
                                <i class="fas fa-warehouse text-muted mr-1"></i>
                                Estado de Stock
                            </label>
                            <select name="stock_status" class="form-control select2" data-minimum-results-for-search="Infinity">
                                <option value="">Todos</option>
                                <option value="bajo" {{ request('stock_status') == 'bajo' ? 'selected' : '' }}>Stock Bajo</option>
                                <option value="normal" {{ request('stock_status') == 'normal' ? 'selected' : '' }}>Stock Normal</option>
                            </select>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <h3 class="card-title">
                <i class="fas fa-list text-primary"></i>
                Listado de Materiales
            </h3>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-striped mb-0">
                    <thead>
                        <tr>
                            <th class="pl-4">Código</th>
                            <th>Nombre</th>
                            <th>Categoría</th>
                            <th>Unidad</th>
                            <th class="text-center">Stock Actual</th>
                            <th class="text-center">Stock Mínimo</th>
                            <th class="text-right pr-4">Acciones</th>
                        </tr>
                    </thead>
                    <tbody id="materialesTableBody">
                        @include('inventario.materiales.table_rows')
                    </tbody>
                </table>
            </div>
        </div>
        <div id="paginationLinks">
            @if($materiales->hasPages())
                <div class="card-footer bg-white">
                    {{ $materiales->links() }}
                </div>
            @endif
        </div>
    </div>

    {{-- Botón de Ayuda Contextual --}}
    <x-help-button section="gestion-materiales">
        <x-slot name="quickGuide">
            <h6 class="font-weight-bold mb-3">Guía Rápida - Gestión de Materiales</h6>
            
            <div class="mb-3">
                <strong class="text-primary"><i class="fas fa-search mr-1"></i> Búsqueda Interactiva:</strong>
                <p class="small mb-0 mt-1">Escribe al menos 3 caracteres para buscar. Los resultados se actualizan automáticamente. Puedes combinar búsqueda por nombre y filtros de categoría.</p>
            </div>

            <div class="mb-3">
                <strong class="text-success"><i class="fas fa-plus-circle mr-1"></i> Crear Material:</strong>
                <ol class="small mb-0 mt-1">
                    <li>Haz clic en "Nuevo Material"</li>
                    <li>Completa nombre, categoría y unidad</li>
                    <li>Define stock inicial (opcional) y stock mínimo</li>
                    <li>Guarda el material</li>
                </ol>
                <small class="text-muted">
                    <i class="fas fa-info-circle"></i> El stock inicial solo se puede establecer al crear el material
                </small>
            </div>

            <div class="mb-3">
                <strong class="text-warning"><i class="fas fa-boxes mr-1"></i> Indicadores de Stock:</strong>
                <ul class="small mb-0 mt-1">
                    <li><span class="badge badge-danger">Rojo</span> - Stock crítico (por debajo del mínimo)</li>
                    <li><span class="badge badge-warning">Amarillo</span> - Stock en alerta</li>
                    <li><span class="badge badge-success">Verde</span> - Stock suficiente</li>
                </ul>
            </div>

            <div class="mb-3">
                <strong class="text-info"><i class="fas fa-folder mr-1"></i> Categorías Disponibles:</strong>
                <ul class="small mb-0 mt-1">
                    <li><strong>ENFERMERIA:</strong> Gasas, jeringas, guantes, vendas</li>
                    <li><strong>QUIROFANO:</strong> Instrumental quirúrgico, suturas</li>
                    <li><strong>UCI:</strong> Equipos de cuidados intensivos</li>
                    <li><strong>OFICINA:</strong> Papelería y suministros</li>
                    <li><strong>LABORATORIO:</strong> Reactivos, tubos, kits de diagnóstico</li>
                </ul>
            </div>

            <div class="alert alert-info small mb-0">
                <i class="fas fa-info-circle mr-1"></i>
                <strong>Tip:</strong> Para ajustar el stock, usa el módulo de "Registro de Ingresos" en lugar de editar directamente el material.
            </div>
        </x-slot>
    </x-help-button>
@endsection

@push('scripts')
<script>
    $(document).ready(function() {
        let searchTimeout;

        function fetchMateriales() {
            const search = $('input[name="search"]').val();
            const categoria = $('select[name="categoria"]').val();
            const stockStatus = $('select[name="stock_status"]').val();

            $.ajax({
                url: "{{ route('inventario.materiales.index') }}",
                type: "GET",
                data: {
                    search: search,
                    categoria: categoria,
                    stock_status: stockStatus
                },
                success: function(response) {
                    $('#materialesTableBody').html(response);
                },
                error: function(xhr) {
                    console.error('Error fetching materials:', xhr);
                }
            });
        }

        $('input[name="search"]').on('input', function() {
            clearTimeout(searchTimeout);
            const val = $(this).val();

            if (val.length > 2 || val.length === 0) {
                searchTimeout = setTimeout(fetchMateriales, 300);
            }
        });

        $('select[name="categoria"]').on('change', function() {
            fetchMateriales();
        });

        $('select[name="stock_status"]').on('change', function() {
            fetchMateriales();
        });
        
        // Prevent form submission on enter for search input
        $('form').on('submit', function(e) {
            e.preventDefault();
            fetchMateriales();
        });

        // Initialize select2
        $('.select2').select2({
            theme: 'bootstrap4',
            width: '100%'
        });
    });
</script>
@endpush
