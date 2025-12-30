<?php
require '../db.php';
header('Content-Type: application/json');

$owner = isset($_SESSION['user_id']) ? $_SESSION['user_id'] : null;
$compras = obtenerCompras($owner);
$pagos = obtenerPagosPorOwner($owner);
$pagos_map = [];
foreach ($pagos as $pago) {
    $pagos_map[$pago['compra_id'] . '_' . $pago['cuota_num']] = $pago;
}

// Asignar color único a cada usuario
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
$eventos = [];
foreach ($compras as $compra) {
    $usuario = $compra['usuario'];
    if (!isset($usuarios_colores[$usuario])) {
        $usuarios_colores[$usuario] = $colores[$color_idx % count($colores)];
        $color_idx++;
    }
    $fecha = $compra['fecha_compra'];
    $cuotas = intval($compra['cuotas']);
    $monto_cuota = ($compra['precio'] - $compra['inicial']) / $cuotas;
    for ($i = 1; $i <= $cuotas; $i++) {
        $pago = date('Y-m-d', strtotime("$fecha +" . ($i * 14) . " days"));
        $pagada = isset($pagos_map[$compra['id'] . '_' . $i]);
        // Mostrar en el calendario:
        // - Si la cuota es de hoy o futura, siempre
        // - Si la cuota es anterior a hoy, solo si NO está pagada
        if ($pago < date('Y-m-d') && $pagada) continue;
        $color = $pagada ? '#43a047' : $usuarios_colores[$usuario];
        // Título: si está pagada, solo mostrar el usuario; si no, mostrar usuario y monto
        $titulo = $usuario;
        if (!$pagada) {
            $titulo .= ' - $' . number_format($monto_cuota, 2);
        }
        $eventos[] = [
            'title' => $titulo,
            'start' => $pago,
            'color' => $color,
            'extendedProps' => [
                'producto' => $compra['producto'],
                'cuota_num' => $i,
                'pagada' => $pagada,
                'compra_id' => $compra['id'],
                'monto' => round($monto_cuota, 2),
                'usuario' => $usuario
            ]
        ];
    }
}
echo json_encode($eventos);
