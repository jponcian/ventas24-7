# Sistema de Referencias de Laboratorio - Clínica SaludSonrisa

## 📋 Resumen

El sistema de referencias permite definir **rangos de valores normales** para cada parámetro de laboratorio, considerando:
- **Sexo del paciente** (Masculino, Femenino o Todos)
- **Edad del paciente** (rangos en años)
- **Condiciones especiales** (ej: en ayunas, post-prandial)

## 🗂️ Estructura de Base de Datos

### Tablas Principales

#### 1. `lab_reference_groups` - Grupos de Referencia
Define los grupos demográficos (edad + sexo):

```
- id
- code (ej: "HAD", "MAD", "NIN")
- description (ej: "Hombres Adultos", "Mujeres Adultas", "Niños")
- sex (1=Masculino, 2=Femenino, 3=Todos)
- age_start_day, age_start_month, age_start_year
- age_end_day, age_end_month, age_end_year
- active
```

**Ejemplo:**
```
code: HAD
description: Hombres Adultos
sex: 1 (Masculino)
age_start_year: 18
age_end_year: 99
```

#### 2. `lab_reference_ranges` - Rangos de Referencia
Define los valores normales para cada parámetro según el grupo:

```
- id
- lab_exam_item_id (FK a lab_exam_items)
- lab_reference_group_id (FK a lab_reference_groups)
- condition (ej: "En ayunas", "Post-prandial")
- value_min (valor mínimo numérico)
- value_max (valor máximo numérico)
- value_text (valor de texto, ej: "Negativo")
- order
```

**Ejemplo para Hemoglobina:**
```
Grupo: Hombres Adultos (HAD)
value_min: 13.5
value_max: 17.5
condition: null
```

## 🔗 Modelos y Relaciones

### LabReferenceGroup
```php
// Relaciones
$group->ranges  // Todos los rangos que usan este grupo

// Campos
$group->sex     // 1=Masculino, 2=Femenino, 3=Todos
$group->age_start_year
$group->age_end_year
```

### LabReferenceRange
```php
// Relaciones
$range->item    // LabExamItem (parámetro del examen)
$range->group   // LabReferenceGroup (grupo demográfico)

// Campos
$range->value_min     // Valor mínimo (numérico)
$range->value_max     // Valor máximo (numérico)
$range->value_text    // Valor de texto (cualitativo)
$range->condition     // Condición especial
```

### LabExamItem
```php
// Relaciones
$item->referenceRanges  // Todos los rangos configurados

// Método clave
$item->getReferenceRangeForPatient($patient)
```

## ⚙️ Funcionamiento del Sistema

### 1. Configuración de Referencias

**Ruta:** `/lab/management/items/{item}/references`

**Proceso:**
1. Ir a la gestión de exámenes
2. Editar un examen
3. Para cada parámetro, hacer clic en "Gestionar Referencias"
4. Agregar rangos según grupos demográficos

**Ejemplo - Hemoglobina:**
```
Grupo: Hombres Adultos (18-99 años)
  → Min: 13.5, Max: 17.5

Grupo: Mujeres Adultas (18-99 años)
  → Min: 12.0, Max: 15.5

Grupo: Niños (0-17 años)
  → Min: 11.0, Max: 14.0
```

### 2. Selección Automática de Referencia

Cuando se cargan resultados, el método `getReferenceRangeForPatient()` selecciona automáticamente el rango correcto:

```php
public function getReferenceRangeForPatient($patient)
{
    // 1. Obtiene edad del paciente
    $age = Carbon::parse($patient->fecha_nacimiento)->age;
    
    // 2. Obtiene sexo del paciente
    $sex = $patient->sexo; // 'M' o 'F'
    $sexCode = ($sex === 'M') ? 1 : 2;
    
    // 3. Busca el rango que coincida con:
    //    - Sexo del paciente O sexo=3 (Todos)
    //    - Edad dentro del rango
    return $this->referenceRanges()
        ->whereHas('group', function($q) use ($age, $sexCode) {
            $q->where(function($query) use ($sexCode) {
                $query->where('sex', $sexCode)
                      ->orWhere('sex', 3); // Todos
            })
            ->where('age_start_year', '<=', $age)
            ->where('age_end_year', '>=', $age);
        })
        ->first();
}
```

### 3. Uso en las Vistas

#### Al cargar resultados (`load_results.blade.php`):
```php
$rango = $item->getReferenceRangeForPatient($order->patient);

@if($rango)
    Referencia: {{ $rango->value_min }} - {{ $rango->value_max }}
@else
    Referencia: {{ $item->reference_value ?? 'N/A' }}
@endif
```

#### En el PDF (`pdf.blade.php`):
```php
$rango = $result->examItem->getReferenceRangeForPatient($order->patient);

if ($rango) {
    // Usar rangos de la tabla lab_reference_ranges
    $min = $rango->value_min;
    $max = $rango->value_max;
} elseif ($result->examItem->reference_value) {
    // Fallback: usar reference_value del item
    $refValue = $result->examItem->reference_value;
}
```

## 🎯 Tipos de Valores de Referencia

### 1. Numérico con Rango (Min-Max)
**Ejemplo:** Hemoglobina
```
value_min: 12.0
value_max: 16.0
value_text: null
```
**Interpretación:** Normal si está entre 12.0 y 16.0

### 2. Numérico con Límite Máximo
**Ejemplo:** Colesterol Total
```
value_min: null
value_max: 200
value_text: null
```
**Interpretación:** Normal si es ≤ 200

### 3. Numérico con Límite Mínimo
**Ejemplo:** HDL Colesterol
```
value_min: 40
value_max: null
value_text: null
```
**Interpretación:** Normal si es ≥ 40

### 4. Cualitativo (Texto)
**Ejemplo:** Serología
```
value_min: null
value_max: null
value_text: "Negativo"
```
**Interpretación:** Normal si el resultado es "Negativo"

## 📍 Rutas Disponibles

```php
// Ver referencias de un parámetro
GET /lab/management/items/{item}/references

// Guardar nueva referencia
POST /lab/management/items/{item}/references

// Actualizar referencia
PUT /lab/management/references/{reference}

// Eliminar referencia
DELETE /lab/management/references/{reference}
```

## 🔄 Flujo Completo

### Configuración Inicial:
1. **Crear Grupos de Referencia** (Seeders ya incluyen grupos básicos)
   - Hombres Adultos (18-99 años)
   - Mujeres Adultas (18-99 años)
   - Niños (0-17 años)
   - etc.

2. **Configurar Referencias por Parámetro**
   - Ir a cada examen
   - Para cada parámetro, agregar rangos según grupos

### Durante la Carga de Resultados:
1. Personal de laboratorio ingresa valores
2. Sistema muestra referencia apropiada según paciente
3. Valores fuera de rango se pueden resaltar visualmente

### En el PDF:
1. Sistema selecciona referencia automáticamente
2. Muestra rango apropiado en la columna "Referencia"
3. Puede marcar valores anormales (opcional)

## 📝 Archivos Clave

### Vistas:
- `resources/views/lab/management/references.blade.php` - Gestión de referencias
- `resources/views/lab/management/edit.blade.php` - Edición de examen (enlace a referencias)
- `resources/views/lab/orders/load_results.blade.php` - Muestra referencias al cargar
- `resources/views/lab/orders/pdf.blade.php` - Referencias en PDF
- `resources/views/lab/orders/show.blade.php` - Referencias en vista de orden
- `resources/views/lab/orders/verify.blade.php` - Referencias en verificación pública

### Modelos:
- `app/Models/LabReferenceGroup.php`
- `app/Models/LabReferenceRange.php`
- `app/Models/LabExamItem.php` (método `getReferenceRangeForPatient`)

### Controlador:
- `app/Http/Controllers/LabManagementController.php`
  - `showReferences()` - Mostrar referencias
  - `storeReference()` - Guardar referencia
  - `updateReference()` - Actualizar referencia
  - `destroyReference()` - Eliminar referencia

## 💡 Ventajas del Sistema

1. ✅ **Personalización por Paciente**: Referencias específicas según edad y sexo
2. ✅ **Flexibilidad**: Soporta valores numéricos y cualitativos
3. ✅ **Fallback Inteligente**: Si no hay referencia específica, usa `reference_value` del item
4. ✅ **Fácil Mantenimiento**: Interfaz visual para gestionar referencias
5. ✅ **Validación Automática**: El sistema puede detectar valores anormales
6. ✅ **Documentación Clara**: PDFs muestran rangos apropiados

## 🔮 Mejoras Futuras (Opcionales)

1. **Validación Visual**: Resaltar en rojo valores fuera de rango
2. **Alertas Automáticas**: Notificar al médico si hay valores críticos
3. **Gráficas de Tendencia**: Comparar resultados históricos con referencias
4. **Importación Masiva**: Cargar referencias desde Excel/CSV
5. **Referencias por Condición**: Diferentes rangos según condiciones médicas
6. **Unidades Múltiples**: Convertir automáticamente entre unidades (mg/dL ↔ mmol/L)

---

**Última actualización:** 2025-12-11  
**Estado:** ✅ Implementado y funcional  
**Documentación:** Completa
