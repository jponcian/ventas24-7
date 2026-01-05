@extends('layouts.adminlte')

@section('title', 'Registro de Ingresos - Ayuda')

@section('content_header')
    <h1><i class="fas fa-truck-loading mr-2"></i> Registro de Ingresos de Inventario</h1>
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
                        <a href="#registrar" class="list-group-item list-group-item-action">2. Registrar Ingreso</a>
                        <a href="#consultar" class="list-group-item list-group-item-action">3. Consultar Ingresos</a>
                        <a href="#buenas-practicas" class="list-group-item list-group-item-action">4. Buenas Prácticas</a>
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
                    <p class="lead">El módulo de <strong>Registro de Ingresos</strong> permite registrar las entradas de materiales al inventario, ya sea por compras, donaciones o ajustes de stock.</p>
                    
                    <div class="alert alert-info">
                        <i class="fas fa-lightbulb mr-2"></i>
                        <strong>¿Qué es un ingreso de inventario?</strong><br>
                        Es el registro de entrada de materiales al almacén que incrementa el stock disponible. Cada ingreso debe documentarse para mantener un control preciso del inventario.
                    </div>

                    <h5 class="mt-4"><i class="fas fa-user-tag mr-2"></i> ¿Quién puede registrar ingresos?</h5>
                    <ul>
                        <li><strong>Jefe de Almacén:</strong> Registrar y gestionar todos los ingresos</li>
                        <li><strong>Admin Clínica:</strong> Acceso completo al módulo</li>
                        <li><strong>Otros usuarios:</strong> Solo pueden consultar el historial</li>
                    </ul>

                    <h5 class="mt-4"><i class="fas fa-clipboard-list mr-2"></i> Tipos de Ingreso</h5>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="card bg-success text-white">
                                <div class="card-body text-center">
                                    <h4><i class="fas fa-shopping-cart"></i></h4>
                                    <h6>Compra</h6>
                                    <p class="small mb-0">Materiales adquiridos a proveedores</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card bg-info text-white">
                                <div class="card-body text-center">
                                    <h4><i class="fas fa-gift"></i></h4>
                                    <h6>Donación</h6>
                                    <p class="small mb-0">Materiales recibidos sin costo</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card bg-warning text-white">
                                <div class="card-body text-center">
                                    <h4><i class="fas fa-wrench"></i></h4>
                                    <h6>Ajuste</h6>
                                    <p class="small mb-0">Correcciones de inventario</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <h5 class="mt-4"><i class="fas fa-database mr-2"></i> Información de un Ingreso</h5>
                    <table class="table table-bordered">
                        <thead class="bg-light">
                            <tr>
                                <th>Campo</th>
                                <th>Descripción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>Fecha de Ingreso</strong></td>
                                <td>Fecha en que se recibieron los materiales</td>
                            </tr>
                            <tr>
                                <td><strong>Tipo</strong></td>
                                <td>Compra, Donación o Ajuste</td>
                            </tr>
                            <tr>
                                <td><strong>Proveedor</strong></td>
                                <td>Nombre del proveedor (opcional para donaciones y ajustes)</td>
                            </tr>
                            <tr>
                                <td><strong>Número de Factura</strong></td>
                                <td>Referencia de la factura o documento (opcional)</td>
                            </tr>
                            <tr>
                                <td><strong>Materiales</strong></td>
                                <td>Lista de materiales ingresados con sus cantidades</td>
                            </tr>
                            <tr>
                                <td><strong>Observaciones</strong></td>
                                <td>Notas adicionales sobre el ingreso</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Registrar -->
            <div class="card" id="registrar">
                <div class="card-header bg-success">
                    <h3 class="card-title text-white"><i class="fas fa-plus-circle mr-2"></i> 2. Registrar un Ingreso</h3>
                </div>
                <div class="card-body">
                    <h5>Proceso de Registro:</h5>
                    
                    <div class="timeline">
                        <div class="time-label">
                            <span class="bg-primary">Paso 1</span>
                        </div>
                        <div>
                            <i class="fas fa-plus-circle bg-blue"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Acceder al Formulario</h3>
                                <div class="timeline-body">
                                    <p>Desde el menú lateral, ve a <strong>Inventario → Ingresos</strong> y haz clic en <button class="btn btn-success btn-sm"><i class="fas fa-plus-circle mr-1"></i> Registrar Ingreso</button></p>
                                </div>
                            </div>
                        </div>

                        <div class="time-label">
                            <span class="bg-success">Paso 2</span>
                        </div>
                        <div>
                            <i class="fas fa-calendar bg-green"></i>
                            <div class="timeline-item">
                                <h3 class="timeline-header">Datos del Ingreso</h3>
                                <div class="timeline-body">
                                    <p><strong>Completa la información general:</strong></p>
                                    <ul class="small">
                                        <li><strong>Fecha de Ingreso:</strong> Fecha en que se recibieron los materiales (por defecto: hoy)</li>
                                        <li><strong>Tipo de Ingreso:</strong> Selecciona Compra, Donación o Ajuste</li>
                                        <li><strong>Proveedor:</strong> Nombre del proveedor (opcional)</li>
                                        <li><strong>Número de Factura:</strong> Referencia del documento (opcional)</li>
                                        <li><strong>Observaciones:</strong> Notas adicionales (opcional)</li>
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
                                    <p><strong>Para cada material:</strong></p>
                                    <ol class="small">
                                        <li>Busca el material en el campo de búsqueda</li>
                                        <li>Selecciona el material de la lista desplegable</li>
                                        <li>Ingresa la <strong>cantidad recibida</strong></li>
                                        <li>Opcionalmente, ingresa el <strong>precio unitario</strong> y <strong>lote</strong></li>
                                        <li>Haz clic en <button class="btn btn-success btn-sm"><i class="fas fa-plus"></i></button> para agregarlo a la lista</li>
                                        <li>Repite para agregar más materiales</li>
                                    </ol>
                                    
                                    <div class="alert alert-info mt-2">
                                        <i class="fas fa-info-circle mr-2"></i>
                                        <strong>Tip:</strong> Puedes agregar múltiples materiales en un solo ingreso. Esto es útil cuando recibes una compra con varios artículos.
                                    </div>

                                    <div class="alert alert-warning mt-2">
                                        <i class="fas fa-exclamation-triangle mr-2"></i>
                                        <strong>Importante:</strong> Si el material no existe en el catálogo, primero debes crearlo en el módulo de <strong>Gestión de Materiales</strong>.
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
                                <h3 class="timeline-header">Guardar Ingreso</h3>
                                <div class="timeline-body">
                                    <p>Revisa la información y los materiales agregados, luego haz clic en <button class="btn btn-primary btn-sm"><i class="fas fa-save mr-1"></i> Guardar Ingreso</button></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-success mt-3">
                        <h6><i class="fas fa-check-circle mr-2"></i> Después de Guardar</h6>
                        <ul class="small mb-0">
                            <li>El stock de los materiales se incrementará automáticamente</li>
                            <li>El ingreso quedará registrado en el historial</li>
                            <li>Se generará un número de ingreso único para referencia</li>
                        </ul>
                    </div>

                    <h5 class="mt-4">Ejemplo Práctico:</h5>
                    <div class="card bg-light">
                        <div class="card-body">
                            <h6 class="text-primary"><i class="fas fa-shopping-cart mr-2"></i> Registro de Compra</h6>
                            <p class="small mb-2"><strong>Escenario:</strong> Recibiste una compra de materiales de enfermería.</p>
                            <table class="table table-sm table-bordered bg-white">
                                <thead>
                                    <tr>
                                        <th>Campo</th>
                                        <th>Valor</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Fecha</td>
                                        <td>08/12/2025</td>
                                    </tr>
                                    <tr>
                                        <td>Tipo</td>
                                        <td>Compra</td>
                                    </tr>
                                    <tr>
                                        <td>Proveedor</td>
                                        <td>Distribuidora Médica XYZ</td>
                                    </tr>
                                    <tr>
                                        <td>Factura</td>
                                        <td>FAC-2025-001234</td>
                                    </tr>
                                    <tr>
                                        <td>Materiales</td>
                                        <td>
                                            • Gasas estériles: 100 unidades<br>
                                            • Jeringas 5ml: 200 unidades<br>
                                            • Guantes talla M: 50 cajas
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Consultar -->
            <div class="card" id="consultar">
                <div class="card-header bg-info">
                    <h3 class="card-title text-white"><i class="fas fa-search mr-2"></i> 3. Consultar Historial de Ingresos</h3>
                </div>
                <div class="card-body">
                    <h5>Acceso al Historial:</h5>
                    <p>Desde el menú lateral, ve a <strong>Inventario → Ingresos</strong> para ver todos los ingresos registrados.</p>

                    <h5 class="mt-4"><i class="fas fa-filter mr-2"></i> Filtros Disponibles:</h5>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="card bg-light">
                                <div class="card-body">
                                    <h6><i class="fas fa-calendar mr-2"></i> Por Fecha</h6>
                                    <p class="small mb-0">Filtra ingresos por rango de fechas (desde - hasta)</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card bg-light">
                                <div class="card-body">
                                    <h6><i class="fas fa-tag mr-2"></i> Por Tipo</h6>
                                    <p class="small mb-0">Filtra por tipo de ingreso: Compra, Donación o Ajuste</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card bg-light">
                                <div class="card-body">
                                    <h6><i class="fas fa-truck mr-2"></i> Por Proveedor</h6>
                                    <p class="small mb-0">Busca ingresos de un proveedor específico</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <h5 class="mt-4">Información Visible en la Lista:</h5>
                    <table class="table table-bordered">
                        <thead class="bg-light">
                            <tr>
                                <th>Columna</th>
                                <th>Descripción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>Número</strong></td>
                                <td>Número único del ingreso (ej: ING-2025-001)</td>
                            </tr>
                            <tr>
                                <td><strong>Fecha</strong></td>
                                <td>Fecha en que se registró el ingreso</td>
                            </tr>
                            <tr>
                                <td><strong>Tipo</strong></td>
                                <td>Compra, Donación o Ajuste</td>
                            </tr>
                            <tr>
                                <td><strong>Proveedor</strong></td>
                                <td>Nombre del proveedor (si aplica)</td>
                            </tr>
                            <tr>
                                <td><strong>Items</strong></td>
                                <td>Cantidad de materiales diferentes en el ingreso</td>
                            </tr>
                            <tr>
                                <td><strong>Total</strong></td>
                                <td>Monto total del ingreso (si se registraron precios)</td>
                            </tr>
                            <tr>
                                <td><strong>Registrado por</strong></td>
                                <td>Usuario que registró el ingreso</td>
                            </tr>
                        </tbody>
                    </table>

                    <h5 class="mt-4">Ver Detalle de un Ingreso:</h5>
                    <p>Haz clic en el botón <button class="btn btn-info btn-sm"><i class="fas fa-eye"></i></button> para ver:</p>
                    <ul>
                        <li>Información completa del ingreso</li>
                        <li>Lista detallada de todos los materiales</li>
                        <li>Cantidades y precios (si aplica)</li>
                        <li>Observaciones registradas</li>
                        <li>Fecha y usuario que lo registró</li>
                    </ul>
                </div>
            </div>

            <!-- Buenas Prácticas -->
            <div class="card" id="buenas-practicas">
                <div class="card-header bg-warning">
                    <h3 class="card-title text-white"><i class="fas fa-star mr-2"></i> 4. Buenas Prácticas</h3>
                </div>
                <div class="card-body">
                    <h5><i class="fas fa-check-circle mr-2 text-success"></i> Recomendaciones:</h5>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card border-success">
                                <div class="card-header bg-success text-white">
                                    <h6 class="mb-0"><i class="fas fa-calendar-check mr-2"></i> Registro Oportuno</h6>
                                </div>
                                <div class="card-body">
                                    <ul class="small mb-0">
                                        <li>Registra los ingresos el mismo día que se reciben</li>
                                        <li>No acumules varios días de ingresos sin registrar</li>
                                        <li>Mantén actualizada la fecha de ingreso</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="card border-info">
                                <div class="card-header bg-info text-white">
                                    <h6 class="mb-0"><i class="fas fa-file-invoice mr-2"></i> Documentación</h6>
                                </div>
                                <div class="card-body">
                                    <ul class="small mb-0">
                                        <li>Siempre registra el número de factura o documento</li>
                                        <li>Incluye el nombre del proveedor en compras</li>
                                        <li>Agrega observaciones relevantes</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="card border-warning">
                                <div class="card-header bg-warning text-white">
                                    <h6 class="mb-0"><i class="fas fa-boxes mr-2"></i> Verificación</h6>
                                </div>
                                <div class="card-body">
                                    <ul class="small mb-0">
                                        <li>Verifica físicamente las cantidades antes de registrar</li>
                                        <li>Revisa que los materiales coincidan con la factura</li>
                                        <li>Confirma el estado de los materiales recibidos</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="card border-primary">
                                <div class="card-header bg-primary text-white">
                                    <h6 class="mb-0"><i class="fas fa-database mr-2"></i> Organización</h6>
                                </div>
                                <div class="card-body">
                                    <ul class="small mb-0">
                                        <li>Agrupa materiales del mismo proveedor en un solo ingreso</li>
                                        <li>Usa el campo de observaciones para notas importantes</li>
                                        <li>Mantén un archivo físico de facturas ordenado</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>

                    <h5 class="mt-4"><i class="fas fa-times-circle mr-2 text-danger"></i> Errores Comunes a Evitar:</h5>
                    
                    <div class="alert alert-danger">
                        <h6><i class="fas fa-exclamation-triangle mr-2"></i> No hacer esto:</h6>
                        <ul class="small mb-0">
                            <li><strong>Registrar cantidades incorrectas:</strong> Siempre verifica físicamente antes de registrar</li>
                            <li><strong>Olvidar la documentación:</strong> Sin factura o referencia es difícil rastrear el ingreso</li>
                            <li><strong>Usar fechas incorrectas:</strong> La fecha debe ser cuando realmente se recibieron los materiales</li>
                            <li><strong>No revisar antes de guardar:</strong> Una vez guardado, no se puede editar (solo anular)</li>
                            <li><strong>Crear materiales duplicados:</strong> Verifica que el material no exista antes de crear uno nuevo</li>
                        </ul>
                    </div>

                    <h5 class="mt-4"><i class="fas fa-lightbulb mr-2 text-warning"></i> Consejos Adicionales:</h5>
                    
                    <div class="callout callout-info">
                        <h6><i class="fas fa-info-circle mr-2"></i> Control de Lotes</h6>
                        <p class="small mb-0">Si trabajas con medicamentos o materiales con fecha de vencimiento, es importante registrar el número de lote. Esto te permitirá hacer seguimiento en caso de retiros o problemas de calidad.</p>
                    </div>

                    <div class="callout callout-info">
                        <h6><i class="fas fa-dollar-sign mr-2"></i> Registro de Precios</h6>
                        <p class="small mb-0">Aunque el precio es opcional, registrarlo te ayudará a llevar un control de costos y generar reportes financieros del inventario.</p>
                    </div>

                    <div class="callout callout-info">
                        <h6><i class="fas fa-sync-alt mr-2"></i> Ajustes de Inventario</h6>
                        <p class="small mb-0">Usa el tipo "Ajuste" solo para correcciones de inventario después de un conteo físico. No lo uses para ingresos regulares de compras o donaciones.</p>
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
