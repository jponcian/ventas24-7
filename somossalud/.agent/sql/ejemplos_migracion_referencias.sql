-- ============================================================================
-- EJEMPLOS PRÁCTICOS DE MIGRACIÓN
-- ============================================================================
-- Cómo migrar exámenes existentes al nuevo sistema
-- ============================================================================

-- ============================================================================
-- EJEMPLO 1: HEMOGLOBINA (Migración Simple)
-- ============================================================================

-- PASO 1: Ver configuración actual
SELECT 
    i.name as parametro,
    g.description as grupo,
    r.value_min,
    r.value_max,
    r.condition
FROM lab_reference_ranges r
JOIN lab_exam_items i ON r.lab_exam_item_id = i.id
JOIN lab_reference_groups g ON r.lab_reference_group_id = g.id
WHERE i.name LIKE '%HEMOGLOBINA%'
ORDER BY g.sex, g.age_start_year;

-- PASO 2: Agregar rangos con nuevos grupos (si aplica)
-- Asumiendo que el item_id de HEMOGLOBINA es 10
INSERT INTO lab_reference_ranges (lab_exam_item_id, lab_reference_group_id, value_min, value_max, condition, active, created_at, updated_at) VALUES
-- Hombres
(10, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS JOVENES - Masculino'), 13.5, 17.5, NULL, 1, NOW(), NOW()),
(10, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS - Masculino'), 13.5, 17.5, NULL, 1, NOW(), NOW()),
(10, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS MADUROS - Masculino'), 13.0, 17.0, NULL, 1, NOW(), NOW()),
(10, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS MAYORES - Masculino'), 12.5, 16.5, NULL, 1, NOW(), NOW()),
-- Mujeres
(10, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS JOVENES - Femenino'), 12.0, 16.0, NULL, 1, NOW(), NOW()),
(10, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS - Femenino'), 12.0, 16.0, NULL, 1, NOW(), NOW()),
(10, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS MADUROS - Femenino'), 11.5, 15.5, NULL, 1, NOW(), NOW()),
(10, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS MAYORES - Femenino'), 11.0, 15.0, NULL, 1, NOW(), NOW());

-- ============================================================================
-- EJEMPLO 2: TESTOSTERONA (Usar VALOR-X con Condiciones)
-- ============================================================================

-- PASO 1: Buscar el parámetro
SELECT id, name FROM lab_exam_items WHERE name LIKE '%TESTOSTERONA%';

-- PASO 2: Agregar rangos con condiciones parseables
-- Asumiendo que el item_id es 25
INSERT INTO lab_reference_ranges (lab_exam_item_id, lab_reference_group_id, value_min, value_max, condition, active, created_at, updated_at) VALUES
(25, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR1-MASC'), 300, 1000, 'Hombres 18-30 años', 1, NOW(), NOW()),
(25, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR1-MASC'), 250, 900, 'Hombres 31-50 años', 1, NOW(), NOW()),
(25, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR1-MASC'), 200, 800, 'Hombres 51-70 años', 1, NOW(), NOW()),
(25, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR1-MASC'), 150, 700, 'Hombres >70 años', 1, NOW(), NOW());

-- ============================================================================
-- EJEMPLO 3: PSA (Antígeno Prostático)
-- ============================================================================

-- Buscar el parámetro
SELECT id, name FROM lab_exam_items WHERE name LIKE '%PSA%';

-- Agregar rangos por edad (solo hombres)
-- Asumiendo que el item_id es 30
INSERT INTO lab_reference_ranges (lab_exam_item_id, lab_reference_group_id, value_min, value_max, condition, active, created_at, updated_at) VALUES
(30, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR1-MASC'), 0, 2.5, 'Hombres 40-49 años', 1, NOW(), NOW()),
(30, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR1-MASC'), 0, 3.5, 'Hombres 50-59 años', 1, NOW(), NOW()),
(30, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR1-MASC'), 0, 4.5, 'Hombres 60-69 años', 1, NOW(), NOW()),
(30, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR1-MASC'), 0, 6.5, 'Hombres >70 años', 1, NOW(), NOW());

-- ============================================================================
-- EJEMPLO 4: PROGESTERONA (Múltiples Condiciones)
-- ============================================================================

-- Buscar el parámetro
SELECT id, name FROM lab_exam_items WHERE name LIKE '%PROGESTERONA%';

-- Agregar rangos por fase del ciclo (solo mujeres)
-- Asumiendo que el item_id es 35
INSERT INTO lab_reference_ranges (lab_exam_item_id, lab_reference_group_id, value_min, value_max, condition, active, created_at, updated_at) VALUES
(35, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR2-FEME'), 0.2, 0.8, 'Fase folicular', 1, NOW(), NOW()),
(35, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR2-FEME'), 5.0, 20.0, 'Fase lútea', 1, NOW(), NOW()),
(35, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR2-FEME'), 0, 0.5, 'Post-menopausia', 1, NOW(), NOW()),
(35, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR3-FEME'), 10, 90, 'Embarazo 1er trimestre', 1, NOW(), NOW()),
(35, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR3-FEME'), 25, 90, 'Embarazo 2do trimestre', 1, NOW(), NOW()),
(35, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR3-FEME'), 60, 150, 'Embarazo 3er trimestre', 1, NOW(), NOW());

-- ============================================================================
-- EJEMPLO 5: CREATININA (Por Edad y Sexo)
-- ============================================================================

-- Buscar el parámetro
SELECT id, name FROM lab_exam_items WHERE name LIKE '%CREATININA%';

-- Opción A: Usar grupos con edad definida (RECOMENDADO)
-- Asumiendo que el item_id es 40
INSERT INTO lab_reference_ranges (lab_exam_item_id, lab_reference_group_id, value_min, value_max, condition, active, created_at, updated_at) VALUES
-- Hombres
(40, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS JOVENES - Masculino'), 0.7, 1.2, NULL, 1, NOW(), NOW()),
(40, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS - Masculino'), 0.8, 1.3, NULL, 1, NOW(), NOW()),
(40, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS MADUROS - Masculino'), 0.9, 1.4, NULL, 1, NOW(), NOW()),
(40, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS MAYORES - Masculino'), 0.9, 1.5, NULL, 1, NOW(), NOW()),
-- Mujeres
(40, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS JOVENES - Femenino'), 0.6, 1.1, NULL, 1, NOW(), NOW()),
(40, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS - Femenino'), 0.6, 1.1, NULL, 1, NOW(), NOW()),
(40, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS MADUROS - Femenino'), 0.7, 1.2, NULL, 1, NOW(), NOW()),
(40, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS MAYORES - Femenino'), 0.7, 1.3, NULL, 1, NOW(), NOW());

-- Opción B: Usar VALOR-X con condiciones
INSERT INTO lab_reference_ranges (lab_exam_item_id, lab_reference_group_id, value_min, value_max, condition, active, created_at, updated_at) VALUES
(40, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR1-MASC'), 0.7, 1.2, 'Hombres 18-40 años', 1, NOW(), NOW()),
(40, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR1-MASC'), 0.8, 1.3, 'Hombres 41-60 años', 1, NOW(), NOW()),
(40, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR1-MASC'), 0.9, 1.4, 'Hombres >60 años', 1, NOW(), NOW()),
(40, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR1-FEME'), 0.6, 1.1, 'Mujeres 18-40 años', 1, NOW(), NOW()),
(40, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR1-FEME'), 0.6, 1.1, 'Mujeres 41-60 años', 1, NOW(), NOW()),
(40, (SELECT id FROM lab_reference_groups WHERE description = 'VALOR1-FEME'), 0.7, 1.2, 'Mujeres >60 años', 1, NOW(), NOW());

-- ============================================================================
-- EJEMPLO 6: GLUCOSA (Simple)
-- ============================================================================

-- Buscar el parámetro
SELECT id, name FROM lab_exam_items WHERE name LIKE '%GLUCOSA%';

-- Usar grupos TODOS (aplica para ambos sexos)
-- Asumiendo que el item_id es 45
INSERT INTO lab_reference_ranges (lab_exam_item_id, lab_reference_group_id, value_min, value_max, condition, active, created_at, updated_at) VALUES
(45, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS - Todos'), 70, 100, 'Ayunas', 1, NOW(), NOW()),
(45, (SELECT id FROM lab_reference_groups WHERE description = 'ADULTOS - Todos'), 0, 140, '2 horas post-prandial', 1, NOW(), NOW());

-- ============================================================================
-- SCRIPT DE VERIFICACIÓN
-- ============================================================================

-- Ver todos los rangos de un parámetro específico
SELECT 
    i.name as parametro,
    g.description as grupo,
    CONCAT(g.age_start_year, '-', g.age_end_year) as edad_grupo,
    CASE g.sex
        WHEN 1 THEN 'Masculino'
        WHEN 2 THEN 'Femenino'
        WHEN 3 THEN 'Todos'
    END as sexo,
    CONCAT(r.value_min, ' - ', r.value_max) as rango,
    r.condition as condicion,
    r.active as activo
FROM lab_reference_ranges r
JOIN lab_exam_items i ON r.lab_exam_item_id = i.id
JOIN lab_reference_groups g ON r.lab_reference_group_id = g.id
WHERE i.name LIKE '%NOMBRE_DEL_PARAMETRO%'
ORDER BY g.sex, g.age_start_year, r.value_min;

-- ============================================================================
-- LIMPIEZA: Eliminar rangos antiguos (CUIDADO!)
-- ============================================================================

-- Ver rangos que se van a eliminar ANTES de ejecutar DELETE
SELECT 
    i.name,
    g.description,
    r.value_min,
    r.value_max,
    r.condition
FROM lab_reference_ranges r
JOIN lab_exam_items i ON r.lab_exam_item_id = i.id
JOIN lab_reference_groups g ON r.lab_reference_group_id = g.id
WHERE i.id = 10  -- Cambiar por el ID del parámetro
AND r.id IN (1, 2, 3);  -- IDs de los rangos antiguos a eliminar

-- Eliminar rangos antiguos (SOLO después de verificar)
-- DELETE FROM lab_reference_ranges WHERE id IN (1, 2, 3);

-- ============================================================================
-- FIN DE EJEMPLOS
-- ============================================================================
