<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

/**
 * Endpoint para verificar la última versión disponible de la aplicación.
 * El campo "version_code" es el número después del "+" en pubspec.yaml (e.g. 1.1.0+2 -> 2)
 */

echo json_encode([
    "ok" => true,
    "latest_version" => "1.1.1",
    "latest_version_code" => 3,
    "download_url" => "https://ponciano.zz.com.ve/ventas247.apk",
    "release_notes" => "Nuevas funciones: Búsqueda por proveedor, gestión de fiados por cliente y cobranza automática vía WhatsApp.",
    "force_update" => false
]);
