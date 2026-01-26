<?php
require_once __DIR__ . '/cors.php';
require __DIR__ . '/../db.php';
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
    error_log("Login attempt: Cedula=$cedula, Pass=" . (empty($password) ? 'EMPTY' : 'PROVIDED'));
    $stmt = $db->prepare("SELECT u.*, n.nombre as negocio_nombre FROM users u JOIN negocios n ON u.negocio_id = n.id WHERE u.cedula = ? LIMIT 1");
    $stmt->execute([$cedula]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$user) {
        error_log("User not found or inactive: $cedula");
    } else {
        error_log("User found: " . $user['nombre_completo']);
    }

    if ($user && password_verify($password, $user['password_hash'])) {
        // En un sistema real usaríamos JWT, aquí mandamos los datos básicos para simplificar
        echo json_encode([
            'ok' => true,
            'user' => [
                'id' => $user['id'],
                'cedula' => $user['cedula'],
                'nombre' => $user['nombre_completo'],
                'rol' => $user['rol'],
                'negocio_id' => $user['negocio_id'],
                'negocio_nombre' => $user['negocio_nombre']
            ]
        ]);
    } else {
        http_response_code(401);
        $error = (!$user) ? 'Usuario no encontrado' : 'Contraseña incorrecta';
        echo json_encode(['ok' => false, 'error' => $error]);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => 'Error en el servidor: ' . $e->getMessage()]);
}
