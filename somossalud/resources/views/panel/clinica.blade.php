@extends('layouts.adminlte')

@section('title', 'SomosSalud | Panel interno')

@section('sidebar')
    @include('panel.partials.sidebar')
@endsection

@push('styles')
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Outfit', sans-serif !important;
            background-color: #f8fafc;
        }

        .content-wrapper {
            background-color: #f8fafc !important;
        }

        .card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
            transition: all 0.3s ease;
            background: white;
            overflow: hidden;
        }

        .card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }

        .card-header {
            background: linear-gradient(135deg, #dbeafe 0%, #dcfce7 100%);
            border-bottom: 1px solid #cbd5e1;
            padding: 1.25rem 1.5rem;
        }

        .card-title {
            font-weight: 600;
            color: #1e293b;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .table thead th {
            border-top: none;
            border-bottom: 2px solid #f1f5f9;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #64748b;
            font-weight: 600;
            padding: 1rem 1.5rem;
        }

        .table td {
            vertical-align: middle;
            border-top: 1px solid #f1f5f9;
            padding: 1rem 1.5rem;
            color: #334155;
        }

        .table-striped tbody tr:nth-of-type(odd) {
            background-color: #f8fafc;
        }

        .avatar-initial {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: #e0f2fe;
            color: #0284c7;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 1rem;
            margin-right: 1rem;
        }

        .badge {
            padding: 0.5em 0.8em;
            border-radius: 6px;
            font-weight: 500;
            letter-spacing: 0.02em;
        }

        .badge-info {
            background-color: #e0f2fe;
            color: #0284c7;
        }

        .badge-success {
            background-color: #dcfce7;
            color: #166534;
        }

        .badge-warning {
            background-color: #fef9c3;
            color: #854d0e;
        }

        @keyframes spin-slow {
            from {
                transform: rotate(0deg);
            }

            to {
                transform: rotate(360deg);
            }
        }
    </style>
@endpush

@section('content')
    {{-- Se eliminó el callout de "Panel en construcción" para mostrar directamente los widgets disponibles --}}

    @php
        // Mostrar mensaje solo una vez por sesión
        $mostrarBienvenida = !session()->pull('panel_bienvenida_mostrada', false);
        if ($mostrarBienvenida) {
            session(['panel_bienvenida_mostrada' => true]);
        }
    @endphp
    @if($mostrarBienvenida)
        @if($mostrarBienvenida)
            <div class="modal fade" id="modalBienvenida" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content border-0 shadow-lg overflow-hidden" style="border-radius: 16px;">
                        <div class="modal-body p-0">
                            <div class="position-relative p-5 text-center" style="background: #fff;">
                                <div class="position-absolute"
                                    style="right: -30px; top: -30px; opacity: 0.15; font-size: 12rem; color: #f59e0b; animation: spin-slow 20s linear infinite;">
                                    <i class="fas fa-sun"></i>
                                </div>
                                <div class="bg-white rounded-circle mx-auto mb-3 shadow-sm d-flex align-items-center justify-content-center overflow-hidden"
                                    style="width: 80px; height: 80px; position: relative; z-index: 1;">
                                    <img src="{{ asset('images/saludsonrisa.jpg') }}" alt="Logo SaludSonrisa" class="img-fluid"
                                        style="max-height: 60px;">
                                </div>
                                <h3 class="font-weight-bold mb-2 text-dark position-relative" style="z-index: 1;">¡Hola,
                                    {{ auth()->user()->name }}!</h3>
                                <p class="mb-4 text-muted position-relative" style="font-size: 1.1rem; z-index: 1;">Bienvenido al
                                    panel de gestión clínica de SomosSalud.</p>
                                <button type="button"
                                    class="btn btn-primary font-weight-bold px-4 rounded-pill shadow-sm position-relative"
                                    style="z-index: 1;" data-dismiss="modal">
                                    Comenzar
                                </button>
                            </div>
                            <div class="progress" style="height: 6px; border-radius: 0;">
                                <div id="bienvenidaProgressBar" class="progress-bar bg-primary" role="progressbar"
                                    style="width: 100%;" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        @endif
    @endif

    {{-- Definimos la variable de usuario autenticado en un bloque PHP para evitar problemas de parseo --}}
    @php
        $yo = auth()->user();
    @endphp
    @role('super-admin|admin_clinica')


    <div class="row mt-4 mb-5">
        <div class="col-md-6">
            <div class="card h-100">
                <div class="card-header">
                    <h3 class="card-title"><i class="fas fa-user-injured text-primary"></i> Últimos Pacientes</h3>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Paciente</th>
                                    <th class="text-right">Registro</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach(\App\Models\User::role('paciente')->latest()->take(5)->get() as $paciente)
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="avatar-initial">
                                                    {{ substr($paciente->name, 0, 1) }}
                                                </div>
                                                <div>
                                                    <div class="font-weight-bold text-dark">{{ $paciente->name }}</div>
                                                    <div class="small text-muted">{{ $paciente->email }}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-right">
                                            <small class="text-muted d-block">
                                                <i class="far fa-clock mr-1"></i> {{ $paciente->created_at->diffForHumans() }}
                                            </small>
                                        </td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card h-100">
                <div class="card-header">
                    <h3 class="card-title"><i class="fas fa-users text-success"></i> Últimos Usuarios</h3>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Usuario</th>
                                    <th>Rol</th>
                                    <th class="text-right">Registro</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach(\App\Models\User::whereDoesntHave('roles', function ($q) {
                                    $q->where('name', 'paciente'); })->latest()->take(5)->get() as $user)
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="avatar-initial" style="background: #dcfce7; color: #166534;">
                                                    {{ substr($user->name, 0, 1) }}
                                                </div>
                                                <div>
                                                    <div class="font-weight-bold text-dark">{{ $user->name }}</div>
                                                    <div class="small text-muted">{{ $user->email }}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            @foreach($user->roles as $role)
                                                @php
                                                    $badgeClass = match ($role->name) {
                                                        'paciente' => 'badge-info',
                                                        'especialista' => 'badge-success',
                                                        'super-admin' => 'badge-warning',
                                                        default => 'badge-secondary'
                                                    };
                                                @endphp
                                                <span class="badge {{ $badgeClass }}">{{ ucfirst($role->name) }}</span>
                                            @endforeach
                                        </td>
                                        <td class="text-right">
                                            <small class="text-muted d-block">
                                                {{ $user->created_at->format('d/m/Y') }}
                                            </small>
                                        </td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    @endrole

    {{-- Tarjetas de Inventario eliminadas para el rol `almacen` por solicitud. --}}

    @role('especialista')
    @php
        // Conteo y listado breve de atenciones abiertas asignadas al especialista
        $totalAbiertas = \App\Models\Atencion::abiertas()->where('medico_id', $yo->id)->count();
        $abiertas = \App\Models\Atencion::abiertas()
            ->where('medico_id', $yo->id)
            ->with(['paciente'])
            ->latest('iniciada_at')
            ->take(5)
            ->get();
    @endphp
    <div class="row mt-4 mb-5">
        <div class="col-lg-4 col-md-6">
            <div class="card border-left border-left-warning" style="border-left: .35rem solid #ffc107;">
                <div class="card-header">
                    <h3 class="card-title mb-0">
                        <i class="fas fa-ambulance text-warning mr-2"></i>
                        Atenciones en curso
                    </h3>
                </div>
                <div class="card-body py-2">
                    <div class="d-flex align-items-center">
                        <span class="badge badge-warning mr-2">{{ $totalAbiertas }}</span>
                        @if($totalAbiertas > 0)
                            <div class="small text-muted">Tienes atenciones asignadas esperando gestión.</div>
                        @else
                            <div class="small text-muted">No tienes atenciones en curso por ahora.</div>
                        @endif
                    </div>
                </div>
                @if($totalAbiertas > 0)
                    <ul class="list-group list-group-flush">
                        @foreach($abiertas as $a)
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="small"><strong>#{{ $a->id }}</strong> ·
                                        {{ optional($a->paciente)->name ?? 'Paciente' }}</div>
                                    @php
                                        $labelEstado = match ($a->estado) {
                                            'validado' => 'Validada',
                                            'en_consulta' => 'En proceso',
                                            'cerrado' => 'Cerrada',
                                            default => ucfirst($a->estado),
                                        };
                                        $badgeClass = match ($a->estado) {
                                            'validado' => 'badge-info',
                                            'en_consulta' => 'badge-warning',
                                            'cerrado' => 'badge-success',
                                            default => 'badge-light'
                                        };
                                    @endphp
                                    <div class="small text-muted">Estado: <span
                                            class="badge {{ $badgeClass }}">{{ $labelEstado }}</span></div>
                                </div>
                                <a href="{{ route('atenciones.gestion', $a) }}" class="btn btn-sm btn-outline-primary">Gestionar</a>
                            </li>
                        @endforeach
                    </ul>
                @endif
            </div>
        </div>
        <div class="col-lg-4 col-md-6">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title"><i class="fas fa-calendar-check text-primary mr-2"></i> Mis citas</h3>
                </div>
                <div class="card-body p-0">
                    <ul class="list-group list-group-flush">
                        @php
                            $proximas = \App\Models\Cita::where('especialista_id', $yo->id)
                                ->orderBy('fecha', 'desc')
                                ->take(5)
                                ->get();
                        @endphp
                        @forelse($proximas as $c)
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="small text-muted">
                                        {{ \Illuminate\Support\Carbon::parse($c->fecha)->format('d/m/Y h:i a') }}</div>
                                    <div class="small">Paciente: {{ optional($c->usuario)->name ?? '—' }}</div>
                                </div>
                                <div class="text-nowrap">
                                    <a href="{{ route('citas.show', $c) }}#gestion" class="btn btn-sm btn-outline-secondary"
                                        title="Gestionar"><i class="fas fa-stethoscope"></i></a>
                                </div>
                            </li>
                        @empty
                            <li class="list-group-item text-muted small">Sin citas próximas</li>
                        @endforelse
                    </ul>
                </div>
            </div>
        </div>

        <div class="col-lg-4 col-md-6">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title"><i class="far fa-clock text-teal mr-2"></i> Mis horarios</h3>
                </div>
                <div class="card-body">
                    <p class="small text-muted mb-2">Administra tu disponibilidad semanal.</p>
                    <a href="{{ route('especialista.horarios.index') }}" class="btn btn-outline-teal btn-sm"><i
                            class="far fa-clock mr-1"></i> Configurar</a>
                </div>
            </div>
        </div>
    </div>
    @endrole
    @push('scripts')
        @if($mostrarBienvenida)
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <script>
                $(document).ready(function () {
                    $('#modalBienvenida').modal('show');


                    // Iniciar animación de la barra de progreso
                    setTimeout(function () {
                        $('#bienvenidaProgressBar').css({
                            'width': '0%',
                            'transition': 'width 5s linear'
                        });
                    }, 500);

                    // Cerrar el modal al finalizar
                    setTimeout(function () {
                        $('#modalBienvenida').modal('hide');
                    }, 5500);
                });
            </script>
        @endif
    @endpush
@endsection