@extends('layouts.adminlte')

@section('title', 'Gestión de Solicitudes - Ayuda')

@section('content_header')
    <h1><i class="fas fa-clipboard-list mr-2"></i> Gestión de Solicitudes de Inventario</h1>
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
                        <a href="#crear" class="list-group-item list-group-item-action">2. Crear Solicitud</a>
                        <a href="#aprobar" class="list-group-item list-group-item-action">3. Aprobar/Rechazar</a>
                        <a href="#despachar" class="list-group-item list-group-item-action">4. Despachar</a>
                        <a href="#estados" class="list-group-item list-group-item-action">5. Estados</a>
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
                    <p class="lead">El módulo de <strong>Gestión de Solicitudes</strong> permite gestionar las peticiones de materiales clínicos de forma organizada y eficiente.</p>
                    
                    <div class="alert alert-info">
                        <i class="fas fa-lightbulb mr-2"></i>
                        <strong>¿Qué es una solicitud de inventario?</strong><br>
                        Es una petición formal de materiales clínicos que pasa por un proceso de aprobación antes de ser despachada.
                    </div>

                    <h5 class="mt-4"><i class="fas fa-user-tag mr-2"></i> Roles y Permisos</h5>
                    <table class="table table-bordered">
                        <thead class="bg-light">
                            <tr>
                                <th>Rol</th>
                                <th>Permisos</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>Médico/Enfermera</strong></td>
                                <td>Crear solicitudes y ver sus propias solicitudes</td>
                            </tr>
                            <tr>
                                <td><strong>Jefe de Almacén</strong></td>
                                <td>Aprobar/rechazar solicitudes y despachar materiales</td>
                            </tr>
                            <tr>
                                <td><strong>Admin Clínica</strong></td>
                                <td>Acceso completo al módulo</td>
                            </tr>
                        </tbody>
                    </table>

                    <h5 class="mt-4"><i class="fas fa-chart-line mr-2"></i> Estadísticas Disponibles</h5>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="card bg-warning text-white">
                                <div class="card-body text-center">
                                    <h4><i class="fas fa-clock"></i></h4>
                                    <h6>Pendientes</h6>
                                    <p class="small mb-0">Solicitudes esperando aprobación</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card bg-info text-white">
                                <div class="card-body text-center">
                                    <h4><i class="fas fa-check-circle"></i></h4>
                                    <h6>Aprobadas</h6>
                                    <p class="small mb-0">Listas para despachar</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card bg-success text-white">
                                <div class="card-body text-center">
                                    <h4><i class="fas fa-truck-loading"></i></h4>
                                    <h6>Despachadas</h6>
                                    <p class="small mb-0">Del mes actual</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Crear Solicitud -->
            <div class="card" id="crear">
                <div class="card-header bg-success">
                    <h3 class="card-title text-white"><i class="fas fa-plus-circle mr-2"></i> 2. Crear una Solicitud</h3>
                </div>
                <div class="card-body">
                    <h5>Proceso de Creación:</h5>
                    
                    <div class="timeline">
                        <div class="time-label">
                            <span class="bg-primary">Paso 1</span>
                        </div>
                        <div>
                            <i class="fas fa-plus-circle bg-blue"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Acceder al Formulario</h3>
                                <div class="timeline-body">
                                    <p>Haz clic en el botón <button class="btn btn-primary btn-sm"><i class="fas fa-plus-circle mr-1"></i> Nueva Solicitud</button> en la página principal de solicitudes.</p>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-success">Paso 2</span>
                        </div>
                        <div>
                            <i class="fas fa-folder bg-green"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Seleccionar Categoría</h3>
                                <div class="timeline-body">
                                    <p><strong>Categorías disponibles:</strong></p>
                                    <ul class="small">
                                        <li><strong>ENFERMERIA:</strong> Gasas, jeringas, vendas, etc.</li>
                                        <li><strong>QUIROFANO:</strong> Material quirúrgico especializado</li>
                                        <li><strong>UCI:</strong> Equipos de cuidados intensivos</li>
                                        <li><strong>OFICINA:</strong> Papelería y suministros administrativos</li>
                                        <li><strong>LABORATORIO:</strong> Material de laboratorio clínico</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-info">Paso 3</span>
                        </div>
                        <div>
                            <i class="fas fa-box bg-cyan"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Agregar Materiales</h3>
                                <div class="timeline-body">
                                    <ol class="small">
                                        <li>Busca el material en el campo de búsqueda</li>
                                        <li>Selecciona el material de la lista</li>
                                        <li>Ingresa la cantidad solicitada</li>
                                        <li>Haz clic en <button class="btn btn-success btn-sm"><i class="fas fa-plus"></i></button> para agregarlo</li>
                                        <li>Repite para agregar más materiales</li>
                                    </ol>
                                    <div class="alert alert-warning mt-2">
                                        <i class="fas fa-exclamation-triangle mr-2"></i>
                                        <strong>Importante:</strong> Si el material no existe, puedes crearlo escribiendo el nombre y seleccionando "(Nuevo)".
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-warning">Paso 4</span>
                        </div>
                        <div>
                            <i class="fas fa-save bg-orange"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Guardar Solicitud</h3>
                                <div class="timeline-body">
                                    <p>Revisa los materiales agregados y haz clic en <button class="btn btn-primary btn-sm"><i class="fas fa-save mr-1"></i> Guardar Solicitud</button></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-success mt-3">
                        <h6><i class="fas fa-check-circle mr-2"></i> Después de Crear</h6>
                        <p class="small mb-0">La solicitud quedará en estado <span class="badge badge-warning">Pendiente</span> y será enviada al Jefe de Almacén para su aprobación.</p>
                    </div>
                </div>
            </div>

            <!-- Aprobar/Rechazar -->
            <div class="card" id="aprobar">
                <div class="card-header bg-warning">
                    <h3 class="card-title text-white"><i class="fas fa-tasks mr-2"></i> 3. Aprobar o Rechazar Solicitudes</h3>
                </div>
                <div class="card-body">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle mr-2"></i>
                        <strong>Nota:</strong> Solo el Jefe de Almacén y Admin Clínica pueden aprobar o rechazar solicitudes.
                    </div>

                    <h5>Proceso de Aprobación:</h5>
                    <ol>
                        <li class="mb-2">Haz clic en el botón <button class="btn btn-outline-warning btn-sm"><i class="fas fa-tasks"></i></button> en la solicitud pendiente</li>
                        <li class="mb-2">Revisa los materiales solicitados y las cantidades</li>
                        <li class="mb-2">Para cada material, puedes:
                            <ul>
                                <li><strong>Aprobar:</strong> Confirma la cantidad solicitada</li>
                                <li><strong>Modificar:</strong> Cambia la cantidad aprobada</li>
                                <li><strong>Rechazar:</strong> Marca cantidad aprobada como 0</li>
                            </ul>
                        </li>
                        <li class="mb-2">Haz clic en <button class="btn btn-success btn-sm"><i class="fas fa-check mr-1"></i> Aprobar Solicitud</button></li>
                    </ol>

                    <h5 class="mt-4">Rechazar una Solicitud:</h5>
                    <ol>
                        <li class="mb-2">Haz clic en <button class="btn btn-danger btn-sm"><i class="fas fa-times mr-1"></i> Rechazar Solicitud</button></li>
                        <li class="mb-2">Ingresa el <strong>motivo del rechazo</strong> (obligatorio)</li>
                        <li class="mb-2">Confirma la acción</li>
                    </ol>

                    <div class="callout callout-warning mt-3">
                        <h6><i class="fas fa-exclamation-triangle mr-2"></i> Motivo Obligatorio</h6>
                        <p class="small mb-0">Al rechazar una solicitud, debes indicar el motivo para que el solicitante pueda corregir o entender la decisión.</p>
                    </div>

                    <h5 class="mt-4">Ejemplos de Motivos de Rechazo:</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="alert alert-light border">
                                <p class="small mb-1"><strong>✓ Bueno:</strong></p>
                                <p class="small text-muted mb-0">"No hay stock suficiente del material solicitado"</p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="alert alert-light border">
                                <p class="small mb-1"><strong>✓ Bueno:</strong></p>
                                <p class="small text-muted mb-0">"La categoría seleccionada no corresponde a los materiales solicitados"</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Despachar -->
            <div class="card" id="despachar">
                <div class="card-header bg-info">
                    <h3 class="card-title text-white"><i class="fas fa-truck-loading mr-2"></i> 4. Despachar Materiales</h3>
                </div>
                <div class="card-body">
                    <p class="lead">Una vez aprobada la solicitud, el Jefe de Almacén puede proceder con el despacho de los materiales.</p>

                    <h5>Proceso de Despacho:</h5>
                    <ol>
                        <li class="mb-2">Filtra las solicitudes por estado <span class="badge badge-info">Aprobada</span></li>
                        <li class="mb-2">Haz clic en el botón <button class="btn btn-outline-primary btn-sm"><i class="fas fa-eye"></i></button> para ver el detalle</li>
                        <li class="mb-2">Verifica los materiales y cantidades aprobadas</li>
                        <li class="mb-2">Prepara físicamente los materiales</li>
                        <li class="mb-2">Haz clic en <button class="btn btn-success btn-sm"><i class="fas fa-truck-loading mr-1"></i> Marcar como Despachada</button></li>
                        <li class="mb-2">Confirma la acción</li>
                    </ol>

                    <div class="alert alert-success mt-3">
                        <h6><i class="fas fa-check-circle mr-2"></i> Después del Despacho</h6>
                        <p class="small mb-0">La solicitud cambiará a estado <span class="badge badge-success">Despachada</span> y se registrará la fecha y hora del despacho. El inventario se actualizará automáticamente.</p>
                    </div>

                    <div class="callout callout-info mt-3">
                        <h6><i class="fas fa-info-circle mr-2"></i> Importante</h6>
                        <p class="small mb-0">Asegúrate de que los materiales estén físicamente preparados antes de marcar la solicitud como despachada, ya que esta acción es irreversible.</p>
                    </div>
                </div>
            </div>

            <!-- Estados -->
            <div class="card" id="estados">
                <div class="card-header bg-secondary">
                    <h3 class="card-title text-white"><i class="fas fa-list-alt mr-2"></i> 5. Estados de las Solicitudes</h3>
                </div>
                <div class="card-body">
                    <h5>Ciclo de Vida de una Solicitud:</h5>
                    
                    <table class="table table-bordered">
                        <thead class="bg-light">
                            <tr>
                                <th width="20%">Estado</th>
                                <th>Descripción</th>
                                <th width="30%">Acciones Disponibles</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><span class="badge badge-warning px-3 py-2"><i class="fas fa-clock mr-1"></i> Pendiente</span></td>
                                <td>La solicitud fue creada y está esperando aprobación del Jefe de Almacén</td>
                                <td>
                                    <button class="btn btn-outline-warning btn-sm"><i class="fas fa-tasks"></i> Gestionar</button>
                                    <button class="btn btn-outline-danger btn-sm"><i class="fas fa-trash"></i> Eliminar</button>
                                </td>
                            </tr>
                            <tr>
                                <td><span class="badge badge-info px-3 py-2"><i class="fas fa-check-circle mr-1"></i> Aprobada</span></td>
                                <td>La solicitud fue aprobada y está lista para ser despachada</td>
                                <td>
                                    <button class="btn btn-success btn-sm"><i class="fas fa-truck-loading"></i> Despachar</button>
                                </td>
                            </tr>
                            <tr>
                                <td><span class="badge badge-success px-3 py-2"><i class="fas fa-truck-loading mr-1"></i> Despachada</span></td>
                                <td>Los materiales fueron entregados. Se registra fecha y hora del despacho</td>
                                <td><span class="text-muted"><i class="fas fa-lock"></i> Sin acciones</span></td>
                            </tr>
                            <tr>
                                <td><span class="badge badge-danger px-3 py-2"><i class="fas fa-times-circle mr-1"></i> Rechazada</span></td>
                                <td>La solicitud fue rechazada. Se muestra el motivo del rechazo</td>
                                <td><span class="text-muted"><i class="fas fa-lock"></i> Sin acciones</span></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="alert alert-info mt-3">
                        <h6><i class="fas fa-info-circle mr-2"></i> Filtros Disponibles</h6>
                        <p class="small mb-0">Puedes filtrar las solicitudes por estado, categoría y rango de fechas para encontrar rápidamente lo que necesitas.</p>
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
    
    html {
        scroll-behavior: smooth;
    }
</style>
@endpush
