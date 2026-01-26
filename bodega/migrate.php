<?php
// migrate.php - script de migración para la tabla `productos` del módulo bodega
// Uso: php migrate.php
// Nota: Este script NO crea respaldos automáticos. Haz un backup manual antes si lo deseas.

$configPath = __DIR__ . '/config.php';
if (file_exists($configPath)) {
    require $configPath;
}

$host = isset($host) ? $host : 'localhost';
$dbname = isset($dbname) ? $dbname : 'javier_ponciano_4';
$user = isset($user) ? $user : 'ponciano';
$pass = isset($pass) ? $pass : 'Prueba016.';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (Exception $e) {
    echo "Error de conexión: " . $e->getMessage() . PHP_EOL;
    exit(1);
}

function columnExists(PDO $pdo, $db, $table, $column)
{
    $sql = "SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = ? AND table_name = ? AND column_name = ?";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$db, $table, $column]);
    return intval($stmt->fetchColumn()) > 0;
}

function tableExists(PDO $pdo, $db, $table)
{
    $sql = "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = ? AND table_name = ?";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$db, $table]);
    return intval($stmt->fetchColumn()) > 0;
}

$table = 'productos';

if (!tableExists($pdo, $dbname, $table)) {
    echo "La tabla '$table' no existe en la base de datos '$dbname'.\n";
    // Intentar crear desde schema.sql si existe
    $schemaFile = __DIR__ . '/schema.sql';
    if (file_exists($schemaFile)) {
        echo "Creando tabla desde schema.sql...\n";
        $schema = file_get_contents($schemaFile);
        try {
            $pdo->exec($schema);
            echo "Tabla creada.\n";
        } catch (Exception $e) {
            echo "Error creando tabla desde schema.sql: " . $e->getMessage() . PHP_EOL;
            exit(1);
        }
    } else {
        echo "No hay schema.sql disponible. Crea la tabla manualmente y vuelve a ejecutar este script.\n";
        exit(1);
    }
}

// Añadir bajo_inventario
if (!columnExists($pdo, $dbname, $table, 'bajo_inventario')) {
    $changes[] = "ADD COLUMN `bajo_inventario` TINYINT(1) NOT NULL DEFAULT 0";
}

// Añadir unidad_medida
if (!columnExists($pdo, $dbname, $table, 'unidad_medida')) {
    $changes[] = "ADD COLUMN `unidad_medida` VARCHAR(32) NOT NULL DEFAULT 'unidad'";
}
// Añadir tam_paquete
if (!columnExists($pdo, $dbname, $table, 'tam_paquete')) {
    $changes[] = "ADD COLUMN `tam_paquete` DECIMAL(10,3) NULL";
}
// Añadir precio_compra
if (!columnExists($pdo, $dbname, $table, 'precio_compra')) {
    $changes[] = "ADD COLUMN `precio_compra` DECIMAL(10,2) NOT NULL DEFAULT 0.00";
}
// Añadir precio_venta
if (!columnExists($pdo, $dbname, $table, 'precio_venta')) {
    $changes[] = "ADD COLUMN `precio_venta` DECIMAL(10,2) NOT NULL DEFAULT 0.00";
}
// Añadir precio_venta_paquete
if (!columnExists($pdo, $dbname, $table, 'precio_venta_paquete')) {
    $changes[] = "ADD COLUMN `precio_venta_paquete` DECIMAL(10,2) NULL";
}
// Añadir precio_venta_mediopaquete
if (!columnExists($pdo, $dbname, $table, 'precio_venta_mediopaquete')) {
    $changes[] = "ADD COLUMN `precio_venta_mediopaquete` DECIMAL(10,2) NULL";
}
// Añadir precio_venta_unidad
if (!columnExists($pdo, $dbname, $table, 'precio_venta_unidad')) {
    $changes[] = "ADD COLUMN `precio_venta_unidad` DECIMAL(10,2) NULL";
}
// Añadir moneda_compra
if (!columnExists($pdo, $dbname, $table, 'moneda_compra')) {
    $changes[] = "ADD COLUMN `moneda_compra` VARCHAR(8) NOT NULL DEFAULT 'USD'";
}
// Añadir codigo_barras
if (!columnExists($pdo, $dbname, $table, 'codigo_barras')) {
    $changes[] = "ADD COLUMN `codigo_barras` VARCHAR(64) NULL AFTER `nombre` ";
}
// Eliminar cantidad
$dropCantidad = false;
if (columnExists($pdo, $dbname, $table, 'cantidad')) {
    $dropCantidad = true;
    $changes[] = "DROP COLUMN `cantidad`";
}

if (count($changes) > 0) {
    $sql = "ALTER TABLE `{$table}` " . implode(', ', $changes);
    echo "Ejecutando: $sql\n";
    try {
        $pdo->exec($sql);
        echo "ALTER TABLE ejecutado correctamente.\n";
    } catch (Exception $e) {
        echo "Error ejecutando ALTER TABLE: " . $e->getMessage() . PHP_EOL;
        echo "Revirtiendo (si es posible).\n";
        exit(1);
    }
} else {
    echo "No se requieren cambios en la estructura de la tabla.\n";
}

// Asegurar valores por defecto para filas existentes
try {
    if (columnExists($pdo, $dbname, $table, 'unidad_medida')) {
        $pdo->exec("UPDATE `{$table}` SET unidad_medida = 'unidad' WHERE unidad_medida IS NULL OR unidad_medida = ''");
    }
    echo "Valores por defecto aplicados a filas existentes.\n";
} catch (Exception $e) {
    echo "Error aplicando valores por defecto: " . $e->getMessage() . PHP_EOL;
}


echo "Migración finalizada.\n";
echo "Si deseas, crea un respaldo manual antes de ejecutar este script (phpMyAdmin o CREATE TABLE backup AS SELECT ...).\n";
