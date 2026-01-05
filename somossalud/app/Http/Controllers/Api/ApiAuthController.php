<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;

class ApiAuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'cedula' => ['required', 'string', 'regex:/^[VEJGP]-?\d{6,8}$/i'],
            'password' => 'required',
        ]);

        // Normalizar la cédula
        $cedula = strtoupper(trim($request->cedula));
        if (preg_match('/^([VEJGP])(\d{6,8})$/i', $cedula, $matches)) {
            $cedula = $matches[1] . '-' . $matches[2];
        }

        if (Auth::attempt(['cedula' => $cedula, 'password' => $request->password])) {
            $user = Auth::user();
            
            // Verificar que sea un paciente
            if (!$user->hasRole('paciente')) {
                Auth::logout();
                return response()->json([
                    'success' => false, 
                    'message' => 'Esta aplicación es solo para pacientes'
                ], 403);
            }
            
            // Generar token
            $token = $user->createToken('movil-app')->plainTextToken;

            return response()->json([
                'success' => true,
                'token' => $token,
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'cedula' => $user->cedula,
                    'email' => $user->email,
                    'clinica_id' => $user->clinica_id,
                    'sexo' => $user->sexo,
                    'fecha_nacimiento' => $user->fecha_nacimiento,
                ]
            ]);
        }

        return response()->json(['success' => false, 'message' => 'Cédula o contraseña incorrecta'], 401);
    }
    
    public function logout(Request $request) {
        $request->user()->currentAccessToken()->delete();
        return response()->json(['success' => true, 'message' => 'Sesión cerrada']);
    }
}
