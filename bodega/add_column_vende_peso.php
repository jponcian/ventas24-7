<?php
require __DIR__ . '/db.php';
try {
    $db->exec("ALTER TABLE productos ADD COLUMN vende_por_peso TINYINT(1) DEFAULT 0 AFTER precio_venta_paquete");
    echo json_encode(['ok' => true, 'message' => 'Columna vende_por_peso añadida']);
} catch (Exception $e) {
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
