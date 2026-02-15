<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

/**
 * Endpoint para verificar la última versión disponible de la aplicación.
 * El campo "version_code" es el número después del "+" en pubspec.yaml (e.g. 1.1.0+2 -> 2)
 */

echo json_encode([
    "ok" => true,
    "latest_version" => "2.5.0",
    "latest_version_code" => 7,
    "download_url" => "https://ponciano.zz.com.ve/ventas247.apk",
    "release_notes" => "Nuevas Mejoras ✅\n\n- WhatsApp: Nombre de negocio dinámico y mensajes más profesionales.\n- Pagos múltiples por venta (Efectivo, Zelle, Pago Móvil, etc).\n- Cambio rápido entre negocios en el menú lateral.\n- Opción de método de pago predeterminado (Favorito ⭐).\n- Diseño de reportes más compacto y eficiente.\n- Mejoras de rendimiento y seguridad.",
    "force_update" => false
]);
