<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <style>
        body {
            font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
            background-color: #f8fafc;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #ffffff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            margin-top: 20px;
            margin-bottom: 20px;
        }
        .header {
            background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%);
            padding: 30px;
            text-align: center;
            color: white;
        }
        .logo {
            width: 80px;
            height: 80px;
            background: white;
            border-radius: 50%;
            margin: 0 auto 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        .logo img {
            max-width: 60px;
        }
        .content {
            padding: 30px;
            color: #334155;
            line-height: 1.6;
        }
        .footer {
            background-color: #f1f5f9;
            padding: 20px;
            text-align: center;
            font-size: 12px;
            color: #64748b;
        }
        .btn {
            display: inline-block;
            background-color: #0ea5e9;
            color: white;
            padding: 12px 24px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: bold;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">
                <img src="{{ asset('images/saludsonrisa.jpg') }}" alt="SaludSonrisa">
            </div>
            <h1 style="margin: 0; font-size: 24px;">¡Bienvenido a SaludSonrisa!</h1>
        </div>
        <div class="content">
            <p>Hola <strong>{{ $user->name }}</strong>,</p>
            
            <p>¡Bienvenido a <strong>SaludSonrisa</strong>! Nos complace enormemente que hayas decidido unirte a nuestra familia.</p>
            
            <p>Tu cuenta ha sido creada exitosamente y ya puedes disfrutar de todos nuestros servicios:</p>
            
            <ul style="line-height: 1.8; color: #475569;">
                <li>📅 Agendar citas médicas con nuestros especialistas</li>
                <li>📋 Consultar tu historial médico</li>
                <li>💊 Acceder a tus recetas y tratamientos</li>
                <li>🏥 Gestionar tu suscripción y beneficios</li>
            </ul>
            
            <p>Estamos aquí para cuidar de tu salud y la de tu familia. Si tienes alguna pregunta o necesitas ayuda, no dudes en contactarnos.</p>
            
            <div style="text-align: center;">
                <a href="{{ route('dashboard') }}" class="btn">Acceder a mi cuenta</a>
            </div>
            
            <p style="margin-top: 30px; font-size: 14px; color: #64748b;">
                <strong>Datos de tu cuenta:</strong><br>
                Usuario: {{ $user->email }}<br>
                Cédula: {{ $user->cedula ?? 'No especificada' }}
            </p>
        </div>
        <div class="footer">
            &copy; {{ date('Y') }} SaludSonrisa. Todos los derechos reservados.
        </div>
    </div>
</body>
</html>
