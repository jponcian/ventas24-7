<?php
// actualizar_tasa_bcv.php - Descarga y guarda la tasa oficial USD/VES del BCV
// Uso: php actualizar_tasa_bcv.php

require __DIR__ . '/db.php';

// Primero, verificar si ya existe una tasa para el día actual (optimización)
$fecha_hoy = date('Y-m-d');
$stmt = $db->prepare("SELECT COUNT(*) FROM tasas_cambio WHERE fecha = ?");
$stmt->execute([$fecha_hoy]);
$existe_hoy = $stmt->fetchColumn();
if ($existe_hoy) {
    // Ya existe para hoy, terminar silenciosamente
    exit(0);
}

// Descargar y procesar la página solo si no existe para hoy
$url = 'https://www.bcv.org.ve/';
$html = null;

// Preferir file_get_contents si está disponible (con User-Agent y timeout)
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
    if ($html === false) {
        $err = error_get_last();
        // file_get_contents falló; se puede revisar $err['message'] para más detalle si se registra
    }
}

// Si file_get_contents no obtuvo contenido, intentar con cURL y mostrar errores para depuración
if (empty($html) && function_exists('curl_version')) {
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 15);
    // Agregar User-Agent para evitar bloqueos simples
    curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)');

    // --- INICIO DE CAMBIO PARA DEPURACIÓN ---
    // Descomenta la siguiente línea SOLO si ves un error SSL y quieres confirmar que esa es la causa.
    // ADVERTENCIA: Desactivar esto es inseguro y no se recomienda en un entorno de producción.
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    // --- FIN DE CAMBIO PARA DEPURACIÓN ---

    // Obtener headers HTTP para diagnóstico
    curl_setopt($ch, CURLOPT_HEADER, false);
    $html = curl_exec($ch);
    $curlErr = curl_error($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if ($html === false || $httpCode >= 400 || trim($html) === '') {
        // Error fatal: detener silenciosamente para permitir manejo externo
        exit(1);
    }
}

if (empty($html)) {
    // No se pudo descargar la página
    exit(1);
}

// Parsear HTML de forma robusta: buscar el bloque con id 'dolar' o buscar el span que contiene 'USD' y obtener el siguiente <strong>
$valor = null;
$fecha = null;
libxml_use_internal_errors(true);
$dom = new DOMDocument();
if ($dom->loadHTML($html)) {
    $xpath = new DOMXPath($dom);
    // 1) Intentar por id 'dolar'
    $nodes = $xpath->query("//*[@id='dolar']");
    if ($nodes->length > 0) {
        $node = $nodes->item(0);
        $strongNodes = $xpath->query('.//strong', $node);
        if ($strongNodes->length > 0) {
            $raw = trim($strongNodes->item(0)->textContent);
            // Reemplazar comas por punto y limpiar
            $raw = preg_replace('/[^0-9,\.]/', '', $raw);
            $raw = str_replace(',', '.', $raw);
            if (is_numeric($raw)) $valor = $raw;
        }
    }

    // 2) Si no se encontró, intentar buscar <span>USD</span> y tomar el siguiente <strong>
    if (!$valor) {
        $spanNodes = $xpath->query("//span[text()[contains(.,'USD')]]");
        if ($spanNodes->length > 0) {
            $span = $spanNodes->item(0);
            // buscar el siguiente <strong> en el documento (following)
            $strongFollowing = $xpath->query('following::strong[1]', $span);
            if ($strongFollowing->length > 0) {
                $raw = trim($strongFollowing->item(0)->textContent);
                $raw = preg_replace('/[^0-9,\.]/', '', $raw);
                $raw = str_replace(',', '.', $raw);
                if (is_numeric($raw)) $valor = $raw;
            }
        }
    }

    // 3) Extraer la fecha del atributo content del span.date-display-single si existe
    $fechaAttr = $xpath->query("//span[contains(@class,'date-display-single')]/@content");
    if ($fechaAttr->length > 0) {
        $attr = $fechaAttr->item(0)->nodeValue;
        // El atributo content puede contener fecha y hora: 2025-10-29T00:00:00-04:00
        // Extraer solo la parte YYYY-MM-DD
        if (preg_match('/^(\d{4}-\d{2}-\d{2})/', $attr, $m)) {
            $fecha = $m[1];
        }
    }
}
libxml_clear_errors();

// Si no se obtuvo fecha, usar la fecha de hoy como fallback
if (!$fecha) $fecha = $fecha_hoy;

// Si no se obtuvo valor, terminar
if (!$valor) {
    exit(1);
}

// Verificar si ya existe una tasa para la fecha de la tasa que se intenta agregar
$stmt = $db->prepare("SELECT COUNT(*) FROM tasas_cambio WHERE fecha = ?");
$stmt->execute([$fecha]);
$existe = $stmt->fetchColumn();
if ($existe) {
    // Ya existe para la fecha de la tasa, terminar silenciosamente
    exit(0);
}

// Guardar en la base de datos solo si no existe para esa fecha
$stmt = $db->prepare("INSERT INTO tasas_cambio (fecha, valor) VALUES (?, ?)");
$stmt->execute([$fecha, $valor]);
