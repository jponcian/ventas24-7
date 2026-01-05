<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>{{ config('app.name', 'SomosSalud') }}</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.bunny.net">
    <link href="https://fonts.bunny.net/css?family=figtree:400,500,600&display=swap" rel="stylesheet" />

    <!-- Scripts & estilos principales -->
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    <link rel="stylesheet" href="{{ asset('css/custom-menu.css') }}">

    <!-- Bootstrap 5 (preferido en todo el proyecto) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
        crossorigin="anonymous">

    <!-- Font Awesome 6 (iconos) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
        integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA=="
        crossorigin="anonymous" referrerpolicy="no-referrer">

    @stack('head')
    <style>
        body {
            background: linear-gradient(135deg, #e0f2fe 0%, #dcfce7 100%);
            background-attachment: fixed;
        }

        .decorative-icon {
            position: fixed;
            opacity: 0.1;
            pointer-events: none;
            z-index: -1;
        }

        .icon-1 {
            top: 10%;
            left: 5%;
            font-size: 150px;
            color: #0ea5e9;
            transform: rotate(-15deg);
        }

        .icon-2 {
            bottom: 15%;
            right: 5%;
            font-size: 180px;
            color: #10b981;
            transform: rotate(15deg);
        }

        /* Ensure content is above icons */
        .min-h-screen {
            position: relative;
            background-color: transparent !important;
        }
    </style>
</head>

<body class="font-sans antialiased">
    <div class="min-h-screen d-flex flex-column relative">
        <i class="fas fa-heartbeat decorative-icon icon-1"></i>
        <i class="fas fa-stethoscope decorative-icon icon-2"></i>
        @include('layouts.navigation')

        <!-- Page Heading -->
        @isset($header)
            <header class="bg-white shadow">
                <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
                    {{ $header }}
                </div>
            </header>
        @endisset

        <!-- Page Content -->
        <main class="flex-grow-1">
            {{ $slot ?? '' }}
        </main>

        @php
            $__rate = optional(\App\Models\ExchangeRate::latestEffective()->first());
        @endphp
        <footer
            class="main-footer border-top bg-white small d-flex justify-content-between align-items-center flex-wrap py-2 px-3 mt-auto"
            style="min-height:auto;">
            <div class="text-muted my-1">
                <strong>© {{ date('Y') }} SomosSalud.</strong>
                <span class="d-none d-sm-inline"> Plataforma de pacientes.</span>
            </div>
            <div class="text-muted my-1">
                @if($__rate && $__rate->rate)
                    Tasa BCV: <strong>{{ number_format((float) $__rate->rate, 2, ',', '.') }} Bs</strong> •
                    {{ $__rate->date?->format('d/m/Y') }}
                @else
                    Tasa no disponible
                @endif
            </div>
            <div class="text-muted my-1">
                <span class="d-none d-sm-inline">Versión 1.0.0</span>
            </div>
        </footer>
    </div>

    <!-- Bootstrap JS bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
        crossorigin="anonymous"></script>

    @stack('scripts')
</body>

</html>