<!-- resources/views/lab/show_order.blade.php -->
@extends('layouts.app')
@section('content')
<h1>Orden #{{ $order->id }}</h1>
<p>Paciente: {{ $order->patient->name }}</p>
<p>Estado: {{ $order->status }}</p>
<h3>Exámenes</h3>
<ul>
@foreach($order->details as $detail)
    <li>{{ $detail->exam->name }} - ${{ $detail->price }}</li>
@endforeach
</ul>
@if($order->status == 'pending')
    <a href="{{ route('lab.orders.edit', $order->id) }}" class="btn btn-primary">Ingresar Resultados</a>
@endif
@endsection
