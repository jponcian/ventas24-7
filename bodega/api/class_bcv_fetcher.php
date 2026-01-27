<?php
// Clase para obtener la tasa del BCV mediante scraping
class BcvFetcher {
    public function fetch() {
        $url = 'https://www.bcv.org.ve/';
        
        // Contexto para simular navegador y evitar bloqueos raros, ignorar SSL si falla (común en dev)
        $context = stream_context_create([
            'http' => [
                'header' => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) BcvFetcherPHP\r\n",
                'timeout' => 20
            ],
            'ssl' => [
                'verify_peer' => false,
                'verify_peer_name' => false
            ]
        ]);

        $html = @file_get_contents($url, false, $context);
        
        if ($html === false) {
            return null;
        }

        libxml_use_internal_errors(true);
        $dom = new DOMDocument();
        if (!$dom->loadHTML($html)) {
            return null;
        }
        $xpath = new DOMXPath($dom);

        $rate = null;
        $rateDate = date('Y-m-d'); // Default hoy

        // 1. Buscar valor en bloque id="dolar" -> strong
        $nodes = $xpath->query("//*[@id='dolar']//strong");
        if ($nodes->length > 0) {
            $raw = trim($nodes->item(0)->textContent);
            $raw = preg_replace('/[^0-9,\.]/', '', $raw); // Limpiar caracteres no numéricos
            $raw = str_replace(',', '.', $raw); // Cambiar coma por punto
            if (is_numeric($raw)) {
                $rate = (float)$raw;
            }
        }

        // 2. Fallback: Buscar "USD" en un span y tomar el siguiente strong
        if (!$rate) {
            $spanUSD = $xpath->query("//span[contains(.,'USD')]");
            if ($spanUSD->length > 0) {
                $strong = $xpath->query('following::strong[1]', $spanUSD->item(0));
                if ($strong->length > 0) {
                    $raw = trim($strong->item(0)->textContent);
                    $raw = preg_replace('/[^0-9,\.]/', '', $raw);
                    $raw = str_replace(',', '.', $raw);
                    if (is_numeric($raw)) $rate = (float)$raw;
                }
            }
        }

        // 3. Intentar sacar fecha del contenido (opcional, igual que en el servicio original)
        $dateAttr = $xpath->query("//span[contains(@class,'date-display-single')]/@content");
        if ($dateAttr->length > 0) {
            $attr = $dateAttr->item(0)->nodeValue;
            if (preg_match('/^(\d{4}-\d{2}-\d{2})/', $attr, $m)) {
                $rateDate = $m[1];
            }
        }

        if ($rate !== null) {
            return ['date' => $rateDate, 'rate' => $rate];
        }
        return null;
    }
}
?>
