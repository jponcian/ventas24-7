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
            if (isset($_GET['id'])) {
                // Obtener un cliente específico
                $stmt = $conn->prepare("
                    SELECT 
                        c.*,
                        COALESCE(SUM(CASE WHEN f.estado = 'pendiente' THEN f.saldo_pendiente ELSE 0 END), 0) as deuda_total
                    FROM clientes c
                    LEFT JOIN fiados f ON c.id = f.cliente_id
                    WHERE c.id = ?
                    GROUP BY c.id
                ");
                $stmt->execute([$_GET['id']]);
                $cliente = $stmt->fetch(PDO::FETCH_ASSOC);
                
                if ($cliente) {
                    echo json_encode([
                        'ok' => true,
                        'cliente' => [
                            'id' => intval($cliente['id']),
                            'nombre' => $cliente['nombre'],
                            'cedula' => $cliente['cedula'],
                            'telefono' => $cliente['telefono'],
                            'direccion' => $cliente['direccion'],
                            'deuda_total' => floatval($cliente['deuda_total']),
                            'fecha_creacion' => $cliente['created_at']
                        ]
                    ]);
                } else {
                    echo json_encode(['ok' => false, 'error' => 'Cliente no encontrado']);
                }
            } else {
                // Listar todos los clientes de un negocio
                $negocio_id = $_GET['negocio_id'] ?? null;
                if (!$negocio_id) {
                    echo json_encode(['ok' => false, 'error' => 'negocio_id requerido']);
                    exit;
                }

                $stmt = $conn->prepare("
                    SELECT 
                        c.*,
                        COALESCE(SUM(CASE WHEN f.estado = 'pendiente' THEN f.saldo_pendiente ELSE 0 END), 0) as deuda_total
                    FROM clientes c
                    LEFT JOIN fiados f ON c.id = f.cliente_id
                    WHERE c.negocio_id = ?
                    GROUP BY c.id
                    ORDER BY c.nombre
                ");
                $stmt->execute([$negocio_id]);
                $clientes = $stmt->fetchAll(PDO::FETCH_ASSOC);

                $result = array_map(function($c) {
                    return [
                        'id' => intval($c['id']),
                        'nombre' => $c['nombre'],
                        'cedula' => $c['cedula'],
                        'telefono' => $c['telefono'],
                        'direccion' => $c['direccion'],
                        'deuda_total' => floatval($c['deuda_total']),
                        'fecha_creacion' => $c['created_at']
                    ];
                }, $clientes);

                echo json_encode([
                    'ok' => true,
                    'clientes' => $result
                ]);
            }
            break;

        case 'POST':
            // Crear nuevo cliente
            $data = json_decode(file_get_contents('php://input'), true);
            
            if (!isset($data['negocio_id']) || !isset($data['nombre'])) {
                echo json_encode(['ok' => false, 'error' => 'Datos incompletos']);
                exit;
            }

            $stmt = $conn->prepare("
                INSERT INTO clientes (negocio_id, nombre, cedula, telefono, direccion)
                VALUES (?, ?, ?, ?, ?)
            ");
            
            $stmt->execute([
                $data['negocio_id'],
                $data['nombre'],
                $data['cedula'] ?? null,
                $data['telefono'] ?? null,
                $data['direccion'] ?? null
            ]);

            echo json_encode([
                'ok' => true,
                'cliente_id' => $conn->lastInsertId(),
                'message' => 'Cliente creado exitosamente'
            ]);
            break;

        case 'PUT':
            // Actualizar cliente
            $data = json_decode(file_get_contents('php://input'), true);
            
            if (!isset($data['id']) || !isset($data['nombre'])) {
                echo json_encode(['ok' => false, 'error' => 'Datos incompletos']);
                exit;
            }

            $stmt = $conn->prepare("
                UPDATE clientes 
                SET nombre = ?, cedula = ?, telefono = ?, direccion = ?
                WHERE id = ?
            ");
            
            $stmt->execute([
                $data['nombre'],
                $data['cedula'] ?? null,
                $data['telefono'] ?? null,
                $data['direccion'] ?? null,
                $data['id']
            ]);

            echo json_encode([
                'ok' => true,
                'message' => 'Cliente actualizado exitosamente'
            ]);
            break;

        case 'DELETE':
            // Eliminar cliente (solo si no tiene fiados)
            $id = $_GET['id'] ?? null;
            if (!$id) {
                echo json_encode(['ok' => false, 'error' => 'ID requerido']);
                exit;
            }

            // Verificar si tiene fiados
            $stmt = $conn->prepare("SELECT COUNT(*) as count FROM fiados WHERE cliente_id = ?");
            $stmt->execute([$id]);
            $count = $stmt->fetch(PDO::FETCH_ASSOC)['count'];

            if ($count > 0) {
                echo json_encode([
                    'ok' => false,
                    'error' => 'No se puede eliminar el cliente porque tiene fiados registrados'
                ]);
                exit;
            }

            $stmt = $conn->prepare("DELETE FROM clientes WHERE id = ?");
            $stmt->execute([$id]);

            echo json_encode([
                'ok' => true,
                'message' => 'Cliente eliminado exitosamente'
            ]);
            break;

        default:
            echo json_encode(['ok' => false, 'error' => 'Método no permitido']);
            break;
    }

} catch (Exception $e) {
    echo json_encode([
        'ok' => false,
        'error' => $e->getMessage()
    ]);
}
