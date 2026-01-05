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

        .detail-card {
            background: white;
            border-radius: 1.5rem;
            border: none;
            box-shadow: var(--card-shadow);
            overflow: hidden;
            margin-bottom: 1.5rem;
        }

        .info-box {
            background: #f8fafc;
            border-radius: 1rem;
            padding: 1.25rem;
            height: 100%;
            transition: all 0.2s;
            border: 1px solid transparent;
        }

        .info-box:hover {
            background: #fff;
            border-color: #e2e8f0;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
        }

        .info-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #64748b;
            font-weight: 600;
            margin-bottom: 0.5rem;
            display: block;
        }

        .info-value {
            font-size: 1.1rem;
            font-weight: 600;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 2rem;
            font-size: 0.85rem;
            font-weight: 600;
            letter-spacing: 0.02em;
            text-transform: uppercase;
            display: inline-block;
        }

        .status-pendiente { background: #fff7ed; color: #c2410c; border: 1px solid #ffedd5; }
        .status-confirmada { background: #eff6ff; color: #0369a1; border: 1px solid #dbeafe; }
        .status-cancelada { background: #fef2f2; color: #b91c1c; border: 1px solid #fee2e2; }
        .status-concluida { background: #f0fdf4; color: #15803d; border: 1px solid #dcfce7; }

        .btn-back {
            color: #64748b;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s;
        }

        .btn-back:hover {
            color: #0ea5e9;
            transform: translateX(-3px);
        }

        .history-table th {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #64748b;
            font-weight: 600;
            background: #f8fafc;
            padding: 1rem;
            border-bottom: 2px solid #e2e8f0;
        }

        .history-table td {
            padding: 1rem;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
            color: #334155;
        }
    </style>
    @endpush

    <div class="py-4">
        <div class="container">
            <!-- Header -->
            <div class="page-header-custom">
                <a href="{{ route('citas.index') }}" class="btn-back mb-3">
                    <i class="fas fa-arrow-left"></i>
                    <span>Volver a mis citas</span>
                </a>
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3">
                    <div>
                        <h1 class="h3 font-weight-bold mb-1" style="color: #0f172a;">Detalle de Cita</h1>
                        <p class="text-muted mb-0">Información de tu consulta médica</p>
                    </div>
                    <span class="status-badge status-{{ $cita->estado }}">
                        {{ ucfirst($cita->estado) }}
                    </span>
                </div>
            </div>

            <div class="detail-card p-4">
                <div class="row g-4">
                    <div class="col-12 col-md-6 col-lg-3">
                        <div class="info-box">
                            <span class="info-label">Fecha y Hora</span>
                            <div class="info-value">
                                <i class="far fa-clock text-primary"></i>
                                {{ \Carbon\Carbon::parse($cita->fecha)->format('d/m/Y H:i') }}
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-3">
                        <div class="info-box">
                            <span class="info-label">Especialista</span>
                            <div class="info-value">
                                <i class="fas fa-user-md text-info"></i>
                                {{ optional($cita->especialista)->name ?? '—' }}
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-3">
                        <div class="info-box">
                            <span class="info-label">Clínica</span>
                            <div class="info-value">
                                <i class="fas fa-hospital text-success"></i>
                                {{ optional($cita->clinica)->nombre ?? '—' }}
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-3">
                        <div class="info-box">
                            <span class="info-label">Estado</span>
                            <div class="info-value">
                                <i class="fas fa-info-circle text-warning"></i>
                                {{ ucfirst($cita->estado) }}
                            </div>
                        </div>
                    </div>
                </div>

                @if($cita->diagnostico || $cita->observaciones)
                    <hr class="my-4 border-light">
                    <div class="row g-4">
                        @if($cita->diagnostico)
                            <div class="col-12 col-md-6">
                                <div class="bg-blue-50 rounded-xl p-4 h-100">
                                    <div class="text-xs text-blue-600 font-weight-bold mb-2 text-uppercase">
                                        <i class="fas fa-notes-medical me-1"></i> Diagnóstico
                                    </div>
                                    <div class="text-gray-700">{{ $cita->diagnostico }}</div>
                                </div>
                            </div>
                        @endif
                        @if($cita->observaciones)
                            <div class="col-12 col-md-6">
                                <div class="bg-yellow-50 rounded-xl p-4 h-100">
                                    <div class="text-xs text-yellow-600 font-weight-bold mb-2 text-uppercase">
                                        <i class="fas fa-comment-dots me-1"></i> Observaciones
                                    </div>
                                    <div class="text-gray-700">{{ $cita->observaciones }}</div>
                                </div>
                            </div>
                        @endif
                    </div>
                @endif
            </div>

            @if(isset($historial) && $historial->count())
                <div class="detail-card p-0">
                    <div class="p-4 border-bottom bg-white">
                        <h4 class="h5 font-weight-bold mb-0 text-dark">
                            <i class="fas fa-history text-primary me-2"></i>Historial Reciente
                        </h4>
                    </div>
                    <div class="table-responsive">
                        <table class="table history-table mb-0">
                            <thead>
                                <tr>
                                    <th>Tipo</th>
                                    <th>Fecha/Hora</th>
                                    <th>Especialista</th>
                                    <th>Diagnóstico</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($historial as $item)
                                    <tr>
                                        <td>
                                            <span class="badge bg-light text-dark border">
                                                {{ ucfirst($item['tipo']) }}
                                            </span>
                                        </td>
                                        <td class="font-weight-bold">{{ $item['momento']->format('d/m/Y H:i') }}</td>
                                        <td>{{ $item['especialista'] }}</td>
                                        <td class="text-muted">{{ Str::limit($item['diagnostico'] ?? '-', 50) }}</td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                </div>
            @endif
        </div>
    </div>
</x-app-layout>