<?php
// Zona horaria global para todo el sistema
date_default_timezone_set('America/Caracas');
// db.php - Conexión PDO y funciones para el módulo bodega
//
// Esta versión intenta cargar una configuración externa `config.php` ubicada en
// el mismo directorio. Si no existe, usa valores por defecto.
// Para separar credenciales del repositorio, copia `config.sample.php` a `config.php`
// y ajusta los valores.

// Cargar configuración si existe
$configPath = __DIR__ . '/config.php';
if (file_exists($configPath)) {
    require $configPath;
}

// Valores por defecto (mantener compatibilidad si no se define en config.php)
$host = isset($host) ? $host : 'localhost';
$dbname = isset($dbname) ? $dbname : 'javier_ponciano_4';
$user = isset($user) ? $user : 'ponciano';
$pass = isset($pass) ? $pass : 'Prueba016.';

try {
    // Usar utf8mb4 para mejor compatibilidad con emojis y multibyte
    $db = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $user, $pass);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (Exception $e) {
    error_log('Bodega DB connection error: ' . $e->getMessage());
    header('Content-Type: application/json');
    echo json_encode(['ok' => false, 'error' => 'Error de conexión a la base de datos']);
    // exit; // Temporarily commented out for debugging
}


// --- Productos ---
function agregarProducto($nombre, $descripcion, $unidad_medida, $tam_paquete, $precio_compra, $precio_venta, $proveedor, $precio_venta_paquete = null, $precio_venta_mediopaquete = null, $precio_venta_unidad = null, $moneda_compra = 'USD', $bajo_inventario = 0, $vende_media = 0, $codigo_barras = null, $stock = 0)
{
    global $db;
    $legacyVenta = $precio_venta;
    if ($unidad_medida === 'paquete' && $precio_venta_paquete !== null) {
        $legacyVenta = $precio_venta_paquete;
    } elseif ($precio_venta_unidad !== null) {
        $legacyVenta = $precio_venta_unidad;
    }
    // Ensure legacyVenta is not null if the DB column is NOT NULL
    if ($legacyVenta === null) {
        $legacyVenta = 0.0;
    }
    $stmt = $db->prepare("INSERT INTO productos (nombre, codigo_barras, descripcion, unidad_medida, tam_paquete, precio_compra, precio_venta, precio_venta_paquete, precio_venta_mediopaquete, precio_venta_unidad, proveedor, moneda_compra, bajo_inventario, stock) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    $stmt->execute([$nombre, $codigo_barras, $descripcion, $unidad_medida, $tam_paquete, $precio_compra, $legacyVenta, $precio_venta_paquete, $precio_venta_mediopaquete, $precio_venta_unidad, $proveedor, $moneda_compra, $bajo_inventario, $stock]);
    return $db->lastInsertId();
}

function editarProducto($id, $nombre, $descripcion, $unidad_medida, $tam_paquete, $precio_compra, $precio_venta, $proveedor, $precio_venta_paquete = null, $precio_venta_mediopaquete = null, $precio_venta_unidad = null, $moneda_compra = 'USD', $bajo_inventario = 0, $vende_media = 0, $codigo_barras = null, $stock = null)
{
    global $db;
    $legacyVenta = $precio_venta;
    if ($unidad_medida === 'paquete' && $precio_venta_paquete !== null) {
        $legacyVenta = $precio_venta_paquete;
    } elseif ($precio_venta_unidad !== null) {
        $legacyVenta = $precio_venta_unidad;
    }
    // Ensure legacyVenta is not null if the DB column is NOT NULL
    if ($legacyVenta === null) {
        $legacyVenta = 0.0;
    }

    $sql = "UPDATE productos SET nombre = ?, codigo_barras = ?, descripcion = ?, unidad_medida = ?, tam_paquete = ?, precio_compra = ?, precio_venta = ?, precio_venta_paquete = ?, precio_venta_mediopaquete = ?, precio_venta_unidad = ?, proveedor = ?, moneda_compra = ?, bajo_inventario = ?";
    $params = [$nombre, $codigo_barras, $descripcion, $unidad_medida, $tam_paquete, $precio_compra, $legacyVenta, $precio_venta_paquete, $precio_venta_mediopaquete, $precio_venta_unidad, $proveedor, $moneda_compra, $bajo_inventario];

    if ($stock !== null) {
        $sql .= ", stock = ?";
        $params[] = $stock;
    }

    $sql .= " WHERE id = ?";
    $params[] = $id;

    $stmt = $db->prepare($sql);
    return $stmt->execute($params);
}

function eliminarProducto($id)
{
    global $db;
    $stmt = $db->prepare("DELETE FROM productos WHERE id = ?");
    return $stmt->execute([$id]);
}

function obtenerProductos($q = null)
{
    global $db;
    if ($q === null || $q === '') {
        $stmt = $db->query("SELECT * FROM productos ORDER BY nombre ASC");
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    $like = '%' . $q . '%';
    $stmt = $db->prepare("SELECT * FROM productos WHERE nombre LIKE ? OR codigo_barras = ? OR descripcion LIKE ? OR proveedor LIKE ? OR unidad_medida LIKE ? OR CAST(precio_compra AS CHAR) LIKE ? OR CAST(precio_venta AS CHAR) LIKE ? ORDER BY nombre ASC");
    $stmt->execute([$like, $q, $like, $like, $like, $like, $like]);
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function getProducto($id)
{
    global $db;
    $stmt = $db->prepare("SELECT * FROM productos WHERE id = ? LIMIT 1");
    $stmt->execute([$id]);
    return $stmt->fetch(PDO::FETCH_ASSOC);
}

// --- Usuarios (utilidades compartidas con otros módulos) ---
function crearUsuario($username, $password)
{
    global $db;
    $hash = password_hash($password, PASSWORD_DEFAULT);
    $stmt = $db->prepare("INSERT INTO users (username, password_hash) VALUES (?, ?)");
    $stmt->execute([$username, $hash]);
    return $db->lastInsertId();
}

function encontrarUsuarioPorUsername($username)
{
    global $db;
    $stmt = $db->prepare("SELECT * FROM users WHERE username = ? LIMIT 1");
    $stmt->execute([$username]);
    return $stmt->fetch(PDO::FETCH_ASSOC);
}

// Eliminar pago (si se comparte la misma base de datos con módulos de pagos)
function eliminarPago($compra_id, $cuota_num)
{
    global $db;
    return $stmt->execute([$compra_id, $cuota_num]);
}

// --- Ventas ---
function registrarVenta($total_bs, $total_usd, $tasa, $detalles)
{
    global $db;
    try {
        $db->beginTransaction();

        $stmt = $db->prepare("INSERT INTO ventas (total_bs, total_usd, tasa) VALUES (?, ?, ?)");
        $stmt->execute([$total_bs, $total_usd, $tasa]);
        $venta_id = $db->lastInsertId();

        $stmtDetalle = $db->prepare("INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario_bs) VALUES (?, ?, ?, ?)");
        $stmtUpdateStock = $db->prepare("UPDATE productos SET stock = stock - ? WHERE id = ?");

        foreach ($detalles as $item) {
            $stmtDetalle->execute([
                $venta_id,
                $item['id'],
                $item['cantidad'],
                $item['precio_bs']
            ]);

            $stmtUpdateStock->execute([
                $item['cantidad'],
                $item['id']
            ]);
        }

        $db->commit();
        return true;
    } catch (Exception $e) {
        if ($db->inTransaction()) {
            $db->rollBack();
        }
        error_log("Error en registrarVenta: " . $e->getMessage());
        return false;
    }
}