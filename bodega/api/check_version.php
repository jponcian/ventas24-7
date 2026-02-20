<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

/**
 * Endpoint para verificar la última versión disponible de la aplicación.
 * El campo "version_code" es el número después del "+" en pubspec.yaml (e.g. 1.1.0+2 -> 2)
 */

echo json_encode([
    "ok" => true,
<<<<<<< HEAD
    "latest_version" => "2.6.2",
    "latest_version_code" => 10,
    "download_url" => "https://ponciano.zz.com.ve/ventas247.apk",
    "release_notes" => "Nueva Versión 🚀🦾\n\n- Notificaciones Multi-Admin: Ahora todos los administradores reciben alertas de stock.\n- Evolution API: Nuevo motor de mensajería más estable.\n- Mejoras en Fiados: Filtro inteligente de deuda y validación de teléfono.\n- Formateador de números: Validación automática para operadoras de Venezuela.",
=======
    "latest_version" => "2.7.0",
    "latest_version_code" => 8,
    "download_url" => "https://ponciano.zz.com.ve/ventas247.apk",
    "release_notes" => "Mejoras v2.7.0 ✅\n\n- Detalle de venta: ventana ahora se ajusta al tamaño del contenido.\n- Mejoras de rendimiento y estabilidad.",
>>>>>>> cdd2c2f (v2.7.0+8: Dialogo de detalle venta se ajusta al contenido)
    "force_update" => false
]);
