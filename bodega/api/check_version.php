<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

/**
 * Endpoint para verificar la última versión disponible de la aplicación.
 * El campo "version_code" es el número después del "+" en pubspec.yaml (e.g. 1.1.0+2 -> 2)
 */

echo json_encode([
    "ok" => true,
    "latest_version" => "2.7.0",
    "latest_version_code" => 11,
    "download_url" => "https://ponciano.zz.com.ve/ventas247.apk",
    "release_notes" => "Mejoras v2.7.0 ✅\n\n- Detalle de venta: ventana ahora se ajusta al tamaño del contenido.\n- Mejoras de rendimiento y estabilidad.",
    "force_update" => false
]);
