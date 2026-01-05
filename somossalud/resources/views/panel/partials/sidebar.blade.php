<nav class="mt-2">
    <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
        <!-- INICIO -->
        <li class="nav-item">
            <a href="{{ route('panel.clinica') }}"
                class="nav-link {{ request()->routeIs('panel.clinica') ? 'active' : '' }}">
                <i class="nav-icon fas fa-home"></i>
                <p>Inicio</p>
            </a>
        </li>
        <!-- SECCIÓN CLÍNICA -->
        @hasanyrole('especialista|recepcionista')
        <li class="nav-header">CLÍNICA</li>
        @hasanyrole('recepcionista')
        <li class="nav-item">
            <a href="{{ route('recepcion.pagos.index') }}"
                class="nav-link {{ request()->routeIs('recepcion.pagos.*') ? 'active' : '' }}">
                <i class="nav-icon fas fa-money-check-alt"></i>
                <p>Validar pagos</p>
            </a>
        </li>
        <li class="nav-item">
            <a href="{{ route('atenciones.index') }}"
                class="nav-link {{ request()->routeIs('atenciones.*') ? 'active' : '' }}">
                <i class="nav-icon fas fa-briefcase-medical"></i>
                <p>Atenciones</p>
            </a>
        </li>
        @endhasanyrole
        @role('especialista')
        <li class="nav-item"></li>
        <a href="{{ route('citas.index') }}" class="nav-link {{ request()->routeIs('citas.*') ? 'active' : '' }}">
            <i class="nav-icon fas fa-notes-medical"></i>
            <p>Mis citas</p>
        </a>
        </li>
        <li class="nav-item">
            <a href="{{ route('atenciones.index') }}"
                class="nav-link {{ request()->routeIs('atenciones.*') ? 'active' : '' }}">
                <i class="nav-icon fas fa-ambulance"></i>
                <p>Mis atenciones</p>
            </a>
        </li>
        <li class="nav-item">
            <a href="{{ route('especialista.horarios.index') }}"
                class="nav-link {{ request()->routeIs('especialista.horarios.*') ? 'active' : '' }}">
                <i class="nav-icon fas fa-calendar-check"></i>
                <p>Mis horarios</p>
            </a>
        </li>
        @endrole
        @endhasanyrole
        <!-- SECCIÓN LABORATORIO -->
        @hasanyrole('laboratorio|laboratorio-resul|recepcionista')
        <li class="nav-header">LABORATORIO</li>
        <!-- Sistema de Órdenes (Nuevo) -->
        <li class="nav-item">
            <a href="{{ route('lab.orders.index') }}"
                class="nav-link {{ request()->routeIs('lab.orders.*') ? 'active' : '' }}">
                <i class="nav-icon fas fa-file-medical"></i>
                <p>
                    @hasanyrole('laboratorio|recepcionista')
                        Exámenes
                    @else
                        Resultados Pendientes
                    @endhasanyrole
                </p>
            </a>
        </li>
        @hasanyrole('laboratorio|laboratorio-resul|admin_clinica|super-admin')
        <li class="nav-item">
            <a href="{{ route('lab.management.index') }}"
                class="nav-link {{ request()->routeIs('lab.management.*') ? 'active' : '' }}">
                <i class="nav-icon fas fa-vials"></i>
                <p>Gestión</p>
            </a>
        </li>
        @endhasanyrole
        @endhasanyrole
        <!-- SECCIÓN INVENTARIO -->
        @hasanyrole('almacen|almacen-jefe')
        <li class="nav-header">INVENTARIO</li>
            <a href="{{ route('inventario.solicitudes.index') }}"
                class="nav-link {{ request()->routeIs('inventario.solicitudes.index') || request()->routeIs('inventario.solicitudes.show') || request()->routeIs('inventario.solicitudes.edit') ? 'active' : '' }}">
                <i class="nav-icon fas fa-boxes"></i>
                <p>Solicitudes</p>
            </a>
        </li>
        @hasanyrole('almacen-jefe')
        <li class="nav-item">
            <a href="{{ route('inventario.ingresos.index') }}"
                class="nav-link {{ request()->routeIs('inventario.ingresos.*') ? 'active' : '' }}">
                <i class="nav-icon fas fa-dolly"></i>
                <p>Ingresos</p>
            </a>
        </li>
        <li class="nav-item">
            <a href="{{ route('inventario.materiales.index') }}"
                class="nav-link {{ request()->routeIs('inventario.materiales.*') ? 'active' : '' }}">
                <i class="nav-icon fas fa-cubes"></i>
                <p>Gestión de Materiales</p>
            </a>
        </li>
        @endhasanyrole

        @endhasanyrole
        <!-- SECCIÓN CONFIGURACIÓN -->
        @hasanyrole('super-admin|admin_clinica')
        <li class="nav-header">CONFIGURACIÓN</li>
        <li class="nav-item">
            <a href="{{ route('admin.users.index') }}"
                class="nav-link {{ request()->routeIs('admin.users.*') ? 'active' : '' }}">
                <i class="nav-icon fas fa-users-cog"></i>
                <p>Gestión de usuarios</p>
            </a>
        </li>
        <li class="nav-item">
            <a href="{{ route('admin.settings.pagos') }}"
                class="nav-link {{ request()->routeIs('admin.settings.*') ? 'active' : '' }}">
                <i class="nav-icon fas fa-cogs"></i>
                <p>Ajustes Generales</p>
            </a>
        </li>
        @role('super-admin')
        <li class="nav-item">
            <a href="{{ route('admin.settings.cache.clear') }}" class="nav-link text-warning" id="btn-limpiar-cache">
                <i class="nav-icon fas fa-broom"></i>
                <p>Limpiar Caché</p>
            </a>
        </li>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                document.getElementById('btn-limpiar-cache').addEventListener('click', function (e) {
                    e.preventDefault();
                    const url = this.href;
                    Swal.fire({
                        title: '¿Limpiar caché del sistema?',
                        text: "Esto puede afectar el rendimiento temporalmente mientras se reconstruye.",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#f59e0b',
                        cancelButtonColor: '#6b7280',
                        confirmButtonText: 'Sí, limpiar',
                        cancelButtonText: 'Cancelar'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            window.location.href = url;
                        }
                    });
                });
            });
        </script>
        @endrole
        @endhasanyrole
        
        <!-- CENTRO DE AYUDA -->
        <li class="nav-header">AYUDA</li>
        <li class="nav-item">
            <a href="{{ route('help.index') }}"
                class="nav-link {{ request()->routeIs('help.*') ? 'active' : '' }}">
                <i class="nav-icon fas fa-question-circle text-info"></i>
                <p>Centro de Ayuda</p>
            </a>
        </li>
    </ul>
</nav>