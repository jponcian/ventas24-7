<?php
$host = '127.0.0.1';
$dbname = 'javier_ponciano_4';
$user = 'ponciano';
$pass = 'Prueba016.';
try {
    $db = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $user, $pass);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $db->exec("ALTER TABLE productos MODIFY COLUMN costo_unitario DECIMAL(15, 4) DEFAULT 0.0000");
    $db->exec("ALTER TABLE productos MODIFY COLUMN precio_venta_unidad DECIMAL(15, 4) DEFAULT 0.0000");
    $db->exec("ALTER TABLE productos MODIFY COLUMN precio_venta_paquete DECIMAL(15, 4) DEFAULT 0.0000");
    echo "OK: Tablas localmente actualizadas.";
} catch (Exception $e) {
    echo "ERROR: " . $e->getMessage();
}
?>
