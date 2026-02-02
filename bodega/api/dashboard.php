<?php
require_once __DIR__ . '/cors.php';
require __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

$nid = $_GET['negocio_id'] ?? null;

if (!$nid) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'negocio_id requerido']);
    exit;
}

try {
    global $db;

    // 1. Ventas de hoy
    $hoy = date('Y-m-d');
    $stmtVentas = $db->prepare("SELECT SUM(total_usd) as total, COUNT(*) as cantidad FROM ventas WHERE negocio_id = ? AND DATE(fecha) = ?");
    $stmtVentas->execute([$nid, $hoy]);
    $resVentas = $stmtVentas->fetch(PDO::FETCH_ASSOC);

    // 2. Productos con stock bajo
    $stmtBajo = $db->prepare("SELECT COUNT(*) FROM productos WHERE negocio_id = ? AND stock <= bajo_inventario");
    $stmtBajo->execute([$nid]);
    $bajoStock = $stmtBajo->fetchColumn();

    // 3. Total productos
    $stmtTotal = $db->prepare("SELECT COUNT(*) FROM productos WHERE negocio_id = ?");
    $stmtTotal->execute([$nid]);
    $totalProd = $stmtTotal->fetchColumn();

    // 4. Últimas 5 ventas
    $stmtLast = $db->prepare("SELECT id, total_usd, fecha FROM ventas WHERE negocio_id = ? ORDER BY fecha DESC LIMIT 5");
    $stmtLast->execute([$nid]);
    $ultimas = $stmtLast->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'ok' => true,
        'today_total_usd' => (float)($resVentas['total'] ?? 0),
        'today_count' => (int)($resVentas['cantidad'] ?? 0),
        'low_stock_count' => (int)$bajoStock,
        'total_products' => (int)$totalProd,
        'latest_sales' => $ultimas
    ]);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
