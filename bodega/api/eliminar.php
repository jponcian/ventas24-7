<?php
require_once __DIR__ . '/cors.php';
require __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$json = file_get_contents('php://input');
$body = json_decode($json, true) ?? [];

if (empty($body) && !empty($_POST)) {
    $body = $_POST;
}

if (!isset($body['id'])) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'Falta id']);
    exit;
}

if (!isset($body['negocio_id'])) {
    $body['negocio_id'] = 1;
}

$id = intval($body['id']);
$negocio_id = intval($body['negocio_id']);

try {
    $ok = eliminarProducto($id, $negocio_id);
    echo json_encode(['ok' => (bool)$ok]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
