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
    echo json_encode(['ok' => true, 'detalles' => $detalles]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
