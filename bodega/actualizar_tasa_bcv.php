<?php
// actualizar_tasa_bcv.php - Descarga y guarda la tasa oficial USD/VES del BCV
// Ahora usa la BD externa javier_ponciano_5 (igual que api/tasa.php)

// Configuración BDD Externa
$db5_host = 'localhost';
$db5_name = 'javier_ponciano_5';
$db5_user = 'somos';
$db5_pass = 'Somossalud016.';

try {
    $db5 = new PDO("mysql:host=$db5_host;dbname=$db5_name;charset=utf8mb4", $db5_user, $db5_pass);
    $db5->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Verificar si ya existe una tasa para hoy
    $fecha_hoy = date('Y-m-d');
    $stmt = $db5->prepare("SELECT COUNT(*) FROM exchange_rates WHERE date = ? AND source = 'BCV'");
    $stmt->execute([$fecha_hoy]);
    $existe_hoy = $stmt->fetchColumn();
    
    if ($existe_hoy) {
        // Ya existe para hoy, terminar silenciosamente
        exit(0);
    }

    // Descargar y procesar la página solo si no existe para hoy
    $url = 'https://www.bcv.org.ve/';
    $html = null;

    // Preferir file_get_contents si está disponible
    if (ini_get('allow_url_fopen')) {
        $opts = [
            'http' => [
                'method' => 'GET',
                'header' => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)\r\n",
                'timeout' => 15
            ]
        ];
        $context = stream_context_create($opts);
        $html = @file_get_contents($url, false, $context);
    }

    // Si file_get_contents no obtuvo contenido, intentar con cURL
    if (empty($html) && function_exists('curl_version')) {
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 15);
        curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)');
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_HEADER, false);
        $html = curl_exec($ch);
        $curlErr = curl_error($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($html === false || $httpCode >= 400 || trim($html) === '') {
            exit(1);
        }
    }

    if (empty($html)) {
        exit(1);
    }

    // Parsear HTML
    $valor = null;
    $fecha = null;
    libxml_use_internal_errors(true);
    $dom = new DOMDocument();
    if ($dom->loadHTML($html)) {
        $xpath = new DOMXPath($dom);
        
        // Intentar por id 'dolar'
        $nodes = $xpath->query("//*[@id='dolar']");
        if ($nodes->length > 0) {
            $node = $nodes->item(0);
            $strongNodes = $xpath->query('.//strong', $node);
            if ($strongNodes->length > 0) {
                $raw = trim($strongNodes->item(0)->textContent);
                $raw = preg_replace('/[^0-9,\.]/', '', $raw);
                $raw = str_replace(',', '.', $raw);
                if (is_numeric($raw)) $valor = $raw;
            }
        }

        // Si no se encontró, intentar buscar <span>USD</span>
        if (!$valor) {
            $spanNodes = $xpath->query("//span[text()[contains(.,'USD')]]");
            if ($spanNodes->length > 0) {
                $span = $spanNodes->item(0);
                $strongFollowing = $xpath->query('following::strong[1]', $span);
                if ($strongFollowing->length > 0) {
                    $raw = trim($strongFollowing->item(0)->textContent);
                    $raw = preg_replace('/[^0-9,\.]/', '', $raw);
                    $raw = str_replace(',', '.', $raw);
                    if (is_numeric($raw)) $valor = $raw;
                }
            }
        }

        // Extraer la fecha
        $fechaAttr = $xpath->query("//span[contains(@class,'date-display-single')]/@content");
        if ($fechaAttr->length > 0) {
            $attr = $fechaAttr->item(0)->nodeValue;
            if (preg_match('/^(\d{4}-\d{2}-\d{2})/', $attr, $m)) {
                $fecha = $m[1];
            }
        }
    }
    libxml_clear_errors();

    // Si no se obtuvo fecha, usar la fecha de hoy
    if (!$fecha) $fecha = $fecha_hoy;

    // Si no se obtuvo valor, terminar
    if (!$valor) {
        exit(1);
    }

    // Verificar si ya existe una tasa para la fecha extraída
    $stmt = $db5->prepare("SELECT COUNT(*) FROM exchange_rates WHERE date = ? AND source = 'BCV'");
    $stmt->execute([$fecha]);
    $existe = $stmt->fetchColumn();
    
    if ($existe) {
        exit(0);
    }

    // Guardar en la base de datos externa
    $stmt = $db5->prepare("INSERT INTO exchange_rates (date, rate, source, `from`, `to`, created_at, updated_at) VALUES (?, ?, 'BCV', 'USD', 'VES', NOW(), NOW())");
    $stmt->execute([$fecha, $valor]);

} catch (Exception $e) {
    // Error silencioso
    exit(1);
}
?>
