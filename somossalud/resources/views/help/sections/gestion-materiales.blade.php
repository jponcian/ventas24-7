@extends('layouts.adminlte')

@section('title', 'Gestión de Materiales - Ayuda')

@section('content_header')
    <h1><i class="fas fa-box mr-2"></i> Gestión de Materiales</h1>
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
                        <a href="#buscar" class="list-group-item list-group-item-action">2. Buscar Materiales</a>
                        <a href="#crear" class="list-group-item list-group-item-action">3. Crear Material</a>
                        <a href="#editar" class="list-group-item list-group-item-action">4. Editar Material</a>
                        <a href="#categorias" class="list-group-item list-group-item-action">5. Categorías</a>
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
                    <p class="lead">El módulo de <strong>Gestión de Materiales</strong> permite administrar el catálogo de materiales clínicos disponibles en el inventario.</p>
                    
                    <div class="alert alert-info">
                        <i class="fas fa-lightbulb mr-2"></i>
                        <strong>¿Qué es un material?</strong><br>
                        Es cualquier insumo clínico que se utiliza en la clínica: gasas, jeringas, guantes, medicamentos, equipos, etc.
                    </div>

                    <h5 class="mt-4"><i class="fas fa-user-tag mr-2"></i> ¿Quién puede gestionar materiales?</h5>
                    <ul>
                        <li><strong>Jefe de Almacén:</strong> Crear, editar y eliminar materiales</li>
                        <li><strong>Admin Clínica:</strong> Acceso completo al módulo</li>
                        <li><strong>Otros usuarios:</strong> Solo pueden ver y buscar materiales</li>
                    </ul>

                    <h5 class="mt-4"><i class="fas fa-clipboard-list mr-2"></i> Información de un Material</h5>
                    <table class="table table-bordered">
                        <thead class="bg-light">
                            <tr>
                                <th>Campo</th>
                                <th>Descripción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>Nombre</strong></td>
                                <td>Nombre descriptivo del material</td>
                            </tr>
                            <tr>
                                <td><strong>Categoría</strong></td>
                                <td>Clasificación del material (ENFERMERIA, QUIROFANO, UCI, OFICINA, LABORATORIO)</td>
                            </tr>
                            <tr>
                                <td><strong>Stock Actual</strong></td>
                                <td>Cantidad disponible en inventario</td>
                            </tr>
                            <tr>
                                <td><strong>Stock Mínimo</strong></td>
                                <td>Cantidad mínima antes de requerir reposición</td>
                            </tr>
                            <tr>
                                <td><strong>Unidad de Medida</strong></td>
                                <td>Unidad, Caja, Paquete, Litro, etc.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Buscar -->
            <div class="card" id="buscar">
                <div class="card-header bg-success">
                    <h3 class="card-title text-white"><i class="fas fa-search mr-2"></i> 2. Buscar Materiales</h3>
                </div>
                <div class="card-body">
                    <h5>Búsqueda Interactiva:</h5>
                    <p>El sistema cuenta con una búsqueda en tiempo real que te permite encontrar materiales rápidamente.</p>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="card bg-light">
                                <div class="card-body">
                                    <h6><i class="fas fa-keyboard mr-2"></i> Por Nombre</h6>
                                    <p class="small mb-0">Escribe al menos 3 caracteres del nombre del material en el campo de búsqueda. Los resultados se actualizan automáticamente.</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card bg-light">
                                <div class="card-body">
                                    <h6><i class="fas fa-filter mr-2"></i> Por Categoría</h6>
                                    <p class="small mb-0">Usa el selector de categoría para filtrar materiales por tipo. Puedes combinar búsqueda por nombre y categoría.</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="callout callout-info mt-3">
                        <h6><i class="fas fa-info-circle mr-2"></i> Búsqueda Automática</h6>
                        <p class="small mb-0">No necesitas hacer clic en "Buscar". La tabla se actualiza automáticamente mientras escribes.</p>
                    </div>

                    <h5 class="mt-4">Información Visible en la Lista:</h5>
                    <ul>
                        <li><strong>Nombre:</strong> Nombre del material</li>
                        <li><strong>Categoría:</strong> Clasificación del material</li>
                        <li><strong>Stock Actual:</strong> Cantidad disponible
                            <ul>
                                <li><span class="badge badge-danger">Rojo:</span> Stock por debajo del mínimo</li>
                                <li><span class="badge badge-warning">Amarillo:</span> Stock en nivel de alerta</li>
                                <li><span class="badge badge-success">Verde:</span> Stock suficiente</li>
                            </ul>
                        </li>
                        <li><strong>Stock Mínimo:</strong> Nivel de reposición</li>
                        <li><strong>Unidad:</strong> Unidad de medida</li>
                    </ul>
                </div>
            </div>

            <!-- Crear -->
            <div class="card" id="crear">
                <div class="card-header bg-primary">
                    <h3 class="card-title text-white"><i class="fas fa-plus-circle mr-2"></i> 3. Crear un Material</h3>
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
                                    <p>Haz clic en el botón <button class="btn btn-success btn-sm"><i class="fas fa-plus-circle mr-1"></i> Registrar Material Nuevo</button></p>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-success">Paso 2</span>
                        </div>
                        <div>
                            <i class="fas fa-edit bg-green"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Completar Información Básica</h3>
                                <div class="timeline-body">
                                    <p><strong>Campos requeridos:</strong></p>
                                    <ul class="small">
                                        <li><strong>Nombre:</strong> Nombre descriptivo y único del material</li>
                                        <li><strong>Categoría:</strong> Selecciona la categoría apropiada</li>
                                        <li><strong>Unidad de Medida:</strong> Unidad, Caja, Paquete, Litro, etc.</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-info">Paso 3</span>
                        </div>
                        <div>
                            <i class="fas fa-boxes bg-cyan"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Configurar Stock</h3>
                                <div class="timeline-body">
                                    <p><strong>Campos de inventario:</strong></p>
                                    <ul class="small">
                                        <li><strong>Stock Inicial:</strong> Cantidad inicial en inventario (opcional)</li>
                                        <li><strong>Stock Mínimo:</strong> Nivel de alerta para reposición</li>
                                    </ul>
                                    <div class="alert alert-info mt-2">
                                        <i class="fas fa-info-circle mr-2"></i>
                                        <strong>Tip:</strong> El stock mínimo te ayudará a identificar cuándo necesitas reponer el material.
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
                                <h3 class="timeline-header">Guardar Material</h3>
                                <div class="timeline-body">
                                    <p>Revisa la información y haz clic en <button class="btn btn-primary btn-sm"><i class="fas fa-save mr-1"></i> Guardar</button></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-success mt-3">
                        <h6><i class="fas fa-check-circle mr-2"></i> Después de Crear</h6>
                        <p class="small mb-0">El material estará disponible inmediatamente para ser usado en solicitudes de inventario.</p>
                    </div>

                    <div class="callout callout-warning mt-3">
                        <h6><i class="fas fa-exclamation-triangle mr-2"></i> Nombres Únicos</h6>
                        <p class="small mb-0">No puedes crear dos materiales con el mismo nombre. Si el material ya existe, edítalo en lugar de crear uno nuevo.</p>
                    </div>
                </div>
            </div>

            <!-- Editar -->
            <div class="card" id="editar">
                <div class="card-header bg-warning">
                    <h3 class="card-title text-white"><i class="fas fa-edit mr-2"></i> 4. Editar un Material</h3>
                </div>
                <div class="card-body">
                    <h5>¿Cuándo editar un material?</h5>
                    <ul>
                        <li>Corregir el nombre o descripción</li>
                        <li>Cambiar la categoría</li>
                        <li>Ajustar el stock mínimo</li>
                        <li>Modificar la unidad de medida</li>
                    </ul>

                    <h5 class="mt-4">Proceso de Edición:</h5>
                    <ol>
                        <li class="mb-2">Busca el material que deseas editar</li>
                        <li class="mb-2">Haz clic en el botón <button class="btn btn-warning btn-sm"><i class="fas fa-edit"></i></button> en la columna de acciones</li>
                        <li class="mb-2">Modifica los campos necesarios</li>
                        <li class="mb-2">Haz clic en <button class="btn btn-primary btn-sm"><i class="fas fa-save mr-1"></i> Actualizar</button></li>
                    </ol>

                    <div class="alert alert-warning mt-3">
                        <h6><i class="fas fa-exclamation-triangle mr-2"></i> Importante</h6>
                        <p class="small mb-0">No puedes editar el stock actual desde aquí. El stock se actualiza automáticamente con los ingresos y despachos. Si necesitas ajustar el stock, usa el módulo de <strong>Registro de Ingresos</strong>.</p>
                    </div>

                    <h5 class="mt-4">Eliminar un Material:</h5>
                    <p>Para eliminar un material:</p>
                    <ol>
                        <li class="mb-2">Haz clic en el botón <button class="btn btn-danger btn-sm"><i class="fas fa-trash"></i></button></li>
                        <li class="mb-2">Confirma la acción en el mensaje de advertencia</li>
                    </ol>

                    <div class="callout callout-warning mt-3">
                        <h6><i class="fas fa-exclamation-triangle mr-2"></i> Precaución al Eliminar</h6>
                        <p class="small mb-0">Solo puedes eliminar materiales que no hayan sido usados en solicitudes. Si el material tiene historial, no podrás eliminarlo para mantener la integridad de los registros.</p>
                    </div>
                </div>
            </div>

            <!-- Categorías -->
            <div class="card" id="categorias">
                <div class="card-header bg-info">
                    <h3 class="card-title text-white"><i class="fas fa-folder mr-2"></i> 5. Categorías de Materiales</h3>
                </div>
                <div class="card-body">
                    <h5>Categorías Disponibles:</h5>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card border-primary">
                                <div class="card-header bg-primary text-white">
                                    <h6 class="mb-0"><i class="fas fa-heartbeat mr-2"></i> ENFERMERIA</h6>
                                </div>
                                <div class="card-body">
                                    <p class="small"><strong>Materiales de uso general en enfermería:</strong></p>
                                    <ul class="small">
                                        <li>Gasas estériles</li>
                                        <li>Jeringas y agujas</li>
                                        <li>Guantes desechables</li>
                                        <li>Vendas y esparadrapo</li>
                                        <li>Algodón y alcohol</li>
                                        <li>Termómetros</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="card border-danger">
                                <div class="card-header bg-danger text-white">
                                    <h6 class="mb-0"><i class="fas fa-procedures mr-2"></i> QUIROFANO</h6>
                                </div>
                                <div class="card-body">
                                    <p class="small"><strong>Material quirúrgico especializado:</strong></p>
                                    <ul class="small">
                                        <li>Instrumental quirúrgico</li>
                                        <li>Suturas y material de cierre</li>
                                        <li>Campos quirúrgicos estériles</li>
                                        <li>Bisturís y hojas</li>
                                        <li>Drenajes</li>
                                        <li>Material de anestesia</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="card border-warning">
                                <div class="card-header bg-warning text-white">
                                    <h6 class="mb-0"><i class="fas fa-hospital mr-2"></i> UCI</h6>
                                </div>
                                <div class="card-body">
                                    <p class="small"><strong>Equipos de cuidados intensivos:</strong></p>
                                    <ul class="small">
                                        <li>Catéteres especializados</li>
                                        <li>Equipos de ventilación</li>
                                        <li>Monitores y sensores</li>
                                        <li>Bombas de infusión</li>
                                        <li>Material de soporte vital</li>
                                        <li>Medicamentos de urgencia</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="card border-success">
                                <div class="card-header bg-success text-white">
                                    <h6 class="mb-0"><i class="fas fa-building mr-2"></i> OFICINA</h6>
                                </div>
                                <div class="card-body">
                                    <p class="small"><strong>Papelería y suministros administrativos:</strong></p>
                                    <ul class="small">
                                        <li>Papel y formularios</li>
                                        <li>Bolígrafos y marcadores</li>
                                        <li>Carpetas y archivadores</li>
                                        <li>Material de oficina general</li>
                                        <li>Tóner y cartuchos</li>
                                        <li>Artículos de limpieza</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="card border-info">
                                <div class="card-header bg-info text-white">
                                    <h6 class="mb-0"><i class="fas fa-flask mr-2"></i> LABORATORIO</h6>
                                </div>
                                <div class="card-body">
                                    <p class="small"><strong>Material de laboratorio clínico:</strong></p>
                                    <ul class="small">
                                        <li>Tubos de ensayo y vacutainers</li>
                                        <li>Reactivos y soluciones</li>
                                        <li>Placas de Petri</li>
                                        <li>Pipetas y micropipetas</li>
                                        <li>Material de microbiología</li>
                                        <li>Kits de diagnóstico</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-info mt-3">
                        <h6><i class="fas fa-info-circle mr-2"></i> Importancia de las Categorías</h6>
                        <p class="small mb-0">Las categorías ayudan a organizar el inventario y facilitan la búsqueda de materiales. Asegúrate de seleccionar la categoría correcta al crear o editar un material.</p>
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
