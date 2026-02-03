<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, OPTIONS');
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
                // Obtener un fiado específico con sus detalles y abonos
                $stmt = $conn->prepare("
                    SELECT 
                        f.*,
                        c.nombre as cliente_nombre,
                        c.telefono as cliente_telefono
                    FROM fiados f
                    INNER JOIN clientes c ON f.cliente_id = c.id
                    WHERE f.id = ?
                ");
                $stmt->execute([$_GET['id']]);
                $fiado = $stmt->fetch(PDO::FETCH_ASSOC);
                
                if (!$fiado) {
                    echo json_encode(['ok' => false, 'error' => 'Fiado no encontrado']);
                    exit;
                }

                // Obtener detalles
                $stmt = $conn->prepare("
                    SELECT 
                        fd.*,
                        p.nombre as producto_nombre
                    FROM fiado_detalles fd
                    INNER JOIN productos p ON fd.producto_id = p.id
                    WHERE fd.fiado_id = ?
                ");
                $stmt->execute([$_GET['id']]);
                $detalles = $stmt->fetchAll(PDO::FETCH_ASSOC);

                $fiado['detalles'] = array_map(function($d) {
                    return [
                        'id' => intval($d['id']),
                        'producto_id' => intval($d['producto_id']),
                        'producto_nombre' => $d['producto_nombre'],
                        'cantidad' => floatval($d['cantidad']),
                        'precio_unitario_bs' => floatval($d['precio_unitario_bs']),
                        'precio_unitario_usd' => floatval($d['precio_unitario_usd']),
                        'subtotal_bs' => floatval($d['subtotal_bs']),
                        'subtotal_usd' => floatval($d['subtotal_usd'])
                    ];
                }, $detalles);

                echo json_encode([
                    'ok' => true,
                    'fiado' => [
                        'id' => intval($fiado['id']),
                        'cliente_id' => intval($fiado['cliente_id']),
                        'cliente_nombre' => $fiado['cliente_nombre'],
                        'total_bs' => floatval($fiado['total_bs']),
                        'total_usd' => floatval($fiado['total_usd']),
                        'saldo_pendiente' => floatval($fiado['saldo_pendiente']),
                        'tasa' => floatval($fiado['tasa']),
                        'estado' => $fiado['estado'],
                        'fecha' => $fiado['fecha'],
                        'detalles' => $fiado['detalles']
                    ]
                ]);
            } else {
                // Listar todos los fiados de un negocio
                $negocio_id = $_GET['negocio_id'] ?? null;
                if (!$negocio_id) {
                    echo json_encode(['ok' => false, 'error' => 'negocio_id requerido']);
                    exit;
                }

                $stmt = $conn->prepare("
                    SELECT 
                        f.*,
                        c.nombre as cliente_nombre,
                        c.telefono as cliente_telefono
                    FROM fiados f
                    INNER JOIN clientes c ON f.cliente_id = c.id
                    WHERE f.negocio_id = ?
                    ORDER BY f.fecha DESC
                ");
                $stmt->execute([$negocio_id]);
                $fiados = $stmt->fetchAll(PDO::FETCH_ASSOC);

                $result = array_map(function($f) {
                    return [
                        'id' => intval($f['id']),
                        'cliente_id' => intval($f['cliente_id']),
                        'cliente_nombre' => $f['cliente_nombre'],
                        'total_bs' => floatval($f['total_bs']),
                        'total_usd' => floatval($f['total_usd']),
                        'saldo_pendiente' => floatval($f['saldo_pendiente']),
                        'tasa' => floatval($f['tasa']),
                        'estado' => $f['estado'],
                        'fecha' => $f['fecha']
                    ];
                }, $fiados);

                echo json_encode([
                    'ok' => true,
                    'fiados' => $result
                ]);
            }
            break;

        case 'POST':
            // Crear nuevo fiado
            $data = json_decode(file_get_contents('php://input'), true);
            
            if (!isset($data['negocio_id']) || !isset($data['cliente_id']) || !isset($data['detalles'])) {
                echo json_encode(['ok' => false, 'error' => 'Datos incompletos']);
                exit;
            }

            $conn->beginTransaction();

            try {
                // Insertar fiado
                $stmt = $conn->prepare("
                    INSERT INTO fiados (negocio_id, cliente_id, total_bs, total_usd, saldo_pendiente, tasa, estado)
                    VALUES (?, ?, ?, ?, ?, ?, 'pendiente')
                ");
                
                $stmt->execute([
                    $data['negocio_id'],
                    $data['cliente_id'],
                    $data['total_bs'],
                    $data['total_usd'],
                    $data['total_usd'], // saldo_pendiente inicial = total
                    $data['tasa']
                ]);

                $fiado_id = $conn->lastInsertId();

                // Insertar detalles
                $stmt = $conn->prepare("
                    INSERT INTO fiado_detalles 
                    (fiado_id, producto_id, cantidad, precio_unitario_bs, precio_unitario_usd, subtotal_bs, subtotal_usd)
                    VALUES (?, ?, ?, ?, ?, ?, ?)
                ");

                foreach ($data['detalles'] as $detalle) {
                    $subtotal_bs = $detalle['cantidad'] * $detalle['precio_unitario_bs'];
                    $subtotal_usd = $detalle['cantidad'] * $detalle['precio_unitario_usd'];
                    
                    $stmt->execute([
                        $fiado_id,
                        $detalle['producto_id'],
                        $detalle['cantidad'],
                        $detalle['precio_unitario_bs'],
                        $detalle['precio_unitario_usd'],
                        $subtotal_bs,
                        $subtotal_usd
                    ]);

                    // Descontar del stock
                    $stmt2 = $conn->prepare("UPDATE productos SET stock = stock - ? WHERE id = ?");
                    $stmt2->execute([$detalle['cantidad'], $detalle['producto_id']]);
                }

                $conn->commit();

                echo json_encode([
                    'ok' => true,
                    'fiado_id' => $fiado_id,
                    'message' => 'Fiado creado exitosamente'
                ]);

            } catch (Exception $e) {
                $conn->rollBack();
                throw $e;
            }
            break;

        case 'PUT':
            // Actualizar estado del fiado
            $data = json_decode(file_get_contents('php://input'), true);
            
            if (!isset($data['id']) || !isset($data['estado'])) {
                echo json_encode(['ok' => false, 'error' => 'Datos incompletos']);
                exit;
            }

            $stmt = $conn->prepare("UPDATE fiados SET estado = ? WHERE id = ?");
            $stmt->execute([$data['estado'], $data['id']]);

            echo json_encode([
                'ok' => true,
                'message' => 'Fiado actualizado exitosamente'
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
