@extends('layouts.adminlte')

@section('title', 'Cargar Resultados - Ayuda')

@section('content_header')
    <h1><i class="fas fa-edit mr-2"></i> Cargar Resultados de Laboratorio</h1>
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
                        <a href="#acceder" class="list-group-item list-group-item-action">2. Acceder a la Orden</a>
                        <a href="#ingresar-valores" class="list-group-item list-group-item-action">3. Ingresar Valores</a>
                        <a href="#observaciones" class="list-group-item list-group-item-action">4. Observaciones</a>
                        <a href="#guardar" class="list-group-item list-group-item-action">5. Guardar y Generar PDF</a>
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
                    <p class="lead">La función de <strong>Cargar Resultados</strong> permite ingresar los valores obtenidos de los exámenes de laboratorio.</p>
                    
                    <div class="alert alert-info">
                        <i class="fas fa-lightbulb mr-2"></i>
                        <strong>¿Quién puede cargar resultados?</strong><br>
                        Solo usuarios con rol <strong>Laboratorio-Resul</strong>, <strong>Laboratorio</strong>, <strong>Admin Clínica</strong> o <strong>Super Admin</strong>.
                    </div>

                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle mr-2"></i>
                        <strong>Importante:</strong> Los rangos de referencia se muestran automáticamente según la edad y sexo del paciente.
                    </div>
                </div>
            </div>

            <!-- Acceder -->
            <div class="card" id="acceder">
                <div class="card-header bg-success">
                    <h3 class="card-title text-white"><i class="fas fa-search mr-2"></i> 2. Acceder a la Orden</h3>
                </div>
                <div class="card-body">
                    <h5>Dos formas de acceder:</h5>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card border-primary">
                                <div class="card-header bg-primary text-white">
                                    <h6 class="mb-0"><i class="fas fa-list mr-2"></i> Desde el Listado</h6>
                                </div>
                                <div class="card-body">
                                    <ol class="small">
                                        <li>Ve a <strong>Laboratorio → Exámenes</strong></li>
                                        <li>Busca la orden pendiente</li>
                                        <li>Haz clic en el botón <span class="badge badge-warning">Cargar Resultados</span></li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card border-info">
                                <div class="card-header bg-info text-white">
                                    <h6 class="mb-0"><i class="fas fa-eye mr-2"></i> Desde los Detalles</h6>
                                </div>
                                <div class="card-body">
                                    <ol class="small">
                                        <li>Abre los detalles de la orden</li>
                                        <li>Haz clic en <strong>"Cargar Resultados"</strong></li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Ingresar Valores -->
            <div class="card" id="ingresar-valores">
                <div class="card-header bg-warning">
                    <h3 class="card-title"><i class="fas fa-keyboard mr-2"></i> 3. Ingresar Valores</h3>
                </div>
                <div class="card-body">
                    <h5>Estructura de la Tabla:</h5>
                    
                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <thead class="bg-light">
                                <tr>
                                    <th>Columna</th>
                                    <th>Descripción</th>
                                    <th>Ejemplo</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><strong>Parámetro</strong></td>
                                    <td>Nombre del valor a medir</td>
                                    <td>Hemoglobina, Glucosa, Colesterol</td>
                                </tr>
                                <tr>
                                    <td><strong>Valor</strong></td>
                                    <td>Campo donde ingresas el resultado</td>
                                    <td>15.2, 95, Negativo</td>
                                </tr>
                                <tr>
                                    <td><strong>Unidad</strong> <span class="badge badge-secondary">Solo desktop</span></td>
                                    <td>Unidad de medida (solo informativo)</td>
                                    <td>g/dL, mg/dL, mmol/L</td>
                                </tr>
                                <tr>
                                    <td><strong>Rango de Referencia</strong> <span class="badge badge-secondary">Solo desktop</span></td>
                                    <td>Valores normales para este paciente</td>
                                    <td>13.5 - 17.5</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="callout callout-info">
                        <h6><i class="fas fa-mobile-alt mr-2"></i> Versión Móvil</h6>
                        <p class="small mb-0">En móviles y tablets, las columnas "Unidad" y "Rango de Referencia" están ocultas para facilitar la carga de datos. Puedes consultar estos valores en el manual completo o en la versión desktop.</p>
                    </div>

                    <h5 class="mt-4">Tipos de Valores:</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card bg-light">
                                <div class="card-body">
                                    <h6 class="font-weight-bold"><i class="fas fa-hashtag text-primary mr-2"></i> Valores Numéricos</h6>
                                    <p class="small">Ingresa solo el número (ej: <code>15.2</code>, <code>95</code>)</p>
                                    <p class="small mb-0 text-muted">El sistema mostrará la unidad automáticamente.</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card bg-light">
                                <div class="card-body">
                                    <h6 class="font-weight-bold"><i class="fas fa-font text-success mr-2"></i> Valores de Texto</h6>
                                    <p class="small">Ingresa el resultado descriptivo (ej: <code>Negativo</code>, <code>Positivo</code>, <code>Normal</code>)</p>
                                    <p class="small mb-0 text-muted">Para resultados cualitativos.</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-success mt-3">
                        <h6><i class="fas fa-magic mr-2"></i> Rangos Automáticos</h6>
                        <p class="small mb-0">El sistema muestra automáticamente el rango de referencia correcto según la <strong>edad</strong> y <strong>sexo</strong> del paciente. No necesitas buscarlo manualmente.</p>
                    </div>
                </div>
            </div>

            <!-- Observaciones -->
            <div class="card" id="observaciones">
                <div class="card-header bg-info">
                    <h3 class="card-title text-white"><i class="fas fa-comment mr-2"></i> 4. Observaciones Generales</h3>
                </div>
                <div class="card-body">
                    <p>Al final del formulario encontrarás un campo de <strong>"Observaciones Generales"</strong>.</p>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <h6 class="font-weight-bold text-success"><i class="fas fa-check mr-2"></i> Usa observaciones para:</h6>
                            <ul class="small">
                                <li>Notas importantes sobre la muestra</li>
                                <li>Condiciones especiales del paciente</li>
                                <li>Aclaraciones sobre algún resultado</li>
                                <li>Recomendaciones generales</li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <h6 class="font-weight-bold text-info"><i class="fas fa-lightbulb mr-2"></i> Ejemplos:</h6>
                            <div class="alert alert-light small">
                                <p class="mb-1">• "Muestra tomada en ayunas"</p>
                                <p class="mb-1">• "Paciente bajo tratamiento con..."</p>
                                <p class="mb-0">• "Se recomienda repetir en 15 días"</p>
                            </div>
                        </div>
                    </div>

                    <div class="callout callout-warning">
                        <h6><i class="fas fa-info-circle mr-2"></i> Nota</h6>
                        <p class="small mb-0">Las observaciones aparecerán en el PDF de resultados que se entrega al paciente.</p>
                    </div>
                </div>
            </div>

            <!-- Guardar -->
            <div class="card" id="guardar">
                <div class="card-header bg-secondary">
                    <h3 class="card-title text-white"><i class="fas fa-save mr-2"></i> 5. Guardar y Generar PDF</h3>
                </div>
                <div class="card-body">
                    <h5>Proceso Final:</h5>
                    
                    <div class="timeline">
                        <div class="time-label">
                            <span class="bg-primary">Paso 1</span>
                        </div>
                        <div>
                            <i class="fas fa-check-double bg-blue"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Revisa los Datos</h3>
                                <div class="timeline-body">
                                    <p>Verifica que todos los valores estén correctos antes de guardar.</p>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-primary">Paso 2</span>
                        </div>
                        <div>
                            <i class="fas fa-save bg-green"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Guarda los Resultados</h3>
                                <div class="timeline-body">
                                    <p>Haz clic en el botón <strong>"Guardar Resultados"</strong>.</p>
                                    <div class="alert alert-success small">
                                        <i class="fas fa-check-circle mr-1"></i> La orden cambiará automáticamente a estado "Completada".
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-primary">Paso 3</span>
                        </div>
                        <div>
                            <i class="fas fa-file-pdf bg-red"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Genera el PDF</h3>
                                <div class="timeline-body">
                                    <p>Una vez guardados los resultados, puedes:</p>
                                    <ul class="small">
                                        <li>Descargar el PDF desde el listado de órdenes</li>
                                        <li>El paciente puede descargarlo desde su panel</li>
                                        <li>Compartir el código de verificación para consulta pública</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>

                    <h5 class="mt-4">Contenido del PDF:</h5>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="small-box bg-info">
                                <div class="inner">
                                    <h4><i class="fas fa-user"></i></h4>
                                    <p>Datos del paciente (nombre, edad, sexo)</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="small-box bg-success">
                                <div class="inner">
                                    <h4><i class="fas fa-vial"></i></h4>
                                    <p>Resultados con rangos de referencia</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="small-box bg-warning">
                                <div class="inner">
                                    <h4><i class="fas fa-qrcode"></i></h4>
                                    <p>Código QR para verificación</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-success mt-3">
                        <h5><i class="fas fa-trophy mr-2"></i> ¡Excelente Trabajo!</h5>
                        <p class="mb-0">Los resultados están listos. El paciente recibirá un documento profesional con toda la información necesaria.</p>
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
