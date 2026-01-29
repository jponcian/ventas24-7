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
    
    // Total compras del día usando el maestro
    $stmt = $db->prepare("
        SELECT 
            COUNT(*) as total_transacciones,
            COALESCE(SUM(total), 0) as total_costo
        FROM compras 
        WHERE negocio_id = ? AND DATE(fecha) = ?
    ");
    $stmt->execute([$nid, $fecha]);
    $resumen = $stmt->fetch(PDO::FETCH_ASSOC);

    // Detalle de todos los items comprados en el día
    $stmtDetalle = $db->prepare("
        SELECT 
            p.nombre,
            ci.cantidad,
            ci.costo_unitario,
            (ci.cantidad * ci.costo_unitario) as total,
            COALESCE(p.proveedor, 'Sin Proveedor') as proveedor,
            c.fecha
        FROM compras_items ci
        JOIN compras c ON c.id = ci.compra_id
        JOIN productos p ON p.id = ci.producto_id
        WHERE c.negocio_id = ? AND DATE(c.fecha) = ?
        ORDER BY c.fecha DESC, p.nombre
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
