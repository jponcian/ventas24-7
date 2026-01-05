<?php

return [
    
    /*
    |--------------------------------------------------------------------------
    | WhatsApp API Enabled
    |--------------------------------------------------------------------------
    |
    | Enable or disable WhatsApp notifications globally
    |
    */
    
    'enabled' => env('WHATSAPP_ENABLED', false),

    /*
    |--------------------------------------------------------------------------
    | UltraMsg Instance ID
    |--------------------------------------------------------------------------
    |
    | Your UltraMsg instance ID (e.g., instance152977)
    |
    */
    
    'instance_id' => env('WHATSAPP_INSTANCE_ID', ''),

    /*
    |--------------------------------------------------------------------------
    | UltraMsg Token
    |--------------------------------------------------------------------------
    |
    | Your UltraMsg authentication token
    |
    */
    
    'token' => env('WHATSAPP_TOKEN', ''),

    /*
    |--------------------------------------------------------------------------
    | UltraMsg API URL
    |--------------------------------------------------------------------------
    |
    | Base URL for the UltraMsg API
    |
    */
    
    'api_url' => env('WHATSAPP_API_URL', 'https://api.ultramsg.com'),

];
