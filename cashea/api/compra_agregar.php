<?php
require '../db.php';
// session_start(); // Ya se inicia en db.php si es necesario
header('Content-Type: application/json');

$input = json_decode(file_get_contents('php://input'), true);
if (!$input) {
    echo json_encode(['ok' => false, 'error' => 'Entrada inválida']);
    exit;
}

$usuario = trim(isset($input['usuario']) ? $input['usuario'] : '');
$producto = trim(isset($input['producto']) ? $input['producto'] : '');
$precio = isset($input['precio']) ? floatval($input['precio']) : null;
$inicial = isset($input['inicial']) ? floatval($input['inicial']) : null;
$cuotas = isset($input['cuotas']) ? intval($input['cuotas']) : null;
$fecha_compra = trim(isset($input['fecha_compra']) ? $input['fecha_compra'] : '');
$telefono = trim(isset($input['telefono']) ? $input['telefono'] : '');

if ($usuario === '' || $producto === '' || !$fecha_compra || $precio === null || $inicial === null || $cuotas === null) {
    echo json_encode(['ok' => false, 'error' => 'Campos incompletos']);
    exit;
}
// Normalizar teléfono: dejar solo dígitos
$hasPlus = false;
$telefono = trim($telefono);
// Quitar espacios y caracteres no numéricos excepto +
$telefono = preg_replace('/[^0-9+]/', '', $telefono);
// Si viene con +58 prefijo, quitarlo para validar operadora+numero
if (strpos($telefono, '+58') === 0) {
    $telefono = substr($telefono, 3);
}
// Si viene con + en otra forma, eliminar
$telefono = str_replace('+', '', $telefono);
// Ahora $telefono debe ser sólo dígitos. Puede ser 10 (operadora+7) o 7 (solo número, que no aceptamos)
$telefono = preg_replace('/[^0-9]/', '', $telefono);
$operadoras = ['414', '424', '416', '426', '412', '422'];
if (strlen($telefono) === 10) {
    $op = substr($telefono, 0, 3);
    $rest = substr($telefono, 3);
    if (!in_array($op, $operadoras)) {
        echo json_encode(['ok' => false, 'error' => 'Operadora inválida']);
        exit;
    }
    $telefono = '+58' . $op . $rest;
} else {
    echo json_encode(['ok' => false, 'error' => 'Teléfono inválido. Use +58{operadora}{7 dígitos} o operadora+numero.']);
    exit;
}

try {
    // requerir sesión antes de agregar
    if (!isset($_SESSION['user_id'])) {
        echo json_encode(['ok' => false, 'error' => 'No autorizado']);
        exit;
    }

    agregarCompra($producto, $precio, $inicial, $cuotas, $fecha_compra, $usuario, $telefono);
    echo json_encode(['ok' => true]);
} catch (Exception $e) {
    error_log('Error agregando compra: ' . $e->getMessage());
    echo json_encode(['ok' => false, 'error' => 'Error interno del servidor']);
    exit;
}
