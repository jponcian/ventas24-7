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
            
            if (!isset($data['monto_usd'])) {
                echo json_encode(['ok' => false, 'error' => 'Datos incompletos (monto_usd requerido)']);
                exit;
            }

            $conn->beginTransaction();

            try {
                // CASO 1: Abono a un fiado específico
                if (isset($data['fiado_id'])) {
                    $fiado_id = $data['fiado_id'];
                    $monto_usd = $data['monto_usd'];
                    $monto_bs = $data['monto_bs'] ?? 0;
                    $obs = $data['observaciones'] ?? null;

                    // Insertar abono
                    $stmt = $conn->prepare("
                        INSERT INTO abonos (fiado_id, monto_bs, monto_usd, observaciones)
                        VALUES (?, ?, ?, ?)
                    ");
                    $stmt->execute([$fiado_id, $monto_bs, $monto_usd, $obs]);
                    $abono_id = $conn->lastInsertId();

                    // Actualizar saldo pendiente del fiado
                    $stmt = $conn->prepare("
                        UPDATE fiados 
                        SET saldo_pendiente = saldo_pendiente - ?
                        WHERE id = ?
                    ");
                    $stmt->execute([$monto_usd, $fiado_id]);

                    // Verificar si el fiado quedó pagado
                    $stmt = $conn->prepare("SELECT saldo_pendiente FROM fiados WHERE id = ?");
                    $stmt->execute([$fiado_id]);
                    $saldo = $stmt->fetch(PDO::FETCH_ASSOC)['saldo_pendiente'];

                    if ($saldo <= 0.01) {
                        $stmt = $conn->prepare("UPDATE fiados SET estado = 'pagado', saldo_pendiente = 0 WHERE id = ?");
                        $stmt->execute([$fiado_id]);
                    }

                    $conn->commit();
                    echo json_encode(['ok' => true, 'abono_id' => $abono_id, 'message' => 'Abono registrado exitosamente']);
                } 
                // CASO 2: Abono general a un cliente (distribuido)
                else if (isset($data['cliente_id'])) {
                    $cliente_id = $data['cliente_id'];
                    $monto_total_usd = (float)$data['monto_usd'];
                    $monto_total_bs = (float)($data['monto_bs'] ?? 0);
                    $monto_restante_usd = $monto_total_usd;
                    $obs = $data['observaciones'] ?? 'Abono general';

                    // Obtener fiados pendientes por fecha ascendente (el más viejo primero)
                    $stmt = $conn->prepare("
                        SELECT id, saldo_pendiente 
                        FROM fiados 
                        WHERE cliente_id = ? AND estado = 'pendiente' 
                        ORDER BY fecha ASC
                    ");
                    $stmt->execute([$cliente_id]);
                    $fiados = $stmt->fetchAll(PDO::FETCH_ASSOC);

                    if (empty($fiados)) {
                        $conn->rollBack();
                        echo json_encode(['ok' => false, 'error' => 'El cliente no tiene deudas pendientes']);
                        exit;
                    }

                    foreach ($fiados as $f) {
                        if ($monto_restante_usd <= 0) break;

                        $pago_usd = min($monto_restante_usd, (float)$f['saldo_pendiente']);
                        // Proporción de BS si se envío monto_total_bs
                        $pago_bs = ($monto_total_usd > 0) ? ($pago_usd * $monto_total_bs / $monto_total_usd) : 0;

                        // Insertar abono para este fiado
                        $stmt_abono = $conn->prepare("
                            INSERT INTO abonos (fiado_id, monto_bs, monto_usd, observaciones)
                            VALUES (?, ?, ?, ?)
                        ");
                        $stmt_abono->execute([$f['id'], $pago_bs, $pago_usd, $obs]);

                        // Actualizar fiado
                        $nuevo_saldo = (float)$f['saldo_pendiente'] - $pago_usd;
                        if ($nuevo_saldo <= 0.01) {
                            $stmt_upd = $conn->prepare("UPDATE fiados SET saldo_pendiente = 0, estado = 'pagado' WHERE id = ?");
                        } else {
                            $stmt_upd = $conn->prepare("UPDATE fiados SET saldo_pendiente = ? WHERE id = ?");
                        }
                        $stmt_upd->execute($nuevo_saldo <= 0.01 ? [$f['id']] : [$nuevo_saldo, $f['id']]);

                        $monto_restante_usd -= $pago_usd;
                    }

                    $conn->commit();
                    echo json_encode(['ok' => true, 'message' => 'Abono general aplicado exitosamente']);
                } else {
                    $conn->rollBack();
                    echo json_encode(['ok' => false, 'error' => 'Se requiere fiado_id o cliente_id']);
                }

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
