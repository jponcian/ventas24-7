@extends('layouts.adminlte')

@section('title', 'Órdenes de Laboratorio - Ayuda')

@section('content_header')
    <h1><i class="fas fa-file-medical mr-2"></i> Órdenes de Laboratorio</h1>
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
                        <a href="#crear-orden" class="list-group-item list-group-item-action">2. Crear una Orden</a>
                        <a href="#seleccionar-examenes" class="list-group-item list-group-item-action">3. Seleccionar Exámenes</a>
                        <a href="#registrar-paciente" class="list-group-item list-group-item-action">4. Registrar Paciente</a>
                        <a href="#ver-orden" class="list-group-item list-group-item-action">5. Ver y Descargar</a>
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
                    <p class="lead">Las <strong>Órdenes de Laboratorio</strong> permiten registrar los exámenes solicitados a un paciente.</p>
                    
                    <div class="alert alert-info">
                        <i class="fas fa-lightbulb mr-2"></i>
                        <strong>Flujo del proceso:</strong>
                        <ol class="mb-0 mt-2">
                            <li>Crear orden y seleccionar paciente</li>
                            <li>Elegir exámenes necesarios</li>
                            <li>Confirmar y generar orden</li>
                            <li>Cargar resultados (cuando estén listos)</li>
                            <li>Generar PDF para el paciente</li>
                        </ol>
                    </div>
                </div>
            </div>

            <!-- Crear Orden -->
            <div class="card" id="crear-orden">
                <div class="card-header bg-success">
                    <h3 class="card-title text-white"><i class="fas fa-plus-circle mr-2"></i> 2. Crear una Orden</h3>
                </div>
                <div class="card-body">
                    <h5>Paso a Paso:</h5>
                    
                    <div class="timeline">
                        <div class="time-label">
                            <span class="bg-primary">Paso 1</span>
                        </div>
                        <div>
                            <i class="fas fa-user bg-blue"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Selecciona el Paciente</h3>
                                <div class="timeline-body">
                                    <p>Busca al paciente por nombre o cédula en el campo "Paciente".</p>
                                    <div class="alert alert-light border">
                                        <p class="mb-0"><i class="fas fa-search mr-2"></i> El buscador es inteligente: puedes escribir nombre completo, apellido o número de cédula.</p>
                                    </div>
                                    <p class="text-muted small">Si el paciente no existe, puedes registrarlo haciendo clic en <strong>"Registrar Nuevo Paciente"</strong>.</p>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-primary">Paso 2</span>
                        </div>
                        <div>
                            <i class="fas fa-hospital bg-green"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Selecciona la Clínica</h3>
                                <div class="timeline-body">
                                    <p>Elige la clínica donde se realizará el examen.</p>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-primary">Paso 3</span>
                        </div>
                        <div>
                            <i class="fas fa-calendar bg-orange"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Fecha de la Orden</h3>
                                <div class="timeline-body">
                                    <p>Por defecto se usa la fecha actual, pero puedes cambiarla si es necesario.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Seleccionar Exámenes -->
            <div class="card" id="seleccionar-examenes">
                <div class="card-header bg-warning">
                    <h3 class="card-title"><i class="fas fa-vials mr-2"></i> 3. Seleccionar Exámenes</h3>
                </div>
                <div class="card-body">
                    <h5>Cómo Seleccionar:</h5>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card bg-light">
                                <div class="card-body">
                                    <h6 class="font-weight-bold"><i class="fas fa-search mr-2"></i> Buscar Exámenes</h6>
                                    <p class="small">Usa el campo de búsqueda para filtrar exámenes por nombre o categoría.</p>
                                    <div class="alert alert-info small mb-0">
                                        <i class="fas fa-lightbulb mr-1"></i> La búsqueda es en tiempo real y no distingue mayúsculas/minúsculas.
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card bg-light">
                                <div class="card-body">
                                    <h6 class="font-weight-bold"><i class="fas fa-check-square mr-2"></i> Marcar Exámenes</h6>
                                    <p class="small">Haz clic en el checkbox de cada examen que desees incluir en la orden.</p>
                                    <div class="alert alert-success small mb-0">
                                        <i class="fas fa-dollar-sign mr-1"></i> El total se actualiza automáticamente.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <h5 class="mt-4">Organización por Categorías:</h5>
                    <p>Los exámenes están agrupados por categorías (Hematología, Química, etc.) para facilitar la búsqueda.</p>

                    <div class="callout callout-info">
                        <h6><i class="fas fa-mobile-alt mr-2"></i> Versión Móvil/Tablet</h6>
                        <p class="small mb-0">En dispositivos móviles, la lista de exámenes se expande completamente para facilitar la selección táctil. El total y botones están siempre visibles en una barra inferior fija.</p>
                    </div>
                </div>
            </div>

            <!-- Registrar Paciente -->
            <div class="card" id="registrar-paciente">
                <div class="card-header bg-info">
                    <h3 class="card-title text-white"><i class="fas fa-user-plus mr-2"></i> 4. Registrar Nuevo Paciente</h3>
                </div>
                <div class="card-body">
                    <p>Si el paciente no existe en el sistema, puedes registrarlo directamente desde la página de crear orden:</p>
                    
                    <ol>
                        <li class="mb-2">Haz clic en <strong>"Registrar Nuevo Paciente"</strong></li>
                        <li class="mb-2">Completa el formulario en el modal:
                            <ul class="mt-2">
                                <li><strong>Nombre completo</strong></li>
                                <li><strong>Cédula</strong></li>
                                <li><strong>Email</strong></li>
                                <li><strong>Teléfono</strong></li>
                                <li><strong>Fecha de nacimiento</strong> (importante para rangos de referencia)</li>
                                <li><strong>Sexo</strong> (importante para rangos de referencia)</li>
                            </ul>
                        </li>
                        <li class="mb-2">Guarda el paciente</li>
                        <li class="mb-2">El paciente se seleccionará automáticamente en la orden</li>
                    </ol>

                    <div class="callout callout-warning">
                        <h6><i class="fas fa-exclamation-triangle mr-2"></i> Datos Importantes</h6>
                        <p class="small mb-0">La <strong>fecha de nacimiento</strong> y el <strong>sexo</strong> son fundamentales para que el sistema muestre los rangos de referencia correctos en los resultados.</p>
                    </div>
                </div>
            </div>

            <!-- Ver y Descargar -->
            <div class="card" id="ver-orden">
                <div class="card-header bg-secondary">
                    <h3 class="card-title text-white"><i class="fas fa-file-pdf mr-2"></i> 5. Ver y Descargar Orden</h3>
                </div>
                <div class="card-body">
                    <h5>Después de Crear la Orden:</h5>
                    
                    <div class="row">
                        <div class="col-md-4">
                            <div class="small-box bg-info">
                                <div class="inner">
                                    <h4><i class="fas fa-eye"></i></h4>
                                    <p>Ver detalles de la orden en el listado</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="small-box bg-warning">
                                <div class="inner">
                                    <h4><i class="fas fa-edit"></i></h4>
                                    <p>Cargar resultados cuando estén listos</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="small-box bg-success">
                                <div class="inner">
                                    <h4><i class="fas fa-download"></i></h4>
                                    <p>Descargar PDF con resultados</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <h5 class="mt-4">Estados de la Orden:</h5>
                    <table class="table table-bordered">
                        <thead class="bg-light">
                            <tr>
                                <th>Estado</th>
                                <th>Descripción</th>
                                <th>Acciones Disponibles</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><span class="badge badge-warning">Pendiente</span></td>
                                <td>Orden creada, esperando resultados</td>
                                <td>Cargar resultados, Ver detalles</td>
                            </tr>
                            <tr>
                                <td><span class="badge badge-success">Completada</span></td>
                                <td>Resultados cargados</td>
                                <td>Ver detalles, Descargar PDF</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="alert alert-success mt-3">
                        <h5><i class="fas fa-check-circle mr-2"></i> ¡Listo!</h5>
                        <p class="mb-0">Una vez completada la orden, el paciente puede descargar sus resultados desde su panel o puedes generarle el PDF directamente.</p>
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
