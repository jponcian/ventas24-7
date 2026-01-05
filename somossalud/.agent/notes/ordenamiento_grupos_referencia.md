# Ordenamiento Personalizado del Select de Grupos de Referencia

## 🎯 Cambio Implementado

Se modificó el método `showReferences()` en `LabManagementController` para ordenar los grupos de referencia de forma personalizada.

## 📊 Orden Anterior (Alfabético Simple)

```
ADULTOS - Todos (14-150 años)
HOMBRES - Masculino (0-150 años)
INFANTES - Todos (0-0 años)
MUJERES - Femenino (0-150 años)
NEONATOS - Todos (0-0 años)
NIÑOS - Todos (1-13 años)
NIÑOS-01 - Todos (0-0 años)
NIÑOS-02 - Todos (0-0 años)
NIÑOS-03 - Todos (0-0 años)
NIÑOS-04 - Sin definir (0-0 años)
RECIEN NACIDOS - Todos (0-0 años)
VALOR1-FEME - Femenino (0-0 años)
VALOR1-MASC - Masculino (0-0 años)
VALOR1-TODOS - Todos (0-0 años)
VALOR2-FEME - Femenino (0-0 años)
VALOR2-MASC - Masculino (0-0 años)
VALOR2-TODOS - Todos (0-0 años)
VALOR3-FEME - Femenino (0-0 años)
VALOR3-MASC - Masculino (0-0 años)
... (mezclados)
```

## ✅ Orden Nuevo (Personalizado y Agrupado)

### **1. Grupos Demográficos (Alfabético)**
```
ADULTOS - Todos (14-150 años)
HOMBRES - Masculino (0-150 años)
INFANTES - Todos (0-0 años)
MUJERES - Femenino (0-150 años)
NEONATOS - Todos (0-0 años)
NIÑOS - Todos (1-13 años)
RECIEN NACIDOS - Todos (0-0 años)
```

### **2. Grupos VALOR-FEME (Ordenados 1, 2, 3, 4, 5, 6)**
```
VALOR1-FEME - Femenino (0-0 años)
VALOR2-FEME - Femenino (0-0 años)
VALOR3-FEME - Femenino (0-0 años)
VALOR4-FEME - Femenino (0-0 años)
VALOR5-FEME - Femenino (0-0 años)
VALOR6-FEME - Femenino (0-0 años)
```

### **3. Grupos VALOR-MASC (Ordenados 1, 2, 3, 4, 5)**
```
VALOR1-MASC - Masculino (0-0 años)
VALOR2-MASC - Masculino (0-0 años)
VALOR3-MASC - Masculino (0-0 años)
VALOR4-MASC - Masculino (0-0 años)
VALOR5-MASC - Masculino (0-0 años)
```

### **4. Grupos VALOR-TODOS (Ordenados 1, 2, 3, 4, 5, 6, 7)**
```
VALOR1-TODOS - Todos (0-0 años)
VALOR2-TODOS - Todos (0-0 años)
VALOR3-TODOS - Todos (0-0 años)
VALOR4-TODOS - Todos (0-0 años)
VALOR5-TODOS - Todos (0-0 años)
VALOR6-TODOS - Todos (0-0 años)
VALOR7-TODOS - Todos (0-0 años)
```

### **5. Grupos NIÑOS (Ordenados 01, 02, 03, 04)**
```
NIÑOS-01 - Todos (0-0 años)
NIÑOS-02 - Todos (0-0 años)
NIÑOS-03 - Todos (0-0 años)
NIÑOS-04 - Sin definir (0-0 años)
```

## 🔧 Implementación Técnica

### **Código Anterior:**
```php
public function showReferences($itemId)
{
    $item = LabExamItem::with('referenceRanges.group', 'exam')->findOrFail($itemId);
    $groups = LabReferenceGroup::where('active', true)->orderBy('description')->get();
    return view('lab.management.references', compact('item', 'groups'));
}
```

### **Código Nuevo:**
```php
public function showReferences($itemId)
{
    $item = LabExamItem::with('referenceRanges.group', 'exam')->findOrFail($itemId);
    
    // Obtener todos los grupos activos
    $allGroups = LabReferenceGroup::where('active', true)->get();
    
    // Separar grupos en categorías
    $demographicGroups = $allGroups->filter(function($group) {
        return !str_starts_with($group->description, 'VALOR');
    })->sortBy('description');
    
    $valorFemeGroups = $allGroups->filter(function($group) {
        return str_starts_with($group->description, 'VALOR') && str_ends_with($group->description, '-FEME');
    })->sortBy('code'); // Ordenar por código (M026, M027, etc.)
    
    $valorMascGroups = $allGroups->filter(function($group) {
        return str_starts_with($group->description, 'VALOR') && str_ends_with($group->description, '-MASC');
    })->sortBy('code'); // Ordenar por código (M030, M031, etc.)
    
    $valorTodosGroups = $allGroups->filter(function($group) {
        return str_starts_with($group->description, 'VALOR') && str_ends_with($group->description, '-TODOS');
    })->sortBy('code'); // Ordenar por código (M017, M018, etc.)
    
    $valorNinosGroups = $allGroups->filter(function($group) {
        return str_starts_with($group->description, 'NIÑOS-');
    })->sortBy('code'); // Ordenar por código (M038, M039, etc.)
    
    // Combinar en el orden deseado
    $groups = $demographicGroups
        ->concat($valorFemeGroups)
        ->concat($valorMascGroups)
        ->concat($valorTodosGroups)
        ->concat($valorNinosGroups)
        ->values(); // Resetear índices
    
    return view('lab.management.references', compact('item', 'groups'));
}
```

## 📝 Explicación del Algoritmo

1. **Obtener todos los grupos activos** de la base de datos

2. **Filtrar y separar en 5 categorías:**
   - **Demográficos:** Grupos que NO empiezan con "VALOR" (HOMBRES, MUJERES, NIÑOS, etc.)
   - **VALOR-FEME:** Grupos que empiezan con "VALOR" y terminan con "-FEME"
   - **VALOR-MASC:** Grupos que empiezan con "VALOR" y terminan con "-MASC"
   - **VALOR-TODOS:** Grupos que empiezan con "VALOR" y terminan con "-TODOS"
   - **NIÑOS-XX:** Grupos que empiezan con "NIÑOS-"

3. **Ordenar cada categoría:**
   - Demográficos: Por `description` (alfabético)
   - VALOR-FEME: Por `code` (M026, M027, M028, M029, M036, M037)
   - VALOR-MASC: Por `code` (M030, M031, M032, M033, M035)
   - VALOR-TODOS: Por `code` (M017, M018, M019, M021, M022, M025, M034)
   - NIÑOS-XX: Por `code` (M038, M039, M040, M041)

4. **Concatenar en el orden deseado:**
   - Primero: Demográficos
   - Segundo: VALOR-FEME
   - Tercero: VALOR-MASC
   - Cuarto: VALOR-TODOS
   - Quinto: NIÑOS-XX

5. **Resetear índices** con `values()` para que la colección tenga índices consecutivos

## 🎯 Ventajas del Nuevo Orden

✅ **Grupos demográficos primero:** Los más usados están al inicio
✅ **VALOR-FEME agrupados:** Fácil encontrar rangos femeninos
✅ **VALOR-MASC agrupados:** Fácil encontrar rangos masculinos
✅ **Orden numérico lógico:** VALOR1, VALOR2, VALOR3, etc.
✅ **Mejor UX:** Más intuitivo y organizado

## 🔍 Códigos de los Grupos VALOR

### **VALOR-FEME:**
- M026 → VALOR1-FEME
- M027 → VALOR2-FEME
- M028 → VALOR3-FEME
- M029 → VALOR4-FEME
- M036 → VALOR5-FEME
- M037 → VALOR6-FEME

### **VALOR-MASC:**
- M030 → VALOR1-MASC
- M031 → VALOR2-MASC
- M032 → VALOR3-MASC
- M033 → VALOR4-MASC
- M035 → VALOR5-MASC

### **VALOR-TODOS:**
- M017 → VALOR1-TODOS
- M018 → VALOR2-TODOS
- M019 → VALOR3-TODOS
- M021 → VALOR4-TODOS
- M022 → VALOR5-TODOS
- M025 → VALOR6-TODOS
- M034 → VALOR7-TODOS

## ✅ Resultado Final

El select ahora mostrará los grupos en este orden lógico y organizado, facilitando la selección del grupo apropiado para cada parámetro de laboratorio.

---

**Archivo modificado:** `app/Http/Controllers/LabManagementController.php`  
**Método:** `showReferences()`  
**Fecha:** 2025-12-11  
**Estado:** ✅ Implementado
