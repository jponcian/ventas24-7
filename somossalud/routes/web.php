<?php

use App\Http\Controllers\Admin\UserManagementController;
use App\Http\Controllers\Especialista\DisponibilidadController;
use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;

use Illuminate\Support\Facades\Log;
Route::get('/', function () {
    try {
        app(\App\Services\BcvRateService::class)->syncIfMissing();
    } catch (\Throwable $e) {
        Log::warning('BCV sync failed: ' . $e->getMessage());
    }
    return view('landing');
});

Route::get('/dashboard', function () {
    $user = \Illuminate\Support\Facades\Auth::user();
    
    // Prioridad al panel clínico para personal
    if ($user->hasAnyRole(['super-admin', 'admin_clinica', 'recepcionista', 'especialista', 'laboratorio', 'laboratorio-resul', 'almacen', 'almacen-jefe'])) {
        return redirect()->route('panel.clinica');
    }
    
    // Por defecto al panel de pacientes
    return redirect()->route('panel.pacientes');
})->middleware(['auth', 'verified'])->name('dashboard');

// Rutas de órdenes de laboratorio (personal autorizado)
Route::middleware(['auth', 'verified', 'role:laboratorio|laboratorio-resul|admin_clinica|super-admin|recepcionista'])
    ->prefix('lab/orders')
    ->name('lab.orders.')
    ->group(function () {
        Route::get('/', [\App\Http\Controllers\LabOrderController::class, 'index'])->name('index');
        Route::get('/create', [\App\Http\Controllers\LabOrderController::class, 'create'])->name('create')
            ->middleware('role:laboratorio|admin_clinica|super-admin|recepcionista');
        Route::post('/', [\App\Http\Controllers\LabOrderController::class, 'store'])->name('store')
            ->middleware('role:laboratorio|admin_clinica|super-admin|recepcionista');
        Route::get('/{id}', [\App\Http\Controllers\LabOrderController::class, 'show'])->name('show');
        Route::get('/{id}/load-results', [\App\Http\Controllers\LabOrderController::class, 'loadResults'])->name('load-results')
            ->middleware('role:laboratorio-resul|admin_clinica|super-admin');
        Route::post('/{id}/results', [\App\Http\Controllers\LabOrderController::class, 'storeResults'])->name('store-results')
            ->middleware('role:laboratorio-resul|admin_clinica|super-admin');
        Route::get('/ajax/search-patients', [\App\Http\Controllers\LabOrderController::class, 'searchPatients'])->name('search-patients')
            ->middleware('role:laboratorio|admin_clinica|super-admin|recepcionista');
        Route::post('/delete-exam-item', [\App\Http\Controllers\LabOrderController::class, 'deleteExamItem'])->name('delete-exam-item')
            ->middleware('role:laboratorio-resul|admin_clinica|super-admin');
        Route::delete('/{order}', [\App\Http\Controllers\LabOrderController::class, 'destroy'])->name('destroy')
            ->middleware('role:admin_clinica|super-admin');
    });

// Gestión de Exámenes (Laboratorio)
Route::middleware(['auth', 'verified', 'role:laboratorio|laboratorio-resul|admin_clinica|super-admin'])
    ->prefix('lab/management')
    ->name('lab.management.')
    ->group(function () {
        Route::get('/', [\App\Http\Controllers\LabManagementController::class, 'index'])->name('index');
        Route::get('/create', [\App\Http\Controllers\LabManagementController::class, 'create'])->name('create');
        Route::post('/', [\App\Http\Controllers\LabManagementController::class, 'store'])->name('store');
        Route::get('/{exam}/edit', [\App\Http\Controllers\LabManagementController::class, 'edit'])->name('edit');
        Route::put('/{exam}', [\App\Http\Controllers\LabManagementController::class, 'update'])->name('update');
        Route::delete('/{exam}', [\App\Http\Controllers\LabManagementController::class, 'destroy'])->name('destroy');
        
        // Rutas para items
        Route::post('/{exam}/items', [\App\Http\Controllers\LabManagementController::class, 'storeItem'])->name('items.store');
        Route::put('/items/{item}', [\App\Http\Controllers\LabManagementController::class, 'updateItem'])->name('items.update');
        Route::delete('/items/{item}', [\App\Http\Controllers\LabManagementController::class, 'destroyItem'])->name('items.destroy');
        
        // Rutas para referencias
        Route::get('/items/{item}/references', [\App\Http\Controllers\LabManagementController::class, 'showReferences'])->name('references.index');
        Route::post('/items/{item}/references', [\App\Http\Controllers\LabManagementController::class, 'storeReference'])->name('references.store');
        Route::put('/references/{reference}', [\App\Http\Controllers\LabManagementController::class, 'updateReference'])->name('references.update');
        Route::delete('/references/{reference}', [\App\Http\Controllers\LabManagementController::class, 'destroyReference'])->name('references.destroy');
        
        // Rutas para API/AJAX de grupos
        Route::get('/groups/search', [\App\Http\Controllers\LabManagementController::class, 'searchGroups'])->name('groups.search');
    });

// Ruta de descarga de PDF accesible para pacientes y personal (validación en controlador)
Route::middleware(['auth', 'verified'])
    ->get('lab/orders/{id}/pdf', [\App\Http\Controllers\LabOrderController::class, 'downloadPDF'])
    ->name('lab.orders.pdf');

// Ruta de descarga de ticket PDF (solo personal autorizado)
Route::middleware(['auth', 'verified', 'role:laboratorio|admin_clinica|super-admin'])
    ->get('lab/orders/{id}/ticket', [\App\Http\Controllers\LabOrderController::class, 'downloadTicket'])
    ->name('lab.orders.ticket');

// Ruta para enviar PDF por WhatsApp (solo personal autorizado)
Route::middleware(['auth', 'verified', 'role:laboratorio|laboratorio-resul|admin_clinica|super-admin'])
    ->post('lab/orders/{id}/send-whatsapp', [\App\Http\Controllers\LabOrderController::class, 'sendPDFWhatsApp'])
    ->name('lab.orders.send-whatsapp');

// Ruta pública de verificación de órdenes de laboratorio (sin autenticación)
Route::get('verificar-orden-laboratorio/{code}', [\App\Http\Controllers\LabOrderController::class, 'verify'])->name('lab.orders.verify');

// Ruta firmada para descarga de PDF (API/App Mobile)
Route::get('lab/orders/{id}/public-pdf', [\App\Http\Controllers\LabOrderController::class, 'downloadPublicPDF'])
    ->name('lab.orders.public-pdf')
    ->middleware('signed');

// Mantener ruta antigua pero redirigir al nuevo dashboard unificado
Route::middleware(['auth', 'verified'])->get('/panel/pacientes', function () {
    $user = \Illuminate\Support\Facades\Auth::user();
    
    // Panel de paciente unificado
    $suscripcionActiva = \App\Models\Suscripcion::where('usuario_id', $user->id)->where('estado', 'activo')->latest()->first();
    $reportePendiente = \App\Models\ReportePago::where('usuario_id', $user->id)->where('estado', 'pendiente')->latest()->first();
    $ultimoRechazado = \App\Models\ReportePago::where('usuario_id', $user->id)->where('estado', 'rechazado')->latest()->first();
    $ultimaReceta = \App\Models\Cita::with(['medicamentos', 'especialista', 'clinica'])
        ->where('usuario_id', $user->id)
        ->whereHas('medicamentos')
        ->orderByRaw('COALESCE(concluida_at, updated_at) DESC')
        ->first();
    // Órdenes de laboratorio completadas del paciente
    $ordenesLaboratorio = \App\Models\LabOrder::with(['clinica', 'details.exam'])
        ->where('patient_id', $user->id)
        ->where('status', 'completed')
        ->orderBy('result_date', 'desc')
        ->limit(5)
        ->get();
        
    return view('panel.pacientes', compact('suscripcionActiva', 'reportePendiente', 'ultimoRechazado', 'ultimaReceta', 'ordenesLaboratorio'));
})->name('panel.pacientes');

Route::middleware(['auth', 'verified', 'role:super-admin|admin_clinica|recepcionista|especialista|laboratorio|laboratorio-resul|almacen|almacen-jefe'])->get('/panel/clinica', function () {
    return view('panel.clinica');
})->name('panel.clinica');

Route::middleware(['auth', 'verified', 'role:especialista'])
    ->prefix('especialista')
    ->name('especialista.')
    ->group(function () {
        Route::get('horarios', [DisponibilidadController::class, 'index'])->name('horarios.index');
        Route::post('horarios', [DisponibilidadController::class, 'store'])->name('horarios.store');
        Route::delete('horarios/{disponibilidad}', [DisponibilidadController::class, 'destroy'])->name('horarios.destroy');
    });

// Gestión de usuarios: también accesible por recepcionista (limitado a pacientes en el controlador)
Route::middleware(['auth', 'verified', 'role:super-admin|admin_clinica|recepcionista|laboratorio|laboratorio-resul'])
    ->prefix('admin')
    ->name('admin.')
    ->group(function () {
        Route::post('users/{user}/password-reset', [UserManagementController::class, 'sendPasswordResetLink'])->name('users.password-reset');
        Route::post('users/{user}/whatsapp-test', [UserManagementController::class, 'sendWhatsAppTest'])->name('users.whatsapp-test');
        Route::delete('users/{user}/firma', [UserManagementController::class, 'deleteFirma'])->name('users.firma.delete');
        Route::get('users/next-dependent-number/{representante}', [UserManagementController::class, 'getNextDependentNumber'])->name('users.next-dependent-number');
        Route::get('users/search-representantes', [UserManagementController::class, 'searchRepresentantes'])->name('users.search-representantes');
        Route::resource('users', UserManagementController::class)->only(['index', 'create', 'store', 'edit', 'update']);
    });

// Configuración: solo administración
Route::middleware(['auth', 'verified', 'role:super-admin|admin_clinica'])
    ->prefix('admin')
    ->name('admin.')
    ->group(function () {
        Route::get('settings/pagos', [\App\Http\Controllers\Admin\SettingsController::class, 'pagos'])->name('settings.pagos');
        Route::post('settings/pagos', [\App\Http\Controllers\Admin\SettingsController::class, 'guardarPagos'])->name('settings.pagos.guardar');

        // Ruta de mantenimiento para limpiar caché
        // Ruta de mantenimiento para limpiar caché (Manual sin Artisan)
        Route::get('settings/limpiar-cache', function () {
            try {
                $basePath = base_path();

                // 1. Limpiar caché de configuración y rutas (bootstrap/cache)
                $files = glob($basePath . '/bootstrap/cache/*.php');
                foreach ($files as $file) {
                    if (is_file($file) && basename($file) !== '.gitignore') {
                        @unlink($file);
                    }
                }

                // 2. Limpiar vistas compiladas (storage/framework/views)
                $viewFiles = glob($basePath . '/storage/framework/views/*');
                foreach ($viewFiles as $file) {
                    if (is_file($file) && basename($file) !== '.gitignore') {
                        @unlink($file);
                    }
                }

                // 3. Limpiar caché de aplicación (storage/framework/cache/data) - Solo si es file driver
                // Nota: Borrar recursivamente es peligroso en una ruta web simple, 
                // pero podemos intentar borrar la carpeta data si existe.
                // Por seguridad, solo borraremos archivos directos en cache/data si existen
                // Para una limpieza profunda de cache de archivos, se requeriría un iterador recursivo.
    
                return back()->with('status', 'Archivos de caché (config, rutas, vistas) eliminados manualmente.');
            } catch (\Exception $e) {
                return back()->with('error', 'Error limpiando caché manualmente: ' . $e->getMessage());
            }
        })->name('settings.cache.clear')->middleware('role:super-admin');
    });

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile/firma', [ProfileController::class, 'deleteFirma'])->name('profile.firma.delete');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');

    // Rutas de suscripción
    Route::get('/suscripcion', [\App\Http\Controllers\SuscripcionController::class, 'show'])
        ->name('suscripcion.show');
    Route::post('/suscripcion/reportar', [\App\Http\Controllers\SuscripcionController::class, 'reportarPago'])
        ->name('suscripcion.reportar');
    Route::get('/suscripcion/carnet', [\App\Http\Controllers\SuscripcionController::class, 'carnet'])
        ->name('suscripcion.carnet');

    // Endpoints auxiliares para selects dependientes y horarios disponibles (colocarlos ANTES del resource para evitar colisión con citas/{cita})
    Route::get('citas/doctores', [\App\Http\Controllers\CitaController::class, 'doctoresPorEspecialidad'])
        ->name('citas.doctores');
    Route::get('citas/slots', [\App\Http\Controllers\CitaController::class, 'slotsDisponibles'])
        ->name('citas.slots');
    Route::get('citas/dias', [\App\Http\Controllers\CitaController::class, 'diasDisponibles'])
        ->name('citas.dias');
    // Cambios de estado de cita
    Route::post('citas/{cita}/cancelar', [\App\Http\Controllers\CitaController::class, 'cancelar'])
        ->name('citas.cancelar');
    Route::post('citas/{cita}/reprogramar', [\App\Http\Controllers\CitaController::class, 'reprogramar'])
        ->name('citas.reprogramar');
    // Gestión de consulta (especialista)
    Route::post('citas/{cita}/gestion', [\App\Http\Controllers\CitaController::class, 'gestionar'])
        ->name('citas.gestion');
    // Receta visible para paciente
    Route::get('citas/{cita}/receta', [\App\Http\Controllers\CitaController::class, 'receta'])
        ->name('citas.receta');

    // Ruta explícita para "Mis Citas" (vista paciente)
    Route::get('mis-citas', [\App\Http\Controllers\CitaController::class, 'indexPaciente'])
        ->name('citas.paciente');

    // Rutas para citas (resource). El controlador protegerá creación/almacenamiento con verificar.suscripcion.
    Route::resource('citas', \App\Http\Controllers\CitaController::class);

    // Resultados de laboratorio para pacientes
    Route::get('mis-resultados', function () {
        // Órdenes de laboratorio completadas
        $ordenes = \App\Models\LabOrder::with(['clinica', 'details.exam', 'details.results.examItem'])
            ->where('patient_id', auth()->id())
            ->where('status', 'completed')
            ->orderBy('result_date', 'desc')
            ->get();

        return view('paciente.resultados', compact('ordenes'));
    })->name('paciente.resultados');
});



Route::middleware(['auth', 'verified', 'role:recepcionista|admin_clinica|super-admin'])
    ->prefix('recepcion')
    ->name('recepcion.')
    ->group(function () {
        Route::get('pagos', [\App\Http\Controllers\Recepcion\PagoManualController::class, 'index'])->name('pagos.index');
        Route::post('pagos/{reporte}/aprobar', [\App\Http\Controllers\Recepcion\PagoManualController::class, 'aprobar'])->name('pagos.aprobar');
        Route::post('pagos/{reporte}/rechazar', [\App\Http\Controllers\Recepcion\PagoManualController::class, 'rechazar'])->name('pagos.rechazar');
    });

// Atenciones (seguro / guardia)
Route::middleware(['auth', 'verified'])
    ->group(function () {
        // Listados por rol
        Route::get('atenciones', [\App\Http\Controllers\AtencionController::class, 'index'])->name('atenciones.index');
        // Recepción
        Route::post('atenciones', [\App\Http\Controllers\AtencionController::class, 'store'])->name('atenciones.store');
        Route::post('atenciones/{atencion}/asignar', [\App\Http\Controllers\AtencionController::class, 'asignarMedico'])->name('atenciones.asignar');
        Route::post('atenciones/{atencion}/cerrar', [\App\Http\Controllers\AtencionController::class, 'cerrar'])->name('atenciones.cerrar');
        // Buscadores AJAX recepción
        Route::get('ajax/pacientes', [\App\Http\Controllers\AtencionController::class, 'buscarPacientes'])->name('ajax.pacientes');
        Route::get('ajax/clinicas', [\App\Http\Controllers\AtencionController::class, 'buscarClinicas'])->name('ajax.clinicas');
        Route::get('ajax/medicos', [\App\Http\Controllers\AtencionController::class, 'buscarMedicos'])->name('ajax.medicos');
        // Especialista gestionar
        Route::get('atenciones/{atencion}/gestion', function (\App\Models\Atencion $atencion) {
            // Reusar layout admin para especialistas
            $user = \Illuminate\Support\Facades\Auth::user();
            if (!$user->hasRole(['especialista', 'super-admin', 'admin_clinica']))
                abort(403);
            // Historial del paciente para apoyo clínico
            $historial = collect();
            if ($atencion->paciente_id) {
                $pacienteId = $atencion->paciente_id;
                $citas = \App\Models\Cita::with(['especialista', 'medicamentos'])
                    ->where('usuario_id', $pacienteId)
                    ->orderBy('fecha', 'desc')->limit(10)->get();
                $ats = \App\Models\Atencion::with(['medico', 'medicamentos'])
                    ->where('paciente_id', $pacienteId)
                    ->orderByRaw('COALESCE(cerrada_at, updated_at, created_at) DESC')
                    ->limit(10)->get();
                foreach ($citas as $c) {
                    $historial->push([
                        'tipo' => 'cita',
                        'momento' => \Carbon\Carbon::parse($c->fecha),
                        'estado' => $c->estado,
                        'especialista' => optional($c->especialista)->name,
                        'diagnostico' => $c->diagnostico,
                        'observaciones' => $c->observaciones,
                        'meds_list' => $c->medicamentos->map(fn($m) => [
                            'nombre' => $m->nombre_generico,
                            'presentacion' => $m->presentacion,
                            'posologia' => $m->posologia,
                            'frecuencia' => $m->frecuencia,
                            'duracion' => $m->duracion,
                        ])->values(),
                    ]);
                }
                foreach ($ats as $a) {
                    $historial->push([
                        'tipo' => 'atencion',
                        'momento' => $a->iniciada_at ?? $a->created_at,
                        'estado' => $a->estado,
                        'especialista' => optional($a->medico)->name,
                        'diagnostico' => $a->diagnostico,
                        'observaciones' => $a->observaciones,
                        'meds_list' => $a->medicamentos->map(fn($m) => [
                            'nombre' => $m->nombre_generico,
                            'presentacion' => $m->presentacion,
                            'posologia' => $m->posologia,
                            'frecuencia' => $m->frecuencia,
                            'duracion' => $m->duracion,
                        ])->values(),
                    ]);
                }
                $historial = $historial->sortByDesc('momento')->take(10)->values();
            }
            return view('atenciones.especialista.gestion', compact('atencion', 'historial'));
        })->name('atenciones.gestion');
        Route::post('atenciones/{atencion}/gestion', [\App\Http\Controllers\AtencionController::class, 'gestionar'])->name('atenciones.gestion.post');
        // Detalle paciente (solo lectura) - reutiliza controlador para ver una atención propia
        Route::get('atenciones/paciente/{atencion}', [\App\Http\Controllers\AtencionController::class, 'showPaciente'])->name('atenciones.paciente.show');
        Route::get('atenciones/paciente/{atencion}/receta', [\App\Http\Controllers\AtencionController::class, 'recetaPaciente'])->name('atenciones.paciente.receta');
    });

// Rutas de Inventario - Solicitudes y Materiales
Route::middleware(['auth', 'verified'])
    ->prefix('inventario')
    ->name('inventario.')
    ->group(function () {
        // Rutas de Solicitudes
        Route::prefix('solicitudes')->name('solicitudes.')->group(function () {
            Route::get('/', [\App\Http\Controllers\SolicitudInventarioController::class, 'index'])
                ->name('index')
                ->middleware('role:super-admin|admin_clinica|almacen|almacen-jefe');

            Route::get('/crear', [\App\Http\Controllers\SolicitudInventarioController::class, 'create'])
                ->name('create')
                ->middleware('role:super-admin|admin_clinica|almacen|almacen-jefe');

            Route::post('/', [\App\Http\Controllers\SolicitudInventarioController::class, 'store'])
                ->name('store')
                ->middleware('role:super-admin|admin_clinica|almacen|almacen-jefe');

            Route::get('/buscar-materiales', [\App\Http\Controllers\SolicitudInventarioController::class, 'buscarMateriales'])
                ->name('buscar-materiales'); // AJAX para autocompletado
    
            Route::get('/{solicitud}', [\App\Http\Controllers\SolicitudInventarioController::class, 'show'])
                ->name('show')
                ->middleware('role:super-admin|admin_clinica|almacen|almacen-jefe');

            Route::get('/{solicitud}/editar', [\App\Http\Controllers\SolicitudInventarioController::class, 'edit'])
                ->name('edit')
                ->middleware('role:super-admin|admin_clinica|almacen-jefe');

            Route::post('/{solicitud}/aprobar', [\App\Http\Controllers\SolicitudInventarioController::class, 'aprobar'])
                ->name('aprobar')
                ->middleware('role:super-admin|admin_clinica|almacen-jefe');

            Route::post('/{solicitud}/despachar', [\App\Http\Controllers\SolicitudInventarioController::class, 'despachar'])
                ->name('despachar')
                ->middleware('role:super-admin|admin_clinica|almacen-jefe');

            Route::delete('/{solicitud}', [\App\Http\Controllers\SolicitudInventarioController::class, 'destroy'])
                ->name('destroy')
                ->middleware('role:super-admin|admin_clinica|almacen-jefe');
        });

        // Rutas de Materiales (solo almacen-jefe)
        Route::resource('materiales', \App\Http\Controllers\MaterialController::class)
            ->parameters(['materiales' => 'material'])
            ->middleware('role:super-admin|admin_clinica|almacen-jefe');

        // Rutas de Ingresos (solo almacen-jefe)
        Route::get('ingresos', [\App\Http\Controllers\IngresoInventarioController::class, 'index'])
            ->name('ingresos.index')
            ->middleware('role:super-admin|admin_clinica|almacen-jefe');
        
        Route::get('ingresos/crear', [\App\Http\Controllers\IngresoInventarioController::class, 'create'])
            ->name('ingresos.create')
            ->middleware('role:super-admin|admin_clinica|almacen-jefe');
            
        Route::post('ingresos', [\App\Http\Controllers\IngresoInventarioController::class, 'store'])
            ->name('ingresos.store')
            ->middleware('role:super-admin|admin_clinica|almacen-jefe');
    });

// Centro de Ayuda
Route::middleware(['auth', 'verified'])
    ->prefix('ayuda')
    ->name('help.')
    ->group(function () {
        Route::get('/', [\App\Http\Controllers\HelpController::class, 'index'])->name('index');
        Route::get('/{section}', [\App\Http\Controllers\HelpController::class, 'show'])->name('show');
    });

// Ruta pública para receta digital (verificada por firma, no auth)
Route::get('citas/public/{cita}/receta', [\App\Http\Controllers\CitaController::class, 'publicReceta'])
    ->name('citas.receta.public')
    ->middleware('signed');

require __DIR__ . '/auth.php';
