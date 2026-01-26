<?php
require __DIR__ . '/bodega/db.php';
header('Content-Type: text/plain');

try {
    global $db;
    $cedula = '16912337';
    $password = '123456';
    
    // 1. Ver datos directos
    $stmt = $db->prepare("SELECT * FROM users WHERE cedula = ?");
    $stmt->execute([$cedula]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$user) {
        echo "ERROR: El usuario $cedula no existe en la BD.\n";
        exit;
    }
    
    echo "Usuario encontrado: " . $user['nombre_completo'] . " (ID: " . $user['id'] . ")\n";
    echo "Hash en BD: " . $user['password_hash'] . "\n";
    
    // 2. Probar hash manual
    $manualHash = password_hash($password, PASSWORD_DEFAULT);
    echo "Nuevo hash generado para prueba: $manualHash\n";
    
    // 3. Probar verificación
    if (password_verify($password, $user['password_hash'])) {
        echo "VERIFICACIÓN EXITOSA: La contraseña coincide.\n";
    } else {
        echo "VERIFICACIÓN FALLIDA: La contraseña NO coincide.\n";
        
        // 4. Intentar corregir de nuevo con un hash fresco
        $stmt = $db->prepare("UPDATE users SET password_hash = ? WHERE id = ?");
        $stmt->execute([$manualHash, $user['id']]);
        echo "Contraseña actualizada con el nuevo hash.\n";
        
        // 5. Re-verificar
        if (password_verify($password, $manualHash)) {
            echo "NUEVA VERIFICACIÓN EXITOSA: Ahora sí coincide.\n";
        }
    }

} catch (Exception $e) {
    echo "ERROR SQL: " . $e->getMessage() . "\n";
}
