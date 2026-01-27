<?php
// Conexión y funciones para la base de datos MySQL
// Esta versión intenta cargar una configuración externa `config.php` ubicada en
// el mismo directorio. Si no existe, usa valores por defecto (como antes).
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
    $db = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $user, $pass);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (Exception $e) {
    // Exponer un mensaje mínimo y registrar el error
    error_log('DB connection error: ' . $e->getMessage());
    header('Content-Type: application/json');
    echo json_encode(['ok' => false, 'error' => 'Error de conexión a la base de datos']);
    exit;
}

// Iniciar sesión si no está iniciada (usado para owner_id en compras)
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

function agregarCompra($producto, $precio, $inicial, $cuotas, $fecha_compra, $usuario, $telefono = null)
{
    global $db;
    $stmt = $db->prepare("INSERT INTO cashea_compras (producto, precio, inicial, cuotas, fecha_compra, usuario, telefono, owner_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
    $owner_id = isset($_SESSION['user_id']) ? $_SESSION['user_id'] : null;
    $stmt->execute([$producto, $precio, $inicial, $cuotas, $fecha_compra, $usuario, $telefono, $owner_id]);
}

function eliminarCompra($compra_id)
{
    global $db;
    $stmt = $db->prepare("DELETE FROM cashea_compras WHERE id = ?");
    $stmt->execute([$compra_id]);
}

function editarCompra($compra_id, $producto, $precio, $inicial, $cuotas, $fecha_compra, $usuario, $telefono = null)
{
    global $db;
    $stmt = $db->prepare("UPDATE cashea_compras SET producto = ?, precio = ?, inicial = ?, cuotas = ?, fecha_compra = ?, usuario = ?, telefono = ? WHERE id = ?");
    $stmt->execute([$producto, $precio, $inicial, $cuotas, $fecha_compra, $usuario, $telefono, $compra_id]);
}

function obtenerCompras($owner_id = null)
{
    global $db;
    if ($owner_id === null) {
        $stmt = $db->query("SELECT * FROM cashea_compras");
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    $stmt = $db->prepare("SELECT * FROM cashea_compras WHERE owner_id = ?");
    $stmt->execute([$owner_id]);
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function registrarPago($compra_id, $cuota_num, $fecha_pago, $monto)
{
    global $db;
    $stmt = $db->prepare("INSERT INTO cashea_pagos (compra_id, cuota_num, fecha_pago, monto) VALUES (?, ?, ?, ?)");
    $stmt->execute([$compra_id, $cuota_num, $fecha_pago, $monto]);
}

function obtenerPagos()
{
    global $db;
    $stmt = $db->query("SELECT * FROM cashea_pagos");
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function obtenerPagosPorOwner($owner_id = null)
{
    global $db;
    if ($owner_id === null) return obtenerPagos();
    $stmt = $db->prepare("SELECT cashea_pagos.* FROM cashea_pagos JOIN cashea_compras ON cashea_pagos.compra_id = cashea_compras.id WHERE cashea_compras.owner_id = ?");
    $stmt->execute([$owner_id]);
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function compraPertenece($compra_id, $owner_id)
{
    global $db;
    $stmt = $db->prepare("SELECT owner_id FROM cashea_compras WHERE id = ?");
    $stmt->execute([$compra_id]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$row) return false;
    return intval($row['owner_id']) === intval($owner_id);
}

// --- Usuarios ---
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

function eliminarPago($compra_id, $cuota_num)
{
    global $db;
    $stmt = $db->prepare("DELETE FROM cashea_pagos WHERE compra_id = ? AND cuota_num = ?");
    $stmt->execute([$compra_id, $cuota_num]);
}
