<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

require_once __DIR__ . '/../db.php';
$conn = $db;

$method = $_SERVER['REQUEST_METHOD'];

try {
    switch ($method) {
        case 'GET':
            $negocio_id = $_GET['negocio_id'] ?? null;
            if (!$negocio_id) {
                echo json_encode(['ok' => false, 'error' => 'negocio_id requerido']);
                exit;
            }

            $stmt = $conn->prepare("SELECT * FROM metodos_pago WHERE negocio_id = ? AND activo = 1 ORDER BY id ASC");
            $stmt->execute([$negocio_id]);
            $metodos = $stmt->fetchAll(PDO::FETCH_ASSOC);

            echo json_encode([
                'ok' => true,
                'metodos' => $metodos
            ]);
            break;

        case 'POST':
            $data = json_decode(file_get_contents('php://input'), true);
            if (!isset($data['negocio_id']) || !isset($data['nombre'])) {
                echo json_encode(['ok' => false, 'error' => 'Datos incompletos']);
                exit;
            }

            $stmt = $conn->prepare("INSERT INTO metodos_pago (negocio_id, nombre, requiere_referencia) VALUES (?, ?, ?)");
            $stmt->execute([
                $data['negocio_id'],
                $data['nombre'],
                $data['requiere_referencia'] ?? 0
            ]);

            echo json_encode([
                'ok' => true,
                'id' => $conn->lastInsertId(),
                'message' => 'Método de pago registrado'
            ]);
            break;

        case 'PUT':
            $data = json_decode(file_get_contents('php://input'), true);
            if (!isset($data['id'])) {
                echo json_encode(['ok' => false, 'error' => 'ID requerido']);
                exit;
            }

            $stmt = $conn->prepare("UPDATE metodos_pago SET nombre = ?, requiere_referencia = ? WHERE id = ?");
            $stmt->execute([
                $data['nombre'],
                $data['requiere_referencia'],
                $data['id']
            ]);

            echo json_encode(['ok' => true, 'message' => 'Método de pago actualizado']);
            break;

        case 'DELETE':
            $id = $_GET['id'] ?? null;
            if (!$id) {
                echo json_encode(['ok' => false, 'error' => 'ID requerido']);
                exit;
            }

            // Soft delete
            $stmt = $conn->prepare("UPDATE metodos_pago SET activo = 0 WHERE id = ?");
            $stmt->execute([$id]);

            echo json_encode(['ok' => true, 'message' => 'Método de pago eliminado']);
            break;

        default:
            echo json_encode(['ok' => false, 'error' => 'Método no permitido']);
            break;
    }
} catch (Exception $e) {
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
