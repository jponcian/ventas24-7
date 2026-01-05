@extends('layouts.adminlte')

@section('title', 'Nueva Solicitud')

@section('content_header')
    <div class="d-flex justify-content-between align-items-center">
        <h1><i class="fas fa-cart-plus text-primary"></i> Nueva Solicitud de Materiales</h1>
        <a href="{{ route('inventario.solicitudes.index') }}" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Volver
        </a>
    </div>
@stop

@section('content')
    <form action="{{ route('inventario.solicitudes.store') }}" method="POST" id="formSolicitud">
        @csrf
        
        <div class="row">
            <div class="col-md-8">
                {{-- Información general --}}
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-primary text-white">
                        <h3 class="card-title"><i class="fas fa-info-circle"></i> Datos de la Solicitud</h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="categoria" class="font-weight-bold">Categoría <span class="text-danger">*</span></label>
                                    <select name="categoria" id="categoria" class="form-control select2 @error('categoria') is-invalid @enderror" required>
                                        <option value="">Seleccione una categoría</option>
                                        @foreach($categorias as $cat)
                                            <option value="{{ $cat }}" {{ old('categoria') == $cat ? 'selected' : '' }}>
                                                {{ $cat }}
                                            </option>
                                        @endforeach
                                    </select>
                                    <small class="form-text text-muted">La categoría ayuda a filtrar los materiales sugeridos.</small>
                                    @error('categoria')
                                        <span class="invalid-feedback">{{ $message }}</span>
                                    @enderror
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="font-weight-bold">Solicitante</label>
                                    <input type="text" class="form-control bg-light" value="{{ auth()->user()->name }}" readonly>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="observaciones_solicitante" class="font-weight-bold">Observaciones / Justificación</label>
                            <textarea name="observaciones_solicitante" 
                                      id="observaciones_solicitante" 
                                      class="form-control @error('observaciones_solicitante') is-invalid @enderror" 
                                      rows="2" 
                                      placeholder="Ej: Reposición mensual para el área de emergencias...">{{ old('observaciones_solicitante') }}</textarea>
                            @error('observaciones_solicitante')
                                <span class="invalid-feedback">{{ $message }}</span>
                            @enderror
                        </div>
                    </div>
                </div>

                {{-- Formulario para agregar items --}}
                <div class="card shadow-lg border-primary">
                    <div class="card-header bg-white">
                        <h3 class="card-title text-primary font-weight-bold"><i class="fas fa-boxes"></i> Items Solicitados</h3>
                    </div>
                    <div class="card-body bg-light">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="small font-weight-bold text-muted">BUSCAR MATERIAL</label>
                                <select id="materialSelect" class="form-control" style="width: 100%;">
                                    <option value="">Buscar material...</option>
                                </select>
                            </div>
                            
                            <div class="col-md-3 mb-3">
                                <label class="small font-weight-bold text-muted">UNIDAD</label>
                                <select id="unidadInput" class="form-control">
                                    @foreach($unidadesMedida as $unidad)
                                        <option value="{{ $unidad }}">{{ $unidad }}</option>
                                    @endforeach
                                </select>
                            </div>
                            
                            <div class="col-md-3 mb-3">
                                <label class="small font-weight-bold text-muted">CANTIDAD</label>
                                <input type="number" id="cantidadInput" class="form-control font-weight-bold text-center" min="1" value="1">
                            </div>
                        </div>
                        
                        <div class="text-right">
                            <button type="button" class="btn btn-success shadow-sm" id="btnAgregarAlCarrito">
                                <i class="fas fa-cart-plus"></i> Agregar al Carrito
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                {{-- Resumen con lista de items --}}
                <div class="card card-outline card-primary shadow sticky-top" style="top: 20px;">
                    <div class="card-header">
                        <h3 class="card-title font-weight-bold"><i class="fas fa-clipboard-check"></i> Resumen</h3>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between mb-3 border-bottom pb-2">
                            <span class="text-muted">Total Items:</span>
                            <span id="totalItems" class="font-weight-bold h5 text-primary mb-0">0</span>
                        </div>
                        
                        <div id="listaItems" class="mb-3" style="max-height: 400px; overflow-y: auto;">
                            <!-- Los items se mostrarán aquí -->
                        </div>
                        
                        <div id="emptyState" class="text-center py-4 text-muted">
                            <i class="fas fa-shopping-cart fa-2x mb-2"></i>
                            <p class="small mb-0">No hay items en el carrito</p>
                        </div>
                        
                        <div class="alert alert-info small mb-0">
                            <i class="fas fa-lightbulb"></i> <strong>Tip:</strong>
                            Puede buscar materiales existentes o escribir nombres nuevos si no encuentra lo que busca.
                        </div>
                    </div>
                    <div class="card-footer bg-white">
                        <button type="submit" class="btn btn-primary btn-block btn-lg shadow-sm">
                            <i class="fas fa-paper-plane"></i> Enviar Solicitud
                        </button>
                        <a href="{{ route('inventario.solicitudes.index') }}" class="btn btn-default btn-block">
                            Cancelar
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </form>
@stop

@push('scripts')
<script>
let carrito = []; // Array para almacenar los items del carrito
let itemCounter = 0;

// Inicializar Select2 para el material
function initMaterialSelect() {
    $('#materialSelect').select2({
        theme: 'bootstrap4',
        placeholder: 'Seleccione un material...',
        allowClear: true,
        minimumInputLength: 0,
        ajax: {
            url: '{{ url("inventario/solicitudes/buscar-materiales") }}',
            dataType: 'json',
            delay: 300,
            data: function (params) {
                return {
                    q: params.term
                };
            },
            processResults: function (data, params) {
                if (data.error) {
                    console.error('Error del servidor:', data.error);
                    return { results: [] };
                }
                // Ordenar alfabéticamente por nombre
                data.sort(function(a, b) {
                    return a.text.localeCompare(b.text);
                });
                return { results: data };
            },
            error: function(xhr, status, error) {
                console.error('Error AJAX:', {
                    status: xhr.status,
                    statusText: xhr.statusText,
                    error: error,
                    response: xhr.responseText
                });
            },
            cache: true
        },
        language: {
            searching: function() { return 'Buscando...'; },
            noResults: function() { return 'No se encontraron materiales registrados.'; },
            errorLoading: function() { return 'No se pudieron cargar los resultados.'; }
        }
    }).on('select2:select', function (e) {
        var data = e.params.data;
        if (data.unidad) {
            $('#unidadInput').val(data.unidad);
        }
    });
}

// Agregar item al carrito
$('#btnAgregarAlCarrito').click(function() {
    const materialData = $('#materialSelect').select2('data')[0];
    
    if (!materialData || !materialData.id) {
        Swal.fire({
            icon: 'warning',
            title: 'Material requerido',
            text: 'Por favor, seleccione un material del catálogo.',
            confirmButtonText: 'Entendido'
        });
        return;
    }
    
    const cantidad = parseInt($('#cantidadInput').val()) || 1;
    const unidad = $('#unidadInput').val();
    
    // Crear objeto del item (solo materiales registrados)
    const item = {
        index: itemCounter++,
        material_id: materialData.id,
        nombre: materialData.text,
        unidad: unidad,
        cantidad: cantidad
    };
    
    // Agregar al carrito
    carrito.push(item);
    
    // Actualizar vista
    renderizarCarrito();
    limpiarFormulario();
    
    // Mostrar feedback
    toastr.success(`${item.nombre} agregado al carrito`);
});

// Renderizar el carrito en el resumen
function renderizarCarrito() {
    const $listaItems = $('#listaItems');
    $listaItems.empty();
    
    if (carrito.length === 0) {
        $('#emptyState').show();
        $('#totalItems').text('0');
        return;
    }
    
    $('#emptyState').hide();
    $('#totalItems').text(carrito.length);
    
    carrito.forEach((item, index) => {
        const itemHtml = `
            <div class="card mb-2 shadow-sm" data-index="${index}">
                <div class="card-body p-2">
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="flex-grow-1">
                            <h6 class="mb-1 font-weight-bold text-dark" style="font-size: 0.9rem;">
                                ${item.nombre}
                            </h6>
                            <div class="d-flex align-items-center gap-2">
                                <span class="badge badge-primary">${item.cantidad} ${item.unidad}</span>
                            </div>
                        </div>
                        <button type="button" class="btn btn-sm btn-danger btn-eliminar-item ml-2" data-index="${index}" title="Eliminar">
                            <i class="fas fa-trash-alt"></i>
                        </button>
                    </div>
                    
                    <!-- Hidden inputs para enviar con el formulario -->
                    <input type="hidden" name="items[${index}][material_id]" value="${item.material_id}">
                    <input type="hidden" name="items[${index}][nombre_item]" value="${item.nombre}">
                    <input type="hidden" name="items[${index}][unidad_medida]" value="${item.unidad}">
                    <input type="hidden" name="items[${index}][cantidad_solicitada]" value="${item.cantidad}">
                </div>
            </div>
        `;
        $listaItems.append(itemHtml);
    });
}

// Eliminar item del carrito
$(document).on('click', '.btn-eliminar-item', function() {
    const index = $(this).data('index');
    carrito.splice(index, 1);
    renderizarCarrito();
    toastr.info('Item eliminado del carrito');
});

// Limpiar formulario después de agregar
function limpiarFormulario() {
    $('#materialSelect').val(null).trigger('change');
    $('#cantidadInput').val('1');
    // Mantener la unidad seleccionada por defecto
}

// Validar formulario antes de enviar
$('#formSolicitud').submit(function(e) {
    if (carrito.length === 0) {
        e.preventDefault();
        Swal.fire({
            icon: 'warning',
            title: 'Carrito vacío',
            text: 'Debe agregar al menos un item a la solicitud.',
            confirmButtonText: 'Entendido'
        });
        return false;
    }
});

// Inicialización
$(document).ready(function() {
    // Select2 para categoría
    $('#categoria').select2({
        theme: 'bootstrap4',
        placeholder: 'Seleccione categoría'
    });
    
    // Inicializar select2 del material
    initMaterialSelect();
    
    // Mostrar estado vacío inicial
    $('#emptyState').show();
});
</script>

{{-- Estilos adicionales --}}
<style>
    .select2-selection.is-invalid {
        border-color: #dc3545 !important;
    }
    #listaItems .card {
        transition: all 0.2s;
    }
    #listaItems .card:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.1) !important;
    }
</style>
@endpush
