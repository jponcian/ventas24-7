<?php

namespace App\Http\Controllers;

use App\Models\LabExam;
use App\Models\LabCategory;
use App\Models\LabExamItem;
use App\Models\LabReferenceRange;
use App\Models\LabReferenceGroup;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class LabManagementController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = LabExam::with('category', 'items');

        if ($request->has('search')) {
            $search = $request->get('search');
            $query->where(function($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('code', 'like', "%{$search}%")
                  ->orWhere('abbreviation', 'like', "%{$search}%");
            });
        }

        if ($request->has('category_id') && $request->category_id != '') {
            $query->where('lab_category_id', $request->category_id);
        }

        $exams = $query->orderBy('name')->paginate(20);
        $categories = LabCategory::orderBy('name')->get();

        return view('lab.management.index', compact('exams', 'categories'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        $categories = LabCategory::orderBy('name')->get();
        return view('lab.management.create', compact('categories'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'code' => 'required|string|max:50|unique:lab_exams,code',
            'lab_category_id' => 'required|exists:lab_categories,id',
            'price' => 'required|numeric|min:0',
            'abbreviation' => 'nullable|string|max:20',
        ]);

        $exam = LabExam::create([
            'name' => $request->name,
            'code' => $request->code,
            'lab_category_id' => $request->lab_category_id,
            'price' => $request->price,
            'abbreviation' => $request->abbreviation,
            'active' => true,
        ]);

        return redirect()->route('lab.management.edit', $exam->id)
            ->with('success', 'Examen creado exitosamente. Ahora puede agregar los parámetros.');
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id)
    {
        $exam = LabExam::with(['items.referenceRanges', 'category'])->findOrFail($id);
        $categories = LabCategory::orderBy('name')->get();
        return view('lab.management.edit', compact('exam', 'categories'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $exam = LabExam::findOrFail($id);

        $request->validate([
            'name' => 'required|string|max:255',
            'code' => 'required|string|max:50|unique:lab_exams,code,'.$id,
            'lab_category_id' => 'required|exists:lab_categories,id',
            'price' => 'required|numeric|min:0',
            'abbreviation' => 'nullable|string|max:20',
        ]);

        $exam->update([
            'name' => $request->name,
            'code' => $request->code,
            'lab_category_id' => $request->lab_category_id,
            'price' => $request->price,
            'abbreviation' => $request->abbreviation,
            'active' => $request->has('active') // Checkbox for active status
        ]);

        return redirect()->back()->with('success', 'Examen actualizado correctamente.');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $exam = LabExam::findOrFail($id);
        
        // Verificar si tiene historial (órdenes)
        if (\App\Models\LabOrderDetail::where('lab_exam_id', $id)->count() > 0) {
            return back()->with('error', 'No se puede eliminar el examen porque existen órdenes asociadas. Puede desactivarlo en su lugar.');
        }

        $exam->delete();
        return redirect()->route('lab.management.index')->with('success', 'Examen eliminado correctamente.');
    }

    // --- ITEM MANAGEMENT ---

    public function storeItem(Request $request, $examId)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'unit' => 'nullable|string|max:50',
            'type' => 'required|in:text,numeric',
            'order' => 'required|integer',
        ]);

        LabExamItem::create([
            'lab_exam_id' => $examId,
            'name' => $request->name,
            'unit' => $request->unit,
            'type' => $request->type,
            'order' => $request->order,
        ]);

        return back()->with('success', 'Parámetro agregado correctamente.');
    }

    public function updateItem(Request $request, $itemId)
    {
        $item = LabExamItem::findOrFail($itemId);

        $request->validate([
            'name' => 'required|string|max:255',
            'unit' => 'nullable|string|max:50',
            'type' => 'required|in:text,numeric',
            'order' => 'required|integer',
        ]);

        $item->update($request->only('name', 'unit', 'type', 'order'));

        return back()->with('success', 'Parámetro actualizado correctamente.');
    }

    public function destroyItem($itemId)
    {
        $item = LabExamItem::findOrFail($itemId);
        // Check dependencies if needed
        $item->delete();
        return back()->with('success', 'Parámetro eliminado correctamente.');
    }

    // --- REFERENCE MANAGEMENT (Simple View for now, modal or separate page) ---

    public function showReferences($itemId)
    {
        $item = LabExamItem::with('referenceRanges.group', 'exam')->findOrFail($itemId);
        
        // Obtener todos los grupos activos ordenados por ID (orden de creación suele ser lógico) 
        // o explicitamente por description
        $allGroups = LabReferenceGroup::where('active', true)->orderBy('id')->get();
        
        $groupedOptions = [
            'Automático - General' => [],
            'Automático - Hombres' => [],
            'Automático - Mujeres' => [],
            'Configuración Manual - Hombres' => [],
            'Configuración Manual - Mujeres' => [],
            'Configuración Manual - Niños' => [],
            'Configuración Manual - Universal' => [],
            'Otros' => []
        ];

        foreach ($allGroups as $group) {
            $desc = $group->description;
            
            // Grupos Manuales ("CATEGORIA - Manual")
            if (str_contains($desc, ' - Manual')) {
                 if (str_starts_with($desc, 'HOMBRES')) {
                    $groupedOptions['Configuración Manual - Hombres'][] = $group;
                 } elseif (str_starts_with($desc, 'MUJERES')) {
                    $groupedOptions['Configuración Manual - Mujeres'][] = $group;
                 } elseif (str_starts_with($desc, 'NIÑOS')) {
                    $groupedOptions['Configuración Manual - Niños'][] = $group;
                 } else {
                    $groupedOptions['Configuración Manual - Universal'][] = $group;
                 }
            }
            // Grupos Automáticos Estandarizados (TITULO - Sexo)
            elseif (str_contains($desc, ' - Masculino')) {
                $groupedOptions['Automático - Hombres'][] = $group;
            } 
            elseif (str_contains($desc, ' - Femenino')) {
                $groupedOptions['Automático - Mujeres'][] = $group;
            } 
            elseif (str_contains($desc, ' - Todos')) {
                $groupedOptions['Automático - General'][] = $group;
            } 
            // Fallback para cualquier otro
            else {
                $groupedOptions['Otros'][] = $group;
            }
        }
        
        // Limpiar categorías vacías
        $groupedOptions = array_filter($groupedOptions);

        return view('lab.management.references', compact('item', 'groupedOptions')); // Pasamos groupedOptions en vez de groups
    }

    public function storeReference(Request $request, $itemId)
    {
        $request->validate([
            'lab_reference_group_id' => 'required|exists:lab_reference_groups,id',
        ]);

        LabReferenceRange::create([
            'lab_exam_item_id' => $itemId,
            'lab_reference_group_id' => $request->lab_reference_group_id,
            'value_min' => $request->value_min,
            'value_max' => $request->value_max,
            'value_text' => $request->value_text,
            'condition' => $request->condition,
        ]);

        return back()->with('success', 'Rango de referencia agregado correctamente.');
    }
    
    public function updateReference(Request $request, $referenceId)
    {
         $reference = LabReferenceRange::findOrFail($referenceId);
         // Validation
         $reference->update($request->except('_token', '_method'));
         return back()->with('success', 'Referencia actualizada.');
    }

    public function destroyReference($referenceId)
    {
        LabReferenceRange::destroy($referenceId);
        return back()->with('success', 'Referencia eliminada.');
    }
    
    public function searchGroups(Request $request) {
        $q = $request->get('q');
        $groups = LabReferenceGroup::where('description', 'like', "%$q%")->limit(20)->get();
        return response()->json($groups);
    }
}
