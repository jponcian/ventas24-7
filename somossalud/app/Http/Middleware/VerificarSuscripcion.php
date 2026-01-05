<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Suscripcion;

class VerificarSuscripcion
{
    /**
     * Handle an incoming request.
     * Si el usuario es paciente, verifica que tenga una suscripción activa.
     */
    public function handle(Request $request, Closure $next)
    {
        $user = Auth::user();

        if (!$user) {
            return redirect()->route('login');
        }

        // Solo aplicar la verificación a pacientes
        if (method_exists($user, 'hasRole') && $user->hasRole('paciente')) {
            $tiene = Suscripcion::where('usuario_id', $user->id)
                ->where('estado', 'activo')
                ->whereDate('periodo_vencimiento', '>=', now())
                ->exists();

            if (!$tiene) {
                return redirect()->route('suscripcion.show')
                    ->with('error', 'Debes tener una suscripción activa para acceder a esta funcionalidad.');
            }
        }

        return $next($request);
    }
}
