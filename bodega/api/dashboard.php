<?php
require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/../db.php';
header('Content-Type: application/json; charset=utf-8');

// Configurar zona horaria
date_default_timezone_set('America/Caracas');

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
    
    // Obtenemos todas las ventas de hoy para procesar los totales con fallback
    $stmtVentas = $db->prepare("SELECT total_usd, total_bs, tasa FROM ventas WHERE negocio_id = ? AND DATE(fecha) = ?");
    $stmtVentas->execute([$nid, $hoy]);
    $ventasHoy = $stmtVentas->fetchAll(PDO::FETCH_ASSOC);

    $totalUsd = 0;
    $totalBs = 0;
    $count = count($ventasHoy);

    foreach ($ventasHoy as $v) {
        $totalUsd += (float)$v['total_usd'];
        $valBs = (float)$v['total_bs'];
        // Si el total_bs es 0 pero tenemos usd y tasa, lo recalculamos para el reporte
        if ($valBs <= 0 && $v['total_usd'] > 0 && $v['tasa'] > 0) {
            $valBs = $v['total_usd'] * $v['tasa'];
        }
        $totalBs += $valBs;
    }

    // 2. Productos con stock bajo
    $stmtBajo = $db->prepare("SELECT COUNT(*) FROM productos WHERE negocio_id = ? AND stock <= bajo_inventario");
    $stmtBajo->execute([$nid]);
    $bajoStock = $stmtBajo->fetchColumn();

    // 3. Total productos
    $stmtTotal = $db->prepare("SELECT COUNT(*) FROM productos WHERE negocio_id = ?");
    $stmtTotal->execute([$nid]);
    $totalProd = $stmtTotal->fetchColumn();

    // 4. Últimas 5 ventas (con procesamiento de total_bs)
    $stmtLast = $db->prepare("SELECT id, total_usd, total_bs, tasa, fecha FROM ventas WHERE negocio_id = ? AND DATE(fecha) = ? ORDER BY fecha DESC LIMIT 5");
    $stmtLast->execute([$nid, $hoy]);
    $ultimasRaw = $stmtLast->fetchAll(PDO::FETCH_ASSOC);
    
    $ultimas = [];
    foreach ($ultimasRaw as $u) {
        $u['total_usd'] = (float)$u['total_usd'];
        $u['total_bs'] = (float)$u['total_bs'];
        if ($u['total_bs'] <= 0 && $u['total_usd'] > 0 && $u['tasa'] > 0) {
            $u['total_bs'] = $u['total_usd'] * $u['tasa'];
        }
        $ultimas[] = $u;
    }

    echo json_encode([
        'ok' => true,
        'today_total_usd' => $totalUsd,
        'today_total_bs' => $totalBs,
        'today_count' => $count,
        'low_stock_count' => (int)$bajoStock,
        'total_products' => (int)$totalProd,
        'latest_sales' => $ultimas
    ]);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
