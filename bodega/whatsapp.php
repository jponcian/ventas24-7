<?php
function enviarWhatsapp($numero, $cuerpo, $motivo = 'NOTIFICACION') {
    $host = '167.71.190.19';
    $db_name   = 'whatsapp';
    $user = 'whatsapp';
    $pass = 'Whatsapp016.';
    $sistema = "Ventas 24-7";

    try {
        // Conexión independiente para no interferir con la DB local
        $connRemote = new PDO("mysql:host=$host;dbname=$db_name;charset=utf8mb4", $user, $pass);
        $connRemote->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        $sql = "INSERT INTO whatsapp (sistema, fecha, destinatario, motivo, cuerpo) VALUES (?, NOW(), ?, ?, ?)";
        $stmt = $connRemote->prepare($sql);
        $stmt->execute([$sistema, $numero, $motivo, $cuerpo]);
        
        // Cerrar conexión explícitamente
        $connRemote = null;
        return true;
    } catch (Exception $e) {
        // En producción podrías querer guardar este error en un log local
        error_log("Error enviando WhatsApp Optimus: " . $e->getMessage());
        return false;
    }
}
?>
