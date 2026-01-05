@extends('layouts.adminlte')

@section('title', 'Validación de pagos')

@section('sidebar')
    @include('panel.partials.sidebar')
@endsection

@push('scripts')
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        $(function () {
            // Toast de resultado tras acciones
            @if(session('success'))
            Swal.fire({
                icon: 'success',
                title: @json(session('success')),
                toast: true,
                position: 'top-end',
                showConfirmButton: false,
                timer: 2500,
                timerProgressBar: true
            });
            @endif
            @if(session('error'))
            Swal.fire({
                icon: 'error',
                title: @json(session('error')),
                toast: true,
                position: 'top-end',
                showConfirmButton: false,
                timer: 3000,
                timerProgressBar: true
            });
            @endif

            $('form.js-approve').on('submit', function (e) {
                e.preventDefault();
                const form = this;
                const paciente = $(form).data('paciente') || '';
                const ref = $(form).data('ref') || '';
                Swal.fire({
                    title: 'Aprobar pago',
                    html: `¿Confirmas aprobar el pago ${ref ? 'ref <b>' + ref + '</b>' : ''}${paciente ? ' de <b>' + paciente + '</b>' : ''}?`,
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonText: 'Sí, aprobar',
                    cancelButtonText: 'Cancelar'
                }).then((result) => {
                    if (result.isConfirmed) {
                        form.submit();
                    }
                });
            });

            $('form.js-reject').on('submit', function (e) {
                e.preventDefault();
                const form = this;
                const paciente = $(form).data('paciente') || '';
                const ref = $(form).data('ref') || '';
                const prev = $(form).find('input[name="observaciones"]').val() || '';
                Swal.fire({
                    title: 'Rechazar pago',
                    html: `${ref ? 'Ref <b>' + ref + '</b>' : ''}${paciente ? ' — <b>' + paciente + '</b>' : ''}`,
                    input: 'textarea',
                    inputLabel: 'Motivo de rechazo',
                    inputPlaceholder: 'Escribe el motivo...',
                    inputValue: prev,
                    inputAttributes: { 'aria-label': 'Motivo de rechazo' },
                    showCancelButton: true,
                    confirmButtonText: 'Rechazar',
                    cancelButtonText: 'Cancelar',
                    preConfirm: (value) => {
                        if (!value) {
                            Swal.showValidationMessage('Indica un motivo para continuar');
                        }
                        return value;
                    }
                }).then((result) => {
                    if (result.isConfirmed) {
                        let obs = $(form).find('input[name="observaciones"]');
                        if (!obs.length) {
                            obs = $('<input>').attr({ type: 'hidden', name: 'observaciones' });
                            $(form).append(obs);
                        }
                        obs.val(result.value);
                        form.submit();
                    }
                });
            });
        });
    </script>
@endpush

{{-- Breadcrumb removido para módulo de pagos en recepción --}}

@section('content')
    <div class="card shadow-sm border-0 rounded-lg overflow-hidden">
        <div class="card-header border-0 d-flex justify-content-between align-items-center" style="background: linear-gradient(135deg, #dbeafe 0%, #dcfce7 100%); border-bottom: 1px solid #cbd5e1;">
            <h3 class="card-title font-weight-bold text-primary mb-0">
                <i class="fas fa-file-invoice-dollar mr-2"></i> Validación de Pagos
            </h3>
            <div class="d-flex align-items-center">
                <form method="GET" class="form-inline mr-3">
                    <label class="mr-2 text-muted small font-weight-bold text-uppercase">Filtrar por:</label>
                    <select name="estado" class="custom-select custom-select-sm border-0 shadow-sm bg-white text-dark font-weight-bold" onchange="this.form.submit()" style="min-width: 140px;">
                        @foreach (['pendiente' => 'Pendientes', 'aprobado' => 'Aprobados', 'rechazado' => 'Rechazados'] as $k => $v)
                            <option value="{{ $k }}" {{ $estado === $k ? 'selected' : '' }}>{{ $v }}</option>
                        @endforeach
                    </select>
                </form>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0 align-middle">
                    <thead style="background-color: #f8fafc;">
                        <tr>
                            <th class="border-top-0 text-uppercase text-secondary small font-weight-bold pl-4">Paciente</th>
                            <th class="border-top-0 text-uppercase text-secondary small font-weight-bold">Detalles Pago</th>
                            <th class="border-top-0 text-uppercase text-secondary small font-weight-bold">Monto</th>
                            <th class="border-top-0 text-uppercase text-secondary small font-weight-bold">Estado</th>
                            <th class="border-top-0 text-uppercase text-secondary small font-weight-bold">Revisión</th>
                            <th class="border-top-0 text-uppercase text-secondary small font-weight-bold text-right pr-4">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($reportes as $reporte)
                            <tr>
                                <td class="pl-4">
                                    <div class="d-flex align-items-center">
                                        <div class="rounded-circle bg-light d-flex align-items-center justify-content-center mr-3 text-primary font-weight-bold" style="width: 40px; height: 40px;">
                                            {{ substr($reporte->usuario->name, 0, 1) }}
                                        </div>
                                        <div>
                                            <div class="font-weight-bold text-dark">{{ $reporte->usuario->name }}</div>
                                            <div class="small text-muted">CI: {{ $reporte->cedula_pagador }}</div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="small">
                                        <div class="text-dark font-weight-bold">Ref: {{ $reporte->referencia }}</div>
                                        <div class="text-muted">{{ optional($reporte->fecha_pago)->format('d/m/Y') }} · {{ $reporte->telefono_pagador }}</div>
                                    </div>
                                </td>
                                <td>
                                    <span class="font-weight-bold text-dark" style="font-size: 1.05rem;">{{ number_format($reporte->monto, 2, ',', '.') }} Bs</span>
                                </td>
                                <td>
                                    @php
                                        $badgeClass = match($reporte->estado) {
                                            'pendiente' => 'badge-warning',
                                            'aprobado' => 'badge-success',
                                            'rechazado' => 'badge-danger',
                                            default => 'badge-secondary'
                                        };
                                        $iconClass = match($reporte->estado) {
                                            'pendiente' => 'fa-clock',
                                            'aprobado' => 'fa-check-circle',
                                            'rechazado' => 'fa-times-circle',
                                            default => 'fa-circle'
                                        };
                                    @endphp
                                    <span class="badge {{ $badgeClass }} px-3 py-2 rounded-pill">
                                        <i class="fas {{ $iconClass }} mr-1"></i> {{ ucfirst($reporte->estado) }}
                                    </span>
                                </td>
                                <td class="small">
                                    @if($reporte->estado !== 'pendiente')
                                        <div>
                                            <span class="d-block font-weight-bold text-dark">{{ optional($reporte->revisor)->name ?? 'Sistema' }}</span>
                                            <span class="text-muted">{{ optional($reporte->reviewed_at)->format('d/m H:i') }}</span>
                                            @if($reporte->estado === 'rechazado' && $reporte->observaciones)
                                                <div class="mt-1 text-danger bg-light rounded px-2 py-1 border border-light" style="max-width: 150px;">
                                                    {{ Str::limit($reporte->observaciones, 40) }}
                                                </div>
                                            @endif
                                        </div>
                                    @else
                                        <span class="text-muted font-italic">En espera</span>
                                    @endif
                                </td>
                                <td class="text-right pr-4">
                                    @if($reporte->estado === 'pendiente')
                                        <div class="btn-group">
                                            <form action="{{ route('recepcion.pagos.aprobar', $reporte) }}" method="POST"
                                                class="d-inline js-approve" data-paciente="{{ $reporte->usuario->name }}" data-ref="{{ $reporte->referencia }}">
                                                @csrf
                                                <button class="btn btn-success btn-sm font-weight-bold shadow-sm rounded-left" type="submit" title="Aprobar">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                            </form>
                                            <form action="{{ route('recepcion.pagos.rechazar', $reporte) }}" method="POST"
                                                class="d-inline js-reject" data-paciente="{{ $reporte->usuario->name }}" data-ref="{{ $reporte->referencia }}">
                                                @csrf
                                                <input type="hidden" name="observaciones" value="Datos inconsistentes">
                                                <button class="btn btn-danger btn-sm font-weight-bold shadow-sm rounded-right" type="submit" title="Rechazar">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </form>
                                        </div>
                                    @else
                                        <span class="text-muted small"><i class="fas fa-lock"></i></span>
                                    @endif
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="6" class="text-center py-5">
                                    <div class="text-muted">
                                        <i class="fas fa-inbox fa-3x mb-3 opacity-50"></i>
                                        <p class="mb-0 font-weight-bold">No hay reportes encontrados</p>
                                        <small>Intenta cambiar el filtro de estado</small>
                                    </div>
                                </td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>
        @if ($reportes->hasPages())
            <div class="card-footer clearfix">
                {{ $reportes->links() }}
            </div>
        @endif
    </div>
@endsection

{{-- Botón de Ayuda Contextual --}}
<x-help-button title="Validar Pagos - Ayuda Rápida" :helpLink="route('help.show', 'validar-pagos')">
    <div class="help-quick-guide">
        <h5 class="text-primary"><i class="fas fa-lightbulb mr-2"></i> Guía Rápida: Validar Pagos</h5>
        
        <h6 class="font-weight-bold mt-3"><i class="fas fa-filter text-info mr-2"></i> Filtrar</h6>
        <p class="small">Usa el selector superior para filtrar por:</p>
        <ul class="small">
            <li><span class="badge badge-warning">Pendientes</span> - Esperan revisión</li>
            <li><span class="badge badge-success">Aprobados</span> - Validados</li>
            <li><span class="badge badge-danger">Rechazados</span> - Con errores</li>
        </ul>

        <h6 class="font-weight-bold mt-3"><i class="fas fa-check text-success mr-2"></i> Aprobar</h6>
        <ol class="small">
            <li>Verifica referencia, monto y datos</li>
            <li>Haz clic en <button class="btn btn-success btn-sm"><i class="fas fa-check"></i></button></li>
            <li>Confirma la acción</li>
        </ol>

        <h6 class="font-weight-bold mt-3"><i class="fas fa-times text-danger mr-2"></i> Rechazar</h6>
        <ol class="small">
            <li>Haz clic en <button class="btn btn-danger btn-sm"><i class="fas fa-times"></i></button></li>
            <li>Escribe el <strong>motivo del rechazo</strong> (obligatorio)</li>
            <li>Confirma</li>
        </ol>

        <div class="callout callout-warning mt-3">
            <h6><i class="fas fa-exclamation-triangle mr-2"></i> Importante</h6>
            <p class="small mb-0">Una vez aprobado o rechazado, el estado <strong>no se puede cambiar</strong>. Revisa bien antes de confirmar.</p>
        </div>
    </div>
</x-help-button>
