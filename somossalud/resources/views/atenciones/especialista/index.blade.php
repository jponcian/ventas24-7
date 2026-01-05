@extends('layouts.adminlte')

@section('title','Mis atenciones | Especialista')

@section('content')
<div class="card shadow-sm">
    <div class="card-header d-flex flex-column flex-md-row justify-content-between align-items-md-center">
        <h5 class="card-title mb-2 mb-md-0">
            <i class="fas fa-briefcase-medical text-primary"></i>
            Mis atenciones asignadas
        </h5>
        <form method="GET" action="{{ route('atenciones.index') }}" class="form-inline small">
            <select name="estado" class="form-control form-control-sm mr-1" onchange="this.form.submit()" style="border-radius: 6px;">
                <option value="">Estado</option>
                @foreach(['validado'=>'Validada','en_consulta'=>'En proceso','cerrado'=>'Cerrada'] as $estado => $label)
                    <option value="{{ $estado }}" {{ request('estado')===$estado?'selected':'' }}>{{ $label }}</option>
                @endforeach
            </select>
            <button class="btn btn-primary btn-sm shadow-sm" type="submit"><i class="fas fa-filter mr-1"></i> Filtrar</button>
        </form>
    </div>
    @php
        $yo = auth()->user();
        $conteosEstados = \App\Models\Atencion::where('medico_id',$yo->id)
            ->selectRaw("estado, count(*) as total")
            ->groupBy('estado')->pluck('total','estado');
        $totalAsignadas = array_sum($conteosEstados->toArray());
    @endphp
    <div class="card-body pt-2">
        <div class="mb-3">
            <div class="small d-flex flex-wrap align-items-center">
                <span class="mr-3">Total: <strong>{{ $totalAsignadas }}</strong></span>
                <span class="mr-3">Validada: <span class="badge badge-info">{{ $conteosEstados['validado'] ?? 0 }}</span></span>
                <span class="mr-3">En proceso: <span class="badge badge-warning">{{ $conteosEstados['en_consulta'] ?? 0 }}</span></span>
                <span class="mr-3">Cerrada: <span class="badge badge-success">{{ $conteosEstados['cerrado'] ?? 0 }}</span></span>
            </div>
        </div>
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead>
                    <tr>
                        <th style="width:55px">#</th>
                        <th>Paciente</th>
                        <th>Seguro</th>
                        <th>Estado</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                @forelse($atenciones as $idx => $a)
                    <tr class="align-middle">
                        <td class="text-muted">{{ ($atenciones->currentPage()-1)*$atenciones->perPage() + $idx + 1 }}<span class="d-none" data-atencion-id="{{ $a->id }}"></span></td>
                        <td>
                            <div class="font-weight-semibold">{{ optional($a->paciente)->name ?? '—' }}</div>
                        </td>
                        <td>
                            @if($a->seguro_validado)
                                <span class="badge badge-success">Validado</span>
                            @else
                                <span class="badge badge-secondary">Pendiente</span>
                            @endif
                            @if($a->aseguradora)
                                <div class="small text-muted">{{ $a->aseguradora }} @if($a->numero_seguro) • {{ $a->numero_seguro }} @endif</div>
                            @endif
                        </td>
                        <td>
                            @php
                                $labelEstado = match($a->estado){
                                    'validado' => 'Validada',
                                    'en_consulta' => 'En proceso',
                                    'cerrado' => 'Cerrada',
                                    default => ucfirst($a->estado),
                                };
                                $badgeClass = match($a->estado){
                                    'validado' => 'badge-info',
                                    'en_consulta' => 'badge-warning',
                                    'cerrado' => 'badge-success',
                                    default => 'badge-light'
                                };
                            @endphp
                            <span class="badge {{ $badgeClass }} px-2 py-1">{{ $labelEstado }}</span>
                        </td>
                        <td class="text-right">
                            @if($a->estado==='cerrado')
                                <a href="{{ route('atenciones.gestion', $a) }}" class="btn btn-sm btn-outline-secondary" title="Atención cerrada (solo lectura)">
                                    <i class="fas fa-eye mr-1"></i> Ver
                                </a>
                            @else
                                <a href="{{ route('atenciones.gestion', $a) }}" class="btn btn-sm btn-primary">
                                    <i class="fas fa-stethoscope mr-1"></i> Gestionar
                                </a>
                            @endif
                        </td>
                    </tr>
                @empty
                    <tr><td colspan="4" class="text-center text-muted small">Sin atenciones asignadas</td></tr>
                @endforelse
                </tbody>
            </table>
        </div>
        <div class="d-flex justify-content-center">
            {{ $atenciones->links() }}
        </div>
    </div>
</div>
@endsection

@push('styles')
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
    body { font-family: 'Outfit', sans-serif !important; background-color: #f8fafc; }
    .content-wrapper { background-color: #f8fafc !important; }
    .card { border: none; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03); transition: all 0.3s ease; background: white; overflow: hidden; }
    .card:hover { box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05); }
    .card-header { background: linear-gradient(135deg, #dbeafe 0%, #dcfce7 100%); border-bottom: 1px solid #cbd5e1; padding: 1.25rem 1.5rem; }
    .card-title { font-weight: 600; color: #1e293b; font-size: 1.1rem; display: flex; align-items: center; gap: 0.5rem; }
    .table thead th { border-bottom: 2px solid #e2e8f0; color: #64748b; font-weight: 600; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; padding: 1rem; background: #f8fafc; border-top: none; }
    .table tbody td { padding: 1rem; vertical-align: middle; border-top: 1px solid #f1f5f9; }
    .badge { padding: 0.5em 0.8em; border-radius: 6px; font-weight: 500; }
    .btn-sm { border-radius: 6px; padding: 0.25rem 0.5rem; font-size: 0.875rem; }
    .font-weight-semibold{ font-weight:600; }
</style>
@endpush
