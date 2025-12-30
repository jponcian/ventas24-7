<?php
// Entrada pública del proyecto: redirige a la carpeta "plantilla" que actúa como front-end
header('Location: plantilla/');
exit;

// Fallback: si el servidor no procesa PHP, mostrar link manual
?>
<!doctype html>
<html lang="es">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Acceder al sitio</title>
</head>

<body>
    <p>Si no fue redirigido automáticamente, haga clic en: <a href="plantilla/">Entrar al sitio (plantilla)</a></p>
</body>

</html>