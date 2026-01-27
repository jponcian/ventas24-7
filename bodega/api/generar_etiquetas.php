<?php
require_once __DIR__ . '/../db.php';
require_once __DIR__ . '/cors.php';
header('Content-Type: application/json; charset=utf-8');

$json = file_get_contents('php://input');
$data = json_decode($json, true) ?? [];

$negocio_id = isset($data['negocio_id']) ? intval($data['negocio_id']) : 0;
$ids = isset($data['ids']) && is_array($data['ids']) ? $data['ids'] : [];

if ($negocio_id <= 0) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'Falta negocio_id']);
    exit;
}

// Construir URL para generar PDF
$baseUrl = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http") . "://$_SERVER[HTTP_HOST]";
$pdfUrl = $baseUrl . dirname($_SERVER['PHP_SELF']) . '/../generar_pdfg.php';

if (!empty($ids)) {
    $pdfUrl .= '?ids=' . implode(',', array_map('intval', $ids));
}

echo json_encode([
    'ok' => true,
    'pdf_url' => $pdfUrl
]);
?>
