@extends('layouts.adminlte')

@section('title', 'Gestión de Usuarios - Ayuda')

@section('content_header')
    <h1><i class="fas fa-users-cog mr-2"></i> Gestión de Usuarios</h1>
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
                        <a href="#crear" class="list-group-item list-group-item-action">2. Crear Usuario</a>
                        <a href="#roles" class="list-group-item list-group-item-action">3. Roles y Permisos</a>
                        <a href="#gestionar" class="list-group-item list-group-item-action">4. Gestionar Usuarios</a>
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
                    <p class="lead">El módulo de <strong>Gestión de Usuarios</strong> permite administrar todos los usuarios del sistema y sus permisos.</p>
                    
                    <div class="alert alert-info">
                        <i class="fas fa-lightbulb mr-2"></i>
                        <strong>¿Qué es un usuario?</strong><br>
                        Es cualquier persona que tiene acceso al sistema: pacientes, médicos, personal administrativo, etc.
                    </div>

                    <h5 class="mt-4"><i class="fas fa-user-shield mr-2"></i> ¿Quién puede gestionar usuarios?</h5>
                    <ul>
                        <li><strong>Super Admin:</strong> Acceso completo, puede crear y gestionar todos los usuarios</li>
                        <li><strong>Admin Clínica:</strong> Puede crear y gestionar usuarios excepto Super Admins</li>
                        <li><strong>Recepción:</strong> Puede crear y editar pacientes únicamente</li>
                    </ul>

                    <h5 class="mt-4"><i class="fas fa-clipboard-list mr-2"></i> Información de un Usuario</h5>
                    <table class="table table-bordered">
                        <thead class="bg-light">
                            <tr>
                                <th>Campo</th>
                                <th>Descripción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>Nombre Completo</strong></td>
                                <td>Nombre y apellido del usuario</td>
                            </tr>
                            <tr>
                                <td><strong>Cédula</strong></td>
                                <td>Número de identificación único</td>
                            </tr>
                            <tr>
                                <td><strong>Email</strong></td>
                                <td>Correo electrónico para acceso al sistema</td>
                            </tr>
                            <tr>
                                <td><strong>Teléfono</strong></td>
                                <td>Número de contacto (para recordatorios)</td>
                            </tr>
                            <tr>
                                <td><strong>Roles</strong></td>
                                <td>Permisos y accesos del usuario en el sistema</td>
                            </tr>
                            <tr>
                                <td><strong>Especialidades</strong></td>
                                <td>Solo para médicos: especialidades que practica</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Crear Usuario -->
            <div class="card" id="crear">
                <div class="card-header bg-success">
                    <h3 class="card-title text-white"><i class="fas fa-user-plus mr-2"></i> 2. Crear un Usuario</h3>
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
                                    <p>Ve a <strong>Administración → Usuarios</strong> y haz clic en <button class="btn btn-primary btn-sm"><i class="fas fa-user-plus mr-1"></i> Nuevo Usuario</button></p>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-success">Paso 2</span>
                        </div>
                        <div>
                            <i class="fas fa-id-card bg-green"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Información Personal</h3>
                                <div class="timeline-body">
                                    <p><strong>Completa los datos básicos:</strong></p>
                                    <ul class="small">
                                        <li><strong>Nombre:</strong> Nombre completo del usuario</li>
                                        <li><strong>Cédula:</strong> Número de identificación (debe ser único)</li>
                                        <li><strong>Email:</strong> Correo electrónico (será el usuario de acceso)</li>
                                        <li><strong>Teléfono:</strong> Número de contacto</li>
                                        <li><strong>Fecha de Nacimiento:</strong> Para pacientes</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-info">Paso 3</span>
                        </div>
                        <div>
                            <i class="fas fa-key bg-cyan"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Seguridad</h3>
                                <div class="timeline-body">
                                    <p><strong>Configura el acceso:</strong></p>
                                    <ul class="small">
                                        <li><strong>Contraseña:</strong> Mínimo 8 caracteres</li>
                                        <li><strong>Confirmar Contraseña:</strong> Debe coincidir</li>
                                    </ul>
                                    <div class="alert alert-warning mt-2">
                                        <i class="fas fa-exclamation-triangle mr-2"></i>
                                        <strong>Importante:</strong> Proporciona una contraseña segura al usuario y pídele que la cambie en su primer acceso.
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-warning">Paso 4</span>
                        </div>
                        <div>
                            <i class="fas fa-user-tag bg-orange"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Asignar Roles</h3>
                                <div class="timeline-body">
                                    <p>Selecciona uno o más roles según las funciones del usuario:</p>
                                    <ul class="small">
                                        <li><strong>Paciente:</strong> Acceso básico para ver citas</li>
                                        <li><strong>Médico/Especialista:</strong> Gestión de consultas y citas</li>
                                        <li><strong>Recepción:</strong> Gestión de citas y pacientes</li>
                                        <li><strong>Jefe de Almacén:</strong> Gestión de inventario</li>
                                        <li><strong>Admin Clínica:</strong> Acceso administrativo completo</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-secondary">Paso 5</span>
                        </div>
                        <div>
                            <i class="fas fa-stethoscope bg-gray"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Especialidades (Solo Médicos)</h3>
                                <div class="timeline-body">
                                    <p>Si el usuario es médico, selecciona sus especialidades:</p>
                                    <ul class="small">
                                        <li>Cardiología</li>
                                        <li>Pediatría</li>
                                        <li>Medicina General</li>
                                        <li>Ginecología</li>
                                        <li>Y más...</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-primary">Paso 6</span>
                        </div>
                        <div>
                            <i class="fas fa-save bg-blue"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Guardar Usuario</h3>
                                <div class="timeline-body">
                                    <p>Revisa toda la información y haz clic en <button class="btn btn-primary btn-sm"><i class="fas fa-save mr-1"></i> Guardar</button></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-success mt-3">
                        <h6><i class="fas fa-check-circle mr-2"></i> Después de Crear</h6>
                        <ul class="small mb-0">
                            <li>El usuario podrá acceder al sistema con su email y contraseña</li>
                            <li>Tendrá acceso solo a los módulos permitidos por sus roles</li>
                            <li>Recibirá notificaciones según su configuración</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Roles y Permisos -->
            <div class="card" id="roles">
                <div class="card-header bg-warning">
                    <h3 class="card-title text-white"><i class="fas fa-user-shield mr-2"></i> 3. Roles y Permisos</h3>
                </div>
                <div class="card-body">
                    <h5>Roles Disponibles en el Sistema:</h5>
                    
                    <div class="accordion" id="rolesAccordion">
                        <!-- Paciente -->
                        <div class="card">
                            <div class="card-header bg-light" id="headingPaciente">
                                <h6 class="mb-0">
                                    <button class="btn btn-link text-dark" type="button" data-toggle="collapse" data-target="#collapsePaciente">
                                        <i class="fas fa-user mr-2 text-primary"></i> Paciente
                                    </button>
                                </h6>
                            </div>
                            <div id="collapsePaciente" class="collapse show" data-parent="#rolesAccordion">
                                <div class="card-body">
                                    <p class="small"><strong>Permisos:</strong></p>
                                    <ul class="small">
                                        <li>Ver sus propias citas</li>
                                        <li>Ver su historial médico</li>
                                        <li>Actualizar su perfil</li>
                                        <li>Reportar pagos</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Médico/Especialista -->
                        <div class="card">
                            <div class="card-header bg-light" id="headingMedico">
                                <h6 class="mb-0">
                                    <button class="btn btn-link text-dark collapsed" type="button" data-toggle="collapse" data-target="#collapseMedico">
                                        <i class="fas fa-user-md mr-2 text-success"></i> Médico/Especialista
                                    </button>
                                </h6>
                            </div>
                            <div id="collapseMedico" class="collapse" data-parent="#rolesAccordion">
                                <div class="card-body">
                                    <p class="small"><strong>Permisos:</strong></p>
                                    <ul class="small">
                                        <li>Ver sus citas programadas</li>
                                        <li>Marcar asistencia de pacientes</li>
                                        <li>Crear órdenes de laboratorio</li>
                                        <li>Registrar atenciones médicas</li>
                                        <li>Ver historial de sus pacientes</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Recepción -->
                        <div class="card">
                            <div class="card-header bg-light" id="headingRecepcion">
                                <h6 class="mb-0">
                                    <button class="btn btn-link text-dark collapsed" type="button" data-toggle="collapse" data-target="#collapseRecepcion">
                                        <i class="fas fa-desktop mr-2 text-info"></i> Recepción
                                    </button>
                                </h6>
                            </div>
                            <div id="collapseRecepcion" class="collapse" data-parent="#rolesAccordion">
                                <div class="card-body">
                                    <p class="small"><strong>Permisos:</strong></p>
                                    <ul class="small">
                                        <li>Crear y gestionar citas</li>
                                        <li>Crear y editar pacientes</li>
                                        <li>Validar pagos</li>
                                        <li>Gestionar atenciones</li>
                                        <li>Ver reportes básicos</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Jefe de Almacén -->
                        <div class="card">
                            <div class="card-header bg-light" id="headingAlmacen">
                                <h6 class="mb-0">
                                    <button class="btn btn-link text-dark collapsed" type="button" data-toggle="collapse" data-target="#collapseAlmacen">
                                        <i class="fas fa-boxes mr-2 text-warning"></i> Jefe de Almacén
                                    </button>
                                </h6>
                            </div>
                            <div id="collapseAlmacen" class="collapse" data-parent="#rolesAccordion">
                                <div class="card-body">
                                    <p class="small"><strong>Permisos:</strong></p>
                                    <ul class="small">
                                        <li>Gestionar materiales de inventario</li>
                                        <li>Aprobar/rechazar solicitudes</li>
                                        <li>Registrar ingresos de inventario</li>
                                        <li>Despachar materiales</li>
                                        <li>Ver reportes de inventario</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Admin Clínica -->
                        <div class="card">
                            <div class="card-header bg-light" id="headingAdmin">
                                <h6 class="mb-0">
                                    <button class="btn btn-link text-dark collapsed" type="button" data-toggle="collapse" data-target="#collapseAdmin">
                                        <i class="fas fa-user-cog mr-2 text-danger"></i> Admin Clínica
                                    </button>
                                </h6>
                            </div>
                            <div id="collapseAdmin" class="collapse" data-parent="#rolesAccordion">
                                <div class="card-body">
                                    <p class="small"><strong>Permisos:</strong></p>
                                    <ul class="small">
                                        <li>Acceso completo a todos los módulos</li>
                                        <li>Gestionar usuarios (excepto Super Admin)</li>
                                        <li>Ver todos los reportes</li>
                                        <li>Configurar el sistema</li>
                                        <li>Gestionar especialidades y servicios</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-info mt-3">
                        <h6><i class="fas fa-info-circle mr-2"></i> Roles Múltiples</h6>
                        <p class="small mb-0">Un usuario puede tener múltiples roles. Por ejemplo, un médico puede ser también Admin Clínica, teniendo acceso tanto a funciones médicas como administrativas.</p>
                    </div>
                </div>
            </div>

            <!-- Gestionar Usuarios -->
            <div class="card" id="gestionar">
                <div class="card-header bg-info">
                    <h3 class="card-title text-white"><i class="fas fa-tasks mr-2"></i> 4. Gestionar Usuarios</h3>
                </div>
                <div class="card-body">
                    <h5>Acciones Disponibles:</h5>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="card border-primary">
                                <div class="card-header bg-primary text-white">
                                    <h6 class="mb-0"><i class="fas fa-search mr-2"></i> Buscar Usuarios</h6>
                                </div>
                                <div class="card-body">
                                    <p class="small">Usa la búsqueda interactiva para encontrar usuarios por:</p>
                                    <ul class="small mb-0">
                                        <li>Nombre</li>
                                        <li>Email</li>
                                        <li>Cédula</li>
                                    </ul>
                                    <p class="small mt-2 mb-0">También puedes filtrar por rol para ver solo pacientes, médicos, etc.</p>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="card border-warning">
                                <div class="card-header bg-warning text-white">
                                    <h6 class="mb-0"><i class="fas fa-edit mr-2"></i> Editar Usuario</h6>
                                </div>
                                <div class="card-body">
                                    <p class="small">Haz clic en <button class="btn btn-warning btn-sm"><i class="fas fa-edit"></i></button> para modificar:</p>
                                    <ul class="small mb-0">
                                        <li>Información personal</li>
                                        <li>Roles asignados</li>
                                        <li>Especialidades (médicos)</li>
                                        <li>Contraseña (si es necesario)</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="card border-success">
                                <div class="card-header bg-success text-white">
                                    <h6 class="mb-0"><i class="fas fa-user-check mr-2"></i> Activar/Desactivar</h6>
                                </div>
                                <div class="card-body">
                                    <p class="small mb-2">Puedes desactivar temporalmente un usuario sin eliminarlo:</p>
                                    <ul class="small mb-0">
                                        <li>Usuario desactivado no puede acceder al sistema</li>
                                        <li>Sus datos se mantienen en el sistema</li>
                                        <li>Puedes reactivarlo cuando sea necesario</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="card border-danger">
                                <div class="card-header bg-danger text-white">
                                    <h6 class="mb-0"><i class="fas fa-trash mr-2"></i> Eliminar Usuario</h6>
                                </div>
                                <div class="card-body">
                                    <p class="small mb-2">Elimina usuarios que ya no son necesarios:</p>
                                    <div class="alert alert-danger small mb-0">
                                        <i class="fas fa-exclamation-triangle mr-1"></i>
                                        <strong>Precaución:</strong> No puedes eliminar usuarios con historial médico, citas o transacciones registradas.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <h5 class="mt-4"><i class="fas fa-shield-alt mr-2"></i> Buenas Prácticas:</h5>
                    <div class="alert alert-info">
                        <ul class="small mb-0">
                            <li>Asigna solo los roles necesarios para cada usuario</li>
                            <li>Revisa periódicamente los usuarios activos</li>
                            <li>Desactiva usuarios que ya no trabajan en la clínica</li>
                            <li>Mantén actualizada la información de contacto</li>
                            <li>Usa contraseñas seguras y pide a los usuarios cambiarlas regularmente</li>
                        </ul>
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
    
    html {
        scroll-behavior: smooth;
    }
</style>
@endpush
