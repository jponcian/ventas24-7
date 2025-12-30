<?php
require '../db.php';
header('Content-Type: application/json');
$input = json_decode(file_get_contents('php://input'), true);
if (!$input) {
    echo json_encode(['ok' => false, 'error' => 'Entrada inválida']);
    exit;
}
$compra_id = isset($input['compra_id']) ? intval($input['compra_id']) : 0;
$usuario = trim(isset($input['usuario']) ? $input['usuario'] : '');
$producto = trim(isset($input['producto']) ? $input['producto'] : '');
$precio = isset($input['precio']) ? floatval($input['precio']) : null;
$inicial = isset($input['inicial']) ? floatval($input['inicial']) : null;
$cuotas = isset($input['cuotas']) ? intval($input['cuotas']) : null;
$fecha_compra = trim(isset($input['fecha_compra']) ? $input['fecha_compra'] : '');
$telefono = trim(isset($input['telefono']) ? $input['telefono'] : '');

if ($compra_id <= 0 || $usuario === '' || $producto === '' || !$fecha_compra || $precio === null || $inicial === null || $cuotas === null) {
    echo json_encode(['ok' => false, 'error' => 'Campos incompletos']);
    exit;
}

// Validar y normalizar telefono si viene
$telefono = preg_replace('/[^0-9+]/', '', $telefono);
if ($telefono !== '') {
    if (strpos($telefono, '+58') === 0) $telefono = substr($telefono, 3);
    $telefono = str_replace('+', '', $telefono);
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
        echo json_encode(['ok' => false, 'error' => 'Teléfono inválido']);
        exit;
    }
} else {
    $telefono = null;
}

try {
    if (!isset($_SESSION['user_id'])) {
        echo json_encode(['ok' => false, 'error' => 'No autorizado']);
        exit;
    }
    if (!compraPertenece($compra_id, $_SESSION['user_id'])) {
        echo json_encode(['ok' => false, 'error' => 'No autorizado para editar esta compra']);
        exit;
    }
    editarCompra($compra_id, $producto, $precio, $inicial, $cuotas, $fecha_compra, $usuario, $telefono);
    echo json_encode(['ok' => true]);
} catch (Exception $e) {
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
