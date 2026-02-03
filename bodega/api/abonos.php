<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
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
            // Obtener abonos de un fiado específico
            $fiado_id = $_GET['fiado_id'] ?? null;
            if (!$fiado_id) {
                echo json_encode(['ok' => false, 'error' => 'fiado_id requerido']);
                exit;
            }

            $stmt = $conn->prepare("
                SELECT *
                FROM abonos
                WHERE fiado_id = ?
                ORDER BY fecha DESC
            ");
            $stmt->execute([$fiado_id]);
            $abonos = $stmt->fetchAll(PDO::FETCH_ASSOC);

            $result = array_map(function($a) {
                return [
                    'id' => intval($a['id']),
                    'fiado_id' => intval($a['fiado_id']),
                    'monto_bs' => floatval($a['monto_bs']),
                    'monto_usd' => floatval($a['monto_usd']),
                    'observaciones' => $a['observaciones'],
                    'fecha' => $a['fecha']
                ];
            }, $abonos);

            echo json_encode([
                'ok' => true,
                'abonos' => $result
            ]);
            break;

        case 'POST':
            // Registrar nuevo abono
            $data = json_decode(file_get_contents('php://input'), true);
            
            if (!isset($data['fiado_id']) || !isset($data['monto_usd'])) {
                echo json_encode(['ok' => false, 'error' => 'Datos incompletos']);
                exit;
            }

            $conn->beginTransaction();

            try {
                // Insertar abono
                $stmt = $conn->prepare("
                    INSERT INTO abonos (fiado_id, monto_bs, monto_usd, observaciones)
                    VALUES (?, ?, ?, ?)
                ");
                
                $stmt->execute([
                    $data['fiado_id'],
                    $data['monto_bs'],
                    $data['monto_usd'],
                    $data['observaciones'] ?? null
                ]);

                $abono_id = $conn->lastInsertId();

                // Actualizar saldo pendiente del fiado
                $stmt = $conn->prepare("
                    UPDATE fiados 
                    SET saldo_pendiente = saldo_pendiente - ?
                    WHERE id = ?
                ");
                $stmt->execute([$data['monto_usd'], $data['fiado_id']]);

                // Verificar si el fiado quedó pagado
                $stmt = $conn->prepare("SELECT saldo_pendiente FROM fiados WHERE id = ?");
                $stmt->execute([$data['fiado_id']]);
                $saldo = $stmt->fetch(PDO::FETCH_ASSOC)['saldo_pendiente'];

                if ($saldo <= 0.01) { // Considerar pagado si el saldo es menor a 1 centavo
                    $stmt = $conn->prepare("UPDATE fiados SET estado = 'pagado', saldo_pendiente = 0 WHERE id = ?");
                    $stmt->execute([$data['fiado_id']]);
                }

                $conn->commit();

                echo json_encode([
                    'ok' => true,
                    'abono_id' => $abono_id,
                    'message' => 'Abono registrado exitosamente'
                ]);

            } catch (Exception $e) {
                $conn->rollBack();
                throw $e;
            }
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
