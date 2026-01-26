<?php
// Zona horaria global
date_default_timezone_set('America/Caracas');

$configPath = __DIR__ . '/config.php';
if (file_exists($configPath)) {
    require $configPath;
}

$host = isset($host) ? $host : 'localhost';
$dbname = isset($dbname) ? $dbname : 'javier_ponciano_4';
$user = isset($user) ? $user : 'ponciano';
$pass = isset($pass) ? $pass : 'Prueba016.';

try {
    $db = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $user, $pass);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (Exception $e) {
    error_log('Bodega DB connection error: ' . $e->getMessage());
    header('Content-Type: application/json');
    echo json_encode(['ok' => false, 'error' => 'Error de conexión']);
    exit;
}

// --- Productos ---
function agregarProducto($negocio_id, $nombre, $descripcion, $unidad_medida, $tam_paquete, $precio_compra, $precio_venta, $proveedor, $precio_venta_paquete = null, $precio_venta_mediopaquete = null, $precio_venta_unidad = null, $moneda_compra = 'USD', $bajo_inventario = 0, $vende_media = 0, $codigo_barras = null, $stock = 0)
{
    global $db;
    $legacyVenta = ($unidad_medida === 'paquete' && $precio_venta_paquete !== null) ? $precio_venta_paquete : ($precio_venta_unidad ?? $precio_venta ?? 0);
    
    $stmt = $db->prepare("INSERT INTO productos (negocio_id, nombre, codigo_barras, descripcion, unidad_medida, tam_paquete, precio_compra, precio_venta, precio_venta_paquete, precio_venta_mediopaquete, precio_venta_unidad, proveedor, moneda_compra, bajo_inventario, stock) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    $stmt->execute([$negocio_id, $nombre, $codigo_barras, $descripcion, $unidad_medida, $tam_paquete, $precio_compra, $legacyVenta, $precio_venta_paquete, $precio_venta_mediopaquete, $precio_venta_unidad, $proveedor, $moneda_compra, $bajo_inventario, $stock]);
    return $db->lastInsertId();
}

function editarProducto($id, $negocio_id, $nombre, $descripcion, $unidad_medida, $tam_paquete, $precio_compra, $precio_venta, $proveedor, $precio_venta_paquete = null, $precio_venta_mediopaquete = null, $precio_venta_unidad = null, $moneda_compra = 'USD', $bajo_inventario = 0, $vende_media = 0, $codigo_barras = null, $stock = null)
{
    global $db;
    $legacyVenta = ($unidad_medida === 'paquete' && $precio_venta_paquete !== null) ? $precio_venta_paquete : ($precio_venta_unidad ?? $precio_venta ?? 0);

    $sql = "UPDATE productos SET nombre = ?, codigo_barras = ?, descripcion = ?, unidad_medida = ?, tam_paquete = ?, precio_compra = ?, precio_venta = ?, precio_venta_paquete = ?, precio_venta_mediopaquete = ?, precio_venta_unidad = ?, proveedor = ?, moneda_compra = ?, bajo_inventario = ?";
    $params = [$nombre, $codigo_barras, $descripcion, $unidad_medida, $tam_paquete, $precio_compra, $legacyVenta, $precio_venta_paquete, $precio_venta_mediopaquete, $precio_venta_unidad, $proveedor, $moneda_compra, $bajo_inventario];

    if ($stock !== null) {
        $sql .= ", stock = ?";
        $params[] = $stock;
    }

    $sql .= " WHERE id = ? AND negocio_id = ?";
    $params[] = $id;
    $params[] = $negocio_id;

    $stmt = $db->prepare($sql);
    return $stmt->execute($params);
}

function eliminarProducto($id, $negocio_id)
{
    global $db;
    $stmt = $db->prepare("DELETE FROM productos WHERE id = ? AND negocio_id = ?");
    return $stmt->execute([$id, $negocio_id]);
}

function obtenerProductos($negocio_id, $q = null)
{
    global $db;
    if ($q === null || $q === '') {
        $stmt = $db->prepare("SELECT * FROM productos WHERE negocio_id = ? ORDER BY nombre ASC");
        $stmt->execute([$negocio_id]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    $like = '%' . $q . '%';
    $stmt = $db->prepare("SELECT * FROM productos WHERE negocio_id = ? AND (nombre LIKE ? OR codigo_barras = ? OR descripcion LIKE ? OR proveedor LIKE ? OR unidad_medida LIKE ?) ORDER BY nombre ASC");
    $stmt->execute([$negocio_id, $like, $q, $like, $like, $like]);
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function getProducto($id, $negocio_id)
{
    global $db;
    $stmt = $db->prepare("SELECT * FROM productos WHERE id = ? AND negocio_id = ? LIMIT 1");
    $stmt->execute([$id, $negocio_id]);
    return $stmt->fetch(PDO::FETCH_ASSOC);
}

// --- Ventas ---
function registrarVenta($negocio_id, $total_bs, $total_usd, $tasa, $detalles)
{
    global $db;
    try {
        $db->beginTransaction();

        $stmt = $db->prepare("INSERT INTO ventas (negocio_id, total_bs, total_usd, tasa) VALUES (?, ?, ?, ?)");
        $stmt->execute([$negocio_id, $total_bs, $total_usd, $tasa]);
        $venta_id = $db->lastInsertId();

        $stmtDetalle = $db->prepare("INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario_bs) VALUES (?, ?, ?, ?)");
        $stmtUpdateStock = $db->prepare("UPDATE productos SET stock = stock - ? WHERE id = ? AND negocio_id = ?");

        foreach ($detalles as $item) {
            $stmtDetalle->execute([$venta_id, $item['id'], $item['cantidad'], $item['precio_bs']]);
            $stmtUpdateStock->execute([$item['cantidad'], $item['id'], $negocio_id]);
        }

        $db->commit();
        return true;
    } catch (Exception $e) {
        if ($db->inTransaction()) $db->rollBack();
        return false;
    }
}