<?php

namespace App\Http\Controllers;

use App\Models\Material;
use App\Models\MovimientoInventario;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class IngresoInventarioController extends Controller
{
    public function index()
    {
        $movimientos = MovimientoInventario::with(['material', 'user'])
            ->where('tipo', 'INGRESO')
            ->orderBy('created_at', 'desc')
            ->paginate(15);

        return view('inventario.ingresos.index', compact('movimientos'));
    }

    public function create()
    {
        $materiales = Material::activos()->orderBy('nombre')->get();
        return view('inventario.ingresos.create', compact('materiales'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'motivo' => 'nullable|string|max:255',
            'referencia' => 'nullable|string|max:255',
            'items' => 'required|array|min:1',
            'items.*.material_id' => 'required|exists:materiales,id',
            'items.*.cantidad' => 'required|integer|min:1',
        ]);

        DB::beginTransaction();
        try {
            $movimientos = [];
            
            foreach ($validated['items'] as $itemData) {
                $material = Material::findOrFail($itemData['material_id']);
                
                $stockAnterior = $material->stock_actual;
                $cantidad = $itemData['cantidad'];
                $stockNuevo = $stockAnterior + $cantidad;

                // Registrar movimiento
                $movimiento = MovimientoInventario::create([
                    'material_id' => $material->id,
                    'user_id' => auth()->id(),
                    'tipo' => 'INGRESO',
                    'cantidad' => $cantidad,
                    'stock_anterior' => $stockAnterior,
                    'stock_nuevo' => $stockNuevo,
                    'motivo' => $validated['motivo'] ?? 'INGRESO MANUAL',
                    'referencia' => $validated['referencia'],
                ]);

                // Actualizar stock material
                $material->stock_actual = $stockNuevo;
                $material->save();
                
                $movimientos[] = $movimiento;
            }

            DB::commit();

            $totalItems = count($movimientos);
            return redirect()->route('inventario.ingresos.index')
                ->with('success', "Ingreso registrado exitosamente. {$totalItems} material(es) actualizado(s).");

        } catch (\Exception $e) {
            DB::rollBack();
            return back()->withInput()->with('error', 'Error al registrar ingreso: ' . $e->getMessage());
        }
    }
}
