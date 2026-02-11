<?php
require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$json = file_get_contents('php://input');
$data = json_decode($json, true) ?? [];

$venta_id = isset($data['venta_id']) ? intval($data['venta_id']) : 0;

if ($venta_id <= 0) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'ID inválido']);
    exit;
}

try {
    global $db;
    
    // Asegurar columna estado
    try {
        $db->exec("ALTER TABLE ventas ADD COLUMN estado VARCHAR(20) DEFAULT 'completada'");
    } catch(Exception $e) {
        // Probablemente ya existe
    }

    $db->beginTransaction();

    // 1. Obtener datos de la venta
    $stmt = $db->prepare("
        SELECT v.*, m.nombre as metodo_nombre
        FROM ventas v
        LEFT JOIN metodos_pago m ON v.metodo_pago_id = m.id
        WHERE v.id = ?
    ");
    $stmt->execute([$venta_id]);
    $venta = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$venta) throw new Exception("La venta no existe");
    if (isset($venta['estado']) && $venta['estado'] === 'anulada') throw new Exception("La venta ya está anulada");

    $nid = $venta['negocio_id'];

    // 2. Revertir stock
    $stmtDet = $db->prepare("
        SELECT dv.*, p.tam_paquete 
        FROM detalle_ventas dv
        JOIN productos p ON dv.producto_id = p.id
        WHERE dv.venta_id = ?
    ");
    $stmtDet->execute([$venta_id]);
    $detalles = $stmtDet->fetchAll(PDO::FETCH_ASSOC);

    foreach ($detalles as $item) {
        $qty = floatval($item['cantidad']);
        $esPaquete = intval($item['es_paquete']);
        $multiplicador = ($esPaquete === 1) ? floatval($item['tam_paquete']) : 1.0;
        
        $stmtUpd = $db->prepare("UPDATE productos SET stock = stock + ? WHERE id = ? AND negocio_id = ?");
        $stmtUpd->execute([$qty * $multiplicador, $item['producto_id'], $nid]);
    }

    // 3. Revertir deuda si era crédito
    if ($venta['metodo_nombre'] === 'Crédito' && $venta['cliente_id']) {
        $stmtUpdateCliente = $db->prepare("UPDATE clientes SET deuda_total = deuda_total - ? WHERE id = ?");
        $stmtUpdateCliente->execute([floatval($venta['total_usd']), $venta['cliente_id']]);
        
        // Intentar anular el fiado relacionado
        $stmtAnularFiado = $db->prepare("UPDATE fiados SET estado = 'anulado' WHERE cliente_id = ? AND total_usd = ? AND ABS(TIMESTAMPDIFF(MINUTE, fecha, ?)) < 5 AND estado != 'anulado' LIMIT 1");
        $stmtAnularFiado->execute([$venta['cliente_id'], $venta['total_usd'], $venta['fecha']]);
    }

    // 4. Marcar como anulada
    $stmtAnular = $db->prepare("UPDATE ventas SET estado = 'anulada' WHERE id = ?");
    $stmtAnular->execute([$venta_id]);

    $db->commit();
    echo json_encode(['ok' => true]);
} catch (Exception $e) {
    if ($db->inTransaction()) $db->rollBack();
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
