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

// Configuración para OpenClaw
$bot_data = [
    "to" => $telefono,
    "message" => $mensaje,
    "channel" => "whatsapp"
];

$ch = curl_init('http://167.71.190.19:18789/v1/messages/send');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($bot_data));
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json',
    'Authorization: Bearer bd7db86de454d71848b32e784595f85130e6a484edf7cf19'
]);

$response = curl_exec($ch);
$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$curl_error = curl_error($ch);
curl_close($ch);

if ($response === false) {
    echo json_encode([
        'ok' => false, 
        'error' => 'Error de conexión con el bot: ' . $curl_error
    ]);
} else {
    // Retornamos la respuesta del bot directamente o la procesamos
    $bot_res = json_decode($response, true);
    if ($http_code >= 200 && $http_code < 300) {
        echo json_encode(['ok' => true, 'bot_response' => $bot_res]);
    } else {
        echo json_encode(['ok' => false, 'error' => 'El bot respondió con error ' . $http_code, 'details' => $bot_res]);
    }
}
?>
