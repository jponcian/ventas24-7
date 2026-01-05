<x-app-layout>
    @push('head')
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%);
            --card-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.05);
        }

        body {
            font-family: 'Outfit', sans-serif !important;
        }

        .page-header-custom {
            background: white;
            padding: 2rem 1.5rem;
            border-radius: 1rem;
            box-shadow: 0 4px 20px -5px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }
        
        .page-header-custom::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; height: 4px;
            background: var(--primary-gradient);
        }

        .btn-new-appointment {
            background: var(--primary-gradient);
            color: white;
            border: none;
            border-radius: 1rem;
            padding: 0.8rem 1.5rem;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(14, 165, 233, 0.3);
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn-new-appointment:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(14, 165, 233, 0.4);
            color: white;
        }

        .appointment-card {
            background: white;
            border-radius: 1.5rem;
            border: none;
            box-shadow: var(--card-shadow);
            margin-bottom: 1.5rem;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
        }

        .appointment-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px -5px rgba(0, 0, 0, 0.1);
        }

        .appointment-card .card-status-bar {
            height: 6px;
            width: 100%;
        }

        .appointment-card .card-body {
            padding: 1.5rem;
        }

        .date-badge {
            background: #f1f5f9;
            border-radius: 1rem;
            padding: 0.5rem 1rem;
            text-align: center;
            min-width: 80px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .date-badge .day {
            font-size: 1.25rem;
            font-weight: 700;
            color: #0f172a;
            line-height: 1;
        }

        .date-badge .month {
            font-size: 0.75rem;
            text-transform: uppercase;
            color: #64748b;
            font-weight: 600;
            letter-spacing: 0.05em;
        }

        .time-badge {
            font-size: 0.9rem;
            color: #475569;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }

        .specialist-info {
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #f1f5f9;
        }

        .specialist-name {
            font-weight: 600;
            color: #1e293b;
            font-size: 1.05rem;
        }

        .status-badge {
            padding: 0.35rem 0.85rem;
            border-radius: 2rem;
            font-size: 0.75rem;
            font-weight: 600;
            letter-spacing: 0.02em;
            text-transform: uppercase;
        }

        .status-pendiente { background: #fff7ed; color: #c2410c; border: 1px solid #ffedd5; }
        .status-confirmada { background: #eff6ff; color: #0369a1; border: 1px solid #dbeafe; }
        .status-cancelada { background: #fef2f2; color: #b91c1c; border: 1px solid #fee2e2; }
        .status-concluida { background: #f0fdf4; color: #15803d; border: 1px solid #dcfce7; }
        .status-validado { background: #f0f9ff; color: #0284c7; border: 1px solid #e0f2fe; }
        .status-en_consulta { background: #fffbeb; color: #b45309; border: 1px solid #fef3c7; }
        .status-cerrado { background: #f0fdf4; color: #166534; border: 1px solid #dcfce7; }

        .action-btn {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
            border: none;
            text-decoration: none !important;
        }
        
        .action-btn:hover {
            transform: scale(1.1);
        }

        .btn-view { background: #e0f2fe; color: #0284c7; }
        .btn-meds { background: #dcfce7; color: #16a34a; }
        .btn-cancel { background: #fee2e2; color: #dc2626; }
    </style>
    @endpush

    <div class="py-4">
        <div class="container">
            <!-- Header -->
            <div class="page-header-custom d-flex flex-column flex-md-row justify-content-between align-items-center gap-3">
                <div class="text-center text-md-start">
                    <h1 class="h3 font-weight-bold mb-1" style="color: #0f172a;">Mis Citas y Atenciones</h1>
                    <p class="text-muted mb-0">Gestiona tus consultas médicas</p>
                </div>
                <a href="{{ route('citas.create') }}" class="btn-new-appointment">
                    <i class="fas fa-plus-circle"></i>
                    <span>Nueva Cita</span>
                </a>
            </div>

            <!-- Success Message -->
            @if(session('success'))
                <div class="alert alert-success border-0 shadow-sm rounded-lg mb-4" style="background: #dcfce7; color: #166534;">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-check-circle mr-2 text-success"></i>
                        <strong>¡Listo!</strong>&nbsp;{{ session('success') }}
                    </div>
                </div>
            @endif

            <div class="row">
                @forelse($items as $item)
                    @php
                        $id = $item['id'];
                        $fechaRaw = $item['momento'];
                        $tipo = $item['tipo'];
                        $estado = $item['estado'];
                        $especialista = $item['especialista'] ?? '—';
                        $tieneMeds = $item['tiene_meds'];
                        
                        $carbonFecha = \Illuminate\Support\Carbon::parse($fechaRaw);
                        $dia = $carbonFecha->format('d');
                        $mes = $carbonFecha->translatedFormat('M');
                        $hora = $carbonFecha->format('h:i A');
                        
                        $statusColor = match($estado) {
                            'pendiente', 'en_consulta' => '#f59e0b',
                            'confirmada', 'validado' => '#0ea5e9',
                            'cancelada' => '#ef4444',
                            'concluida', 'cerrado' => '#22c55e',
                            default => '#64748b'
                        };
                    @endphp

                    <div class="col-12 col-md-6 col-lg-4">
                        <div class="appointment-card">
                            <div class="card-status-bar" style="background: {{ $statusColor }}"></div>
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div class="d-flex gap-3 align-items-center">
                                        <div class="date-badge">
                                            <span class="day">{{ $dia }}</span>
                                            <span class="month">{{ $mes }}</span>
                                        </div>
                                        <div>
                                            <div class="time-badge mb-1">
                                                <i class="far fa-clock text-primary"></i>
                                                {{ $hora }}
                                            </div>
                                            <span class="status-badge status-{{ $estado }}">
                                                {{ ucfirst(str_replace('_', ' ', $estado)) }}
                                            </span>
                                        </div>
                                    </div>
                                    
                                    <div class="dropdown">
                                        <button class="btn btn-link text-muted p-0" type="button" data-bs-toggle="dropdown">
                                            <i class="fas fa-ellipsis-v"></i>
                                        </button>
                                        <ul class="dropdown-menu dropdown-menu-end border-0 shadow-lg rounded-lg">
                                            @if($tipo === 'cita')
                                                <li><a class="dropdown-item py-2" href="{{ route('citas.show', $id) }}">
                                                    <i class="fas fa-eye text-primary me-2"></i> Ver detalles
                                                </a></li>
                                                @if($tieneMeds)
                                                    <li><a class="dropdown-item py-2" href="{{ route('citas.receta', $id) }}">
                                                        <i class="fas fa-prescription-bottle-alt text-success me-2"></i> Ver receta
                                                    </a></li>
                                                @endif
                                                @if(!in_array($estado, ['cancelada','concluida']))
                                                    <li><hr class="dropdown-divider"></li>
                                                    <li>
                                                        <form action="{{ route('citas.cancelar', $id) }}" method="POST" class="js-cancel-cita">
                                                            @csrf
                                                            <button type="submit" class="dropdown-item py-2 text-danger">
                                                                <i class="fas fa-ban me-2"></i> Cancelar cita
                                                            </button>
                                                        </form>
                                                    </li>
                                                @endif
                                            @else
                                                @if($estado === 'cerrado')
                                                    <li><a class="dropdown-item py-2" href="{{ route('atenciones.paciente.show', $id) }}">
                                                        <i class="fas fa-eye text-primary me-2"></i> Ver detalles
                                                    </a></li>
                                                @endif
                                                @if($tieneMeds)
                                                    <li><a class="dropdown-item py-2" href="{{ route('atenciones.paciente.receta', $id) }}">
                                                        <i class="fas fa-prescription-bottle-alt text-success me-2"></i> Ver receta
                                                    </a></li>
                                                @endif
                                            @endif
                                        </ul>
                                    </div>
                                </div>

                                <div class="specialist-info">
                                    <p class="text-uppercase text-muted small font-weight-bold mb-1" style="font-size: 0.7rem; letter-spacing: 1px;">
                                        {{ $tipo === 'cita' ? 'Especialista' : 'Atención Médica' }}
                                    </p>
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div class="d-flex align-items-center">
                                            <div class="bg-light rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px;">
                                                <i class="fas {{ $tipo === 'cita' ? 'fa-user-md' : 'fa-ambulance' }} text-primary"></i>
                                            </div>
                                            <span class="specialist-name">{{ $especialista }}</span>
                                        </div>
                                        
                                        <div class="d-flex gap-2">
                                            @if($tipo === 'cita')
                                                <a href="{{ route('citas.show', $id) }}" class="action-btn btn-view" title="Ver">
                                                    <i class="fas fa-chevron-right"></i>
                                                </a>
                                            @elseif($estado === 'cerrado')
                                                <a href="{{ route('atenciones.paciente.show', $id) }}" class="action-btn btn-view" title="Ver">
                                                    <i class="fas fa-chevron-right"></i>
                                                </a>
                                            @endif
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                @empty
                    <div class="col-12">
                        <div class="text-center py-5">
                            <div class="mb-4">
                                <div class="bg-white rounded-circle shadow-sm d-inline-flex align-items-center justify-content-center" style="width: 100px; height: 100px;">
                                    <i class="fas fa-calendar-plus text-primary fa-3x opacity-50"></i>
                                </div>
                            </div>
                            <h3 class="h4 font-weight-bold text-dark">No tienes citas programadas</h3>
                            <p class="text-muted mb-4">Agenda tu primera consulta médica con nuestros especialistas.</p>
                            <a href="{{ route('citas.create') }}" class="btn btn-primary btn-lg rounded-pill px-5 shadow-sm">
                                Agendar Cita Ahora
                            </a>
                        </div>
                    </div>
                @endforelse
            </div>
        </div>
    </div>

    @push('scripts')
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
    (function(){
        function bindCancelHandlers(){
            document.querySelectorAll('form.js-cancel-cita').forEach(function(form){
                if(form._boundSwal) return;
                form._boundSwal = true;
                form.addEventListener('submit', function(e){
                    e.preventDefault();
                    Swal.fire({
                        title: '¿Cancelar cita?',
                        text: 'Esta acción notificará al especialista.',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonText: 'Sí, cancelar',
                        cancelButtonText: 'Volver',
                        confirmButtonColor: '#ef4444',
                        cancelButtonColor: '#64748b',
                        reverseButtons: true,
                        customClass: {
                            popup: 'rounded-xl',
                            confirmButton: 'rounded-lg',
                            cancelButton: 'rounded-lg'
                        }
                    }).then(function(result){
                        if(result.isConfirmed){ form.submit(); }
                    });
                });
            });
        }
        bindCancelHandlers();
    })();
    </script>
    @endpush
</x-app-layout>
