<?php
require_once __DIR__ . '/cors.php';
require __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$nid = isset($_GET['negocio_id']) ? intval($_GET['negocio_id']) : 0;
$fecha = isset($_GET['fecha']) ? $_GET['fecha'] : date('Y-m-d');

if ($nid <= 0) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'Falta negocio_id']);
    exit;
}

try {
    global $db;
    
    // Total compras del día
    // costo_unitario * cantidad
    $stmt = $db->prepare("
        SELECT 
            COUNT(*) as total_transacciones,
            COALESCE(SUM(cantidad * IFNULL(costo_unitario, 0)), 0) as total_costo
        FROM compras 
        WHERE negocio_id = ? AND DATE(fecha) = ?
    ");
    $stmt->execute([$nid, $fecha]);
    $resumen = $stmt->fetch(PDO::FETCH_ASSOC);

    // Detalle agrupado por proveedor
    $stmtDetalle = $db->prepare("
        SELECT 
            p.nombre,
            c.cantidad,
            c.costo_unitario,
            (c.cantidad * IFNULL(c.costo_unitario, 0)) as total,
            COALESCE(p.proveedor, 'Sin Proveedor') as proveedor
        FROM compras c
        JOIN productos p ON p.id = c.producto_id
        WHERE c.negocio_id = ? AND DATE(c.fecha) = ?
        ORDER BY proveedor, p.nombre
    ");
    $stmtDetalle->execute([$nid, $fecha]);
    $items = $stmtDetalle->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'ok' => true,
        'fecha' => $fecha,
        'resumen' => $resumen,
        'items' => $items
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
?>
