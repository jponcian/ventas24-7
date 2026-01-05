<?php

namespace App\Http\Controllers;

use App\Models\Atencion;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class AtencionController extends Controller
{
    // Recepción y especialistas verán distintos listados
    public function index()
    {
        $user = Auth::user();
        if ($user->hasRole(['recepcionista','admin_clinica','super-admin'])) {
            // Filtros básicos: estado, médico, paciente
            $q = Atencion::query()->orderByDesc('id');
            if (request('estado')) $q->where('estado', request('estado'));
            if (request('medico_id')) $q->where('medico_id', request('medico_id'));
            if (request('paciente_id')) $q->where('paciente_id', request('paciente_id'));
            $atenciones = $q->with(['paciente','medico'])->paginate(15)->withQueryString();
            $especialidades = \App\Models\Especialidad::orderBy('nombre')->get(['id','nombre']);
            return view('atenciones.recepcion.index', compact('atenciones','especialidades'));
        }
        if ($user->hasRole('especialista')) {
            $q = Atencion::with(['paciente'])->where('medico_id', $user->id)->orderByDesc('id');
            if (request('estado')) $q->where('estado', request('estado'));
            $atenciones = $q->paginate(15)->withQueryString();
            return view('atenciones.especialista.index', compact('atenciones'));
        }
        // Paciente: ver sus propias atenciones (historial por seguro)
        // Los pacientes ahora ven sus atenciones integradas en el listado unificado de Citas (CitaController@index)
        if ($user->hasRole('paciente')) {
            return redirect()->route('citas.index');
        }
        abort(403);
    }

    // Recepción: crear proceso tras validar seguro
    public function store(Request $request)
    {
        $this->authorizeRecepcion();
        $validated = $request->validate([
            'paciente_id' => ['required','exists:usuarios,id'],
            'aseguradora' => ['nullable','string','max:150'],
            'numero_siniestro' => ['nullable','string','max:150'],
            'empresa' => ['nullable','string','max:150'],
            'nombre_operador' => ['nullable','string','max:150'],
            'seguro_validado' => ['required','boolean'],
            'es_titular' => ['required','in:0,1'],
            'titular_id' => ['nullable','exists:usuarios,id'],
        ]);

        $titular_id = $validated['es_titular'] == '1' ? $validated['paciente_id'] : ($validated['titular_id'] ?? null);

        $atencion = Atencion::create([
            'paciente_id' => $validated['paciente_id'],
            'clinica_id' => 1,
            'recepcionista_id' => Auth::id(),
            'especialidad_id' => null,
            'aseguradora' => $validated['aseguradora'] ?? null,
            'numero_siniestro' => $validated['numero_siniestro'] ?? null,
            'empresa' => $validated['empresa'] ?? null,
            'nombre_operador' => $validated['nombre_operador'] ?? null,
            'seguro_validado' => (bool)$validated['seguro_validado'],
            'validado_at' => now(),
            'validado_por' => Auth::id(),
            'estado' => 'validado',
            'iniciada_at' => now(),
            'titular_id' => $titular_id,
        ]);

        return redirect()->route('atenciones.index')->with('success', 'Atención creada correctamente.');
    }

    // Recepción: asignar médico
    public function asignarMedico(Request $request, Atencion $atencion)
    {
        $this->authorizeRecepcion();
        // Regla: no permitir modificaciones sobre atenciones cerradas
        if ($atencion->estado === 'cerrado') {
            return back()->with('info', 'No se puede asignar un médico a una atención cerrada.');
        }
        $data = $request->validate([
            'medico_id' => ['required','exists:usuarios,id'], // viene de autocomplete (no ingresar IDs manualmente en UI)
        ]);
        $medico = User::role('especialista')->findOrFail($data['medico_id']);
        $atencion->medico_id = $medico->id;
        if (empty($atencion->especialidad_id)) {
            $atencion->especialidad_id = $medico->especialidad_id ?? null;
        }
        $atencion->estado = 'en_consulta';
        $atencion->save();
        return back()->with('success', 'Médico asignado.');
    }

    // Especialista: gestionar atención (similar a CitaController::gestionar)
    public function gestionar(Request $request, Atencion $atencion)
    {
        $user = Auth::user();
        $puede = ($atencion->medico_id === $user->id) || ($user->hasRole(['super-admin','admin_clinica']));
        if (!$puede) abort(403);

        // Regla: una atención cerrada no puede ser modificada
        if ($atencion->estado === 'cerrado') {
            return back()->with('info', 'La atención ya está cerrada y no se puede modificar.');
        }

        $validated = $request->validate([
            'diagnostico' => ['required','string','min:3'],
            'observaciones' => ['nullable','string'],
            'concluir' => ['nullable','boolean'],
            'medicamentos' => ['nullable','array','max:10'],
            'medicamentos.*.nombre_generico' => ['required_with:medicamentos','string','max:255'],
            'medicamentos.*.posologia' => ['nullable','string','max:255'],
            'medicamentos.*.frecuencia' => ['nullable','string','max:150'],
            'medicamentos.*.duracion' => ['nullable','string','max:150'],
            'adjuntos' => ['nullable','array','max:6'],
            'adjuntos.*' => ['file','mimes:jpg,jpeg,png,webp,heic,pdf','max:5120'],
        ]);

        DB::transaction(function () use ($atencion, $validated, $request) {
            $atencion->diagnostico = $validated['diagnostico'];
            $atencion->observaciones = $validated['observaciones'] ?? null;

            if (!empty($validated['medicamentos'])) {
                $atencion->medicamentos()->delete();
                $orden = 1;
                foreach ($validated['medicamentos'] as $med) {
                    if (empty($med['nombre_generico'])) continue;
                    $nombreBruto = trim($med['nombre_generico']);
                    $nombre = $nombreBruto; $presentacion = null;
                    if (preg_match('/\s[-–—]\s/', $nombreBruto)) {
                        [$nombre,$presentacion] = preg_split('/\s[-–—]\s/', $nombreBruto,2);
                    } elseif (str_contains($nombreBruto, ',')) {
                        [$nombre,$presentacion] = array_map('trim', explode(',', $nombreBruto,2));
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
                    $atencion->medicamentos()->create([
                        'nombre_generico' => $nombre,
                        'presentacion' => $presentacion,
                        'posologia' => $med['posologia'] ?? null,
                        'frecuencia' => $med['frecuencia'] ?? null,
                        'duracion' => $med['duracion'] ?? null,
                        'orden' => $orden++,
                    ]);
                }
            }

            if (!empty($validated['adjuntos'])) {
                foreach ($validated['adjuntos'] as $file) {
                    $path = $file->store('atenciones/'.$atencion->id, 'public');
                    $atencion->adjuntos()->create([
                        'ruta' => $path,
                        'nombre_original' => $file->getClientOriginalName(),
                        'mime' => $file->getClientMimeType(),
                        'size' => $file->getSize(),
                    ]);
                }
            }

            if (filter_var($validated['concluir'] ?? false, FILTER_VALIDATE_BOOL)) {
                $atencion->estado = 'cerrado';
                $atencion->cerrada_at = now();
            }

            $atencion->save();
        });

        return back()->with('success', 'Atención actualizada.');
    }

    // Recepción: cerrar atención
    public function cerrar(Request $request, Atencion $atencion)
    {
        $this->authorizeRecepcion();
        if ($atencion->estado === 'cerrado') {
            return back()->with('info', 'La atención ya está cerrada.');
        }
        $atencion->estado = 'cerrado';
        $atencion->cerrada_at = now();
        $atencion->save();
        return back()->with('success', 'Atención cerrada.');
    }

    // Buscador AJAX de pacientes por nombre/email
    public function buscarPacientes(Request $request)
    {
        $this->authorizeRecepcion();
        $term = trim($request->query('q',''));
        $users = \App\Models\User::role('paciente')
            ->when($term, fn($qq) => $qq->where('name','like',"%{$term}%")->orWhere('email','like',"%{$term}%"))
            ->orderBy('name')
            ->limit(10)
            ->get(['id','name','email']);
        return response()->json(['data'=>$users->map(fn($u)=>[
            'id'=>$u->id,
            'nombre'=>$u->name,
            'email'=>$u->email,
        ])]);
    }

    // Buscador AJAX de clínicas
    public function buscarClinicas(Request $request)
    {
        $this->authorizeRecepcion();
        $term = trim($request->query('q',''));
        $clinicas = \App\Models\Clinica::query()
            ->when($term, fn($qq)=>$qq->where('nombre','like',"%{$term}%"))
            ->orderBy('nombre')
            ->limit(10)
            ->get(['id','nombre']);
        return response()->json(['data'=>$clinicas]);
    }

    // Buscador AJAX de médicos (especialistas) por nombre y opcional especialidad
    public function buscarMedicos(Request $request)
    {
        $this->authorizeRecepcion();
        $term = trim($request->query('q',''));
        $especialidadId = $request->query('especialidad_id');
        $medicos = \App\Models\User::role('especialista')
            ->when($especialidadId, fn($qq)=>$qq->where('especialidad_id',$especialidadId))
            ->when($term, fn($qq)=>$qq->where('name','like',"%{$term}%"))
            ->orderBy('name')
            ->limit(10)
            ->get(['id','name','especialidad_id']);
        return response()->json(['data'=>$medicos->map(fn($m)=>[
            'id'=>$m->id,
            'nombre'=>$m->name,
            'especialidad_id'=>$m->especialidad_id,
        ])]);
    }

    private function authorizeRecepcion(): void
    {
        $user = Auth::user();
        if (!$user->hasRole(['recepcionista','admin_clinica','super-admin'])) abort(403);
    }

    // Vista de detalle (solo lectura) para paciente
    public function showPaciente(Atencion $atencion)
    {
        $user = Auth::user();
        if ($user->id !== $atencion->paciente_id) abort(403);
        $atencion->load(['medico','clinica','medicamentos']);
        return view('atenciones.paciente.show', compact('atencion'));
    }

    // Receta de atención (solo lectura para paciente)
    public function recetaPaciente(Atencion $atencion)
    {
        $user = Auth::user();
        if ($user->id !== $atencion->paciente_id) abort(403);
        $atencion->load(['medicamentos','medico','clinica']);
        return view('atenciones.paciente.receta', compact('atencion'));
    }
}
