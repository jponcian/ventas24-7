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
$user = encontrarUsuarioPorUsername($username);
if (!$user || !password_verify($password, $user['password_hash'])) {
    echo json_encode(['ok' => false, 'error' => 'Usuario/contraseña inválidos']);
    exit;
}
// login
$_SESSION['user_id'] = $user['id'];
$_SESSION['username'] = $user['username'];
echo json_encode(['ok' => true, 'user_id' => $user['id'], 'username' => $user['username']]);
