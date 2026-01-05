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

        .settings-card {
            background: white;
            border-radius: 1.5rem;
            border: none;
            box-shadow: var(--card-shadow);
            margin-bottom: 1.5rem;
            overflow: hidden;
            height: 100%;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .settings-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px -5px rgba(0, 0, 0, 0.1);
        }

        .settings-card .card-body {
            padding: 2rem;
        }

        .settings-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #f1f5f9;
        }
    </style>
    @endpush

    <div class="py-4">
        <div class="container">
            <!-- Header -->
            <div class="page-header-custom">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="h3 font-weight-bold mb-1" style="color: #0f172a;">Mi Perfil</h1>
                        <p class="text-muted mb-0">Actualiza tus datos personales y seguridad</p>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-12 col-lg-6">
                    <div class="settings-card">
                        <div class="card-body">
                            <h2 class="settings-title">
                                <i class="fas fa-user-circle text-primary me-2"></i>Información Personal
                            </h2>
                            @include('profile.partials.update-profile-information-form')
                        </div>
                    </div>
                </div>

                <div class="col-12 col-lg-6">
                    <div class="settings-card">
                        <div class="card-body">
                            <h2 class="settings-title">
                                <i class="fas fa-lock text-primary me-2"></i>Seguridad
                            </h2>
                            @include('profile.partials.update-password-form')
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</x-app-layout>