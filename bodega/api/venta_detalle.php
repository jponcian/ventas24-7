<?php
require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$vid = $_GET['id'] ?? null;

if (!$vid) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'ID de venta requerido']);
    exit;
}

try {
    $detalles = obtenerVentaDetalle($vid);
    $pagos = obtenerVentaPagos($vid);
    $info = null;
    try {
        $info = obtenerInfoVenta($vid);
    } catch (Exception $ei) {
        // Si falla la info del cliente, no bloqueamos el detalle
        error_log('obtenerInfoVenta error: ' . $ei->getMessage());
    }
    echo json_encode(['ok' => true, 'detalles' => $detalles, 'pagos' => $pagos, 'info' => $info]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
