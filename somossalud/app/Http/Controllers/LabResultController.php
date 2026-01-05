<?php

namespace App\Http\Controllers;

use App\Models\LabOrder;
use App\Models\LabResult;
use App\Models\LabReferenceRange;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class LabResultController extends Controller
{
    // Mostrar formulario para ingresar resultados de una orden
    public function edit($orderId)
    {
        $order = LabOrder::with('details.exam.items')->findOrFail($orderId);
        return view('lab.edit_results', compact('order'));
    }

    // Guardar resultados y cerrar la orden
    public function update(Request $request, $orderId)
    {
        DB::transaction(function () use ($request, $orderId) {
            $order = LabOrder::findOrFail($orderId);
            foreach ($request->input('results', []) as $detailId => $items) {
                foreach ($items as $itemId => $value) {
                    LabResult::updateOrCreate(
                        [
                            'lab_order_detail_id' => $detailId,
                            'lab_exam_item_id'    => $itemId,
                        ],
                        [
                            'value'       => $value['value'] ?? null,
                            'observation' => $value['observation'] ?? null,
                        ]
                    );
                }
            }
            $order->update([
                'status' => 'completed',
                'result_date' => now(), // Guarda fecha y hora del resultado
                'results_loaded_by' => $request->user()->id, // Opcional: registrar quién cargó los resultados
            ]);
        });

        return redirect()->route('lab.orders.show', $orderId)
                         ->with('success', 'Resultados guardados y orden completada');
    }
}
?>
