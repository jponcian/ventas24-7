@extends('layouts.adminlte')

@section('title', 'Gestión de Exámenes - Ayuda')

@section('content_header')
    <h1><i class="fas fa-vials mr-2"></i> Gestión de Exámenes de Laboratorio</h1>
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
                        <a href="#crear-examen" class="list-group-item list-group-item-action">2. Crear un Examen</a>
                        <a href="#agregar-parametros" class="list-group-item list-group-item-action">3. Agregar Parámetros</a>
                        <a href="#configurar-referencias" class="list-group-item list-group-item-action">4. Configurar Referencias</a>
                        <a href="#editar-eliminar" class="list-group-item list-group-item-action">5. Editar y Eliminar</a>
                        <a href="#consejos" class="list-group-item list-group-item-action">6. Consejos Útiles</a>
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
                    <p class="lead">El módulo de <strong>Gestión de Exámenes</strong> te permite administrar completamente el catálogo de exámenes de laboratorio.</p>
                    
                    <div class="alert alert-info">
                        <i class="fas fa-lightbulb mr-2"></i>
                        <strong>¿Qué puedes hacer aquí?</strong>
                        <ul class="mb-0 mt-2">
                            <li>Crear nuevos exámenes de laboratorio</li>
                            <li>Definir parámetros individuales para cada examen</li>
                            <li>Configurar rangos de referencia por edad y sexo</li>
                            <li>Editar precios y datos de exámenes existentes</li>
                            <li>Activar o desactivar exámenes</li>
                        </ul>
                    </div>

                    <h5 class="mt-4"><i class="fas fa-map-signs mr-2"></i> Acceso al Módulo</h5>
                    <p>Para acceder, ve al menú lateral:</p>
                    <div class="bg-light p-3 rounded border">
                        <code>Laboratorio → Gestión</code>
                    </div>
                    <p class="text-muted small mt-2">
                        <i class="fas fa-user-shield mr-1"></i> 
                        Solo usuarios con rol <strong>Laboratorio</strong>, <strong>Laboratorio-Resul</strong>, <strong>Admin Clínica</strong> o <strong>Super Admin</strong> pueden acceder.
                    </p>
                </div>
            </div>

            <!-- Crear Examen -->
            <div class="card" id="crear-examen">
                <div class="card-header bg-success">
                    <h3 class="card-title text-white"><i class="fas fa-plus-circle mr-2"></i> 2. Crear un Examen</h3>
                </div>
                <div class="card-body">
                    <h5>Paso a Paso:</h5>
                    
                    <div class="timeline">
                        <div class="time-label">
                            <span class="bg-primary">Paso 1</span>
                        </div>
                        <div>
                            <i class="fas fa-mouse-pointer bg-blue"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Haz clic en "Nuevo Examen"</h3>
                                <div class="timeline-body">
                                    <p>En la página principal de Gestión, encontrarás el botón azul en la esquina superior derecha.</p>
                                    <div class="alert alert-light border">
                                        <img src="{{ asset('images/help/gestion-lab-nuevo.png') }}" class="img-fluid rounded shadow-sm" alt="Botón Nuevo Examen" onerror="this.parentElement.innerHTML='<p class=text-muted><i class=fas fa-image></i> Imagen: Botón azul que dice <strong>+ Nuevo Examen</strong></p>'">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-primary">Paso 2</span>
                        </div>
                        <div>
                            <i class="fas fa-edit bg-green"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Completa el formulario</h3>
                                <div class="timeline-body">
                                    <table class="table table-sm table-bordered">
                                        <thead class="bg-light">
                                            <tr>
                                                <th width="30%">Campo</th>
                                                <th>Descripción</th>
                                                <th width="20%">Ejemplo</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Código</strong> <span class="text-danger">*</span></td>
                                                <td>Identificador único del examen</td>
                                                <td><code>HEM001</code></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Nombre</strong> <span class="text-danger">*</span></td>
                                                <td>Nombre completo del examen</td>
                                                <td>Hematología Completa</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Abreviatura</strong></td>
                                                <td>Nombre corto (opcional)</td>
                                                <td>HMG</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Categoría</strong> <span class="text-danger">*</span></td>
                                                <td>Grupo al que pertenece</td>
                                                <td>Hematología</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Precio (USD)</strong> <span class="text-danger">*</span></td>
                                                <td>Costo del examen</td>
                                                <td>15.00</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <p class="text-muted small"><span class="text-danger">*</span> Campos obligatorios</p>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-primary">Paso 3</span>
                        </div>
                        <div>
                            <i class="fas fa-save bg-success"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Guarda el examen</h3>
                                <div class="timeline-body">
                                    <p>Haz clic en el botón <strong>"Crear Examen"</strong>. Serás redirigido automáticamente a la página de edición donde podrás agregar los parámetros.</p>
                                    <div class="alert alert-success">
                                        <i class="fas fa-check-circle mr-2"></i> ¡Examen creado! Ahora puedes agregar los parámetros individuales.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Agregar Parámetros -->
            <div class="card" id="agregar-parametros">
                <div class="card-header bg-warning">
                    <h3 class="card-title"><i class="fas fa-list mr-2"></i> 3. Agregar Parámetros</h3>
                </div>
                <div class="card-body">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle mr-2"></i>
                        <strong>¿Qué son los parámetros?</strong><br>
                        Son los valores individuales que se miden en un examen. Por ejemplo, en una Hematología Completa: Hemoglobina, Leucocitos, Plaquetas, etc.
                    </div>

                    <h5 class="mt-4">Cómo Agregar:</h5>
                    <ol>
                        <li class="mb-3">
                            <strong>Haz clic en "Agregar Parámetro"</strong> (botón verde en la sección de parámetros)
                        </li>
                        <li class="mb-3">
                            <strong>Completa el modal:</strong>
                            <table class="table table-sm table-bordered mt-2">
                                <tr>
                                    <td width="30%"><strong>Nombre</strong></td>
                                    <td>Ej: Hemoglobina, Glucosa, Colesterol</td>
                                </tr>
                                <tr>
                                    <td><strong>Unidad</strong></td>
                                    <td>Ej: mg/dL, g/dL, mmol/L</td>
                                </tr>
                                <tr>
                                    <td><strong>Tipo</strong></td>
                                    <td>
                                        <div class="mb-1"><span class="badge badge-primary">N</span> <strong>Numérico:</strong> Valores numéricos validables</div>
                                        <div class="mb-1"><span class="badge badge-secondary">T</span> <strong>Texto:</strong> Resultados cualitativos cortos</div>
                                        <div class="mb-1"><span class="badge badge-dark">E</span> <strong>Encabezado:</strong> Título de sección</div>
                                        <div class="mb-1"><span class="badge badge-info">O</span> <strong>Observación:</strong> Texto largo/notas</div>
                                        <div><span class="badge badge-warning">F</span> <strong>Fórmula:</strong> Valor calculado</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>Orden</strong></td>
                                    <td>Posición en que aparecerá en el reporte (1, 2, 3...)</td>
                                </tr>
                            </table>
                        </li>
                        <li class="mb-3">
                            <strong>Guarda</strong> y repite para cada parámetro del examen
                        </li>
                    </ol>

                    <div class="callout callout-warning">
                        <h5><i class="fas fa-exclamation-triangle mr-2"></i> Importante</h5>
                        <p class="mb-0">El <strong>orden</strong> determina cómo se mostrarán los resultados en el PDF. Asegúrate de numerarlos correctamente.</p>
                    </div>
                </div>
            </div>

            <!-- Configurar Referencias -->
            <div class="card" id="configurar-referencias">
                <div class="card-header bg-info">
                    <h3 class="card-title text-white"><i class="fas fa-chart-line mr-2"></i> 4. Configurar Rangos de Referencia</h3>
                </div>
                <div class="card-body">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle mr-2"></i>
                        <strong>¿Qué son los rangos de referencia?</strong><br>
                        Son los valores normales esperados para cada parámetro, que varían según la edad y sexo del paciente.
                    </div>

                    <h5 class="mt-4">Proceso:</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card bg-light">
                                <div class="card-body">
                                    <h6 class="font-weight-bold">1. Accede a Referencias</h6>
                                    <p class="small">En la tabla de parámetros, haz clic en el ícono <i class="fas fa-chart-line text-info"></i> del parámetro que deseas configurar.</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <div class="card bg-light">
                                <div class="card-body">
                                    <h6 class="font-weight-bold"><i class="fas fa-layer-group text-primary mr-2"></i> 2. Guía de Grupos de Referencia</h6>
                                    <p class="small">Elige el grupo adecuado para que el sistema valide automáticamente los resultados:</p>
                                    
                                    <div class="accordion" id="accordionRef">
                                        <!-- Grupos Automáticos -->
                                        <div class="card mb-1">
                                            <div class="card-header p-2 bg-white" id="headingAuto">
                                                <h2 class="mb-0">
                                                    <button class="btn btn-link btn-block text-left font-weight-bold text-success" type="button" data-toggle="collapse" data-target="#collapseAuto">
                                                        <i class="fas fa-magic mr-2"></i> Automáticos (Por Edad y Sexo)
                                                    </button>
                                                </h2>
                                            </div>
                                            <div id="collapseAuto" class="collapse show" data-parent="#accordionRef">
                                                <div class="card-body p-2 small">
                                                    <p>El sistema usa la fecha de nacimiento para asignar estos rangos:</p>
                                                    <table class="table table-sm table-bordered bg-white">
                                                        <thead>
                                                            <tr>
                                                                <th>Categoría</th>
                                                                <th>Grupos Incluidos</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr>
                                                                <td><strong>Pediatría</strong></td>
                                                                <td>Neonatos (1-2d), Recién Nacidos (3-30d), Infantes (1-12m), Niños (1-13a)</td>
                                                            </tr>
                                                            <tr>
                                                                <td><strong>Adultos Detallados</strong></td>
                                                                <td>Jóvenes (18-30), Adultos (31-50), Maduros (51-70), Mayores (71+)</td>
                                                            </tr>
                                                            <tr>
                                                                <td><strong>Universales</strong></td>
                                                                <td>
                                                                    <strong>UNIVERSAL - Todos (0-120 años):</strong> Para valores idénticos en cualquier persona.<br>
                                                                    <strong>ADULTOS - Todos (14-120 años):</strong> Para cualquier adulto sin importar sexo.<br>
                                                                    <strong>HOMBRES/MUJERES Generales:</strong> Para cualquier edad dentro de ese sexo.
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Grupos Manuales -->
                                        <div class="card mb-0">
                                            <div class="card-header p-2 bg-white" id="headingManual">
                                                <h2 class="mb-0">
                                                    <button class="btn btn-link btn-block text-left font-weight-bold text-info" type="button" data-toggle="collapse" data-target="#collapseManual">
                                                        <i class="fas fa-hand-paper mr-2"></i> Configuración Manual / Especial
                                                    </button>
                                                </h2>
                                            </div>
                                            <div id="collapseManual" class="collapse" data-parent="#accordionRef">
                                                <div class="card-body p-2 small">
                                                    <p>Úsalos cuando la edad/sexo no sea suficiente. Debes especificar la condición en el campo de texto.</p>
                                                    <ul class="mb-0">
                                                        <li><strong>HOMBRES/MUJERES - Manual:</strong> Fases del ciclo, embarazo, terapias hormonales.</li>
                                                        <li><strong>GENERAL - Manual:</strong> Tablas de riesgo (Deseable/Alto), condiciones como "Diabéticos", "Fumadores".</li>
                                                        <li><strong>NIÑOS - Manual:</strong> Rangos pediátricos no estándar (ej. Escolar 6-12 años).</li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>

                    <h5 class="mt-4">Campos del Formulario:</h5>
                    <table class="table table-bordered">
                        <thead class="bg-light">
                            <tr>
                                <th>Campo</th>
                                <th>Descripción</th>
                                <th>Ejemplo</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>Grupo de Referencia</strong></td>
                                <td>Define sexo y rango de edad</td>
                                <td>Masculino 18-65 años</td>
                            </tr>
                            <tr>
                                <td><strong>Valor Mínimo</strong></td>
                                <td>Límite inferior del rango normal</td>
                                <td>13.5</td>
                            </tr>
                            <tr>
                                <td><strong>Valor Máximo</strong></td>
                                <td>Límite superior del rango normal</td>
                                <td>17.5</td>
                            </tr>
                            <tr>
                                <td><strong>Valor Texto</strong></td>
                                <td>Alternativa para valores no numéricos</td>
                                <td>Negativo, Positivo, Normal</td>
                            </tr>
                            <tr>
                                <td><strong>Condición</strong></td>
                                <td>Condiciones especiales (opcional)</td>
                                <td>En ayunas, Post-prandial</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="callout callout-success">
                        <h5><i class="fas fa-lightbulb mr-2"></i> Consejo</h5>
                        <p class="mb-0">Puedes agregar múltiples rangos para el mismo parámetro si los valores normales varían por edad o sexo.</p>
                    </div>
                </div>
            </div>

            <!-- Editar y Eliminar -->
            <div class="card" id="editar-eliminar">
                <div class="card-header bg-secondary">
                    <h3 class="card-title text-white"><i class="fas fa-tools mr-2"></i> 5. Editar y Eliminar</h3>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h5><i class="fas fa-edit text-info mr-2"></i> Editar</h5>
                            <p>Para modificar un examen existente:</p>
                            <ol>
                                <li>Busca el examen en la lista principal</li>
                                <li>Haz clic en el botón azul <i class="fas fa-edit"></i></li>
                                <li>Modifica los datos necesarios</li>
                                <li>Guarda los cambios</li>
                            </ol>
                            <div class="alert alert-info small">
                                <i class="fas fa-info-circle mr-1"></i> Puedes activar/desactivar exámenes con el switch "Examen activo"
                            </div>
                        </div>
                        <div class="col-md-6">
                            <h5><i class="fas fa-trash text-danger mr-2"></i> Eliminar</h5>
                            <p>Para eliminar un examen:</p>
                            <ol>
                                <li>Haz clic en el botón rojo <i class="fas fa-trash"></i></li>
                                <li>Confirma la acción en el mensaje de alerta</li>
                            </ol>
                            <div class="alert alert-warning small">
                                <i class="fas fa-exclamation-triangle mr-1"></i> <strong>Importante:</strong> No podrás eliminar exámenes que tengan órdenes asociadas. En su lugar, desactívalos.
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Consejos -->
            <div class="card" id="consejos">
                <div class="card-header bg-dark">
                    <h3 class="card-title text-white"><i class="fas fa-star mr-2"></i> 6. Consejos Útiles</h3>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="small-box bg-info">
                                <div class="inner">
                                    <h4><i class="fas fa-code"></i></h4>
                                    <p>Usa códigos consistentes (ej: HEM001, HEM002) para facilitar la búsqueda</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="small-box bg-success">
                                <div class="inner">
                                    <h4><i class="fas fa-sort-numeric-down"></i></h4>
                                    <p>Numera los parámetros en orden lógico para reportes más claros</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="small-box bg-warning">
                                <div class="inner">
                                    <h4><i class="fas fa-check-double"></i></h4>
                                    <p>Verifica siempre los rangos de referencia antes de activar un examen</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-success mt-3">
                        <h5><i class="fas fa-question-circle mr-2"></i> ¿Necesitas más ayuda?</h5>
                        <p class="mb-0">Contacta al administrador del sistema o revisa las otras secciones del Centro de Ayuda.</p>
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
    
    .callout-success {
        border-left-color: #00a65a;
        background-color: #f0f9ff;
    }
    
    html {
        scroll-behavior: smooth;
    }
</style>
@endpush
