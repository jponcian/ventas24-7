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

// Si no hay mensaje personalizado, usar la plantilla del bot
if ($mensaje_custom) {
    $mensaje = $mensaje_custom;
} else {
    $mensaje = "Hola $cliente, te saluda la Bodega de Javier. Te informamos que tu saldo pendiente es de *$deuda USD*. ¡Feliz día!";
}

// Usar la nueva función de envío por base de datos
require_once __DIR__ . '/../whatsapp.php';

// El motivo para este tipo de mensajes
$motivo = "COBRANZA";

if (enviarWhatsapp($telefono, $mensaje, $motivo)) {
    echo json_encode(['ok' => true, 'mensaje' => 'Enviado a la cola de Optimus']);
} else {
    echo json_encode(['ok' => false, 'error' => 'Error al insertar en DB externa']);
}
?>
