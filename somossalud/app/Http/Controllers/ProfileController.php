<?php

namespace App\Http\Controllers;

use App\Http\Requests\ProfileUpdateRequest;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Redirect;
use Illuminate\View\View;

class ProfileController extends Controller
{
    /**
     * Display the user's profile form.
     */
    public function edit(Request $request): View
    {
        $context = $request->input('context');
        $user = $request->user();

        // Si el contexto es explícitamente 'clinica', mostrar layout de clínica
        if ($context === 'clinica') {
            return view('profile.edit_clinic', ['user' => $user]);
        }

        // Si el contexto es explícitamente 'paciente', mostrar layout de paciente
        if ($context === 'paciente') {
            return view('profile.edit', ['user' => $user]);
        }

        // Fallback: si tiene roles de clínica, mostrar layout de clínica por defecto
        if ($user->hasAnyRole(['super-admin', 'admin_clinica', 'recepcionista', 'especialista', 'laboratorio', 'laboratorio-resul', 'almacen', 'almacen-jefe'])) {
            return view('profile.edit_clinic', ['user' => $user]);
        }

        return view('profile.edit', [
            'user' => $user,
        ]);
    }

    /**
     * Update the user's profile information.
     */
    public function update(ProfileUpdateRequest $request): RedirectResponse
    {
        $user = $request->user();
        
        // Actualizar datos básicos primero
        $user->fill($request->safe()->except(['firma']));

        // Manejar la carga de la firma
        if ($request->hasFile('firma') && $request->file('firma')->isValid()) {
            // Validar el archivo de firma
            $request->validate([
                'firma' => 'image|mimes:jpeg,png,jpg,gif|max:2048',
            ]);

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



        if ($user->isDirty('email')) {
            $user->email_verified_at = null;
        }

        $user->save();

        $context = $request->query('context');
        return Redirect::route('profile.edit', ['context' => $context])->with('status', 'profile-updated');
    }

    /**
     * Delete the user's account.
     */
    public function destroy(Request $request): RedirectResponse
    {
        $request->validateWithBag('userDeletion', [
            'password' => ['required', 'current_password'],
        ]);

        $user = $request->user();

        Auth::logout();

        $user->delete();

        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return Redirect::to('/');
    }

    /**
     * Delete the user's signature.
     */
    public function deleteFirma(Request $request): RedirectResponse
    {
        $user = $request->user();

        // Eliminar el archivo de firma si existe
        if ($user->firma && \Storage::disk('public')->exists($user->firma)) {
            \Storage::disk('public')->delete($user->firma);
        }

        // Limpiar el campo en la base de datos
        $user->firma = null;
        $user->save();

        $context = $request->query('context');
        return Redirect::route('profile.edit', ['context' => $context])->with('status', 'firma-deleted');
    }
}
