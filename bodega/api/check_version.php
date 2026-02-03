<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

/**
 * Endpoint para verificar la última versión disponible de la aplicación.
 * El campo "version_code" es el número después del "+" en pubspec.yaml (e.g. 1.1.0+2 -> 2)
 */

echo json_encode([
    "ok" => true,
    "latest_version" => "1.1.0",
    "latest_version_code" => 2,
    "download_url" => "https://ponciano.zz.com.ve/ventas247.apk",
    "release_notes" => "Mejoras en el reporte de inventario y optimización de velocidad.",
    "force_update" => false
]);
