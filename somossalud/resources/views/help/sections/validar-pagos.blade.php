@extends('layouts.adminlte')

@section('title', 'Validación de Pagos - Ayuda')

@section('content_header')
    <h1><i class="fas fa-file-invoice-dollar mr-2"></i> Validación de Pagos</h1>
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
                        <a href="#filtrar" class="list-group-item list-group-item-action">2. Filtrar Pagos</a>
                        <a href="#aprobar" class="list-group-item list-group-item-action">3. Aprobar Pago</a>
                        <a href="#rechazar" class="list-group-item list-group-item-action">4. Rechazar Pago</a>
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
                    <p class="lead">El módulo de <strong>Validación de Pagos</strong> permite revisar y aprobar/rechazar los reportes de pago enviados por los pacientes.</p>
                    
                    <div class="alert alert-info">
                        <i class="fas fa-lightbulb mr-2"></i>
                        <strong>¿Qué es un reporte de pago?</strong><br>
                        Es la información que el paciente envía cuando realiza un pago móvil o transferencia bancaria. Incluye referencia, monto, cédula del pagador y teléfono.
                    </div>

                    <h5 class="mt-4"><i class="fas fa-user-tag mr-2"></i> ¿Quién puede validar pagos?</h5>
                    <ul>
                        <li><strong>Recepción/Admin:</strong> Aprobar o rechazar reportes de pago</li>
                        <li><strong>Super Admin:</strong> Acceso completo al módulo</li>
                    </ul>

                    <h5 class="mt-4"><i class="fas fa-clipboard-list mr-2"></i> Información Visible</h5>
                    <table class="table table-bordered">
                        <thead class="bg-light">
                            <tr>
                                <th>Columna</th>
                                <th>Descripción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>Paciente</strong></td>
                                <td>Nombre del usuario y cédula del pagador</td>
                            </tr>
                            <tr>
                                <td><strong>Detalles Pago</strong></td>
                                <td>Referencia, fecha y teléfono del pagador</td>
                            </tr>
                            <tr>
                                <td><strong>Monto</strong></td>
                                <td>Cantidad en bolívares reportada</td>
                            </tr>
                            <tr>
                                <td><strong>Estado</strong></td>
                                <td>Pendiente, Aprobado o Rechazado</td>
                            </tr>
                            <tr>
                                <td><strong>Revisión</strong></td>
                                <td>Quién revisó, cuándo y motivo (si fue rechazado)</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Filtrar -->
            <div class="card" id="filtrar">
                <div class="card-header bg-success">
                    <h3 class="card-title text-white"><i class="fas fa-filter mr-2"></i> 2. Filtrar Pagos</h3>
                </div>
                <div class="card-body">
                    <h5>Selector de Estado:</h5>
                    <p>En la parte superior derecha encontrarás un selector para filtrar los reportes por estado.</p>

                    <div class="row">
                        <div class="col-md-4">
                            <div class="card bg-warning text-white">
                                <div class="card-body text-center">
                                    <h4><i class="fas fa-clock"></i></h4>
                                    <h6>Pendientes</h6>
                                    <p class="small mb-0">Reportes que esperan tu revisión</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card bg-success text-white">
                                <div class="card-body text-center">
                                    <h4><i class="fas fa-check-circle"></i></h4>
                                    <h6>Aprobados</h6>
                                    <p class="small mb-0">Pagos validados correctamente</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card bg-danger text-white">
                                <div class="card-body text-center">
                                    <h4><i class="fas fa-times-circle"></i></h4>
                                    <h6>Rechazados</h6>
                                    <p class="small mb-0">Reportes con datos incorrectos</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="callout callout-info mt-3">
                        <h6><i class="fas fa-info-circle mr-2"></i> Filtro Automático</h6>
                        <p class="small mb-0">Al seleccionar un estado, la página se actualiza automáticamente mostrando solo los reportes de ese estado.</p>
                    </div>
                </div>
            </div>

            <!-- Aprobar -->
            <div class="card" id="aprobar">
                <div class="card-header bg-success">
                    <h3 class="card-title text-white"><i class="fas fa-check mr-2"></i> 3. Aprobar un Pago</h3>
                </div>
                <div class="card-body">
                    <h5>Proceso de Aprobación:</h5>
                    
                    <div class="timeline">
                        <div class="time-label">
                            <span class="bg-primary">Paso 1</span>
                        </div>
                        <div>
                            <i class="fas fa-search bg-blue"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Verifica los Datos</h3>
                                <div class="timeline-body">
                                    <p><strong>Revisa:</strong></p>
                                    <ul class="small">
                                        <li>Referencia del pago</li>
                                        <li>Monto reportado</li>
                                        <li>Cédula del pagador</li>
                                        <li>Fecha del pago</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-success">Paso 2</span>
                        </div>
                        <div>
                            <i class="fas fa-check-circle bg-green"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Haz Clic en Aprobar</h3>
                                <div class="timeline-body">
                                    <p>Haz clic en el botón verde <button class="btn btn-success btn-sm"><i class="fas fa-check"></i></button> en la columna "Acciones".</p>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-info">Paso 3</span>
                        </div>
                        <div>
                            <i class="fas fa-exclamation-circle bg-cyan"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Confirma la Acción</h3>
                                <div class="timeline-body">
                                    <p>Aparecerá un mensaje de confirmación con los datos del pago. Haz clic en <strong>"Sí, aprobar"</strong>.</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-success mt-3">
                        <h6><i class="fas fa-check-circle mr-2"></i> Después de Aprobar</h6>
                        <p class="small mb-0">El pago cambiará a estado <span class="badge badge-success">Aprobado</span> y se registrará tu nombre y la fecha/hora de aprobación.</p>
                    </div>
                </div>
            </div>

            <!-- Rechazar -->
            <div class="card" id="rechazar">
                <div class="card-header bg-danger">
                    <h3 class="card-title text-white"><i class="fas fa-times mr-2"></i> 4. Rechazar un Pago</h3>
                </div>
                <div class="card-body">
                    <h5>¿Cuándo rechazar un pago?</h5>
                    <p>Rechaza un reporte cuando:</p>
                    <ul>
                        <li>La referencia no coincide con los registros bancarios</li>
                        <li>El monto es incorrecto</li>
                        <li>Los datos del pagador no coinciden</li>
                        <li>La fecha del pago es inconsistente</li>
                    </ul>

                    <h5 class="mt-4">Proceso de Rechazo:</h5>
                    <ol>
                        <li class="mb-2">Haz clic en el botón rojo <button class="btn btn-danger btn-sm"><i class="fas fa-times"></i></button></li>
                        <li class="mb-2">Aparecerá un cuadro de diálogo solicitando el <strong>motivo del rechazo</strong></li>
                        <li class="mb-2">Escribe una explicación clara del problema (obligatorio)</li>
                        <li class="mb-2">Haz clic en <strong>"Rechazar"</strong></li>
                    </ol>

                    <div class="callout callout-warning mt-3">
                        <h6><i class="fas fa-exclamation-triangle mr-2"></i> Motivo Obligatorio</h6>
                        <p class="small mb-0">Debes indicar un motivo para rechazar el pago. El paciente podrá ver este motivo para corregir su reporte.</p>
                    </div>

                    <h5 class="mt-4">Ejemplos de Motivos:</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="alert alert-light border">
                                <p class="small mb-1"><strong>✓ Bueno:</strong></p>
                                <p class="small text-muted mb-0">"La referencia no aparece en nuestro sistema bancario"</p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="alert alert-light border">
                                <p class="small mb-1"><strong>✓ Bueno:</strong></p>
                                <p class="small text-muted mb-0">"El monto reportado no coincide con el monto recibido"</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Estados -->
            <div class="card" id="estados">
                <div class="card-header bg-info">
                    <h3 class="card-title text-white"><i class="fas fa-tasks mr-2"></i> 5. Estados del Reporte</h3>
                </div>
                <div class="card-body">
                    <h5>Ciclo de Vida de un Reporte:</h5>
                    
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
                                <td>El paciente envió el reporte y está esperando validación</td>
                                <td>
                                    <button class="btn btn-success btn-sm"><i class="fas fa-check"></i> Aprobar</button>
                                    <button class="btn btn-danger btn-sm"><i class="fas fa-times"></i> Rechazar</button>
                                </td>
                            </tr>
                            <tr>
                                <td><span class="badge badge-success px-3 py-2"><i class="fas fa-check-circle mr-1"></i> Aprobado</span></td>
                                <td>El pago fue validado correctamente. Se registra quién aprobó y cuándo</td>
                                <td><span class="text-muted"><i class="fas fa-lock"></i> Sin acciones</span></td>
                            </tr>
                            <tr>
                                <td><span class="badge badge-danger px-3 py-2"><i class="fas fa-times-circle mr-1"></i> Rechazado</span></td>
                                <td>El reporte fue rechazado. Se muestra el motivo del rechazo</td>
                                <td><span class="text-muted"><i class="fas fa-lock"></i> Sin acciones</span></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="alert alert-info mt-3">
                        <h6><i class="fas fa-info-circle mr-2"></i> Nota Importante</h6>
                        <p class="small mb-0">Una vez aprobado o rechazado, el estado del reporte <strong>no se puede cambiar</strong>. Asegúrate de revisar bien antes de confirmar.</p>
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
