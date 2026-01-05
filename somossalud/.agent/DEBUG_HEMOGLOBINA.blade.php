@php
// DEBUG: Agregar esto temporalmente al PDF para ver qué está pasando
// ELIMINAR DESPUÉS DE VERIFICAR

if (stripos($result->examItem->name, 'HEMOGLOBINA') !== false) {
    echo "<!-- DEBUG HEMOGLOBINA:\n";
    echo "Valor resultado: '{$result->value}'\n";
    echo "Valor limpio: '{$cleanValue}'\n";
    echo "Es numérico: " . (is_numeric($cleanValue) ? 'SI' : 'NO') . "\n";
    echo "Valor numérico: " . (is_numeric($cleanValue) ? floatval($cleanValue) : 'N/A') . "\n";
    echo "Rango existe: " . ($rango ? 'SI' : 'NO') . "\n";
    if ($rango) {
        echo "Min: {$rango->value_min}\n";
        echo "Max: {$rango->value_max}\n";
        echo "Min float: " . floatval($rango->value_min) . "\n";
        echo "Max float: " . floatval($rango->value_max) . "\n";
    }
    echo "Fuera de rango: " . ($isOutOfRange ? 'SI' : 'NO') . "\n";
    echo "-->\n";
}
@endphp
