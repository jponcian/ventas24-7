<?php
require_once __DIR__ . '/cors.php';
header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['ok' => false, 'error' => 'Método no permitido']);
    exit;
}

if (!isset($_FILES['imagen'])) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'No se recibió ninguna imagen']);
    exit;
}

$file = $_FILES['imagen'];
$uploadDir = __DIR__ . '/../uploads/productos/';

if (!is_dir($uploadDir)) {
    mkdir($uploadDir, 0777, true);
}

$ext = pathinfo($file['name'], PATHINFO_EXTENSION);
$fileName = 'prod_' . time() . '_' . uniqid() . '.' . $ext;
$targetPath = $uploadDir . $fileName;

if (move_uploaded_file($file['tmp_name'], $targetPath)) {
    echo json_encode(['ok' => true, 'url' => 'uploads/productos/' . $fileName]);
} else {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => 'Error al guardar el archivo']);
}
