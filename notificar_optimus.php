<?php
// notificar_optimus.php - Puente de prueba para el sistema
header('Content-Type: application/json');

$data = [
    "to" => "+584144679693",
    "message" => "🦾 ¡Toque recibido! Javier, el botón de prueba funcionó perfectamente. El sistema y yo ya estamos conectados.",
    "channel" => "whatsapp"
];

$ch = curl_init('http://167.71.190.19/v1/messages/send');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5); // Timeout de 5 segundos
curl_setopt($ch, CURLOPT_TIMEOUT, 10);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json',
    'Authorization: Bearer bd7db86de454d71848b32e784595f85130e6a484edf7cf19'
]);

$response = curl_exec($ch);
$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$curl_error = curl_error($ch);
curl_close($ch);

echo json_encode([
    "enviado" => ($http_code == 200),
    "error_detalle" => $curl_error,
    "http_code" => $http_code
]);
?>