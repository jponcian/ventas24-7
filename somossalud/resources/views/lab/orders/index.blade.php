@extends('layouts.adminlte')

@section('title', 'Órdenes de Laboratorio')

@section('content')
<div class="row">
    <div class="col-12">
        <div class="card shadow-sm border-0 rounded-lg overflow-hidden">
            <div class="card-header border-0 d-flex align-items-center" style="background: linear-gradient(135deg, #dbeafe 0%, #dcfce7 100%); border-bottom: 1px solid #cbd5e1;">
                <h3 class="card-title font-weight-bold text-primary mb-0">
                    <i class="fas fa-flask mr-2"></i> Órdenes de Laboratorio
                </h3>
                <div class="ms-auto ml-auto">
                    <a href="{{ route('lab.orders.create') }}" 
                       class="btn text-white shadow-sm font-weight-bold" 
                       style="background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%); transition: all 0.3s ease;"
                       onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 12px rgba(14, 165, 233, 0.4)'"
                       onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow=''">
                        <i class="fas fa-plus-circle mr-2"></i> Nueva Orden
                    </a>
                </div>
            </div>

            @if(session('success'))
                <div class="alert alert-success alert-dismissible fade show mx-3 mt-3" role="alert">
                    <i class="fas fa-check-circle mr-2"></i> {{ session('success') }}
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
            @endif

            <div class="card-body p-0">
                <!-- Filtros -->
                <div class="p-3" style="background-color: #f8fafc; border-bottom: 1px solid #e2e8f0;">
                    <form action="{{ route('lab.orders.index') }}" method="GET">
                        <div class="row align-items-end">
                            <div class="col-md-3 col-sm-6 mb-2 mb-md-0">
                                <label class="small font-weight-bold text-muted mb-1">
                                    <i class="fas fa-calendar-alt mr-1"></i> Fecha
                                </label>
                                <div class="input-group input-group-sm shadow-sm">
                                    <input type="date" name="date" class="form-control border-0" 
                                           value="{{ $date ?? '' }}">
                                    @if($date)
                                        <div class="input-group-append">
                                            <a href="{{ route('lab.orders.index', array_merge(request()->except('date'), ['date' => ''])) }}" 
                                               class="btn btn-light bg-white text-muted border-left-0" 
                                               title="Ver todas las fechas">
                                                <i class="fas fa-times"></i>
                                            </a>
                                        </div>
                                    @endif
                                </div>
                            </div>
                            
                            <!-- Filtro Paciente -->
                            <div class="col-md-4 col-sm-6 mb-2 mb-md-0">
                                <label class="small font-weight-bold text-muted mb-1">
                                    <i class="fas fa-user mr-1"></i> Paciente
                                </label>
                                <div class="input-group input-group-sm shadow-sm">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text border-0 bg-white"><i class="fas fa-search text-muted"></i></span>
                                    </div>
                                    <input type="text" name="patient_search" class="form-control border-0" 
                                           placeholder="Buscar por nombre o cédula..." 
                                           value="{{ $patientSearch ?? '' }}">
                                </div>
                            </div>

                            <!-- Filtro Estado -->
                            <div class="col-md-3 col-sm-6 mb-2 mb-md-0">
                                <label class="small font-weight-bold text-muted mb-1">
                                    <i class="fas fa-tasks mr-1"></i> Estado
                                </label>
                                <select name="status" class="form-control form-control-sm shadow-sm border-0">
                                    <option value="all" {{ ($status ?? 'all') == 'all' ? 'selected' : '' }}>Todos los estados</option>
                                    <option value="pending" {{ ($status ?? '') == 'pending' ? 'selected' : '' }}>⚠️ Pendiente</option>
                                    <option value="completed" {{ ($status ?? '') == 'completed' ? 'selected' : '' }}>✅ Completado</option>
                                </select>
                            </div>

                            <!-- Botones -->
                            <div class="col-md-2 col-sm-6 d-flex">
                                <button type="submit" class="btn btn-primary btn-sm flex-grow-1 shadow-sm mr-2 font-weight-bold" 
                                        style="background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); border: none;">
                                    <i class="fas fa-filter mr-1"></i> Filtrar
                                </button>
                                <a href="{{ route('lab.orders.index') }}" class="btn btn-light btn-sm shadow-sm text-secondary" title="Limpiar Filtros">
                                    <i class="fas fa-undo"></i>
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
                @if($orders->count() > 0)
                    <div class="table-responsive mb-0">
                        <table class="table table-hover mb-0 align-middle">
                            <thead style="background-color: #f8fafc;">
                                <tr>
                                    <th class="border-top-0 text-uppercase text-secondary small font-weight-bold pl-4">Nº Orden</th>
                                    <th class="border-top-0 text-uppercase text-secondary small font-weight-bold">Nº Diario</th>
                                    <th class="border-top-0 text-uppercase text-secondary small font-weight-bold">Paciente</th>
                                    <th class="border-top-0 text-uppercase text-secondary small font-weight-bold">Exámenes</th>
                                    <th class="border-top-0 text-uppercase text-secondary small font-weight-bold">Fecha Orden</th>
                                    <th class="border-top-0 text-uppercase text-secondary small font-weight-bold">Fecha Resultado</th>
                                    <th class="border-top-0 text-uppercase text-secondary small font-weight-bold">Estado</th>
                                    <th class="border-top-0 text-uppercase text-secondary small font-weight-bold pr-4">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($orders as $order)
                                    <tr>
                                        <td class="pl-4">
                                            <code class="text-primary font-weight-bold">{{ $order->order_number }}</code>
                                        </td>
                                        <td>
                                            <span class="badge badge-success px-3 py-1 rounded-pill">{{ $order->daily_exam_count }}</span>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="rounded-circle bg-light d-flex align-items-center justify-content-center mr-2 text-primary font-weight-bold" style="width: 32px; height: 32px; font-size: 0.8rem;">
                                                    {{ substr($order->patient->name, 0, 1) }}
                                                </div>
                                                <div>
                                                    <div class="font-weight-bold text-dark">{{ $order->patient->name }}</div>
                                                    <small class="text-muted">{{ $order->patient->cedula }}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge badge-info px-3 py-1 rounded-pill">
                                                <i class="fas fa-vial mr-1"></i> {{ $order->details->count() }}
                                            </span>
                                        </td>
                                        <td>
                                            <i class="fas fa-calendar-alt text-primary mr-2"></i>
                                            <span class="small">{{ $order->order_date->format('d/m/Y') }}</span>
                                        </td>
                                        <td>
                                            @if($order->result_date)
                                                <i class="fas fa-calendar-check text-success mr-2"></i>
                                                <span class="small">{{ $order->result_date->format('d/m/Y') }}</span>
                                            @else
                                                <span class="text-muted small font-italic">Pendiente</span>
                                            @endif
                                        </td>
                                        <td>
                                            @php
                                                $badgeClass = match($order->status) {
                                                    'pending' => 'badge-warning',
                                                    'in_progress' => 'badge-info',
                                                    'completed' => 'badge-success',
                                                    default => 'badge-secondary'
                                                };
                                                $statusLabel = match($order->status) {
                                                    'pending' => 'Pendiente',
                                                    'in_progress' => 'En Proceso',
                                                    'completed' => 'Completado',
                                                    default => 'Cancelado'
                                                };
                                            @endphp
                                            <span class="badge {{ $badgeClass }} px-3 py-1 rounded-pill small">
                                                {{ $statusLabel }}
                                            </span>
                                        </td>
                                        <td class="text-right pr-4">
                                            <div class="btn-group" role="group">
                                                @if($order->isPending() || $order->isInProgress())
                                                    <a href="{{ route('lab.orders.load-results', $order->id) }}"
                                                        class="btn btn-light btn-sm rounded-circle shadow-sm text-primary mr-1" 
                                                        title="Cargar resultados">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                @endif

                                                <a href="{{ route('lab.orders.show', $order->id) }}" 
                                                   class="btn btn-light btn-sm rounded-circle shadow-sm text-info mr-1"
                                                   title="Ver detalle">
                                                    <i class="fas fa-eye"></i>
                                                </a>

                                                @if($order->isCompleted())
                                                    <a href="{{ route('lab.orders.pdf', $order->id) }}" 
                                                       class="btn btn-light btn-sm rounded-circle shadow-sm text-danger"
                                                       title="Descargar PDF">
                                                        <i class="fas fa-file-pdf"></i>
                                                    </a>
                                                @endif
                                            </div>
                                        </td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>

                    @if($orders->hasPages())
                    <div class="d-flex justify-content-center py-3 border-top">
                        {{ $orders->links() }}
                    </div>
                    @endif
                @else
                    <div class="text-center py-5">
                        <i class="fas fa-flask fa-3x mb-3 opacity-50" style="color: #cbd5e1;"></i>
                        <p class="mb-3 text-muted">No hay órdenes de laboratorio registradas.</p>
                        <a href="{{ route('lab.orders.create') }}" 
                           class="btn text-white shadow-sm font-weight-bold" 
                           style="background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%); transition: all 0.3s ease;"
                           onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 12px rgba(14, 165, 233, 0.4)'"
                           onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow=''">
                            <i class="fas fa-plus-circle mr-2"></i> Crear Primera Orden
                        </a>
                    </div>
                @endif
            </div>
        </div>
    </div>
</div>
@stop

@section('css')
<style>
    .table-hover tbody tr:hover {
        background-color: #f8fafc;
        transition: background-color 0.2s ease;
    }

    .btn-group .btn {
        transition: all 0.2s ease;
    }

    .btn-group .btn:hover {
        transform: translateY(-2px);
    }

    .badge {
        font-weight: 600;
        letter-spacing: 0.3px;
    }

    .rounded-circle {
        flex-shrink: 0;
    }
</style>
@stop