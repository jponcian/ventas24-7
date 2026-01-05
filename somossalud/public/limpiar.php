<?php
// Este archivo debe ir en la carpeta PUBLIC (public_html) del servidor
// Ajusta la ruta a los archivos principales si es necesario (el ../ asume estructura standard)

require __DIR__.'/../vendor/autoload.php';
$app = require_once __DIR__.'/../bootstrap/app.php';

$kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);
$response = $kernel->handle(
    $request = Illuminate\Http\Request::capture()
);

use Illuminate\Support\Facades\Artisan;
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mantenimiento Laravel</title>
    <style>body { font-family: sans-serif; padding: 20px; line-height: 1.6; } .success { color: green; } .error { color: red; }</style>
</head>
<body>
    <h1>Herramienta de Limpieza de Caché</h1>
    
    <?php
    try {
        echo "<p>Ejecutando <strong>route:clear</strong>...</p>";
        Artisan::call('route:clear');
        echo "<div class='success'>" . nl2br(Artisan::output()) . "</div>";

        echo "<p>Ejecutando <strong>config:clear</strong>...</p>";
        Artisan::call('config:clear');
        echo "<div class='success'>" . nl2br(Artisan::output()) . "</div>";

        echo "<p>Ejecutando <strong>cache:clear</strong>...</p>";
        Artisan::call('cache:clear');
        echo "<div class='success'>" . nl2br(Artisan::output()) . "</div>";

    } catch (Exception $e) {
        echo "<div class='error'><strong>Error Crítico:</strong> " . $e->getMessage() . "</div>";
    }
    ?>
    
    <p><em>Ahora intenta acceder a la App nuevamente. Recuerda BORRAR este archivo después de usarlo por seguridad.</em></p>
</body>
</html>
