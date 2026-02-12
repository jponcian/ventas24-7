<?php
// notificar_optimus.php - Usando Túnel Seguro Cloudflare
header('Content-Type: application/json');

$numero_cliente = $_GET['numero'] ?? '584144679693';
// Limpiar número: dejar solo dígitos
$numero_limpio = preg_replace('/[^0-9]/', '', $numero_cliente);
// Ajuste para Venezuela: Si empieza con 04.., quitar 0 y agregar 58
if (substr($numero_limpio, 0, 1) === '0') {
    $numero_limpio = '58' . substr($numero_limpio, 1);
}
$chatId = $numero_limpio . "@c.us";

$mensaje = "🦾 ¡PRUEBA EXITOSA! Javier, este mensaje pasó por el túnel seguro de Cloudflare desde ZZ hasta DigitalOcean. ¡Conexión blindada! 🚀";

// URL DEL TÚNEL SEGURO
$url = 'https://dropped-traveler-oliver-tiles.trycloudflare.com/api/sendText';
$api_key = 'Guarico2026!';

$data = [
    "chatId" => $chatId,
    "text" => $mensaje,
    "session" => "default"
];

$payload = json_encode($data);

$ch = curl_init($url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json',
    'X-Api-Key: ' . $api_key
]);

$response = curl_exec($ch);
$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$curl_error = curl_error($ch);
curl_close($ch);

echo json_encode([
    "exito" => ($http_code == 201 || $http_code == 200),
    "http_code" => $http_code,
    "respuesta_waha" => json_decode($response),
    "error_curl" => $curl_error
]);
?>