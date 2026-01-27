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
    $stmt = $db->prepare("SELECT * FROM users WHERE cedula = ? LIMIT 1");
    $stmt->execute([$cedula]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$user) {
        error_log("User not found: $cedula");
        http_response_code(401);
        echo json_encode(['ok' => false, 'error' => 'Usuario no encontrado']);
        exit;
    }

    if (!password_verify($password, $user['password_hash'])) {
        error_log("Invalid password for user: $cedula");
        http_response_code(401);
        echo json_encode(['ok' => false, 'error' => 'Contraseña incorrecta']);
        exit;
    }

    // Buscar negocio
    $stmtNeg = $db->prepare("SELECT nombre FROM negocios WHERE id = ?");
    $stmtNeg->execute([$user['negocio_id']]);
    $negocio = $stmtNeg->fetch(PDO::FETCH_ASSOC);

    if (!$negocio) {
        error_log("User $cedula has invalid negocio_id: " . $user['negocio_id']);
         // Para mantener compatibilidad, quizás asignar un negocio default o dar error
         // Daremos error para que se sepa qué pasa
         // OJO: Si es el admin global (ID 1), tal vez queramos dejarlo pasar con valores dummy?
         // Pero el app espera negocio_id y nombre.
         
         // Si es un fix rápido para usuario JAVIER (ID 1) que tiene negocio 0:
         if ($user['negocio_id'] == 0) {
             $negocio = ['nombre' => 'Admin Global'];
             $user['negocio_id'] = 1; // Fallback to 1? Or keep 0? App might break with 0 if using FKs.
             // Mejor devolvemos error por ahora.
             http_response_code(401);
             echo json_encode(['ok' => false, 'error' => 'Usuario sin negocio asignado']);
             exit;
         } else {
             http_response_code(401);
             echo json_encode(['ok' => false, 'error' => 'Negocio no encontrado']);
             exit;
         }
    }

    error_log("Login success: " . $user['nombre_completo']);
    
    echo json_encode([
        'ok' => true,
        'user' => [
            'id' => $user['id'],
            'cedula' => $user['cedula'],
            'nombre' => $user['nombre_completo'],
            'rol' => $user['rol'],
            'negocio_id' => $user['negocio_id'],
            'negocio_nombre' => $negocio['nombre']
        ]
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => 'Error en el servidor: ' . $e->getMessage()]);
}
