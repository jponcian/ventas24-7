<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\View\View;

class AuthenticatedSessionController extends Controller
{
    /**
     * Display the login view.
     */
    public function create(Request $request): View
    {
        return view('auth.login', ['perfil' => $request->query('perfil')]);
    }

    /**
     * Handle an incoming authentication request.
     */
    public function store(LoginRequest $request): RedirectResponse
    {
        $request->authenticate();

        $request->session()->regenerate();

        $user = Auth::user();

        $perfil = $request->input('perfil');

        // Lógica de redirección basada en el perfil solicitado y roles
        if ($perfil === 'empleados' && $user->hasAnyRole(['super-admin', 'admin_clinica', 'recepcionista', 'especialista', 'laboratorio', 'laboratorio-resul', 'almacen', 'almacen-jefe'])) {
            $target = route('panel.clinica', absolute: false);
        } elseif ($perfil === 'pacientes' && $user->hasRole('paciente')) {
            $target = route('panel.pacientes', absolute: false);
        } else {
            // Fallback original (con roles actualizados)
            if ($user && $user->hasRole('paciente')) {
                $target = route('panel.pacientes', absolute: false);
            } elseif ($user && $user->hasAnyRole(['super-admin', 'admin_clinica', 'recepcionista', 'especialista', 'laboratorio', 'laboratorio-resul', 'almacen', 'almacen-jefe'])) {
                $target = route('panel.clinica', absolute: false);
            } else {
                $target = route('dashboard', absolute: false);
            }
        }

        return redirect()->intended($target);
    }

    /**
     * Destroy an authenticated session.
     */
    public function destroy(Request $request): RedirectResponse
    {
        Auth::guard('web')->logout();

        $request->session()->invalidate();

        $request->session()->regenerateToken();

        return redirect('/');
    }
}
