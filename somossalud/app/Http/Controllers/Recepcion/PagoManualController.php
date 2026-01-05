<?php

namespace App\Http\Controllers\Recepcion;

use App\Http\Controllers\Controller;
use App\Models\ReportePago;
use App\Models\Suscripcion;
use Illuminate\Support\Facades\DB;
use App\Models\User;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\View\View;

class PagoManualController extends Controller
{
    public function index(Request $request): View
    {
        $estado = $request->query('estado', 'pendiente');
        $reportes = ReportePago::with(['usuario','revisor'])
            ->when($estado, fn($q) => $q->where('estado', $estado))
            ->orderByDesc('created_at')
            ->paginate(15);

        return view('recepcion.pagos.index', [
            'reportes' => $reportes,
            'estado' => $estado,
        ]);
    }

    public function aprobar(Request $request, ReportePago $reporte): RedirectResponse
    {
        if ($reporte->estado !== 'pendiente') {
            return back()->with('error', 'Este reporte ya fue gestionado.');
        }

        $reporte->estado = 'aprobado';
        $reporte->reviewed_by = Auth::id();
        $reporte->reviewed_at = now();
        $reporte->observaciones = $request->input('observaciones');
        $reporte->save();

        // Activar/renovar suscripción del usuario
        $inicio = now()->toDateString();
        $vencimiento = now()->addYear()->toDateString();

        $suscripcionFinal = null;
        DB::transaction(function () use ($reporte, $inicio, $vencimiento, &$suscripcionFinal) {
            // Bloqueo optimista: obtenemos o creamos la suscripción del usuario
            $suscripcion = Suscripcion::where('usuario_id', $reporte->usuario_id)->lockForUpdate()->first();

            if (!$suscripcion) {
                $suscripcion = new Suscripcion();
                $suscripcion->usuario_id = $reporte->usuario_id;
            }

            // Asignar número correlativo solo si no existe
            if (empty($suscripcion->numero)) {
                // Intento con pequeño reintento ante condición de carrera por restricción unique
                for ($i = 0; $i < 3; $i++) {
                    $next = ((int) (Suscripcion::max('numero') ?? 0)) + 1;
                    $suscripcion->numero = $next;
                    $suscripcion->plan = 'anual';
                    $suscripcion->precio = 10.00;
                    $suscripcion->periodo_inicio = $inicio;
                    $suscripcion->periodo_vencimiento = $vencimiento;
                    $suscripcion->estado = 'activo';
                    $suscripcion->metodo_pago = 'pago_movil';
                    $suscripcion->transaccion_id = 'PM-' . $reporte->referencia . '-' . \Illuminate\Support\Carbon::parse($reporte->fecha_pago)->format('Ymd');
                    try {
                        $suscripcion->save();
                        break; // éxito
                    } catch (\Illuminate\Database\QueryException $e) {
                        // Si es duplicado de unique(numero), reintenta
                        if (str_contains(strtolower($e->getMessage()), 'duplicate') || str_contains(strtolower($e->getMessage()), 'unique')) {
                            // reintentar con otro número
                            continue;
                        }
                        throw $e;
                    }
                }
            } else {
                // Ya tenía número, solo actualizamos campos de ciclo
                $suscripcion->plan = 'anual';
                $suscripcion->precio = 10.00;
                $suscripcion->periodo_inicio = $inicio;
                $suscripcion->periodo_vencimiento = $vencimiento;
                $suscripcion->estado = 'activo';
                $suscripcion->metodo_pago = 'pago_movil';
                $suscripcion->transaccion_id = 'PM-' . $reporte->referencia . '-' . \Illuminate\Support\Carbon::parse($reporte->fecha_pago)->format('Ymd');
                $suscripcion->save();
            }

            $suscripcionFinal = $suscripcion;
        });

        // Enviar correo de confirmación al paciente (si tenemos la suscripción final)
        if ($suscripcionFinal) {
            try {
                $usuario = $reporte->usuario; // si no viene, lo buscamos
                if (!$usuario) {
                    $usuario = User::find($reporte->usuario_id);
                }
                if ($usuario && $usuario->email) {
                    Mail::to($usuario->email)->queue(new \App\Mail\SuscripcionAprobada($usuario, $suscripcionFinal));
                }
            } catch (\Throwable $e) {
                Log::error('Fallo al enviar correo de suscripción aprobada: '.$e->getMessage());
            }
        }

        return back()->with('success', 'Pago aprobado y suscripción activada.');
    }

    public function rechazar(Request $request, ReportePago $reporte): RedirectResponse
    {
        if ($reporte->estado !== 'pendiente') {
            return back()->with('error', 'Este reporte ya fue gestionado.');
        }

        $request->validate([
            'observaciones' => ['nullable', 'string', 'max:500'],
        ]);

        $reporte->estado = 'rechazado';
        $reporte->reviewed_by = Auth::id();
        $reporte->reviewed_at = now();
        $reporte->observaciones = $request->input('observaciones');
        $reporte->save();

        return back()->with('success', 'Pago rechazado. Se guardaron las observaciones.');
    }
}
