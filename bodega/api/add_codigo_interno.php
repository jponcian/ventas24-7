<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include_once '../db.php';

if (!isset($db)) {
    echo json_encode(["error" => "No se pudo conectar a la base de datos"]);
    exit;
}

try {
    $sql = "ALTER TABLE productos ADD COLUMN codigo_interno VARCHAR(50) NULL AFTER nombre";
    $db->exec($sql);
    echo json_encode(["message" => "Columna codigo_interno agregada correctamente"]);
} catch (PDOException $e) {
    if (strpos($e->getMessage(), "Duplicate column name") !== false) {
        echo json_encode(["message" => "La columna codigo_interno ya existe"]);
    } else {
        echo json_encode(["error" => $e->getMessage()]);
    }
}
?>
