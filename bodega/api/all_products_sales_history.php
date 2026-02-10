<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
header('Access-Control-Allow-Headers: Content-Type');

require_once '../conexion.php';

try {
    $negocio_id = isset($_GET['negocio_id']) ? intval($_GET['negocio_id']) : 0;
    $days = isset($_GET['days']) ? intval($_GET['days']) : 30;

    if ($negocio_id <= 0) {
        echo json_encode([
            'ok' => false,
            'error' => 'Parámetros inválidos'
        ]);
        exit;
    }

    // Calcular fecha de inicio
    $fecha_inicio = date('Y-m-d', strtotime("-$days days"));

    // Consultar historial de ventas agrupado por producto
    $sql = "SELECT 
                vd.producto_id,
                p.nombre as producto_nombre,
                p.stock,
                DATE(v.fecha_venta) as fecha,
                SUM(vd.cantidad) as cantidad_total
            FROM venta_detalle vd
            INNER JOIN ventas v ON vd.venta_id = v.id
            INNER JOIN productos p ON vd.producto_id = p.id
            WHERE v.negocio_id = ?
            AND v.fecha_venta >= ?
            GROUP BY vd.producto_id, DATE(v.fecha_venta), p.nombre, p.stock
            ORDER BY vd.producto_id, fecha DESC";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param('is', $negocio_id, $fecha_inicio);
    $stmt->execute();
    $result = $stmt->get_result();

    // Agrupar ventas por producto
    $productos = [];
    while ($row = $result->fetch_assoc()) {
        $producto_id = $row['producto_id'];
        
        if (!isset($productos[$producto_id])) {
            $productos[$producto_id] = [
                'producto_id' => $producto_id,
                'producto_nombre' => $row['producto_nombre'],
                'stock' => floatval($row['stock']),
                'ventas' => []
            ];
        }
        
        $productos[$producto_id]['ventas'][] = [
            'fecha' => $row['fecha'],
            'cantidad' => floatval($row['cantidad_total'])
        ];
    }

    // Convertir a array indexado
    $productos_array = array_values($productos);

    echo json_encode([
        'ok' => true,
        'productos' => $productos_array,
        'total_productos' => count($productos_array),
        'dias_analizados' => $days
    ]);

} catch (Exception $e) {
    echo json_encode([
        'ok' => false,
        'error' => 'Error al obtener historial: ' . $e->getMessage()
    ]);
}

$conn->close();
?>
