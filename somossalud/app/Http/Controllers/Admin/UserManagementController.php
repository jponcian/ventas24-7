<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Especialidad;
use App\Models\User;
use App\Services\WhatsAppService;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;
use Illuminate\View\View;
use Spatie\Permission\Models\Role;

class UserManagementController extends Controller
{
    public function index(): View
    {
        $usuarioActual = Auth::user();
        $roles = \Spatie\Permission\Models\Role::where('name', '!=', 'super-admin')->orderBy('name')->pluck('name');
        $filtroRol = request('rol');
        $buscar = request('buscar');
        $usuariosQuery = User::with(['roles', 'especialidad'])
            ->whereDoesntHave('roles', function ($q) {
                $q->where('name', 'super-admin');
            });

        // Si es recepcionista (y no es admin): solo puede ver pacientes
        if ($usuarioActual && $usuarioActual->hasRole('recepcionista') && !$usuarioActual->hasAnyRole(['super-admin', 'admin_clinica'])) {
            $roles = collect(['paciente']);
            $usuariosQuery->whereHas('roles', function ($q) {
                $q->where('name', 'paciente');
            });
            // Forzar el filtro a paciente si llega otro valor
            if ($filtroRol && $filtroRol !== 'paciente') {
                $filtroRol = 'paciente';
            }
        }

        if ($filtroRol) {
            $usuariosQuery->whereHas('roles', function ($q) use ($filtroRol) {
                $q->where('name', $filtroRol);
            });
        }

        // Filtro de búsqueda por nombre, email o cédula
        if ($buscar) {
            $usuariosQuery->where(function ($q) use ($buscar) {
                $q->where('name', 'LIKE', "%{$buscar}%")
                  ->orWhere('email', 'LIKE', "%{$buscar}%")
                  ->orWhere('cedula', 'LIKE', "%{$buscar}%");
            });
        }

        $usuarios = $usuariosQuery->orderByDesc('created_at')->paginate(12)->appends([
            'rol' => $filtroRol,
            'buscar' => $buscar
        ]);

        return view('admin.users.index', [
            'usuarios' => $usuarios,
            'roles' => $roles,
            'filtroRol' => $filtroRol,
        ]);
    }

    public function create(): View
    {
        $esRecepcionistaLimitado = Auth::user()->hasRole('recepcionista') && !Auth::user()->hasAnyRole(['super-admin', 'admin_clinica']);

        $roles = $esRecepcionistaLimitado
            ? collect(['paciente'])
            : Role::where('name', '!=', 'super-admin')->orderBy('name')->pluck('name');
        $especialidades = Especialidad::orderBy('nombre')->get();

        // Obtener posibles representantes (usuarios que no son dependientes)
        // Filtramos por aquellos que NO tienen representante_id
        $posiblesRepresentantes = User::whereNull('representante_id')
            ->orderBy('name')
            ->get(['id', 'name', 'cedula', 'email']);

        return view('admin.users.create', [
            'roles' => $roles,
            'especialidades' => $especialidades,
            'posiblesRepresentantes' => $posiblesRepresentantes,
        ]);
    }

    public function store(Request $request)
    {
        // Si es recepcionista (y no admin), forzar rol paciente y sin especialidad
        if (Auth::user()->hasRole('recepcionista') && !Auth::user()->hasAnyRole(['super-admin', 'admin_clinica'])) {
            $request->merge(['roles' => ['paciente'], 'especialidad_id' => null]);
        }

        // Normalizar cédula antes de validar (ahora acepta sufijo -H1, -H2, etc. para hijos)
        $cedula = strtoupper(trim($request->cedula));
        if (preg_match('/^([VEJGP])(\d{6,8})$/i', $cedula, $matches)) {
            $cedula = $matches[1] . '-' . $matches[2];
        }
        $request->merge(['cedula' => $cedula]);

        $roles = Role::where('name', '!=', 'super-admin')->pluck('name');
        $roleNames = $roles->toArray();

        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'cedula' => [
                'required',
                'string',
                'max:50',
                'unique:usuarios,cedula',
                'regex:/^[VEJGP]-\d{6,8}(-H\d+)?$/i' // Acepta V-12345678 o V-12345678-H1
            ],
            'email' => ['required', 'string', 'email', 'max:255'], // Removido unique para permitir emails compartidos
            'telefono' => ['nullable', 'regex:/^0(41[24]|42[246])\d{7}$/'], // Números venezolanos
            'fecha_nacimiento' => ['required', 'date', 'before:today'],
            'sexo' => ['required', 'in:M,F'],
            'password' => ['required', 'string', 'min:8', 'confirmed'],
            'roles' => ['required', 'array', 'min:1'],
            'roles.*' => ['string', 'in:' . implode(',', $roleNames)],
            'representante_id' => ['nullable', 'exists:usuarios,id'], // ID del representante si es un dependiente
        ], [
            'cedula.regex' => 'El formato de la cédula debe ser: V-12345678 o V-12345678-H1 (para hijos). Letras permitidas: V, E, J, G, P',
            'cedula.unique' => 'Esta cédula ya está registrada en el sistema',
            'telefono.regex' => 'El formato del teléfono debe ser: 0414-1234567 (Movistar: 0414/0424, Digitel: 0412/0422, Movilnet: 0416/0426)',
            'fecha_nacimiento.required' => 'La fecha de nacimiento es obligatoria',
            'fecha_nacimiento.date' => 'La fecha de nacimiento debe ser una fecha válida',
            'fecha_nacimiento.before' => 'La fecha de nacimiento debe ser anterior a hoy',
            'sexo.required' => 'El sexo es obligatorio',
            'sexo.in' => 'El sexo seleccionado no es válido',
        ]);

        $esEspecialista = collect($validated['roles'])->contains('especialista');

        if ($esEspecialista) {
            $request->validate([
                'especialidades' => ['required', 'array', 'min:1'],
                'especialidades.*' => ['exists:especialidades,id'],
            ]);
        }

        $usuario = User::create([
            'name' => strtoupper($validated['name']),
            'cedula' => $cedula,
            'email' => strtoupper($validated['email']),
            'telefono' => $validated['telefono'] ?? null,
            'fecha_nacimiento' => $validated['fecha_nacimiento'],
            'sexo' => $validated['sexo'],
            'password' => Hash::make($validated['password']),
            'especialidad_id' => $esEspecialista ? ($validated['especialidad_id'] ?? null) : null,
            'representante_id' => $validated['representante_id'] ?? null,
        ]);

        $usuario->syncRoles($validated['roles']);

        // Sincronizar especialidades múltiples (solo si es especialista)
        if ($esEspecialista && $request->has('especialidades')) {
            $usuario->especialidades()->sync($request->input('especialidades', []));
        }

        // Si es una petición AJAX, devolver JSON
        if ($request->expectsJson() || $request->ajax()) {
            return response()->json([
                'success' => true,
                'message' => 'Usuario registrado correctamente.',
                'user' => [
                    'id' => $usuario->id,
                    'name' => $usuario->name,
                    'cedula' => $usuario->cedula,
                    'email' => $usuario->email,
                ]
            ], 201);
        }

        return redirect()
            ->route('admin.users.index')
            ->with('status', 'Usuario registrado correctamente.');
    }

    public function edit(User $user): View
    {
        $user->load(['roles', 'especialidad']);

        // Recepcionista (no admin) solo puede editar pacientes
        $esRecepcionistaLimitado = Auth::user()->hasRole('recepcionista') && !Auth::user()->hasAnyRole(['super-admin', 'admin_clinica']);

        if ($esRecepcionistaLimitado && !$user->hasRole('paciente')) {
            abort(403);
        }

        $roles = $esRecepcionistaLimitado
            ? collect(['paciente'])
            : Role::where('name', '!=', 'super-admin')->orderBy('name')->pluck('name');
        $especialidades = Especialidad::orderBy('nombre')->get();
        $assignedRoles = $user->roles->pluck('name')->toArray();

        return view('admin.users.edit', [
            'usuario' => $user,
            'roles' => $roles,
            'especialidades' => $especialidades,
            'assignedRoles' => $assignedRoles,
        ]);
    }

    public function update(Request $request, User $user): RedirectResponse
    {
        // Recepcionista (no admin) solo puede actualizar pacientes y forzar rol paciente
        if (Auth::user()->hasRole('recepcionista') && !Auth::user()->hasAnyRole(['super-admin', 'admin_clinica'])) {
            if (!$user->hasRole('paciente')) {
                abort(403);
            }
            $request->merge(['roles' => ['paciente'], 'especialidad_id' => null]);
        }

        // Normalizar cédula antes de validar
        $cedula = strtoupper(trim($request->cedula));
        if (preg_match('/^([VEJGP])(\d{6,8})$/i', $cedula, $matches)) {
            $cedula = $matches[1] . '-' . $matches[2];
        }
        $request->merge(['cedula' => $cedula]);

        $roles = Role::where('name', '!=', 'super-admin')->pluck('name');
        $roleNames = $roles->toArray();

        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'cedula' => [
                'required',
                'string',
                'max:50',
                'unique:usuarios,cedula,' . $user->id,
                'regex:/^[VEJGP]-\d{6,8}(-H\d+)?$/i' // Acepta V-12345678 o V-12345678-H1
            ],
            'email' => ['required', 'string', 'email', 'max:255'], // Removido unique para permitir emails compartidos
            'telefono' => ['nullable', 'regex:/^0(41[24]|42[246])\d{7}$/'], // Números venezolanos
            'fecha_nacimiento' => ['required', 'date', 'before:today'],
            'sexo' => ['required', 'in:M,F'],
            'password' => ['nullable', 'string', 'min:8', 'confirmed'],
            'roles' => ['required', 'array', 'min:1'],
            'roles.*' => ['string', 'in:' . implode(',', $roleNames)],
            'representante_id' => ['nullable', 'exists:usuarios,id'],
            'firma' => ['nullable', 'image', 'mimes:jpeg,png,jpg,gif', 'max:2048'], // Validación de firma
        ], [
            'cedula.regex' => 'El formato de la cédula debe ser: V-12345678 o V-12345678-H1 (para hijos). Letras permitidas: V, E, J, G, P',
            'cedula.unique' => 'Esta cédula ya está registrada en el sistema',
            'telefono.regex' => 'El formato del teléfono debe ser: 0414-1234567 (Movistar: 0414/0424, Digitel: 0412/0422, Movilnet: 0416/0426)',
            'fecha_nacimiento.required' => 'La fecha de nacimiento es obligatoria',
            'fecha_nacimiento.date' => 'La fecha de nacimiento debe ser una fecha válida',
            'fecha_nacimiento.before' => 'La fecha de nacimiento debe ser anterior a hoy',
            'sexo.required' => 'El sexo es obligatorio',
            'sexo.in' => 'El sexo seleccionado no es válido',
            'firma.image' => 'El archivo debe ser una imagen',
            'firma.mimes' => 'La firma debe ser un archivo de tipo: jpeg, png, jpg, gif',
            'firma.max' => 'La firma no debe ser mayor a 2MB',
        ]);

        $esEspecialista = collect($validated['roles'])->contains('especialista');

        if ($esEspecialista) {
            $request->validate([
                'especialidades' => ['required', 'array', 'min:1'],
                'especialidades.*' => ['exists:especialidades,id'],
            ]);
        }

        $user->name = strtoupper($validated['name']);
        $user->cedula = $cedula;
        $user->email = strtoupper($validated['email']);
        $user->telefono = $validated['telefono'] ?? null;
        $user->fecha_nacimiento = $validated['fecha_nacimiento'];
        $user->sexo = $validated['sexo'];
        $user->especialidad_id = $esEspecialista ? ($validated['especialidad_id'] ?? null) : null;

        if (!empty($validated['password'])) {
            $user->password = Hash::make($validated['password']);
        }

        // Manejar la carga de la firma
        if ($request->hasFile('firma') && $request->file('firma')->isValid()) {
            // Eliminar la firma anterior si existe
            if ($user->firma && \Storage::disk('public')->exists($user->firma)) {
                \Storage::disk('public')->delete($user->firma);
            }

            // Guardar la nueva firma con nombre único
            $file = $request->file('firma');
            $filename = 'firma_' . $user->id . '_' . time() . '.' . $file->getClientOriginalExtension();
            $path = 'firmas/' . $filename;
            
            // Usar put con el contenido del archivo usando getPathname() para mayor compatibilidad
            \Storage::disk('public')->put($path, file_get_contents($file->getPathname()));
            $user->firma = $path;
        }

        $user->save();

        $user->syncRoles($validated['roles']);

        // Sincronizar especialidades múltiples (solo si es especialista)
        if ($esEspecialista && $request->has('especialidades')) {
            $user->especialidades()->sync($request->input('especialidades', []));
        } else {
            $user->especialidades()->detach();
        }
        return redirect()
            ->route('admin.users.index')
            ->with('status', 'Usuario actualizado correctamente.');
    }

    /**
     * Delete the user's signature.
     */
    public function deleteFirma(User $user): RedirectResponse
    {
        // Eliminar el archivo de firma si existe
        if ($user->firma && \Storage::disk('public')->exists($user->firma)) {
            \Storage::disk('public')->delete($user->firma);
        }

        // Limpiar el campo en la base de datos
        $user->firma = null;
        $user->save();

        return redirect()
            ->route('admin.users.edit', $user)
            ->with('status', 'Firma eliminada correctamente.');
    }

    public function sendPasswordResetLink(User $user): \Illuminate\Http\JsonResponse
    {
        // Enviar el enlace de restablecimiento de contraseña
        $status = \Illuminate\Support\Facades\Password::broker()->sendResetLink(
            ['email' => $user->email]
        );

        if ($status == \Illuminate\Support\Facades\Password::RESET_LINK_SENT) {
            return response()->json([
                'success' => true,
                'message' => __($status)
            ]);
        }

        return response()->json([
            'success' => false,
            'message' => __($status)
        ], 400);
    }

    public function getNextDependentNumber(User $representante): \Illuminate\Http\JsonResponse
    {
        // Obtener todos los dependientes del representante
        $dependientes = User::where('representante_id', $representante->id)
            ->where('cedula', 'LIKE', $representante->cedula . '-H%')
            ->get();

        // Extraer los números de los sufijos existentes
        $numeros = $dependientes->map(function ($dep) {
            if (preg_match('/-H(\d+)$/', $dep->cedula, $matches)) {
                return (int) $matches[1];
            }
            return 0;
        })->filter()->toArray();

        // Calcular el siguiente número disponible
        $siguienteNumero = empty($numeros) ? 1 : max($numeros) + 1;

        return response()->json([
            'next_number' => $siguienteNumero,
            'representante_cedula' => $representante->cedula
        ]);
    }

    public function searchRepresentantes(Request $request): \Illuminate\Http\JsonResponse
    {
        $term = trim($request->query('q', ''));

        if (strlen($term) < 1) {
            return response()->json(['results' => []]);
        }

        $users = User::where(function ($q) use ($term) {
            $q->where('name', 'like', "%{$term}%")
                ->orWhere('cedula', 'like', "%{$term}%");
        })
            ->orderBy('name')
            ->limit(20)
            ->get(['id', 'name', 'cedula', 'email']);

        // Formatear para Select2
        $results = $users->map(function ($user) {
            return [
                'id' => $user->id,
                'text' => $user->name . ' (' . $user->cedula . ')',
                'cedula' => $user->cedula,
                'email' => $user->email
            ];
        });

        return response()->json(['results' => $results]);
    }

    /**
     * Enviar mensaje de prueba por WhatsApp
     * 
     * @param User $user
     * @return \Illuminate\Http\JsonResponse
     */
    public function sendWhatsAppTest(User $user): \Illuminate\Http\JsonResponse
    {
        // Verificar que el usuario tenga teléfono
        if (empty($user->telefono)) {
            return response()->json([
                'success' => false,
                'message' => 'El usuario no tiene un número de teléfono registrado'
            ], 400);
        }

        $whatsappService = new WhatsAppService();

        // Convertir el teléfono a formato internacional si es necesario
        $phoneNumber = $this->formatPhoneNumber($user->telefono);
        
        if (!$phoneNumber) {
            return response()->json([
                'success' => false,
                'message' => 'El formato del teléfono no es válido. Debe ser: 0414-1234567 o +584141234567'
            ], 400);
        }
        
        $message = "¡Hola {$user->name}! 👋\n\n";
        $message .= "Este es un mensaje de prueba desde SomosSalud.\n\n";
        $message .= "Tu información:\n";
        $message .= "📧 Email: {$user->email}\n";
        $message .= "📱 Teléfono: {$user->telefono}\n";
        $message .= "📅 Fecha: " . now()->format('d/m/Y H:i');

        $result = $whatsappService->sendMessage($phoneNumber, $message);

        if ($result['success']) {
            return response()->json([
                'success' => true,
                'message' => "Mensaje enviado a {$user->name} ({$phoneNumber})",
                'data' => $result['data']
            ]);
        } else {
            return response()->json([
                'success' => false,
                'message' => 'Error al enviar mensaje: ' . ($result['error'] ?? 'Error desconocido')
            ], 500);
        }
    }

    /**
     * Formatear número de teléfono venezolano a formato internacional
     * Convierte: 0414-1234567 → +584141234567
     * Operadoras: Movistar (0414, 0424), Digitel (0412, 0422), Movilnet (0416, 0426)
     * 
     * @param string $phone
     * @return string|null
     */
    private function formatPhoneNumber($phone)
    {
        // Limpiar el número (quitar espacios, guiones, paréntesis)
        $phone = preg_replace('/[^0-9+]/', '', $phone);
        
        // Si ya tiene el formato internacional correcto
        // +58 + (0414|0424|0412|0422|0416|0426) + 7 dígitos
        if (preg_match('/^\+58(41[24]|42[246])\d{7}$/', $phone)) {
            return $phone;
        }
        
        // Si es formato local venezolano: 04XX-XXXXXXX
        if (preg_match('/^0(41[24]|42[246])(\d{7})$/', $phone, $matches)) {
            return '+58' . $matches[1] . $matches[2];
        }
        
        // Si ya tiene 58 pero sin el +
        if (preg_match('/^58(41[24]|42[246])\d{7}$/', $phone)) {
            return '+' . $phone;
        }
        
        return null;
    }
}
