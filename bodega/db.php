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
    $db->exec("SET time_zone = '-04:00';");
} catch (Exception $e) {
    error_log('Bodega DB connection error: ' . $e->getMessage());
    header('Content-Type: application/json');
    echo json_encode(['ok' => false, 'error' => 'Error de conexión: ' . $e->getMessage()]);
    exit;
}

// --- Productos ---
     function agregarProducto($negocio_id, $nombre, $descripcion, $unidad_medida, $tam_paquete, $precio_compra, $precio_venta, $proveedor, $precio_venta_paquete = null, $precio_venta_mediopaquete = null, $precio_venta_unidad = null, $moneda_compra = 'USD', $bajo_inventario = 0, $vende_media = 0, $codigo_barras = null, $stock = 0, $fecha_vencimiento = null, $vende_por_peso = 0, $imagen = null, $marca = null, $codigo_interno = null)
{
    global $db;
    
    // Buscar o crear proveedor ID
    $provId = null;
    if ($proveedor) {
        $stmtP = $db->prepare("SELECT id FROM proveedores WHERE nombre = ? AND negocio_id = ?");
        $stmtP->execute([$proveedor, $negocio_id]);
        $p = $stmtP->fetch(PDO::FETCH_ASSOC);
        if ($p) $provId = $p['id'];
        else {
             $stmtIns = $db->prepare("INSERT INTO proveedores (negocio_id, nombre) VALUES (?, ?)");
             $stmtIns->execute([$negocio_id, $proveedor]);
             $provId = $db->lastInsertId();
        }
    }

    // Normalizar precios entrantes para llenar los nuevos campos
    $costo_unitario = $precio_compra;

    $pv_unidad = $precio_venta_unidad ?? 0;
    $pv_paquete = $precio_venta_paquete ?? 0;

    // Si faltan precios, intentar calcularlos
    if ($pv_unidad == 0 && $precio_venta > 0) {
        if ($unidad_medida === 'paquete' && $tam_paquete > 1) $pv_unidad = $precio_venta / $tam_paquete;
        else $pv_unidad = $precio_venta;
    }
    if ($pv_paquete == 0 && $unidad_medida === 'paquete' && $precio_venta > 0) {
        $pv_paquete = $precio_venta;
    }

    $stmt = $db->prepare("INSERT INTO productos (negocio_id, nombre, codigo_interno, codigo_barras, descripcion, unidad_medida, tam_paquete, costo_unitario, precio_venta_unidad, precio_venta_paquete, proveedor_id, moneda_base, bajo_inventario, stock, fecha_vencimiento, vende_por_peso, imagen, marca) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    $stmt->execute([$negocio_id, $nombre, $codigo_interno, $codigo_barras, $descripcion, $unidad_medida, $tam_paquete, $costo_unitario, $pv_unidad, $pv_paquete, $provId, $moneda_compra, $bajo_inventario, $stock, $fecha_vencimiento, $vende_por_peso, $imagen, $marca]);
    return $db->lastInsertId();
}

function editarProducto($id, $negocio_id, $nombre, $descripcion, $unidad_medida, $tam_paquete, $precio_compra, $precio_venta, $proveedor, $precio_venta_paquete = null, $precio_venta_mediopaquete = null, $precio_venta_unidad = null, $moneda_compra = 'USD', $bajo_inventario = 0, $vende_media = 0, $codigo_barras = null, $stock = null, $fecha_vencimiento = null, $vende_por_peso = 0, $imagen = null, $marca = null, $codigo_interno = null)
{
    global $db;
    $legacyVenta = ($unidad_medida === 'paquete' && $precio_venta_paquete !== null) ? $precio_venta_paquete : ($precio_venta_unidad ?? $precio_venta ?? 0);

    // Buscar o crear proveedor ID
    $provId = null;
    if ($proveedor) {
        $stmtP = $db->prepare("SELECT id FROM proveedores WHERE nombre = ? AND negocio_id = ?");
        $stmtP->execute([$proveedor, $negocio_id]);
        $p = $stmtP->fetch(PDO::FETCH_ASSOC);
        if ($p) $provId = $p['id'];
        else {
             $stmtIns = $db->prepare("INSERT INTO proveedores (negocio_id, nombre) VALUES (?, ?)");
             $stmtIns->execute([$negocio_id, $proveedor]);
             $provId = $db->lastInsertId();
        }
    }

    $costo_unitario = $precio_compra;
    
    $pv_unidad = $precio_venta_unidad ?? 0;
    $pv_paquete = $precio_venta_paquete ?? 0;
    
    // Si faltan precios, intentar calcularlos
    if ($pv_unidad == 0 && $precio_venta > 0) {
        if ($unidad_medida === 'paquete' && $tam_paquete > 1) $pv_unidad = $precio_venta / $tam_paquete;
        else $pv_unidad = $precio_venta;
    }
    if ($pv_paquete == 0 && $unidad_medida === 'paquete' && $precio_venta > 0) {
        $pv_paquete = $precio_venta;
    }

    $sql = "UPDATE productos SET nombre = ?, codigo_interno = ?, codigo_barras = ?, descripcion = ?, unidad_medida = ?, tam_paquete = ?, costo_unitario = ?, precio_venta_unidad = ?, precio_venta_paquete = ?, proveedor_id = ?, moneda_base = ?, bajo_inventario = ?, vende_media = ?, fecha_vencimiento = ?, vende_por_peso = ?, imagen = ?, marca = ?";
    $params = [$nombre, $codigo_interno, $codigo_barras, $descripcion, $unidad_medida, $tam_paquete, $costo_unitario, $pv_unidad, $pv_paquete, $provId, $moneda_compra, $bajo_inventario, $vende_media, $fecha_vencimiento, $vende_por_peso, $imagen, $marca];

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
        $stmt = $db->prepare("
            SELECT p.*, pr.nombre as proveedor_nombre 
            FROM productos p 
            LEFT JOIN proveedores pr ON p.proveedor_id = pr.id
            WHERE p.negocio_id = ? 
            ORDER BY p.nombre ASC
        ");
        $stmt->execute([$negocio_id]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    $like = '%' . $q . '%';
    // Nota: proveedor es nombre, pero ahora tenemos proveedor_id. Para buscar por nombre de proveedor necesitaríamos un JOIN.
    // Mantenemos la estructura simple por ahora, buscando en las columnas de texto de producto.
    $stmt = $db->prepare("
        SELECT p.*, pr.nombre as proveedor_nombre 
        FROM productos p 
        LEFT JOIN proveedores pr ON p.proveedor_id = pr.id
        WHERE p.negocio_id = ? AND (p.nombre LIKE ? OR p.codigo_barras LIKE ? OR p.codigo_interno LIKE ? OR p.descripcion LIKE ? OR pr.nombre LIKE ? OR p.unidad_medida LIKE ?) 
        ORDER BY p.nombre ASC
    ");
    $stmt->execute([$negocio_id, $like, $q, $like, $like, $like, $like]);
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
function registrarVenta($negocio_id, $total_bs, $total_usd, $tasa, $detalles, $metodo_pago_id = null, $cliente_id = null, $referencia = null)
{
    global $db;
    try {
        $db->beginTransaction();

        // 1. Insertar la venta
        $stmt = $db->prepare("INSERT INTO ventas (negocio_id, total_bs, total_usd, tasa, metodo_pago_id, cliente_id, referencia) VALUES (?, ?, ?, ?, ?, ?, ?)");
        $stmt->execute([$negocio_id, $total_bs, $total_usd, $tasa, $metodo_pago_id, $cliente_id, $referencia]);
        $venta_id = $db->lastInsertId();

        // 2. Procesar detalles y stock
        $stmtDetalle = $db->prepare("INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, es_paquete, precio_unitario_bs) VALUES (?, ?, ?, ?, ?)");
        $stmtUpdateStock = $db->prepare("UPDATE productos SET stock = stock - ? WHERE id = ? AND negocio_id = ?");

        foreach ($detalles as $item) {
            $multiplicador = isset($item['multiplicador']) ? floatval($item['multiplicador']) : 1.0;
            $esPaquete = $multiplicador > 1 ? 1 : 0;
            $cantidadVendida = floatval($item['cantidad']);
            $precioUnitarioBs = floatval($item['precio_bs'] ?? 0);
            
            $stmtDetalle->execute([$venta_id, $item['id'], $cantidadVendida, $esPaquete, $precioUnitarioBs]);
            $stmtUpdateStock->execute([$cantidadVendida * $multiplicador, $item['id'], $negocio_id]);
        }

        // 3. Si el método de pago es 'Crédito', registrar en fiados
        if ($metodo_pago_id && $cliente_id) {
            $stmtMetodo = $db->prepare("SELECT nombre FROM metodos_pago WHERE id = ?");
            $stmtMetodo->execute([$metodo_pago_id]);
            $metodoNombre = $stmtMetodo->fetchColumn();

            if ($metodoNombre === 'Crédito') {
                $stmtFiado = $db->prepare("INSERT INTO fiados (negocio_id, cliente_id, total_bs, total_usd, saldo_pendiente, tasa, estado) VALUES (?, ?, ?, ?, ?, ?, 'pendiente')");
                $stmtFiado->execute([$negocio_id, $cliente_id, $total_bs, $total_usd, $total_usd, $tasa]);
                $fiado_id = $db->lastInsertId();

                // Registrar detalles del fiado
                $stmtFiadoDet = $db->prepare("INSERT INTO fiado_detalles (fiado_id, producto_id, cantidad, precio_unitario_bs, precio_unitario_usd, subtotal_bs, subtotal_usd) VALUES (?, ?, ?, ?, ?, ?, ?)");
                foreach ($detalles as $item) {
                    $cantidad = floatval($item['cantidad']);
                    $precio_bs = floatval($item['precio_bs'] ?? 0);
                    $precio_usd = $tasa > 0 ? $precio_bs / $tasa : 0;
                    $stmtFiadoDet->execute([$fiado_id, $item['id'], $cantidad, $precio_bs, $precio_usd, $cantidad * $precio_bs, $cantidad * $precio_usd]);
                }

                // Actualizar deuda total del cliente
                $stmtUpdateCliente = $db->prepare("UPDATE clientes SET deuda_total = deuda_total + ? WHERE id = ?");
                $stmtUpdateCliente->execute([$total_usd, $cliente_id]);
            }
        }

        $db->commit();
        return true;
    } catch (Exception $e) {
        if ($db->inTransaction()) $db->rollBack();
        error_log("Error in registrarVenta: " . $e->getMessage());
        return false;
    }
}

function obtenerVentaDetalle($venta_id)
{
    global $db;
    $stmt = $db->prepare("
        SELECT dv.*, p.nombre, p.tam_paquete, p.unidad_medida, v.tasa
        FROM detalle_ventas dv
        JOIN productos p ON dv.producto_id = p.id
        JOIN ventas v ON dv.venta_id = v.id
        WHERE dv.venta_id = ?
    ");
    $stmt->execute([$venta_id]);
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}
