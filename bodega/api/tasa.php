<?php
require_once __DIR__ . '/cors.php';
require __DIR__ . '/../db.php'; 
require_once __DIR__ . '/class_bcv_fetcher.php'; // Fetcher logic

header('Content-Type: application/json; charset=utf-8');

// Configuración BDD Externa (javier_ponciano_5)
$db5_host = 'localhost';
$db5_name = 'javier_ponciano_5';
$db5_user = 'somos';
$db5_pass = 'Somossalud016.';

try {
    $db5 = new PDO("mysql:host=$db5_host;dbname=$db5_name;charset=utf8mb4", $db5_user, $db5_pass);
    $db5->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $forcedDate = isset($_GET['fecha']) ? $_GET['fecha'] : null;
    $hoy = $forcedDate ?: date('Y-m-d');

    // 1. Intentar buscar tasa para la fecha solicitada
    $stmt = $db5->prepare("SELECT date, rate FROM exchange_rates WHERE date = ? AND source = 'BCV' LIMIT 1");
    $stmt->execute([$hoy]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);

    // 2. Si NO hay tasa para HOY y no se pidió una fecha específica pasada, intentamos actualizar
    if (!$row && !$forcedDate) {
        // Intentar fetch del BCV
        $fetcher = new BcvFetcher();
        $data = $fetcher->fetch();

        if ($data && isset($data['rate'])) {
            // Verificar si la fecha que trajo el BCV ya existe
            $bcvDate = $data['date'];
            $bcvRate = $data['rate'];

            // Corroborar existencia
            $check = $db5->prepare("SELECT id FROM exchange_rates WHERE date = ? AND source = 'BCV' LIMIT 1");
            $check->execute([$bcvDate]);
            if (!$check->fetch()) {
                // Insertar nueva tasa
                $ins = $db5->prepare("INSERT INTO exchange_rates (date, rate, source, `from`, `to`, created_at, updated_at) VALUES (?, ?, 'BCV', 'USD', 'VES', NOW(), NOW())");
                $ins->execute([$bcvDate, $bcvRate]);
            }

            // Si la fecha del BCV coincide con hoy, ya tenemos $row
            if ($bcvDate === $hoy) {
                $row = ['date' => $bcvDate, 'rate' => $bcvRate];
            } else {
                // Si el BCV devolvió una fecha distinta (ayer u otro día), usamos esa como referencia
                // OJO: Si hoy es Sábado y BCV devuelve Viernes, es correcto.
            }
        }
    }

    // 3. Volver a buscar la tasa más reciente disponible si aún no tenemos row (fallback)
    if (!$row) {
        $stmt2 = $db5->prepare("SELECT date, rate FROM exchange_rates WHERE source = 'BCV' ORDER BY date DESC LIMIT 1");
        $stmt2->execute();
        $row = $stmt2->fetch(PDO::FETCH_ASSOC);
    }

    if ($row) {
        echo json_encode([
            'ok' => true,
            'fecha' => $row['date'],
            'valor' => (float)$row['rate']
        ]);
    } else {
        echo json_encode(['ok' => false, 'error' => 'No hay tasa disponible']);
    }

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => 'Error BDD Tasa: ' . $e->getMessage()]);
}
?>
