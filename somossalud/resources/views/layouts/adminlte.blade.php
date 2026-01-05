<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title', 'SomosSalud | Panel administrativo')</title>

    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css2?family=Source+Sans+Pro:wght@300;400;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
        integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA=="
        crossorigin="anonymous" referrerpolicy="no-referrer">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css"
        crossorigin="anonymous">
    {{-- Select2 --}}
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/@ttskch/select2-bootstrap4-theme@x.x.x/dist/select2-bootstrap4.min.css">
    <link rel="icon" type="image/png" href="{{ asset('images/logo.png') }}">

    <style>
        /* Separación superior del contenido cuando no hay content-header */
        .content-wrapper>.content {
            padding-top: .75rem;
            padding-bottom: env(safe-area-inset-bottom);
        }

        @media (min-width: 768px) {
            .content-wrapper>.content {
                padding-top: 1rem;
            }
        }

        @media (max-width: 767.98px) {
            body {
                padding-top: env(safe-area-inset-top);
                padding-left: env(safe-area-inset-left);
                padding-right: env(safe-area-inset-right);
            }
            
            .content-wrapper>.content {
                padding-top: 1.5rem; /* Más espacio arriba en móvil */
                padding-bottom: 2rem; 
            }

            .main-footer {
                padding-bottom: 5rem; /* Levantar el contenido del footer por encima de botones de navegación */
            }
        }

        /* Navbar Premium */
        .main-header {
            border-bottom: none !important;
            box-shadow: 0 4px 20px rgba(0, 86, 179, 0.25);
            background: linear-gradient(135deg, #0056b3 0%, #28a745 100%) !important;
            color: white !important;
        }

        .main-header .nav-link {
            color: rgba(255, 255, 255, 0.9) !important;
            font-weight: 500;
        }

        .main-header .nav-link:hover {
            color: #ffffff !important;
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
        }

        /* Sidebar Premium */
        .main-sidebar {
            background: #0f172a !important;
            /* Slate 900 */
            box-shadow: 4px 0 24px rgba(0, 0, 0, 0.05);
            border-right: none;
        }

        .brand-link {
            border-bottom: 1px solid rgba(255, 255, 255, 0.05) !important;
            background: #0f172a !important;
        }

        .nav-sidebar .nav-item {
            margin-bottom: 4px;
        }

        .nav-sidebar .nav-link {
            border-radius: 8px !important;
            color: #94a3b8 !important;
            padding: 0.75rem 1rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .nav-sidebar .nav-link:hover {
            background-color: rgba(255, 255, 255, 0.05) !important;
            color: #fff !important;
        }

        .nav-sidebar .nav-item>.nav-link.active {
            background: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%) !important;
            color: #fff !important;
            box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);
            font-weight: 600;
        }

        .nav-sidebar .nav-icon {
            font-size: 1.1rem;
            margin-right: 0.5rem;
            width: 1.5rem;
            text-align: center;
        }
    </style>

    @stack('styles')
</head>

<body class="hold-transition sidebar-mini layout-fixed">
    <div class="wrapper">
        <!-- Navbar -->
        <nav class="main-header navbar navbar-expand navbar-white navbar-light">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" data-widget="pushmenu" href="#" role="button"><i class="fas fa-bars"></i></a>
                </li>
                @role('paciente')
                <li class="nav-item d-none d-sm-inline-block">
                    <a href="{{ route('panel.pacientes') }}" class="nav-link">Paciente</a>
                </li>
                @endrole
            </ul>

            <ul class="navbar-nav ml-auto">
                <li class="nav-item dropdown">
                    <a class="nav-link" data-toggle="dropdown" href="#" aria-expanded="false">
                        <i class="far fa-user"></i>
                        <span class="ml-2">{{ auth()->user()->name ?? 'Usuario' }}</span>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right">
                        <a href="{{ route('profile.edit', ['context' => 'clinica']) }}" class="dropdown-item">
                            <i class="fas fa-user-cog mr-2"></i> Perfil
                        </a>
                        <div class="dropdown-divider"></div>
                        <form action="{{ route('logout') }}" method="POST" class="d-inline">
                            @csrf
                            <button type="submit" class="dropdown-item text-danger">
                                <i class="fas fa-sign-out-alt mr-2"></i> Cerrar sesión
                            </button>
                        </form>
                    </div>
                </li>
            </ul>
        </nav>
        <!-- /.navbar -->

        <!-- Main Sidebar Container -->
        <aside class="main-sidebar sidebar-dark-primary elevation-4">
            <a href="{{ route('panel.clinica') }}" class="brand-link d-flex align-items-center justify-content-center"
                style="min-height:58px;">
                <img src="{{ asset('images/logo.png') }}" alt="SomosSalud" class="brand-image"
                    style="max-height:38px; width:auto; object-fit:contain; opacity:1;">
            </a>

            <div class="sidebar">
                @hasSection('sidebar')
                    @yield('sidebar')
                @else
                    @include('panel.partials.sidebar')
                @endif
            </div>
        </aside>

        <!-- Content Wrapper. Contains page content -->
        <div class="content-wrapper">
            @hasSection('content-header')
                <div class="content-header">
                    <div class="container-fluid">
                        @yield('content-header')
                    </div>
                </div>
            @endif

            <section class="content">
                <div class="container-fluid">
                    @yield('content')
                </div>
            </section>
        </div>

        @php
            $__rateAdmin = optional(\App\Models\ExchangeRate::latestEffective()->first());
        @endphp
        <footer class="main-footer text-sm d-flex justify-content-between align-items-center flex-wrap bg-light py-2">
            <div>
                <strong>© {{ date('Y') }} SomosSalud.</strong>
                <span class="d-none d-sm-inline-block text-muted"> Gestión interna.</span>
            </div>
            <div class="my-0">
                @if($__rateAdmin && $__rateAdmin->rate)
                    <span class="px-3 py-1 rounded-pill bg-white shadow-sm border d-inline-flex align-items-center">
                        <i class="fas fa-coins text-success mr-2"></i>
                        <span class="font-weight-bold text-dark" style="font-size: 1.1em;">
                            Tasa BCV: {{ number_format((float) $__rateAdmin->rate, 2, ',', '.') }} Bs
                        </span>
                        <span class="text-muted ml-2 small border-left pl-2">
                            {{ $__rateAdmin->date?->format('d/m/Y') }}
                        </span>
                    </span>
                @else
                    <span class="text-muted font-italic">Tasa no disponible</span>
                @endif
            </div>
            <div class="float-right d-none d-sm-inline text-muted">Versión 1.0.0</div>
        </footer>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"
        crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/js/adminlte.min.js" crossorigin="anonymous"></script>
    {{-- Select2 --}}
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    {{-- SweetAlert2 --}}
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    {{-- Configuración global CSRF para AJAX --}}
    <script>
        $.ajaxSetup({
            headers: {
                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
            }
        });

        // Mostrar mensajes flash de sesión con SweetAlert2
        @if(session('success'))
            Swal.fire({
                icon: 'success',
                title: '¡Éxito!',
                text: '{{ session('success') }}',
                timer: 3000,
                showConfirmButton: false,
                toast: true,
                position: 'bottom-end'
            });
        @endif

        @if(session('error'))
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: '{{ session('error') }}',
                confirmButtonText: 'Aceptar'
            });
        @endif

        @if(session('warning'))
            Swal.fire({
                icon: 'warning',
                title: 'Advertencia',
                text: '{{ session('warning') }}',
                confirmButtonText: 'Aceptar'
            });
        @endif

        @if(session('info'))
            Swal.fire({
                icon: 'info',
                title: 'Información',
                text: '{{ session('info') }}',
                timer: 3000,
                showConfirmButton: false,
                toast: true,
                position: 'bottom-end'
            });
        @endif
    </script>

    @stack('scripts')
</body>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        if (window.$ && $.fn.select2) {
            $('.select2').select2({ width: '100%' });
        }
    });
</script>
</body>

</html>