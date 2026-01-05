<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Http;
use Illuminate\Http\Client\ConnectionException;
use App\Models\ExchangeRate;
use DOMDocument;
use DOMXPath;

class SyncBcvRate extends Command
{
    protected $signature = 'exchange:sync-bcv {--force : Ignorar si existe hoy y volver a guardar}';
    protected $description = 'Obtiene la tasa oficial USD/VES del BCV y la guarda si no existe para la fecha';

    public function handle(): int
    {
        $today = date('Y-m-d');
        if (! $this->option('force') && ExchangeRate::where('date',$today)->where('source','BCV')->where('from','USD')->where('to','VES')->exists()) {
            $this->info('Ya existe tasa para hoy, no se hace nada. Usa --force para reobtener.');
            return self::SUCCESS;
        }

        $url = 'https://www.bcv.org.ve/';
        try {
            $response = Http::timeout(20)->withHeaders([
                'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) LaravelBot'
            ])->get($url);
        } catch (ConnectionException $e) {
            // Fallback deshabilitando verificación SSL (no recomendado para producción)
            $this->warn('Falla SSL, reintentando sin verificación (solo desarrollo).');
            $response = Http::timeout(20)->withoutVerifying()->withHeaders([
                'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) LaravelBot'
            ])->get($url);
        }

        if (! $response->ok()) {
            $this->error('Error HTTP al consultar BCV: ' . $response->status());
            return self::FAILURE;
        }

        $html = $response->body();
        libxml_use_internal_errors(true);
        $dom = new DOMDocument();
        if (! $dom->loadHTML($html)) {
            $this->error('No se pudo parsear HTML.');
            return self::FAILURE;
        }
        $xpath = new DOMXPath($dom);

        $rate = null; $rateDate = null;
        // Intento 1: id="dolar" primer <strong>
        $nodes = $xpath->query("//*[@id='dolar']//strong");
        if ($nodes->length > 0) {
            $raw = trim($nodes->item(0)->textContent);
            $raw = preg_replace('/[^0-9,\.]/','',$raw);
            $raw = str_replace(',', '.', $raw);
            if (is_numeric($raw)) $rate = (float)$raw;
        }
        // Intento 2: span con USD y siguiente strong
        if (! $rate) {
            $spanUSD = $xpath->query("//span[contains(.,'USD')]");
            if ($spanUSD->length) {
                $strong = $xpath->query('following::strong[1]', $spanUSD->item(0));
                if ($strong->length) {
                    $raw = trim($strong->item(0)->textContent);
                    $raw = preg_replace('/[^0-9,\.]/','',$raw);
                    $raw = str_replace(',', '.', $raw);
                    if (is_numeric($raw)) $rate = (float)$raw;
                }
            }
        }
        // Fecha
        $dateAttr = $xpath->query("//span[contains(@class,'date-display-single')]/@content");
        if ($dateAttr->length) {
            $attr = $dateAttr->item(0)->nodeValue;
            if (preg_match('/^(\d{4}-\d{2}-\d{2})/', $attr, $m)) {
                $rateDate = $m[1];
            }
        }
        if (! $rateDate) $rateDate = $today;

        if ($rate === null) {
            $this->error('No se pudo extraer la tasa.');
            return self::FAILURE;
        }

        $stored = ExchangeRate::storeIfNotExists($rateDate, $rate, 'BCV','USD','VES');
        if ($stored) {
            $this->info("Guardada tasa BCV {$rate} para fecha {$rateDate}");
        } else {
            $this->info('La tasa ya existía para esa fecha, no se duplicó.');
        }

        return self::SUCCESS;
    }
}
