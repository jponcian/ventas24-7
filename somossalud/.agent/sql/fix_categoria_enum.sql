-- Script para corregir el error "Data truncated for column 'categoria'"
-- Este script agrega 'LABORATORIO' a la lista de valores permitidos en la columna ENUM 'categoria'

ALTER TABLE `solicitudes_inventario` 
MODIFY COLUMN `categoria` ENUM('ENFERMERIA','QUIROFANO','UCI','OFICINA','LABORATORIO') 
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL;

-- Verificación opcional (solo informativo)
-- SHOW COLUMNS FROM `solicitudes_inventario` LIKE 'categoria';
