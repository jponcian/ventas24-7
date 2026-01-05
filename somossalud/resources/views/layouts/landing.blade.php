<!doctype html>
<html lang="es">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">


    <!-- SEO Meta Tags -->
    <title>@yield('title', 'Clínica SaludSonrisa | Atención Médica y Odontológica en Venezuela | SomosSalud')</title>
    <meta name="description"
        content="@yield('description', 'Clínica SaludSonrisa ofrece atención médica integral, odontología, pediatría y laboratorio clínico. Agenda citas online, consulta resultados y accede a descuentos con SomosSalud. Atención 24/7 en Venezuela.')">

    <!-- Palabras clave optimizadas para búsqueda local -->
    <meta name="keywords"
        content="clínica venezuela, salud sonrisa, saludsonrisa, clínica saludsonrisa, clínica salud sonrisa, odontología venezuela, pediatría venezuela, laboratorio clínico, citas médicas online, resultados de laboratorio online, atención médica 24 horas, consultas médicas, dentista venezuela, médico pediatra, exámenes de laboratorio, descuentos médicos, salud familiar venezuela, somossalud, clínica familiar, atención odontológica, servicios médicos, centro médico venezuela, somossalud, somos salud, somos salud venezuela">

    <meta name="author" content="Clínica SaludSonrisa">
    <meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">
    <meta name="googlebot" content="index, follow">

    <!-- Geo Tags para búsqueda local -->
    <meta name="geo.region" content="VE">
    <meta name="geo.placename" content="Venezuela">
    <meta name="geo.position" content="10.4806;-66.9036">
    <meta name="ICBM" content="10.4806, -66.9036">

    <!-- Idioma y localización -->
    <meta http-equiv="content-language" content="es-VE">
    <link rel="alternate" hreflang="es-ve" href="{{ url('/') }}">
    <link rel="alternate" hreflang="es" href="{{ url('/') }}">

    <!-- Open Graph / Facebook (Mejorado) -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="{{ url('/') }}">
    <meta property="og:site_name" content="Clínica SaludSonrisa">
    <meta property="og:title"
        content="@yield('og_title', 'Clínica SaludSonrisa | Atención Médica Integral en Venezuela')">
    <meta property="og:description"
        content="@yield('og_description', 'Tu salud y la de tu familia en las mejores manos. Agenda citas, consulta resultados de laboratorio y accede a descuentos exclusivos.')">
    <meta property="og:image" content="{{ asset('images/logo.png') }}">
    <meta property="og:image:width" content="1200">
    <meta property="og:image:height" content="630">
    <meta property="og:locale" content="es_VE">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="@yield('twitter_title', 'Clínica SaludSonrisa | Atención Médica en Venezuela')">
    <meta name="twitter:description"
        content="@yield('twitter_description', 'Agenda citas médicas, consulta resultados de laboratorio y accede a atención 24/7')">
    <meta name="twitter:image" content="{{ asset('images/logo.png') }}">

    <!-- Canonical URL -->
    <link rel="canonical" href="{{ url()->current() }}">

    <!-- Datos Estructurados JSON-LD para Google -->
    <script type="application/ld+json">
    {
      "@@context": "https://schema.org",
      "@type": "MedicalClinic",
      "name": "Clínica SaludSonrisa",
      "description": "Clínica médica integral con servicios de odontología, pediatría y laboratorio clínico en Venezuela",
      "url": "{{ url('/') }}",
      "logo": "{{ asset('images/logo.png') }}",
      "image": "{{ asset('images/logo.png') }}",
      "telephone": "+58-246-871-6474",
      "email": "alianzas@clinicasaludsonrisa.com.ve",
      "address": {
        "@type": "PostalAddress",
        "addressCountry": "VE",
        "addressLocality": "Venezuela"
      },
      "openingHoursSpecification": {
        "@type": "OpeningHoursSpecification",
        "dayOfWeek": [
          "Monday",
          "Tuesday",
          "Wednesday",
          "Thursday",
          "Friday",
          "Saturday",
          "Sunday"
        ],
        "opens": "00:00",
        "closes": "23:59"
      },
      "medicalSpecialty": [
        "Odontología",
        "Pediatría",
        "Medicina General",
        "Laboratorio Clínico"
      ],
      "priceRange": "$$",
      "availableService": [
        {
          "@type": "MedicalProcedure",
          "name": "Consultas Médicas"
        },
        {
          "@type": "MedicalProcedure",
          "name": "Atención Odontológica"
        },
        {
          "@type": "MedicalTest",
          "name": "Exámenes de Laboratorio"
        },
        {
          "@type": "MedicalProcedure",
          "name": "Pediatría"
        }
      ],
      "potentialAction": {
        "@type": "ReserveAction",
        "target": {
          "@type": "EntryPoint",
          "urlTemplate": "{{ route('register') }}",
          "actionPlatform": [
            "http://schema.org/DesktopWebPlatform",
            "http://schema.org/MobileWebPlatform"
          ]
        },
        "result": {
          "@type": "Reservation",
          "name": "Agendar Cita Médica"
        }
      }
    }
    </script>

    <!-- Organización Schema -->
    <script type="application/ld+json">
    {
      "@@context": "https://schema.org",
      "@type": "Organization",
      "name": "SomosSalud",
      "alternateName": "Clínica SaludSonrisa",
      "url": "{{ url('/') }}",
      "logo": "{{ asset('images/logo.png') }}",
      "contactPoint": {
        "@type": "ContactPoint",
        "telephone": "+58-246-871-6474",
        "contactType": "customer service",
        "areaServed": "VE",
        "availableLanguage": "Spanish"
      },
      "sameAs": [
        "https://www.instagram.com/clinicasaludsonrisave/",
        "https://www.facebook.com/p/Clínica-SaludSonrisa-100089365696512/"
      ]
    }
    </script>

    <!-- Google Fonts: Outfit (Moderno y limpio) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
        crossorigin="anonymous">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
        integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />

    <!-- Favicon -->
    <link rel="icon" href="{{ asset('favicon.ico') }}">

    <style>
        :root {
            --primary-blue: #0056b3;
            /* Azul original */
            --primary-light: #e3f2fd;
            --accent-green: #28a745;
            /* Verde original */
            --accent-green-hover: #218838;
            --text-dark: #1e293b;
            --text-muted: #64748b;
            --bg-light: #f8fafc;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: 'Outfit', sans-serif;
            color: var(--text-dark);
            background-color: var(--bg-light);
            -webkit-font-smoothing: antialiased;
            padding-bottom: env(safe-area-inset-bottom);
        }

        /* Sobreescribir Bootstrap Colors para consistencia */
        .text-primary {
            color: var(--primary-blue) !important;
        }

        .bg-primary {
            background-color: var(--primary-blue) !important;
        }

        .text-success {
            color: var(--accent-green) !important;
        }

        .bg-success {
            background-color: var(--accent-green) !important;
        }

        /* Navbar Premium */
        .navbar {
            background-color: rgba(255, 255, 255, 0.95) !important;
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            padding: 1rem 0;
        }

        .navbar-brand img {
            height: 50px;
        }

        /* Hero Section Dinámico */
        .hero {
            /* Gradiente Azul a Verde original */
            background: linear-gradient(135deg, #0056b3 0%, #28a745 100%);
            position: relative;
            overflow: hidden;
            padding: 120px 0 100px;
            color: white;
            clip-path: polygon(0 0, 100% 0, 100% 95%, 0 100%);
        }

        /* Efecto de brillo/reflejo de luz */
        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 50%;
            height: 100%;
            background: linear-gradient(to right, rgba(255, 255, 255, 0) 0%, rgba(255, 255, 255, 0.2) 50%, rgba(255, 255, 255, 0) 100%);
            transform: skewX(-25deg);
            animation: shine 3s infinite linear;
            /* Movimiento continuo cada 3 segundos */
            pointer-events: none;
        }

        @keyframes shine {
            0% {
                left: -100%;
            }

            100% {
                left: 200%;
            }
        }

        /* Botones Modernos */
        .btn {
            border-radius: 50px;
            /* Pill shape */
            padding: 0.75rem 2rem;
            font-weight: 600;
            transition: all 0.3s ease;
            letter-spacing: 0.5px;
        }

        .btn-primary {
            background-color: var(--primary-blue);
            border: none;
            box-shadow: 0 4px 15px rgba(0, 86, 179, 0.3);
        }

        .btn-primary:hover {
            background-color: #004494;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 86, 179, 0.4);
        }

        .btn-success {
            background-color: var(--accent-green);
            border: none;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }

        .btn-success:hover {
            background-color: var(--accent-green-hover);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
        }

        .btn-outline-light:hover {
            background-color: white;
            color: var(--primary-blue);
        }

        .btn-outline-primary {
            color: var(--primary-blue);
            border-color: var(--primary-blue);
        }

        .btn-outline-primary:hover {
            background-color: var(--primary-blue);
            color: white;
        }

        /* Cards y Elementos */
        .insight-card {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .feature-icon {
            width: 60px;
            height: 60px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 16px;
            background: var(--primary-light);
            color: var(--primary-blue);
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }

        .badge-soft {
            background-color: rgba(255, 255, 255, 0.2);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 500;
            display: inline-block;
            margin-bottom: 1rem;
        }

        .hero-list li {
            margin-bottom: 0.8rem;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.05rem;
        }

        .hero-list i {
            color: #a3ffb8;
            /* Verde claro para iconos en fondo azul */
        }

        /* Footer */
        footer {
            background-color: white;
            border-top: 1px solid #e9ecef;
            color: var(--text-muted);
            padding: 2rem 0;
        }
    </style>

    @stack('head')
</head>

<body>
    @yield('content')

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
        crossorigin="anonymous"></script>


    @stack('scripts')
</body>

</html>