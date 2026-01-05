@extends('layouts.adminlte')

@section('title','Citas | SomosSalud')

{{-- Breadcrumb removido para ahorrar espacio vertical --}}

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
</style>
@endpush

@section('content')
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center flex-wrap">
            <h3 class="card-title mb-0"><i class="fas fa-calendar-alt text-primary"></i> Listado de citas</h3>
            @if(auth()->user()->hasRole('paciente'))
                <a href="{{ route('citas.create') }}" class="btn btn-primary btn-sm shadow-sm"><i class="fas fa-calendar-plus mr-1"></i> Nueva cita</a>
            @endif
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                    <tr>
                        <th>Fecha / Hora</th>
                        <th>Estado</th>
                        <th>Paciente</th>
                        <th>Especialista</th>
                        <th class="text-right">Acciones</th>
                    </tr>
                    </thead>
                <tbody>
                @forelse($citas as $cita)
                    <tr class="align-middle">
                        <td class="small">
                            @php($f = \Illuminate\Support\Carbon::parse($cita->fecha))
                            {{ $f->format('d/m/Y') }} {{ str_replace(' ', '', $f->format('h:i a')) }}
                        </td>
                        <td class="small">
                            <span class="badge badge-{{ $cita->estado_badge }}">{{ ucfirst($cita->estado) }}</span>
                        </td>
                        <td class="small">{{ optional($cita->usuario)->name ?? '—' }}</td>
                        <td class="small">{{ optional($cita->especialista)->name ?? '—' }}</td>
                        <td class="text-right text-nowrap">
                            @php($yo = auth()->user())
                            @if(($yo->id === $cita->especialista_id) || $yo->hasRole(['super-admin','admin_clinica']))
                                <a href="{{ route('citas.show', $cita) }}#gestion" class="btn btn-outline-primary btn-sm" title="Gestionar"><i class="fas fa-stethoscope"></i></a>
                            @else
                                <a href="{{ route('citas.show', $cita) }}" class="btn btn-outline-secondary btn-sm" title="Ver"><i class="fas fa-eye"></i></a>
                            @endif
                            @if($cita->medicamentos()->exists())
                                <a href="{{ route('citas.receta', $cita) }}" class="btn btn-outline-success btn-sm" title="Receta"><i class="fas fa-prescription-bottle-alt"></i></a>
                            @else
                                <button class="btn btn-outline-secondary btn-sm" title="Sin receta" disabled><i class="fas fa-prescription-bottle-alt"></i></button>
                            @endif
                            @if(!in_array($cita->estado,['cancelada','concluida']))
                                <form action="{{ route('citas.cancelar', $cita) }}" method="POST" class="d-inline js-cancel-cita" data-cita-id="{{ $cita->id }}">
                                    @csrf
                                    <button class="btn btn-outline-danger btn-sm" title="Cancelar"><i class="fas fa-ban"></i></button>
                                </form>
                            @endif
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="5" class="text-center py-4 text-muted small">No hay citas registradas.</td>
                    </tr>
                @endforelse
                </tbody>
            </table>
        </div>
    </div>
    <script>
    (function(){
        function ensureSwal(cb){ if(window.Swal) return cb(); const s=document.createElement('script'); s.src='https://cdn.jsdelivr.net/npm/sweetalert2@11'; s.onload=cb; document.head.appendChild(s); }
        function bind(){
            document.querySelectorAll('form.js-cancel-cita').forEach(f=>{
                if(f._swBound) return; f._swBound=true;
                f.addEventListener('submit', function(e){
                    e.preventDefault();
                    ensureSwal(()=>{
                        Swal.fire({
                            title:'Cancelar cita',
                            text:'¿Confirmas que deseas cancelar esta cita?',
                            icon:'warning',
                            showCancelButton:true,
                            confirmButtonText:'Sí, cancelar',
                            cancelButtonText:'No',
                            confirmButtonColor:'#d33'
                        }).then(r=>{ if(r.isConfirmed) f.submit(); });
                    });
                });
            });
        }
        bind();
    })();
    </script>
@endsection
