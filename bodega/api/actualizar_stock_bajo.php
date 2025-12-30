<?php
header('Content-Type: application/json');
// Enable error reporting for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

error_log("actualizar_stock_bajo.php: Script started.");

include_once '../db.php'; // Adjust path as needed
global $db; // Ensure $db (PDO object) is globally accessible

// Check if $db is available after including db.php
if (!isset($db) || !$db instanceof PDO) {
    error_log("actualizar_stock_bajo.php: DB object not available after db.php include.");
    $response = ['ok' => false, 'error' => 'Error interno: Conexión a DB no establecida.'];
    echo json_encode($response);
    exit;
} else {
    error_log("actualizar_stock_bajo.php: DB object is available.");
}

$response = ['ok' => false, 'error' => ''];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id = isset($_POST['id']) ? $_POST['id'] : null;
    $stock_bajo = isset($_POST['stock_bajo']) ? $_POST['stock_bajo'] : null;

    error_log("actualizar_stock_bajo.php: Received ID: " . var_export($id, true) . ", stock_bajo: " . var_export($stock_bajo, true));

    if ($id === null || $stock_bajo === null) {
        $response['error'] = 'ID del producto o estado de stock bajo no proporcionado.';
        error_log("actualizar_stock_bajo.php: Missing parameters.");
    } else {
        try {
            $stmt = $db->prepare("UPDATE productos SET bajo_inventario = :bajo_inventario WHERE id = :id");
            error_log("actualizar_stock_bajo.php: SQL prepared.");
            $stmt->bindParam(':bajo_inventario', $stock_bajo, PDO::PARAM_INT);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);

            if ($stmt->execute()) {
                $response['ok'] = true;
                error_log("actualizar_stock_bajo.php: Update successful.");
            } else {
                $response['error'] = 'Error al actualizar el stock bajo.';
                error_log("actualizar_stock_bajo.php: Update failed. PDO errorInfo: " . var_export($stmt->errorInfo(), true));
            }
        } catch (PDOException $e) {
            $response['error'] = 'Error de base de datos: ' . $e->getMessage();
            error_log("actualizar_stock_bajo.php: PDOException caught: " . $e->getMessage());
        }
    }
} else {
    $response['error'] = 'Método no permitido.';
    error_log("actualizar_stock_bajo.php: Invalid request method.");
}

echo json_encode($response);
error_log("actualizar_stock_bajo.php: Script finished. Response: " . json_encode($response));
?>