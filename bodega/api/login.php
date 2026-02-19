<?php
require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$json = file_get_contents('php://input');
$body = json_decode($json, true) ?? [];

$cedula = isset($body['cedula']) ? trim($body['cedula']) : '';
$password = isset($body['password']) ? $body['password'] : '';

if (empty($cedula) || empty($password)) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'Cedula y contraseña requeridas']);
    exit;
}

try {
    global $db;
    $stmt = $db->prepare("SELECT * FROM users WHERE cedula = ? LIMIT 1");
    $stmt->execute([$cedula]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$user) {
        http_response_code(401);
        echo json_encode(['ok' => false, 'error' => 'Usuario no encontrado']);
        exit;
    }

    if (!password_verify($password, $user['password_hash'])) {
        http_response_code(401);
        echo json_encode(['ok' => false, 'error' => 'Contraseña incorrecta']);
        exit;
    }

    // Obtener negocios asignados
    $stmtNeg = $db->prepare("
        SELECT n.id, n.nombre 
        FROM negocios n 
        INNER JOIN user_negocios un ON n.id = un.negocio_id 
        WHERE un.user_id = ? AND n.activo = 1
    ");
    $stmtNeg->execute([$user['id']]);
    $negocios = $stmtNeg->fetchAll(PDO::FETCH_ASSOC);

    // Si es superadmin y no tiene negocios asignados explícitamente, ver todos
    if ($user['rol'] === 'superadmin' && empty($negocios)) {
        $negocios = $db->query("SELECT id, nombre FROM negocios WHERE activo = 1")->fetchAll(PDO::FETCH_ASSOC);
    }

    if (empty($negocios)) {
        http_response_code(401);
        echo json_encode(['ok' => false, 'error' => 'Usuario sin negocios activos asignados']);
        exit;
    }

    echo json_encode([
        'ok' => true,
        'user' => [
            'id' => $user['id'],
            'cedula' => $user['cedula'],
            'nombre' => $user['nombre_completo'],
            'rol' => $user['rol'],
            'telefono_notificaciones' => $user['telefono_notificaciones']
        ],
        'negocios' => $negocios
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => 'Error en el servidor: ' . $e->getMessage()]);
}
