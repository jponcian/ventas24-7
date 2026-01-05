<?php

namespace App\Http\Controllers;

use App\Models\Material;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class MaterialController extends Controller
{
    public function index(Request $request)
    {
        $query = Material::query();

        if ($request->filled('search')) {
            $query->buscar($request->search);
        }

        if ($request->filled('categoria')) {
            $query->porCategoria($request->categoria);
        }

        if ($request->filled('stock_status')) {
            if ($request->stock_status === 'bajo') {
                $query->whereRaw('stock_actual <= stock_minimo');
            } elseif ($request->stock_status === 'normal') {
                $query->whereRaw('stock_actual > stock_minimo');
            }
        }

        $materiales = $query->orderBy('nombre')->paginate(15);
        
        if ($request->ajax()) {
            return view('inventario.materiales.table_rows', compact('materiales'))->render();
        }

        $categorias = ['ENFERMERIA', 'QUIROFANO', 'UCI', 'OFICINA', 'LABORATORIO']; // Should probably be dynamic or constant

        return view('inventario.materiales.index', compact('materiales', 'categorias'));
    }

    public function create()
    {
        $categorias = ['ENFERMERIA', 'QUIROFANO', 'UCI', 'OFICINA', 'LABORATORIO'];
        $unidades = ['Unidad', 'Caja', 'Paquete', 'Litro', 'Kilogramo', 'Metro', 'Rollo', 'Frasco', 'Ampolla'];
        
        return view('inventario.materiales.create', compact('categorias', 'unidades'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'codigo' => ['required', 'string', 'max:50', Rule::unique('materiales')],
            'nombre' => 'required|string|max:255',
            'descripcion' => 'nullable|string',
            'categoria_default' => 'required|string',
            'unidad_medida_default' => 'required|string',
            'stock_inicial' => 'nullable|integer|min:0',
            'stock_minimo' => 'required|integer|min:0',
        ]);

        $validated['clinica_id'] = auth()->user()->clinica_id; // Assuming user has clinica_id
        $validated['activo'] = true;
        
        // Establecer el stock_actual con el stock_inicial (si se proporcionó)
        $validated['stock_actual'] = $validated['stock_inicial'] ?? 0;
        
        // Remover stock_inicial ya que no existe en la tabla
        unset($validated['stock_inicial']);

        Material::create($validated);

        return redirect()->route('inventario.materiales.index')
            ->with('success', 'Material creado exitosamente.');
    }

    public function edit(Material $material)
    {
        $categorias = ['ENFERMERIA', 'QUIROFANO', 'UCI', 'OFICINA', 'LABORATORIO'];
        $unidades = ['Unidad', 'Caja', 'Paquete', 'Litro', 'Kilogramo', 'Metro', 'Rollo', 'Frasco', 'Ampolla'];

        return view('inventario.materiales.edit', compact('material', 'categorias', 'unidades'));
    }

    public function update(Request $request, Material $material)
    {
        $validated = $request->validate([
            'codigo' => ['required', 'string', 'max:50', Rule::unique('materiales')->ignore($material->id)],
            'nombre' => 'required|string|max:255',
            'descripcion' => 'nullable|string',
            'categoria_default' => 'required|string',
            'unidad_medida_default' => 'required|string',
            'stock_minimo' => 'required|integer|min:0',
            'activo' => 'boolean',
        ]);

        $material->update($validated);

        return redirect()->route('inventario.materiales.index')
            ->with('success', 'Material actualizado exitosamente.');
    }

    public function destroy(Material $material)
    {
        $material->delete();
        return redirect()->route('inventario.materiales.index')
            ->with('success', 'Material eliminado exitosamente.');
    }
}
