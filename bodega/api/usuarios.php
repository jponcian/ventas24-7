<?php
require_once __DIR__ . '/cors.php';
require __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$method = $_SERVER['REQUEST_METHOD'];
$nid = $_GET['negocio_id'] ?? null;

if (!$nid) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'negocio_id requerido']);
    exit;
}

try {
    global $db;

    if ($method === 'GET') {
        $stmt = $db->prepare("SELECT id, cedula, nombre_completo, rol, activo, created_at FROM users WHERE negocio_id = ? ORDER BY nombre_completo ASC");
        $stmt->execute([$nid]);
        $users = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode(['ok' => true, 'usuarios' => $users]);
    } 
    elseif ($method === 'POST') {
        $json = file_get_contents('php://input');
        $body = json_decode($json, true) ?? [];
        
        $action = $body['action'] ?? 'create';
        $uid = $body['id'] ?? null;
        $cedula = $body['cedula'] ?? '';
        $nombre = $body['nombre_completo'] ?? '';
        $rol = $body['rol'] ?? 'vendedor';
        $password = $body['password'] ?? '';
        $activo = isset($body['activo']) ? (int)$body['activo'] : 1;

        if ($action === 'create') {
            if (empty($cedula) || empty($password)) {
                 echo json_encode(['ok' => false, 'error' => 'Cédula y contraseña requeridas']);
                 exit;
            }
            $hash = password_hash($password, PASSWORD_BCRYPT);
            $stmt = $db->prepare("INSERT INTO users (negocio_id, cedula, nombre_completo, rol, password_hash, activo) VALUES (?, ?, ?, ?, ?, ?)");
            $stmt->execute([$nid, $cedula, $nombre, $rol, $hash, $activo]);
            echo json_encode(['ok' => true, 'id' => $db->lastInsertId()]);
        } 
        elseif ($action === 'update') {
            if (!$uid) {
                echo json_encode(['ok' => false, 'error' => 'ID de usuario requerido']);
                exit;
            }
            $sql = "UPDATE users SET cedula = ?, nombre_completo = ?, rol = ?, activo = ? WHERE id = ? AND negocio_id = ?";
            $params = [$cedula, $nombre, $rol, $activo, $uid, $nid];
            
            if (!empty($password)) {
                $hash = password_hash($password, PASSWORD_BCRYPT);
                $sql = "UPDATE users SET cedula = ?, nombre_completo = ?, rol = ?, activo = ?, password_hash = ? WHERE id = ? AND negocio_id = ?";
                $params = [$cedula, $nombre, $rol, $activo, $hash, $uid, $nid];
            }
            
            $stmt = $db->prepare($sql);
            $stmt->execute($params);
            echo json_encode(['ok' => true]);
        }
        elseif ($action === 'delete') {
            if (!$uid) {
                echo json_encode(['ok' => false, 'error' => 'ID de usuario requerido']);
                exit;
            }
            $stmt = $db->prepare("DELETE FROM users WHERE id = ? AND negocio_id = ? AND rol != 'superadmin'");
            $stmt->execute([$uid, $nid]);
            echo json_encode(['ok' => true]);
        }
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
