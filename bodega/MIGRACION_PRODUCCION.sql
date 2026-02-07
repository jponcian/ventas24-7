-- ============================================================================
-- MIGRACIÓN PARA PRODUCCIÓN: Campo es_paquete en detalle_ventas
-- Fecha: 2026-02-06
-- Descripción: Agrega campo para distinguir ventas por paquete vs unidad
--              y corrige datos históricos mal registrados
-- ============================================================================

-- Paso 1: Agregar columna es_paquete a detalle_ventas
-- Esta columna indica si la venta fue por paquete (1) o por unidad individual (0)
ALTER TABLE `detalle_ventas` 
ADD COLUMN `es_paquete` TINYINT(1) NOT NULL DEFAULT 0 
COMMENT 'Indica si la venta fue por paquete (1) o unidad (0)' 
AFTER `cantidad`;

-- Paso 2: Corregir datos históricos
-- Identifica ventas que fueron registradas incorrectamente
-- (cuando se vendió 1 paquete pero se guardó como 20 unidades)
UPDATE detalle_ventas dv
INNER JOIN productos p ON dv.producto_id = p.id
SET 
    dv.es_paquete = 1,
    dv.cantidad = dv.cantidad / p.tam_paquete
WHERE 
    p.unidad_medida = 'paquete' 
    AND p.tam_paquete > 1
    AND MOD(dv.cantidad, p.tam_paquete) = 0
    AND dv.cantidad >= p.tam_paquete
    AND dv.es_paquete = 0;

-- Paso 3: Verificar los cambios realizados
-- Ejecuta esta consulta para ver cuántos registros fueron corregidos
SELECT 
    COUNT(*) as registros_corregidos,
    'Ventas por paquete identificadas' as descripcion
FROM detalle_ventas 
WHERE es_paquete = 1;

-- Paso 4: Ver ejemplos de registros corregidos
SELECT 
    dv.id,
    dv.venta_id,
    p.nombre as producto,
    dv.cantidad,
    CASE WHEN dv.es_paquete = 1 THEN 'Paquete' ELSE 'Unidad' END as tipo_venta,
    dv.precio_unitario_bs,
    (dv.cantidad * dv.precio_unitario_bs) as subtotal_bs
FROM detalle_ventas dv
INNER JOIN productos p ON dv.producto_id = p.id
WHERE dv.es_paquete = 1
ORDER BY dv.id DESC
LIMIT 10;

-- ============================================================================
-- NOTAS IMPORTANTES:
-- ============================================================================
-- 1. Esta migración es SEGURA y NO elimina datos
-- 2. Solo corrige cantidades que eran múltiplos exactos del tamaño del paquete
-- 3. Después de ejecutar, las nuevas ventas se registrarán correctamente
-- 4. El frontend mostrará "paq" o "und" según corresponda
-- 5. Si algo sale mal, puedes revertir con:
--    UPDATE detalle_ventas SET es_paquete = 0 WHERE es_paquete = 1;
--    (Pero tendrías que recalcular las cantidades manualmente)
-- ============================================================================
