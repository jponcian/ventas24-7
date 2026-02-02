<?php
require __DIR__ . '/db.php';
try {
    $stmt = $db->query("DESCRIBE productos");
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
} catch (Exception $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
