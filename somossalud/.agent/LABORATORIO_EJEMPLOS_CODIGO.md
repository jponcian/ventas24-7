# Ejemplos de Código - Sistema de Referencias de Laboratorio

## 🔍 Consultas SQL Útiles

### 1. Ver un Examen Completo con sus Items

```sql
-- Ejemplo: HEMATOLOGIA COMPLETA (id: 279)
SELECT 
    e.id as exam_id,
    e.name as exam_name,
    i.id as item_id,
    i.code as item_code,
    i.name as item_name,
    i.unit,
    i.reference_value,
    i.type,
    i.order
FROM lab_exams e
INNER JOIN lab_exam_items i ON e.id = i.lab_exam_id
WHERE e.id = 279
ORDER BY i.order;
```

**Resultado:**
```
exam_id | exam_name              | item_id | code | item_name        | unit  | reference_value | type | order
--------|------------------------|---------|------|------------------|-------|-----------------|------|------
279     | HEMATOLOGIA COMPLETA   | 1932    | 001  | HEMATOLOGIA      |       |                 | E    | 1
279     | HEMATOLOGIA COMPLETA   | 1933    | 022  | HEMOGLOBINA:     | g/dL  | 12.0 - 16.0     | N    | 2
279     | HEMATOLOGIA COMPLETA   | 40      | 001  | HEMATOCRITO:     | %     | 37.0 - 47.0     | N    | 3
279     | HEMATOLOGIA COMPLETA   | 39      | 001  | LEUCOCITOS:      | /mm3  | 4000.0 - 11000.0| N    | 4
```

---

### 2. Ver Rangos de Referencia de un Item

```sql
-- Ejemplo: HEMOGLOBINA (item_id: 1933)
SELECT 
    i.name as item_name,
    i.reference_value as ref_simple,
    rg.description as grupo,
    rg.sex,
    rg.age_start_year,
    rg.age_end_year,
    rr.condition,
    rr.value_min,
    rr.value_max,
    rr.value_text
FROM lab_exam_items i
LEFT JOIN lab_reference_ranges rr ON i.id = rr.lab_exam_item_id
LEFT JOIN lab_reference_groups rg ON rr.lab_reference_group_id = rg.id
WHERE i.id = 1933
ORDER BY rr.order;
```

---

### 3. Buscar Items con Referencias Avanzadas

```sql
-- Items que tienen rangos específicos por edad/sexo
SELECT 
    e.name as exam_name,
    i.name as item_name,
    COUNT(rr.id) as num_rangos
FROM lab_exam_items i
INNER JOIN lab_exams e ON i.lab_exam_id = e.id
LEFT JOIN lab_reference_ranges rr ON i.id = rr.lab_exam_item_id
GROUP BY i.id
HAVING num_rangos > 1
ORDER BY num_rangos DESC
LIMIT 20;
```

---

### 4. Ver Grupos de Referencia Activos

```sql
SELECT 
    id,
    code,
    description,
    CASE sex
        WHEN 1 THEN 'Hombre'
        WHEN 2 THEN 'Mujer'
        WHEN 3 THEN 'Todos'
        ELSE 'Desconocido'
    END as sexo,
    CONCAT(age_start_year, ' años') as edad_min,
    CONCAT(age_end_year, ' años') as edad_max
FROM lab_reference_groups
WHERE active = 1
ORDER BY sex, age_start_year;
```

---

## 💻 Código PHP - Modelos

### Método para Obtener Referencia Aplicable

```php
// En app/Models/LabExamItem.php

/**
 * Obtener la referencia aplicable para un paciente específico
 * Prioriza rangos avanzados sobre referencia simple
 */
public function getApplicableReference($patient)
{
    // 1. Intentar obtener rango específico por edad/sexo
    $advancedRange = $this->getReferenceRangeForPatient($patient);
    
    if ($advancedRange) {
        return [
            'type' => 'advanced',
            'group' => $advancedRange->group->description,
            'condition' => $advancedRange->condition,
            'min' => $advancedRange->value_min,
            'max' => $advancedRange->value_max,
            'text' => $advancedRange->value_text,
            'display' => $this->formatAdvancedReference($advancedRange)
        ];
    }
    
    // 2. Usar referencia simple
    if ($this->reference_value) {
        return [
            'type' => 'simple',
            'text' => $this->reference_value,
            'display' => $this->reference_value
        ];
    }
    
    // 3. Sin referencia
    return null;
}

/**
 * Formatear referencia avanzada para mostrar
 */
private function formatAdvancedReference($range)
{
    $parts = [];
    
    if ($range->condition) {
        $parts[] = $range->condition;
    }
    
    if ($range->value_min !== null && $range->value_max !== null) {
        $parts[] = "{$range->value_min} - {$range->value_max}";
    } elseif ($range->value_min !== null) {
        $parts[] = "> {$range->value_min}";
    } elseif ($range->value_max !== null) {
        $parts[] = "< {$range->value_max}";
    }
    
    if ($range->value_text) {
        $parts[] = "({$range->value_text})";
    }
    
    if ($this->unit) {
        $parts[] = $this->unit;
    }
    
    return implode(' ', $parts);
}

/**
 * Verificar si un resultado está fuera de rango
 */
public function isOutOfRange($value, $patient)
{
    if ($this->type !== 'N') {
        return false; // Solo validar valores numéricos
    }
    
    $reference = $this->getApplicableReference($patient);
    
    if (!$reference) {
        return false; // Sin referencia, no se puede validar
    }
    
    if ($reference['type'] === 'advanced') {
        return $this->validateAdvancedRange($value, $reference);
    }
    
    if ($reference['type'] === 'simple') {
        return $this->validateSimpleRange($value, $reference['text']);
    }
    
    return false;
}

/**
 * Validar contra rango avanzado
 */
private function validateAdvancedRange($value, $reference)
{
    $min = $reference['min'];
    $max = $reference['max'];
    
    if ($min !== null && $value < $min) {
        return true; // Debajo del mínimo
    }
    
    if ($max !== null && $value > $max) {
        return true; // Encima del máximo
    }
    
    return false;
}

/**
 * Validar contra referencia simple
 * Parsea formatos como: "12.0 - 16.0", "> 200.0", "< 5.0"
 */
private function validateSimpleRange($value, $referenceText)
{
    // Formato: "min - max"
    if (preg_match('/^([\d.]+)\s*-\s*([\d.]+)$/', $referenceText, $matches)) {
        $min = floatval($matches[1]);
        $max = floatval($matches[2]);
        return ($value < $min || $value > $max);
    }
    
    // Formato: "> valor"
    if (preg_match('/^>\s*([\d.]+)$/', $referenceText, $matches)) {
        $threshold = floatval($matches[1]);
        return ($value > $threshold); // Mayor es anormal
    }
    
    // Formato: "< valor"
    if (preg_match('/^<\s*([\d.]+)$/', $referenceText, $matches)) {
        $threshold = floatval($matches[1]);
        return ($value >= $threshold); // Mayor o igual es anormal
    }
    
    // Formato: "HASTA valor" o "Hasta valor"
    if (preg_match('/^(HASTA|Hasta)\s*([\d.]+)$/i', $referenceText, $matches)) {
        $max = floatval($matches[2]);
        return ($value > $max);
    }
    
    // No se puede parsear
    return false;
}
```

---

## 🎨 Código Blade - Vista de Resultados

### Mostrar Resultado con Referencia

```blade
{{-- resources/views/lab/results/show.blade.php --}}

@foreach($order->details as $detail)
    @foreach($detail->exam->items as $item)
        @php
            $result = $detail->results->where('lab_exam_item_id', $item->id)->first();
            $reference = $item->getApplicableReference($order->patient);
            $isOutOfRange = false;
            
            if ($result && $reference && $item->type === 'N') {
                $isOutOfRange = $item->isOutOfRange($result->value, $order->patient);
            }
        @endphp
        
        <tr class="{{ $isOutOfRange ? 'table-warning' : '' }}">
            <td>
                <strong>{{ $item->name }}</strong>
                @if($item->type === 'E')
                    <span class="badge bg-secondary">Encabezado</span>
                @endif
            </td>
            
            <td>
                @if($result)
                    @if($item->type === 'N')
                        <span class="{{ $isOutOfRange ? 'text-danger fw-bold' : '' }}">
                            {{ $result->value }}
                        </span>
                    @else
                        {{ $result->value }}
                    @endif
                @else
                    <span class="text-muted">-</span>
                @endif
            </td>
            
            <td>
                @if($item->unit)
                    {{ $item->unit }}
                @endif
            </td>
            
            <td>
                @if($reference)
                    <small>
                        {{ $reference['display'] }}
                        
                        @if($reference['type'] === 'advanced')
                            <span class="badge bg-info">
                                {{ $reference['group'] }}
                            </span>
                        @endif
                    </small>
                @else
                    <span class="text-muted">-</span>
                @endif
            </td>
            
            <td>
                @if($isOutOfRange)
                    <span class="badge bg-danger">
                        <i class="fas fa-exclamation-triangle"></i>
                        Fuera de rango
                    </span>
                @elseif($result && $reference && $item->type === 'N')
                    <span class="badge bg-success">
                        <i class="fas fa-check"></i>
                        Normal
                    </span>
                @endif
            </td>
        </tr>
    @endforeach
@endforeach
```

---

## 📄 Generación de PDF

### Código para Resaltar Valores Anormales

```php
// En el controlador o servicio de PDF

public function generatePDF($orderId)
{
    $order = LabOrder::with([
        'patient',
        'details.exam.items.referenceRanges.group',
        'details.results'
    ])->findOrFail($orderId);
    
    $data = [
        'order' => $order,
        'patient' => $order->patient,
        'results' => $this->prepareResultsForPDF($order)
    ];
    
    $pdf = PDF::loadView('lab.pdf.results', $data);
    return $pdf->download("resultado-{$order->order_number}.pdf");
}

private function prepareResultsForPDF($order)
{
    $results = [];
    
    foreach ($order->details as $detail) {
        $examResults = [];
        
        foreach ($detail->exam->items as $item) {
            $result = $detail->results->where('lab_exam_item_id', $item->id)->first();
            $reference = $item->getApplicableReference($order->patient);
            
            $examResults[] = [
                'item' => $item,
                'value' => $result ? $result->value : null,
                'reference' => $reference,
                'is_out_of_range' => $result && $reference 
                    ? $item->isOutOfRange($result->value, $order->patient)
                    : false,
                'is_header' => $item->type === 'E',
                'is_numeric' => $item->type === 'N'
            ];
        }
        
        $results[] = [
            'exam' => $detail->exam,
            'items' => $examResults
        ];
    }
    
    return $results;
}
```

---

## 🧪 Casos de Prueba

### Test 1: Validación de Hemoglobina

```php
// tests/Unit/LabExamItemTest.php

public function test_hemoglobina_normal_para_adulto()
{
    $patient = User::factory()->create([
        'fecha_nacimiento' => now()->subYears(30),
        'sexo' => 'M'
    ]);
    
    $item = LabExamItem::find(1933); // HEMOGLOBINA
    
    $this->assertFalse($item->isOutOfRange(14.5, $patient)); // Normal
    $this->assertTrue($item->isOutOfRange(10.0, $patient));  // Bajo
    $this->assertTrue($item->isOutOfRange(18.0, $patient));  // Alto
}

public function test_hemoglobina_referencia_simple()
{
    $patient = User::factory()->create([
        'fecha_nacimiento' => now()->subYears(30),
        'sexo' => 'M'
    ]);
    
    $item = LabExamItem::find(1933);
    $reference = $item->getApplicableReference($patient);
    
    $this->assertEquals('simple', $reference['type']);
    $this->assertEquals('12.0 - 16.0', $reference['text']);
}
```

### Test 2: Validación de HCG por Semanas

```php
public function test_hcg_embarazo_4_semanas()
{
    $patient = User::factory()->create([
        'fecha_nacimiento' => now()->subYears(28),
        'sexo' => 'F'
    ]);
    
    $item = LabExamItem::find(276); // H.C.G. BETA
    
    // Valor normal para 4 semanas: 9.5 - 750.0
    $this->assertFalse($item->isOutOfRange(450, $patient));
    
    // Valor bajo para 4 semanas
    $this->assertTrue($item->isOutOfRange(5, $patient));
    
    // Valor alto para 4 semanas (podría ser 5 semanas)
    $this->assertTrue($item->isOutOfRange(5000, $patient));
}
```

---

## 🔧 Migraciones para Mejoras

### Agregar Índices para Mejorar Performance

```php
// database/migrations/2025_12_11_create_lab_indexes.php

public function up()
{
    Schema::table('lab_reference_ranges', function (Blueprint $table) {
        $table->index(['lab_exam_item_id', 'lab_reference_group_id'], 
            'idx_ranges_item_group');
    });
    
    Schema::table('lab_reference_groups', function (Blueprint $table) {
        $table->index(['sex', 'age_start_year', 'age_end_year'], 
            'idx_groups_search');
    });
}
```

---

## 📊 Query para Análisis de Datos

### Estadísticas de Referencias

```sql
-- Contar items por tipo de referencia
SELECT 
    'Solo Referencia Simple' as tipo,
    COUNT(*) as cantidad
FROM lab_exam_items
WHERE reference_value IS NOT NULL 
    AND id NOT IN (SELECT DISTINCT lab_exam_item_id FROM lab_reference_ranges)

UNION ALL

SELECT 
    'Solo Rangos Avanzados' as tipo,
    COUNT(DISTINCT lab_exam_item_id) as cantidad
FROM lab_reference_ranges
WHERE lab_exam_item_id NOT IN (
    SELECT id FROM lab_exam_items WHERE reference_value IS NOT NULL
)

UNION ALL

SELECT 
    'Ambos (Simple + Avanzado)' as tipo,
    COUNT(DISTINCT rr.lab_exam_item_id) as cantidad
FROM lab_reference_ranges rr
INNER JOIN lab_exam_items i ON rr.lab_exam_item_id = i.id
WHERE i.reference_value IS NOT NULL

UNION ALL

SELECT 
    'Sin Referencia' as tipo,
    COUNT(*) as cantidad
FROM lab_exam_items
WHERE reference_value IS NULL 
    AND id NOT IN (SELECT DISTINCT lab_exam_item_id FROM lab_reference_ranges);
```

---

## 🎯 Script de Limpieza

### Eliminar Rangos Duplicados

```sql
-- Encontrar items con referencia simple Y avanzada idéntica
SELECT 
    i.id,
    i.name,
    i.reference_value,
    rr.value_min,
    rr.value_max
FROM lab_exam_items i
INNER JOIN lab_reference_ranges rr ON i.id = rr.lab_exam_item_id
INNER JOIN lab_reference_groups rg ON rr.lab_reference_group_id = rg.id
WHERE rg.code = 'M017' -- VALOR1-TODOS
    AND i.reference_value IS NOT NULL
    AND CONCAT(rr.value_min, ' - ', rr.value_max) = i.reference_value;

-- Estos rangos se pueden eliminar porque son redundantes
```

---

## 📝 Documentación de API

### Endpoint para Obtener Referencias

```php
// routes/api.php
Route::get('/lab/items/{item}/reference', [LabController::class, 'getReference']);

// app/Http/Controllers/LabController.php
public function getReference(Request $request, $itemId)
{
    $item = LabExamItem::findOrFail($itemId);
    
    $patientId = $request->input('patient_id');
    $patient = $patientId ? User::find($patientId) : null;
    
    $reference = $item->getApplicableReference($patient);
    
    return response()->json([
        'item' => [
            'id' => $item->id,
            'name' => $item->name,
            'unit' => $item->unit,
            'type' => $item->type
        ],
        'reference' => $reference,
        'patient' => $patient ? [
            'age' => $patient->edad,
            'sex' => $patient->sexo
        ] : null
    ]);
}
```

**Ejemplo de Respuesta:**
```json
{
    "item": {
        "id": 1933,
        "name": "HEMOGLOBINA:",
        "unit": "g/dL",
        "type": "N"
    },
    "reference": {
        "type": "simple",
        "text": "12.0 - 16.0",
        "display": "12.0 - 16.0"
    },
    "patient": {
        "age": 35,
        "sex": "M"
    }
}
```

---

## 🎓 Conclusión

Este documento proporciona ejemplos prácticos de código para trabajar con el sistema de referencias de laboratorio. Los métodos implementados priorizan rangos avanzados cuando existen, pero mantienen compatibilidad con referencias simples.
