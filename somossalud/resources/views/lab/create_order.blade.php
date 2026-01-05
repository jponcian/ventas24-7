<!-- resources/views/lab/create_order.blade.php -->
@extends('layouts.app')
@section('content')
<h1>Crear Orden de Laboratorio</h1>
<form method="POST" action="{{ route('lab.orders.store') }}">
    @csrf
    <div>
        <label>Paciente ID:</label>
        <input type="number" name="patient_id" required>
    </div>
    <div>
        <label>Médico ID (opcional):</label>
        <input type="number" name="doctor_id">
    </div>
    <h3>Exámenes Disponibles</h3>
    @foreach($categories as $category)
        <h4>{{ $category->name }}</h4>
        @foreach($category->exams as $exam)
            <div>
                <input type="checkbox" name="exams[]" value="{{ $exam->id }}">
                {{ $exam->name }} ({{ $exam->price }}$)
            </div>
        @endforeach
    @endforeach
    <button type="submit">Generar Orden</button>
</form>
@endsection
