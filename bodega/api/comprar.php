<?php
require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$json = file_get_contents('php://input');
$data = json_decode($json, true) ?? [];

$nid = isset($data['negocio_id']) ? intval($data['negocio_id']) : 0;
$items = isset($data['items']) ? $data['items'] : [];
$provId = isset($data['proveedor_id']) ? intval($data['proveedor_id']) : null;
$moneda = isset($data['moneda']) ? $data['moneda'] : 'USD';
$tasa = isset($data['tasa']) ? floatval($data['tasa']) : 1.0;

if ($nid <= 0 || empty($items)) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'Datos inválidos o lista de productos vacía']);
    exit;
}

try {
    global $db;
    $db->beginTransaction();

    // 1. Crear el maestro de la compra con metadatos extendidos
    $stmtMaestro = $db->prepare("INSERT INTO compras (negocio_id, proveedor_id, moneda, tasa, fecha) VALUES (?, ?, ?, ?, NOW())");
    $stmtMaestro->execute([$nid, $provId, $moneda, $tasa]);
    $compraId = $db->lastInsertId();

    $totalCompra = 0;

    foreach ($items as $item) {
        $pid = isset($item['producto_id']) ? intval($item['producto_id']) : 0;
        $qty = isset($item['cantidad']) ? floatval($item['cantidad']) : 0;
        
        // El costo nuevo viene como referencia
        $costRaw = isset($item['costo_nuevo']) ? floatval($item['costo_nuevo']) : null;
        $suggestedPrice = isset($item['precio_venta_nuevo']) ? floatval($item['precio_venta_nuevo']) : null;

        if ($pid <= 0 || $qty <= 0) continue;

        // Calcular costo estandarizado en USD para el registro maestro
        // Si la compra fue en BS, convertir a USD.
        // Si fue en USD, usar directo.
        $costoStandard = 0;
        if ($costRaw !== null) {
            if ($moneda === 'BS') {
                $costoStandard = ($tasa > 0) ? ($costRaw / $tasa) : 0;
            } else {
                $costoStandard = $costRaw;
            }
        } else {
             // Fallback al precio actual
            $stmtProd = $db->prepare("SELECT costo_unitario FROM productos WHERE id = ?");
            $stmtProd->execute([$pid]);
            $prod = $stmtProd->fetch(PDO::FETCH_ASSOC);
            $costoStandard = $prod ? $prod['costo_unitario'] : 0;
        }

        // 2. Insertar en detalle con info extendida
        $stmtDetalle = $db->prepare("INSERT INTO compras_items (compra_id, producto_id, cantidad, costo_unitario, costo_origen, moneda_origen) VALUES (?, ?, ?, ?, ?, ?)");
        $stmtDetalle->execute([$compraId, $pid, $qty, $costoStandard, $costRaw, $moneda]);

        // Totalizar en la moneda base del registro (usualmente USD para reportes internos)
        // Ojo: si la tabla `compras` guarda el total en la moneda declarada en `moneda`, entonces sumamos $costRaw.
        // Vamos a guardar el total en la moneda que se especifica en la cabecera para consistencia visual.
        $totalCompra += ($qty * ($costRaw ?? 0));

        // 3. Actualizar stock y precios en tabla productos
        $sqlUpd = "UPDATE productos SET stock = stock + ?";
        $paramsUpd = [$qty];

        // Si tenemos un costo válido, actualizamos el costo en USD (base del sistema)
        if ($costoStandard > 0) {
            $sqlUpd .= ", costo_unitario = ?";
            $paramsUpd[] = $costoStandard;
        }
        
        // Si el usuario aceptó sugerencia de precio de venta, actualizamos el precio unitario
        // (La lógica del app ya manda el precio unitario sugerido)
        if ($suggestedPrice !== null && $suggestedPrice > 0) {
            $sqlUpd .= ", precio_venta_unidad = ?";
            $paramsUpd[] = $suggestedPrice;
        }

        $sqlUpd .= " WHERE id = ? AND negocio_id = ?";
        $paramsUpd[] = $pid;
        $paramsUpd[] = $nid;

        $stmtUpd = $db->prepare($sqlUpd);
        $stmtUpd->execute($paramsUpd);
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
