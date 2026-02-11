<?php
require_once __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

try {
    global $db;
    // Tabla para registrar múltiples pagos por venta
    $db->exec("CREATE TABLE IF NOT EXISTS ventas_pagos (
        id INT AUTO_INCREMENT PRIMARY KEY,
        venta_id INT NOT NULL,
        metodo_pago_id INT NOT NULL,
        monto_bs DECIMAL(10,2) NOT NULL,
        monto_usd DECIMAL(10,2) NOT NULL,
        referencia VARCHAR(100) NULL,
        fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )");
    
    echo json_encode(['ok' => true, 'message' => 'Tabla ventas_pagos creada correctamente']);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
