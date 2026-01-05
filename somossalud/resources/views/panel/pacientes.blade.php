<x-app-layout>
    @push('head')
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%);
            --secondary-gradient: linear-gradient(135deg, #10b981 0%, #059669 100%);
            --accent-gradient: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
            --card-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.05);
        }

        body {
            font-family: 'Outfit', sans-serif !important;
        }

        .dashboard-header {
            background: white;
            padding: 2rem 1.5rem;
            border-radius: 1rem;
            box-shadow: 0 4px 20px -5px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
            margin-top: 1.5rem; /* Add spacing from top nav */
        }
        
        .dashboard-header::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; height: 4px;
            background: var(--primary-gradient);
        }

        .welcome-text {
            font-size: 1.5rem;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 0.25rem;
        }

        .date-text {
            color: #64748b;
            font-size: 0.95rem;
            font-weight: 500;
        }

        .action-card {
            background: white;
            border-radius: 1.5rem;
            border: none;
            box-shadow: var(--card-shadow);
            transition: all 0.3s ease;
            height: 100%;
            overflow: hidden;
            position: relative;
        }

        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px -5px rgba(0, 0, 0, 0.1);
        }

        .action-card .card-body {
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100%;
        }

        .icon-wrapper {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }

        .card-title {
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: 0.5rem;
            color: #1e293b;
        }

        .card-text {
            color: #64748b;
            font-size: 0.9rem;
            margin-bottom: 1.5rem;
            line-height: 1.5;
        }

        .btn-action {
            padding: 0.75rem 1.5rem;
            border-radius: 1rem;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            width: 100%;
        }

        .btn-primary-soft {
            background: #e0f2fe;
            color: #0284c7;
        }
        .btn-primary-soft:hover {
            background: #bae6fd;
            color: #0369a1;
        }

        .btn-success-soft {
            background: #dcfce7;
            color: #059669;
        }
        .btn-success-soft:hover {
            background: #bbf7d0;
            color: #166534;
        }

        .btn-indigo-soft {
            background: #e0e7ff;
            color: #4f46e5;
        }
        .btn-indigo-soft:hover {
            background: #c7d2fe;
            color: #4338ca;
        }

        .status-card {
            background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%);
            color: white;
            border-radius: 1.5rem;
            padding: 1.5rem;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 30px -5px rgba(14, 165, 233, 0.3);
        }

        .status-card::after {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 200px;
            height: 200px;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 70%);
            border-radius: 50%;
        }

        .recent-item {
            background: white;
            border-radius: 1rem;
            padding: 1rem;
            margin-bottom: 1rem;
            border: 1px solid #f1f5f9;
            transition: all 0.2s;
        }

        .recent-item:hover {
            border-color: #e2e8f0;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
        }

        @media (max-width: 768px) {
            .dashboard-header {
                padding: 1.5rem 1rem;
                border-radius: 0 0 1.5rem 1.5rem;
            }
            .welcome-text {
                font-size: 1.25rem;
            }
        }
    </style>
    @endpush

    @php
        $suscripcionActiva = $suscripcionActiva ?? \App\Models\Suscripcion::where('usuario_id', auth()->id())->where('estado', 'activo')->latest()->first();
        $reportePendiente = $reportePendiente ?? \App\Models\ReportePago::where('usuario_id', auth()->id())->where('estado','pendiente')->latest()->first();
        $ultimoRechazado = $ultimoRechazado ?? \App\Models\ReportePago::where('usuario_id', auth()->id())->where('estado','rechazado')->latest()->first();
        $tieneActiva = (bool) $suscripcionActiva;
    @endphp

    <div class="py-6" style="background-color: transparent;">
        <div class="container">
            <!-- Header -->
            <div class="dashboard-header">
                <div>
                    <h1 class="welcome-text">Hola, {{ auth()->user()->name }}</h1>
                    <p class="date-text mb-0">
                        {{ now()->isoFormat('D [de] MMMM, YYYY') }}
                    </p>
                </div>
            </div>
            <!-- Status Section -->
            @if (!$tieneActiva)
                <div class="status-card mb-4">
                    <div class="d-flex justify-content-between align-items-start position-relative" style="z-index: 1;">
                        <div>
                            @if($reportePendiente)
                                <h3 class="h5 font-weight-bold mb-1 text-warning">
                                    <i class="fas fa-clock me-2"></i>Pago en Revisión
                                </h3>
                                <p class="text-white-50 mb-3 small">Referencia: {{ $reportePendiente->referencia }}</p>
                                <a href="{{ route('suscripcion.show') }}" class="btn btn-sm btn-light text-dark font-weight-bold rounded-pill px-3">
                                    Ver Estado
                                </a>
                            @elseif($ultimoRechazado)
                                <h3 class="h5 font-weight-bold mb-1 text-danger">
                                    <i class="fas fa-times-circle me-2"></i>Pago Rechazado
                                </h3>
                                <p class="text-white-50 mb-3 small">{{ $ultimoRechazado->observaciones }}</p>
                                <a href="{{ route('suscripcion.show') }}" class="btn btn-sm btn-light text-dark font-weight-bold rounded-pill px-3">
                                    Intentar de nuevo
                                </a>
                            @else
                                <h3 class="h5 font-weight-bold mb-1">Activa tu Suscripción</h3>
                                <p class="text-white-50 mb-3 small">Accede a todas las funciones premium.</p>
                                <a href="{{ route('suscripcion.show') }}" class="btn btn-sm btn-primary font-weight-bold rounded-pill px-3 border-0" style="background: var(--primary-gradient);">
                                    Reportar Pago
                                </a>
                            @endif
                        </div>
                        <i class="fas fa-crown fa-3x" style="color: #fbbf24; opacity: 0.9;"></i>
                    </div>
                </div>
            @endif

            <!-- Quick Actions Grid -->
            <div class="row g-4 mb-5">
                <!-- Citas -->
                <div class="col-12 col-md-4">
                    <div class="action-card">
                        <div class="card-body">
                            <div>
                                <div class="icon-wrapper bg-blue-50 text-primary">
                                    <i class="fas fa-calendar-check"></i>
                                </div>
                                <h3 class="card-title">Citas Médicas</h3>
                                <p class="card-text">Agenda nuevas consultas y revisa tus citas programadas.</p>
                            </div>
                            <a href="{{ route('citas.paciente') }}" class="btn-action btn-primary-soft">
                                Gestionar Citas <i class="fas fa-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Resultados -->
                <div class="col-12 col-md-4">
                    <div class="action-card">
                        <div class="card-body">
                            <div>
                                <div class="icon-wrapper bg-green-50 text-success">
                                    <i class="fas fa-file-medical-alt"></i>
                                </div>
                                <h3 class="card-title">Resultados</h3>
                                <p class="card-text">Consulta y descarga tus informes de laboratorio.</p>
                            </div>
                            <a href="{{ route('paciente.resultados') }}" class="btn-action btn-success-soft">
                                Ver Resultados <i class="fas fa-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Perfil -->
                <div class="col-12 col-md-4">
                    <div class="action-card">
                        <div class="card-body">
                            <div>
                                <div class="icon-wrapper bg-indigo-50 text-indigo-600">
                                    <i class="fas fa-user-cog"></i>
                                </div>
                                <h3 class="card-title">Mi Perfil</h3>
                                <p class="card-text">Actualiza tus datos personales y de contacto.</p>
                            </div>
                            <a href="{{ route('profile.edit', ['context' => 'paciente']) }}" class="btn-action btn-indigo-soft">
                                Editar Perfil <i class="fas fa-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Activity -->
            @if($ultimaReceta || (isset($ultimaAtencionConMeds) && $ultimaAtencionConMeds))
                <h2 class="h5 font-weight-bold mb-3 text-dark">Actividad Reciente</h2>
                <div class="row g-4">
                    @if($ultimaReceta)
                        <div class="col-12 col-lg-6">
                            <div class="recent-item h-100">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="bg-pink-50 text-pink-500 rounded p-2">
                                            <i class="fas fa-prescription-bottle-alt"></i>
                                        </div>
                                        <div>
                                            <h6 class="mb-0 font-weight-bold">Última Receta</h6>
                                            <small class="text-muted">{{ \Carbon\Carbon::parse($ultimaReceta->fecha)->format('d/m/Y') }}</small>
                                        </div>
                                    </div>
                                    <a href="{{ route('citas.receta', $ultimaReceta) }}" class="btn btn-sm btn-light text-primary">Ver</a>
                                </div>
                                <div class="small text-muted">
                                    @foreach($ultimaReceta->medicamentos->take(2) as $med)
                                        <div class="mb-1">• {{ $med->nombre_generico }}</div>
                                    @endforeach
                                    @if($ultimaReceta->medicamentos->count() > 2)
                                        <div class="fst-italic">+ {{ $ultimaReceta->medicamentos->count() - 2 }} más</div>
                                    @endif
                                </div>
                            </div>
                        </div>
                    @endif
                </div>
            @endif
        </div>
    </div>
</x-app-layout>