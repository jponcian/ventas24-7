<?php
require_once __DIR__ . '/cors.php';
// Mantenemos db.php para otros propósitos si fuera necesario, 
// pero usaremos una conexión específica para la tasa de javier_ponciano_5
require __DIR__ . '/../db.php'; 
header('Content-Type: application/json; charset=utf-8');

// Configuración de la BDD de Tasas (javier_ponciano_5)
$db5_host = 'localhost';
$db5_name = 'javier_ponciano_5';
$db5_user = 'somos';
$db5_pass = 'Somossalud016.';

try {
    $db5 = new PDO("mysql:host=$db5_host;dbname=$db5_name;charset=utf8mb4", $db5_user, $db5_pass);
    $db5->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Buscar tasa del día actual o fecha especificada
    $hoy = isset($_GET['fecha']) ? $_GET['fecha'] : date('Y-m-d');
    
    // En javier_ponciano_5 la tabla es exchange_rates, columnas date y rate
    $stmt = $db5->prepare("SELECT date, rate FROM exchange_rates WHERE date = ? AND source = 'BCV' LIMIT 1");
    $stmt->execute([$hoy]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($row) {
        echo json_encode([
            'ok' => true,
            'fecha' => $row['date'],
            'valor' => (float)$row['rate']
        ]);
    } else {
        // Si no hay tasa para hoy, usar la tasa más reciente disponible.
        $stmt2 = $db5->prepare("SELECT date, rate FROM exchange_rates WHERE source = 'BCV' ORDER BY date DESC LIMIT 1");
        $stmt2->execute();
        $row2 = $stmt2->fetch(PDO::FETCH_ASSOC);
        if ($row2) {
            echo json_encode([
                'ok' => true,
                'fecha' => $row2['date'],
                'valor' => (float)$row2['rate']
            ]);
        } else {
            echo json_encode(['ok' => false, 'error' => 'No hay tasa registrada en exchange_rates']);
        }
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => 'Error al consultar tasa en BDD externa: ' . $e->getMessage()]);
}
