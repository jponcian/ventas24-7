<?php
require_once __DIR__ . '/cors.php';
header('Content-Type: application/json');
require_once __DIR__ . '/../db.php';

$negocio_id = isset($_GET['negocio_id']) ? intval($_GET['negocio_id']) : 0;

if ($negocio_id <= 0) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'Falta negocio_id']);
    exit;
}

try {
    global $db;
    $stmt = $db->prepare("SELECT DISTINCT proveedor FROM productos WHERE negocio_id = ? AND proveedor IS NOT NULL AND proveedor != '' ORDER BY proveedor ASC");
    $stmt->execute([$negocio_id]);
    $proveedores = $stmt->fetchAll(PDO::FETCH_COLUMN);
    echo json_encode(['ok' => true, 'proveedores' => $proveedores]);
} catch (Exception $e) {
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
