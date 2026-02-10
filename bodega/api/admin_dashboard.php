<?php
require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$negocio_id = $_GET['negocio_id'] ?? null;
$fecha = $_GET['fecha'] ?? date('Y-m-d');

if (!$negocio_id) {
    echo json_encode(['ok' => false, 'error' => 'negocio_id requerido']);
    exit;
}

error_log("Admin Dashboard request: negocio_id=$negocio_id, fecha=$fecha");

try {
    global $db; // Usar el objeto $db de db.php

    // --- 1. Resumen de Ventas del día ---
    $stmt = $db->prepare("
        SELECT 
            COUNT(*) as num_ventas,
            COALESCE(SUM(total_usd), 0) as total_ventas_usd,
            COALESCE(SUM(total_bs), 0) as total_ventas_bs
        FROM ventas 
        WHERE negocio_id = ? 
        AND DATE(fecha) = ?
    ");
    $stmt->execute([$negocio_id, $fecha]);
    $ventas = $stmt->fetch(PDO::FETCH_ASSOC);

    // --- 2. Costos del día (Basado en el costo actual del producto) ---
    // Como detalle_ventas no guarda el costo histórico, usamos el costo actual en productos
    $stmtCostos = $db->prepare("
        SELECT COALESCE(SUM(
            CASE 
                WHEN p.moneda_base = 'USD' THEN dv.cantidad * p.costo_unitario
                ELSE dv.cantidad * (p.costo_unitario / v.tasa)
            END
        ), 0) as total_costos_usd
        FROM detalle_ventas dv
        INNER JOIN ventas v ON dv.venta_id = v.id
        INNER JOIN productos p ON dv.producto_id = p.id
        WHERE v.negocio_id = ? 
        AND DATE(v.fecha) = ?
    ");
    $stmtCostos->execute([$negocio_id, $fecha]);
    $costosRow = $stmtCostos->fetch(PDO::FETCH_ASSOC);
    $total_costos_usd = floatval($costosRow['total_costos_usd']);

    // --- 3. Inversión Total (Valor del inventario a precio de costo) ---
    // Necesitamos una tasa para convertir costos en BS a USD si existen
    // Obtenemos la tasa más reciente de las ventas como referencia
    $stmtTasa = $db->prepare("SELECT tasa FROM ventas WHERE negocio_id = ? ORDER BY fecha DESC LIMIT 1");
    $stmtTasa->execute([$negocio_id]);
    $lastTasa = $stmtTasa->fetchColumn();
    if (!$lastTasa) $lastTasa = 1; // Fallback

    $stmtInv = $db->prepare("
        SELECT COALESCE(SUM(
            CASE 
                WHEN moneda_base = 'USD' THEN stock * costo_unitario
                ELSE stock * costo_unitario / ?
            END
        ), 0) as inversion_total_usd
        FROM productos 
        WHERE negocio_id = ? 
        AND stock > 0
    ");
    $stmtInv->execute([$lastTasa, $negocio_id]);
    $inversionRow = $stmtInv->fetch(PDO::FETCH_ASSOC);
    $inversion_total_usd = floatval($inversionRow['inversion_total_usd']);

    // --- 4. Recaudación Potencial (Valor del inventario a precio de venta) ---
    $stmtRec = $db->prepare("
        SELECT COALESCE(SUM(
            CASE 
                WHEN moneda_base = 'USD' THEN stock * precio_venta_unidad
                ELSE stock * precio_venta_unidad / ?
            END
        ), 0) as recaudacion_potencial_usd
        FROM productos 
        WHERE negocio_id = ? 
        AND stock > 0
    ");
    $stmtRec->execute([$lastTasa, $negocio_id]);
    $recaudacionRow = $stmtRec->fetch(PDO::FETCH_ASSOC);
    $recaudacion_potencial_usd = floatval($recaudacionRow['recaudacion_potencial_usd']);

    // --- 5. Ventas por hora ---
    $stmtHora = $db->prepare("
        SELECT 
            HOUR(fecha) as hora,
            COALESCE(SUM(total_usd), 0) as total
        FROM ventas 
        WHERE negocio_id = ? 
        AND DATE(fecha) = ?
        GROUP BY HOUR(fecha)
        ORDER BY hora
    ");
    $stmtHora->execute([$negocio_id, $fecha]);
    $ventas_por_hora = $stmtHora->fetchAll(PDO::FETCH_ASSOC);

    // --- 6. Top 5 productos más vendidos del día ---
    $stmtTop = $db->prepare("
        SELECT 
            p.nombre,
            SUM(dv.cantidad) as cantidad_vendida,
            SUM(dv.cantidad * (dv.precio_unitario_bs / v.tasa)) as total_ventas_usd
        FROM detalle_ventas dv
        INNER JOIN ventas v ON dv.venta_id = v.id
        INNER JOIN productos p ON dv.producto_id = p.id
        WHERE v.negocio_id = ? 
        AND DATE(v.fecha) = ?
        GROUP BY p.id, p.nombre
        ORDER BY cantidad_vendida DESC
        LIMIT 5
    ");
    $stmtTop->execute([$negocio_id, $fecha]);
    $top_productos = [];
    while ($row = $stmtTop->fetch(PDO::FETCH_ASSOC)) {
        $top_productos[] = [
            'nombre' => $row['nombre'],
            'cantidad_vendida' => floatval($row['cantidad_vendida']),
            'total_ventas' => floatval($row['total_ventas_usd'])
        ];
    }

    // Cálculos finales
    $total_ventas_usd = floatval($ventas['total_ventas_usd']);
    $ganancia_neta = $total_ventas_usd - $total_costos_usd;
    $margen_porcentaje = $total_ventas_usd > 0 ? ($ganancia_neta / $total_ventas_usd) * 100 : 0;

    // --- 7. Ventas por método de pago ---
    $stmtMetodos = $db->prepare("
        SELECT 
            COALESCE(m.nombre, 'Efectivo') as metodo,
            COALESCE(SUM(v.total_bs), 0) as total_bs,
            COALESCE(SUM(v.total_usd), 0) as total_usd
        FROM ventas v
        LEFT JOIN metodos_pago m ON v.metodo_pago_id = m.id
        WHERE v.negocio_id = ? AND DATE(v.fecha) = ?
        GROUP BY COALESCE(m.nombre, 'Efectivo')
    ");
    $stmtMetodos->execute([$negocio_id, $fecha]);
    $ventas_por_metodo = $stmtMetodos->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'ok' => true,
        'total_ventas_usd' => $total_ventas_usd,
        'total_ventas_bs' => floatval($ventas['total_ventas_bs']),
        'num_ventas' => intval($ventas['num_ventas']),
        'total_costos_usd' => $total_costos_usd,
        'ganancia_neta_usd' => $ganancia_neta,
        'margen_porcentaje' => $margen_porcentaje,
        'inversion_total_usd' => $inversion_total_usd,
        'recaudacion_potencial_usd' => $recaudacion_potencial_usd,
        'ventas_por_hora' => $ventas_por_hora,
        'top_productos' => $top_productos,
        'ventas_por_metodo' => $ventas_por_metodo
    ]);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'ok' => false,
        'error' => $e->getMessage(),
        'trace' => $e->getTraceAsString()
    ]);
}
