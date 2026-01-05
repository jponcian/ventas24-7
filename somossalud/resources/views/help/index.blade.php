@extends('layouts.adminlte')

@section('title', 'Centro de Ayuda')

@section('content_header')
    <h1><i class="fas fa-question-circle mr-2"></i> Centro de Ayuda</h1>
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
                        <a href="{{ route('help.index') }}" class="list-group-item list-group-item-action {{ !request()->segment(2) ? 'active' : '' }}">
                            <i class="fas fa-home mr-2"></i> Inicio
                        </a>
                        
                        <div class="list-group-item bg-light font-weight-bold text-uppercase small">
                            <i class="fas fa-ambulance mr-2"></i> Atenciones
                        </div>
                        <a href="{{ route('help.show', 'validar-pagos') }}" class="list-group-item list-group-item-action {{ request()->segment(2) == 'validar-pagos' ? 'active' : '' }}">
                            <i class="fas fa-file-invoice-dollar mr-2"></i> Validar Pagos
                        </a>
                        <a href="{{ route('help.show', 'gestion-atenciones') }}" class="list-group-item list-group-item-action {{ request()->segment(2) == 'gestion-atenciones' ? 'active' : '' }}">
                            <i class="fas fa-clipboard-list mr-2"></i> Gestión de Atenciones
                        </a>
                        
                        <div class="list-group-item bg-light font-weight-bold text-uppercase small">
                            <i class="fas fa-flask mr-2"></i> Laboratorio
                        </div>
                        <a href="{{ route('help.show', 'ordenes-laboratorio') }}" class="list-group-item list-group-item-action {{ request()->segment(2) == 'ordenes-laboratorio' ? 'active' : '' }}">
                            <i class="fas fa-file-medical mr-2"></i> Órdenes
                        </a>
                        <a href="{{ route('help.show', 'cargar-resultados') }}" class="list-group-item list-group-item-action {{ request()->segment(2) == 'cargar-resultados' ? 'active' : '' }}">
                            <i class="fas fa-edit mr-2"></i> Cargar Resultados
                        </a>
                        <a href="{{ route('help.show', 'gestion-laboratorio') }}" class="list-group-item list-group-item-action {{ request()->segment(2) == 'gestion-laboratorio' ? 'active' : '' }}">
                            <i class="fas fa-vials mr-2"></i> Gestión
                        </a>
                        
                        <div class="list-group-item bg-light font-weight-bold text-uppercase small">
                            <i class="fas fa-boxes mr-2"></i> Inventario
                        </div>
                        <a href="{{ route('help.show', 'gestion-solicitudes') }}" class="list-group-item list-group-item-action {{ request()->segment(2) == 'gestion-solicitudes' ? 'active' : '' }}">
                            <i class="fas fa-clipboard-list mr-2"></i> Solicitudes
                        </a>
                        <a href="{{ route('help.show', 'gestion-materiales') }}" class="list-group-item list-group-item-action {{ request()->segment(2) == 'gestion-materiales' ? 'active' : '' }}">
                            <i class="fas fa-box mr-2"></i> Materiales
                        </a>
                        <a href="{{ route('help.show', 'registro-ingresos') }}" class="list-group-item list-group-item-action {{ request()->segment(2) == 'registro-ingresos' ? 'active' : '' }}">
                            <i class="fas fa-truck-loading mr-2"></i> Ingresos
                        </a>
                        
                        <div class="list-group-item bg-light font-weight-bold text-uppercase small">
                            <i class="fas fa-cog mr-2"></i> Sistema
                        </div>
                        <a href="{{ route('help.show', 'gestion-usuarios') }}" class="list-group-item list-group-item-action {{ request()->segment(2) == 'gestion-usuarios' ? 'active' : '' }}">
                            <i class="fas fa-users-cog mr-2"></i> Gestión de Usuarios
                        </a>
                        <a href="{{ route('help.show', 'perfil-usuario') }}" class="list-group-item list-group-item-action {{ request()->segment(2) == 'perfil-usuario' ? 'active' : '' }}">
                            <i class="fas fa-user-circle mr-2"></i> Perfil de Usuario
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Content -->
        <div class="col-md-10">
            <div class="card">
                <div class="card-body">
                    <div class="text-center py-5">
                        <i class="fas fa-book-open fa-5x text-primary mb-4"></i>
                        <h2 class="mb-3">Bienvenido al Centro de Ayuda</h2>
                        <p class="lead text-muted">Selecciona una sección del menú lateral para comenzar</p>
                        
                        <div class="row mt-5 justify-content-center">
                            <div class="col-md-2">
                                <div class="info-box bg-gradient-warning">
                                    <span class="info-box-icon"><i class="fas fa-ambulance"></i></span>
                                    <div class="info-box-content">
                                        <span class="info-box-text">Atenciones</span>
                                        <span class="info-box-number">2 Guías</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="info-box bg-gradient-info">
                                    <span class="info-box-icon"><i class="fas fa-flask"></i></span>
                                    <div class="info-box-content">
                                        <span class="info-box-text">Laboratorio</span>
                                        <span class="info-box-number">3 Guías</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="info-box bg-gradient-purple">
                                    <span class="info-box-icon"><i class="fas fa-boxes"></i></span>
                                    <div class="info-box-content">
                                        <span class="info-box-text">Inventario</span>
                                        <span class="info-box-number">3 Guías</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="info-box bg-gradient-secondary">
                                    <span class="info-box-icon"><i class="fas fa-cog"></i></span>
                                    <div class="info-box-content">
                                        <span class="info-box-text">Sistema</span>
                                        <span class="info-box-number">2 Guías</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="info-box bg-gradient-success">
                                    <span class="info-box-icon"><i class="fas fa-question-circle"></i></span>
                                    <div class="info-box-content">
                                        <span class="info-box-text">Total</span>
                                        <span class="info-box-number">10 Guías</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="alert alert-info mt-4">
                            <i class="fas fa-info-circle mr-2"></i>
                            <strong>Tip:</strong> Cada módulo tiene ayuda contextual. Busca el botón <span class="badge badge-info"><i class="fas fa-question-circle"></i></span> en la esquina inferior derecha.
                        </div>
                    </div>
                </div>
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
    
    .list-group-item-action:hover {
        background-color: #f8f9fa;
    }
    
    .list-group-item.active {
        background-color: #007bff;
        border-color: #007bff;
    }
</style>
@endpush
