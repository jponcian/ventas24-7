<?php
require_once __DIR__ . '/../db.php';
header('Content-Type: application/json');

try {
    global $db;
    // Check if column exists
    $stmt = $db->query("SHOW COLUMNS FROM productos LIKE 'marca'");
    $exists = $stmt->fetch();

    if (!$exists) {
        $db->exec("ALTER TABLE productos ADD COLUMN marca VARCHAR(100) NULL AFTER descripcion");
        echo json_encode(['ok' => true, 'message' => 'Columna marca agregada']);
    } else {
        echo json_encode(['ok' => true, 'message' => 'Columna marca ya existe']);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
?>
