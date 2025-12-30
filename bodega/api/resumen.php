<?php
// Endpoint simple que lista productos como JSON
require __DIR__ . '/../db.php';

header('Content-Type: application/json; charset=utf-8');

try {
    $productos = obtenerProductos();
    echo json_encode($productos);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => 'Error al obtener productos']);
}
