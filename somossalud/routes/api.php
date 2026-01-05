<?php

use Illuminate\Support\Facades\Route;
use App\Models\ExchangeRate;

Route::post('/login', [\App\Http\Controllers\Api\ApiAuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [\App\Http\Controllers\Api\ApiAuthController::class, 'logout']);
    
    // Obtener usuario autenticado
    Route::get('/user', function (\Illuminate\Http\Request $request) {
        return $request->user();
    });

    // Rutas de Paciente
    Route::get('/paciente/dashboard', [\App\Http\Controllers\Api\ApiPatientController::class, 'dashboard']);
    Route::get('/paciente/resultados', [\App\Http\Controllers\Api\ApiPatientController::class, 'labResults']);
    Route::get('/paciente/resultados/{id}', [\App\Http\Controllers\Api\ApiPatientController::class, 'labResultDetail']);
    
    Route::get('/paciente/citas', [\App\Http\Controllers\Api\ApiPatientController::class, 'appointments']);
    Route::post('/paciente/citas', [\App\Http\Controllers\Api\ApiPatientController::class, 'storeAppointment']); 
    Route::get('/paciente/especialidades', [\App\Http\Controllers\Api\ApiPatientController::class, 'getSpecialties']); 
    Route::get('/paciente/doctores', [\App\Http\Controllers\Api\ApiPatientController::class, 'getDoctors']);
    Route::get('/paciente/slots', [\App\Http\Controllers\Api\ApiPatientController::class, 'getAvailableSlots']); // Nueva ruta vital
    
    Route::get('/paciente/suscripcion', [\App\Http\Controllers\Api\ApiPatientController::class, 'subscription']);
    Route::post('/paciente/reportar-pago', [\App\Http\Controllers\Api\ApiPatientController::class, 'reportPayment']);
    Route::post('/paciente/perfil', [\App\Http\Controllers\Api\ApiPatientController::class, 'updateProfile']);
});

Route::get('/tasa', function() {
    $rate = ExchangeRate::latestRate()->first();
    if(!$rate){
        return response()->json(['message' => 'Sin tasa disponible'], 404);
    }
    return [
        'date' => $rate->date->format('Y-m-d'),
        'from' => $rate->from,
        'to' => $rate->to,
        'rate' => (float)$rate->rate,
        'source' => $rate->source,
    ];
});
