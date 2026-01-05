<?php

namespace App\Http\Controllers\Especialista;

use App\Http\Controllers\Controller;
use App\Models\Disponibilidad;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;
use Illuminate\Validation\Rule;

class DisponibilidadController extends Controller
{
    public const DIAS_SEMANA = [
        'monday' => 'Lunes',
        'tuesday' => 'Martes',
        'wednesday' => 'Miércoles',
        'thursday' => 'Jueves',
        'friday' => 'Viernes',
        'saturday' => 'Sábado',
        'sunday' => 'Domingo',
    ];

    public function index(Request $request): View
    {
        $especialista = $request->user();

        $disponibilidades = $especialista->disponibilidades()
            ->orderByRaw("FIELD(dia_semana, 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday')")
            ->orderBy('hora_inicio')
            ->get();

        return view('especialista.horarios.index', [
            'disponibilidades' => $disponibilidades,
            'diasSemana' => self::DIAS_SEMANA,
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $especialista = $request->user();

        $validated = $request->validate([
            'dia_semana' => ['required', Rule::in(array_keys(self::DIAS_SEMANA))],
            'hora_inicio' => ['required', 'date_format:H:i'],
            'hora_fin' => ['required', 'date_format:H:i', 'after:hora_inicio'],
        ]);

        $overlap = Disponibilidad::where('especialista_id', $especialista->id)
            ->where('dia_semana', $validated['dia_semana'])
            ->where(function ($query) use ($validated) {
                $query->where(function ($slot) use ($validated) {
                    $slot->where('hora_inicio', '<', $validated['hora_fin'])
                        ->where('hora_fin', '>', $validated['hora_inicio']);
                });
            })
            ->exists();

        if ($overlap) {
            return back()
                ->withErrors(['dia_semana' => 'Ya tienes un horario que se solapa con el intervalo seleccionado.'])
                ->withInput();
        }

        Disponibilidad::create([
            'especialista_id' => $especialista->id,
            'dia_semana' => $validated['dia_semana'],
            'hora_inicio' => $validated['hora_inicio'],
            'hora_fin' => $validated['hora_fin'],
        ]);

        return redirect()
            ->route('especialista.horarios.index')
            ->with('status', 'Horario agregado correctamente.');
    }

    public function destroy(Request $request, Disponibilidad $disponibilidad): RedirectResponse
    {
        $especialista = $request->user();

        if ($disponibilidad->especialista_id !== $especialista->id) {
            abort(403);
        }

        $disponibilidad->delete();

        return redirect()
            ->route('especialista.horarios.index')
            ->with('status', 'Horario eliminado.');
    }
}
