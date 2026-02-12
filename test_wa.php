<?php
require_once __DIR__ . '/bodega/whatsapp.php';

$mensajeEnviado = false;
$error = null;

if (isset($_POST['enviar'])) {
    $numero = '04141476580';
    $mensaje = "🧪 *Mensaje de Prueba*\n\nEste es un mensaje automático de prueba desde el entorno local de SuperBodega. ✨";
    
    if (enviarWhatsapp($numero, $mensaje, 'TEST')) {
        $mensajeEnviado = true;
    } else {
        $error = "No se pudo enviar el mensaje. Revisa la configuración en whatsapp.php o la conexión al servidor WAHA.";
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prueba de WhatsApp - SuperBodega</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body { 
            font-family: 'Outfit', sans-serif; 
            background: #f8fafc; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            height: 100vh; 
            margin: 0; 
        }
        .card { 
            background: white; 
            padding: 30px; 
            border-radius: 20px; 
            box-shadow: 0 10px 25px rgba(0,0,0,0.05); 
            text-align: center; 
            max-width: 400px; 
            width: 90%; 
        }
        h1 { color: #1e3a8a; margin-bottom: 20px; font-size: 24px; }
        p { color: #64748b; margin-bottom: 30px; }
        .btn { 
            background: #22c55e; 
            color: white; 
            border: none; 
            padding: 12px 24px; 
            border-radius: 12px; 
            font-size: 16px; 
            font-weight: 600; 
            cursor: pointer; 
            transition: all 0.3s; 
            text-decoration: none;
            display: inline-block;
        }
        .btn:hover { background: #16a34a; transform: translateY(-2px); }
        .alert { 
            margin-top: 20px; 
            padding: 15px; 
            border-radius: 10px; 
            font-size: 14px; 
        }
        .success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
        .error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Prueba de Envío</h1>
        <p>Presiona el botón para enviar un mensaje de prueba al número:<br><strong>04141476580</strong></p>
        
        <form method="POST">
            <button type="submit" name="enviar" class="btn">Enviar Mensaje</button>
        </form>

        <?php if ($mensajeEnviado): ?>
            <div class="alert success">✅ ¡Mensaje enviado con éxito al servidor WAHA!</div>
        <?php endif; ?>

        <?php if ($error): ?>
            <div class="alert error">❌ <?php echo $error; ?></div>
        <?php endif; ?>
    </div>
</body>
</html>
