# SQL para Eliminar Grupos Sin Uso y Caso Real de VALOR-MASC

## 🗑️ SQL para Eliminar Grupos NIÑOS-XX (Sin Uso)

```sql
-- ============================================
-- ELIMINAR GRUPOS DE REFERENCIA SIN USO
-- ============================================

-- Verificar que no tienen referencias (debe retornar 0)
SELECT COUNT(*) as total_referencias
FROM lab_reference_ranges
WHERE lab_reference_group_id IN (26, 27, 28, 29);

-- Si el resultado es 0, proceder a eliminar
DELETE FROM lab_reference_groups
WHERE id IN (26, 27, 28, 29);

-- O por código:
DELETE FROM lab_reference_groups
WHERE code IN ('M038', 'M039', 'M040', 'M041');

-- O por descripción:
DELETE FROM lab_reference_groups
WHERE description IN ('NIÑOS-01', 'NIÑOS-02', 'NIÑOS-03', 'NIÑOS-04');

-- Verificar eliminación (debe retornar 25)
SELECT COUNT(*) as grupos_activos
FROM lab_reference_groups
WHERE active = 1;
```

### **Resultado esperado:**
- Antes: 29 grupos
- Después: 25 grupos

---

## 📊 Caso Real: PSA (Antígeno Prostático Específico)

### **Contexto:**
El PSA es un marcador tumoral usado para detectar cáncer de próstata. Los valores normales **aumentan con la edad**, por lo que se usan diferentes rangos según el grupo etario.

### **Configuración del Examen:**

```sql
-- ============================================
-- EJEMPLO REAL: PSA CON MÚLTIPLES VALOR-MASC
-- ============================================

-- 1. Crear el examen PSA (si no existe)
INSERT INTO lab_exams (code, lab_category_id, name, abbreviation, price, active)
VALUES ('PSA', 20, 'ANTÍGENO PROSTÁTICO ESPECÍFICO', 'PSA', 15.00, 1);

-- Obtener el ID del examen (supongamos que es 600)
SET @exam_id = LAST_INSERT_ID();

-- 2. Crear el parámetro PSA
INSERT INTO lab_exam_items (lab_exam_id, code, name, unit, reference_value, type, `order`)
VALUES (@exam_id, 'PSA', 'PSA Total', 'ng/mL', '< 4.0', 'numeric', 1);

-- Obtener el ID del item (supongamos que es 1500)
SET @item_id = LAST_INSERT_ID();

-- 3. Configurar referencias con VALOR-MASC

-- VALOR1-MASC: Hombres 40-49 años
INSERT INTO lab_reference_ranges 
(lab_exam_item_id, lab_reference_group_id, condition, value_min, value_max, value_text, `order`)
VALUES 
(@item_id, 18, 'Hombres 40-49 años', NULL, 2.5, NULL, 1);

-- VALOR2-MASC: Hombres 50-59 años
INSERT INTO lab_reference_ranges 
(lab_exam_item_id, lab_reference_group_id, condition, value_min, value_max, value_text, `order`)
VALUES 
(@item_id, 19, 'Hombres 50-59 años', NULL, 3.5, NULL, 2);

-- VALOR3-MASC: Hombres 60-69 años
INSERT INTO lab_reference_ranges 
(lab_exam_item_id, lab_reference_group_id, condition, value_min, value_max, value_text, `order`)
VALUES 
(@item_id, 20, 'Hombres 60-69 años', NULL, 4.5, NULL, 3);

-- VALOR4-MASC: Hombres 70+ años
INSERT INTO lab_reference_ranges 
(lab_exam_item_id, lab_reference_group_id, condition, value_min, value_max, value_text, `order`)
VALUES 
(@item_id, 21, 'Hombres 70+ años', NULL, 6.5, NULL, 4);
```

### **Tabla de Referencia PSA:**

| Grupo | Código | Edad | Valor Normal | Condición |
|-------|--------|------|--------------|-----------|
| VALOR1-MASC | M030 | 40-49 años | < 2.5 ng/mL | Hombres 40-49 años |
| VALOR2-MASC | M031 | 50-59 años | < 3.5 ng/mL | Hombres 50-59 años |
| VALOR3-MASC | M032 | 60-69 años | < 4.5 ng/mL | Hombres 60-69 años |
| VALOR4-MASC | M033 | 70+ años | < 6.5 ng/mL | Hombres 70+ años |

### **Interpretación Clínica:**

```
Paciente: Hombre de 45 años
PSA: 3.2 ng/mL
Referencia: < 2.5 ng/mL (VALOR1-MASC)
Resultado: ⚠️ ELEVADO (requiere evaluación)

Paciente: Hombre de 55 años
PSA: 3.2 ng/mL
Referencia: < 3.5 ng/mL (VALOR2-MASC)
Resultado: ✅ NORMAL

Paciente: Hombre de 65 años
PSA: 3.2 ng/mL
Referencia: < 4.5 ng/mL (VALOR3-MASC)
Resultado: ✅ NORMAL

Paciente: Hombre de 75 años
PSA: 3.2 ng/mL
Referencia: < 6.5 ng/mL (VALOR4-MASC)
Resultado: ✅ NORMAL
```

---

## 📊 Otro Caso Real: Testosterona Total

### **Contexto:**
La testosterona disminuye con la edad. Se usan diferentes rangos para evaluar correctamente.

### **Configuración:**

```sql
-- ============================================
-- EJEMPLO REAL: TESTOSTERONA CON VALOR-MASC
-- ============================================

-- Supongamos que el item de Testosterona tiene ID 1600

-- VALOR1-MASC: Hombres jóvenes (20-39 años)
INSERT INTO lab_reference_ranges 
(lab_exam_item_id, lab_reference_group_id, condition, value_min, value_max, value_text, `order`)
VALUES 
(1600, 18, 'Hombres 20-39 años', 300, 1000, NULL, 1);

-- VALOR2-MASC: Hombres adultos (40-59 años)
INSERT INTO lab_reference_ranges 
(lab_exam_item_id, lab_reference_group_id, condition, value_min, value_max, value_text, `order`)
VALUES 
(1600, 19, 'Hombres 40-59 años', 240, 870, NULL, 2);

-- VALOR3-MASC: Hombres mayores (60+ años)
INSERT INTO lab_reference_ranges 
(lab_exam_item_id, lab_reference_group_id, condition, value_min, value_max, value_text, `order`)
VALUES 
(1600, 20, 'Hombres 60+ años', 200, 740, NULL, 3);

-- VALOR4-MASC: Niños prepúberes
INSERT INTO lab_reference_ranges 
(lab_exam_item_id, lab_reference_group_id, condition, value_min, value_max, value_text, `order`)
VALUES 
(1600, 21, 'Niños prepúberes', 10, 50, NULL, 4);

-- VALOR5-MASC: Adolescentes (10-19 años)
INSERT INTO lab_reference_ranges 
(lab_exam_item_id, lab_reference_group_id, condition, value_min, value_max, value_text, `order`)
VALUES 
(1600, 23, 'Adolescentes 10-19 años', 100, 970, NULL, 5);
```

### **Tabla de Referencia Testosterona:**

| Grupo | Código | Edad | Rango Normal (ng/dL) | Condición |
|-------|--------|------|---------------------|-----------|
| VALOR1-MASC | M030 | 20-39 años | 300-1000 | Hombres jóvenes |
| VALOR2-MASC | M031 | 40-59 años | 240-870 | Hombres adultos |
| VALOR3-MASC | M032 | 60+ años | 200-740 | Hombres mayores |
| VALOR4-MASC | M033 | Prepúberes | 10-50 | Niños prepúberes |
| VALOR5-MASC | M035 | 10-19 años | 100-970 | Adolescentes |

### **Interpretación Clínica:**

```
Paciente: Hombre de 30 años
Testosterona: 450 ng/dL
Referencia: 300-1000 ng/dL (VALOR1-MASC)
Resultado: ✅ NORMAL

Paciente: Hombre de 50 años
Testosterona: 450 ng/dL
Referencia: 240-870 ng/dL (VALOR2-MASC)
Resultado: ✅ NORMAL

Paciente: Hombre de 70 años
Testosterona: 450 ng/dL
Referencia: 200-740 ng/dL (VALOR3-MASC)
Resultado: ✅ NORMAL

Paciente: Hombre de 70 años
Testosterona: 150 ng/dL
Referencia: 200-740 ng/dL (VALOR3-MASC)
Resultado: ⚠️ BAJO (hipogonadismo)
```

---

## 🎯 Resumen

### **SQL para Eliminar Grupos Sin Uso:**
```sql
-- Verificar primero
SELECT COUNT(*) FROM lab_reference_ranges 
WHERE lab_reference_group_id IN (26, 27, 28, 29);

-- Si retorna 0, eliminar
DELETE FROM lab_reference_groups 
WHERE id IN (26, 27, 28, 29);
```

### **Casos Reales de Uso de VALOR-MASC:**

1. **PSA (Antígeno Prostático):**
   - VALOR1-MASC: 40-49 años → < 2.5 ng/mL
   - VALOR2-MASC: 50-59 años → < 3.5 ng/mL
   - VALOR3-MASC: 60-69 años → < 4.5 ng/mL
   - VALOR4-MASC: 70+ años → < 6.5 ng/mL

2. **Testosterona Total:**
   - VALOR1-MASC: 20-39 años → 300-1000 ng/dL
   - VALOR2-MASC: 40-59 años → 240-870 ng/dL
   - VALOR3-MASC: 60+ años → 200-740 ng/dL
   - VALOR4-MASC: Prepúberes → 10-50 ng/dL
   - VALOR5-MASC: Adolescentes → 100-970 ng/dL

### **Ventaja de usar VALOR-MASC:**
✅ Permite definir múltiples rangos para el mismo parámetro  
✅ Documenta claramente las condiciones en el campo "Condición"  
✅ Facilita la interpretación según la edad del paciente  
✅ Evita errores de interpretación clínica  

---

**Fecha:** 2025-12-11  
**Estado:** ✅ SQL y ejemplos listos para usar
