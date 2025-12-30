<?php
require_once __DIR__ . '/fpdf/fpdf.php';
require_once __DIR__ . '/db.php';

// Ajusta el tamaño de fuente del nombre para que no se salga de la celda
function ajustarFuenteNombreTabla($pdf, $nombre, $anchoCelda, $maxFont = 22, $minFont = 10)
{
    $fontSize = $maxFont;
    $pdf->SetFont('Arial', 'B', $fontSize);
    $nombreWidth = $pdf->GetStringWidth($nombre);
    while ($nombreWidth > ($anchoCelda - 2) && $fontSize > $minFont) {
        $fontSize--;
        $pdf->SetFont('Arial', 'B', $fontSize);
        $nombreWidth = $pdf->GetStringWidth($nombre);
    }
    // Si aún no cabe, recortar y agregar "..."
    if ($nombreWidth > ($anchoCelda - 2)) {
        $ellipsis = '...';
        $shortName = '';
        for ($i = 0; $i < strlen($nombre); $i++) {
            $shortName .= $nombre[$i];
            $pdf->SetFont('Arial', 'B', $fontSize);
            if ($pdf->GetStringWidth($shortName . $ellipsis) > ($anchoCelda - 2)) {
                break;
            }
        }
        $nombre = $shortName . $ellipsis;
    }
    return [$nombre, $fontSize];
}

// Obtener solo los productos seleccionados si se pasa ?ids=1,2,3
$ids = isset($_GET['ids']) ? explode(',', $_GET['ids']) : [];
$ids = array_filter(array_map('intval', $ids));
if ($ids) {
    $productos = array_filter(obtenerProductos(), function ($p) use ($ids) {
        return in_array($p['id'], $ids);
    });
} else {
    $productos = [];
}

// Ordenar productos por precio (parámetros GET: orden=paquete|mediopaquete|unidad, dir=asc|desc)
if (!empty($productos)) {
    // Detectar columnas con precio > 0 para decidir por cuál ordenar si la solicitada no aplica
    $hayP = $hayM = false;
    $hayU = true; // Unidad siempre existe según requerimiento
    foreach ($productos as $p) {
        if (isset($p['precio_venta_paquete']) && floatval($p['precio_venta_paquete']) > 0) $hayP = true;
        if (isset($p['precio_venta_mediopaquete']) && floatval($p['precio_venta_mediopaquete']) > 0) $hayM = true;
    }

    $orden = isset($_GET['orden']) ? strtolower($_GET['orden']) : 'paquete';
    // Por defecto ordenamos de menor a mayor (asc). Si se pasa dir=desc explicitamente, se usará descendente.
    $dir = (isset($_GET['dir']) && strtolower($_GET['dir']) === 'desc') ? 'desc' : 'asc';
    // Ajustar el campo de orden según disponibilidad
    if ($orden === 'paquete' && !$hayP) {
        $orden = $hayM ? 'mediopaquete' : 'unidad';
    } elseif ($orden === 'mediopaquete' && !$hayM) {
        $orden = $hayP ? 'paquete' : 'unidad';
    }

    $mapa = [
        'paquete' => 'precio_venta_paquete',
        'mediopaquete' => 'precio_venta_mediopaquete',
        'unidad' => 'precio_venta_unidad'
    ];
    $campo = isset($mapa[$orden]) ? $mapa[$orden] : 'precio_venta_unidad';

    usort($productos, function ($a, $b) use ($campo, $dir) {
        $va = isset($a[$campo]) && $a[$campo] !== '' ? floatval($a[$campo]) : 0.0;
        $vb = isset($b[$campo]) && $b[$campo] !== '' ? floatval($b[$campo]) : 0.0;
        if ($va == $vb) return 0;
        if ($dir === 'asc') {
            return ($va < $vb) ? -1 : 1;
        } else {
            return ($va > $vb) ? -1 : 1;
        }
    });
}

$pdf = new FPDF('P', 'mm', 'Letter');
$pdf->SetAutoPageBreak(true, 15);
$pdf->SetMargins(10, 15, 10);
$pdf->AddPage();

// Cabecera de la tabla (columnas dinámicas)

// Detectar qué columnas de precio existen entre los productos (precio > 0)
$hayPaquete = false;
$hayMedioPaquete = false;
$hayUnidad = true; // Unidad siempre existe según requerimiento
foreach ($productos as $p) {
    if (isset($p['precio_venta_paquete']) && floatval($p['precio_venta_paquete']) > 0) $hayPaquete = true;
    if (isset($p['precio_venta_mediopaquete']) && floatval($p['precio_venta_mediopaquete']) > 0) $hayMedioPaquete = true;
}

$pdf->SetFont('Arial', 'B', 14);

// Calcular anchuras dinámicas según columnas presentes
// Usar GetPageWidth() para evitar acceder a propiedades protegidas de FPDF.
// Márgenes establecidos más arriba con SetMargins(10,15,10) => 10mm izquierda/derecha.
$usableWidth = $pdf->GetPageWidth() - 10 - 10; // ancho de página menos márgenes
$numPrices = 0;
if ($hayPaquete) $numPrices++;
if ($hayMedioPaquete) $numPrices++;
if ($hayUnidad) $numPrices++;

// Reservar espacio para el nombre; ajustar en función de número de columnas de precio
if ($numPrices >= 3) {
    $nameWidth = 70;
} elseif ($numPrices == 2) {
    $nameWidth = 80;
} else {
    $nameWidth = 116; // deja espacio para una sola columna de precio
}

$priceWidth = floor(($usableWidth - $nameWidth));
// dividir uniformemente entre columnas de precio
if ($numPrices > 0) {
    $priceWidth = floor($priceWidth / $numPrices);
} else {
    $priceWidth = 40;
}

// Si solo existe la columna Unidad, hacer la tabla más estrecha (alineada a la izquierda)
$isSoloUnidad = (!$hayPaquete && !$hayMedioPaquete && $hayUnidad);
if ($isSoloUnidad) {
    $totalWidth = min($usableWidth, 140); // ancho total deseado cuando solo hay Unidad
    $nameWidth = floor($totalWidth * 0.65);
    $priceWidth = $totalWidth - $nameWidth;
}

// Cabecera: celda vacía para el nombre (sin línea izquierda ni superior)
$pdf->Cell($nameWidth, 10, '', 'RD', 0, 'C');
if ($hayPaquete) {
    $pdf->Cell($priceWidth, 10, 'Paquete', 1, 0, 'C');
}
if ($hayMedioPaquete) {
    $pdf->Cell($priceWidth, 10, 'Medio Paq.', 1, 0, 'C');
}
// Unidad siempre presente
$pdf->Cell($priceWidth, 10, 'Unidad', 1, 1, 'C');


// Función para formatear precios (sin decimales si es entero)
if (!function_exists('precio_fmt')) {
    function precio_fmt($valor, $moneda)
    {
        if ($valor === null || $valor === '') return '';
        $es_entero = (floatval($valor) == intval($valor));
        $fmt = $es_entero ? '%.0f' : '%.2f';
        $num = sprintf($fmt, $valor);
        return ($moneda === 'BS') ? $num . ' Bs' : '$' . $num;
    }
}

foreach ($productos as $p) {
    $nombre = utf8_decode($p['nombre']);
    $precio_paquete = (isset($p['precio_venta_paquete']) && floatval($p['precio_venta_paquete']) > 0)
        ? precio_fmt($p['precio_venta_paquete'], $p['moneda_compra']) : '';
    $precio_mediopaquete = (isset($p['precio_venta_mediopaquete']) && floatval($p['precio_venta_mediopaquete']) > 0)
        ? precio_fmt($p['precio_venta_mediopaquete'], $p['moneda_compra']) : '';
    $precio_unidad = (isset($p['precio_venta_unidad']) && floatval($p['precio_venta_unidad']) > 0)
        ? precio_fmt($p['precio_venta_unidad'], $p['moneda_compra']) : '';

    // Ajustar fuente del nombre según ancho de celda calculado
    list($nombreAjustado, $fontNombre) = ajustarFuenteNombreTabla($pdf, $nombre, $nameWidth, 22, 10);
    $pdf->SetFont('Arial', 'B', $fontNombre);
    $pdf->Cell($nameWidth, 14, $nombreAjustado, 1, 0, 'L');

    // Precios (usar mismas columnas y anchos que en cabecera)
    $pdf->SetFont('Arial', 'B', 26);
    $printed = 0;
    if ($hayPaquete) {
        $printed++;
        $pdf->Cell($priceWidth, 14, $precio_paquete, 1, ($printed == $numPrices ? 1 : 0), 'C');
    }
    if ($hayMedioPaquete) {
        $printed++;
        $pdf->Cell($priceWidth, 14, $precio_mediopaquete, 1, ($printed == $numPrices ? 1 : 0), 'C');
    }
    if ($hayUnidad) {
        $printed++;
        $pdf->Cell($priceWidth, 14, $precio_unidad, 1, ($printed == $numPrices ? 1 : 0), 'C');
    }
    // Restaurar fuente por si acaso
    $pdf->SetFont('Arial', '', 12);
}

$pdf->Output('I', 'precios_tabla.pdf');
