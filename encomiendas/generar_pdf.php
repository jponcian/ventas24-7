<?php
require('fpdf/fpdf.php');

// Obtener datos del formulario
$id_destinatario = $_POST['id_destinatario'];
$id_autorizado = $_POST['id_autorizado'];
$guia = $_POST['track'];
if (trim($guia) === '') {
    $guia = str_repeat('_', 20);
}

// Conexión a la base de datos para obtener nombres y cédulas
include 'conexion.php';
// Obtener destinatario
$consulta_dest = "SELECT * FROM usuarios WHERE id = $id_destinatario";
$result_dest = mysqli_query($conn, $consulta_dest);
$destinatario = mysqli_fetch_assoc($result_dest);

// Obtener autorizado
$consulta_aut = "SELECT * FROM usuarios WHERE id = $id_autorizado";
$result_aut = mysqli_query($conn, $consulta_aut);
$autorizado = mysqli_fetch_assoc($result_aut);
// Crear PDF con márgenes personalizados
$pdf = new FPDF();
$pdf->AddPage('P', 'Letter');
$pdf->SetMargins(30, 40, 30); // izquierda, arriba, derecha
$pdf->SetAutoPageBreak(true, 10); // margen inferior (abajo)
$pdf->Ln(20);

// Fecha arriba a la derecha
//setlocale(LC_TIME, 'es_ES.UTF-8', 'Spanish_Spain', 'Spanish');
$formato = new IntlDateFormatter(
    'es_ES', // Configuración regional (español de España)
    IntlDateFormatter::LONG, // Estilo para la fecha
    IntlDateFormatter::NONE, // Estilo para la hora
    'America/Caracas', // Zona horaria
    IntlDateFormatter::GREGORIAN // Calendario
);

$fecha_formateada = $formato->format(new DateTime());
$pdf->SetFont('Arial', '', 11);
$pdf->Cell(0, 10, ($fecha_formateada), 0, 0, 'R');
$pdf->Ln(20);

$pdf->SetFont('Arial', 'B', 14);
$pdf->Cell(0, 10, utf8_decode('AUTORIZACIÓN PARA RETIRAR UN PAQUETE'), 0, 1, 'C');
$pdf->Ln(10);

$pdf->SetFont('Arial', '', 12);
$texto = "Yo, " . $destinatario['nombre'] . ", titular de la cedula de identidad " . number_format($destinatario['cedula'], 0, '', '.') .
    ", autorizo a " . $autorizado['nombre'] . ", titular de la cedula de identidad " . number_format($autorizado['cedula'], 0, '', '.') .
    ", el retiro de la (as) encomienda (as) bajo el número de guía (tracking): " . $guia .
    " debido a que no tengo la posibilidad de trasladarme personalmente a retirar la encomienda por motivo ajeno a mi voluntad.";

$pdf->MultiCell(0, 8, utf8_decode($texto));
$pdf->Ln(10);

$pdf->SetFont('Arial', '', 11);
$pdf->SetTextColor(220, 53, 69); // Rojo Bootstrap
$pdf->MultiCell(0, 8, utf8_decode(
    "Nota: Anexo a este documento se presenta fotocopia de la cédula de identidad del destinatario y de la persona autorizada que lo va a retirar."
));


$pdf->Ln(20);
$pdf->SetTextColor(0, 0, 0); // Restablece color negro
$pdf->SetFont('Arial', '', 12);

// Línea para firma del destinatario
$pdf->Cell(70, 10, '________________________', 0, 0, 'C');
$pdf->Cell(10, 10, '', 0, 0); // Espacio entre firmas
$pdf->Cell(70, 10, '________________________', 0, 1, 'C');

// Nombres debajo de las líneas
$pdf->Cell(70, 8, utf8_decode($destinatario['nombre']), 0, 0, 'C');
$pdf->Cell(10, 8, '', 0, 0);
$pdf->Cell(70, 8, utf8_decode($autorizado['nombre']), 0, 1, 'C');

// Roles debajo de los nombres
$pdf->Cell(70, 8, 'Destinatario', 0, 0, 'C');
$pdf->Cell(10, 8, '', 0, 0);
$pdf->Cell(70, 8, 'Autorizado', 0, 1, 'C');

// Teléfonos debajo de los roles
$pdf->SetFont('Arial', '', 10);
$pdf->Cell(70, 7, 'Tel: ' . $destinatario['telefono'], 0, 0, 'C');
$pdf->Cell(10, 7, '', 0, 0);
$pdf->Cell(70, 7, 'Tel: ' . $autorizado['telefono'], 0, 1, 'C');

$pdf->SetFont('Arial', '', 12);

// Imágenes debajo de las firmas
$pdf->Ln(5);
$y = $pdf->GetY();
$pdf->Image($destinatario['foto'], 35, $y, 60, 40);
$pdf->Image($autorizado['foto'], 117, $y, 60, 40);

// Pie de página tipo marca de agua
$pdf->SetY(-25); // 25mm desde abajo
$pdf->SetFont('Arial', 'I', 10);
$pdf->SetTextColor(180, 180, 180);
$pdf->Cell(0, 10, utf8_decode('Generado en http://aut-encomiendas.zz.com.ve/'), 0, 0, 'C');

$pdf->Output('I', 'autorizacion.pdf');
