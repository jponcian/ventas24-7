<?php

namespace App\Services;

use App\Models\ExchangeRate;
use Illuminate\Support\Facades\Http;
use Illuminate\Http\Client\ConnectionException;
use DOMDocument;
use DOMXPath;

class BcvRateService
{
    /**
     * Intenta sincronizar la tasa del día si no existe aún.
     */
    public function syncIfMissing(): void
    {
        $today = date('Y-m-d');
        // Buscar tasa más reciente sin importar si es futura (el BCV puede publicar adelantada)
        $latest = ExchangeRate::orderByDesc('date')
            ->where('source','BCV')
            ->where('from','USD')
            ->where('to','VES')
            ->first();

        if ($latest && $latest->date->format('Y-m-d') >= $today) {
            // Ya tenemos una tasa para hoy o futura (p.ej. viernes publica lunes). No intentamos nuevamente.
            return;
        }

        $data = $this->fetch();
        if ($data && isset($data['date'], $data['rate'])) {
            // Guardar sólo si no existe EXACTA combinación fecha-source-par
            ExchangeRate::storeIfNotExists($data['date'], (float) $data['rate'], 'BCV', 'USD', 'VES');
        }
    }

    /**
     * Descarga y parsea la tasa del BCV.
     * @return array|null ['date' => 'YYYY-MM-DD', 'rate' => float]
     */
    public function fetch(): ?array
    {
        $url = 'https://www.bcv.org.ve/';
        try {
            $response = Http::timeout(20)->withHeaders([
                'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) BcvFetcher'
            ])->get($url);
        } catch (ConnectionException $e) {
            // Fallback para entornos Windows/desarrollo con CA faltante
            $response = Http::timeout(20)->withoutVerifying()->withHeaders([
                'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) BcvFetcher'
            ])->get($url);
        }

        if (! $response->ok()) {
            return null;
        }

        $html = $response->body();
        libxml_use_internal_errors(true);
        $dom = new DOMDocument();
        if (! $dom->loadHTML($html)) {
            return null;
        }
        $xpath = new DOMXPath($dom);

        $rate = null; $rateDate = null;
        // 1) Bloque id=dolar -> primer strong
        $nodes = $xpath->query("//*[@id='dolar']//strong");
        if ($nodes->length > 0) {
            $raw = trim($nodes->item(0)->textContent);
            $raw = preg_replace('/[^0-9,\.]/', '', $raw);
            $raw = str_replace(',', '.', $raw);
            if (is_numeric($raw)) $rate = (float) $raw;
        }
        // 2) Fallback por span USD -> following strong
        if (! $rate) {
            $spanUSD = $xpath->query("//span[contains(.,'USD')]");
            if ($spanUSD->length) {
                $strong = $xpath->query('following::strong[1]', $spanUSD->item(0));
                if ($strong->length) {
                    $raw = trim($strong->item(0)->textContent);
                    $raw = preg_replace('/[^0-9,\.]/', '', $raw);
                    $raw = str_replace(',', '.', $raw);
                    if (is_numeric($raw)) $rate = (float) $raw;
                }
            }
        }
        // 3) Fecha del atributo content si existe
        $dateAttr = $xpath->query("//span[contains(@class,'date-display-single')]/@content");
        if ($dateAttr->length) {
            $attr = $dateAttr->item(0)->nodeValue;
            if (preg_match('/^(\d{4}-\d{2}-\d{2})/', $attr, $m)) {
                $rateDate = $m[1];
            }
        }
    if (! $rateDate) $rateDate = date('Y-m-d'); // Si BCV no entrega fecha, usamos hoy (no futura artificial)

        if ($rate === null) {
            return null;
        }

        return ['date' => $rateDate, 'rate' => $rate];
    }
}
