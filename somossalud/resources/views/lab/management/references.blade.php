@extends('layouts.adminlte')

@section('title', 'Gestionar Referencias')

@section('content_header')
    <h1>Referencias: {{ $item->name }}</h1>
@stop

@section('content')
<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header" style="background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%); color: white;">
                    <div class="d-flex justify-content-between align-items-center">
                        <h3 class="card-title mb-0">
                            <i class="fas fa-chart-line mr-2"></i> Rangos de Referencia
                        </h3>
                        <div>
                            <button type="button" class="btn btn-success" data-toggle="modal" data-target="#modalAddReference">
                                <i class="fas fa-plus mr-2"></i> Agregar Referencia
                            </button>
                            <a href="{{ route('lab.management.edit', $item->exam->id) }}" class="btn btn-secondary">
                                <i class="fas fa-arrow-left mr-2"></i> Volver
                            </a>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    @if($item->referenceRanges->count() > 0)
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Grupo de Referencia</th>
                                        <th>Sexo</th>
                                        <th>Edad (años)</th>
                                        <th>Valor Mín</th>
                                        <th>Valor Máx</th>
                                        <th>Valor Texto</th>
                                        <th>Condición</th>
                                        <th width="100">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @foreach($item->referenceRanges as $ref)
                                    <tr>
                                        <td>
                                            <strong>{{ $ref->group->description }}</strong><br>
                                            <small class="text-muted">{{ $ref->group->code }}</small>
                                        </td>
                                        <td>
                                            @if($ref->group->sex == 1)
                                                <span class="badge badge-primary">Masculino</span>
                                            @elseif($ref->group->sex == 2)
                                                <span class="badge badge-danger">Femenino</span>
                                            @else
                                                <span class="badge badge-secondary">Todos</span>
                                            @endif
                                        </td>
                                        <td>{{ $ref->group->age_start_year }} - {{ $ref->group->age_end_year }}</td>
                                        <td>{{ $ref->value_min ?? '-' }}</td>
                                        <td>{{ $ref->value_max ?? '-' }}</td>
                                        <td>{{ $ref->value_text ?? '-' }}</td>
                                        <td>{{ $ref->condition ?? '-' }}</td>
                                        <td>
                                            <div class="btn-group btn-group-sm">
                                                <button type="button" class="btn btn-danger" onclick="deleteReference({{ $ref->id }})" title="Eliminar">
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
                        <div class="text-center text-muted py-5">
                            <i class="fas fa-inbox fa-3x mb-3"></i>
                            <p>No hay rangos de referencia configurados para este parámetro.</p>
                            <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#modalAddReference">
                                <i class="fas fa-plus mr-2"></i> Agregar Primera Referencia
                            </button>
                        </div>
                    @endif
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Agregar Referencia -->
<div class="modal fade" id="modalAddReference" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content border-0 shadow-lg">
            <form action="{{ route('lab.management.references.store', $item->id) }}" method="POST">
                @csrf
                <div class="modal-header text-white border-0" style="background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%);">
                    <h5 class="modal-title">
                        <i class="fas fa-plus-circle mr-2"></i>
                        Agregar Rango de Referencia
                    </h5>
                    <button type="button" class="close text-white" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body bg-light">
                    <div class="alert alert-info border-0 shadow-sm mb-4">
                        <i class="fas fa-info-circle mr-2"></i>
                        <strong>Importante:</strong> Para grupos de "Configuración Manual", debe especificar la condición exacta (ej. "Fase Folicular", "Diabéticos") en el campo "Condición Especial".
                    </div>

                    <div class="form-group">
                        <label class="font-weight-bold">
                            <i class="fas fa-layer-group mr-1 text-primary"></i>
                            Grupo de Referencia <span class="text-danger">*</span>
                        </label>
                        <div style="width: 100%;">
                            <select name="lab_reference_group_id" class="form-control select2" required style="width: 100%;">
                                <option value="">Seleccione un grupo...</option>
                            @foreach($groupedOptions as $category => $groups)
                                <optgroup label="{{ $category }}">
                                @foreach($groups as $group)
                                    <option value="{{ $group->id }}">
                                        @php
                                            $desc = $group->description;
                                            
                                            // Lógica para grupos Manuales
                                            if (str_contains($desc, 'Manual')) {
                                                $displayText = "Manual / Personalizado (Especifique Condición)";
                                            }
                                            // Lógica para grupos Automáticos
                                            else {
                                                // Calcular texto de edad
                                                $ageText = "";
                                                if ($group->age_start_year == 0 && $group->age_end_year == 0) {
                                                     if (str_contains($desc, 'NEONATOS')) $ageText = '1-2 días';
                                                     elseif (str_contains($desc, 'RECIEN NACIDOS')) $ageText = '3-30 días';
                                                     elseif (str_contains($desc, 'INFANTES')) $ageText = '1-12 meses';
                                                } 
                                                elseif ($desc == 'NIÑOS' || str_starts_with($desc, 'NIÑOS-')) {
                                                     if ($group->age_start_year > 0) $ageText = "{$group->age_start_year}-{$group->age_end_year} años";
                                                }
                                                else {
                                                     $ageText = "{$group->age_start_year}-{$group->age_end_year} años";
                                                }

                                                // Limpiar nombre (Quitar " - Sexo")
                                                $cleanTitle = $desc;
                                                if (str_contains($desc, ' - ')) {
                                                    $parts = explode(' - ', $desc);
                                                    $cleanTitle = $parts[0];
                                                }
                                                
                                                if ($ageText) {
                                                    $displayText = "{$cleanTitle} ({$ageText})";
                                                } else {
                                                    $displayText = $cleanTitle;
                                                }
                                            }
                                        @endphp
                                        {{ $displayText }}
                                    </option>
                                @endforeach
                                </optgroup>
                            @endforeach
                        </select>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="font-weight-bold">
                                    <i class="fas fa-arrow-down mr-1 text-success"></i>
                                    Valor Mínimo
                                </label>
                                <input type="text" name="value_min" class="form-control" placeholder="Ej: 4.5">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="font-weight-bold">
                                    <i class="fas fa-arrow-up mr-1 text-danger"></i>
                                    Valor Máximo
                                </label>
                                <input type="text" name="value_max" class="form-control" placeholder="Ej: 11.0">
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="font-weight-bold">
                            <i class="fas fa-font mr-1 text-info"></i>
                            Valor Texto (alternativo)
                        </label>
                        <input type="text" name="value_text" class="form-control" placeholder="Ej: Negativo, Positivo, etc.">
                        <small class="text-muted">Use esto para valores no numéricos</small>
                    </div>

                    <div class="form-group">
                        <label class="font-weight-bold">
                            <i class="fas fa-clipboard-list mr-1 text-warning"></i>
                            Condición Especial
                        </label>
                        <input type="text" name="condition" class="form-control" placeholder="Ej: 40-49 años, Fase folicular, En ayunas">
                        <small class="text-muted">
                            <i class="fas fa-lightbulb mr-1"></i>
                            Ejemplos: "Hombres 40-49 años", "Mujeres premenopausia", "En ayunas", "Fase folicular"
                        </small>
                    </div>
                </div>
                <div class="modal-footer bg-light border-0">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">
                        <i class="fas fa-times mr-1"></i> Cancelar
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save mr-1"></i> Guardar Referencia
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

{{-- Botón de Ayuda Contextual --}}
{{-- Botón de Ayuda Contextual --}}
<x-help-button title="Rangos de Referencia - Ayuda Rápida" :helpLink="route('help.show', 'gestion-laboratorio')">
    <div class="help-quick-guide">
        <h5 class="text-primary"><i class="fas fa-lightbulb mr-2"></i> Guía Rápida: Rangos de Referencia</h5>
        
        <p class="small text-muted">
            Los rangos de referencia permiten al sistema validar automáticamente si un resultado es normal, bajo o alto, considerando la edad y sexo del paciente.
        </p>

        <h6 class="font-weight-bold mt-3"><i class="fas fa-layer-group text-info mr-2"></i> Grupos de Referencia</h6>
        <div class="small mb-3">
            <p class="mb-1">El sistema selecciona automáticamente el rango correcto basado en:</p>
            <ul class="mb-0 pl-3">
                <li><i class="fas fa-venus-mars text-muted mr-1"></i> <strong>Sexo:</strong> Masculino, Femenino o Todos</li>
                <li><i class="fas fa-birthday-cake text-muted mr-1"></i> <strong>Edad:</strong> Rango de años (ej: 0-12, 18-99)</li>
            </ul>
        </div>

        <h6 class="font-weight-bold mt-3"><i class="fas fa-plus-circle text-success mr-2"></i> Cómo Configurar</h6>
        <ol class="small">
            <li>Haz clic en <strong>"Agregar Referencia"</strong></li>
            <li>Selecciona el <strong>Grupo</strong> adecuado (ej: Hombres Adultos)</li>
            <li>Define los límites:
                <div class="mt-1 ml-2 p-2 bg-light rounded border">
                    <div class="mb-1"><strong>Numérico:</strong> Min: <code>13.5</code> - Max: <code>17.5</code></div>
                    <div class="mb-1"><strong>Límite:</strong> Min: <code>NULL</code> - Max: <code>200</code> (Hasta 200)</div>
                    <div><strong>Texto:</strong> Valor Texto: <code>Negativo</code></div>
                </div>
            </li>
            <li>Guarda la referencia</li>
        </ol>

        <h6 class="font-weight-bold mt-3"><i class="fas fa-flask text-warning mr-2"></i> Ejemplos Comunes</h6>
        
        <div class="accordion" id="accordionHelp">
            <!-- Ejemplo 1 -->
            <div class="card mb-1 shadow-none border">
                <div class="card-header p-2" id="headingOne">
                    <h2 class="mb-0">
                        <button class="btn btn-link btn-block text-left p-0 text-dark small font-weight-bold" type="button" data-toggle="collapse" data-target="#collapseOne">
                            <i class="fas fa-tint text-danger mr-2"></i> Hemoglobina (Numérico)
                        </button>
                    </h2>
                </div>
                <div id="collapseOne" class="collapse" data-parent="#accordionHelp">
                    <div class="card-body p-2 small bg-light">
                        <p class="mb-1"><strong>Hombres Adultos:</strong> 13.5 - 17.5</p>
                        <p class="mb-1"><strong>Mujeres Adultas:</strong> 12.0 - 15.5</p>
                        <p class="mb-0"><strong>Niños:</strong> 11.0 - 14.0</p>
                    </div>
                </div>
            </div>

            <!-- Ejemplo 2 -->
            <div class="card mb-1 shadow-none border">
                <div class="card-header p-2" id="headingTwo">
                    <h2 class="mb-0">
                        <button class="btn btn-link btn-block text-left p-0 text-dark small font-weight-bold" type="button" data-toggle="collapse" data-target="#collapseTwo">
                            <i class="fas fa-virus text-success mr-2"></i> Serología (Cualitativo)
                        </button>
                    </h2>
                </div>
                <div id="collapseTwo" class="collapse" data-parent="#accordionHelp">
                    <div class="card-body p-2 small bg-light">
                        <p class="mb-1"><strong>Valor Texto:</strong> Negativo</p>
                        <p class="mb-0"><strong>Condición:</strong> Si el resultado es distinto, se marca como anormal.</p>
                    </div>
                </div>
            </div>

            <!-- Ejemplo 3 -->
            <div class="card mb-0 shadow-none border">
                <div class="card-header p-2" id="headingThree">
                    <h2 class="mb-0">
                        <button class="btn btn-link btn-block text-left p-0 text-dark small font-weight-bold" type="button" data-toggle="collapse" data-target="#collapseThree">
                            <i class="fas fa-hamburger text-warning mr-2"></i> Colesterol (Límite Máximo)
                        </button>
                    </h2>
                </div>
                <div id="collapseThree" class="collapse" data-parent="#accordionHelp">
                    <div class="card-body p-2 small bg-light">
                        <p class="mb-1"><strong>Valor Min:</strong> (vacío)</p>
                        <p class="mb-1"><strong>Valor Max:</strong> 200</p>
                        <p class="mb-0">Cualquier valor sobre 200 será alto.</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="callout callout-info mt-3 py-2 px-3">
            <p class="small mb-0">
                <i class="fas fa-info-circle mr-1"></i> El sistema validará automáticamente los resultados ingresados contra estos rangos.
            </p>
        </div>
    </div>
</x-help-button>
@stop

@push('styles')
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@ttskch/select2-bootstrap4-theme@x.x.x/dist/select2-bootstrap4.min.css">
@endpush

@push('scripts')
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
$(document).ready(function() {
    $('.select2').select2({
        theme: 'bootstrap4',
        width: '100%',
        dropdownParent: $('#modalAddReference')
    });
});

function deleteReference(refId) {
    Swal.fire({
        title: '¿Eliminar referencia?',
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
            form.action = "{{ url('lab/management/references') }}/" + refId;
            form.innerHTML = '@csrf @method("DELETE")';
            document.body.appendChild(form);
            form.submit();
        }
    });
}
</script>
@endpush
