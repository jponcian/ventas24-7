<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
header('Access-Control-Allow-Headers: Content-Type');

require_once '../conexion.php';

try {
    $negocio_id = isset($_GET['negocio_id']) ? intval($_GET['negocio_id']) : 0;
    $producto_id = isset($_GET['producto_id']) ? intval($_GET['producto_id']) : 0;
    $days = isset($_GET['days']) ? intval($_GET['days']) : 30;

    if ($negocio_id <= 0 || $producto_id <= 0) {
        echo json_encode([
            'ok' => false,
            'error' => 'Parámetros inválidos'
        ]);
        exit;
    }

    // Calcular fecha de inicio
    $fecha_inicio = date('Y-m-d', strtotime("-$days days"));

    // Consultar historial de ventas del producto
    $sql = "SELECT 
                vd.cantidad,
                v.fecha_venta as fecha
            FROM venta_detalle vd
            INNER JOIN ventas v ON vd.venta_id = v.id
            WHERE v.negocio_id = ?
            AND vd.producto_id = ?
            AND v.fecha_venta >= ?
            ORDER BY v.fecha_venta DESC";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param('iis', $negocio_id, $producto_id, $fecha_inicio);
    $stmt->execute();
    $result = $stmt->get_result();

    $ventas = [];
    while ($row = $result->fetch_assoc()) {
        $ventas[] = [
            'cantidad' => floatval($row['cantidad']),
            'fecha' => $row['fecha']
        ];
    }

    echo json_encode([
        'ok' => true,
        'ventas' => $ventas,
        'total_registros' => count($ventas)
    ]);

} catch (Exception $e) {
    echo json_encode([
        'ok' => false,
        'error' => 'Error al obtener historial: ' . $e->getMessage()
    ]);
}

$conn->close();
?>
