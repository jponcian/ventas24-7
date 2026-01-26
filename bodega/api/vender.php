<?php
require_once __DIR__ . '/cors.php';
require __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$json = file_get_contents('php://input');
$body = json_decode($json, true) ?? [];

if (!isset($body['total_bs']) || !isset($body['detalles'])) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'Faltan datos de la venta']);
    exit;
}

$total_bs = floatval($body['total_bs']);
$total_usd = isset($body['total_usd']) ? floatval($body['total_usd']) : 0;
$tasa = isset($body['tasa']) ? floatval($body['tasa']) : 0;
$detalles = $body['detalles'];

if (registrarVenta($total_bs, $total_usd, $tasa, $detalles)) {
    echo json_encode(['ok' => true]);
} else {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => 'Error al registrar la venta']);
}
