<?php
require_once __DIR__ . '/cors.php';
require __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$nid = isset($_GET['negocio_id']) ? intval($_GET['negocio_id']) : 0;
$limit = isset($_GET['limit']) ? intval($_GET['limit']) : 50;

if ($nid <= 0) {
    echo json_encode(['ok' => false, 'error' => 'Negocio ID faltante']);
    exit;
}

try {
    $stmt = $db->prepare("
        SELECT c.*, p.nombre as proveedor_nombre 
        FROM compras c 
        LEFT JOIN proveedores p ON c.proveedor_id = p.id 
        WHERE c.negocio_id = ? 
        ORDER BY c.fecha DESC 
        LIMIT $limit
    ");
    $stmt->execute([$nid]);
    $compras = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Obtener detalles básicos de cada compra (o cargarlos on demand, pero aquí enviamos resumen)
    foreach ($compras as &$c) {
        $stmtD = $db->prepare("SELECT COUNT(*) as items_count FROM compras_items WHERE compra_id = ?");
        $stmtD->execute([$c['id']]);
        $row = $stmtD->fetch();
        $c['items_count'] = $row['items_count'];
    }

    echo json_encode(['ok' => true, 'compras' => $compras]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
?>
