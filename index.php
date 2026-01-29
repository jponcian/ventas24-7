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
    <div style="margin-top: 20px;">
        <a href="https://www.digitalocean.com/?refcode=004d8c71908f&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%202.svg" alt="DigitalOcean Referral Badge" /></a>
    </div>
</body>

</html>