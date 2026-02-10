<?php
require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$negocio_id = isset($_GET['negocio_id']) ? intval($_GET['negocio_id']) : 0;
// Support query parameter 'fecha'
$fecha = isset($_GET['fecha']) ? $_GET['fecha'] : date('Y-m-d');

if ($negocio_id <= 0) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'Falta negocio_id']);
    exit;
}

try {
    global $db;
    
    // Total ventas del día - use DATE() function to strip time part if exists
    // COALESCE to return 0 instead of null
    $stmt = $db->prepare("
        SELECT 
            COUNT(*) as total_transacciones,
            COALESCE(SUM(total_bs), 0) as total_bs,
            COALESCE(SUM(total_usd), 0) as total_usd
        FROM ventas 
        WHERE negocio_id = ? AND DATE(fecha) = ?
    ");
    $stmt->execute([$negocio_id, $fecha]);
    $resumen = $stmt->fetch(PDO::FETCH_ASSOC);

    // Detalle de productos vendidos
    // We group by product name to show total quantity sold per product
    $stmtDetalle = $db->prepare("
        SELECT 
            p.nombre,
            p.codigo_interno,
            p.unidad_medida, 
            COALESCE(pr.nombre, 'Sin Proveedor') as proveedor,
            SUM(d.cantidad) as total_cantidad,
            SUM(d.cantidad * d.precio_unitario_bs) as total_bs
        FROM detalle_ventas d
        JOIN ventas v ON v.id = d.venta_id
        JOIN productos p ON p.id = d.producto_id
        LEFT JOIN proveedores pr ON pr.id = p.proveedor_id
        WHERE v.negocio_id = ? AND DATE(v.fecha) = ?
        GROUP BY pr.nombre, p.id, p.nombre, p.codigo_interno, p.unidad_medida
        ORDER BY proveedor, nombre
    ");
    $stmtDetalle->execute([$negocio_id, $fecha]);
    $productos = $stmtDetalle->fetchAll(PDO::FETCH_ASSOC);

    // Listado de ventas individuales
    $stmtVentas = $db->prepare("SELECT id, total_usd, total_bs, fecha FROM ventas WHERE negocio_id = ? AND DATE(fecha) = ? ORDER BY fecha DESC");
    $stmtVentas->execute([$negocio_id, $fecha]);
    $ventas = $stmtVentas->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'ok' => true,
        'fecha' => $fecha,
        'resumen' => $resumen,
        'productos' => $productos,
        'ventas' => $ventas
    ]);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
?>
