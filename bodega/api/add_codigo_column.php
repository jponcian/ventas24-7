<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include_once '../db.php';

// $db está disponible desde db.php
if (!isset($db)) {
    echo json_encode(["error" => "No se pudo conectar a la base de datos"]);
    exit;
}

try {
    // Intentar agregar la columna codigo_barras si no existe
    // MySQL 5.7+ supports IF NOT EXISTS in some contexts, but not purely in ADD COLUMN standard syntax easily without procedure.
    // Instead we try and catch.
    $sql = "ALTER TABLE productos ADD COLUMN codigo_barras VARCHAR(100) NULL AFTER descripcion";
    $db->exec($sql);
    echo json_encode(["message" => "Columna codigo_barras agregada correctamente"]);
} catch (PDOException $e) {
    if (strpos($e->getMessage(), "Duplicate column name") !== false) {
        echo json_encode(["message" => "La columna codigo_barras ya existe"]);
    } else {
        echo json_encode(["error" => $e->getMessage()]);
    }
}
?>
