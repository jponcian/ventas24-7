<?php
require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$json = file_get_contents('php://input');
$body = json_decode($json, true) ?? [];

if (!isset($body['negocio_id']) || !isset($body['detalles'])) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'Faltan datos de la venta']);
    exit;
}

$negocio_id = intval($body['negocio_id']);
$total_bs = floatval($body['total_bs'] ?? 0);
$total_usd = floatval($body['total_usd'] ?? 0);
$tasa = floatval($body['tasa'] ?? 0);
$detalles = $body['detalles'];

if (registrarVenta($negocio_id, $total_bs, $total_usd, $tasa, $detalles)) {
    echo json_encode(['ok' => true]);
} else {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => 'Error al registrar la venta']);
}
