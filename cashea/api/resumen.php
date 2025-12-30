<?php
require '../db.php';
header('Content-Type: application/json');

// limitar a owner si hay sesión
$owner = isset($_SESSION['user_id']) ? $_SESSION['user_id'] : null;
$compras = obtenerCompras($owner);
$pagos = obtenerPagosPorOwner($owner);

// Paleta y asignación de color por usuario (coherente con cuotas.php)
$colores = [
    '#FFD600', // Amarillo
    '#1976D2', // Azul
    '#8E24AA', // Morado
    '#F4511E', // Naranja
    '#00ACC1', // Turquesa
    '#6D4C41', // Marrón
    '#D81B60', // Rosa fuerte
    '#5E35B1', // Morado oscuro
];
$usuarios_colores = [];
$color_idx = 0;

// Mapear pagos por compra_id
$pagos_por_compra = [];
foreach ($pagos as $p) {
    $cid = $p['compra_id'];
    if (!isset($pagos_por_compra[$cid])) {
        $pagos_por_compra[$cid] = [
            'sum_monto' => 0.0,
            'cuotas_pagadas' => []
        ];
    }
    $pagos_por_compra[$cid]['sum_monto'] += floatval($p['monto']);
    $pagos_por_compra[$cid]['cuotas_pagadas'][$p['cuota_num']] = true;
}

// Agrupar por usuario
$usuarios = [];
foreach ($compras as $c) {
    $u = $c['usuario'];
    if (!isset($usuarios[$u])) {
        $usuarios[$u] = [
            'usuario' => $u,
            'color' => null,
            'totales' => [
                'compras' => 0,
                'total_precio' => 0.0,
                'total_inicial' => 0.0,
                'total_pagado' => 0.0,
                'total_saldo' => 0.0,
            ],
            'compras' => []
        ];
    }

    // Asignar color consistente por usuario
    if (!isset($usuarios_colores[$u])) {
        $usuarios_colores[$u] = $colores[$color_idx % count($colores)];
        $color_idx++;
    }
    $usuarios[$u]['color'] = $usuarios_colores[$u];
    // Guardar el teléfono a nivel usuario si no está
    if (!isset($usuarios[$u]['telefono']) && isset($c['telefono'])) {
        $usuarios[$u]['telefono'] = $c['telefono'];
    }

    $cid = $c['id'];
    $precio = floatval($c['precio']);
    $inicial = floatval($c['inicial']);
    $cuotas = intval($c['cuotas']);
    $pagado_info = isset($pagos_por_compra[$cid]) ? $pagos_por_compra[$cid] : array('sum_monto' => 0.0, 'cuotas_pagadas' => array());
    $sum_pagado = $pagado_info['sum_monto'];
    $cuotas_pagadas = count($pagado_info['cuotas_pagadas']);
    $pendientes = max(0, $cuotas - $cuotas_pagadas);
    $saldo = max(0.0, ($precio - $inicial) - $sum_pagado);

    $usuarios[$u]['totales']['compras'] += 1;
    $usuarios[$u]['totales']['total_precio'] += $precio;
    $usuarios[$u]['totales']['total_inicial'] += $inicial;
    $usuarios[$u]['totales']['total_pagado'] += $sum_pagado;
    $usuarios[$u]['totales']['total_saldo'] += $saldo;

    $usuarios[$u]['compras'][] = [
        'id' => $cid,
        'producto' => $c['producto'],
        'precio' => $precio,
        'inicial' => $inicial,
        'pagado_cuotas' => $sum_pagado,
        'pagado_total' => $inicial + $sum_pagado,
        'cuotas' => $cuotas,
        'pagadas' => $cuotas_pagadas,
        'pendientes' => $pendientes,
        'saldo' => $saldo,
        'fecha_compra' => $c['fecha_compra'],
    ];
}

// Calcular total pagado incluyendo inicial a nivel usuario
foreach ($usuarios as $key => $val) {
    $usuarios[$key]['totales']['total_pagado_total'] = $val['totales']['total_inicial'] + $val['totales']['total_pagado'];
}

// Reindexar como lista
$resultado = array_values($usuarios);

echo json_encode($resultado);
