-- ============================================================================
-- SQL PARA MEJORAR EL SISTEMA DE REFERENCIAS DE LABORATORIO
-- ============================================================================
-- Fecha: 2025-12-11
-- Descripción: Agrega grupos de referencia con rangos de edad específicos
--              para permitir selección automática de rangos
-- ============================================================================

-- PASO 1: Agregar grupos de edad específicos para HOMBRES
-- ============================================================================

INSERT INTO lab_reference_groups (description, sex, age_start_year, age_end_year, active, created_at, updated_at) VALUES
-- Hombres por grupos de edad
('ADULTOS JOVENES - Masculino', 1, 18, 30, 1, NOW(), NOW()),
('ADULTOS - Masculino', 1, 31, 50, 1, NOW(), NOW()),
('ADULTOS MADUROS - Masculino', 1, 51, 70, 1, NOW(), NOW()),
('ADULTOS MAYORES - Masculino', 1, 71, 120, 1, NOW(), NOW());

-- PASO 2: Agregar grupos de edad específicos para MUJERES
-- ============================================================================

INSERT INTO lab_reference_groups (description, sex, age_start_year, age_end_year, active, created_at, updated_at) VALUES
-- Mujeres por grupos de edad
('ADULTOS JOVENES - Femenino', 2, 18, 30, 1, NOW(), NOW()),
('ADULTOS - Femenino', 2, 31, 50, 1, NOW(), NOW()),
('ADULTOS MADUROS - Femenino', 2, 51, 70, 1, NOW(), NOW()),
('ADULTOS MAYORES - Femenino', 2, 71, 120, 1, NOW(), NOW());

-- PASO 3: Agregar grupos específicos para MUJERES EN EDAD FÉRTIL
-- ============================================================================

INSERT INTO lab_reference_groups (description, sex, age_start_year, age_end_year, active, created_at, updated_at) VALUES
-- Mujeres en edad fértil (para hormonas)
('MUJERES EDAD FERTIL - Femenino', 2, 15, 45, 1, NOW(), NOW()),
('MUJERES PREMENOPAUSIA - Femenino', 2, 40, 50, 1, NOW(), NOW()),
('MUJERES POSTMENOPAUSIA - Femenino', 2, 51, 120, 1, NOW(), NOW());

-- ============================================================================
-- VERIFICACIÓN: Ver los grupos creados
-- ============================================================================

SELECT 
    id,
    description,
    CASE sex
        WHEN 1 THEN 'Masculino'
        WHEN 2 THEN 'Femenino'
        WHEN 3 THEN 'Todos'
    END as sexo,
    CONCAT(age_start_year, '-', age_end_year, ' años') as rango_edad,
    active
FROM lab_reference_groups
WHERE description LIKE '%ADULTOS%' 
   OR description LIKE '%MUJERES%'
ORDER BY sex, age_start_year;

-- ============================================================================
-- NOTAS IMPORTANTES
-- ============================================================================

/*
CÓMO USAR LOS NUEVOS GRUPOS:

1. PARA EXÁMENES COMUNES (Hemograma, Química Básica):
   - Usa los grupos ADULTOS JOVENES, ADULTOS, ADULTOS MADUROS, ADULTOS MAYORES
   - El sistema seleccionará automáticamente según la edad del paciente
   
   Ejemplo: Hemoglobina
   - ADULTOS JOVENES - Masculino (18-30 años): 13.5-17.5 g/dL
   - ADULTOS - Masculino (31-50 años): 13.5-17.5 g/dL
   - ADULTOS MADUROS - Masculino (51-70 años): 13.0-17.0 g/dL
   - ADULTOS MAYORES - Masculino (71+ años): 12.5-16.5 g/dL

2. PARA EXÁMENES HORMONALES COMPLEJOS:
   - Sigue usando VALOR1-MASC, VALOR2-FEME, etc.
   - Especifica la condición en el campo "Condición Especial"
   - El sistema intentará parsear la edad de la condición
   
   Ejemplo: Testosterona
   - VALOR1-MASC | Condición: "Hombres 18-30 años" | 300-1000 ng/dL
   - VALOR1-MASC | Condición: "Hombres 31-50 años" | 250-900 ng/dL
   - VALOR1-MASC | Condición: "Hombres 51-70 años" | 200-800 ng/dL
   
3. PARA CASOS ESPECIALES (Embarazo, Ciclo Menstrual):
   - Usa VALOR-X con condiciones descriptivas
   - El sistema mostrará TODOS los rangos para que el médico interprete
   
   Ejemplo: Progesterona
   - VALOR2-FEME | Condición: "Fase folicular" | 0.2-0.8 ng/mL
   - VALOR2-FEME | Condición: "Fase lútea" | 5.0-20.0 ng/mL
   - VALOR2-FEME | Condición: "Post-menopausia" | <0.5 ng/mL

FORMATOS DE CONDICIÓN SOPORTADOS:
- "18-30 años" o "Hombres 18-30 años"
- ">70 años" o "Mayores de 70 años"
- ">=65 años"
- "<18 años" o "Menores de 18 años"
- "<=17 años"

VENTAJAS DEL NUEVO SISTEMA:
✅ Selección automática cuando es posible
✅ Muestra múltiples rangos cuando no puede decidir
✅ Parsing inteligente de condiciones especiales
✅ Compatible con grupos existentes (VALOR-X)
✅ No requiere cambios en rangos ya configurados
*/

-- ============================================================================
-- EJEMPLO COMPLETO: Configurar Testosterona Total
-- ============================================================================

/*
-- 1. Buscar el ID del parámetro
SELECT id, name FROM lab_exam_items WHERE name LIKE '%TESTOSTERONA%';

-- 2. Agregar rangos usando los nuevos grupos (OPCIÓN A - Recomendada)
INSERT INTO lab_reference_ranges (lab_exam_item_id, lab_reference_group_id, value_min, value_max, condition, active, created_at, updated_at) VALUES
-- Asumiendo que el item_id es 123 y los group_ids son los recién creados
(123, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS JOVENES - Masculino'), 300, 1000, NULL, 1, NOW(), NOW()),
(123, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS - Masculino'), 250, 900, NULL, 1, NOW(), NOW()),
(123, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS MADUROS - Masculino'), 200, 800, NULL, 1, NOW(), NOW()),
(123, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS MAYORES - Masculino'), 150, 700, NULL, 1, NOW(), NOW());

-- 3. O usar VALOR1-MASC con condiciones (OPCIÓN B - Para casos complejos)
INSERT INTO lab_reference_ranges (lab_exam_item_id, lab_reference_group_id, value_min, value_max, condition, active, created_at, updated_at) VALUES
(123, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR1-MASC'), 300, 1000, 'Hombres 18-30 años', 1, NOW(), NOW()),
(123, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR1-MASC'), 250, 900, 'Hombres 31-50 años', 1, NOW(), NOW()),
(123, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR1-MASC'), 200, 800, 'Hombres 51-70 años', 1, NOW(), NOW()),
(123, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR1-MASC'), 150, 700, 'Hombres >70 años', 1, NOW(), NOW());
*/

-- ============================================================================
-- FIN DEL SCRIPT
-- ============================================================================
