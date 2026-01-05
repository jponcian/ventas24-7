@extends('layouts.adminlte')

@section('title', 'Cargar Resultados')

@section('sidebar')
    @include('panel.partials.sidebar')
@stop

@section('content_header')
    <h1 class="m-0">Cargar Resultados - Orden {{ $order->order_number }}</h1>
@stop

@section('content')
<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12">
            <h1 class="h3 mb-0">
                <i class="fas fa-edit text-primary"></i> Cargar Resultados - Orden {{ $order->order_number }}
            </h1>
        </div>
    </div>

    <!-- Información del paciente -->
    <div class="card mb-4">
        <div class="card-header bg-info text-white">
            <h5 class="mb-0"><i class="fas fa-user"></i> Información del Paciente</h5>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-2">
                    <strong>Paciente:</strong><br>{{ $order->patient->name }}
                </div>
                <div class="col-md-2">
                    <strong>Cédula:</strong><br>{{ $order->patient->cedula }}
                </div>
                <div class="col-md-2">
                    <strong>Fecha de Orden:</strong><br>{{ $order->order_date->format('d/m/Y') }}
                </div>
                <div class="col-md-2">
                    <strong>Sexo:</strong><br>{{ $order->patient->sexo == 'M' ? 'Masculino' : ($order->patient->sexo == 'F' ? 'Femenino' : 'No especificado') }}
                </div>
                <div class="col-md-2">
                    <strong>Edad:</strong><br>{{ \Carbon\Carbon::parse($order->patient->fecha_nacimiento)->age ?? 'No disponible' }} años
                </div>
            </div>
        </div>
    </div>

    <form action="{{ route('lab.orders.store-results', $order->id) }}" method="POST">
        @csrf
        

        <!-- Resultados por examen -->
        @foreach($order->details as $detail)
            <div class="card mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-flask"></i> {{ $detail->exam->name }}
                        @if($detail->exam->abbreviation)
                            <small>({{ $detail->exam->abbreviation }})</small>
                        @endif
                    </h5>
                </div>
                <div class="card-body">
                    @if($detail->exam->items->count() > 0)
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <thead class="table-light">
                                    <tr>
                                        <th width="35%">Parámetro</th>
                                        <th width="20%">Valor</th>
                                        <th width="15%" class="d-none d-md-table-cell">Unidad</th>
                                        <th width="25%" class="d-none d-md-table-cell">Rango de Referencia</th>
                                        <th width="5%" class="text-center"><i class="fas fa-trash-alt"></i></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @foreach($detail->exam->items as $item)
                                        @php
                                            $existingResult = $detail->results->where('lab_exam_item_id', $item->id)->first();
                                        @endphp
                                        <tr>
                                            <td>
                                                <strong>{{ $item->name }}</strong>
                                            </td>
                                            <td>
                                                <input type="text" 
                                                       name="results[{{ $item->id }}][value]" 
                                                       class="form-control" 
                                                       value="{{ old('results.'.$item->id.'.value', $existingResult?->value) }}"
                                                       placeholder="Ingrese valor">
                                            </td>
                                            </td>
                                            <td class="d-none d-md-table-cell">
                                                <span class="text-muted">{{ $item->unit ?? 'N/A' }}</span>
                                            </td>
                                            <td class="d-none d-md-table-cell">
                                                @php
                                                    $rango = $item->getReferenceRangeForPatient($order->patient);
                                                    $esColeccion = $rango instanceof \Illuminate\Support\Collection;
                                                @endphp

                                                @if($esColeccion)
                                                    @foreach($rango as $rng)
                                                        <div class="mb-1">
                                                            <span class="badge badge-info text-wrap" style="font-size: 0.9em;">
                                                                {{ !empty($rng->value_text) ? $rng->value_text : ($rng->value_min . ' - ' . $rng->value_max) }}
                                                            </span>
                                                            @if($rng->condition)
                                                                <br><small class="text-muted">({{ $rng->condition }})</small>
                                                            @endif
                                                        </div>
                                                    @endforeach
                                                @elseif($rango)
                                                    <span class="badge badge-info text-wrap" style="font-size: 0.9em;">
                                                        {{ !empty($rango->value_text) ? $rango->value_text : ($rango->value_min . ' - ' . $rango->value_max) }}
                                                    </span>
                                                    @if($rango->condition)
                                                        <br><small class="text-muted">({{ $rango->condition }})</small>
                                                    @endif
                                                @else
                                                    <span class="text-muted">{{ $item->reference_value ?? 'N/A' }}</span>
                                                @endif
                                            </td>
                                            <td>
                                                <button type="button" class="btn btn-danger btn-sm delete-exam-item" title="Borrar parámetro" data-item-id="{{ $item->id }}">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                    @else
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle"></i> Este examen no tiene ítems configurados.
                        </div>
                    @endif
                </div>
            </div>
        @endforeach

        <!-- Observaciones Generales -->
        <div class="card mb-4">
            <div class="card-header bg-secondary text-white">
                <h5 class="mb-0">
                    <i class="fas fa-comment-alt"></i> Observaciones Generales
                </h5>
            </div>
            <div class="card-body">
                <textarea name="observations" class="form-control" rows="3" placeholder="Observaciones generales para el reporte...">{{ old('observations', $order->observations) }}</textarea>
                <small class="text-muted">Estas observaciones aparecerán en el reporte final.</small>
            </div>
        </div>

        <!-- Botones -->
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between">
                    <a href="{{ route('lab.orders.show', $order->id) }}" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Volver
                    </a>
                    <button type="submit" id="save-results-btn" class="btn btn-success">
                        <span id="btnContent">
                            <i class="fas fa-save"></i> Guardar Resultados
                        </span>
                        <span id="btnLoading" style="display: none;">
                            <i class="fas fa-spinner fa-spin"></i> Guardando...
                        </span>
                    </button>
                </div>
            </div>
        </div>
    </form>
</div>
@endsection

@push('scripts')
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Manejo de eliminación de parámetros
    document.querySelectorAll('.delete-exam-item').forEach(function(btn) {
        btn.addEventListener('click', function() {
            Swal.fire({
                title: '¿Seguro que desea borrar este parámetro?',
                text: 'Esta acción no se puede deshacer.',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Sí, borrar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    var itemId = btn.getAttribute('data-item-id');
                    fetch("{{ route('lab.orders.delete-exam-item') }}", {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'X-CSRF-TOKEN': '{{ csrf_token() }}'
                        },
                        body: JSON.stringify({ item_id: itemId })
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            Swal.fire({
                                title: '¡Borrado!',
                                text: 'El parámetro fue eliminado correctamente.',
                                icon: 'success',
                                timer: 1500,
                                showConfirmButton: false
                            }).then(() => {
                                location.reload();
                            });
                        } else {
                            Swal.fire('Error', 'No se pudo borrar el parámetro.', 'error');
                        }
                    })
                    .catch(() => Swal.fire('Error', 'Error de red al intentar borrar.', 'error'));
                }
            });
        });
    });

    // Prevención de múltiples clics al guardar resultados
    const form = document.querySelector('form[action*="store-results"]');
    if (form) {
        const saveBtn = document.getElementById('save-results-btn');
        const btnContent = document.getElementById('btnContent');
        const btnLoading = document.getElementById('btnLoading');
        let isSubmitting = false;

        form.addEventListener('submit', function(e) {
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
            if (saveBtn) {
                saveBtn.disabled = true;
                saveBtn.style.cursor = 'not-allowed';
                saveBtn.style.opacity = '0.7';
                saveBtn.style.pointerEvents = 'none';
            }

            // Cambiar el contenido del botón
            if (btnContent && btnLoading) {
                btnContent.style.display = 'none';
                btnLoading.style.display = 'inline';
            }

            // Mostrar indicador de carga
            Swal.fire({
                title: 'Guardando resultados...',
                html: 'Por favor espere mientras se guardan los resultados y se envían las notificaciones.',
                allowOutsideClick: false,
                allowEscapeKey: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            // Por seguridad, re-habilitar después de 30 segundos en caso de error de red
            setTimeout(() => {
                if (isSubmitting) {
                    isSubmitting = false;
                    if (saveBtn) {
                        saveBtn.disabled = false;
                        saveBtn.style.cursor = 'pointer';
                        saveBtn.style.opacity = '1';
                        saveBtn.style.pointerEvents = 'auto';
                    }
                    if (btnContent && btnLoading) {
                        btnContent.style.display = 'inline';
                        btnLoading.style.display = 'none';
                    }
                    Swal.close();
                }
            }, 30000);

            return true;
        }, true);
    }
});
</script>
@endpush

{{-- Botón de Ayuda Contextual --}}
<x-help-button title="Cargar Resultados - Ayuda Rápida" :helpLink="route('help.show', 'cargar-resultados')">
    <div class="help-quick-guide">
        <h5 class="text-primary"><i class="fas fa-lightbulb mr-2"></i> Guía Rápida: Cargar Resultados</h5>
        
        <h6 class="font-weight-bold mt-3"><i class="fas fa-keyboard text-primary mr-2"></i> Ingresar Valores</h6>
        <p class="small">Completa el campo "Valor" para cada parámetro del examen.</p>
        <ul class="small">
            <li><strong>Numéricos:</strong> Solo el número (ej: 15.2, 95)</li>
            <li><strong>Texto:</strong> Resultado descriptivo (ej: Negativo, Positivo)</li>
        </ul>

        <h6 class="font-weight-bold mt-3"><i class="fas fa-chart-line text-info mr-2"></i> Rangos de Referencia</h6>
        <p class="small">Los rangos se muestran automáticamente según la edad y sexo del paciente. No necesitas buscarlos manualmente.</p>

        <h6 class="font-weight-bold mt-3"><i class="fas fa-comment text-success mr-2"></i> Observaciones</h6>
        <p class="small">Usa el campo de observaciones generales para notas importantes, condiciones especiales o recomendaciones.</p>

        <div class="callout callout-success mt-3">
            <h6><i class="fas fa-check-circle mr-2"></i> Guardar</h6>
            <p class="small mb-0">Revisa todos los valores antes de guardar. Una vez guardados, la orden cambiará a estado "Completada" y se podrá generar el PDF.</p>
        </div>

        <div class="callout callout-info mt-3">
            <h6><i class="fas fa-mobile-alt mr-2"></i> Versión Móvil</h6>
            <p class="small mb-0">En móviles, las columnas "Unidad" y "Rango de Referencia" están ocultas para facilitar la carga de datos.</p>
        </div>
    </div>
</x-help-button>
