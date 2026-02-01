<?php
require_once __DIR__ . '/cors.php';
require __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$json = file_get_contents('php://input');
$body = json_decode($json, true) ?? [];

if (!isset($body['negocio_id'])) {
    $body['negocio_id'] = 1;
}

if (!isset($body['nombre'])) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'Falta nombre']);
    exit;
}

$negocio_id = intval($body['negocio_id']);
$nombre = trim($body['nombre']);
error_log("Crear producto: $nombre en negocio $negocio_id");
$codigo_barras = $body['codigo_barras'] ?? null;
$descripcion = $body['descripcion'] ?? null;
$unidad_medida = $body['unidad_medida'] ?? 'unidad';
$tam_paquete = $body['tam_paquete'] ?? 1.0;
$precio_compra = $body['precio_compra'] ?? 0.0;
$precio_venta = $body['precio_venta'] ?? 0.0;
$precio_venta_paquete = $body['precio_venta_paquete'] ?? 0.0;
$precio_venta_mediopaquete = $body['precio_venta_mediopaquete'] ?? 0.0;
$precio_venta_unidad = $body['precio_venta_unidad'] ?? 0.0;
$proveedor = $body['proveedor'] ?? '';
$vende_media = $body['vende_media'] ?? 0;
$bajo_inventario = $body['bajo_inventario'] ?? 0;
$moneda_compra = $body['moneda_compra'] ?? 'USD';
$stock = $body['stock'] ?? 0.0;
$fecha_vencimiento = $body['fecha_vencimiento'] ?? null;

try {
    $id = agregarProducto($negocio_id, $nombre, $descripcion, $unidad_medida, $tam_paquete, $precio_compra, $precio_venta, $proveedor, $precio_venta_paquete, $precio_venta_mediopaquete, $precio_venta_unidad, $moneda_compra, $bajo_inventario, $vende_media, $codigo_barras, $stock, $fecha_vencimiento);
    echo json_encode(['ok' => true, 'id' => $id]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
