@extends('layouts.adminlte')
@section('title','Mis atenciones | Paciente')
@section('content')
<div class="container-fluid py-3">
    <h1 class="h5 mb-3">Mis atenciones (seguro / guardia)</h1>
    <div class="alert alert-info small d-flex align-items-center mb-3" style="display:none" id="flashBienvenida">
        <i class="fa fa-heartbeat me-2"></i> Aquí verás el historial de procesos gestionados por tu seguro.
    </div>
    @if(session('success'))
        <div class="alert alert-success small">{{ session('success') }}</div>
    @endif
    <div class="card shadow-sm">
        <div class="card-body p-0">
            <form method="GET" action="{{ route('atenciones.index') }}" class="p-3 border-bottom small d-flex flex-wrap gap-2 align-items-end">
                <div>
                    <label class="form-label mb-1">Estado</label>
                    <select name="estado" class="form-select form-select-sm">
                        <option value="">Todos</option>
                        <option value="validado" @selected(request('estado')==='validado')>Validada</option>
                        <option value="en_consulta" @selected(request('estado')==='en_consulta')>En proceso</option>
                        <option value="cerrado" @selected(request('estado')==='cerrado')>Cerrada</option>
                    </select>
                </div>
                <div>
                    <button class="btn btn-sm btn-primary"><i class="fa fa-filter me-1"></i> Filtrar</button>
                </div>
            </form>
            <div class="table-responsive">
                <table class="table table-sm mb-0">
                    <thead class="table-light small text-uppercase text-muted">
                        <tr>
                            <th>Fecha</th>
                            <th>Estado</th>
                            <th>Médico</th>
                            <th>Aseguradora</th>
                            <th class="text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                    @forelse($atenciones as $a)
                        @php
                            $badge = match($a->estado){
                                'validado' => 'info',
                                'en_consulta' => 'warning',
                                'cerrado' => 'success',
                                default => 'secondary'
                            };
                            $label = match($a->estado){
                                'validado' => 'Validada',
                                'en_consulta' => 'En proceso',
                                'cerrado' => 'Cerrada',
                                default => ucfirst($a->estado)
                            };
                        @endphp
                        <tr class="align-middle">
                            <td class="small">{{ $a->iniciada_at? $a->iniciada_at->format('d/m/Y H:i') : $a->created_at->format('d/m/Y H:i') }}</td>
                            <td class="small"><span class="badge text-bg-{{ $badge }}">{{ $label }}</span></td>
                            <td class="small">{{ optional($a->medico)->name ?? '—' }}</td>
                            <td class="small">@if($a->aseguradora) <span class="text-nowrap">{{ $a->aseguradora }} @if($a->numero_seguro) <span class="text-muted">• {{ $a->numero_seguro }}</span> @endif</span> @else — @endif</td>
                            <td class="text-end small">
                                @if($a->estado==='cerrado')
                                    <a href="{{ route('atenciones.gestion', $a) }}" class="btn btn-outline-secondary btn-sm" title="Ver detalle"><i class="fa fa-eye"></i></a>
                                @else
                                    <span class="text-muted">En curso</span>
                                @endif
                            </td>
                        </tr>
                    @empty
                        <tr><td colspan="5" class="text-center text-muted py-4 small">No tienes atenciones registradas.</td></tr>
                    @endforelse
                    </tbody>
                </table>
            </div>
            <div class="p-2 border-top small">
                {{ $atenciones->links() }}
            </div>
        </div>
    </div>
    <p class="small text-muted mt-3">Las atenciones se generan cuando tu seguro es validado y eres atendido por un especialista en guardia.</p>
</div>
@endsection
@push('scripts')
<script>
document.addEventListener('DOMContentLoaded',()=>{
    const el = document.getElementById('flashBienvenida');
    if(el){ el.style.display='flex'; setTimeout(()=>{ el.classList.add('fade'); el.style.opacity='0'; setTimeout(()=> el.remove(),600); }, 3000); }
});
</script>
@endpush
