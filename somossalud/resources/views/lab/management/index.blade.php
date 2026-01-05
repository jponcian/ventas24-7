@extends('layouts.adminlte')

@section('title', 'Gestión de Exámenes')

@section('content_header')
    <h1>Gestión de Exámenes de Laboratorio</h1>
@stop

@section('content')
<div class="container-fluid">
    <div class="card">
        <div class="card-header border-0 d-flex justify-content-between align-items-center" style="background: linear-gradient(135deg, #dbeafe 0%, #dcfce7 100%); border-bottom: 1px solid #cbd5e1;">
            <h3 class="card-title font-weight-bold text-primary mb-0">
                <i class="fas fa-vials mr-2"></i> Listado de Exámenes
            </h3>
            <a href="{{ route('lab.management.create') }}" 
               class="btn text-white shadow-sm font-weight-bold" 
               style="background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%); transition: all 0.3s ease;"
               onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 12px rgba(14, 165, 233, 0.4)'"
               onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow=''">
                <i class="fas fa-plus-circle mr-2"></i> Nuevo Examen
            </a>
        </div>
        <div class="card-body">
            <!-- Filtros -->
            <form method="GET" class="mb-3">
                <div class="row">
                    <div class="col-md-4">
                        <input type="text" name="search" class="form-control" placeholder="Buscar por nombre, código o abreviatura..." value="{{ request('search') }}">
                    </div>
                    <div class="col-md-3">
                        <select name="category_id" class="form-control">
                            <option value="">Todas las categorías</option>
                            @foreach($categories as $category)
                                <option value="{{ $category->id }}" {{ request('category_id') == $category->id ? 'selected' : '' }}>
                                    {{ $category->name }}
                                </option>
                            @endforeach
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-secondary btn-block">
                            <i class="fas fa-search"></i> Buscar
                        </button>
                    </div>
                    <div class="col-md-2">
                        <a href="{{ route('lab.management.index') }}" class="btn btn-light btn-block">
                            <i class="fas fa-times"></i> Limpiar
                        </a>
                    </div>
                </div>
            </form>

            <!-- Tabla -->
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Código</th>
                            <th>Nombre</th>
                            <th>Categoría</th>
                            <th>Abreviatura</th>
                            <th>Precio</th>
                            <th>Parámetros</th>
                            <th>Estado</th>
                            <th width="120">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($exams as $exam)
                        <tr>
                            <td><code>{{ $exam->code }}</code></td>
                            <td><strong>{{ $exam->name }}</strong></td>
                            <td>
                                <span class="badge badge-info">{{ $exam->category->name }}</span>
                            </td>
                            <td>{{ $exam->abbreviation ?? '-' }}</td>
                            <td>${{ number_format($exam->price, 2) }}</td>
                            <td>
                                <span class="badge badge-secondary">{{ $exam->items->count() }} items</span>
                            </td>
                            <td>
                                @if($exam->active)
                                    <span class="badge badge-success">Activo</span>
                                @else
                                    <span class="badge badge-danger">Inactivo</span>
                                @endif
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <a href="{{ route('lab.management.edit', $exam->id) }}" 
                                       class="btn text-white shadow-sm" 
                                       style="background: linear-gradient(135deg, #06b6d4 0%, #0ea5e9 100%);"
                                       title="Editar">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button type="button" 
                                            class="btn text-white shadow-sm" 
                                            style="background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);"
                                            onclick="confirmDelete({{ $exam->id }})" 
                                            title="Eliminar">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                                <form id="delete-form-{{ $exam->id }}" action="{{ route('lab.management.destroy', $exam->id) }}" method="POST" class="d-none">
                                    @csrf
                                    @method('DELETE')
                                </form>
                            </td>
                        </tr>
                        @empty
                        <tr>
                            <td colspan="8" class="text-center text-muted py-4">
                                <i class="fas fa-inbox fa-3x mb-3"></i>
                                <p>No se encontraron exámenes.</p>
                            </td>
                        </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>

            <!-- Paginación -->
            <div class="mt-3">
                {{ $exams->links() }}
            </div>
        </div>
    </div>
</div>

{{-- Botón de Ayuda Contextual --}}
<x-help-button title="Gestión de Exámenes - Ayuda Rápida" :helpLink="route('help.show', 'gestion-laboratorio')">
    <div class="help-quick-guide">
        <h5 class="text-primary"><i class="fas fa-lightbulb mr-2"></i> Guía Rápida</h5>
        
        <div class="alert alert-info">
            <strong>En esta página puedes:</strong>
            <ul class="mb-0 mt-2">
                <li>Ver todos los exámenes de laboratorio</li>
                <li>Buscar y filtrar exámenes</li>
                <li>Crear nuevos exámenes</li>
                <li>Editar o eliminar exámenes existentes</li>
            </ul>
        </div>

        <h6 class="font-weight-bold mt-3"><i class="fas fa-plus-circle text-success mr-2"></i> Crear un Examen</h6>
        <ol class="small">
            <li>Haz clic en el botón <strong class="text-primary">"+ Nuevo Examen"</strong></li>
            <li>Completa el formulario con los datos del examen</li>
            <li>Guarda y luego agrega los parámetros individuales</li>
        </ol>

        <h6 class="font-weight-bold mt-3"><i class="fas fa-edit text-info mr-2"></i> Editar un Examen</h6>
        <ol class="small">
            <li>Busca el examen en la tabla</li>
            <li>Haz clic en el botón azul <i class="fas fa-edit"></i></li>
            <li>Modifica los datos y guarda los cambios</li>
        </ol>

        <div class="callout callout-warning mt-3">
            <h6><i class="fas fa-exclamation-triangle mr-2"></i> Importante</h6>
            <p class="small mb-0">No podrás eliminar exámenes que tengan órdenes asociadas. En su lugar, desactívalos usando el switch "Examen activo".</p>
        </div>
    </div>
</x-help-button>
@stop

@push('scripts')
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
function confirmDelete(examId) {
    Swal.fire({
        title: '¿Eliminar examen?',
        text: "Esta acción no se puede deshacer.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Sí, eliminar',
        cancelButtonText: 'Cancelar'
    }).then((result) => {
        if (result.isConfirmed) {
            document.getElementById('delete-form-' + examId).submit();
        }
    });
}
</script>
@endpush
