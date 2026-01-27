<?php
require_once __DIR__ . '/cors.php';
require __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$json = file_get_contents('php://input');
$data = json_decode($json, true) ?? [];

$nid = isset($data['negocio_id']) ? intval($data['negocio_id']) : 0;
$pid = isset($data['producto_id']) ? intval($data['producto_id']) : 0;
$qty = isset($data['cantidad']) ? floatval($data['cantidad']) : 0;
$cost = isset($data['costo_nuevo']) ? floatval($data['costo_nuevo']) : null;

if ($nid <= 0 || $pid <= 0 || $qty <= 0) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'Datos inválidos']);
    exit;
}

try {
    global $db;
    
    // Iniciar transacción
    $db->beginTransaction();

    // 1. Insertar en tabla de compras
    $stmtCompra = $db->prepare("INSERT INTO compras (negocio_id, producto_id, cantidad, costo_unitario) VALUES (?, ?, ?, ?)");
    
    // Si no se provee un costo nuevo, obtener el actual del producto para registrarlo
    $costoRegistrar = $cost;
    if ($cost === null) {
        $stmtProd = $db->prepare("SELECT precio_compra FROM productos WHERE id = ?");
        $stmtProd->execute([$pid]);
        $prod = $stmtProd->fetch(PDO::FETCH_ASSOC);
        $costoRegistrar = $prod ? $prod['precio_compra'] : 0;
    }
    
    $stmtCompra->execute([$nid, $pid, $qty, $costoRegistrar]);

    // 2. Actualizar stock
    $params = [$qty, $pid, $nid];
    // Si hay costo nuevo explícito, actualizarlo en producto
    if ($cost !== null && $cost > 0) {
        $sql = "UPDATE productos SET stock = stock + ?, precio_compra = ? WHERE id = ? AND negocio_id = ?";
        $params = [$qty, $cost, $pid, $nid];
    } else {
        $sql = "UPDATE productos SET stock = stock + ? WHERE id = ? AND negocio_id = ?";
    }
    
    $stmt = $db->prepare($sql);
    $res = $stmt->execute($params);
    
    $db->commit();
    echo json_encode(['ok' => true]);

} catch (Exception $e) {
    if ($db->inTransaction()) $db->rollBack();
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
?>
