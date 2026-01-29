<?php
require('fpdf/fpdf.php');
require('db.php');

class PDF extends FPDF
{
    function Header()
    {
        // Logo
        if (file_exists('logo.png')) {
            $this->Image('logo.png', 10, 6, 30);
        }
        $this->SetFont('Arial', 'B', 15);
        $this->Cell(80);
        $this->Cell(30, 10, utf8_decode('Lista de Precios'), 0, 0, 'C');
        $this->Ln(20);

        // Encabezados de tabla
        $this->SetFont('Arial', 'B', 10);
        $this->SetFillColor(200, 220, 255);
        
        $this->Cell(40, 10, utf8_decode('Código'), 1, 0, 'C', true);
        $this->Cell(90, 10, 'Producto', 1, 0, 'C', true);
        $this->Cell(30, 10, 'Precio Unid ($)', 1, 0, 'C', true);
        $this->Cell(30, 10, 'Precio Pqt ($)', 1, 0, 'C', true);
        $this->Ln();
    }

    function Footer()
    {
        $this->SetY(-15);
        $this->SetFont('Arial', 'I', 8);
        $this->Cell(0, 10, utf8_decode('Página ') . $this->PageNo(), 0, 0, 'C');
    }
}

// Obtener productos ordenados por nombre
$stmt = $db->query("SELECT * FROM productos ORDER BY nombre ASC");
$productos = $stmt->fetchAll(PDO::FETCH_ASSOC);

$pdf = new PDF();
$pdf->AliasNbPages();
$pdf->AddPage();
$pdf->SetFont('Arial', '', 10);

foreach ($productos as $row) {
    $nombre = substr($row['nombre'], 0, 50); // Truncar si es muy largo visualmente
    $codigo = $row['codigo_barras'] ?? '-';
    $precioU = number_format($row['precio_venta_unidad'], 2);
    $precioP = number_format($row['precio_venta_paquete'], 2);

    // Ajuste de altura para celdas
    $h = 10;
    
    $pdf->Cell(40, $h, utf8_decode($codigo), 1);
    $pdf->Cell(90, $h, utf8_decode($nombre), 1);
    $pdf->Cell(30, $h, $precioU, 1, 0, 'R');
    $pdf->Cell(30, $h, $precioP, 1, 0, 'R');
    $pdf->Ln();
}

$pdf->Output();
?>
