@extends('layouts.adminlte')

@section('title', 'Atenciones - Ayuda')

@section('content_header')
    <h1><i class="fas fa-ambulance mr-2"></i> Gestión de Atenciones</h1>
@stop

@section('content')
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-md-2">
            <div class="card card-primary card-outline sticky-top" style="top: 70px;">
                <div class="card-header">
                    <h3 class="card-title"><i class="fas fa-book mr-2"></i> Contenido</h3>
                </div>
                <div class="card-body p-0">
                    <div class="list-group list-group-flush">
                        <a href="{{ route('help.index') }}" class="list-group-item list-group-item-action">
                            <i class="fas fa-arrow-left mr-2"></i> Volver al inicio
                        </a>
                        <a href="#introduccion" class="list-group-item list-group-item-action">1. Introducción</a>
                        <a href="#crear" class="list-group-item list-group-item-action">2. Crear Atención</a>
                        <a href="#validar" class="list-group-item list-group-item-action">3. Validar Seguro</a>
                        <a href="#estados" class="list-group-item list-group-item-action">4. Estados</a>
                        <a href="#cerrar" class="list-group-item list-group-item-action">5. Cerrar Atención</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Content -->
        <div class="col-md-10">
            <!-- Introducción -->
            <div class="card" id="introduccion">
                <div class="card-header bg-primary">
                    <h3 class="card-title text-white"><i class="fas fa-info-circle mr-2"></i> 1. Introducción</h3>
                </div>
                <div class="card-body">
                    <p class="lead">El módulo de <strong>Atenciones</strong> permite gestionar las consultas médicas y validar pagos de seguros.</p>
                    
                    <div class="alert alert-info">
                        <i class="fas fa-lightbulb mr-2"></i>
                        <strong>¿Qué es una atención?</strong><br>
                        Es el registro de una consulta médica que puede estar cubierta por un seguro o ser particular. Incluye datos del paciente, aseguradora, número de siniestro y estado de validación.
                    </div>

                    <h5 class="mt-4"><i class="fas fa-user-tag mr-2"></i> ¿Quién puede usar este módulo?</h5>
                    <ul>
                        <li><strong>Recepción/Admin:</strong> Crear atenciones, validar seguros, cerrar atenciones</li>
                        <li><strong>Especialistas:</strong> Ver sus atenciones asignadas y gestionarlas</li>
                    </ul>
                </div>
            </div>

            <!-- Crear Atención -->
            <div class="card" id="crear">
                <div class="card-header bg-success">
                    <h3 class="card-title text-white"><i class="fas fa-plus-circle mr-2"></i> 2. Crear una Atención</h3>
                </div>
                <div class="card-body">
                    <h5>Formulario de Nueva Atención:</h5>
                    
                    <table class="table table-bordered">
                        <thead class="bg-light">
                            <tr>
                                <th width="30%">Campo</th>
                                <th>Descripción</th>
                                <th width="20%">Requerido</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>Paciente</strong></td>
                                <td>Selecciona al paciente que será atendido</td>
                                <td><span class="badge badge-danger">Sí</span></td>
                            </tr>
                            <tr>
                                <td><strong>Empresa donde labora</strong></td>
                                <td>Nombre de la empresa del paciente (si aplica)</td>
                                <td><span class="badge badge-secondary">No</span></td>
                            </tr>
                            <tr>
                                <td><strong>Aseguradora</strong></td>
                                <td>Nombre del seguro (ej: Seguros Caracas, Mapfre)</td>
                                <td><span class="badge badge-secondary">No</span></td>
                            </tr>
                            <tr>
                                <td><strong>N° Siniestro</strong></td>
                                <td>Número de caso o siniestro del seguro</td>
                                <td><span class="badge badge-secondary">No</span></td>
                            </tr>
                            <tr>
                                <td><strong>Nombre del operador</strong></td>
                                <td>Persona que atendió la llamada del seguro</td>
                                <td><span class="badge badge-secondary">No</span></td>
                            </tr>
                            <tr>
                                <td><strong>Seguro validado</strong></td>
                                <td>Switch para indicar si el seguro ya fue validado</td>
                                <td><span class="badge badge-info">Por defecto: Sí</span></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="callout callout-success mt-3">
                        <h6><i class="fas fa-check-circle mr-2"></i> Después de Crear</h6>
                        <p class="small mb-0">La atención se creará con estado <span class="badge badge-info">Validada</span> y aparecerá en la lista de atenciones recientes.</p>
                    </div>
                </div>
            </div>

            <!-- Validar Seguro -->
            <div class="card" id="validar">
                <div class="card-header bg-warning">
                    <h3 class="card-title"><i class="fas fa-shield-alt mr-2"></i> 3. Validar Seguro</h3>
                </div>
                <div class="card-body">
                    <h5>¿Qué significa validar un seguro?</h5>
                    <p>Es confirmar que la aseguradora aprobó la cobertura de la atención médica.</p>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="card bg-light">
                                <div class="card-header">
                                    <h6 class="mb-0"><i class="fas fa-check-circle text-success mr-2"></i> Seguro Validado</h6>
                                </div>
                                <div class="card-body">
                                    <p class="small mb-2">Cuando el switch está <strong>activado</strong>:</p>
                                    <ul class="small">
                                        <li>La aseguradora confirmó la cobertura</li>
                                        <li>Se puede proceder con la atención</li>
                                        <li>Aparece ícono <i class="fas fa-check-circle text-success"></i> en la lista</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card bg-light">
                                <div class="card-header">
                                    <h6 class="mb-0"><i class="fas fa-clock text-warning mr-2"></i> Seguro Pendiente</h6>
                                </div>
                                <div class="card-body">
                                    <p class="small mb-2">Cuando el switch está <strong>desactivado</strong>:</p>
                                    <ul class="small">
                                        <li>Esperando confirmación del seguro</li>
                                        <li>La atención puede esperar validación</li>
                                        <li>Aparece ícono <i class="fas fa-clock text-warning"></i> en la lista</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="callout callout-info mt-3">
                        <h6><i class="fas fa-user mr-2"></i> Atenciones Particulares</h6>
                        <p class="small mb-0">Si el paciente no tiene seguro, deja vacío el campo "Aseguradora". Aparecerá como <em>"Particular"</em> en la lista.</p>
                    </div>
                </div>
            </div>

            <!-- Estados -->
            <div class="card" id="estados">
                <div class="card-header bg-info">
                    <h3 class="card-title text-white"><i class="fas fa-tasks mr-2"></i> 4. Estados de la Atención</h3>
                </div>
                <div class="card-body">
                    <h5>Ciclo de Vida de una Atención:</h5>
                    
                    <div class="timeline">
                        <div class="time-label">
                            <span class="bg-info">Estado 1</span>
                        </div>
                        <div>
                            <i class="fas fa-check-circle bg-blue"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header"><span class="badge badge-info">Validada</span></h3>
                                <div class="timeline-body">
                                    <p><strong>Descripción:</strong> La atención fue creada y el seguro está validado (o es particular).</p>
                                    <p class="mb-0"><strong>Siguiente paso:</strong> Espera ser asignada a un especialista o que el especialista la tome.</p>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-warning">Estado 2</span>
                        </div>
                        <div>
                            <i class="fas fa-user-md bg-orange"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header"><span class="badge badge-warning">En proceso</span></h3>
                                <div class="timeline-body">
                                    <p><strong>Descripción:</strong> Un especialista está atendiendo al paciente.</p>
                                    <p class="mb-0"><strong>Siguiente paso:</strong> El especialista completa la consulta y cierra la atención.</p>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-success">Estado 3</span>
                        </div>
                        <div>
                            <i class="fas fa-check-double bg-green"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header"><span class="badge badge-success">Cerrada</span></h3>
                                <div class="timeline-body">
                                    <p><strong>Descripción:</strong> La atención fue completada.</p>
                                    <p class="mb-0"><strong>Estado final:</strong> No se puede modificar ni reabrir.</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <h5 class="mt-4">Filtrar por Estado:</h5>
                    <p>Usa el selector en la parte superior de la lista para filtrar atenciones por estado.</p>
                </div>
            </div>

            <!-- Cerrar Atención -->
            <div class="card" id="cerrar">
                <div class="card-header bg-danger">
                    <h3 class="card-title text-white"><i class="fas fa-times-circle mr-2"></i> 5. Cerrar una Atención</h3>
                </div>
                <div class="card-body">
                    <h5>¿Cuándo cerrar una atención?</h5>
                    <p>Cierra una atención cuando:</p>
                    <ul>
                        <li>El especialista completó la consulta</li>
                        <li>El paciente no se presentó y ya no se atenderá</li>
                        <li>Se canceló por cualquier motivo</li>
                    </ul>

                    <h5 class="mt-4">Cómo Cerrar:</h5>
                    <ol>
                        <li>Busca la atención en la lista</li>
                        <li>Haz clic en el botón rojo <button class="btn btn-light btn-sm rounded-circle"><i class="fas fa-times text-danger"></i></button></li>
                        <li>Confirma la acción en el mensaje de SweetAlert</li>
                    </ol>

                    <div class="callout callout-warning mt-3">
                        <h6><i class="fas fa-exclamation-triangle mr-2"></i> Importante</h6>
                        <p class="small mb-0">Una vez cerrada, la atención <strong>no se puede reabrir</strong>. Asegúrate de que realmente deseas cerrarla antes de confirmar.</p>
                    </div>

                    <div class="alert alert-info mt-3">
                        <h6><i class="fas fa-info-circle mr-2"></i> Nota</h6>
                        <p class="small mb-0">Las atenciones cerradas no se pueden eliminar, solo quedan archivadas con estado <span class="badge badge-success">Cerrada</span>.</p>
                    </div>
                </div>
            </div>

            <!-- Botón Volver -->
            <div class="text-center mb-4">
                <a href="{{ route('help.index') }}" class="btn btn-secondary btn-lg">
                    <i class="fas fa-arrow-left mr-2"></i> Volver al Centro de Ayuda
                </a>
            </div>
        </div>
    </div>
</div>
@stop

@push('styles')
<style>
    .sticky-top {
        position: sticky;
        z-index: 1020;
    }
    
    .timeline {
        position: relative;
        margin: 0 0 30px 0;
        padding: 0;
        list-style: none;
    }
    
    .timeline:before {
        content: '';
        position: absolute;
        top: 0;
        bottom: 0;
        width: 4px;
        background: #ddd;
        left: 31px;
        margin: 0;
        border-radius: 2px;
    }
    
    .timeline > div {
        margin-bottom: 15px;
        position: relative;
    }
    
    .timeline > div > .timeline-item {
        margin-top: 0;
        background: #fff;
        color: #444;
        margin-left: 60px;
        margin-right: 15px;
        padding: 0;
        position: relative;
        box-shadow: 0 1px 3px rgba(0,0,0,0.12);
        border-radius: 3px;
    }
    
    .timeline > div > .fas {
        width: 30px;
        height: 30px;
        font-size: 15px;
        line-height: 30px;
        position: absolute;
        color: #fff;
        background: #999;
        border-radius: 50%;
        text-align: center;
        left: 18px;
        top: 0;
    }
    
    .timeline > div > .timeline-item > .timeline-header {
        margin: 0;
        color: #555;
        border-bottom: 1px solid #f4f4f4;
        padding: 10px;
        font-size: 16px;
        font-weight: 600;
    }
    
    .timeline > div > .timeline-item > .timeline-body {
        padding: 10px;
    }
    
    .timeline > .time-label > span {
        font-weight: 600;
        padding: 5px;
        display: inline-block;
        background-color: #fff;
        border-radius: 4px;
    }
    
    .callout {
        border-radius: 3px;
        margin: 20px 0;
        padding: 15px 30px 15px 15px;
        border-left: 5px solid #eee;
    }
    
    .callout-warning {
        border-left-color: #f39c12;
        background-color: #fcf8e3;
    }
    
    .callout-info {
        border-left-color: #17a2b8;
        background-color: #f0f9ff;
    }
    
    .callout-success {
        border-left-color: #28a745;
        background-color: #d4edda;
    }
    
    html {
        scroll-behavior: smooth;
    }
</style>
@endpush
