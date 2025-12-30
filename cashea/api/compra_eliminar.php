<?php
require '../db.php';
header('Content-Type: application/json');
$input = json_decode(file_get_contents('php://input'), true);
if (!$input) {
    echo json_encode(['ok' => false, 'error' => 'Entrada inválida']);
    exit;
}
$compra_id = isset($input['compra_id']) ? intval($input['compra_id']) : 0;
if ($compra_id <= 0) {
    echo json_encode(['ok' => false, 'error' => 'compra_id inválido']);
    exit;
}
try {
    if (!isset($_SESSION['user_id'])) {
        echo json_encode(['ok' => false, 'error' => 'No autorizado']);
        exit;
    }
    if (!compraPertenece($compra_id, $_SESSION['user_id'])) {
        echo json_encode(['ok' => false, 'error' => 'No autorizado para eliminar esta compra']);
        exit;
    }
    // Eliminar pagos asociados primero (integridad)
    $db->prepare("DELETE FROM pagos WHERE compra_id = ?")->execute([$compra_id]);
    eliminarCompra($compra_id);
    echo json_encode(['ok' => true]);
} catch (Exception $e) {
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
