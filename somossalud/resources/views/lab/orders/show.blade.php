@extends('layouts.adminlte')

@section('title', 'Detalle de Orden')

@section('sidebar')
    @include('panel.partials.sidebar')
@stop

@section('content_header')
    <h1>Detalle de Orden de Laboratorio</h1>
@stop

@section('content')
<div class="container-fluid">
    @if(session('success'))
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle"></i> {{ session('success') }}
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
    @endif

    <div class="row align-items-start">
        <div class="col-md-8">
            <!-- Información de la Orden -->
            <div class="card">
                <div class="card-header" style="background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%); color: white;">
                    <h3 class="card-title mb-0">
                        <i class="fas fa-file-medical"></i> Orden {{ $order->order_number }}
                    </h3>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <h5 class="text-muted mb-2">Información del Paciente</h5>
                            <p class="mb-1"><strong>Nombre:</strong> {{ $order->patient->name }}</p>
                            <p class="mb-1"><strong>Cédula:</strong> {{ $order->patient->cedula }}</p>
                            <p class="mb-1"><strong>Email:</strong> {{ $order->patient->email }}</p>
                            @if($order->patient->fecha_nacimiento)
                                <p class="mb-1"><strong>Fecha de Nacimiento:</strong> {{ \Carbon\Carbon::parse($order->patient->fecha_nacimiento)->format('d/m/Y') }}</p>
                            @endif
                        </div>
                        <div class="col-md-6">
                            <h5 class="text-muted mb-2">Información de la Orden</h5>
                            <p class="mb-1"><strong>Estado:</strong> 
                                @if($order->status == 'pending')
                                    <span class="badge badge-warning">Pendiente</span>
                                @elseif($order->status == 'in_progress')
                                    <span class="badge badge-info">En Proceso</span>
                                @elseif($order->status == 'completed')
                                    <span class="badge badge-success">Completado</span>
                                @else
                                    <span class="badge badge-danger">Cancelado</span>
                                @endif
                            </p>
                            {{-- <p class="mb-1"><strong>Fecha Orden:</strong> {{ $order->order_date->format('d/m/Y') }}</p> --}}
                            @if($order->sample_date)
                                <p class="mb-1"><strong>Fecha Muestra:</strong> {{ $order->sample_date->format('d/m/Y') }}</p>
                            @endif
                            @if($order->result_date)
                                <p class="mb-1"><strong>Fecha Resultado:</strong> {{ $order->result_date->format('d/m/Y') }}</p>
                            @endif
                            <p class="mb-1"><strong>Clínica:</strong> {{ $order->clinica->nombre }}</p>
                        </div>
                    </div>

                    <hr>

                    <h5 class="text-muted mb-3">Exámenes Solicitados</h5>
                    @foreach($order->details as $detail)
                        <div class="mb-4">
                            <h6 class="text-primary">
                                <i class="fas fa-flask"></i> {{ $detail->exam->name }}
                                <span class="badge badge-info">${{ number_format($detail->price, 2) }}</span>
                            </h6>
                            
                            @if($detail->results->count() > 0)
                                <div class="table-responsive">
                                    <table class="table table-bordered table-hover table-sm">
                                        <thead class="thead-light">
                                            <tr>
                                                <th>Parámetro</th>
                                                <th>Valor</th>
                                                <th>Unidad</th>
                                                <th>Rango de Referencia</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            @foreach($detail->results as $result)
                                            <tr>
                                                <td><strong>{{ $result->examItem->name }}</strong></td>
                                                <td>{{ $result->value }}</td>
                                                <td>{{ $result->examItem->unit ?? '-' }}</td>
                                                <td>

                                                    @php
                                                        $rango = $result->examItem->getReferenceRangeForPatient($order->patient);
                                                        $esColeccion = $rango instanceof \Illuminate\Support\Collection;
                                                    @endphp

                                                    @if($esColeccion)
                                                        @foreach($rango as $rng)
                                                            <div class="mb-1">
                                                                <span class="badge badge-light border text-wrap" style="font-size: 0.9em;">
                                                                    {{ !empty($rng->value_text) ? $rng->value_text : ($rng->value_min . ' - ' . $rng->value_max) }}
                                                                </span>
                                                                @if($rng->condition)
                                                                    <br><small class="text-muted">({{ $rng->condition }})</small>
                                                                @endif
                                                            </div>
                                                        @endforeach
                                                    @elseif($rango)
                                                        <span class="badge badge-light border text-wrap" style="font-size: 0.9em;">
                                                            {{ !empty($rango->value_text) ? $rango->value_text : ($rango->value_min . ' - ' . $rango->value_max) }}
                                                        </span>
                                                        @if($rango->condition)
                                                            <br><small class="text-muted">({{ $rango->condition }})</small>
                                                        @endif
                                                    @else
                                                        {{ $result->examItem->reference_value ?? '-' }}
                                                    @endif
                                                </td>
                                            </tr>
                                            @endforeach
                                        </tbody>
                                    </table>
                                </div>
                            @else
                                <p class="text-muted"><em>Sin resultados cargados</em></p>
                            @endif
                        </div>
                    @endforeach

                    @if($order->observations)
                    <hr>
                    <h5 class="text-muted mb-2">Observaciones</h5>
                    <p class="text-justify">{{ $order->observations }}</p>
                    @endif

                    <hr>

                    <div class="row">
                        <div class="col-md-6">
                            <p class="mb-1"><strong>Resultados por:</strong> {{ $order->resultsLoadedBy->name ?? '-------------' }}</p>
                            <p class="mb-1"><strong>Fecha de resultados:</strong> {{ $order->result_date ? $order->result_date->format('d/m/Y h:i A') : '-------------' }}</p>
                        </div>
                        <div class="col-md-6 text-right">
                            <p class="mb-1"><strong>Total:</strong> <span class="h4 text-success">${{ number_format($order->total, 2) }}</span></p>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    @if($order->isCompleted())
                        <a href="{{ route('lab.orders.pdf', $order->id) }}" class="btn btn-danger">
                            <i class="fas fa-file-pdf"></i> Descargar PDF con QR
                        </a>
                        
                        @if(config('whatsapp.enabled') && !empty($order->patient->telefono))
                            <form id="whatsapp-form" action="{{ route('lab.orders.send-whatsapp', $order->id) }}" method="POST" class="d-inline">
                                @csrf
                                <button type="submit" id="whatsapp-btn" class="btn btn-success">
                                    <span id="whatsappBtnContent">
                                        <i class="fab fa-whatsapp"></i> Enviar PDF por WhatsApp
                                    </span>
                                    <span id="whatsappBtnLoading" style="display: none;">
                                        <i class="fas fa-spinner fa-spin"></i> Enviando...
                                    </span>
                                </button>
                            </form>
                        @endif
                    @endif
                    @if(($order->isPending() || $order->isInProgress()) && auth()->user()->hasRole(['laboratorio-resul', 'admin_clinica', 'super-admin']))
                        <a href="{{ route('lab.orders.load-results', $order->id) }}" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Cargar Resultados
                        </a>
                    @endif
                    
                    @if(auth()->user()->hasRole(['super-admin', 'admin_clinica']))
                        <form id="delete-order-form" action="{{ route('lab.orders.destroy', $order->id) }}" method="POST" class="d-inline">
                            @csrf
                            @method('DELETE')
                            <button type="button" id="delete-order-btn" class="btn btn-danger">
                                <i class="fas fa-trash"></i> Eliminar Orden
                            </button>
                        </form>
                    @endif
                    
                    <a href="{{ route('lab.orders.index') }}" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Volver al Listado
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            @if($order->isCompleted() && $order->verification_code)
                <!-- Código de Verificación -->
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h3 class="card-title mb-0">
                            <i class="fas fa-qrcode"></i> Código de Verificación
                        </h3>
                    </div>
                    <div class="card-body text-center">
                        <div class="mb-3">
                            {!! QrCode::size(200)->generate(route('lab.orders.verify', $order->verification_code)) !!}
                        </div>
                        <p class="mb-2"><strong>Código:</strong></p>
                        <h4 class="text-primary">{{ $order->verification_code }}</h4>
                        <hr>
                        <p class="text-muted small mb-2">URL de Verificación:</p>
                        <a href="{{ route('lab.orders.verify', $order->verification_code) }}" target="_blank" class="btn btn-sm btn-outline-primary">
                            <i class="fas fa-external-link-alt"></i> Verificar Resultado
                        </a>
                    </div>
                </div>

                <!-- Información Adicional -->
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h3 class="card-title mb-0">
                            <i class="fas fa-info-circle"></i> Información
                        </h3>
                    </div>
                    <div class="card-body">
                        <p class="small text-muted mb-2">
                            <i class="fas fa-shield-alt"></i> Este resultado puede ser verificado escaneando el código QR o ingresando el código de verificación en nuestro sitio web.
                        </p>
                        <p class="small text-muted mb-0">
                            <i class="fas fa-lock"></i> El código QR garantiza la autenticidad del documento y previene falsificaciones.
                        </p>
                    </div>
                </div>
            @endif
            
            {{-- Visor de Ticket PDF - Solo visible cuando NO está completada --}}
            @if(!$order->isCompleted())
                <div class="card">
                    <div class="card-header" style="background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%); color: white;">
                        <h3 class="card-title mb-0">
                            <i class="fas fa-receipt"></i> Ticket de Orden
                        </h3>
                    </div>
                    <div class="card-body p-0">
                        <iframe 
                            src="{{ route('lab.orders.ticket', $order->id) }}" 
                            style="width: 100%; height: 450px; border: none;"
                            title="Ticket de Orden"
                        ></iframe>
                    </div>
                    <div class="card-footer text-center bg-light">
                        <a href="{{ route('lab.orders.ticket', $order->id) }}" 
                           target="_blank" 
                           class="btn btn-sm btn-primary">
                            <i class="fas fa-print mr-1"></i>Imprimir Ticket
                        </a>
                        <br>
                        <small class="text-muted mt-2 d-block">
                            <i class="fas fa-info-circle"></i> Para toma de muestra
                        </small>
                    </div>
                </div>
            @endif
        </div>
    </div>
</div>
@stop

@section('css')
<style>
    .table th {
        background-color: #f8f9fa;
        font-weight: 600;
    }
    
    .card-header {
        border-radius: 0.25rem 0.25rem 0 0 !important;
    }
</style>
@stop

@push('scripts')
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Prevención de múltiples clics en el botón de WhatsApp
        const whatsappForm = document.getElementById('whatsapp-form');
        
        if (whatsappForm) {
            const whatsappBtn = document.getElementById('whatsapp-btn');
            const whatsappBtnContent = document.getElementById('whatsappBtnContent');
            const whatsappBtnLoading = document.getElementById('whatsappBtnLoading');
            let isSubmitting = false;

            whatsappForm.addEventListener('submit', function(e) {
                // Si ya se está enviando, prevenir completamente
                if (isSubmitting) {
                    e.preventDefault();
                    e.stopPropagation();
                    e.stopImmediatePropagation();
                    return false;
                }

                // Marcar como enviando inmediatamente
                isSubmitting = true;

                // Deshabilitar el botón inmediatamente
                if (whatsappBtn) {
                    whatsappBtn.disabled = true;
                    whatsappBtn.style.cursor = 'not-allowed';
                    whatsappBtn.style.opacity = '0.7';
                    whatsappBtn.style.pointerEvents = 'none';
                }

                // Cambiar el contenido del botón
                if (whatsappBtnContent && whatsappBtnLoading) {
                    whatsappBtnContent.style.display = 'none';
                    whatsappBtnLoading.style.display = 'inline';
                }

                // Por seguridad, re-habilitar después de 30 segundos en caso de error de red
                setTimeout(() => {
                    if (isSubmitting) {
                        isSubmitting = false;
                        if (whatsappBtn) {
                            whatsappBtn.disabled = false;
                            whatsappBtn.style.cursor = 'pointer';
                            whatsappBtn.style.opacity = '1';
                            whatsappBtn.style.pointerEvents = 'auto';
                        }
                        if (whatsappBtnContent && whatsappBtnLoading) {
                            whatsappBtnContent.style.display = 'inline';
                            whatsappBtnLoading.style.display = 'none';
                        }
                    }
                }, 30000);

                return true;
            }, true);
        }
        
        // Confirmación para eliminar orden
        const deleteBtn = document.getElementById('delete-order-btn');
        if (deleteBtn) {
            deleteBtn.addEventListener('click', function(e) {
                e.preventDefault();
                
                Swal.fire({
                    title: '¿Eliminar esta orden?',
                    html: 'Esta acción eliminará permanentemente:<br>• La orden de laboratorio<br>• Todos los resultados<br>• Los exámenes asociados<br><br><strong>Esta acción NO se puede deshacer.</strong>',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#3085d6',
                    confirmButtonText: 'Sí, eliminar',
                    cancelButtonText: 'Cancelar',
                    reverseButtons: false
                }).then((result) => {
                    if (result.isConfirmed) {
                        document.getElementById('delete-order-form').submit();
                    }
                });
            });
        }
    });
</script>
@endpush