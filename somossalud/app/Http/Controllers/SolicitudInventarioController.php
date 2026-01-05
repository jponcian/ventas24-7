<?php

namespace App\Http\Controllers;

use App\Models\SolicitudInventario;
use App\Models\ItemSolicitudInventario;
use App\Models\Material;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

class SolicitudInventarioController extends Controller
{
    /**
     * Mostrar lista de solicitudes
     */
    public function index(Request $request)
    {
        $query = SolicitudInventario::with(['solicitante', 'clinica', 'items'])
            ->where('clinica_id', auth()->user()->clinica_id)
            ->orderBy('created_at', 'desc');
        
        // Filtros
        if ($request->filled('estado')) {
            $query->where('estado', $request->estado);
        }
        
        if ($request->filled('categoria')) {
            $query->where('categoria', $request->categoria);
        }
        
        if ($request->filled('fecha_desde')) {
            $query->whereDate('created_at', '>=', $request->fecha_desde);
        }
        
        if ($request->filled('fecha_hasta')) {
            $query->whereDate('created_at', '<=', $request->fecha_hasta);
        }
        
        // Si es usuario de almacén regular (no jefe), solo ver sus propias solicitudes
        // El jefe de almacén puede ver todas las solicitudes
        if (auth()->user()->hasRole('almacen') && !auth()->user()->hasRole('almacen-jefe')) {
            $query->where('solicitante_id', auth()->id());
        }
        
        $solicitudes = $query->paginate(15);
        
        // Estadísticas
        $statsQuery = SolicitudInventario::where('clinica_id', auth()->user()->clinica_id);
        
        // Aplicar el mismo filtro de rol que en la consulta principal
        if (auth()->user()->hasRole('almacen') && !auth()->user()->hasRole('almacen-jefe')) {
            $statsQuery->where('solicitante_id', auth()->id());
        }
        
        $stats = [
            'pendientes' => (clone $statsQuery)->pendientes()->count(),
            'aprobadas' => (clone $statsQuery)->aprobadas()->count(),
            'despachadas_mes' => (clone $statsQuery)->despachadas()
                ->whereYear('fecha_despacho', now()->year)
                ->whereMonth('fecha_despacho', now()->month)
                ->count(),
        ];
        
        return view('inventario.solicitudes.index', compact('solicitudes', 'stats'));
    }
    
    /**
     * Mostrar formulario de creación
     */
    public function create()
    {
        $this->authorize('create', SolicitudInventario::class);
        
        $categorias = ['ENFERMERIA', 'QUIROFANO', 'UCI', 'OFICINA', 'LABORATORIO'];
        $unidadesMedida = ['Unidad', 'Caja', 'Paquete', 'Litro', 'Kilogramo', 'Metro', 'Rollo', 'Frasco', 'Ampolla'];
        
        return view('inventario.solicitudes.create', compact('categorias', 'unidadesMedida'));
    }
    
    /**
     * Búsqueda de materiales para autocompletado (AJAX)
     */
    public function buscarMateriales(Request $request)
    {
        $term = $request->input('q', '');
        $categoria = $request->input('categoria');
        
        // Verificar que el usuario tenga clinica_id
        $clinicaId = auth()->user()->clinica_id;
        if (!$clinicaId) {
            return response()->json([
                'error' => 'Usuario sin clínica asignada'
            ], 400);
        }
        
        $query = Material::where('clinica_id', $clinicaId)
            ->activos();
        
        // Solo aplicar búsqueda si hay un término
        if (!empty($term)) {
            $query->buscar($term);
        }
            
        // if ($categoria) {
        //     $query->where('categoria_default', $categoria);
        // }
        
        $materiales = $query->limit(500)->get();
        
        return response()->json($materiales->map(function($m) {
            return [
                'id' => $m->id,
                'text' => $m->nombre . ($m->unidad_medida_default ? " ({$m->unidad_medida_default})" : ''),
                'nombre' => $m->nombre,
                'unidad' => $m->unidad_medida_default,
                'descripcion' => $m->descripcion
            ];
        }));
    }
    
    /**
     * Guardar nueva solicitud
     */
    public function store(Request $request)
    {
        $this->authorize('create', SolicitudInventario::class);
        
        $validated = $request->validate([
            'categoria' => 'required|in:ENFERMERIA,QUIROFANO,UCI,OFICINA,LABORATORIO',
            'observaciones_solicitante' => 'nullable|string|max:1000',
            'items' => 'required|array|min:1',
            'items.*.nombre_item' => 'required|string|max:200',
            'items.*.material_id' => 'nullable|exists:materiales,id',
            'items.*.descripcion' => 'nullable|string|max:500',
            'items.*.unidad_medida' => 'nullable|string|max:50',
            'items.*.cantidad_solicitada' => 'required|integer|min:1',
        ]);
        
        DB::beginTransaction();
        try {
            // Crear solicitud
            $solicitud = SolicitudInventario::create([
                'solicitante_id' => auth()->id(),
                'clinica_id' => auth()->user()->clinica_id,
                'categoria' => $validated['categoria'],
                'observaciones_solicitante' => $validated['observaciones_solicitante'],
                'estado' => 'pendiente'
            ]);
            
            // Crear items
            foreach ($validated['items'] as $itemData) {
                // Si viene un ID de material, verificar que pertenezca a la clínica
                if (!empty($itemData['material_id'])) {
                    $material = Material::find($itemData['material_id']);
                    if ($material && $material->clinica_id != auth()->user()->clinica_id) {
                        $itemData['material_id'] = null; // Ignorar si no es de la misma clínica
                    }
                }
                
                $solicitud->items()->create([
                    'material_id' => $itemData['material_id'] ?? null,
                    'nombre_item' => $itemData['nombre_item'],
                    'descripcion' => $itemData['descripcion'] ?? null,
                    'unidad_medida' => $itemData['unidad_medida'] ?? 'Unidad',
                    'cantidad_solicitada' => $itemData['cantidad_solicitada'],
                ]);
            }
            
            DB::commit();
            
            return redirect()
                ->route('inventario.solicitudes.show', $solicitud)
                ->with('success', 'Solicitud creada exitosamente: ' . $solicitud->numero_solicitud);
                
        } catch (\Exception $e) {
            DB::rollBack();
            return back()
                ->withInput()
                ->with('error', 'Error al crear la solicitud: ' . $e->getMessage());
        }
    }
    
    /**
     * Mostrar detalle de solicitud
     */
    public function show(SolicitudInventario $solicitud)
    {
        $this->authorize('view', $solicitud);
        
        $solicitud->load(['solicitante', 'clinica', 'aprobadoPor', 'despachadoPor', 'items.material']);
        
        return view('inventario.solicitudes.show', compact('solicitud'));
    }
    
    /**
     * Mostrar formulario de aprobación
     */
    public function edit(SolicitudInventario $solicitud)
    {
        $this->authorize('approve', $solicitud);
        
        if (!$solicitud->isPendiente()) {
            return redirect()
                ->route('inventario.solicitudes.show', $solicitud)
                ->with('warning', 'Esta solicitud ya fue procesada.');
        }
        
        $solicitud->load(['solicitante', 'items.material']);
        
        return view('inventario.solicitudes.edit', compact('solicitud'));
    }
    
    /**
     * Aprobar o rechazar solicitud
     */
    public function aprobar(Request $request, SolicitudInventario $solicitud)
    {
        $this->authorize('approve', $solicitud);
        
        if (!$solicitud->isPendiente()) {
            return back()->with('error', 'Esta solicitud ya fue procesada.');
        }
        
        $validated = $request->validate([
            'accion' => 'required|in:aprobar,rechazar',
            'observaciones_aprobador' => 'nullable|string|max:1000',
            'items' => 'required_if:accion,aprobar|array',
            'items.*.id' => 'required_if:accion,aprobar|exists:items_solicitud_inventario,id',
            'items.*.cantidad_aprobada' => 'required_if:accion,aprobar|integer|min:0',
        ]);
        
        DB::beginTransaction();
        try {
            if ($validated['accion'] === 'aprobar') {
                // Actualizar cantidades aprobadas
                foreach ($validated['items'] as $itemData) {
                    ItemSolicitudInventario::where('id', $itemData['id'])
                        ->update(['cantidad_aprobada' => $itemData['cantidad_aprobada']]);
                }
                
                $solicitud->update([
                    'estado' => 'aprobada',
                    'aprobado_por' => auth()->id(),
                    'fecha_aprobacion' => now(),
                    'observaciones_aprobador' => $validated['observaciones_aprobador']
                ]);
                
                $mensaje = 'Solicitud aprobada exitosamente.';
            } else {
                $solicitud->update([
                    'estado' => 'rechazada',
                    'aprobado_por' => auth()->id(),
                    'fecha_aprobacion' => now(),
                    'observaciones_aprobador' => $validated['observaciones_aprobador']
                ]);
                
                $mensaje = 'Solicitud rechazada.';
            }
            
            DB::commit();
            
            return redirect()
                ->route('inventario.solicitudes.show', $solicitud)
                ->with('success', $mensaje);
                
        } catch (\Exception $e) {
            DB::rollBack();
            return back()->with('error', 'Error al procesar la solicitud: ' . $e->getMessage());
        }
    }
    
    /**
     * Despachar solicitud aprobada
     */
    public function despachar(Request $request, SolicitudInventario $solicitud)
    {
        $this->authorize('dispatch', $solicitud);
        
        if (!$solicitud->isAprobada()) {
            return back()->with('error', 'Solo se pueden despachar solicitudes aprobadas.');
        }
        
        $validated = $request->validate([
            'items' => 'required|array',
            'items.*.id' => 'required|exists:items_solicitud_inventario,id',
            'items.*.cantidad_despachada' => 'required|integer|min:0',
        ]);
        
        DB::beginTransaction();
        try {
            // Actualizar cantidades despachadas y descontar del inventario
            foreach ($validated['items'] as $itemData) {
                $item = ItemSolicitudInventario::with('material')->findOrFail($itemData['id']);
                $cantidadDespachada = (int) $itemData['cantidad_despachada'];
                
                // Actualizar cantidad despachada del item
                $item->update(['cantidad_despachada' => $cantidadDespachada]);
                
                // Descontar del inventario si hay cantidad despachada
                if ($cantidadDespachada > 0) {
                    $material = $item->material;
                    $stockAnterior = $material->stock_actual;
                    $stockNuevo = $stockAnterior - $cantidadDespachada;
                    
                    // Actualizar stock del material
                    $material->update(['stock_actual' => $stockNuevo]);
                    
                    // Registrar movimiento de inventario
                    \App\Models\MovimientoInventario::create([
                        'material_id' => $material->id,
                        'user_id' => auth()->id(),
                        'tipo' => 'SALIDA',
                        'cantidad' => $cantidadDespachada,
                        'stock_anterior' => $stockAnterior,
                        'stock_nuevo' => $stockNuevo,
                        'motivo' => 'DESPACHO DE SOLICITUD',
                        'referencia' => $solicitud->numero_solicitud,
                    ]);
                }
            }
            
            $solicitud->update([
                'estado' => 'despachada',
                'despachado_por' => auth()->id(),
                'fecha_despacho' => now()
            ]);
            
            DB::commit();
            
            return redirect()
                ->route('inventario.solicitudes.show', $solicitud)
                ->with('success', 'Solicitud despachada exitosamente. Inventario actualizado.');
                
        } catch (\Exception $e) {
            DB::rollBack();
            return back()->with('error', 'Error al despachar la solicitud: ' . $e->getMessage());
        }
    }
    
    /**
     * Eliminar solicitud (solo si está pendiente)
     */
    public function destroy(SolicitudInventario $solicitud)
    {
        $this->authorize('delete', $solicitud);
        
        if (!$solicitud->isPendiente()) {
            return back()->with('error', 'Solo se pueden eliminar solicitudes pendientes.');
        }
        
        $numero = $solicitud->numero_solicitud;
        $solicitud->delete();
        
        return redirect()
            ->route('inventario.solicitudes.index')
            ->with('success', "Solicitud {$numero} eliminada exitosamente.");
    }
}
