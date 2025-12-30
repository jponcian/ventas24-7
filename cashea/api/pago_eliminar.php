<?php
require '../db.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['ok' => false, 'error' => 'Método no permitido']);
    exit;
}

$json = json_decode(file_get_contents('php://input'), true);
$compra_id = isset($json['compra_id']) ? intval($json['compra_id']) : 0;
$cuota_num = isset($json['cuota_num']) ? intval($json['cuota_num']) : 0;

if ($compra_id <= 0 || $cuota_num <= 0) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'Datos incompletos']);
    exit;
}

try {
    if (!isset($_SESSION['user_id'])) {
        http_response_code(401);
        echo json_encode(['ok' => false, 'error' => 'No autorizado']);
        exit;
    }
    if (!compraPertenece($compra_id, $_SESSION['user_id'])) {
        http_response_code(403);
        echo json_encode(['ok' => false, 'error' => 'No autorizado para eliminar pago en esta compra']);
        exit;
    }
    eliminarPago($compra_id, $cuota_num);
    echo json_encode(['ok' => true]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
