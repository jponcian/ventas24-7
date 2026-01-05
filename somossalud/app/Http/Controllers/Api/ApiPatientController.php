<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use App\Models\Cita;
use App\Models\User;
use App\Models\Disponibilidad;
use App\Models\Especialidad;

class ApiPatientController extends Controller
{
    // ... (Keep existing dashboard, labResults, methods) ...
    public function dashboard(Request $request)
    {
        $user = $request->user();

        // 1. Suscripción Activa
        $suscripcionActiva = \App\Models\Suscripcion::where('usuario_id', $user->id)
            ->where('estado', 'activo')
            ->latest()
            ->first();

        // 2. Última Cita / Receta
        $ultimaCita = \App\Models\Cita::with(['medicamentos', 'especialista', 'clinica'])
            ->where('usuario_id', $user->id)
            ->whereNotNull('concluida_at')
            ->orderBy('concluida_at', 'desc')
            ->first();

        // 3. Próxima Cita (Pendiente)
        $proximaCita = \App\Models\Cita::with(['especialista', 'clinica'])
            ->where('usuario_id', $user->id)
            ->where('estado', 'pendiente')
            ->where('fecha', '>=', now())
            ->orderBy('fecha', 'asc')
            ->first();

        $familiaIds = $user->dependientes()->pluck('id')->push($user->id);

        $ordenesLaboratorio = \App\Models\LabOrder::with(['clinica', 'details.exam', 'patient'])
            ->whereIn('patient_id', $familiaIds)
            ->where('status', 'completed')
            ->orderBy('result_date', 'desc')
            ->limit(5)
            ->get();

        return response()->json([
            'success' => true,
            'data' => [
                'suscripcion' => $suscripcionActiva ? [
                    'plan' => $suscripcionActiva->plan, 
                    'estado' => $suscripcionActiva->estado,
                    'vence' => $suscripcionActiva->fecha_fin,
                ] : null,
                'proxima_cita' => $proximaCita ? [
                    'id' => $proximaCita->id,
                    'especialista' => $proximaCita->especialista->name ?? 'N/A',
                    'fecha' => $proximaCita->fecha,
                    'clinica' => $proximaCita->clinica->nombre ?? 'N/A',
                ] : null,
                'ultima_receta' => $ultimaCita ? [
                    'id' => $ultimaCita->id,
                    'fecha' => $ultimaCita->concluida_at,
                    'especialista' => $ultimaCita->especialista->name ?? 'N/A',
                ] : null,
                'resultados_recientes' => $ordenesLaboratorio->map(function($orden) {
                    return [
                        'id' => $orden->id,
                        'codigo' => $orden->code,
                        'fecha' => $orden->result_date ? \Carbon\Carbon::parse($orden->result_date)->format('Y-m-d H:i:s') : null,
                        'paciente' => $orden->patient->name ?? 'N/A',
                        'clinica' => $orden->clinica->nombre ?? 'N/A',
                        'total_examenes' => $orden->details->count(),
                        'examenes' => $orden->details->take(3)->map(fn($d) => $d->exam->name)->implode(', '),
                    ];
                }),
            ]
        ]);
    }

    public function labResults(Request $request) { /* ... same as before */ 
        $user = $request->user();
        $familiaIds = $user->dependientes()->pluck('id')->push($user->id);
        $ordenes = \App\Models\LabOrder::with(['clinica', 'details.exam', 'patient'])
            ->whereIn('patient_id', $familiaIds)
            ->where('status', 'completed')
            ->orderBy('result_date', 'desc')
            ->get();
        return response()->json([
            'success' => true,
            'data' => $ordenes->map(function($orden) {
                return [
                    'id' => $orden->id,
                    'codigo' => $orden->order_number ?? $orden->code,
                    'fecha_orden' => $orden->order_date,
                    'fecha_resultado' => $orden->result_date,
                    'paciente' => optional($orden->patient)->name ?? 'N/A',
                    'estado' => $orden->status,
                    'clinica' => optional($orden->clinica)->nombre ?? 'N/A',
                    'total_examenes' => $orden->details->count(),
                    'examenes' => $orden->details->map(fn($d) => [
                        'nombre' => optional($d->exam)->name ?? 'N/A',
                        'categoria' => optional(optional($d->exam)->category)->name ?? 'N/A',
                    ]),
                ];
            })
        ]);
    }

    public function labResultDetail(Request $request, $id) { /* ... same as before */ 
        $user = $request->user();
        $familiaIds = $user->dependientes()->pluck('id')->push($user->id);
        $orden = \App\Models\LabOrder::with(['clinica', 'details.exam.category', 'details.results.examItem', 'patient'])
            ->whereIn('patient_id', $familiaIds)
            ->where('id', $id)
            ->first();

        if (!$orden) {
            return response()->json(['success' => false,'message' => 'Resultado no encontrado'], 404);
        }
        return response()->json([
            'success' => true,
            'data' => [
                'id' => $orden->id,
                'codigo' => $orden->order_number ?? $orden->code,
                'fecha_orden' => $orden->order_date,
                'fecha_resultado' => $orden->result_date,
                'paciente' => optional($orden->patient)->name ?? 'N/A',
                'estado' => $orden->status,
                'clinica' => optional($orden->clinica)->nombre ?? 'N/A',
                'observaciones' => $orden->observations,
                'examenes' => $orden->details->map(function($detalle) {
                    return [
                        'id' => $detalle->id,
                        'nombre' => optional($detalle->exam)->name ?? 'N/A',
                        'categoria' => optional(optional($detalle->exam)->category)->name ?? 'N/A',
                        'resultados' => $detalle->results->map(fn($r) => [
                            'parametro' => optional($r->examItem)->name ?? 'N/A',
                            'valor' => $r->value ?? 'N/A',
                            'unidad' => optional($r->examItem)->unit ?? '',
                            'referencia' => optional($r->examItem)->reference_value ?? '',
                        ]),
                    ];
                }),
                'pdf_url' => \Illuminate\Support\Facades\URL::temporarySignedRoute(
                    'lab.orders.public-pdf', 
                    now()->addMinutes(30),
                    ['id' => $orden->id]
                ),
            ]
        ]);
    }

    public function appointments(Request $request) { /* ... same as before */ 
        $user = $request->user();
        $citas = \App\Models\Cita::with(['especialista', 'clinica'])
            ->where('usuario_id', $user->id)
            ->orderBy('fecha', 'desc')
            ->get();
        return response()->json([
            'success' => true,
            'data' => $citas->map(function($cita) {
                return [
                    'id' => $cita->id,
                    'fecha' => $cita->fecha,
                    'hora' => $cita->fecha ? \Carbon\Carbon::parse($cita->fecha)->format('h:i a') : 'No especificada',
                    'especialista' => optional($cita->especialista)->name ?? 'No asignado',
                    'especialidad' => optional($cita->especialista)->especialidad->nombre ?? 'General',
                    'clinica' => optional($cita->clinica)->nombre ?? 'N/A',
                    'estado' => $cita->estado ?? 'pendiente',
                    'concluida' => $cita->concluida_at != null,
                    'motivo' => $cita->motivo,
                    'diagnostico' => $cita->diagnostico,
                    'tratamiento' => $cita->tratamiento,
                    'observaciones' => $cita->observaciones,
                    'recipe_url' => $cita->concluida_at 
                        ? \Illuminate\Support\Facades\URL::signedRoute('citas.receta.public', ['cita' => $cita->id]) 
                        : null,
                ];
            })
        ]);
    }

    public function subscription(Request $request) { /* ... */ 
        $user = $request->user();
        $suscripcion = \App\Models\Suscripcion::where('usuario_id', $user->id)
            ->where('estado', 'activo')
            ->latest()
            ->first();
        if (!$suscripcion) {
            return response()->json(['success' => true,'data' => null]);
        }
        return response()->json([
            'success' => true,
            'data' => [
                'plan' => $suscripcion->plan ?? 'Plan Básico',
                'estado' => $suscripcion->estado,
                'vence' => $suscripcion->fecha_fin,
            ]
        ]);
    }

    public function reportPayment(Request $request) { /* ... */ 
         $request->validate([
            'monto' => 'required|numeric',
            'referencia' => 'required|string',
            'fecha_pago' => 'required|date',
            'metodo_pago' => 'required|string',
        ]);
        $user = $request->user();
        \App\Models\ReportePago::create([
            'usuario_id' => $user->id,
            'monto' => $request->monto,
            'referencia' => $request->referencia,
            'fecha_pago' => $request->fecha_pago,
            'estado' => 'pendiente',
        ]);
        return response()->json([
            'success' => true,
            'message' => 'Pago reportado exitosamente. Será revisado por nuestro equipo.'
        ]);
    }

    public function updateProfile(Request $request) { /* ... */ 
        $user = $request->user();
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $user->id,
            'password' => 'nullable|string|min:6|confirmed',
            'sexo' => 'nullable|string|in:Masculino,Femenino',
            'fecha_nacimiento' => 'nullable|date',
        ]);
        $user->name = $request->name;
        $user->email = $request->email;
        $user->sexo = $request->sexo;
        $user->fecha_nacimiento = $request->fecha_nacimiento;
        if ($request->filled('password')) {
            $user->password = \Illuminate\Support\Facades\Hash::make($request->password);
        }
        $user->save();
        return response()->json([
            'success' => true,
            'message' => 'Perfil actualizado correctamente',
            'data' => $user
        ]);
    }

    // ==========================================
    // NUEVOS METODOS MEJORADOS PARA CITAS
    // ==========================================


    // Obtener especialidades
    public function getSpecialties()
    {
        try {
            // Solo especialidades que tienen usuarios con rol 'especialista'
            $specialties = Especialidad::whereHas('usuarios', function ($q) {
                $q->role('especialista');
            })
            ->select('id', 'nombre')
            ->orderBy('nombre')
            ->get();
            
            return response()->json([
                'success' => true,
                'data' => $specialties
            ]);
        } catch (\Exception $e) {
            \Log::error('Error en getSpecialties: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al cargar especialidades: ' . $e->getMessage()
            ], 500);
        }
    }

    // Obtener doctores por especialidad
    public function getDoctors(Request $request)
    {
        try {
            $request->validate([
                'especialidad_id' => 'required|exists:especialidades,id'
            ]);

            $especialidadId = $request->especialidad_id;

            // Usar Spatie role 'especialista' y relacion con especialidades
            $doctors = User::role('especialista')
                ->whereHas('especialidades', function ($q) use ($especialidadId) {
                    $q->where('especialidades.id', $especialidadId);
                })
                ->select('id', 'name')
                ->orderBy('name')
                ->get();

            return response()->json([
                'success' => true,
                'data' => $doctors
            ]);
        } catch (\Exception $e) {
            \Log::error('Error en getDoctors: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al cargar doctores: ' . $e->getMessage()
            ], 500);
        }
    }

    // Obtener slots disponibles para un doctor y fecha
    public function getAvailableSlots(Request $request)
    {
        try {
            $validated = $request->validate([
                'doctor_id' => 'required|exists:usuarios,id',
                'fecha' => 'required|date_format:Y-m-d'
            ]);

            $especialista = User::findOrFail($validated['doctor_id']);
            
            // Verificar que sea especialista
            if (!$especialista->hasRole('especialista')) {
                 return response()->json([
                     'success' => false, 
                     'message' => 'Usuario no es especialista'
                 ], 422);
            }

            $date = \Carbon\Carbon::createFromFormat('Y-m-d', $validated['fecha']);
            $diaKey = strtolower($date->englishDayOfWeek); // monday..sunday

            // Obtener horarios base del especialista
            $disponibilidades = Disponibilidad::where('especialista_id', $especialista->id)
                ->where('dia_semana', $diaKey)
                ->orderBy('hora_inicio')
                ->get(['hora_inicio', 'hora_fin']);

            $slots = [];
            $duracionMin = 30; // Minutos por cita

            foreach ($disponibilidades as $disp) {
                $inicio = \Carbon\Carbon::parse($validated['fecha'] . ' ' . $disp->hora_inicio);
                $fin = \Carbon\Carbon::parse($validated['fecha'] . ' ' . $disp->hora_fin);

                for ($dt = $inicio->copy(); $dt->lt($fin); $dt->addMinutes($duracionMin)) {
                    
                    // No mostrar horas pasadas si es hoy
                    if ($dt->isPast()) continue;

                    $slotStr = $dt->format('Y-m-d H:i');
                    
                    // Verificar si ya está ocupado (excluyendo canceladas)
                    $ocupada = Cita::where('especialista_id', $especialista->id)
                        ->where('fecha', $slotStr)
                        ->where('estado', '!=', 'cancelada')
                        ->exists();

                    if (!$ocupada) {
                        $slots[] = [
                            'valor' => $slotStr,
                            'hora' => $dt->format('H:i'),
                            'hora_am_pm' => $dt->format('h:i a'),
                        ];
                    }
                }
            }

            return response()->json([
                'success' => true,
                'data' => $slots
            ]);
            
        } catch (\Exception $e) {
            \Log::error('Error en getAvailableSlots: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al cargar horarios: ' . $e->getMessage()
            ], 500);
        }
    }

    // Agendar Cita
    public function storeAppointment(Request $request)
    {
        $validated = $request->validate([
            'especialidad_id' => 'required|exists:especialidades,id',
            'doctor_id' => 'required|exists:usuarios,id',
            'fecha_hora' => 'required|date_format:Y-m-d H:i',
            'motivo' => 'nullable|string|max:500',
        ]);

        $user = Auth::user();

        // 1. Validar Especialista
        $especialista = User::role('especialista')->findOrFail($validated['doctor_id']);
        
        // 2. Validar que especialista tenga la especialidad
        if (!$especialista->especialidades()->where('especialidades.id', $validated['especialidad_id'])->exists()) {
             return response()->json(['success' => false, 'message' => 'El especialista no corresponde a la especialidad'], 422);
        }

        // 3. Validar Disponibilidad (Doble chequeo)
        $existe = Cita::where('especialista_id', $especialista->id)
            ->where('fecha', $validated['fecha_hora'])
            ->where('estado', '!=', 'cancelada')
            ->exists();
            
        if ($existe) {
            return response()->json(['success' => false, 'message' => 'Este horario ya acaba de ser ocupado.'], 422);
        }
        
        // 4. (Opcional) Validar horario base nuevamente para seguridad

        // 5. Determinar clínica
        $clinicaId = $especialista->clinica_id ?? 1;

        $cita = Cita::create([
            'usuario_id' => $user->id,
            'clinica_id' => $clinicaId,
            'especialista_id' => $especialista->id,
            'fecha' => $validated['fecha_hora'], // Y-m-d H:i
            'estado' => 'pendiente',
            'motivo' => $validated['motivo'],
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Cita agendada con éxito',
            'data' => $cita
        ], 201);
    }
}
