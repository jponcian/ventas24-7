<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>{{ config('app.name', 'SomosSalud') }} — Acceso</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
        integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA=="
        crossorigin="anonymous" referrerpolicy="no-referrer">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            overflow-x: hidden;
        }
        
        /* Fondo animado con gradiente - Colores corporativos: Azul y Verde */
        .auth-bg {
            background: linear-gradient(135deg, #0ea5e9 0%, #06b6d4 25%, #10b981 50%, #14b8a6 75%, #22c55e 100%);
            background-size: 400% 400%;
            animation: gradientShift 15s ease infinite;
            position: relative;
            overflow: hidden;
        }
        
        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        
        /* Partículas flotantes */
        .auth-bg::before {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            background-image: 
                radial-gradient(circle at 20% 50%, rgba(255, 255, 255, 0.12) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(255, 255, 255, 0.12) 0%, transparent 50%),
                radial-gradient(circle at 40% 20%, rgba(255, 255, 255, 0.1) 0%, transparent 50%);
            animation: float 20s ease-in-out infinite;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }
        
        /* Contenedor de contenido con glassmorphism */
        .auth-content {
            position: relative;
            z-index: 10;
        }
        
        .brand-section {
            padding: 3rem;
            color: white;
            position: relative;
            z-index: 1;
        }
        
        .brand-logo {
            background: rgba(255, 255, 255, 0.18);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.25);
            border-radius: 20px;
            padding: 1.5rem 2rem;
            display: inline-block;
            animation: fadeInUp 0.6s ease-out;
            box-shadow: 0 8px 32px rgba(14, 165, 233, 0.2);
        }
        
        .brand-title {
            font-size: 3rem;
            font-weight: 700;
            margin-top: 2rem;
            margin-bottom: 1rem;
            animation: fadeInUp 0.6s ease-out 0.1s backwards;
            background: linear-gradient(to right, #fff, rgba(255,255,255,0.85));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-shadow: 0 2px 20px rgba(255, 255, 255, 0.1);
        }
        
        .brand-subtitle {
            font-size: 1.25rem;
            opacity: 0.95;
            line-height: 1.6;
            animation: fadeInUp 0.6s ease-out 0.2s backwards;
        }
        
        .feature-list {
            margin-top: 2.5rem;
            animation: fadeInUp 0.6s ease-out 0.3s backwards;
        }
        
        .feature-item {
            display: flex;
            align-items: center;
            padding: 1rem;
            margin-bottom: 0.75rem;
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.18);
            transition: all 0.3s ease;
        }
        
        .feature-item:hover {
            background: rgba(255, 255, 255, 0.18);
            transform: translateX(10px);
            box-shadow: 0 4px 20px rgba(16, 185, 129, 0.2);
        }
        
        .feature-icon {
            width: 40px;
            height: 40px;
            background: rgba(255, 255, 255, 0.25);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            font-size: 1.1rem;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* Formulario con glassmorphism mejorado */
        .form-section {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 2rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .auth-card {
            background: white;
            border-radius: 24px;
            padding: 2.5rem;
            box-shadow: 0 20px 60px rgba(14, 165, 233, 0.12);
            border: 1px solid rgba(14, 165, 233, 0.08);
            animation: fadeInUp 0.6s ease-out 0.2s backwards;
            width: 100%;
        }
        
        .auth-card-header {
            margin-bottom: 2rem;
        }
        
        .auth-card h1 {
            font-size: 1.75rem;
            font-weight: 700;
            background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
        }
        
        .auth-card-subtitle {
            color: #64748b;
            font-size: 0.95rem;
        }
        
        .brand-pill {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%);
            color: white;
            font-size: 0.75rem;
            font-weight: 600;
            padding: 0.5rem 1rem;
            border-radius: 50px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 15px rgba(14, 165, 233, 0.35);
        }
        
        /* Inputs mejorados */
        .form-label {
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }
        
        .form-control {
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background: #f8fafc;
        }
        
        .form-control:focus {
            background: white;
            border-color: #0ea5e9;
            box-shadow: 0 0 0 4px rgba(14, 165, 233, 0.12);
            outline: none;
        }
        
        .form-control::placeholder {
            color: #94a3b8;
        }
        
        /* Botón principal mejorado - Gradiente Azul a Verde */
        .btn-primary {
            background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%);
            border: none;
            border-radius: 12px;
            padding: 0.875rem 1.5rem;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(14, 165, 233, 0.35);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(14, 165, 233, 0.45);
            background: linear-gradient(135deg, #0284c7 0%, #059669 100%);
        }
        
        .btn-primary:active {
            transform: translateY(0);
        }
        
        .btn-outline-secondary {
            border: 2px solid #e2e8f0;
            background: white;
            border-radius: 0 12px 12px 0;
            border-left: none;
            transition: all 0.3s ease;
            color: #64748b;
        }
        
        .btn-outline-secondary:hover {
            background: #f8fafc;
            border-color: #cbd5e0;
            color: #0ea5e9;
        }
        
        .input-group .form-control {
            border-radius: 12px 0 0 12px;
        }
        
        /* Enlaces */
        a {
            color: #0ea5e9;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }
        
        a:hover {
            color: #10b981;
        }
        
        /* Checkbox personalizado */
        .form-check-input {
            width: 1.25rem;
            height: 1.25rem;
            border: 2px solid #cbd5e0;
            border-radius: 6px;
            cursor: pointer;
        }
        
        .form-check-input:checked {
            background-color: #10b981;
            border-color: #10b981;
        }
        
        .form-check-label {
            cursor: pointer;
            color: #475569;
        }
        
        /* Alertas mejoradas */
        .alert {
            border-radius: 12px;
            border: none;
            padding: 1rem 1.25rem;
        }
        
        .alert-info {
            background: linear-gradient(135deg, #e0f2fe 0%, #d1fae5 100%);
            color: #0c4a6e;
            border-left: 4px solid #0ea5e9;
        }
        
        .invalid-feedback {
            font-size: 0.85rem;
            margin-top: 0.5rem;
            color: #ef4444;
        }
        
        /* Responsive */
        @media (max-width: 991px) {
            .brand-title {
                font-size: 2rem;
            }
            .auth-card {
                padding: 2rem 1.5rem;
            }
        }
        
        @media (max-width: 576px) {
            .auth-card {
                padding: 1.5rem 1rem;
            }
            .brand-section {
                padding: 2rem 1.5rem;
            }
        }
        
        /* Logo móvil */
        .mobile-logo {
            background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%);
            padding: 1rem;
            border-radius: 16px;
            display: inline-block;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(14, 165, 233, 0.3);
        }
    </style>
    @yield('head')
    @stack('head')
</head>
<body>
<div class="container-fluid min-vh-100 p-0">
    <div class="row g-0 min-vh-100">
        <!-- Lado marca con gradiente animado -->
        <div class="col-lg-6 d-none d-lg-flex auth-bg">
            <div class="brand-section d-flex flex-column justify-content-between w-100 auth-content">
                <div>
                    <div class="brand-logo">
                        <img src="{{ asset('images/logo.png') }}" alt="SomosSalud" style="height:60px;width:auto;">
                    </div>
                    <h1 class="brand-title">Bienvenido a<br>SomosSalud</h1>
                    <p class="brand-subtitle">Tu salud en las mejores manos. Gestiona tus citas, suscripciones y resultados de forma rápida y segura.</p>
                    
                    <div class="feature-list">
                        <div class="feature-item">
                            <div class="feature-icon">
                                <i class="fa-solid fa-shield-heart"></i>
                            </div>
                            <div>
                                <strong>Seguridad garantizada</strong><br>
                                <small style="opacity: 0.9;">Tus datos protegidos con encriptación de última generación</small>
                            </div>
                        </div>
                        <div class="feature-item">
                            <div class="feature-icon">
                                <i class="fa-solid fa-bolt"></i>
                            </div>
                            <div>
                                <strong>Acceso instantáneo</strong><br>
                                <small style="opacity: 0.9;">Consulta tu información médica en cualquier momento</small>
                            </div>
                        </div>
                        <div class="feature-item">
                            <div class="feature-icon">
                                <i class="fa-solid fa-mobile-screen-button"></i>
                            </div>
                            <div>
                                <strong>Multiplataforma</strong><br>
                                <small style="opacity: 0.9;">Diseño responsive adaptado a todos tus dispositivos</small>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div style="opacity: 0.7; font-size: 0.9rem;">
                    © {{ date('Y') }} SomosSalud. Todos los derechos reservados.
                </div>
            </div>
        </div>
        
        <!-- Lado formulario -->
        <div class="col-lg-6 form-section">
            <div class="w-100" style="max-width: 480px;">
                <div class="text-center d-lg-none">
                    <div class="mobile-logo">
                        <img src="{{ asset('images/logo.png') }}" alt="SomosSalud" style="height:50px;width:auto;">
                    </div>
                </div>
                @yield('content')
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
@stack('scripts')
</body>
</html>
