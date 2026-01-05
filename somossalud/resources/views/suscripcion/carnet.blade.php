<x-app-layout>
    <div class="container py-4">
        <style>
            /* Texto del carnet: ajuste fino más pequeño */
            .ss-label{font-size:.90rem;opacity:.75;letter-spacing:.5px}
            .ss-value{font-size:1.20rem;font-weight:600;line-height:1.2}
            @media (min-width: 768px){.ss-value{font-size:1.30rem}}
            /* QR responsivo y nítido */
            .ss-qr{position:absolute; right:3%; bottom:5%; width:min(22%, 190px)}
            .ss-qr .ss-qr-inner{background:#fff; border-radius:.25rem; padding:.25rem; box-shadow:0 .125rem .25rem rgba(0,0,0,.08)}
            .ss-qr svg{width:100% !important; height:auto !important; display:block}
        </style>
        <div class="row justify-content-center">
            <div class="col-lg-7">
                <div class="card shadow-sm overflow-hidden">
                    <div class="position-relative" style="background:#f8f9fa;">
                        <!-- Fondo del carnet anverso -->
                        <div class="ratio" style="--bs-aspect-ratio:65%;">
                            <div class="w-100 h-100 position-absolute" style="background:url('{{ asset('images/carnet_anverso.png') }}') center/cover no-repeat;">
                                @php
                                    // Coordenadas aproximadas basadas en el script GD (escala relativa 1000x650)
                                    // Original: numero (x=100,y=357), nombre (50,480), ced/telef (50,540)
                                    // QR: size=190; offsets: x from right 50, y from bottom 49
                                    $numAfiliado = str_pad((string)($suscripcion->numero ?? ''), 6, '0', STR_PAD_LEFT);
                                @endphp
                                    <div class="position-absolute" style="left:10%; top:49%; color:#fff; font-weight:700; font-size:1.58rem; letter-spacing:3px; text-shadow:0 1px 3px rgba(0,0,0,.6);">
                                    {{ $numAfiliado }}
                                </div>
                                <div class="position-absolute" style="left:5%; bottom:12%; right:38%; color:#fff; font-size:.95rem;">
                                    <div class="mb-2">
                                        <div class="ss-label">Nombre</div>
                                        <div class="ss-value" style="font-size:1.44rem;">{{ strtoupper($user->name) }}</div>
                                    </div>
                                    <div class="mb-2 d-flex flex-wrap align-items-center" style="gap:.75rem;">
                                        <div>
                                            <div class="ss-label">Cédula</div>
                                            <div class="ss-value">{{ $user->cedula }}</div>
                                        </div>
                                        <div>
                                            <div class="ss-label">Plan</div>
                                            <div class="ss-value">{{ strtoupper($suscripcion->plan) }}</div>
                                        </div>
                                        <div>
                                            <div class="ss-label">Vence</div>
                                            <div class="ss-value">{{ \Illuminate\Support\Carbon::parse($suscripcion->periodo_vencimiento)->format('d/m/Y') }}</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="ss-qr">
                                    @php
                                        $qrPayload = json_encode([
                                            'uid' => $user->id,
                                            'cedula' => $user->cedula,
                                            'vence' => \Illuminate\Support\Carbon::parse($suscripcion->periodo_vencimiento)->format('Y-m-d'),
                                        ]);
                                    @endphp
                                    <div class="ss-qr-inner">{!! QrCode::size(512)->margin(1)->generate($qrPayload) !!}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    {{-- En carnet digital usamos solo el frontal (anverso) --}}
                </div>
                <div class="mt-3 d-flex justify-content-between align-items-center">
                    <a href="{{ route('suscripcion.show') }}" class="btn btn-outline-success btn-sm">Volver</a>
                    <button class="btn btn-secondary btn-sm" onclick="window.print()"><i class="fa-solid fa-print me-1"></i>Imprimir</button>
                </div>
                <p class="text-muted small mt-2">Escanea el código QR para validar afiliación. Si los datos son incorrectos contacta soporte.</p>
                @php
                    $ratePrint = optional(\App\Models\ExchangeRate::latestEffective()->first());
                    $usdPrice = 10; // Precio fijo en USD
                    $bsEquiv = $ratePrint->rate ? number_format($usdPrice * $ratePrint->rate, 2, ',', '.') : null;
                @endphp
                <div class="alert alert-light border shadow-sm mt-3" role="alert" style="border-left:.35rem solid #0d6efd;">
                    <div class="d-flex align-items-start">
                        <div class="me-3 text-primary"><i class="fa-solid fa-id-card fa-lg"></i></div>
                        <div class="flex-grow-1">
                            <div class="fw-semibold">¿Quieres tu carnet físico?</div>
                            <div>
                                Precio: <span class="fw-bold">${{ $usdPrice }}</span>
                                @if($bsEquiv)
                                    <span class="text-muted">(aprox. {{ $bsEquiv }} Bs a la tasa actual)</span>
                                @else
                                    <span class="text-muted">(tasa no disponible)</span>
                                @endif
                                <br><small class="text-muted">El equivalente en Bs se calcula al momento de pagar.</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</x-app-layout>