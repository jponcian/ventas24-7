<?php
// notificar_optimus.php - Nueva Versión vía Base de Datos
header('Content-Type: application/json');

$numero_cliente = $_GET['numero'];
$sistema = "Ventas 24-7";
$motivo = "PRUEBA_SISTEMA";
$cuerpo = "🦾 Hola Javier, esta es una prueba de envío mediante base de datos. ¡El puente está funcionando!";

// Datos de conexión al MySQL de Optimus (DigitalOcean)
$host = '167.71.190.19';
$db   = 'whatsapp';
$user = 'whatsapp';
$pass = 'Whatsapp016.';

try {
    $conn = new mysqli($host, $user, $pass, $db);
    if ($conn->connect_error) { throw new Exception("Error de conexión: " . $conn->connect_error); }

    $stmt = $conn->prepare("INSERT INTO whatsapp (sistema, fecha, destinatario, motivo, cuerpo) VALUES (?, NOW(), ?, ?, ?)");
    $stmt->bind_param("ssss", $sistema, $numero_cliente, $motivo, $cuerpo);
    
    if ($stmt->execute()) {
        echo json_encode(["exito" => true, "mensaje" => "Orden insertada en la base de datos de Optimus."]);
    } else {
        echo json_encode(["exito" => false, "error" => $stmt->error]);
    }
    
    $stmt->close();
    $conn->close();

} catch (Exception $e) {
    echo json_encode(["exito" => false, "error" => $e->getMessage()]);
}
?>