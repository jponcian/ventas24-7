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
            /* Fondo manejado por layout global */
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

        .result-card {
            background: white;
            border-radius: 1.5rem;
            border: none;
            box-shadow: var(--card-shadow);
            margin-bottom: 1.5rem;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
        }

        .result-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px -5px rgba(0, 0, 0, 0.1);
        }

        .result-card .card-body {
            padding: 2rem;
        }

        .info-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #64748b;
            font-weight: 600;
            margin-bottom: 0.25rem;
        }

        .info-value {
            font-size: 0.95rem;
            color: #1e293b;
            font-weight: 500;
        }

        .status-badge-completed {
            background: #f0fdf4;
            color: #15803d;
            border: 1px solid #dcfce7;
            padding: 0.35rem 0.85rem;
            border-radius: 2rem;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.02em;
        }

        .btn-action-custom {
            border-radius: 0.75rem;
            padding: 0.6rem 1.25rem;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            border: none;
        }

        .btn-pdf {
            background: #fee2e2;
            color: #dc2626;
        }
        .btn-pdf:hover {
            background: #fecaca;
            color: #b91c1c;
            transform: translateY(-2px);
        }

        .btn-verify {
            background: #f1f5f9;
            color: #475569;
        }
        .btn-verify:hover {
            background: #e2e8f0;
            color: #1e293b;
            transform: translateY(-2px);
        }

        .obs-box {
            background: #eff6ff;
            border-left: 4px solid #3b82f6;
            padding: 1rem;
            border-radius: 0.5rem;
            font-size: 0.9rem;
            color: #1e3a8a;
        }

        .exam-item {
            padding: 0.5rem 0;
            border-bottom: 1px solid #f1f5f9;
            color: #334155;
            font-size: 0.95rem;
        }
        .exam-item:last-child { border-bottom: none; }
        .exam-item:before {
            content: '•';
            color: #0ea5e9;
            margin-right: 0.5rem;
            font-weight: bold;
        }
    </style>
    @endpush

    <div class="py-4">
        <div class="container">
            <!-- Header -->
            <div class="page-header-custom">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="h3 font-weight-bold mb-1" style="color: #0f172a;">Mis Resultados</h1>
                        <p class="text-muted mb-0">Consulta y descarga tus informes de laboratorio</p>
                    </div>
                </div>
            </div>

            @if($ordenes->count() > 0)
                <div class="row g-4">
                    @foreach($ordenes as $order)
                    <div class="col-12">
                        <div class="result-card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-lg-8">
                                        <div class="d-flex align-items-center gap-3 mb-4">
                                            <div class="bg-blue-50 text-blue-600 rounded-circle d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                                                <i class="fas fa-file-medical fa-lg"></i>
                                            </div>
                                            <div>
                                                <h3 class="h5 font-weight-bold mb-0 text-dark">Orden #{{ $order->order_number }}</h3>
                                                <span class="status-badge-completed mt-1 d-inline-block">Completado</span>
                                            </div>
                                        </div>

                                        <div class="row g-4 mb-4">
                                            <div class="col-md-4">
                                                <div class="info-label"><i class="far fa-calendar text-primary me-1"></i> Fecha Orden</div>
                                                <div class="info-value">{{ $order->order_date->format('d/m/Y') }}</div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="info-label"><i class="far fa-calendar-check text-green-600 me-1"></i> Fecha Resultado</div>
                                                <div class="info-value">{{ $order->result_date->format('d/m/Y') }}</div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="info-label"><i class="far fa-hospital text-gray-400 me-1"></i> Clínica</div>
                                                <div class="info-value">{{ $order->clinica->nombre }}</div>
                                            </div>
                                        </div>

                                        <div class="mb-4">
                                            <div class="info-label mb-2">Exámenes Realizados</div>
                                            <div class="bg-slate-50 rounded-3 p-3 border border-slate-100">
                                                @foreach($order->details as $detail)
                                                    <div class="exam-item">{{ $detail->exam->name }}</div>
                                                @endforeach
                                            </div>
                                        </div>

                                        @if($order->observations)
                                        <div class="obs-box mb-3">
                                            <strong>Observaciones:</strong> {{ $order->observations }}
                                        </div>
                                        @endif
                                    </div>

                                    <div class="col-lg-4 border-start-lg ps-lg-5">
                                        <div class="text-center text-lg-end mb-4">
                                            <div class="d-inline-block bg-white p-2 rounded-3 shadow-sm border mb-2">
                                                {!! QrCode::size(120)->generate(route('lab.orders.verify', $order->verification_code)) !!}
                                            </div>
                                            <div class="small text-muted font-monospace">{{ $order->verification_code }}</div>
                                            <div class="text-xs text-muted">Código de verificación</div>
                                        </div>

                                        <div class="d-flex flex-column gap-2 align-items-lg-end">
                                            <a href="{{ route('lab.orders.pdf', $order->id) }}" class="btn-action-custom btn-pdf w-100 justify-content-center" style="max-width: 250px;">
                                                <i class="fas fa-file-pdf"></i> Descargar PDF
                                            </a>
                                            <a href="{{ route('lab.orders.verify', $order->verification_code) }}" target="_blank" class="btn-action-custom btn-verify w-100 justify-content-center" style="max-width: 250px;">
                                                <i class="fas fa-external-link-alt"></i> Verificar Online
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    @endforeach
                </div>
            @else
                <div class="result-card text-center py-5">
                    <div class="card-body">
                        <div class="mb-4 text-gray-300">
                            <i class="fas fa-microscope fa-4x"></i>
                        </div>
                        <h3 class="h5 text-dark font-weight-bold">No tienes resultados disponibles</h3>
                        <p class="text-muted">Tus informes de laboratorio aparecerán aquí una vez que sean procesados.</p>
                    </div>
                </div>
            @endif
        </div>
    </div>
</x-app-layout>
