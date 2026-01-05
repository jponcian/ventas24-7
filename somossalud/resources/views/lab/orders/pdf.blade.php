<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resultado de Laboratorio - {{ $order->order_number }}</title>
    <style>
        @page {
            margin: 0.5cm 1cm;
            margin-bottom: 4cm;
        }
        
        body {
            font-family: 'Arial', sans-serif;
            font-size: 10pt;
            color: #000;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .header {
            width: 100%;
            margin-bottom: 10px;
            border-bottom: 2px solid #000;
            padding-bottom: 5px;
        }
        
        .header-table td {
            vertical-align: top;
        }
        
        .logo {
            width: 150px;
            height: auto;
        }
        
        .clinic-name {
            font-size: 16pt;
            font-weight: bold;
            text-align: center;
            text-transform: uppercase;
        }
        
        .clinic-info {
            font-size: 8pt;
            text-align: center;
        }
        
        .report-title {
            font-size: 14pt;
            font-weight: bold;
            text-align: center;
            margin-top: 5px;
            text-decoration: underline;
        }
        
        .patient-info {
            border: 1px solid #000;
            border-radius: 5px;
            padding: 5px;
            margin-bottom: 15px;
            font-size: 9pt;
        }
        
        .patient-info table td {
            padding: 2px 5px;
        }
        
        .label {
            font-weight: bold;
        }
        
        .results-header {
            background-color: #e0e0e0;
            font-weight: bold;
            border-top: 1px solid #000;
            border-bottom: 1px solid #000;
        }
        
        .results-header td {
            padding: 5px;
            text-align: left;
        }
        
        .exam-category {
            font-weight: bold;
            font-size: 11pt;
            margin-top: 10px;
            margin-bottom: 5px;
            text-decoration: underline;
        }
        
        .result-row td {
            padding: 3px 5px;
            border-bottom: 1px dotted #ccc;
        }
        
        .footer {
            position: fixed;
            bottom: -2.5cm;
            left: 0;
            right: 0;
            height: 130px;
            font-size: 8pt;
        }

        .signature-section {
            margin-top: 30px;
            page-break-inside: avoid;
            width: 100%;
        }
        
        .signature-line {
            border-top: 1px solid #000;
            width: 200px;
            margin: 0 auto;
            margin-top: 40px;
            padding-top: 5px;
        }
        
        .qr-code {
            position: absolute;
            top: 10px;
            right: 10px;
            width: 80px;
        }
        
        .out-of-range {
            background-color: #fff3cd;
            color: #d32f2f;
            font-weight: bold;
            padding: 2px 4px;
            border-left: 3px solid #d32f2f;
        }
        
        .alert-icon {
            color: #d32f2f;
            font-weight: bold;
            margin-right: 3px;
        }
    </style>
</head>
<body>
    <!-- Encabezado -->
    <div class="header">
        <table class="header-table">
            <tr>
                <td width="20%">
                    <img src="{{ public_path('images/saludsonrisa completo.jpg') }}" class="logo" onerror="this.style.display='none'">
                </td>
                <td width="60%" align="center">
                    <div class="clinic-name">{{ $order->clinica->nombre }}</div>
                    <div class="clinic-info">
                        {{ $order->clinica->direccion }}<br>
                        Teléfonos: {{ $order->clinica->telefono }}
                    </div>
                    <div class="report-title">RESULTADO DE LABORATORIO</div>
                </td>
                <td width="20%" align="right">
                    <img src="data:image/svg+xml;base64,{{ $qrCode }}" width="80">
                    <div style="font-size: 7pt; text-align: center;">{{ $order->verification_code }}</div>
                </td>
            </tr>
        </table>
    </div>

    <!-- Datos del Paciente -->
    <div class="patient-info">
        <table>
            <tr>
                <td class="label" width="15%">PACIENTE:</td>
                <td width="45%">{{ strtoupper($order->patient->name) }}</td>

                <td class="label" width="15%">FECHA RESULTADO:</td>
                <td width="25%">{{ $order->result_date ? \Carbon\Carbon::parse($order->result_date)->format('d/m/Y h:i A') : 'N/A' }}</td>
            </tr>
            <tr>
                <td class="label">C.I.:</td>
                <td>{{ $order->patient->cedula }}</td>
                <td class="label">Nº ORDEN:</td>
                <td>{{ $order->order_number }}</td>
            </tr>
            <tr>
                <td class="label">EDAD/SEXO:</td>
                <td>{{ $order->patient->edad ?? 'N/A' }} AÑOS / {{ strtoupper($order->patient->sexo ?? 'N/A') }}</td>
                <td class="label">MÉDICO:</td>
                <td>{{ strtoupper($order->doctor->name ?? 'A QUIEN PUEDA INTERESAR') }}</td>
            </tr>
            @if($order->patient->fecha_nacimiento)
            <tr>
                <td class="label">F. NACIMIENTO:</td>
                <td>{{ \Carbon\Carbon::parse($order->patient->fecha_nacimiento)->format('d/m/Y') }}</td>
                <td colspan="2"></td>
            </tr>
            @endif
        </table>
    </div>

    <!-- Tabla de Resultados -->
    <table class="results-table">
        <tr class="results-header">
            <td width="40%">EXAMEN / PRUEBA</td>
            <td width="20%">RESULTADO</td>
            <td width="15%">UNIDADES</td>
            <td width="25%">VALORES DE REFERENCIA</td>
        </tr>

        @foreach($order->details as $detail)
            <tr>
                <td colspan="4" class="exam-category">{{ strtoupper($detail->exam->name) }}</td>
            </tr>
            
            @foreach($detail->results as $result)
                @php
                    $rango = $result->examItem->getReferenceRangeForPatient($order->patient);
                    $isOutOfRange = false;
                    $resultValue = trim($result->value);
                    
                    // Verificar si el valor está fuera de rango
                    if (is_numeric($resultValue)) {
                        $numericValue = floatval($resultValue);
                        
                        if ($rango && $rango->value_min !== null && $rango->value_max !== null) {
                            // Usar rangos de la tabla lab_reference_ranges
                            $minValue = floatval($rango->value_min);
                            $maxValue = floatval($rango->value_max);
                            
                            if ($numericValue < $minValue || $numericValue > $maxValue) {
                                $isOutOfRange = true;
                            }
                        } elseif ($result->examItem->reference_value) {
                            // Fallback: parsear reference_value (formato: "12.0 - 16.0")
                            $refValue = $result->examItem->reference_value;
                            
                            // Intentar extraer min y max del formato "X - Y" o "X-Y"
                            if (preg_match('/(\d+\.?\d*)\s*-\s*(\d+\.?\d*)/', $refValue, $matches)) {
                                $minValue = floatval($matches[1]);
                                $maxValue = floatval($matches[2]);
                                
                                if ($numericValue < $minValue || $numericValue > $maxValue) {
                                    $isOutOfRange = true;
                                }
                            }
                        }
                    }
                @endphp
                
                <tr class="result-row {{ $isOutOfRange ? 'out-of-range' : '' }}">
                    <td>
                        @if($isOutOfRange)
                            <span class="alert-icon">⚠</span>
                        @endif
                        {{ $result->examItem->name }}
                    </td>
                    <td style="font-weight: bold;">{{ $result->value }}</td>
                    <td>{{ $result->examItem->unit }}</td>
                    <td>

                        @php
                            $textoReferencia = null;
                            $esColeccion = $rango instanceof \Illuminate\Support\Collection;
                            
                            if (!$esColeccion && $rango) {
                                if (!empty($rango->value_text)) {
                                    $textoReferencia = $rango->value_text;
                                } elseif (!is_null($rango->value_min) || !is_null($rango->value_max)) {
                                    $textoReferencia = $rango->value_min . ' - ' . $rango->value_max;
                                }
                            }
                            
                            // Si no hallamos un texto específico (y no es colección), usar el genérico
                            if (empty($textoReferencia) && !$esColeccion) {
                                $textoReferencia = $result->examItem->reference_value;
                            }
                        @endphp

                        @if($esColeccion)
                            @foreach($rango as $rng)
                                <div>
                                    @if(!empty($rng->value_text))
                                        {{ $rng->value_text }}
                                    @else
                                        {{ $rng->value_min }} - {{ $rng->value_max }}
                                    @endif

                                    @if($rng->condition)
                                        <span style="font-size: 7pt; font-style: italic;">({{ $rng->condition }})</span>
                                    @endif
                                </div>
                            @endforeach
                        @else
                            {{ $textoReferencia }}

                            @if($rango && $rango->condition)
                                <br><span style="font-size: 7pt; font-style: italic;">({{ $rango->condition }})</span>
                            @endif
                        @endif
                    </td>
                </tr>
                @if($result->observation)
                    <tr>
                        <td colspan="4" style="font-style: italic; font-size: 8pt; padding-left: 10px;">
                            Obs: {{ $result->observation }}
                        </td>
                    </tr>
                @endif
            @endforeach
        @endforeach
    </table>

    @if($order->observations)
        <div style="margin-top: 20px; border: 1px solid #ccc; padding: 5px; font-size: 9pt;">
            <strong>OBSERVACIONES:</strong> {{ $order->observations }}
        </div>
    @endif

    <!-- Pie de página fijo con dirección y firma -->
    <div class="footer">
        <table width="100%">
            <tr>
                <!-- Columna Izquierda: Dirección -->
                <td width="55%" valign="bottom" style="text-align: left; padding-bottom: 10px;">
                    @php
                        $direccion = \App\Models\Setting::getValue('clinica_direccion') ?? $order->clinica->direccion;
                        $direccion = preg_replace('/E:\s*[\d\.\-]+\s*W:\s*[\d\.\-]+/i', '', $direccion);
                        $direccion = trim($direccion, " -");
                    @endphp
                    <div>D: {{ $direccion }}</div>
                    <div>T: {{ \App\Models\Setting::getValue('clinica_telefono') ?? $order->clinica->telefono }}</div>
                </td>

                <!-- Columna Derecha: Firma del Bioanalista -->
                <td width="45%" align="center" valign="bottom">
                    <div style="width: 220px; text-align: center; margin-left: auto; margin-right: auto;">
                        <div style="font-weight: bold; margin-bottom: 5px; font-size: 9pt;">Bioanalista</div>
                        
                        <div style="height: 60px; position: relative;">
                            @if($order->resultsLoadedBy && $order->resultsLoadedBy->firma)
                                @php
                                    $path = storage_path('app/public/' . $order->resultsLoadedBy->firma);
                                    if (file_exists($path)) {
                                        $type = pathinfo($path, PATHINFO_EXTENSION);
                                        $data = file_get_contents($path);
                                        $base64 = 'data:image/' . $type . ';base64,' . base64_encode($data);
                                    } else {
                                        $base64 = null;
                                    }
                                @endphp
                                
                                @if($base64)
                                    <img src="{{ $base64 }}" style="max-height: 80px; max-width: 180px; position: absolute; bottom: 0; left: 50%; transform: translateX(-50%);">
                                @endif
                            @endif
                        </div>

                        <div style="border-top: 1px solid #000; margin-top: 5px; margin-bottom: 5px;"></div>
                        
                        <div style="font-size: 8pt; line-height: 1.3;">
                            <div style="font-weight: bold;">
                                Lic. {{ strtoupper($order->resultsLoadedBy->name ?? '') }}
                            </div>
                            <div>
                                M.P.P.S: {{ $order->resultsLoadedBy->mpps ?? 'N/A' }} 
                                &nbsp;&nbsp; 
                                C.B.: {{ $order->resultsLoadedBy->colegio_bioanalista ?? 'N/A' }}
                            </div>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</body>
</html>
