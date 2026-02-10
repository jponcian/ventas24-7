<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

/**
 * Endpoint para verificar la última versión disponible de la aplicación.
 * El campo "version_code" es el número después del "+" en pubspec.yaml (e.g. 1.1.0+2 -> 2)
 */

echo json_encode([
    "ok" => true,
    "latest_version" => "1.1.2",
    "latest_version_code" => 4,
    "download_url" => "https://ponciano.zz.com.ve/ventas247.apk",
    "release_notes" => "Versión Actual ✅\n\n- Menú reorganizado con Catálogo de Productos.\n- Búsqueda por código interno mejorada.\n- Interfaz premium del catálogo.\n- Corrección de visualización de precios.",
    "force_update" => false
]);
