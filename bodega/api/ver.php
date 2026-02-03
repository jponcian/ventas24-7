<?php
require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$negocio_id = isset($_GET['negocio_id']) ? intval($_GET['negocio_id']) : 1;
$id = isset($_GET['id']) ? intval($_GET['id']) : null;
$q = isset($_GET['q']) ? $_GET['q'] : null;

if ($negocio_id <= 0) {
    $negocio_id = 1;
}

try {
    if ($id) {
        $p = getProducto($id, $negocio_id);
        echo json_encode($p ?: ['ok' => false, 'error' => 'No encontrado']);
    } else {
        $lista = obtenerProductos($negocio_id, $q);
        echo json_encode($lista);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
