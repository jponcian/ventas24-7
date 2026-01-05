@extends('layouts.adminlte')

@section('title', 'Gestionar Solicitud')

@section('content_header')
    <div class="d-flex justify-content-between align-items-center">
        <h1><i class="fas fa-tasks text-warning"></i> Gestionar Solicitud {{ $solicitud->numero_solicitud }}</h1>
        <a href="{{ route('inventario.solicitudes.show', $solicitud) }}" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Cancelar
        </a>
    </div>
@stop

@section('content')
    <form action="{{ route('inventario.solicitudes.aprobar', $solicitud) }}" method="POST" id="formGestion">
        @csrf
        
        <div class="row">
            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-header bg-warning">
                        <h3 class="card-title text-dark"><i class="fas fa-check-double"></i> Revisión de Items</h3>
                        <div class="card-tools">
                            <span class="badge badge-light text-dark">Total: {{ $solicitud->total_items }} items</span>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="bg-light">
                                    <tr>
                                        <th class="pl-4" style="width: 40%">Item</th>
                                        <th class="text-center" style="width: 20%">Solicitado</th>
                                        <th class="text-center" style="width: 20%">Aprobar</th>
                                        <th class="text-center" style="width: 20%">Estado</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @foreach($solicitud->items as $index => $item)
                                        <tr>
                                            <td class="pl-4 align-middle">
                                                <input type="hidden" name="items[{{ $index }}][id]" value="{{ $item->id }}">
                                                <div class="font-weight-bold">{{ $item->nombre_item }}</div>
                                                <small class="text-muted">{{ $item->descripcion }}</small>
                                            </td>
                                            <td class="text-center align-middle">
                                                <span class="badge badge-light border px-3 py-2" style="font-size: 1rem;">
                                                    {{ $item->cantidad_solicitada }} <small>{{ $item->unidad_medida }}</small>
                                                </span>
                                            </td>
                                            <td class="text-center align-middle">
                                                <input type="number" 
                                                       name="items[{{ $index }}][cantidad_aprobada]" 
                                                       class="form-control text-center font-weight-bold input-aprobado" 
                                                       value="{{ $item->cantidad_solicitada }}" 
                                                       min="0"
                                                       data-solicitado="{{ $item->cantidad_solicitada }}">
                                            </td>
                                            <td class="text-center align-middle">
                                                <span class="badge badge-success badge-status-item">Aprobado</span>
                                            </td>
                                        </tr>
                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card shadow sticky-top" style="top: 20px;">
                    <div class="card-header bg-white">
                        <h3 class="card-title font-weight-bold">Decisión Final</h3>
                    </div>
                    <div class="card-body">
                        <div class="form-group">
                            <label class="font-weight-bold">Observaciones de Aprobación/Rechazo</label>
                            <textarea name="observaciones_aprobador" 
                                      class="form-control" 
                                      rows="3" 
                                      placeholder="Ingrese comentarios sobre la decisión..."></textarea>
                        </div>
                        
                        <hr>
                        
                        <div class="row">
                            <div class="col-6">
                                <button type="submit" name="accion" value="rechazar" class="btn btn-outline-danger btn-block" onclick="return confirm('¿Seguro que desea RECHAZAR toda la solicitud?');">
                                    <i class="fas fa-times"></i> Rechazar
                                </button>
                            </div>
                            <div class="col-6">
                                <button type="submit" name="accion" value="aprobar" class="btn btn-success btn-block shadow-sm">
                                    <i class="fas fa-check"></i> Aprobar
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
@stop

@push('scripts')
<script>
    // Lógica visual para cambios de cantidad
    $('.input-aprobado').on('input change', function() {
        let val = parseInt($(this).val()) || 0;
        let solicitado = parseInt($(this).data('solicitado'));
        let $badge = $(this).closest('tr').find('.badge-status-item');
        
        if (val === 0) {
            $badge.removeClass('badge-success badge-warning').addClass('badge-danger').text('Rechazado');
            $(this).addClass('is-invalid text-danger');
        } else if (val < solicitado) {
            $badge.removeClass('badge-success badge-danger').addClass('badge-warning').text('Parcial');
            $(this).addClass('text-warning').removeClass('is-invalid text-danger');
        } else {
            $badge.removeClass('badge-warning badge-danger').addClass('badge-success').text('Aprobado');
            $(this).removeClass('is-invalid text-danger text-warning');
        }
    });
</script>
@endpush
