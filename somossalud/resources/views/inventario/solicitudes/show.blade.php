@extends('layouts.adminlte')

@section('title', 'Detalle de Solicitud')

@section('content_header')
    <div class="d-flex justify-content-between align-items-center">
        <h1>
            <span class="text-muted">Solicitud</span> 
            <strong>{{ $solicitud->numero_solicitud }}</strong>
        </h1>
        <div>
            @if($solicitud->isPendiente() && (auth()->user()->can('approve', $solicitud) || auth()->user()->id == $solicitud->solicitante_id))
                @can('approve', $solicitud)
                    <a href="{{ route('inventario.solicitudes.edit', $solicitud) }}" class="btn btn-warning shadow-sm">
                        <i class="fas fa-tasks"></i> Gestionar Aprobación
                    </a>
                @endcan
                
                @can('delete', $solicitud)
                    <form action="{{ route('inventario.solicitudes.destroy', $solicitud) }}" method="POST" style="display:inline-block" onsubmit="return confirm('¿Eliminar solicitud?');">
                        @csrf @method('DELETE')
                        <button type="submit" class="btn btn-danger shadow-sm ml-2">
                            <i class="fas fa-trash"></i> Eliminar
                        </button>
                    </form>
                @endcan
            @endif
            
            @if($solicitud->isAprobada() && auth()->user()->can('dispatch', $solicitud))
                <form action="{{ route('inventario.solicitudes.despachar', $solicitud) }}" method="POST" style="display:inline-block" id="formDespacho">
                    @csrf
                    {{-- Input hidden para items se llenaría dinámicamente si quisiéramos despacho parcial, 
                         pero para simplificar despachamos todo lo aprobado por defecto --}}
                    @foreach($solicitud->items as $item)
                        <input type="hidden" name="items[{{ $loop->index }}][id]" value="{{ $item->id }}">
                        <input type="hidden" name="items[{{ $loop->index }}][cantidad_despachada]" value="{{ $item->cantidad_aprobada }}">
                    @endforeach
                    
                    <button type="button" class="btn btn-success shadow-sm ml-2" onclick="confirmarDespacho()">
                        <i class="fas fa-truck-loading"></i> Despachar Todo
                    </button>
                </form>
            @endif
            
            <a href="{{ route('inventario.solicitudes.index') }}" class="btn btn-secondary ml-2">
                <i class="fas fa-arrow-left"></i> Volver
            </a>
        </div>
    </div>
@stop

@section('content')
    <div class="row">
        {{-- Columna Izquierda: Detalles --}}
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header bg-white border-bottom-0">
                    <div class="d-flex justify-content-between align-items-center">
                        <h3 class="card-title text-primary font-weight-bold"><i class="fas fa-list-alt"></i> Items de la Solicitud</h3>
                        
                        @if($solicitud->isAprobada() && auth()->user()->can('dispatch', $solicitud))
                            <form action="{{ route('inventario.solicitudes.despachar', $solicitud) }}" method="POST" style="display:inline-block" id="formDespacho">
                                @csrf
                                @foreach($solicitud->items as $item)
                                    <input type="hidden" name="items[{{ $loop->index }}][id]" value="{{ $item->id }}">
                                    <input type="hidden" name="items[{{ $loop->index }}][cantidad_despachada]" value="{{ $item->cantidad_aprobada }}">
                                @endforeach
                                
                                <button type="button" class="btn btn-success shadow-sm" onclick="confirmarDespacho()">
                                    <i class="fas fa-truck-loading"></i> Despachar Todo
                                </button>
                            </form>
                        @endif
                    </div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped mb-0">
                            <thead class="bg-light">
                                <tr>
                                    <th class="pl-4">Item / Material</th>
                                    <th>Descripción</th>
                                    <th class="text-center">Cant. Solicitada</th>
                                    @if(!$solicitud->isPendiente())
                                        <th class="text-center">Cant. Aprobada</th>
                                    @endif
                                    @if($solicitud->isDespachada())
                                        <th class="text-center">Cant. Despachada</th>
                                    @endif
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($solicitud->items as $item)
                                    <tr>
                                        <td class="pl-4">
                                            <div class="font-weight-bold">{{ $item->nombre_item }}</div>
                                            @if($item->material)
                                                <small class="text-info"><i class="fas fa-link"></i> Catálogo</small>
                                            @else
                                                <small class="text-muted"><i class="fas fa-pen"></i> Texto libre</small>
                                            @endif
                                        </td>
                                        <td>
                                            <small class="text-muted">{{ $item->descripcion ?? '-' }}</small>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge badge-light border px-2 py-1" style="font-size: 0.9rem;">
                                                {{ $item->cantidad_solicitada }} {{ $item->unidad_medida }}
                                            </span>
                                        </td>
                                        @if(!$solicitud->isPendiente())
                                            <td class="text-center">
                                                @if($item->cantidad_aprobada < $item->cantidad_solicitada)
                                                    <span class="text-warning font-weight-bold" title="Cantidad ajustada">
                                                        <i class="fas fa-exclamation-triangle"></i> {{ $item->cantidad_aprobada }}
                                                    </span>
                                                @else
                                                    <span class="text-success font-weight-bold">
                                                        <i class="fas fa-check"></i> {{ $item->cantidad_aprobada }}
                                                    </span>
                                                @endif
                                            </td>
                                        @endif
                                        @if($solicitud->isDespachada())
                                            <td class="text-center">
                                                <span class="badge badge-success px-2">
                                                    {{ $item->cantidad_despachada }}
                                                </span>
                                            </td>
                                        @endif
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            {{-- Observaciones --}}
            @if($solicitud->observaciones_solicitante)
                <div class="card shadow-sm mt-3">
                    <div class="card-header bg-light">
                        <h3 class="card-title text-muted small font-weight-bold">OBSERVACIONES DEL SOLICITANTE</h3>
                    </div>
                    <div class="card-body">
                        <p class="mb-0">{{ $solicitud->observaciones_solicitante }}</p>
                    </div>
                </div>
            @endif
            
            @if($solicitud->observaciones_aprobador)
                <div class="card shadow-sm mt-3 border-left-warning" style="border-left: 4px solid #ffc107;">
                    <div class="card-header bg-light">
                        <h3 class="card-title text-warning small font-weight-bold">OBSERVACIONES DE APROBACIÓN/RECHAZO</h3>
                    </div>
                    <div class="card-body">
                        <p class="mb-0">{{ $solicitud->observaciones_aprobador }}</p>
                    </div>
                </div>
            @endif

            <div class="mt-4 mb-4">
                <a href="{{ route('inventario.solicitudes.index') }}" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Volver al Listado
                </a>
            </div>
        </div>

        {{-- Columna Derecha: Info --}}
        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-header bg-{{ $solicitud->badge_color }} text-white">
                    <h3 class="card-title font-weight-bold">Estado: {{ ucfirst($solicitud->estado) }}</h3>
                </div>
                <div class="card-body p-0">
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item">
                            <small class="text-muted d-block">CATEGORÍA</small>
                            <strong>{{ $solicitud->categoria }}</strong>
                        </li>
                        <li class="list-group-item">
                            <small class="text-muted d-block">SOLICITANTE</small>
                            <div class="d-flex align-items-center mt-1">
                                <div class="bg-light rounded-circle text-center mr-2" style="width:30px;height:30px;line-height:30px;">
                                    <i class="fas fa-user text-muted"></i>
                                </div>
                                <div>
                                    <div class="font-weight-bold">{{ $solicitud->solicitante->name }}</div>
                                    <small class="text-muted">{{ $solicitud->created_at->format('d/m/Y H:i') }}</small>
                                </div>
                            </div>
                        </li>
                        
                        @if($solicitud->aprobadoPor)
                            <li class="list-group-item">
                                <small class="text-muted d-block">APROBADO POR</small>
                                <div class="d-flex align-items-center mt-1">
                                    <div class="bg-light rounded-circle text-center mr-2" style="width:30px;height:30px;line-height:30px;">
                                        <i class="fas fa-user-check text-success"></i>
                                    </div>
                                    <div>
                                        <div class="font-weight-bold">{{ $solicitud->aprobadoPor->name }}</div>
                                        <small class="text-muted">{{ $solicitud->fecha_aprobacion->format('d/m/Y H:i') }}</small>
                                    </div>
                                </div>
                            </li>
                        @endif
                        
                        @if($solicitud->despachadoPor)
                            <li class="list-group-item">
                                <small class="text-muted d-block">DESPACHADO POR</small>
                                <div class="d-flex align-items-center mt-1">
                                    <div class="bg-light rounded-circle text-center mr-2" style="width:30px;height:30px;line-height:30px;">
                                        <i class="fas fa-truck text-info"></i>
                                    </div>
                                    <div>
                                        <div class="font-weight-bold">{{ $solicitud->despachadoPor->name }}</div>
                                        <small class="text-muted">{{ $solicitud->fecha_despacho->format('d/m/Y H:i') }}</small>
                                    </div>
                                </div>
                            </li>
                        @endif
                    </ul>
                </div>
            </div>
        </div>
    </div>
@stop

@push('scripts')
<script>
    function confirmarDespacho() {
        Swal.fire({
            title: '¿Confirmar Despacho?',
            text: "Se marcarán todos los items aprobados como despachados.",
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#28a745',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Sí, despachar',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                document.getElementById('formDespacho').submit();
            }
        })
    }
</script>
@endpush
