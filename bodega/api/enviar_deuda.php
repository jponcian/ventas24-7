<?php
// enviar_deuda.php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Obtener datos (soporta JSON y Form Data)
$data = json_decode(file_get_contents('php://input'), true);
if (!$data) {
    $data = $_POST;
}

$telefono = $data['telefono'] ?? null;
$cliente = $data['cliente'] ?? '';
$deuda = $data['deuda'] ?? '0.00';
$mensaje_custom = $data['mensaje'] ?? null;

if (!$telefono) {
    echo json_encode(['ok' => false, 'error' => 'telefono_requerido']);
    exit;
}

// Limpiar número de teléfono para el bot
$telefono = preg_replace('/[^\d]/', '', $telefono);
if (strlen($telefono) > 0 && substr($telefono, 0, 2) !== '58') {
    $telefono = '58' . ltrim($telefono, '0');
}

// Si no hay mensaje personalizado, usar la plantilla amigable
if ($mensaje_custom) {
    $mensaje = $mensaje_custom;
} else {
    $mensaje = "🏪 *SuperBodega* 🏪\n\n¡Hola, *$cliente*! Esperamos que estés teniendo un excelente día. 😊\n\nTe escribimos para recordarte que mantienes un saldo pendiente de *$deuda USD*. \n\nRecuerda que puedes pasar por la tienda cuando gustes para ponerte al día. Valoramos mucho tu confianza en nosotros. 🙌\n\n¡Muchas gracias por tu preferencia! ✨";
}

// Usar la nueva función de envío por base de datos
require_once __DIR__ . '/../whatsapp.php';

// El motivo para este tipo de mensajes
$motivo = "COBRANZA";

$resultado = enviarWhatsapp($telefono, $mensaje, $motivo);

if ($resultado['success']) {
    echo json_encode(['ok' => true, 'mensaje' => 'Notificación enviada con éxito']);
} else {
    echo json_encode(['ok' => false, 'error' => $resultado['error'] ?? 'El servicio de WhatsApp no está disponible']);
}
?>
