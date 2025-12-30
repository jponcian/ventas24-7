<?php
require '../db.php';
header('Content-Type: application/json');

$input = json_decode(file_get_contents('php://input'), true);
if (!$input) {
    echo json_encode(['ok' => false, 'error' => 'Entrada inválida']);
    exit;
}
$username = trim(isset($input['username']) ? $input['username'] : '');
$password = trim(isset($input['password']) ? $input['password'] : '');
if ($username === '' || $password === '') {
    echo json_encode(['ok' => false, 'error' => 'Campos incompletos']);
    exit;
}
if (encontrarUsuarioPorUsername($username)) {
    echo json_encode(['ok' => false, 'error' => 'Usuario ya existe']);
    exit;
}
try {
    $id = crearUsuario($username, $password);
    // iniciar sesión
    $_SESSION['user_id'] = $id;
    $_SESSION['username'] = $username;
    echo json_encode(['ok' => true, 'user_id' => $id]);
} catch (Exception $e) {
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
