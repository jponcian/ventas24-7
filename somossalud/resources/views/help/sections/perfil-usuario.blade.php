@extends('layouts.adminlte')

@section('title', 'Perfil de Usuario - Ayuda')

@section('content_header')
    <h1><i class="fas fa-user-circle mr-2"></i> Perfil de Usuario</h1>
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
                        <a href="#acceder" class="list-group-item list-group-item-action">2. Acceder al Perfil</a>
                        <a href="#editar" class="list-group-item list-group-item-action">3. Editar Información</a>
                        <a href="#seguridad" class="list-group-item list-group-item-action">4. Seguridad</a>
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
                    <p class="lead">Tu <strong>Perfil de Usuario</strong> contiene toda tu información personal y configuración de acceso al sistema.</p>
                    
                    <div class="alert alert-info">
                        <i class="fas fa-lightbulb mr-2"></i>
                        <strong>¿Por qué es importante mantener tu perfil actualizado?</strong><br>
                        La información de tu perfil se usa para contactarte, enviarte recordatorios y personalizar tu experiencia en el sistema.
                    </div>

                    <h5 class="mt-4"><i class="fas fa-clipboard-list mr-2"></i> Información en tu Perfil</h5>
                    <table class="table table-bordered">
                        <thead class="bg-light">
                            <tr>
                                <th>Sección</th>
                                <th>Contenido</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>Información Personal</strong></td>
                                <td>Nombre, cédula, fecha de nacimiento, teléfono</td>
                            </tr>
                            <tr>
                                <td><strong>Información de Contacto</strong></td>
                                <td>Email, teléfono, dirección</td>
                            </tr>
                            <tr>
                                <td><strong>Seguridad</strong></td>
                                <td>Contraseña, configuración de acceso</td>
                            </tr>
                            <tr>
                                <td><strong>Roles y Permisos</strong></td>
                                <td>Roles asignados y accesos al sistema (solo lectura)</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="alert alert-warning">
                        <h6><i class="fas fa-exclamation-triangle mr-2"></i> Campos No Editables</h6>
                        <p class="small mb-0">Algunos campos como <strong>cédula</strong>, <strong>email</strong> y <strong>roles</strong> solo pueden ser modificados por un administrador. Si necesitas cambiar estos datos, contacta al personal administrativo.</p>
                    </div>
                </div>
            </div>

            <!-- Acceder al Perfil -->
            <div class="card" id="acceder">
                <div class="card-header bg-success">
                    <h3 class="card-title text-white"><i class="fas fa-sign-in-alt mr-2"></i> 2. Acceder a tu Perfil</h3>
                </div>
                <div class="card-body">
                    <h5>¿Cómo acceder?</h5>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card bg-light">
                                <div class="card-body">
                                    <h6 class="text-primary"><i class="fas fa-mouse-pointer mr-2"></i> Método 1: Menú Superior</h6>
                                    <ol class="small mb-0">
                                        <li>Haz clic en tu nombre en la esquina superior derecha</li>
                                        <li>Selecciona <strong>"Perfil"</strong> del menú desplegable</li>
                                    </ol>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="card bg-light">
                                <div class="card-body">
                                    <h6 class="text-success"><i class="fas fa-bars mr-2"></i> Método 2: Menú Lateral</h6>
                                    <ol class="small mb-0">
                                        <li>Busca la sección <strong>"Mi Perfil"</strong> en el menú lateral</li>
                                        <li>Haz clic para acceder</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card border-primary mt-3">
                        <div class="card-header bg-primary text-white">
                            <h6 class="mb-0"><i class="fas fa-eye mr-2"></i> Vista del Perfil</h6>
                        </div>
                        <div class="card-body">
                            <p class="small mb-2"><strong>En tu perfil verás:</strong></p>
                            <div class="row">
                                <div class="col-md-6">
                                    <ul class="small mb-0">
                                        <li>Foto de perfil (si la has configurado)</li>
                                        <li>Nombre completo</li>
                                        <li>Cédula de identidad</li>
                                        <li>Email de acceso</li>
                                    </ul>
                                </div>
                                <div class="col-md-6">
                                    <ul class="small mb-0">
                                        <li>Número de teléfono</li>
                                        <li>Fecha de nacimiento</li>
                                        <li>Roles asignados</li>
                                        <li>Fecha de registro</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Editar Información -->
            <div class="card" id="editar">
                <div class="card-header bg-warning">
                    <h3 class="card-title text-white"><i class="fas fa-edit mr-2"></i> 3. Editar tu Información</h3>
                </div>
                <div class="card-body">
                    <h5>Campos que Puedes Editar:</h5>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="card border-success">
                                <div class="card-header bg-success text-white">
                                    <h6 class="mb-0"><i class="fas fa-check-circle mr-2"></i> Editables</h6>
                                </div>
                                <div class="card-body">
                                    <ul class="small mb-0">
                                        <li><strong>Nombre:</strong> Puedes corregir tu nombre</li>
                                        <li><strong>Teléfono:</strong> Actualiza tu número de contacto</li>
                                        <li><strong>Dirección:</strong> Modifica tu dirección</li>
                                        <li><strong>Foto de Perfil:</strong> Sube una imagen</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="card border-danger">
                                <div class="card-header bg-danger text-white">
                                    <h6 class="mb-0"><i class="fas fa-lock mr-2"></i> No Editables</h6>
                                </div>
                                <div class="card-body">
                                    <ul class="small mb-0">
                                        <li><strong>Cédula:</strong> Solo administradores</li>
                                        <li><strong>Email:</strong> Solo administradores</li>
                                        <li><strong>Roles:</strong> Solo administradores</li>
                                        <li><strong>Fecha de Registro:</strong> Automático</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>

                    <h5 class="mt-4">Proceso de Edición:</h5>
                    <div class="timeline">
                        <div class="time-label">
                            <span class="bg-primary">Paso 1</span>
                        </div>
                        <div>
                            <i class="fas fa-edit bg-blue"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Modo Edición</h3>
                                <div class="timeline-body">
                                    <p>Haz clic en el botón <button class="btn btn-warning btn-sm"><i class="fas fa-edit mr-1"></i> Editar Perfil</button></p>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-success">Paso 2</span>
                        </div>
                        <div>
                            <i class="fas fa-keyboard bg-green"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Modificar Datos</h3>
                                <div class="timeline-body">
                                    <p>Actualiza los campos que necesites cambiar. Los campos bloqueados aparecerán deshabilitados.</p>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-info">Paso 3</span>
                        </div>
                        <div>
                            <i class="fas fa-save bg-cyan"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Guardar Cambios</h3>
                                <div class="timeline-body">
                                    <p>Haz clic en <button class="btn btn-primary btn-sm"><i class="fas fa-save mr-1"></i> Guardar Cambios</button> para aplicar las modificaciones.</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-info mt-3">
                        <h6><i class="fas fa-info-circle mr-2"></i> Actualización de Teléfono</h6>
                        <p class="small mb-0">Es muy importante mantener tu número de teléfono actualizado para recibir recordatorios de citas por WhatsApp. Asegúrate de incluir el código de área.</p>
                    </div>
                </div>
            </div>

            <!-- Seguridad -->
            <div class="card" id="seguridad">
                <div class="card-header bg-danger">
                    <h3 class="card-title text-white"><i class="fas fa-shield-alt mr-2"></i> 4. Seguridad y Contraseña</h3>
                </div>
                <div class="card-body">
                    <h5>Cambiar tu Contraseña:</h5>
                    
                    <div class="card border-warning">
                        <div class="card-header bg-warning text-white">
                            <h6 class="mb-0"><i class="fas fa-key mr-2"></i> Proceso de Cambio de Contraseña</h6>
                        </div>
                        <div class="card-body">
                            <ol class="small">
                                <li>En tu perfil, busca la sección <strong>"Cambiar Contraseña"</strong></li>
                                <li>Ingresa tu <strong>contraseña actual</strong></li>
                                <li>Ingresa tu <strong>nueva contraseña</strong> (mínimo 8 caracteres)</li>
                                <li>Confirma la nueva contraseña</li>
                                <li>Haz clic en <button class="btn btn-primary btn-sm"><i class="fas fa-save mr-1"></i> Actualizar Contraseña</button></li>
                            </ol>
                        </div>
                    </div>

                    <h5 class="mt-4"><i class="fas fa-lock mr-2"></i> Requisitos de Contraseña Segura:</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card border-success">
                                <div class="card-header bg-success text-white">
                                    <h6 class="mb-0"><i class="fas fa-check mr-2"></i> Buenas Prácticas</h6>
                                </div>
                                <div class="card-body">
                                    <ul class="small mb-0">
                                        <li>Mínimo 8 caracteres</li>
                                        <li>Combina letras mayúsculas y minúsculas</li>
                                        <li>Incluye números</li>
                                        <li>Usa caracteres especiales (@, #, $, etc.)</li>
                                        <li>No uses información personal obvia</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="card border-danger">
                                <div class="card-header bg-danger text-white">
                                    <h6 class="mb-0"><i class="fas fa-times mr-2"></i> Evita</h6>
                                </div>
                                <div class="card-body">
                                    <ul class="small mb-0">
                                        <li>Tu nombre o cédula</li>
                                        <li>Fechas de nacimiento</li>
                                        <li>Contraseñas muy simples (123456, password)</li>
                                        <li>Palabras del diccionario</li>
                                        <li>Reutilizar contraseñas de otros sitios</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>

                    <h5 class="mt-4"><i class="fas fa-user-lock mr-2"></i> Consejos de Seguridad:</h5>
                    <div class="alert alert-warning">
                        <ul class="small mb-0">
                            <li><strong>No compartas tu contraseña</strong> con nadie, ni siquiera con personal de la clínica</li>
                            <li><strong>Cambia tu contraseña regularmente</strong> (cada 3-6 meses)</li>
                            <li><strong>Cierra sesión</strong> cuando uses computadoras compartidas</li>
                            <li><strong>No guardes tu contraseña</strong> en navegadores públicos</li>
                            <li><strong>Notifica inmediatamente</strong> si sospechas que tu cuenta fue comprometida</li>
                        </ul>
                    </div>

                    <h5 class="mt-4"><i class="fas fa-question-circle mr-2"></i> ¿Olvidaste tu Contraseña?</h5>
                    <div class="card border-info">
                        <div class="card-body">
                            <p class="small mb-2"><strong>Si olvidaste tu contraseña:</strong></p>
                            <ol class="small mb-0">
                                <li>En la página de inicio de sesión, haz clic en <strong>"¿Olvidaste tu contraseña?"</strong></li>
                                <li>Ingresa tu email registrado</li>
                                <li>Recibirás un enlace para restablecer tu contraseña</li>
                                <li>Sigue las instrucciones del correo</li>
                                <li>Crea una nueva contraseña segura</li>
                            </ol>
                            <div class="alert alert-info small mt-2 mb-0">
                                <i class="fas fa-info-circle mr-1"></i>
                                Si no recibes el correo, verifica tu carpeta de spam o contacta al administrador.
                            </div>
                        </div>
                    </div>

                    <div class="callout callout-info mt-3">
                        <h6><i class="fas fa-shield-alt mr-2"></i> Protege tu Cuenta</h6>
                        <p class="small mb-0">Tu cuenta contiene información médica sensible. Mantén tu contraseña segura y actualizada para proteger tu privacidad y la de tus datos médicos.</p>
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
    
    .callout-info {
        border-left-color: #17a2b8;
        background-color: #f0f9ff;
    }
    
    html {
        scroll-behavior: smooth;
    }
</style>
@endpush
