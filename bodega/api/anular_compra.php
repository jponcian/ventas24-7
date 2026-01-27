<?php
require_once __DIR__ . '/cors.php';
require __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$json = file_get_contents('php://input');
$data = json_decode($json, true) ?? [];

$compra_id = isset($data['compra_id']) ? intval($data['compra_id']) : 0;

if ($compra_id <= 0) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'ID inválido']);
    exit;
}

try {
    global $db;
    $db->beginTransaction();

    // Obtener items para revertir stock
    $stmt = $db->prepare("SELECT * FROM compras_items WHERE compra_id = ?");
    $stmt->execute([$compra_id]);
    $items = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Obtener el negocio ID para seguridad
    $stmtC = $db->prepare("SELECT negocio_id FROM compras WHERE id = ?");
    $stmtC->execute([$compra_id]);
    $compra = $stmtC->fetch(PDO::FETCH_ASSOC);
    $nid = $compra['negocio_id'];

    foreach ($items as $item) {
        // Restar stock
        $stmtUpd = $db->prepare("UPDATE productos SET stock = stock - ? WHERE id = ? AND negocio_id = ?");
        $stmtUpd->execute([$item['cantidad'], $item['producto_id'], $nid]);
    }

    // Marcar compra como anulada
    $stmtAnular = $db->prepare("UPDATE compras SET estado = 'anulada' WHERE id = ?");
    $stmtAnular->execute([$compra_id]);

    $db->commit();
    echo json_encode(['ok' => true]);
} catch (Exception $e) {
    if ($db->inTransaction()) $db->rollBack();
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
?>
