<?php
require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$method = $_SERVER['REQUEST_METHOD'];
$nid = $_GET['negocio_id'] ?? null;
$requester_rol = $_GET['requester_rol'] ?? 'vendedor';

try {
    global $db;
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    if ($method === 'GET') {
        // Si el solicitante es superadmin, vemos TODOS los usuarios del sistema.
        // Si es admin, solo los de su negocio actual y que no sean superadmins.
        if ($requester_rol === 'superadmin') {
            $stmt = $db->query("SELECT id, cedula, nombre_completo, rol, activo, created_at FROM users ORDER BY nombre_completo ASC");
        } else {
            $stmt = $db->prepare("
                SELECT DISTINCT u.id, u.cedula, u.nombre_completo, u.rol, u.activo, u.created_at 
                FROM users u
                INNER JOIN user_negocios un ON u.id = un.user_id
                WHERE un.negocio_id = ? AND u.rol != 'superadmin'
                ORDER BY u.nombre_completo ASC
            ");
            $stmt->execute([$nid]);
        }
        
        $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Para cada usuario, obtenemos la lista de IDs de negocios a los que pertenece
        foreach ($users as &$u) {
            $stmtN = $db->prepare("SELECT negocio_id FROM user_negocios WHERE user_id = ?");
            $stmtN->execute([$u['id']]);
            $u['negocios'] = $stmtN->fetchAll(PDO::FETCH_COLUMN);
        }

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
        $negocios_asignados = $body['negocios'] ?? [];

        if (empty($negocios_asignados) && $nid) {
            $negocios_asignados = [$nid];
        }

        if ($action === 'create') {
            if (empty($cedula) || empty($password)) {
                 echo json_encode(['ok' => false, 'error' => 'Cédula y contraseña requeridas']);
                 exit;
            }
            $hash = password_hash($password, PASSWORD_BCRYPT);
            
            $stmt = $db->prepare("INSERT INTO users (cedula, nombre_completo, rol, password_hash, activo) VALUES (?, ?, ?, ?, ?)");
            $stmt->execute([$cedula, $nombre, $rol, $hash, $activo]);
            $new_uid = $db->lastInsertId();

            foreach ($negocios_asignados as $nbid) {
                $db->prepare("INSERT IGNORE INTO user_negocios (user_id, negocio_id) VALUES (?, ?)")->execute([$new_uid, $nbid]);
            }

            echo json_encode(['ok' => true, 'id' => $new_uid]);
        } 
        elseif ($action === 'update') {
            if (!$uid) {
                echo json_encode(['ok' => false, 'error' => 'ID de usuario requerido']);
                exit;
            }
            
            $sql = "UPDATE users SET cedula = ?, nombre_completo = ?, rol = ?, activo = ? WHERE id = ?";
            $params = [$cedula, $nombre, $rol, $activo, $uid];
            
            if (!empty($password)) {
                $hash = password_hash($password, PASSWORD_BCRYPT);
                $sql = "UPDATE users SET cedula = ?, nombre_completo = ?, rol = ?, activo = ?, password_hash = ? WHERE id = ?";
                $params = [$cedula, $nombre, $rol, $activo, $hash, $uid];
            }
            
            $stmt = $db->prepare($sql);
            $stmt->execute($params);

            // Actualizar tabla pivot
            $db->prepare("DELETE FROM user_negocios WHERE user_id = ?")->execute([$uid]);
            foreach ($negocios_asignados as $nbid) {
                $db->prepare("INSERT IGNORE INTO user_negocios (user_id, negocio_id) VALUES (?, ?)")->execute([$uid, $nbid]);
            }

            echo json_encode(['ok' => true]);
        }
        elseif ($action === 'delete') {
            if (!$uid) {
                echo json_encode(['ok' => false, 'error' => 'ID de usuario requerido']);
                exit;
            }
            $stmt = $db->prepare("DELETE FROM users WHERE id = ? AND rol != 'superadmin'");
            $stmt->execute([$uid]);
            $db->prepare("DELETE FROM user_negocios WHERE user_id = ?")->execute([$uid]);
            echo json_encode(['ok' => true]);
        }
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
