<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verificación de Resultado - Clínica SaludSonrisa</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
        integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA=="
        crossorigin="anonymous" referrerpolicy="no-referrer">
    <style>
        body {
            background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .verification-container {
            padding: 40px 0;
        }

        .verification-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            animation: slideIn 0.5s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card-header-custom {
            background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .card-header-custom h1 {
            font-size: 28px;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .card-header-custom p {
            margin: 0;
            font-size: 16px;
            opacity: 0.9;
        }

        .info-section {
            padding: 30px;
        }

        .verified-badge {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 25px;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
        }

        .verified-badge i {
            font-size: 40px;
            display: block;
            margin-bottom: 10px;
        }

        .code-display {
            background: #f8f9fa;
            border: 2px dashed #0ea5e9;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 30px;
        }

        .code-display .code {
            font-size: 28px;
            font-weight: bold;
            color: #0ea5e9;
            letter-spacing: 3px;
            font-family: 'Courier New', monospace;
        }

        .info-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .info-card h5 {
            color: #0ea5e9;
            font-weight: bold;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e9ecef;
        }

        .info-row {
            padding: 8px 0;
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid #e9ecef;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 600;
            color: #6c757d;
        }

        .info-value {
            color: #212529;
            text-align: right;
        }

        .results-section {
            margin-top: 20px;
        }

        .exam-title {
            background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%);
            color: white;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .results-table {
            width: 100%;
            margin-bottom: 20px;
        }

        .results-table th {
            background-color: #f8f9fa;
            padding: 12px;
            text-align: left;
            font-weight: 600;
            color: #495057;
            border-bottom: 2px solid #dee2e6;
        }

        .results-table td {
            padding: 12px;
            border-bottom: 1px solid #dee2e6;
        }

        .security-notice {
            background: #d1fae5;
            border-left: 4px solid #10b981;
            padding: 20px;
            border-radius: 8px;
            margin-top: 30px;
        }

        .security-notice h5 {
            color: #065f46;
            margin-bottom: 10px;
        }

        .security-notice p {
            color: #047857;
            margin: 0;
            font-size: 14px;
        }

        .footer-custom {
            text-align: center;
            padding: 30px;
            background: #f8f9fa;
            color: #666;
        }
    </style>
</head>

<body>
    <div class="verification-container">
        <div class="container">
            <div class="verification-card">
                <!-- Header -->
                <div class="card-header-custom">
                    <img src="{{ asset('images/saludsonrisa.jpg') }}" alt="Logo SaludSonrisa" style="max-height: 80px; margin-bottom: 10px;">
                    <h1><i class="fas fa-shield-alt"></i> Verificación de Resultado de Laboratorio</h1>
                    <p>Clínica SaludSonrisa</p>
                </div>

                <div class="info-section">
                    <!-- Badge de verificación -->
                    <div class="text-center">
                        <div class="verified-badge">
                            <i class="fas fa-check-circle"></i>
                            RESULTADO VERIFICADO Y AUTÉNTICO
                        </div>
                    </div>

                    <!-- Código de verificación -->
                    <div class="code-display">
                        <div class="text-muted mb-2">Código de Verificación</div>
                        <div class="code">{{ $order->verification_code }}</div>
                    </div>

                    <!-- Información del Paciente -->
                    <div class="info-card">
                        <h5><i class="fas fa-user"></i> Información del Paciente</h5>
                        <div class="info-row">
                            <span class="info-label">Nombre:</span>
                            <span class="info-value"><strong>{{ $order->patient->name }}</strong></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Cédula:</span>
                            <span class="info-value">{{ $order->patient->cedula }}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Fecha de Nacimiento:</span>
                            <span class="info-value">{{ $order->patient->fecha_nacimiento ? \Carbon\Carbon::parse($order->patient->fecha_nacimiento)->format('d/m/Y') : 'N/A' }}</span>
                        </div>
                    </div>

                    <!-- Información del Examen -->
                    <div class="info-card">
                        <h5><i class="fas fa-file-medical"></i> Información del Examen</h5>
                        <div class="info-row">
                            <span class="info-label">Nº de Orden:</span>
                            <span class="info-value"><strong>{{ $order->order_number }}</strong></span>
                        </div>
                        {{-- <div class="info-row">
                            <span class="info-label">Fecha de Orden:</span>
                            <span class="info-value">{{ $order->order_date->format('d/m/Y') }}</span>
                        </div> --}}
                        <div class="info-row">
                            <span class="info-label">Fecha de Muestra:</span>
                            <span class="info-value">{{ $order->sample_date->format('d/m/Y') }}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Fecha de Resultado:</span>
                            <span class="info-value">{{ $order->result_date->format('d/m/Y h:i A') }}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Clínica:</span>
                            <span class="info-value">{{ $order->clinica->nombre }}</span>
                        </div>
                    </div>

                    <!-- Resultados -->
                    <div class="results-section">
                        <h5 class="text-primary mb-3"><i class="fas fa-flask"></i> Resultados</h5>
                        @foreach($order->details as $detail)
                            <div class="exam-title">
                                {{ $detail->exam->name }}
                                @if($detail->exam->abbreviation)
                                    <small>({{ $detail->exam->abbreviation }})</small>
                                @endif
                            </div>

                            @if($detail->results->count() > 0)
                                <div class="table-responsive">
                                    <table class="results-table table table-bordered">
                                        <thead>
                                            <tr>
                                                <th>Parámetro</th>
                                                <th>Valor</th>
                                                <th>Unidad</th>
                                                <th>Rango de Referencia</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            @foreach($detail->results as $result)
                                                <tr>
                                                    <td><strong>{{ $result->examItem->name }}</strong></td>
                                                    <td>{{ $result->value }}</td>
                                                    <td>{{ $result->examItem->unit ?? '-' }}</td>
                                                    <td>

                                                        @php
                                                            $rango = $result->examItem->getReferenceRangeForPatient($order->patient);
                                                            $esColeccion = $rango instanceof \Illuminate\Support\Collection;
                                                        @endphp

                                                        @if($esColeccion)
                                                            @foreach($rango as $rng)
                                                                <div class="mb-1">
                                                                    <span class="badge badge-light border text-wrap" style="font-size: 0.9em;">
                                                                        {{ !empty($rng->value_text) ? $rng->value_text : ($rng->value_min . ' - ' . $rng->value_max) }}
                                                                    </span>
                                                                    @if($rng->condition)
                                                                        <br><small class="text-muted">({{ $rng->condition }})</small>
                                                                    @endif
                                                                </div>
                                                            @endforeach
                                                        @elseif($rango)
                                                            <span class="badge badge-light border text-wrap" style="font-size: 0.9em;">
                                                                {{ !empty($rango->value_text) ? $rango->value_text : ($rango->value_min . ' - ' . $rango->value_max) }}
                                                            </span>
                                                            @if($rango->condition)
                                                                <br><small class="text-muted">({{ $rango->condition }})</small>
                                                            @endif
                                                        @else
                                                            {{ $result->examItem->reference_value ?? '-' }}
                                                        @endif
                                                    </td>
                                                </tr>
                                            @endforeach
                                        </tbody>
                                    </table>
                                </div>
                            @endif
                        @endforeach

                        @if($order->observations)
                            <div class="alert alert-info mt-4">
                                <h6><i class="fas fa-comment"></i> Observaciones</h6>
                                <p class="mb-0">{{ $order->observations }}</p>
                            </div>
                        @endif
                    </div>

                    <!-- Información de Seguridad -->
                    <div class="security-notice">
                        <h5><i class="fas fa-shield-alt"></i> Información de Seguridad</h5>
                        <p>
                            Este resultado ha sido verificado mediante el código único {{ $order->verification_code }}. 
                            Cualquier resultado sin este código o con un código diferente debe considerarse no auténtico. 
                            Para verificar la autenticidad de un resultado, visite nuestra página web y escanee el código QR 
                            o ingrese el código de verificación.
                        </p>
                    </div>

                    <!-- Botón para volver -->
                    <div class="text-center mt-4">
                        <a href="{{ url('/') }}" class="btn btn-primary btn-lg">
                            <i class="fas fa-home"></i> Volver al Inicio
                        </a>
                    </div>
                </div>

                <!-- Footer -->
                <div class="footer-custom">
                    <p class="mb-0">Clínica SaludSonrisa</p>
                    <small>Documento verificado el {{ now()->format('d/m/Y h:i:s A') }}</small>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
