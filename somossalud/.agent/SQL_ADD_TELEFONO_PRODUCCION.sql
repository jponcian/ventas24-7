-- ================================================
-- MIGRACIÓN: Agregar campo telefono a tabla usuarios
-- Fecha: 2025-12-01
-- Descripción: Agrega el campo telefono para WhatsApp
-- ================================================

-- Agregar columna telefono
ALTER TABLE `usuarios` 
ADD COLUMN `telefono` VARCHAR(20) NULL 
AFTER `email`;

-- Verificar que se agregó correctamente
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
  AND TABLE_NAME = 'usuarios' 
  AND COLUMN_NAME = 'telefono';

-- ================================================
-- FORMATO VÁLIDO DE NÚMEROS:
-- ================================================
-- Local: 0414-1234567, 04141234567
-- Internacional: +584141234567, 584141234567
--
-- Operadoras soportadas:
-- - Movistar: 0414, 0424
-- - Digitel:  0412, 0422
-- - Movilnet: 0416, 0426
-- ================================================

-- Ejemplos de actualización (OPCIONAL - no ejecutar a menos que sea necesario)
-- UPDATE usuarios SET telefono = '0414-1234567' WHERE id = 1;
-- UPDATE usuarios SET telefono = '+584141234567' WHERE email = 'usuario@ejemplo.com';
