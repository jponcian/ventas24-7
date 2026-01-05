<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class HelpController extends Controller
{
    public function index()
    {
        return view('help.index');
    }

    public function show($section)
    {
        // Validar que la sección existe
        $validSections = [
            'gestion-laboratorio',
            'ordenes-laboratorio',
            'cargar-resultados',
            'gestion-atenciones',
            'validar-pagos',
            'gestion-solicitudes',
            'gestion-materiales',
            'registro-ingresos',
            'gestion-usuarios',
            'perfil-usuario',
        ];

        if (!in_array($section, $validSections)) {
            abort(404);
        }

        return view('help.sections.' . $section);
    }
}
