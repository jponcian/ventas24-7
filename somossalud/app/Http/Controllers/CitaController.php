<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Cita;
use App\Models\User;
use App\Models\Especialidad;
use App\Models\Disponibilidad;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\DB;

class CitaController extends Controller
{
    public function __construct()
    {
        // Aplicamos verificación de suscripción directamente con la clase del middleware
        // para evitar problemas de alias en ambientes donde el registro no se recargó.
        $this->middleware(\App\Http\Middleware\VerificarSuscripcion::class)->only(['create', 'store']);
    }

    /**
     * Vista exclusiva para pacientes (Mis Citas)
     * Accesible vía ruta dedicada para evitar conflictos de roles
     */
    public function indexPaciente()
    {
        $user = Auth::user();
        
        // Unificar Citas y Atenciones del paciente en un solo listado
        $citasRaw = Cita::with(['especialista'])
            ->withCount('medicamentos') 
            ->where('usuario_id', $user->id)
            ->orderBy('fecha', 'desc')
            ->orderBy('id', 'desc')
            ->get();
            
        $atencionesRaw = \App\Models\Atencion::with(['medico'])
            ->withCount('medicamentos')
            ->where('paciente_id', $user->id)
            ->orderBy('id', 'desc')
            ->get();

        $items = collect();
        foreach ($citasRaw as $c) {
            $items->push([
                'tipo' => 'cita',
                'id' => $c->id,
                'momento' => \Carbon\Carbon::parse($c->fecha),
                'estado' => $c->estado,
                'especialista' => optional($c->especialista)->name,
                'tiene_meds' => $c->medicamentos_count > 0, 
            ]);
        }
        foreach ($atencionesRaw as $a) {
            $items->push([
                'tipo' => 'atencion',
                'id' => $a->id,
                'momento' => $a->iniciada_at ?? $a->created_at,
                'estado' => $a->estado,
                'especialista' => optional($a->medico)->name,
                'tiene_meds' => $a->medicamentos_count > 0, 
            ]);
        }
        $items = $items->sortByDesc('momento')->values();
        
        if ($items->isEmpty()) {
            // Redirigir a create pero con un flag para saber volver
            return redirect()->route('citas.create')->with('info', 'Crea tu primera cita.');
        }
        
        return view('citas.paciente_index', [
            'items' => $items,
        ]);
    }

    public function index()
{
    $user = Auth::user();
    
    // Si la petición pide explícitamente vista paciente (legacy support)
    if (request()->has('view_as_patient')) {
        return $this->indexPaciente();
    }
    
    // Prioridad por roles puros:
    // Si SOLO es paciente, ir directo a su vista
    if ($user->hasRole('paciente') && !$user->hasAnyRole(['super-admin', 'admin_clinica', 'recepcionista'])) {
        return $this->indexPaciente();
    }
    
    // Si no es paciente puro (es admin o híbrido), usar vista administrativa por defecto
    $usaAdmin = $user->hasRole(['especialista', 'super-admin', 'admin_clinica', 'recepcionista', 'laboratorio']);
    
    // Optimización: Eager Loading para evitar N+1 en vista Admin
    $query = Cita::with(['usuario', 'especialista', 'clinica']);
    
    if ($user->hasRole('especialista')) {
        // Mostrar solo las citas asignadas a este especialista
        $citas = $query->where('especialista_id', $user->id)
            ->orderBy('fecha', 'desc')
            ->orderBy('id', 'desc')
            ->get();
    } else {
        $citas = $query->orderBy('fecha', 'desc')->orderBy('id', 'desc')->get();
    }
    return view($usaAdmin ? 'citas.admin.index' : 'citas.index', compact('citas'));
}

    public function create()
    {
        // Validación manual de suscripción
        $user = Auth::user();
        if ($user->hasRole('paciente')) {
            $tieneSuscripcion = \App\Models\Suscripcion::where('usuario_id', $user->id)
                ->where('estado', 'activo')
                ->whereDate('periodo_vencimiento', '>=', now())
                ->exists();

            if (!$tieneSuscripcion) {
                return redirect()->route('suscripcion.show')
                    ->with('error', 'Debes tener una suscripción activa para agendar citas.');
            }
        }

        // Solo especialidades que tengan al menos un usuario con rol especialista asignado (muchos a muchos)
        $especialidades = Especialidad::whereHas('usuarios', function ($q) {
            $q->role('especialista');
        })
            ->orderBy('nombre')
            ->get(['id', 'nombre']);

        return view('citas.create', compact('especialidades'));
    }

    public function store(Request $request)
    {
        // Validación manual de suscripción
        $user = Auth::user();
        if ($user->hasRole('paciente')) {
            $tieneSuscripcion = \App\Models\Suscripcion::where('usuario_id', $user->id)
                ->where('estado', 'activo')
                ->whereDate('periodo_vencimiento', '>=', now())
                ->exists();

            if (!$tieneSuscripcion) {
                return redirect()->route('suscripcion.show')
                    ->with('error', 'Debes tener una suscripción activa para agendar citas.');
            }
        }

        $validated = $request->validate([
            'especialidad_id' => ['required', 'exists:especialidades,id'],
            'especialista_id' => ['required', 'exists:usuarios,id'],
            'fecha' => ['required', 'date_format:Y-m-d H:i'],
            'motivo' => ['nullable', 'string', 'max:500'],
        ]);

        // Verificar que el especialista pertenece a la especialidad seleccionada (muchos a muchos)
        $especialista = User::role('especialista')->findOrFail($validated['especialista_id']);
        if (!$especialista->especialidades->pluck('id')->contains((int) $validated['especialidad_id'])) {
            return back()->withErrors(['especialista_id' => 'El especialista no pertenece a la especialidad seleccionada.'])->withInput();
        }

        // Verificar colisión: que no exista otra cita en ese mismo horario con el especialista
        $existe = Cita::where('especialista_id', $especialista->id)
            ->where('fecha', $validated['fecha'])
            ->exists();
        if ($existe) {
            return back()->withErrors(['fecha' => 'El horario seleccionado ya no está disponible. Actualiza los horarios disponibles.'])->withInput();
        }

        // Validar que la hora seleccionada esté dentro de la disponibilidad del especialista para ese día
        $fecha = \Carbon\Carbon::createFromFormat('Y-m-d H:i', $validated['fecha']);
        $diaKey = strtolower($fecha->englishDayOfWeek); // monday..sunday
        $dentroHorario = Disponibilidad::where('especialista_id', $especialista->id)
            ->where('dia_semana', $diaKey)
            ->where('hora_inicio', '<=', $fecha->format('H:i'))
            ->where('hora_fin', '>', $fecha->format('H:i'))
            ->exists();
        if (!$dentroHorario) {
            return back()->withErrors(['fecha' => 'La hora elegida no coincide con el horario del especialista.'])->withInput();
        }

        // Determinar clínica: si el especialista no tiene, usar la clínica por defecto (configurable por .env)
        $clinicaId = $especialista->clinica_id ?? (int) env('DEFAULT_CLINICA_ID', 1);
        if (empty($clinicaId)) {
            $clinicaId = 1; // fallback duro a 1 si .env no está definido
        }

        $cita = Cita::create([
            'usuario_id' => Auth::id(),
            'clinica_id' => $clinicaId, // por defecto si no viene del especialista
            'especialista_id' => $especialista->id,
            'fecha' => $validated['fecha'],
            'estado' => 'pendiente',
            'motivo' => $validated['motivo'] ?? null,
        ]);

        // Enviar correo de confirmación al paciente (cola)
        try {
            if ($cita->usuario && $cita->usuario->email) {
                Mail::to($cita->usuario->email)->queue(new \App\Mail\CitaAgendada($cita));
            }
        } catch (\Throwable $e) {
            Log::error('Fallo al enviar correo de cita agendada: ' . $e->getMessage());
        }

        return redirect()->route('citas.index')->with('success', 'Cita creada correctamente.');
    }

    public function show(Cita $cita)
    {
        $user = Auth::user();
        $isPaciente = $user->hasRole('paciente');
        $usaAdmin = $user->hasRole(['especialista', 'super-admin', 'admin_clinica', 'recepcionista', 'laboratorio']);
        $historial = collect();
        if ($usaAdmin && $cita->usuario_id) {
            $pacienteId = $cita->usuario_id;
            $citas = Cita::with(['especialista', 'medicamentos'])
                ->where('usuario_id', $pacienteId)
                ->orderBy('fecha', 'desc')
                ->limit(10)
                ->get();
            $ats = \App\Models\Atencion::with(['medico', 'medicamentos'])
                ->where('paciente_id', $pacienteId)
                ->orderByRaw('COALESCE(cerrada_at, updated_at, created_at) DESC')
                ->limit(10)
                ->get();

            foreach ($citas as $c) {
                $historial->push([
                    'tipo' => 'cita',
                    'momento' => \Carbon\Carbon::parse($c->fecha),
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

        // Forzar layout de paciente si el usuario es paciente
        if ($isPaciente) {
            return view('citas.paciente_show', compact('cita', 'historial'));
        }
        return view('citas.admin.show', compact('cita', 'historial'));
    }

    public function destroy(Cita $cita)
    {
        $this->authorize('delete', $cita);
        $cita->delete();
        return redirect()->route('citas.index')->with('success', 'Cita eliminada.');
    }

    // Cancelar cita (marca estado=cancelada y notifica al paciente)
    public function cancelar(Request $request, Cita $cita)
    {
        $user = Auth::user();
        // Permitir al dueño de la cita, al especialista asignado o a roles administrativos
        $puede = ($cita->usuario_id === $user->id)
            || ($cita->especialista_id === $user->id)
            || ($user->hasRole(['super-admin', 'admin_clinica', 'recepcionista']));
        if (!$puede) {
            abort(403);
        }

        if ($cita->estado === 'cancelada') {
            return back()->with('info', 'La cita ya estaba cancelada.');
        }
        if ($cita->estado === 'concluida') {
            return back()->with('info', 'No se puede cancelar una cita concluida.');
        }

        $anterior = $cita->fecha;
        $cita->estado = 'cancelada';
        $cita->save();

        try {
            if ($cita->usuario && $cita->usuario->email) {
                Mail::to($cita->usuario->email)->queue(new \App\Mail\CitaActualizada($cita, 'cancelada', $anterior));
            }
        } catch (\Throwable $e) {
            Log::error('Fallo al enviar correo de cita cancelada: ' . $e->getMessage());
        }

        return back()->with('success', 'Cita cancelada.');
    }

    // Reprogramar cita (valida disponibilidad, actualiza fecha y notifica)
    public function reprogramar(Request $request, Cita $cita)
    {
        $user = Auth::user();
        $puede = ($cita->usuario_id === $user->id)
            || ($cita->especialista_id === $user->id)
            || ($user->hasRole(['super-admin', 'admin_clinica', 'recepcionista']));
        if (!$puede) {
            abort(403);
        }

        if (in_array($cita->estado, ['cancelada', 'concluida'])) {
            return back()->withErrors(['fecha' => 'No se puede reprogramar una cita ' . ($cita->estado === 'cancelada' ? 'cancelada' : 'concluida') . '.']);
        }

        $validated = $request->validate([
            'fecha' => ['required', 'date_format:Y-m-d H:i'],
        ]);

        $nuevaFecha = \Carbon\Carbon::createFromFormat('Y-m-d H:i', $validated['fecha']);
        $diaKey = strtolower($nuevaFecha->englishDayOfWeek);

        // Verificar que cae dentro de disponibilidad del especialista
        $dentroHorario = Disponibilidad::where('especialista_id', $cita->especialista_id)
            ->where('dia_semana', $diaKey)
            ->where('hora_inicio', '<=', $nuevaFecha->format('H:i'))
            ->where('hora_fin', '>', $nuevaFecha->format('H:i'))
            ->exists();
        if (!$dentroHorario) {
            return back()->withErrors(['fecha' => 'La hora elegida no coincide con el horario del especialista.']);
        }

        // Verificar colisión con otras citas del especialista
        $existe = Cita::where('especialista_id', $cita->especialista_id)
            ->where('id', '!=', $cita->id)
            ->where('fecha', $validated['fecha'])
            ->exists();
        if ($existe) {
            return back()->withErrors(['fecha' => 'El horario seleccionado ya no está disponible.']);
        }

        $anterior = $cita->fecha;
        $cita->fecha = $validated['fecha'];
        // Mantenemos estado en 'pendiente' si estaba pendiente; si estaba 'cancelada' no permitimos reprogramar
        // Estado permanece en pendiente o similar; no se soporta reprogramación si fue cancelada o concluida (validado arriba)
        $cita->estado = 'pendiente';
        $cita->save();

        try {
            if ($cita->usuario && $cita->usuario->email) {
                Mail::to($cita->usuario->email)->queue(new \App\Mail\CitaActualizada($cita, 'reprogramada', $anterior));
            }
        } catch (\Throwable $e) {
            Log::error('Fallo al enviar correo de cita reprogramada: ' . $e->getMessage());
        }

        return back()->with('success', 'Cita reprogramada.');
    }

    // AJAX: lista de especialistas por especialidad
    public function doctoresPorEspecialidad(Request $request)
    {
        $request->validate(['especialidad_id' => ['required', 'exists:especialidades,id']]);
        $especialidadId = (int) $request->query('especialidad_id');
        $doctores = User::role('especialista')
            ->whereHas('especialidades', function ($q) use ($especialidadId) {
                $q->where('especialidades.id', $especialidadId);
            })
            ->orderBy('name')
            ->get(['id', 'name']);

        $payload = $doctores->map(fn($u) => [
            'id' => $u->id,
            'nombre' => $u->name,
        ])->values();

        return response()->json([
            'data' => $payload,
            'count' => $payload->count(),
        ]);
    }

    // AJAX: obtener slots disponibles para un especialista en una fecha (Y-m-d)
    public function slotsDisponibles(Request $request)
    {
        $validated = $request->validate([
            'especialista_id' => ['required', 'exists:usuarios,id'],
            'fecha' => ['required', 'date_format:Y-m-d'],
        ]);

        $especialista = User::role('especialista')->findOrFail($validated['especialista_id']);
        $date = \Carbon\Carbon::createFromFormat('Y-m-d', $validated['fecha']);
        $diaKey = strtolower($date->englishDayOfWeek); // monday..sunday

        // Obtener los bloques de disponibilidad del día
        $disps = Disponibilidad::where('especialista_id', $especialista->id)
            ->where('dia_semana', $diaKey)
            ->orderBy('hora_inicio')
            ->get(['hora_inicio', 'hora_fin']);

        $duracionMin = 30; // minutos por cita
        $slots = [];
        foreach ($disps as $disp) {
            $inicio = \Carbon\Carbon::parse($validated['fecha'] . ' ' . $disp->hora_inicio);
            $fin = \Carbon\Carbon::parse($validated['fecha'] . ' ' . $disp->hora_fin);
            for ($dt = $inicio->copy(); $dt->lt($fin); $dt->addMinutes($duracionMin)) {
                // Evitar slots en el pasado si la fecha es hoy
                if ($dt->isPast()) {
                    continue;
                }
                $slotStr = $dt->format('Y-m-d H:i');
                $ocupada = Cita::where('especialista_id', $especialista->id)
                    ->where('fecha', $slotStr)
                    ->exists();
                if (!$ocupada) {
                    // Mostrar hora en formato 12h con am/pm sin espacio (ej: 08:00am)
                    $hora12 = str_replace(' ', '', $dt->format('h:i a'));
                    $slots[] = [
                        'valor' => $slotStr,     // valor usado para enviar al backend (Y-m-d H:i en 24h)
                        'hora' => $hora12,       // etiqueta amigable 12h
                        'hora_24' => $dt->format('H:i'), // referencia opcional 24h por si se necesita en el front
                    ];
                }
            }
        }

        return response()->json(['data' => $slots]);
    }

    // AJAX: días disponibles (con conteo de slots) para un especialista en un rango relativo (por defecto hoy + 21 días)
    public function diasDisponibles(Request $request)
    {
        $validated = $request->validate([
            'especialista_id' => ['required', 'exists:usuarios,id'],
            'dias' => ['nullable', 'integer', 'min:1', 'max:60'],
        ]);
        $especialista = User::role('especialista')->findOrFail($validated['especialista_id']);
        $span = $validated['dias'] ?? 21;

        $hoy = \Carbon\Carbon::today();
        $fin = $hoy->copy()->addDays($span - 1);

        // Traer disponibilidades del especialista agrupadas por día_semana
        $disps = Disponibilidad::where('especialista_id', $especialista->id)
            ->get(['dia_semana', 'hora_inicio', 'hora_fin']);
        if ($disps->isEmpty()) {
            return response()->json(['data' => []]);
        }
        $porDiaSemana = $disps->groupBy('dia_semana');

        $resultado = [];
        for ($date = $hoy->copy(); $date->lte($fin); $date->addDay()) {
            $diaKey = strtolower($date->englishDayOfWeek); // monday..sunday
            $bloques = $porDiaSemana[$diaKey] ?? null;
            if (!$bloques) {
                continue; // día sin disponibilidad
            }
            $slotsCount = 0;
            foreach ($bloques as $b) {
                $inicio = \Carbon\Carbon::parse($date->format('Y-m-d') . ' ' . $b->hora_inicio);
                $finHora = \Carbon\Carbon::parse($date->format('Y-m-d') . ' ' . $b->hora_fin);
                $duracionMin = 30;
                for ($dt = $inicio->copy(); $dt->lt($finHora); $dt->addMinutes($duracionMin)) {
                    if ($dt->isPast())
                        continue; // no contar horas pasadas
                    $ocupada = Cita::where('especialista_id', $especialista->id)
                        ->where('fecha', $dt->format('Y-m-d H:i'))
                        ->exists();
                    if (!$ocupada) {
                        $slotsCount++;
                    }
                }
            }
            if ($slotsCount > 0) {
                $resultado[] = [
                    'fecha' => $date->format('Y-m-d'),
                    'dia' => $date->format('d'),
                    'mes' => $date->format('m'),
                    'nombre_dia' => $date->locale('es')->dayName,
                    'slots' => $slotsCount,
                ];
            }
        }

        return response()->json(['data' => $resultado]);
    }

    // Gestión de consulta por el especialista: guardar diagnóstico, tratamiento, medicamentos, observaciones y adjuntos
    public function gestionar(Request $request, Cita $cita)
    {
        $user = Auth::user();
        $puede = ($cita->especialista_id === $user->id) || ($user->hasRole(['super-admin', 'admin_clinica']));
        if (!$puede)
            abort(403);

        // No permitir gestionar una cita cancelada o concluida
        if ($cita->estado === 'cancelada') {
            return back()->with('info', 'La cita está cancelada y no se puede gestionar.');
        }
        if ($cita->estado === 'concluida') {
            return back()->with('info', 'La cita ya fue concluida y no se puede modificar.');
        }

        $validated = $request->validate([
            'diagnostico' => ['required', 'string', 'min:3'],
            'observaciones' => ['nullable', 'string'],
            'concluir' => ['nullable', 'boolean'],
            // medicamentos estructurados (campo combinado nombre + presentación)
            'medicamentos' => ['nullable', 'array', 'max:10'],
            'medicamentos.*.nombre_generico' => ['required_with:medicamentos', 'string', 'max:255'], // ahora puede incluir presentación
            'medicamentos.*.posologia' => ['nullable', 'string', 'max:255'],
            'medicamentos.*.frecuencia' => ['nullable', 'string', 'max:150'],
            'medicamentos.*.duracion' => ['nullable', 'string', 'max:150'],
            // adjuntos
            'adjuntos' => ['nullable', 'array', 'max:6'],
            'adjuntos.*' => ['file', 'mimes:jpg,jpeg,png,webp,heic,pdf', 'max:5120'],
        ]);

        DB::transaction(function () use ($cita, $validated, $request) {
            $cita->diagnostico = $validated['diagnostico'];
            $cita->observaciones = $validated['observaciones'] ?? null;
            // Mantener medicamentos_texto como respaldo si el front lo provee en bloque (opcional)
            if ($request->filled('medicamentos_texto')) {
                $cita->medicamentos_texto = $request->string('medicamentos_texto');
            }

            if (!empty($validated['medicamentos'])) {
                // Reescribir todos los medicamentos declarados
                $cita->medicamentos()->delete();
                $orden = 1;
                foreach ($validated['medicamentos'] as $med) {
                    if (empty($med['nombre_generico']))
                        continue;
                    // Intentar separar presentación si el usuario ingresó "Nombre Presentación" o con coma/ guión
                    $nombreBruto = trim($med['nombre_generico']);
                    $nombre = $nombreBruto;
                    $presentacion = null;
                    // Heurística: si contiene ' - ' o ' — ' dividir; si contiene coma, dividir primera coma; si varias palabras y última parece unidad (mg, ml, %, UI, comprimidos, caps, tab, ampolla(s)) entonces separar
                    if (preg_match('/\s[-–—]\s/', $nombreBruto)) {
                        [$nombre, $presentacion] = preg_split('/\s[-–—]\s/', $nombreBruto, 2);
                    } elseif (str_contains($nombreBruto, ',')) {
                        [$nombre, $presentacion] = array_map('trim', explode(',', $nombreBruto, 2));
                    } else {
                        $parts = preg_split('/\s+/', $nombreBruto);
                        if (count($parts) > 1) {
                            $ultima = strtolower(end($parts));
                            if (preg_match('/^(mg|ml|g|ug|µg|mcg|%|ui|u|comprimidos?|tabs?|tabletas?|caps?(ulas)?|cap?s|amp(olla|ollas)?|viales?)$/', $ultima)) {
                                $presentacion = array_pop($parts);
                                $nombre = trim(implode(' ', $parts));
                            }
                        }
                    }

                    $cita->medicamentos()->create([
                        'nombre_generico' => $nombre,
                        'presentacion' => $presentacion,
                        'posologia' => $med['posologia'] ?? null,
                        'frecuencia' => $med['frecuencia'] ?? null,
                        'duracion' => $med['duracion'] ?? null,
                        'orden' => $orden++,
                    ]);
                }
            }

            // Adjuntos
            if (!empty($validated['adjuntos'])) {
                foreach ($validated['adjuntos'] as $file) {
                    $path = $file->store('citas/' . $cita->id, 'public');
                    $cita->adjuntos()->create([
                        'ruta' => $path,
                        'nombre_original' => $file->getClientOriginalName(),
                        'mime' => $file->getClientMimeType(),
                        'size' => $file->getSize(),
                    ]);
                }
            }

            if (filter_var($validated['concluir'] ?? false, FILTER_VALIDATE_BOOL)) {
                // Si no está cancelada, pasamos a concluida; si está cancelada, solo marcamos concluida_at
                if ($cita->estado !== 'cancelada') {
                    $cita->estado = 'concluida';
                }
                $cita->concluida_at = now();
            }

            $cita->save();
        });

        return back()->with('success', 'Gestión de consulta guardada.');
    }

    // Receta legible para paciente (y especialista)
public function receta(Request $request, Cita $cita)
{
    $user = Auth::user();
    $puedeVer = ($cita->usuario_id === $user->id) || ($cita->especialista_id === $user->id) || ($user->hasRole(['super-admin', 'admin_clinica']));
    if (!$puedeVer)
        abort(403);

    $cita->load(['medicamentos', 'especialista', 'clinica']);
    
    // PRIORIDAD: Si el usuario es el paciente dueño de la cita, mostrar vista de paciente
    // independientemente de si tiene otros roles
    if ($cita->usuario_id === $user->id) {
        return view('citas.receta', compact('cita'));
    }
    
    // Si no es el paciente, usar vista administrativa
    return view('citas.admin.receta', compact('cita'));
    }

    // Receta pública (firmada) para acceso externo / app móvil
    public function publicReceta(Request $request, Cita $cita)
    {
        // La seguridad la garantiza el middleware 'signed'
        $cita->load(['medicamentos', 'especialista', 'clinica']);
        return view('citas.receta_publica', compact('cita'));
    }
}
