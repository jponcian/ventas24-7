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
    $productos = array_slice($todos, 0, 27);
}

$pdf = new FPDF_CellFit('P', 'mm', 'Letter'); // Carta
// Desactivar salto de página automático para evitar desorden del grid
$pdf->SetAutoPageBreak(false);
$pdf->SetMargins(5, 10, 5); // margen lateral 5mm

$etiquetaAncho = 67; // mm (ajustado para 3 por fila)
$etiquetaAlto = round(36 * 0.7 * 1.1, 2);  // mm (30% más bajo + 10% más alto)
$espacioX = 0; // espacio horizontal entre etiquetas (unidos)
$espacioY = 0; // espacio vertical entre etiquetas
$cols = 3; // etiquetas por fila
$rows = 9; // etiquetas por columna (2 más)

$pdf->AddPage();
$pdf->SetXY(5, 10);
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
        $lineHeight = 6; // más separados
        $contentHeight = 16 + ($totalLineas - 1) * $lineHeight;
        $offsetY = 0; // sube todo el bloque al tope de la ficha
        // Si el bloque se sale, ajusta para que no se salga
        if ($contentHeight > $etiquetaAlto) {
            $offsetY = 0;
        }
    } else {
        $lineHeight = 9; // interlineado normal
        $contentHeight = 16 + ($totalLineas - 1) * $lineHeight;
        $offsetY = ($etiquetaAlto - $contentHeight) / 2;
    }
    // Dibuja recuadro
    $pdf->SetDrawColor(100, 100, 100);
    $pdf->Rect($x, $y, $etiquetaAncho, $etiquetaAlto);
    // Nombre más grande, centrado, con ajuste por longitud
    // Ajuste automático de tamaño de fuente para que el nombre quepa en el ancho
    $maxFont = 30;
    $minFont = 18;
    $fontSize = $maxFont;
    $pdf->SetFont('Arial', 'B', $fontSize);
    $nombreWidth = $pdf->GetStringWidth($nombre);
    while ($nombreWidth > ($etiquetaAncho - 2) && $fontSize > $minFont) {
        $fontSize--;
        $pdf->SetFont('Arial', 'B', $fontSize);
        $nombreWidth = $pdf->GetStringWidth($nombre);
    }
    $pdf->SetTextColor(30, 64, 175);
    $pdf->SetXY($x, $y + $offsetY - 1); // Subir 1mm
    // Usar CellFit solo si el nombre tiene 11 o más caracteres, si no usar Cell normal
    if (mb_strlen(trim($p['nombre'])) >= 11) {
        $pdf->CellFit($etiquetaAncho, 12, $nombre, 0, 2, 'C');
    } else {
        $pdf->Cell($etiquetaAncho, 12, $nombre, 0, 2, 'C');
    }
    // Precios: abreviatura pequeña, precio grande
    foreach ($precios as $linea) {
        // Si hay ambos precios, mostrar prefijo; si solo uno, solo el valor
        if (preg_match('/^(c\\/u:|Paq:) (\\$?\\d+[\\.,]\\d{2}.*)$/i', $linea, $m)) {
            $label = $m[1];
            $precio = $m[2];
        } else {
            $label = '';
            $precio = $linea;
        }
        if ($label) {
            $pdf->SetFont('Arial', '', 14); // Abreviatura pequeña
            $pdf->SetTextColor(80, 80, 80);
            $pdf->SetXY($x, $pdf->GetY());
            $pdf->Cell(18, $lineHeight + 2, utf8_decode($label), 0, 0, 'R');
            $pdf->SetFont('Arial', 'B', 27); // Precio grande
            $pdf->SetTextColor(0, 0, 0);
            $pdf->Cell($etiquetaAncho - 18, $lineHeight + 2, utf8_decode($precio), 0, 1, 'L');
        } else {
            // Si solo hay un precio y es unitario en dólares, mostrar $ pequeño y valor grande, centrados
            if (count($precios) === 1 && $tieneUnidad && !$tienePaquete && strpos($precio, '$') === 0) {
                $valor = substr($precio, 1);
                $pdf->SetFont('Arial', '', 17); // 30% de 56 ≈ 17
                $anchoSimbolo = $pdf->GetStringWidth('$');
                $pdf->SetFont('Arial', 'B', 56);
                $anchoValor = $pdf->GetStringWidth($valor);
                $anchoTotal = $anchoSimbolo + $anchoValor + 2;
                $xCentrado = $x + ($etiquetaAncho - $anchoTotal) / 2;
                $yActual = $pdf->GetY() + 0.5; // bajar medio milímetro
                $pdf->SetXY($xCentrado, $yActual);
                $pdf->SetFont('Arial', '', 17);
                $pdf->SetTextColor(80, 80, 80);
                $pdf->Cell($anchoSimbolo, $lineHeight + 2, '$', 0, 0, 'L');
                $pdf->SetFont('Arial', 'B', 56);
                $pdf->SetTextColor(0, 0, 0);
                $pdf->Cell($anchoValor, $lineHeight + 2, $valor, 0, 1, 'L');
            } else {
                if (count($precios) === 1 && $tieneUnidad && !$tienePaquete) {
                    $pdf->SetFont('Arial', 'B', 48);
                } else {
                    $pdf->SetFont('Arial', 'B', 27);
                }
                $pdf->SetTextColor(0, 0, 0);
                $pdf->SetXY($x, $pdf->GetY());
                $pdf->Cell($etiquetaAncho, $lineHeight + 2, utf8_decode($precio), 0, 1, 'C');
            }
        }
    }
    // Siguiente posición
    $col++;
    if ($col >= $cols) {
        $col = 0;
        $x = $x0;
        $row++;
        $y += $etiquetaAlto + $espacioY;
        // Solo agregar nueva página si quedan productos por imprimir
        if ($row >= $rows && ($idx + 1) < count($productos)) {
            $pdf->AddPage();
            $y = $y0;
            $row = 0;
        }
    } else {
        $x += $etiquetaAncho + $espacioX;
    }
}

$pdf->Output('I', 'etiquetas_productos.pdf');
