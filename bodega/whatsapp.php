<?php
function enviarWhatsapp($numero, $cuerpo, $motivo = 'NOTIFICACION') {
    // Configuración de la API (Tomada de notificar_optimus.php)
    $url = 'http://164.90.145.35/api/sendText';
    $api_key = 'optimus';
    $session = 'default';

    // Limpiar número: dejar solo dígitos
    $numero_limpio = preg_replace('/[^0-9]/', '', $numero);
    
    // 1. Manejar formato con 0 inicial (0414...) -> Convertir a 58414...
    if (strpos($numero_limpio, '0') === 0) {
        $numero_limpio = '58' . substr($numero_limpio, 1);
    }
    
    // 2. Manejar formato 580... (común error) -> Convertir a 58...
    if (strpos($numero_limpio, '580') === 0) {
        $numero_limpio = '58' . substr($numero_limpio, 3);
    }

    // 3. Manejar formato sin código de país (414... o 412... 10 dígitos) -> Convertir a 58414...
    if (strlen($numero_limpio) == 10 && (substr($numero_limpio, 0, 1) == '4' || substr($numero_limpio, 0, 1) == '2')) {
        $numero_limpio = '58' . $numero_limpio;
    }

    // 4. VALIDACIÓN FINAL: El número debe tener 12 dígitos y empezar por 58 (Venezuela)
    if (strlen($numero_limpio) !== 12 || substr($numero_limpio, 0, 2) !== '58') {
        error_log("Número de WhatsApp inválido (debe ser Vzla 58...): " . $numero . " (Limpio: $numero_limpio)");
        return [
            'success' => false,
            'error' => 'Formato de número inválido. Debe ser 584XXXXXXXXX'
        ];
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
            return [
                'success' => false, 
                'error' => "Error de conexión: " . $curl_error
            ];
        }

        if ($http_code == 200 || $http_code == 201) {
            return [
                'success' => true,
                'response' => json_decode($response, true)
            ];
        } else {
            error_log("Error API WhatsApp (HTTP $http_code): " . $response);
            return [
                'success' => false,
                'error' => "Error del servidor (HTTP $http_code): " . $response
            ];
        }

    } catch (Exception $e) {
        error_log("Error enviando WhatsApp: " . $e->getMessage());
        return [
            'success' => false,
            'error' => $e->getMessage()
        ];
    }
}
?>
