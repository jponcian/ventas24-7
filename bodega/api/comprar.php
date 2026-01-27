<?php
require_once __DIR__ . '/cors.php';
require __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$json = file_get_contents('php://input');
$data = json_decode($json, true) ?? [];

$nid = isset($data['negocio_id']) ? intval($data['negocio_id']) : 0;
$items = isset($data['items']) ? $data['items'] : [];

if ($nid <= 0 || empty($items)) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'Datos inválidos o lista de productos vacía']);
    exit;
}

try {
    global $db;
    $db->beginTransaction();

    // 1. Crear el maestro de la compra
    $stmtMaestro = $db->prepare("INSERT INTO compras (negocio_id, fecha) VALUES (?, NOW())");
    $stmtMaestro->execute([$nid]);
    $compraId = $db->lastInsertId();

    $totalCompra = 0;

    foreach ($items as $item) {
        $pid = isset($item['producto_id']) ? intval($item['producto_id']) : 0;
        $qty = isset($item['cantidad']) ? floatval($item['cantidad']) : 0;
        $cost = isset($item['costo_nuevo']) ? floatval($item['costo_nuevo']) : null;

        if ($pid <= 0 || $qty <= 0) continue;

        // Si no se provee un costo nuevo, obtener el actual del producto
        $costoRegistrar = $cost;
        if ($cost === null) {
            $stmtProd = $db->prepare("SELECT precio_compra FROM productos WHERE id = ?");
            $stmtProd->execute([$pid]);
            $prod = $stmtProd->fetch(PDO::FETCH_ASSOC);
            $costoRegistrar = $prod ? $prod['precio_compra'] : 0;
        }

        // 2. Insertar en detalle
        $stmtDetalle = $db->prepare("INSERT INTO compras_items (compra_id, producto_id, cantidad, costo_unitario) VALUES (?, ?, ?, ?)");
        $stmtDetalle->execute([$compraId, $pid, $qty, $costoRegistrar]);

        $totalCompra += ($qty * $costoRegistrar);

        // 3. Actualizar stock y precio en tabla productos
        if ($cost !== null && $cost > 0) {
            $sql = "UPDATE productos SET stock = stock + ?, precio_compra = ? WHERE id = ? AND negocio_id = ?";
            $params = [$qty, $cost, $pid, $nid];
        } else {
            $sql = "UPDATE productos SET stock = stock + ? WHERE id = ? AND negocio_id = ?";
            $params = [$qty, $pid, $nid];
        }
        $stmtUpd = $db->prepare($sql);
        $stmtUpd->execute($params);
    }

    // 4. Actualizar el total en el maestro
    $stmtTotal = $db->prepare("UPDATE compras SET total = ? WHERE id = ?");
    $stmtTotal->execute([$totalCompra, $compraId]);

    $db->commit();
    echo json_encode(['ok' => true, 'compra_id' => $compraId]);

} catch (Exception $e) {
    if ($db->inTransaction()) $db->rollBack();
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
?>
