@extends('layouts.adminlte')

@section('title', 'Editar Examen')

@section('content_header')
    <h1>Editar Examen: {{ $exam->name }}</h1>
@stop

@section('content')
<div class="container-fluid">
    <!-- Datos del Examen -->
    <div class="card">
        <div class="card-header" style="background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%); color: white;">
            <h3 class="card-title mb-0">
                <i class="fas fa-flask mr-2"></i> Datos del Examen
            </h3>
        </div>
        <form action="{{ route('lab.management.update', $exam->id) }}" method="POST">
            @csrf
            @method('PUT')
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
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="code">Código</label>
                            <input type="text" name="code" id="code" class="form-control" value="{{ old('code', $exam->code) }}" required>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="abbreviation">Abreviatura</label>
                            <input type="text" name="abbreviation" id="abbreviation" class="form-control" value="{{ old('abbreviation', $exam->abbreviation) }}">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="lab_category_id">Categoría</label>
                            <select name="lab_category_id" id="lab_category_id" class="form-control" required>
                                @foreach($categories as $category)
                                    <option value="{{ $category->id }}" {{ $exam->lab_category_id == $category->id ? 'selected' : '' }}>
                                        {{ $category->name }}
                                    </option>
                                @endforeach
                            </select>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label for="price">Precio (USD)</label>
                            <input type="number" step="0.01" name="price" id="price" class="form-control" value="{{ old('price', $exam->price) }}" required>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="name">Nombre del Examen</label>
                    <input type="text" name="name" id="name" class="form-control" value="{{ old('name', $exam->name) }}" required>
                </div>

                <div class="custom-control custom-switch">
                    <input type="checkbox" class="custom-control-input" id="active" name="active" {{ $exam->active ? 'checked' : '' }}>
                    <label class="custom-control-label" for="active">Examen activo</label>
                </div>
            </div>
            <div class="card-footer">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save mr-2"></i> Guardar Cambios
                </button>
                <a href="{{ route('lab.management.index') }}" class="btn btn-secondary">
                    <i class="fas fa-arrow-left mr-2"></i> Volver
                </a>
            </div>
        </form>
    </div>

    <!-- Parámetros del Examen -->
    <div class="card">
        <div class="card-header" style="background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%); color: white;">
            <div class="d-flex justify-content-between align-items-center">
                <h3 class="card-title mb-0">
                    <i class="fas fa-list mr-2"></i> Parámetros del Examen
                </h3>
                <button type="button" 
                        class="btn btn-primary shadow-sm font-weight-bold btn-sm" 
                        data-toggle="modal" 
                        data-target="#modalAddItem">
                    <i class="fas fa-plus-circle mr-2"></i> Agregar Parámetro
                </button>
            </div>
        </div>
        <div class="card-body">
            @if($exam->items->count() > 0)
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th width="5%">Orden</th>
                                <th>Nombre</th>
                                <th width="15%">Unidad</th>
                                <th width="10%">Tipo</th>
                                <th width="10%">Referencias</th>
                                <th width="15%">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach($exam->items->sortBy('order') as $item)
                            <tr>
                                <td>{{ $item->order }}</td>
                                <td><strong>{{ $item->name }}</strong></td>
                                <td>{{ $item->unit ?? '-' }}</td>
                                <td>
                                    @php
                                        $badgeColors = [
                                            'N' => 'primary',
                                            'T' => 'secondary', 
                                            'E' => 'dark',
                                            'O' => 'info',
                                            'F' => 'warning'
                                        ];
                                        $typeLabels = [
                                            'N' => 'Numérico',
                                            'T' => 'Texto',
                                            'E' => 'Encabezado',
                                            'O' => 'Observación',
                                            'F' => 'Fórmula'
                                        ];
                                        $color = $badgeColors[$item->type] ?? 'secondary';
                                        $label = $typeLabels[$item->type] ?? $item->type;
                                    @endphp
                                    <span class="badge badge-{{ $color }}">
                                        {{ $item->type }} - {{ $label }}
                                    </span>
                                </td>
                                <td>
                                    <span class="badge badge-info">{{ $item->referenceRanges->count() }} rangos</span>
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm">
                                        @if($item->type !== 'E')
                                        <a href="{{ route('lab.management.references.index', $item->id) }}" 
                                           class="btn text-white shadow-sm" 
                                           style="background: linear-gradient(135deg, #06b6d4 0%, #0ea5e9 100%);"
                                           title="Gestionar Referencias">
                                            <i class="fas fa-chart-line"></i>
                                        </a>
                                        @endif
                                        <button type="button" 
                                                class="btn text-white shadow-sm" 
                                                style="background: linear-gradient(135deg, #f59e0b 0%, #f97316 100%);"
                                                onclick="editItem({{ $item->id }}, '{{ $item->name }}', '{{ $item->unit }}', '{{ $item->type }}', {{ $item->order }})" 
                                                title="Editar">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button type="button" 
                                                class="btn text-white shadow-sm" 
                                                style="background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);"
                                                onclick="deleteItem({{ $item->id }})" 
                                                title="Eliminar">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
            @else
                <div class="text-center text-muted py-4">
                    <i class="fas fa-inbox fa-3x mb-3"></i>
                    <p>No hay parámetros configurados para este examen.</p>
                    <button type="button" 
                            class="btn btn-primary shadow-sm font-weight-bold" 
                            data-toggle="modal" 
                            data-target="#modalAddItem">
                        <i class="fas fa-plus-circle mr-2"></i> Agregar Primer Parámetro
                    </button>
                </div>
            @endif
        </div>
    </div>
</div>

<!-- Modal Agregar Parámetro -->
<div class="modal fade" id="modalAddItem" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content border-0 shadow-lg">
            <form action="{{ route('lab.management.items.store', $exam->id) }}" method="POST">
                @csrf
                <div class="modal-header text-white border-0" style="background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%);">
                    <h5 class="modal-title">
                        <i class="fas fa-plus-circle mr-2"></i>
                        Agregar Parámetro
                    </h5>
                    <button type="button" class="close text-white" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body bg-light">
                    <div class="form-group">
                        <label class="font-weight-bold">
                            <i class="fas fa-tag mr-1 text-primary"></i>
                            Nombre del Parámetro <span class="text-danger">*</span>
                        </label>
                        <input type="text" name="name" class="form-control" required>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="font-weight-bold">
                                    <i class="fas fa-ruler mr-1 text-info"></i>
                                    Unidad
                                </label>
                                <input type="text" name="unit" class="form-control" placeholder="ej: mg/dL">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="font-weight-bold">
                                    <i class="fas fa-list-ul mr-1 text-warning"></i>
                                    Tipo <span class="text-danger">*</span>
                                </label>
                                <select name="type" class="form-control" required>
                                    <option value="N">N - Numérico (valor numérico)</option>
                                    <option value="T">T - Texto (texto corto)</option>
                                    <option value="E">E - Encabezado (solo título)</option>
                                    <option value="O">O - Observación (texto largo)</option>
                                    <option value="F">F - Fórmula (calculado)</option>
                                </select>
                                <small class="form-text text-muted">
                                    <strong>N:</strong> Para valores numéricos que se pueden validar (ej: 14.5 g/dL)<br>
                                    <strong>T:</strong> Para texto corto (ej: "Positivo", "Negativo")<br>
                                    <strong>E:</strong> Para títulos de sección (no se ingresa valor)<br>
                                    <strong>O:</strong> Para observaciones largas o notas<br>
                                    <strong>F:</strong> Para valores calculados automáticamente
                                </small>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="font-weight-bold">
                            <i class="fas fa-sort-numeric-up mr-1 text-success"></i>
                            Orden <span class="text-danger">*</span>
                        </label>
                        <input type="number" name="order" class="form-control" value="{{ $exam->items->count() + 1 }}" required>
                    </div>
                </div>
                <div class="modal-footer bg-light border-0">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">
                        <i class="fas fa-times mr-1"></i> Cancelar
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save mr-1"></i> Guardar
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Editar Parámetro -->
<div class="modal fade" id="modalEditItem" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content border-0 shadow-lg">
            <form id="formEditItem" method="POST">
                @csrf
                @method('PUT')
                <div class="modal-header text-white border-0" style="background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%);">
                    <h5 class="modal-title">
                        <i class="fas fa-edit mr-2"></i>
                        Editar Parámetro
                    </h5>
                    <button type="button" class="close text-white" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body bg-light">
                    <div class="form-group">
                        <label class="font-weight-bold">
                            <i class="fas fa-tag mr-1 text-primary"></i>
                            Nombre del Parámetro
                        </label>
                        <input type="text" name="name" id="edit_name" class="form-control" required>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="font-weight-bold">
                                    <i class="fas fa-ruler mr-1 text-info"></i>
                                    Unidad
                                </label>
                                <input type="text" name="unit" id="edit_unit" class="form-control">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="font-weight-bold">
                                    <i class="fas fa-list-ul mr-1 text-warning"></i>
                                    Tipo
                                </label>
                                <select name="type" id="edit_type" class="form-control" required>
                                    <option value="N">N - Numérico (valor numérico)</option>
                                    <option value="T">T - Texto (texto corto)</option>
                                    <option value="E">E - Encabezado (solo título)</option>
                                    <option value="O">O - Observación (texto largo)</option>
                                    <option value="F">F - Fórmula (calculado)</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="font-weight-bold">
                            <i class="fas fa-sort-numeric-up mr-1 text-success"></i>
                            Orden
                        </label>
                        <input type="number" name="order" id="edit_order" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer bg-light border-0">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">
                        <i class="fas fa-times mr-1"></i> Cancelar
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save mr-1"></i> Actualizar
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

{{-- Botón de Ayuda Contextual --}}
<x-help-button title="Editar Examen - Ayuda Rápida" :helpLink="route('help.show', 'gestion-laboratorio')">
    <div class="help-quick-guide">
        <h5 class="text-primary"><i class="fas fa-lightbulb mr-2"></i> Guía Rápida: Editar Examen</h5>
        
        <h6 class="font-weight-bold mt-3"><i class="fas fa-edit text-info mr-2"></i> Editar Datos del Examen</h6>
        <p class="small">Modifica el código, nombre, categoría o precio del examen en la sección superior.</p>
        
        <h6 class="font-weight-bold mt-3"><i class="fas fa-plus-circle text-success mr-2"></i> Agregar Parámetros</h6>
        <ol class="small">
            <li>Haz clic en <strong>"Agregar Parámetro"</strong></li>
            <li>Completa: Nombre, Unidad y Orden</li>
            <li>Selecciona el <strong>Tipo</strong> apropiado (ver tipos abajo)</li>
            <li>Guarda el parámetro</li>
        </ol>

        <h6 class="font-weight-bold mt-3"><i class="fas fa-list-ul text-primary mr-2"></i> Tipos de Parámetros</h6>
        <div class="small">
            <div class="mb-2">
                <span class="badge badge-primary">N</span> <strong>Numérico:</strong> Para valores numéricos que se validan contra rangos
                <br><small class="text-muted ml-4">Ejemplo: HEMOGLOBINA: 14.5 g/dL</small>
            </div>
            <div class="mb-2">
                <span class="badge badge-secondary">T</span> <strong>Texto:</strong> Para texto corto (resultados cualitativos)
                <br><small class="text-muted ml-4">Ejemplo: GRUPO SANGUINEO: "O+"</small>
            </div>
            <div class="mb-2">
                <span class="badge badge-dark">E</span> <strong>Encabezado:</strong> Solo título de sección (no se ingresa valor)
                <br><small class="text-muted ml-4">Ejemplo: "HEMATOLOGIA COMPLETA"</small>
            </div>
            <div class="mb-2">
                <span class="badge badge-info">O</span> <strong>Observación:</strong> Para texto largo o notas
                <br><small class="text-muted ml-4">Ejemplo: Observaciones del técnico</small>
            </div>
            <div class="mb-2">
                <span class="badge badge-warning">F</span> <strong>Fórmula:</strong> Valores calculados automáticamente
                <br><small class="text-muted ml-4">Ejemplo: GLOBULINA = PROTEINAS - ALBUMINA</small>
            </div>
        </div>

        <h6 class="font-weight-bold mt-3"><i class="fas fa-chart-line text-primary mr-2"></i> Configurar Referencias</h6>
        <p class="small">Haz clic en el ícono <i class="fas fa-chart-line text-info"></i> de cada parámetro para definir los rangos de referencia por edad y sexo.</p>

        <div class="callout callout-warning mt-3">
            <h6><i class="fas fa-exclamation-triangle mr-2"></i> Importante</h6>
            <p class="small mb-0">El <strong>orden</strong> de los parámetros determina cómo aparecerán en el PDF de resultados. Asegúrate de numerarlos correctamente.</p>
        </div>

        <div class="callout callout-info mt-3">
            <h6><i class="fas fa-toggle-on mr-2"></i> Activar/Desactivar</h6>
            <p class="small mb-0">Usa el switch "Examen activo" para desactivar temporalmente un examen sin eliminarlo.</p>
        </div>
    </div>
</x-help-button>
@stop

@push('scripts')
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
function editItem(id, name, unit, type, order) {
    document.getElementById('formEditItem').action = "{{ url('lab/management/items') }}/" + id;
    document.getElementById('edit_name').value = name;
    document.getElementById('edit_unit').value = unit || '';
    document.getElementById('edit_type').value = type;
    document.getElementById('edit_order').value = order;
    $('#modalEditItem').modal('show');
}

function deleteItem(itemId) {
    Swal.fire({
        title: '¿Eliminar parámetro?',
        text: "Esta acción no se puede deshacer.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Sí, eliminar',
        cancelButtonText: 'Cancelar'
    }).then((result) => {
        if (result.isConfirmed) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = "{{ url('lab/management/items') }}/" + itemId;
            form.innerHTML = '@csrf @method("DELETE")';
            document.body.appendChild(form);
            form.submit();
        }
    });
}
</script>
@endpush
