<?php
require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$method = $_SERVER['REQUEST_METHOD'];
$nid = isset($_GET['negocio_id']) ? intval($_GET['negocio_id']) : 1;

if ($method === 'GET') {
    if ($nid <= 0) $nid = 1;
    
    $stmt = $db->prepare("SELECT * FROM proveedores WHERE negocio_id = ? ORDER BY nombre ASC");
    $stmt->execute([$nid]);
    $proveedores = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode(['ok' => true, 'proveedores' => $proveedores]);
    
} elseif ($method === 'POST') {
    $json = file_get_contents('php://input');
    $data = json_decode($json, true) ?? [];
    
    $nid = isset($data['negocio_id']) ? intval($data['negocio_id']) : 1;
    $nombre = trim($data['nombre'] ?? '');
    
    if ($nid <= 0) $nid = 1;

    if (empty($nombre)) {
        http_response_code(400);
        echo json_encode(['ok' => false, 'error' => 'Nombre requerido']);
        exit;
    }
    
    $stmt = $db->prepare("INSERT INTO proveedores (negocio_id, nombre, contacto, telefono) VALUES (?, ?, ?, ?)");
    $stmt->execute([$nid, $nombre, $data['contacto'] ?? null, $data['telefono'] ?? null]);
    
    echo json_encode(['ok' => true, 'id' => $db->lastInsertId()]);
}
?>
