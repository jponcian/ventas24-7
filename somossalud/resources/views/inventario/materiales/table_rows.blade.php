@forelse($materiales as $material)
    <tr>
        <td class="pl-4 font-weight-bold text-muted">{{ $material->codigo }}</td>
        <td>
            <div class="font-weight-bold">{{ $material->nombre }}</div>
            <small class="text-muted">{{ Str::limit($material->descripcion, 50) }}</small>
        </td>
        <td><span class="badge badge-light border">{{ $material->categoria_default }}</span></td>
        <td>{{ $material->unidad_medida_default }}</td>
        <td class="text-center">
            <span class="badge badge-{{ $material->stock_actual <= $material->stock_minimo ? 'danger' : 'success' }} px-3 py-2" style="font-size: 1rem;">
                {{ $material->stock_actual }}
            </span>
        </td>
        <td class="text-center text-muted">{{ $material->stock_minimo }}</td>
        <td class="text-right pr-4">
            <a href="{{ route('inventario.materiales.edit', $material) }}" class="btn btn-sm btn-outline-primary" title="Editar">
                <i class="fas fa-edit"></i>
            </a>
            <form action="{{ route('inventario.materiales.destroy', $material) }}" method="POST" class="d-inline" onsubmit="return confirm('¿Eliminar material?');">
                @csrf @method('DELETE')
                <button type="submit" class="btn btn-sm btn-outline-danger" title="Eliminar">
                    <i class="fas fa-trash"></i>
                </button>
            </form>
        </td>
    </tr>
@empty
    <tr>
        <td colspan="7" class="text-center py-5 text-muted">No se encontraron materiales.</td>
    </tr>
@endforelse
