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
            margin-top: 1.5rem;
        }
        
        .page-header-custom::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; height: 4px;
            background: var(--primary-gradient);
        }

        .content-card {
            background: white;
            border-radius: 1.5rem;
            border: none;
            box-shadow: var(--card-shadow);
            overflow: hidden;
            margin-bottom: 1.5rem;
        }

        .card-header-custom {
            padding: 1.5rem;
            border-bottom: 1px solid #f1f5f9;
            background: white;
        }

        .card-title-custom {
            font-weight: 700;
            color: #0f172a;
            font-size: 1.1rem;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .info-item {
            background: #f8fafc;
            border-radius: 1rem;
            padding: 1rem;
            height: 100%;
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
            font-weight: 600;
            color: #1e293b;
            font-size: 1rem;
        }

        .form-control {
            border-radius: 0.75rem;
            border: 2px solid #e2e8f0;
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
            transition: all 0.2s;
        }

        .form-control:focus {
            border-color: #0ea5e9;
            box-shadow: 0 0 0 4px rgba(14, 165, 233, 0.1);
        }

        .btn-primary-custom {
            background: var(--primary-gradient);
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 0.75rem;
            font-weight: 600;
            box-shadow: 0 4px 12px rgba(14, 165, 233, 0.25);
            transition: all 0.2s;
            width: 100%;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(14, 165, 233, 0.35);
            color: white;
        }

        .payment-info-box {
            background: #f0f9ff;
            border: 1px dashed #bae6fd;
            border-radius: 1rem;
            padding: 1.5rem;
        }

        .payment-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }
        
        .payment-label { color: #64748b; }
        .payment-val { font-weight: 600; color: #0f172a; text-align: right; }

        @media (max-width: 768px) {
            .page-header-custom {
                padding: 1.5rem 1rem;
                border-radius: 0 0 1.5rem 1.5rem;
            }
        }
    </style>
    @endpush

    <div class="py-6" style="background-color: transparent;">
        <!-- Header -->
        <div class="container">
            <div class="page-header-custom">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="h3 font-weight-bold mb-1" style="color: #0f172a;">Mi Suscripción</h1>
                        <p class="text-muted mb-0">Gestiona tu plan y pagos</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="container">
            @if(session('error'))
                <div class="alert alert-danger border-0 shadow-sm rounded-lg mb-4">
                    <i class="fas fa-exclamation-circle me-2"></i>{{ session('error') }}
                </div>
            @endif
            @if(session('success'))
                <div class="alert alert-success border-0 shadow-sm rounded-lg mb-4">
                    <i class="fas fa-check-circle me-2"></i>{{ session('success') }}
                </div>
            @endif

            <!-- Subscription Status -->
            @if($suscripcion)
                <div class="content-card">
                    <div class="card-header-custom">
                        <h2 class="card-title-custom">
                            <i class="fas fa-id-card text-primary"></i>
                            Estado de la Suscripción
                        </h2>
                    </div>
                    <div class="p-4">
                        <div class="row g-3">
                            <div class="col-6 col-md-3">
                                <div class="info-item">
                                    <div class="info-label">Plan</div>
                                    <div class="info-value text-uppercase">{{ $suscripcion->plan }}</div>
                                </div>
                            </div>
                            <div class="col-6 col-md-3">
                                <div class="info-item">
                                    <div class="info-label">Estado</div>
                                    <span class="badge rounded-pill {{ $suscripcion->estado === 'activo' ? 'bg-success' : 'bg-warning text-dark' }}">
                                        {{ ucfirst($suscripcion->estado) }}
                                    </span>
                                </div>
                            </div>
                            <div class="col-6 col-md-3">
                                <div class="info-item">
                                    <div class="info-label">Vence</div>
                                    <div class="info-value">
                                        {{ \Illuminate\Support\Carbon::parse($suscripcion->periodo_vencimiento)->format('d/m/Y') }}
                                    </div>
                                </div>
                            </div>
                            <div class="col-6 col-md-3">
                                <div class="info-item">
                                    <div class="info-label">Método</div>
                                    <div class="info-value text-capitalize">
                                        {{ str_replace('_', ' ', $suscripcion->metodo_pago) }}
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="mt-4 text-end">
                            <a href="{{ route('suscripcion.carnet') }}" class="btn btn-outline-primary rounded-pill px-4">
                                <i class="fas fa-address-card me-2"></i>Ver Carnet Digital
                            </a>
                        </div>
                    </div>
                </div>
            @elseif(!isset($ultimoReporte) || $ultimoReporte->estado !== 'pendiente')
                <div class="alert alert-primary border-0 shadow-sm rounded-lg mb-4">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-info-circle fa-2x me-3 opacity-50"></i>
                        <div>
                            <h5 class="alert-heading fw-bold mb-1">No tienes una suscripción activa</h5>
                            <p class="mb-0 small">Realiza el pago de tu anualidad para disfrutar de todos los beneficios.</p>
                        </div>
                    </div>
                </div>
            @endif

            <!-- Pending Report Alert -->
            @if(isset($ultimoReporte) && $ultimoReporte)
                @if($ultimoReporte->estado === 'pendiente')
                    <div class="content-card bg-warning bg-opacity-10 border-warning border-opacity-25">
                        <div class="p-4">
                            <div class="d-flex">
                                <i class="fas fa-clock text-warning fa-2x me-3"></i>
                                <div>
                                    <h5 class="fw-bold text-warning-emphasis mb-1">Pago en Revisión</h5>
                                    <p class="mb-0 text-muted small">
                                        Referencia: <strong>{{ $ultimoReporte->referencia }}</strong>. 
                                        Te notificaremos cuando sea aprobado.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                @elseif($ultimoReporte->estado === 'rechazado')
                    <div class="content-card bg-danger bg-opacity-10 border-danger border-opacity-25">
                        <div class="p-4">
                            <div class="d-flex">
                                <i class="fas fa-times-circle text-danger fa-2x me-3"></i>
                                <div>
                                    <h5 class="fw-bold text-danger-emphasis mb-1">Pago Rechazado</h5>
                                    <p class="mb-0 text-muted small">
                                        @if($ultimoReporte->observaciones) 
                                            Motivo: <strong>{{ $ultimoReporte->observaciones }}</strong>
                                        @else
                                            Por favor verifica los datos e intenta nuevamente.
                                        @endif
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                @endif
            @endif

            <div class="row g-4">
                <!-- Payment Form -->
                <div class="col-lg-7">
                    <div class="content-card h-100">
                        <div class="card-header-custom">
                            <h2 class="card-title-custom">
                                <div class="bg-primary bg-opacity-10 p-2 rounded-circle text-primary">
                                    <i class="fas fa-paper-plane"></i>
                                </div>
                                Reportar Pago
                            </h2>
                        </div>
                        <div class="p-4">
                            @if(isset($ultimoReporte) && $ultimoReporte && $ultimoReporte->estado === 'pendiente')
                                <div class="text-center py-5">
                                    <i class="fas fa-check-circle text-success fa-4x mb-3"></i>
                                    <h4 class="fw-bold text-dark">¡Reporte Enviado!</h4>
                                    <p class="text-muted">Tu pago está siendo verificado por nuestro equipo.</p>
                                    <a href="{{ route('dashboard') }}" class="btn btn-primary-custom mt-3 w-auto px-4">
                                        Volver al Inicio
                                    </a>
                                </div>
                            @else
                                <form method="POST" action="{{ route('suscripcion.reportar') }}">
                                    @csrf
                                    @php
                                        $__rateForm = optional(\App\Models\ExchangeRate::latestEffective()->first());
                                        $__bsDefaultNumeric = ($__rateForm && $__rateForm->rate) ? (10 * (float) $__rateForm->rate) : null;
                                        $__bsDefaultValue = $__bsDefaultNumeric !== null ? number_format($__bsDefaultNumeric, 2, '.', '') : '';
                                        $__bsDefaultDisplay = $__bsDefaultNumeric !== null ? number_format($__bsDefaultNumeric, 2, ',', '.') : null;
                                    @endphp

                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label small fw-bold text-uppercase text-muted">Cédula del Pagador</label>
                                            <input type="text" id="cedula_pagador" name="cedula_pagador" value="{{ old('cedula_pagador') }}" class="form-control" required placeholder="V-12345678">
                                            @error('cedula_pagador')<div class="text-danger small mt-1">{{ $message }}</div>@enderror
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small fw-bold text-uppercase text-muted">Teléfono</label>
                                            <input type="text" id="telefono_pagador" name="telefono_pagador" value="{{ old('telefono_pagador') }}" class="form-control" required placeholder="0414-1234567">
                                            @error('telefono_pagador')<div class="text-danger small mt-1">{{ $message }}</div>@enderror
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small fw-bold text-uppercase text-muted">Fecha</label>
                                            <input type="date" id="fecha_pago" name="fecha_pago" value="{{ old('fecha_pago', now()->format('Y-m-d')) }}" class="form-control" required>
                                            @error('fecha_pago')<div class="text-danger small mt-1">{{ $message }}</div>@enderror
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small fw-bold text-uppercase text-muted">Monto (Bs)</label>
                                            <input type="number" step="0.01" id="monto" name="monto" value="{{ old('monto', $__bsDefaultValue) }}" class="form-control" required>
                                            @if($__bsDefaultDisplay)
                                                <div class="form-text small text-primary"><i class="fas fa-info-circle me-1"></i>Sugerido: {{ $__bsDefaultDisplay }} Bs</div>
                                            @endif
                                            @error('monto')<div class="text-danger small mt-1">{{ $message }}</div>@enderror
                                        </div>
                                        <div class="col-12">
                                            <label class="form-label small fw-bold text-uppercase text-muted">Referencia</label>
                                            <input type="text" id="referencia" name="referencia" value="{{ old('referencia') }}" class="form-control" required placeholder="Últimos 6 dígitos">
                                            @error('referencia')<div class="text-danger small mt-1">{{ $message }}</div>@enderror
                                        </div>
                                    </div>

                                    <div class="mt-4 pt-3 border-top">
                                        <button class="btn-primary-custom" type="submit">
                                            Enviar Reporte de Pago
                                        </button>
                                        <p class="text-center text-muted small mt-2 mb-0">
                                            Al enviar, confirmas que los datos son reales.
                                        </p>
                                    </div>
                                </form>
                            @endif
                        </div>
                    </div>
                </div>

                <!-- Payment Instructions -->
                <div class="col-lg-5">
                    <div class="content-card h-100">
                        <div class="card-header-custom bg-light">
                            <h2 class="card-title-custom">
                                <i class="fas fa-wallet text-secondary"></i>
                                Datos para el Pago
                            </h2>
                        </div>
                        <div class="p-4">
                            <div class="text-center mb-4">
                                <h3 class="display-6 fw-bold text-primary mb-0">$10 USD</h3>
                                <p class="text-muted small">Anualidad</p>
                            </div>

                            @php
                                $__ratePago = optional(\App\Models\ExchangeRate::latestEffective()->first());
                                $__bsEquivPago = ($__ratePago && $__ratePago->rate) ? 10 * (float) $__ratePago->rate : null;
                            @endphp

                            @if($__bsEquivPago !== null)
                                <div class="alert alert-info border-0 bg-info bg-opacity-10 text-info-emphasis mb-4">
                                    <i class="fas fa-exchange-alt me-2"></i>
                                    Aprox. <strong>{{ number_format((float)$__bsEquivPago, 2, ',', '.') }} Bs</strong>
                                    <div class="small mt-1 opacity-75">Según tasa del día</div>
                                </div>
                            @endif

                            <div class="payment-info-box">
                                <h6 class="fw-bold text-uppercase text-muted small mb-3">Pago Móvil</h6>
                                <div class="payment-row">
                                    <span class="payment-label">Banco</span>
                                    <span class="payment-val">{{ $pagoMovil['banco'] }}</span>
                                </div>
                                <div class="payment-row">
                                    <span class="payment-label">Cédula/RIF</span>
                                    <span class="payment-val">{{ $pagoMovil['identificacion'] }}</span>
                                </div>
                                <div class="payment-row">
                                    <span class="payment-label">Teléfono</span>
                                    <span class="payment-val">{{ $pagoMovil['telefono'] }}</span>
                                </div>
                                <div class="payment-row border-top pt-2 mt-2">
                                    <span class="payment-label">Nombre</span>
                                    <span class="payment-val">{{ $pagoMovil['nombre'] }}</span>
                                </div>
                            </div>
                            
                            @if($user->clinica && $user->clinica->descuento)
                                <div class="mt-3 text-center">
                                    <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-3 py-2">
                                        <i class="fas fa-tag me-1"></i>
                                        {{ $user->clinica->descuento }}% Descuento aplicado
                                    </span>
                                </div>
                            @endif
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    @push('scripts')
    <script src="{{ asset('js/cedula-validator.js') }}"></script>
    <script>
    document.addEventListener('DOMContentLoaded', () => {
        const cedulaPagadorInput = document.getElementById('cedula_pagador');
        if (cedulaPagadorInput) {
            new CedulaValidator('cedula_pagador');
        }
    });
    </script>
    @endpush
</x-app-layout>