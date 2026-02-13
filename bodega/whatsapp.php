<?php
function enviarWhatsapp($numero, $cuerpo, $motivo = 'NOTIFICACION') {
    // Configuración de la API (Tomada de notificar_optimus.php)
    $url = 'http://167.71.190.19:3000/api/sendText';
    $api_key = 'Ponciano016';
    $session = 'default';

    // Limpiar número: dejar solo dígitos
    $numero_limpio = preg_replace('/[^0-9]/', '', $numero);
    
    // 1. Manejar formato con 0 inicial (0414...) -> Convertir a 58414...
    if (strpos($numero_limpio, '0') === 0) {
        $numero_limpio = '58' . substr($numero_limpio, 1);
    }
    
    // 2. Manejar formato sin código de país (414...) -> Convertir a 58414...
    // Un número de Venezuela sin código de país tiene 10 dígitos (ej: 4141234567)
    if (strlen($numero_limpio) == 10 && substr($numero_limpio, 0, 1) != '5') {
        $numero_limpio = '58' . $numero_limpio;
    }

    // 3. VALIDACIÓN ESTRICTA: El número final DEBE tener 12 dígitos y empezar por 58
    // Formato esperado: 58 4XX XXXXXXX
    if (strlen($numero_limpio) !== 12 || substr($numero_limpio, 0, 2) !== '58') {
        error_log("Número de WhatsApp inválido (debe ser Vzla 58...): " . $numero);
        return false;
    }
    
    // Asegurar formato chatId para WAHA
    $chatId = $numero_limpio . "@c.us";

    $data = [
        "chatId" => $chatId,
        "text" => $cuerpo,
        "session" => $session
    ];

    $payload = json_encode($data);

    try {
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Content-Type: application/json',
            'X-Api-Key: ' . $api_key
        ]);
        curl_setopt($ch, CURLOPT_TIMEOUT, 15); // Timeout de 15 segundos

        $response = curl_exec($ch);
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $curl_error = curl_error($ch);
        curl_close($ch);

        if ($curl_error) {
            error_log("Error cURL enviando WhatsApp: " . $curl_error);
            return false;
        }

        // Se considera exitoso si devuelve 200 o 201
        return ($http_code == 200 || $http_code == 201);

    } catch (Exception $e) {
        error_log("Error enviando WhatsApp Optimus REST: " . $e->getMessage());
        return false;
    }
}
?>
