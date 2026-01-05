<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class WhatsAppService
{
    protected $instanceId;
    protected $token;
    protected $apiUrl;

    public function __construct()
    {
        $this->instanceId = config('whatsapp.instance_id');
        $this->token = config('whatsapp.token');
        $this->apiUrl = config('whatsapp.api_url');
    }

    /**
     * Enviar mensaje de texto simple
     * 
     * @param string $to Número de teléfono en formato internacional (+584144679693)
     * @param string $message Mensaje a enviar
     * @param int $priority Prioridad (1=alta, 5=media, 10=baja)
     * @return array
     */
    public function sendMessage($to, $message, $priority = 10)
    {
        try {
            $url = "{$this->apiUrl}/{$this->instanceId}/messages/chat";
            
            $http = Http::asForm();
            
            // Configuración especial para Windows/WAMP con problemas de DNS
            $curlOptions = [
                CURLOPT_IPRESOLVE => CURL_IPRESOLVE_V4, // Forzar IPv4
                CURLOPT_DNS_CACHE_TIMEOUT => 120, // Cache DNS por 2 minutos
                CURLOPT_CONNECTTIMEOUT => 30, // Timeout de conexión
            ];
            
            // Deshabilitar verificación SSL en desarrollo
            if (config('app.env') !== 'production') {
                $curlOptions[CURLOPT_SSL_VERIFYHOST] = 0;
                $curlOptions[CURLOPT_SSL_VERIFYPEER] = false;
            }
            
            $http = $http->withOptions($curlOptions);
            
            $response = $http->post($url, [
                'token' => $this->token,
                'to' => $to,
                'body' => $message,
                'priority' => $priority
            ]);

            $result = $response->json();

            // Log para debugging
            Log::info('WhatsApp message sent', [
                'to' => $to,
                'response' => $result
            ]);

            return [
                'success' => $response->successful(),
                'data' => $result
            ];

        } catch (\Exception $e) {
            Log::error('WhatsApp send error', [
                'to' => $to,
                'error' => $e->getMessage()
            ]);

            return [
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }

    /**
     * Enviar documento/archivo (PDF, imagen, etc.)
     * 
     * @param string $to Número de teléfono en formato internacional (+584144679693)
     * @param string $fileUrl URL pública del archivo a enviar
     * @param string $caption Texto que acompaña al archivo (opcional)
     * @param string $filename Nombre del archivo (opcional)
     * @return array
     */
    public function sendDocument($to, $fileUrl, $caption = '', $filename = 'documento.pdf')
    {
        try {
            $url = "{$this->apiUrl}/{$this->instanceId}/messages/document";
            
            $http = Http::asForm();
            
            // Configuración especial para Windows/WAMP con problemas de DNS
            $curlOptions = [
                CURLOPT_IPRESOLVE => CURL_IPRESOLVE_V4, // Forzar IPv4
                CURLOPT_DNS_CACHE_TIMEOUT => 120, // Cache DNS por 2 minutos
                CURLOPT_CONNECTTIMEOUT => 30, // Timeout de conexión
            ];
            
            // Deshabilitar verificación SSL en desarrollo
            if (config('app.env') !== 'production') {
                $curlOptions[CURLOPT_SSL_VERIFYHOST] = 0;
                $curlOptions[CURLOPT_SSL_VERIFYPEER] = false;
            }
            
            $http = $http->withOptions($curlOptions);
            
            // Aumentar timeout para envíos de documentos pesados (Base64)
            $response = $http->timeout(120)->post($url, [
                'token' => $this->token,
                'to' => $to,
                'document' => $fileUrl,
                'caption' => $caption,
                'filename' => $filename
            ]);

            $result = $response->json();

            // Log para debugging
            Log::info('WhatsApp document sent', [
                'to' => $to,
                'file' => $filename,
                'response' => $result
            ]);

            return [
                'success' => $response->successful(),
                'data' => $result
            ];

        } catch (\Exception $e) {
            Log::error('WhatsApp document send error', [
                'to' => $to,
                'file' => $filename,
                'error' => $e->getMessage()
            ]);

            return [
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }

    /**
     * Verificar si el servicio está habilitado
     * 
     * @return bool
     */
    public function isEnabled()
    {
        return config('whatsapp.enabled', false) && 
               !empty($this->instanceId) && 
               !empty($this->token);
    }
}
