<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Suscripcion;
use App\Models\ReportePago;

class SuscripcionController extends Controller
{
    public function show()
    {
        $user = Auth::user();
        $suscripcion = Suscripcion::where('usuario_id', $user->id)->latest()->first();
        $ultimoReporte = ReportePago::where('usuario_id', $user->id)->latest()->first();
        // Configuración de Pago Móvil
        $pagoMovil = [
            'banco' => \App\Models\Setting::getValue('pago_movil_banco', 'Banesco'),
            'identificacion' => \App\Models\Setting::getValue('pago_movil_identificacion', 'J-12345678-9'),
            'telefono' => \App\Models\Setting::getValue('pago_movil_telefono', '0414-0000000'),
            'nombre' => \App\Models\Setting::getValue('pago_movil_nombre', 'SomosSalud C.A.'),
        ];

        return view('suscripcion.show', [
            'user' => $user,
            'suscripcion' => $suscripcion,
            'ultimoReporte' => $ultimoReporte,
            'pagoMovil' => $pagoMovil,
        ]);
    }

    // Método de sandbox eliminado para producción.

    public function reportarPago(Request $request)
    {
        $user = Auth::user();
        // Validación de entrada básica
        $data = $request->validate([
            'cedula_pagador' => ['required', 'string', 'max:50'],
            'telefono_pagador' => ['required', 'string', 'max:30', 'regex:/^0\d{3}-?\d{7}$/'],
            'fecha_pago' => ['required', 'date', 'before_or_equal:today'],
            'referencia' => ['required', 'string', 'max:100'],
            'monto' => ['required', 'numeric', 'min:0.01'],
        ], [
            'telefono_pagador.regex' => 'Teléfono inválido. Use 0414-1234567 (guion opcional).',
        ]);

        // Normalizar mayúsculas en campos alfanuméricos
        $referencia = strtoupper(trim($data['referencia']));
        $cedula = strtoupper(trim($data['cedula_pagador']));

        // Regla: un usuario no puede tener más de 1 reporte pendiente sin revisar
        $yaPendiente = ReportePago::where('usuario_id', $user->id)->where('estado', 'pendiente')->first();
        if ($yaPendiente) {
            return redirect()->route('suscripcion.show')
                ->with('error', 'Ya tienes un pago pendiente de validación. Espera la revisión antes de registrar otro.');
        }

        // Regla: referencia no debe existir (independiente del monto/fecha) en ningún reporte anterior
        $existeReferencia = ReportePago::whereRaw('UPPER(referencia) = ?', [$referencia])->first();
        if ($existeReferencia) {
            return redirect()->route('suscripcion.show')
                ->with('error', 'La referencia ya fue reportada previamente. Verifica que no estés duplicando el pago.');
        }

        // Crear registro
        // Normalizar teléfono
        $telDigits = str_replace('-', '', $data['telefono_pagador']);
        $telefono = substr($telDigits,0,4) . '-' . substr($telDigits,4);

        ReportePago::create([
            'usuario_id' => $user->id,
            'cedula_pagador' => $cedula,
            'telefono_pagador' => $telefono,
            'fecha_pago' => $data['fecha_pago'],
            'referencia' => $referencia,
            'monto' => $data['monto'],
            'estado' => 'pendiente',
        ]);

        return redirect()->route('suscripcion.show')
            ->with('success', 'Pago reportado correctamente. Un recepcionista validará la información y activará tu suscripción.');
    }

    public function carnet()
    {
        $user = Auth::user();
        $suscripcion = Suscripcion::where('usuario_id', $user->id)->where('estado', 'activo')->latest()->first();

        if (!$suscripcion) {
            return redirect()->route('suscripcion.show')->with('error', 'Activa tu suscripción para ver tu carnet.');
        }

        return view('suscripcion.carnet', [
            'user' => $user,
            'suscripcion' => $suscripcion,
        ]);
    }
}
