<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ticket - {{ $order->order_number }}</title>
    <style>
        @page {
            margin: 0.3cm;
            size: 80mm auto;
        }
        
        body {
            font-family: 'Courier New', 'Courier', monospace;
            font-size: 8pt;
            color: #000;
            margin: 0 auto;
            padding: 3mm;
            max-width: 74mm;
            line-height: 1.3;
        }
        
        .ticket-container {
            width: 100%;
            margin: 0 auto;
        }
        
        .header {
            text-align: center;
            margin-bottom: 3mm;
        }
        
        .clinic-logo {
            width: 35mm;
            margin: 0 auto 2mm;
        }
        
        .clinic-name {
            font-size: 9pt;
            font-weight: bold;
            margin-bottom: 1mm;
            letter-spacing: 0.5px;
        }
        
        .clinic-rif {
            font-size: 7pt;
            margin-bottom: 2mm;
        }
        
        .divider {
            border-top: 1px dashed #000;
            margin: 2mm 0;
        }
        
        .date-line {
            text-align: center;
            font-size: 8pt;
            margin: 2mm 0;
        }
        
        .ticket-title {
            text-align: center;
            font-size: 10pt;
            font-weight: bold;
            margin: 2mm 0;
            letter-spacing: 1px;
        }
        
        .order-box {
            border: 2px solid #000;
            padding: 2mm;
            margin: 3mm 0;
            text-align: center;
            font-size: 9pt;
            font-weight: bold;
        }
        
        .info-section {
            text-align: left;
            margin: 2mm 0;
            font-size: 8pt;
        }
        
        .info-line {
            margin: 1mm 0;
        }
        
        .label {
            font-weight: bold;
        }
        
        .name-field {
            margin: 2mm 0;
        }
        
        .inline-info {
            display: inline-block;
        }
        
        .exams-section {
            margin: 3mm 0;
        }
        
        .exams-title {
            font-weight: bold;
            margin-bottom: 2mm;
        }
        
        .exam-item {
            margin: 1mm 0;
            padding-left: 2mm;
        }
        
        .total-section {
            text-align: center;
            font-size: 9pt;
            font-weight: bold;
            margin: 3mm 0;
        }
        
        .footer {
            text-align: center;
            font-size: 6pt;
            margin-top: 4mm;
            line-height: 1.4;
        }
        
        .stars {
            text-align: center;
            letter-spacing: 2px;
            margin: 2mm 0;
        }
    </style>
</head>
<body>
    <div class="ticket-container">
        {{-- Logo solamente --}}
        <div class="header">
            <div class="clinic-logo">
                <img src="{{ public_path('images/saludsonrisa completo.jpg') }}" style="width: 100%;" onerror="this.style.display='none'">
            </div>
        </div>
        
        <div class="divider"></div>
        
        {{-- Título --}}
        <div class="ticket-title">
            ORDEN DE SERVICIO
        </div>
        
        {{-- Número de orden en caja --}}
        <div class="order-box">
            {{ $order->order_number }} - {{ $order->order_date->format('d/m/Y') }}
        </div>
        
        <div class="divider"></div>
        
        {{-- Información del paciente --}}
        <div class="info-section">
            <div class="name-field">
                <span class="label">NOMBRE:</span><br>
                {{ strtoupper($order->patient->name) }}
            </div>
            
            <div class="info-line">
                <span class="label">C.I.</span> {{ $order->patient->cedula }}
            </div>
            
            <div class="info-line">
                <span class="label">SEXO:</span> {{ strtoupper($order->patient->sexo ?? 'M') }}
                &nbsp;&nbsp;
                <span class="label">EDAD:</span> {{ $order->patient->edad ?? 'N/A' }} AÑOS
            </div>
            
            <div class="info-line">
                <span class="label">TELF:</span> {{ $order->patient->telefono ?? 'N/A' }}
            </div>
        </div>
        
        <div class="divider"></div>
        
        {{-- Lista de exámenes --}}
        <div class="exams-section">
            @foreach($order->details as $detail)
                <div class="exam-item">{{ strtoupper($detail->exam->name) }}</div>
            @endforeach
        </div>
        
        <div class="divider"></div>
        
        {{-- Footer --}}
        <div class="footer">
            Gracias por confiar en {{ $order->clinica->nombre ?? 'SaludSonrisa' }}<br>
            Este ticket es válido para la toma de muestra<br>
            {{ now()->format('d/m/Y h:i A') }}
        </div>
    </div>
</body>
</html>
