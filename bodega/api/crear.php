<?php
require_once __DIR__ . '/cors.php';
require __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

// Espera POST con nombre, descripcion, unidad_medida, tam_paquete, precio_compra, precio_venta, proveedor
// Soporte para JSON o POST tradicional
if (empty($_POST)) {
    $json = file_get_contents('php://input');
    $body = json_decode($json, true) ?? [];
} else {
    $body = $_POST;
}

$required = ['nombre'];
foreach ($required as $r) {
    if (!isset($body[$r]) || trim($body[$r]) === '') {
        http_response_code(400);
        echo json_encode(['ok' => false, 'error' => "Falta campo: $r"]);
        exit;
    }
}

$nombre = trim($body['nombre']);
$codigo_barras = isset($body['codigo_barras']) ? trim($body['codigo_barras']) : null;
$descripcion = isset($body['descripcion']) && trim($body['descripcion']) !== '' ? trim($body['descripcion']) : null;
$unidad_medida = isset($body['unidad_medida']) ? trim($body['unidad_medida']) : 'unidad';
$tam_paquete = isset($body['tam_paquete']) && $body['tam_paquete'] !== '' ? floatval($body['tam_paquete']) : null;
$precio_compra = isset($body['precio_compra']) && $body['precio_compra'] !== '' ? floatval($body['precio_compra']) : null;
$moneda_compra = isset($body['moneda_compra']) && in_array($body['moneda_compra'], ['USD', 'BS']) ? $body['moneda_compra'] : 'USD';
$precio_venta = isset($body['precio_venta']) && $body['precio_venta'] !== '' ? floatval($body['precio_venta']) : null;
$precio_venta_paquete = isset($body['precio_venta_paquete']) && $body['precio_venta_paquete'] !== '' ? floatval($body['precio_venta_paquete']) : null;
$precio_venta_mediopaquete = isset($body['precio_venta_mediopaquete']) && strlen($body['precio_venta_mediopaquete']) ? floatval($body['precio_venta_mediopaquete']) : 0.0;
$precio_venta_unidad = isset($body['precio_venta_unidad']) && $body['precio_venta_unidad'] !== '' ? floatval($body['precio_venta_unidad']) : null;
$proveedor = isset($body['proveedor']) ? trim($body['proveedor']) : '';
$vende_media = isset($body['vende_media']) ? intval($body['vende_media']) : 0;
$bajo_inventario = isset($body['bajo_inventario']) ? intval($body['bajo_inventario']) : 0;
$stock = isset($body['stock']) ? floatval($body['stock']) : 0.0;

try {
    $id = agregarProducto($nombre, $descripcion, $unidad_medida, $tam_paquete, $precio_compra, $precio_venta, $proveedor, $precio_venta_paquete, $precio_venta_mediopaquete, $precio_venta_unidad, $moneda_compra, $bajo_inventario, $vende_media, $codigo_barras, $stock);
    echo json_encode(['ok' => true, 'id' => $id]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => 'Error al crear producto']);
}
