<?php
require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$method = $_SERVER['REQUEST_METHOD'];

try {
    global $db;

    if ($method === 'GET') {
        $stmt = $db->query("SELECT * FROM negocios ORDER BY nombre ASC");
        $negocios = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode(['ok' => true, 'negocios' => $negocios]);
    } 
    elseif ($method === 'POST') {
        $json = file_get_contents('php://input');
        $body = json_decode($json, true) ?? [];
        
        $action = $body['action'] ?? 'create';
        $id = $body['id'] ?? null;
        $nombre = $body['nombre'] ?? '';
        $rif = $body['rif'] ?? '';
        $activo = isset($body['activo']) ? (int)$body['activo'] : 1;

        if ($action === 'create') {
            if (empty($nombre)) {
                 echo json_encode(['ok' => false, 'error' => 'Nombre de negocio requerido']);
                 exit;
            }
            $stmt = $db->prepare("INSERT INTO negocios (nombre, rif, activo) VALUES (?, ?, ?)");
            $stmt->execute([$nombre, $rif, $activo]);
            echo json_encode(['ok' => true, 'id' => $db->lastInsertId()]);
        } 
        elseif ($action === 'update') {
            if (!$id) {
                echo json_encode(['ok' => false, 'error' => 'ID de negocio requerido']);
                exit;
            }
            $stmt = $db->prepare("UPDATE negocios SET nombre = ?, rif = ?, activo = ? WHERE id = ?");
            $stmt->execute([$nombre, $rif, $activo, $id]);
            echo json_encode(['ok' => true]);
        }
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
