<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Auth\Events\Registered;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules;
use Illuminate\View\View;

class RegisteredUserController extends Controller
{
    /**
     * Display the registration view.
     */
    public function create(): View
    {
        return view('auth.register');
    }

    /**
     * Handle an incoming registration request.
     *
     * @throws \Illuminate\Validation\ValidationException
     */
    public function store(Request $request): RedirectResponse
    {
        // Normalizar cédula antes de validar
        $cedula = strtoupper(trim($request->cedula));
        if (preg_match('/^([VEJGP])(\d{6,8})$/i', $cedula, $matches)) {
            $cedula = $matches[1] . '-' . $matches[2];
        }
        $request->merge(['cedula' => $cedula]);

        // Verificar si existe usuario con esa cédula
        $usuarioExistente = User::where('cedula', $cedula)->first();

        if ($usuarioExistente) {
            // Si tiene email temporal, permitir actualización (auto-vinculación)
            if (str_ends_with($usuarioExistente->email, '@paciente.temp')) {
                // Validar solo email y contraseña (la cédula ya existe)
                $request->validate([
                    'name' => ['required', 'string', 'max:255'],
                    'email' => ['required', 'string', 'email', 'max:255', 'unique:usuarios,email'],
                    'fecha_nacimiento' => ['required', 'date', 'before:today'],
                    'sexo' => ['required', 'in:M,F'],
                    'password' => ['required', 'confirmed', Rules\Password::defaults()],
                ], [
                    'fecha_nacimiento.required' => 'La fecha de nacimiento es obligatoria',
                    'fecha_nacimiento.date' => 'La fecha de nacimiento debe ser una fecha válida',
                    'fecha_nacimiento.before' => 'La fecha de nacimiento debe ser anterior a hoy',
                    'sexo.required' => 'El sexo es obligatorio',
                    'sexo.in' => 'El sexo seleccionado no es válido',
                ]);

                // Actualizar cuenta existente con datos reales
                $usuarioExistente->update([
                    'name' => $request->name,
                    'email' => $request->email,
                    'fecha_nacimiento' => $request->fecha_nacimiento,
                    'sexo' => $request->sexo,
                    'password' => Hash::make($request->password),
                ]);

                event(new Registered($usuarioExistente));

                // Enviar correo de bienvenida
                \Illuminate\Support\Facades\Mail::to($usuarioExistente->email)->send(new \App\Mail\WelcomeEmail($usuarioExistente));

                Auth::login($usuarioExistente);

                return redirect()->route('panel.pacientes')
                    ->with('success', '¡Cuenta activada exitosamente! Tus datos han sido actualizados y ahora puedes acceder a todos tus resultados.');
            } else {
                // Ya tiene cuenta real, mostrar error con sugerencia
                return back()->withErrors([
                    'cedula' => 'Esta cédula ya está registrada. Si olvidaste tu contraseña, usa la opción "¿Olvidaste tu contraseña?"'
                ])->withInput($request->except('password', 'password_confirmation'));
            }
        }

        // No existe, proceder con registro normal
        $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:usuarios,email'],
            'cedula' => [
                'required', 
                'string', 
                'max:50', 
                'unique:usuarios,cedula',
                'regex:/^[VEJGP]-\d{6,8}$/i'
            ],
            'fecha_nacimiento' => ['required', 'date', 'before:today'],
            'sexo' => ['required', 'in:M,F'],
            'password' => ['required', 'confirmed', Rules\Password::defaults()],
        ], [
            'cedula.regex' => 'El formato de la cédula debe ser: V-12345678 (6 a 8 dígitos). Letras permitidas: V, E, J, G, P',
            'cedula.unique' => 'Esta cédula ya está registrada en el sistema',
            'fecha_nacimiento.required' => 'La fecha de nacimiento es obligatoria',
            'fecha_nacimiento.date' => 'La fecha de nacimiento debe ser una fecha válida',
            'fecha_nacimiento.before' => 'La fecha de nacimiento debe ser anterior a hoy',
            'sexo.required' => 'El sexo es obligatorio',
            'sexo.in' => 'El sexo seleccionado no es válido',
        ]);

        // Asignar a la clínica por defecto (SaludSonrisa) si existe
        $clinicaId = \App\Models\Clinica::first()?->id ?? null;

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'cedula' => $cedula,
            'fecha_nacimiento' => $request->fecha_nacimiento,
            'sexo' => $request->sexo,
            'password' => Hash::make($request->password),
            'clinica_id' => $clinicaId,
        ]);

        // Asignar rol de paciente por defecto a los usuarios que se registran desde el portal
        if (method_exists($user, 'assignRole')) {
            $user->assignRole('paciente');
        }

        event(new Registered($user));

        // Enviar correo de bienvenida
        \Illuminate\Support\Facades\Mail::to($user->email)->send(new \App\Mail\WelcomeEmail($user));

        Auth::login($user);

        // Redirigir a la zona de pacientes tras el registro
        return redirect()->route('panel.pacientes');
    }
}
