@extends('layouts.adminlte')

@section('title', 'SomosSalud | Mi disponibilidad')

@section('sidebar')
    @include('panel.partials.sidebar')
@endsection

{{-- Breadcrumb removido para disponibilidad de especialista --}}

@push('styles')
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
    body { font-family: 'Outfit', sans-serif !important; background-color: #f8fafc; }
    .content-wrapper { background-color: #f8fafc !important; }
    .card { border: none; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03); transition: all 0.3s ease; background: white; overflow: hidden; }
    .card:hover { box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05); }
    .card-header { background: linear-gradient(135deg, #dbeafe 0%, #dcfce7 100%); border-bottom: 1px solid #cbd5e1; padding: 1.25rem 1.5rem; }
    .card-title { font-weight: 600; color: #1e293b; font-size: 1.1rem; display: flex; align-items: center; gap: 0.5rem; }
    .form-control { border-radius: 8px; border: 2px solid #e2e8f0; padding: 0.5rem 1rem; }
    .form-control:focus { border-color: #0ea5e9; box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1); }
    .btn { border-radius: 8px; font-weight: 500; padding: 0.5rem 1.5rem; transition: all 0.2s ease; }
    .btn-primary { background: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%); border: none; box-shadow: 0 2px 8px rgba(14, 165, 233, 0.3); }
    .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(14, 165, 233, 0.4); }
    .table thead th { border-bottom: 2px solid #e2e8f0; color: #64748b; font-weight: 600; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; padding: 1rem; background: #f8fafc; border-top: none; }
    .table tbody td { padding: 1rem; vertical-align: middle; border-top: 1px solid #f1f5f9; }
    .badge { padding: 0.5em 0.8em; border-radius: 6px; font-weight: 500; }
</style>
@endpush

@section('content')
    <div class="row">
        <div class="col-lg-5">
            <div class="card mb-4">
                <div class="card-header">
                    <h3 class="card-title mb-0"><i class="fas fa-clock text-primary"></i> Agregar horario</h3>
                </div>
                <form action="{{ route('especialista.horarios.store') }}" method="POST">
                    @csrf
                    <div class="card-body">
                        @if ($errors->any())
                            <div class="alert alert-danger">
                                <p class="mb-2 font-weight-bold">Corrige los siguientes puntos:</p>
                                <ul class="mb-0 pl-3">
                                    @foreach ($errors->all() as $error)
                                        <li>{{ $error }}</li>
                                    @endforeach
                                </ul>
                            </div>
                        @endif
                        <div class="form-group">
                            <label for="dia_semana">Día de la semana</label>
                            <select name="dia_semana" id="dia_semana"
                                class="form-control @error('dia_semana') is-invalid @enderror" required>
                                <option value="">Selecciona un día</option>
                                @foreach ($diasSemana as $key => $label)
                                    <option value="{{ $key }}" {{ old('dia_semana') === $key ? 'selected' : '' }}>
                                        {{ $label }}
                                    </option>
                                @endforeach
                            </select>
                            @error('dia_semana')
                                <span class="invalid-feedback" role="alert">{{ $message }}</span>
                            @enderror
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="hora_inicio">Hora de inicio</label>
                                <input type="time" name="hora_inicio" id="hora_inicio" value="{{ old('hora_inicio') }}"
                                    class="form-control @error('hora_inicio') is-invalid @enderror" required>
                                @error('hora_inicio')
                                    <span class="invalid-feedback" role="alert">{{ $message }}</span>
                                @enderror
                            </div>
                            <div class="form-group col-md-6">
                                <label for="hora_fin">Hora de fin</label>
                                <input type="time" name="hora_fin" id="hora_fin" value="{{ old('hora_fin') }}"
                                    class="form-control @error('hora_fin') is-invalid @enderror" required>
                                @error('hora_fin')
                                    <span class="invalid-feedback" role="alert">{{ $message }}</span>
                                @enderror
                            </div>
                        </div>
                    </div>
                    <div class="card-footer d-flex justify-content-end">
                        <button type="submit" class="btn btn-primary">Guardar horario</button>
                    </div>
                </form>
            </div>
        </div>
        <div class="col-lg-7">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h3 class="card-title mb-0"><i class="fas fa-calendar-week text-success"></i> Horarios cargados</h3>
                    @if (session('status'))
                        <span class="badge badge-success">{{ session('status') }}</span>
                    @endif
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover mb-0">
                            <thead class="thead-light">
                                <tr>
                                    <th>Día</th>
                                    <th class="text-nowrap">Hora inicio</th>
                                    <th class="text-nowrap">Hora fin</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                @forelse ($disponibilidades as $disponibilidad)
                                    <tr>
                                        <td>{{ $diasSemana[$disponibilidad->dia_semana] ?? ucfirst($disponibilidad->dia_semana) }}</td>
                                        <td>{{ \Carbon\Carbon::createFromFormat('H:i:s', $disponibilidad->hora_inicio)->format('h:i a') }}</td>
                                        <td>{{ \Carbon\Carbon::createFromFormat('H:i:s', $disponibilidad->hora_fin)->format('h:i a') }}</td>
                                        <td class="text-right">
                                            <form action="{{ route('especialista.horarios.destroy', $disponibilidad) }}" method="POST"
                                                onsubmit="return confirm('¿Eliminar este horario?');">
                                                @csrf
                                                @method('DELETE')
                                                <button type="submit" class="btn btn-sm btn-outline-danger">
                                                    <i class="fas fa-trash-alt"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                @empty
                                    <tr>
                                        <td colspan="4" class="text-center py-4">Aún no has registrado horarios.</td>
                                    </tr>
                                @endforelse
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection
