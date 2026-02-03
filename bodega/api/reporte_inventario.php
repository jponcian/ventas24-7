<?php
require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$nid = $_GET['negocio_id'] ?? null;

if (!$nid) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'negocio_id requerido']);
    exit;
}

try {
    global $db;

    // Obtener productos con stock mayor a 0 y sus costos
    $stmt = $db->prepare("
        SELECT 
            p.id, 
            p.nombre, 
            p.stock, 
            p.costo_unitario, 
            p.precio_venta_unidad as precio_venta, 
            p.moneda_base,
            pr.nombre as proveedor
        FROM productos p
        LEFT JOIN proveedores pr ON p.proveedor_id = pr.id
        WHERE p.negocio_id = ? AND p.stock > 0
        ORDER BY pr.nombre, p.nombre
    ");
    $stmt->execute([$nid]);
    $productos = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Calcular totales
    // Nota: El reporte asume que manejamos inventario en USD como base principal de activos
    // pero incluiremos desglose si hay activos en BS.
    
    echo json_encode([
        'ok' => true,
        'productos' => $productos
    ]);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
