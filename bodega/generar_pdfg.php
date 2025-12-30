<?php
require_once __DIR__ . '/fpdf/fpdf.php';
require_once __DIR__ . '/db.php';

// Clase para ajustar texto en celdas
class FPDF_CellFit extends FPDF
{
    function CellFit($w, $h = 0, $txt = '', $border = 0, $ln = 0, $align = '', $fill = false, $link = '', $scale = false, $force = true)
    {
        $str_width = $this->GetStringWidth($txt);
        if ($w == 0)
            $w = $this->w - $this->rMargin - $this->x;
        $ratio = ($w - $this->cMargin * 2) / $str_width;
        $fit = ($ratio < 1 || ($ratio > 1 && $force));
        if ($fit) {
            if ($scale) {
                $horiz_scale = $ratio * 100.0;
                $this->_out(sprintf('BT %.2F Tz ET', $horiz_scale));
            } else {
                $char_space = ($w - $this->cMargin * 2 - $str_width) / max(strlen($txt) - 1, 1) * $this->k;
                $this->_out(sprintf('BT %.2F Tc ET', $char_space));
            }
            $align = '';
        }
        $this->Cell($w, $h, $txt, $border, $ln, $align, $fill, $link);
        if ($fit)
            $this->_out('BT ' . ($scale ? '100 Tz' : '0 Tc') . ' ET');
    }
    function CellFitScale($w, $h = 0, $txt = '', $border = 0, $ln = 0, $align = '', $fill = false, $link = '')
    {
        $this->CellFit($w, $h, $txt, $border, $ln, $align, $fill, $link, true, false);
    }
}

// Obtener solo los productos seleccionados si se pasa ?ids=1,2,3
$ids = isset($_GET['ids']) ? explode(',', $_GET['ids']) : [];
$ids = array_filter(array_map('intval', $ids));
if ($ids) {
    $productos = array_filter(obtenerProductos(), function ($p) use ($ids) {
        return in_array($p['id'], $ids);
    });
} else {
    // Solo 27 artículos ordenados por created_at descendente
    $todos = obtenerProductos();
    usort($todos, function ($a, $b) {
        return strtotime($b['created_at']) - strtotime($a['created_at']);
    });
    $productos = array_slice($todos, 0, 24);
}

$pdf = new FPDF_CellFit('P', 'mm', 'Letter'); // Carta
$pdf->SetAutoPageBreak(true, 10);
$pdf->SetMargins(5, 10, 5); // margen lateral 5mm

$etiquetaAncho = 100.5; // mm (50% mas grande)
$etiquetaAlto = 41.58;  // mm (50% mas grande)
$espacioX = 0; // espacio horizontal entre etiquetas (unidos)
$espacioY = 0; // espacio vertical entre etiquetas
$cols = 2; // etiquetas por fila
$rows = 6; // etiquetas por columna

$pdf->AddPage();
$x0 = 5; // margen izquierdo
$y0 = 10; // margen superior
$x = $x0;
$y = $y0;
$col = 0;
$row = 0;

foreach ($productos as $idx => $p) {
    // Preparar líneas de contenido
    $nombre = utf8_decode($p['nombre']);
    $precios = [];
    $tieneUnidad = $p['precio_venta_unidad'] ? true : false;
    $tienePaquete = $p['precio_venta_paquete'] ? true : false;
    $fmt = function ($n) {
        return (fmod($n, 1) == 0) ? number_format($n, 0) : number_format($n, 2);
    };
    if ($p['moneda_compra'] === 'BS') {
        if ($tieneUnidad && $tienePaquete) {
            $precios[] = 'c/u: ' . $fmt($p['precio_venta_unidad']) . ' Bs';
            $precios[] = 'Paq: ' . $fmt($p['precio_venta_paquete']) . ' Bs';
        } elseif ($tieneUnidad) {
            $precios[] = $fmt($p['precio_venta_unidad']) . ' Bs';
        } elseif ($tienePaquete) {
            $precios[] = $fmt($p['precio_venta_paquete']) . ' Bs';
        }
    } else {
        if ($tieneUnidad && $tienePaquete) {
            $precios[] = 'c/u: $' . $fmt($p['precio_venta_unidad']);
            $precios[] = 'Paq: $' . $fmt($p['precio_venta_paquete']);
        } elseif ($tieneUnidad) {
            $precios[] = '$' . $fmt($p['precio_venta_unidad']);
        } elseif ($tienePaquete) {
            $precios[] = '$' . $fmt($p['precio_venta_paquete']);
        }
    }
    $totalLineas = 1 + count($precios);
    // Si hay ambos precios, aumentar el salto de línea para que no se toquen
    if (count($precios) > 1) {
        $lineHeight = 9; // más separados (1.5x)
        $contentHeight = 24 + ($totalLineas - 1) * $lineHeight;
        $offsetY = 0;
        if ($contentHeight > $etiquetaAlto) {
            $offsetY = 0;
        }
    } else {
        $lineHeight = 13.5; // interlineado normal (1.5x)
        $contentHeight = 24 + ($totalLineas - 1) * $lineHeight;
        $offsetY = ($etiquetaAlto - $contentHeight) / 2;
    }
    // Dibuja recuadro
    $pdf->SetDrawColor(100, 100, 100);
    $pdf->Rect($x, $y, $etiquetaAncho, $etiquetaAlto);

    $maxFont = 45;
    $minFont = 27;
    $fontSize = $maxFont;
    $pdf->SetFont('Arial', 'B', $fontSize);
    $nombreWidth = $pdf->GetStringWidth($nombre);
    while ($nombreWidth > ($etiquetaAncho - 2) && $fontSize > $minFont) {
        $fontSize--;
        $pdf->SetFont('Arial', 'B', $fontSize);
        $nombreWidth = $pdf->GetStringWidth($nombre);
    }
    $pdf->SetTextColor(30, 64, 175);
    $pdf->SetXY($x, $y + $offsetY - 1.5); // Subir 1.5mm

    if (mb_strlen(trim($p['nombre'])) >= 11) {
        $pdf->CellFit($etiquetaAncho, 18, $nombre, 0, 2, 'C');
    } else {
        $pdf->Cell($etiquetaAncho, 18, $nombre, 0, 2, 'C');
    }

    foreach ($precios as $linea) {
        if (preg_match('/^(c\/u:|Paq:) (\$?\d+[\.,]\d{2}.*)$/i', $linea, $m)) {
            $label = $m[1];
            $precio = $m[2];
        } else {
            $label = '';
            $precio = $linea;
        }
        if ($label) {
            $pdf->SetFont('Arial', '', 21);
            $pdf->SetTextColor(80, 80, 80);
            $pdf->SetXY($x, $pdf->GetY());
            $pdf->Cell(27, $lineHeight + 3, utf8_decode($label), 0, 0, 'R');
            $pdf->SetFont('Arial', 'B', 40);
            $pdf->SetTextColor(0, 0, 0);
            $pdf->Cell($etiquetaAncho - 27, $lineHeight + 3, utf8_decode($precio), 0, 1, 'L');
        } else {
            if (count($precios) === 1 && $tieneUnidad && !$tienePaquete && strpos($precio, '$') === 0) {
                $valor = substr($precio, 1);
                $pdf->SetFont('Arial', '', 25);
                $anchoSimbolo = $pdf->GetStringWidth('$');
                $pdf->SetFont('Arial', 'B', 84);
                $anchoValor = $pdf->GetStringWidth($valor);
                $anchoTotal = $anchoSimbolo + $anchoValor + 3;
                $xCentrado = $x + ($etiquetaAncho - $anchoTotal) / 2;
                $yActual = $pdf->GetY() + 0.75;
                $pdf->SetXY($xCentrado, $yActual);
                $pdf->SetFont('Arial', '', 25);
                $pdf->SetTextColor(80, 80, 80);
                $pdf->Cell($anchoSimbolo, $lineHeight + 3, '$', 0, 0, 'L');
                $pdf->SetFont('Arial', 'B', 84);
                $pdf->SetTextColor(0, 0, 0);
                $pdf->Cell($anchoValor, $lineHeight + 3, $valor, 0, 1, 'L');
            } else {
                if (count($precios) === 1 && $tieneUnidad && !$tienePaquete) {
                    $pdf->SetFont('Arial', 'B', 72);
                } else {
                    $pdf->SetFont('Arial', 'B', 40);
                }
                $pdf->SetTextColor(0, 0, 0);
                $pdf->SetXY($x, $pdf->GetY());
                $pdf->Cell($etiquetaAncho, $lineHeight + 3, utf8_decode($precio), 0, 1, 'C');
            }
        }
    }

    $col++;
    if ($col >= $cols) {
        $col = 0;
        $x = $x0;
        $row++;
        $y += $etiquetaAlto + $espacioY;

        if ($row >= $rows && ($idx + 1) < count($productos)) {
            $pdf->AddPage();
            $y = $y0;
            $row = 0;
        }
    } else {
        $x += $etiquetaAncho + $espacioX;
    }
}

$pdf->Output('I', 'etiquetas_productos_grandes.pdf');
