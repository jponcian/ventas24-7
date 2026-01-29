/*
 Navicat Premium Data Transfer

 Source Server         : ZZ - ponciano
 Source Server Type    : MySQL
 Source Server Version : 101114
 Source Host           : zz.com.ve:3306
 Source Schema         : javier_ponciano_4

 Target Server Type    : MySQL
 Target Server Version : 101114
 File Encoding         : 65001

 Date: 28/01/2026 22:28:53
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for compras
-- ----------------------------
DROP TABLE IF EXISTS `compras`;
CREATE TABLE `compras`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `negocio_id` int NOT NULL,
  `proveedor_id` int NULL DEFAULT NULL,
  `moneda` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'USD',
  `tasa` decimal(10, 4) NULL DEFAULT 1.0000,
  `estado` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'completada',
  `fecha` datetime NULL DEFAULT current_timestamp,
  `total` decimal(10, 2) NULL DEFAULT 0.00,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_compras_negocio`(`negocio_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of compras
-- ----------------------------
INSERT INTO `compras` VALUES (1, 1, 1, 'USD', 358.9247, 'anulada', '2026-01-27 17:11:03', 117.00);
INSERT INTO `compras` VALUES (2, 1, NULL, 'USD', 361.4906, 'completada', '2026-01-28 14:48:13', 14.50);
INSERT INTO `compras` VALUES (3, 1, NULL, 'USD', 361.4906, 'completada', '2026-01-28 14:59:44', 8.00);

-- ----------------------------
-- Table structure for compras_items
-- ----------------------------
DROP TABLE IF EXISTS `compras_items`;
CREATE TABLE `compras_items`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `compra_id` int NOT NULL,
  `producto_id` int NOT NULL,
  `cantidad` decimal(10, 2) NOT NULL,
  `costo_unitario` decimal(10, 2) NOT NULL,
  `costo_origen` decimal(10, 2) NULL DEFAULT NULL,
  `moneda_origen` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of compras_items
-- ----------------------------
INSERT INTO `compras_items` VALUES (1, 1, 233, 3.00, 39.00, 39.00, 'USD');
INSERT INTO `compras_items` VALUES (2, 2, 38, 20.00, 0.73, 0.73, 'USD');
INSERT INTO `compras_items` VALUES (3, 3, 54, 12.00, 0.67, 0.67, 'USD');

-- ----------------------------
-- Table structure for detalle_ventas
-- ----------------------------
DROP TABLE IF EXISTS `detalle_ventas`;
CREATE TABLE `detalle_ventas`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `venta_id` int NOT NULL,
  `producto_id` int NOT NULL,
  `cantidad` decimal(10, 2) NOT NULL,
  `precio_unitario_bs` decimal(10, 2) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `venta_id`(`venta_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of detalle_ventas
-- ----------------------------
INSERT INTO `detalle_ventas` VALUES (1, 1, 233, 1.00, 1503.99);
INSERT INTO `detalle_ventas` VALUES (2, 2, 234, 1.00, 764.44);
INSERT INTO `detalle_ventas` VALUES (3, 3, 202, 1.00, 213.33);
INSERT INTO `detalle_ventas` VALUES (4, 3, 183, 1.00, 760.88);
INSERT INTO `detalle_ventas` VALUES (5, 4, 234, 1.00, 771.69);
INSERT INTO `detalle_ventas` VALUES (6, 5, 235, 1.00, 653.24);
INSERT INTO `detalle_ventas` VALUES (7, 5, 235, 20.00, 653.24);
INSERT INTO `detalle_ventas` VALUES (8, 6, 4, 1.00, 143.57);
INSERT INTO `detalle_ventas` VALUES (9, 6, 15, 1.00, 696.31);
INSERT INTO `detalle_ventas` VALUES (10, 6, 59, 1.00, 466.60);
INSERT INTO `detalle_ventas` VALUES (11, 6, 206, 1.00, 671.19);
INSERT INTO `detalle_ventas` VALUES (12, 6, 5, 1.00, 358.92);
INSERT INTO `detalle_ventas` VALUES (13, 7, 102, 1.00, 234.97);
INSERT INTO `detalle_ventas` VALUES (14, 8, 234, 1.00, 777.20);
INSERT INTO `detalle_ventas` VALUES (15, 9, 77, 1.00, 397.64);
INSERT INTO `detalle_ventas` VALUES (16, 9, 54, 1.00, 361.49);

-- ----------------------------
-- Table structure for negocios
-- ----------------------------
DROP TABLE IF EXISTS `negocios`;
CREATE TABLE `negocios`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `rif` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `activo` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of negocios
-- ----------------------------
INSERT INTO `negocios` VALUES (1, 'Bodega', NULL, 1);
INSERT INTO `negocios` VALUES (2, 'NegocioPrueba', NULL, 1);

-- ----------------------------
-- Table structure for productos
-- ----------------------------
DROP TABLE IF EXISTS `productos`;
CREATE TABLE `productos`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `negocio_id` int NOT NULL,
  `proveedor_id` int NULL DEFAULT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `codigo_barras` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `unidad_medida` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'unidad',
  `tam_paquete` decimal(10, 2) NULL DEFAULT 1.00,
  `stock` decimal(10, 2) NULL DEFAULT 0.00,
  `bajo_inventario` int NULL DEFAULT 5,
  `moneda_base` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'USD',
  `costo_unitario` decimal(10, 2) NULL DEFAULT 0.00,
  `precio_venta_unidad` decimal(10, 2) NULL DEFAULT 0.00,
  `precio_venta_paquete` decimal(10, 2) NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT current_timestamp,
  `updated_at` timestamp NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_negocio`(`negocio_id`) USING BTREE,
  INDEX `idx_proveedor`(`proveedor_id`) USING BTREE,
  INDEX `idx_codigo`(`codigo_barras`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 351 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of productos
-- ----------------------------
INSERT INTO `productos` VALUES (1, 1, 2, 'QUESO', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 4.80, 7.00, NULL, '2026-01-27 18:05:01', '2026-01-27 18:19:43');
INSERT INTO `productos` VALUES (2, 1, 3, 'CLUB SOCIAL', NULL, NULL, 'paquete', 6.00, 0.00, 0, 'USD', 0.29, 0.40, 2.15, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (63, 1, 4, 'GLUP 2LTS', NULL, NULL, 'paquete', 6.00, 0.00, 0, 'USD', 1.08, 1.41, 1.41, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (4, 1, 5, 'CATALINAS', NULL, NULL, 'unidad', 10.00, -1.00, 0, 'USD', 3.00, 0.40, 3.50, '2026-01-27 18:05:01', '2026-01-27 21:38:11');
INSERT INTO `productos` VALUES (5, 1, 6, 'PAN SALADO', NULL, NULL, 'unidad', 1.00, -1.00, 0, 'USD', 0.80, 1.00, NULL, '2026-01-27 18:05:01', '2026-01-27 21:38:11');
INSERT INTO `productos` VALUES (6, 1, 7, 'PAN CLINEJA', NULL, NULL, 'unidad', 1.00, 0.00, 1, 'USD', 1.30, 1.60, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (300, 1, 8, 'HELADO YOGURT', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.40, 0.55, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (8, 1, 7, 'PAN RELLENO GUAYABA', NULL, NULL, 'paquete', 10.00, 0.00, 0, 'USD', 0.33, 0.45, 4.50, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (9, 1, 7, 'PAN COCO', NULL, NULL, 'paquete', 10.00, 0.00, 1, 'USD', 0.27, 0.40, 3.30, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (10, 1, 9, 'RIQUESA', '', NULL, 'unidad', 1.00, 0.00, 1, 'USD', 0.00, 3.50, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (11, 1, 10, 'SALSA SOYA AJO INGLESA DOÑA TITA', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 1.10, 1.43, 1.43, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (12, 1, 11, 'ACEITE VATEL', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 5.00, 6.00, 6.00, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (13, 1, 3, 'SALSA PASTA UW 490GR', NULL, NULL, 'unidad', 1.00, 0.00, 1, 'USD', 0.00, 2.95, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (14, 1, 4, 'ARROZ', NULL, NULL, 'paquete', 24.00, 0.00, 0, 'USD', 1.38, 1.79, 1.79, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (15, 1, 1, 'HARINA PAN', NULL, NULL, 'paquete', 20.00, -1.00, 0, 'USD', 1.55, 1.94, 1.94, '2026-01-27 18:05:01', '2026-01-27 21:38:11');
INSERT INTO `productos` VALUES (16, 1, 3, 'CARAMELO FREEGELLS', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 0.23, 0.50, 0.50, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (17, 1, 3, 'HALLS', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 0.46, 0.65, 0.65, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (339, 1, 3, 'GALLE LULU LIMON 175GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.61, 2.01, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (19, 1, 10, 'TORONTO', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.65, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (20, 1, 10, 'CHOCOLATE SAVOY', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 1.29, 1.70, 1.70, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (21, 1, 3, 'CHICLE GIGANTE', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.55, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (22, 1, NULL, 'GALLETAS MALTN\'MILK', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.25, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (23, 1, 11, 'JABÓN PROTEX 110GR', NULL, NULL, 'paquete', 3.00, 0.00, 0, 'USD', 2.50, 3.25, 9.00, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (24, 1, 4, 'ESPONJAS', NULL, NULL, 'paquete', 2.00, 0.00, 1, 'USD', 0.60, 0.85, 0.85, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (25, 1, 4, 'FREGADOR', NULL, NULL, 'paquete', 15.00, 0.00, 0, 'USD', 0.37, 0.70, 0.70, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (26, 1, NULL, 'COCA-COLA 1.5LTS', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 1.60, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (28, 1, 9, 'GATORADE', '', NULL, 'unidad', 1.00, 0.00, 1, 'USD', 0.00, 1.80, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (29, 1, 12, 'TOMATE', NULL, NULL, 'kg', 1.00, 0.00, 0, 'BS', 390.00, 550.00, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (30, 1, 12, 'CEBOLLA', NULL, NULL, 'kg', 1.00, 0.00, 0, 'BS', 390.00, 550.00, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (31, 1, 12, 'PAPA', NULL, NULL, 'kg', 1.00, 0.00, 0, 'BS', 490.00, 650.00, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (32, 1, 12, 'PLÁTANO', NULL, NULL, 'kg', 1.00, 0.00, 0, 'BS', 800.00, 1040.00, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (33, 1, 13, 'LUCKY', NULL, NULL, 'paquete', 20.00, 1.00, 0, 'USD', 3.00, 0.23, 4.50, '2026-01-27 18:05:01', '2026-01-28 15:00:56');
INSERT INTO `productos` VALUES (34, 1, 13, 'BELTMONT', NULL, NULL, 'paquete', 20.00, 1.00, 0, 'USD', 2.45, 0.18, 3.68, '2026-01-27 18:05:01', '2026-01-28 15:00:56');
INSERT INTO `productos` VALUES (35, 1, 13, 'PALLMALL', NULL, NULL, 'paquete', 20.00, 1.00, 0, 'USD', 2.45, 0.18, 3.68, '2026-01-27 18:05:01', '2026-01-28 15:00:57');
INSERT INTO `productos` VALUES (37, 1, 13, 'UNIVERSAL', NULL, NULL, 'paquete', 20.00, 1.00, 0, 'USD', 1.65, 0.12, 2.48, '2026-01-27 18:05:01', '2026-01-28 15:00:57');
INSERT INTO `productos` VALUES (38, 1, 13, 'CONSUL', NULL, NULL, 'paquete', 20.00, 1.00, 0, 'USD', 1.45, 0.11, 2.18, '2026-01-27 18:05:01', '2026-01-28 15:00:58');
INSERT INTO `productos` VALUES (39, 1, 3, 'VELAS', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.25, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (283, 1, 1, 'JUGO JUCOSA', NULL, NULL, 'paquete', 3.00, 0.00, 0, 'USD', 0.53, 0.70, 2.00, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (42, 1, 4, 'LOPERAN', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.25, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (45, 1, 14, 'DICLOFENAC POTÁSICO', NULL, NULL, 'paquete', 30.00, 0.00, 0, 'USD', 0.03, 0.15, 0.15, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (44, 1, 4, 'DICLOFENAC SÓDICO', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.10, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (46, 1, 14, 'METOCLOPRAMIDA', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.35, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (47, 1, 14, 'IBUPROFENO', NULL, NULL, 'paquete', 10.00, 0.00, 0, 'USD', 0.12, 0.20, 0.20, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (48, 1, 14, 'LORATADINA', NULL, NULL, 'paquete', 10.00, 0.00, 0, 'USD', 0.15, 0.25, 0.25, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (49, 1, 14, 'CETIRIZINA', NULL, NULL, 'paquete', 20.00, 0.00, 0, 'USD', 0.05, 0.15, 0.15, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (50, 1, 14, 'ACETAMINOFÉN', NULL, NULL, 'paquete', 20.00, 10.00, 0, 'USD', 0.05, 0.15, 0.15, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (51, 1, 14, 'OMEPRAZOL', NULL, NULL, 'paquete', 28.00, 0.00, 0, 'USD', 0.11, 0.20, 0.20, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (52, 1, 14, 'AMOXICILINA', NULL, NULL, 'paquete', 10.00, 0.00, 1, 'USD', 0.22, 0.30, 0.30, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (53, 1, 14, 'METRONIDAZOL', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.20, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (54, 1, 4, 'GLUP 1 LT', NULL, NULL, 'paquete', 12.00, 11.00, 0, 'USD', 0.67, 1.00, 1.00, '2026-01-27 18:05:01', '2026-01-28 14:59:44');
INSERT INTO `productos` VALUES (55, 1, 4, 'GLUP 400ML', NULL, NULL, 'paquete', 15.00, 0.00, 0, 'USD', 0.39, 0.60, 0.60, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (56, 1, 9, 'MALTA DE BOTELLA', NULL, NULL, 'paquete', 36.00, 0.00, 1, 'USD', 0.46, 0.65, 0.65, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (57, 1, 9, 'PEPSI-COLA 1.25LTS', NULL, NULL, 'paquete', 6.00, 0.00, 0, 'USD', 0.75, 1.10, 1.10, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (58, 1, 9, 'PEPSI-COLA 2LT', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 2.00, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (59, 1, 4, 'JUSTY', '', NULL, 'unidad', 1.00, -1.00, 0, 'USD', 0.00, 1.30, NULL, '2026-01-27 18:05:01', '2026-01-27 21:38:11');
INSERT INTO `productos` VALUES (60, 1, 4, 'COCA-COLA 2LTS', NULL, NULL, 'paquete', 6.00, 0.00, 0, 'USD', 1.67, 2.20, 2.20, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (61, 1, 9, 'MALTA 1.5LTS', NULL, NULL, 'paquete', 6.00, 0.00, 1, 'USD', 1.64, 2.15, 2.15, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (62, 1, 3, 'JUGO FRICAJITA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.99, 1.24, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (65, 1, NULL, 'COCA-COLA 1LT', '', NULL, 'paquete', 6.00, 0.00, 0, 'USD', 0.83, 1.10, 1.10, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (275, 1, 1, 'GOMITAS PLAY', NULL, NULL, 'paquete', 24.00, 0.00, 0, 'USD', 0.58, 0.90, 0.90, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (67, 1, 11, 'PAPEL NARANJA 400', NULL, NULL, 'paquete', 4.00, 0.00, 0, 'USD', 0.73, 1.10, 3.70, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (68, 1, 11, 'GALLETA MARIA ITALIA', NULL, NULL, 'paquete', 9.00, 0.00, 0, 'USD', 0.06, 0.10, 0.90, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (69, 1, 15, 'CAFE AMANECER 100GR', NULL, NULL, 'paquete', 10.00, 0.00, 1, 'USD', 1.30, 1.63, 1.63, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (70, 1, 15, 'CARAOTAS AMANECER', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.00, 1.35, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (71, 1, 15, 'PASTA LARGA NONNA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.75, 0.95, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (72, 1, 15, 'PASTA CORTA NONNA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.40, 2.10, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (73, 1, 16, 'DORITOS PEQ', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 0.94, 1.23, 1.23, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (74, 1, 16, 'DORITOS DIN PEQ', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 1.20, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (75, 1, 16, 'DORITOS FH PEQ', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 1.30, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (76, 1, 16, 'DORITOS DIN FH PEQ', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 1.20, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (77, 1, 16, 'CHEESE TRIS P', '', NULL, 'unidad', 1.00, -1.00, 0, 'USD', 0.00, 1.10, NULL, '2026-01-27 18:05:01', '2026-01-28 14:58:33');
INSERT INTO `productos` VALUES (78, 1, 16, 'PEPITO P', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 1.00, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (79, 1, 11, 'BOLI KRUCH', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 0.37, 0.60, 0.60, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (80, 1, 11, 'KESITOS P', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.60, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (81, 1, 1, 'PIGSY PICANTE', NULL, NULL, 'paquete', 18.00, 0.00, 1, 'USD', 0.19, 0.40, 0.40, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (82, 1, 16, 'RAQUETY', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.65, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (83, 1, 11, 'CHISKESITO PEQUEÑO', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 0.53, 0.70, 0.70, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (84, 1, 3, 'CHIPS AHOY', NULL, NULL, 'paquete', 6.00, 0.00, 0, 'USD', 0.38, 0.50, 2.75, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (85, 1, 1, 'COCO CRUCH', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.40, 1.82, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (86, 1, 11, 'SALSERITOS GRANDES', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.61, 2.01, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (87, 1, 11, 'SALSERITOS PEQUEÑOS', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 0.42, 0.60, 0.60, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (88, 1, 4, 'TOSTON TOM', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.45, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (89, 1, 3, 'MINI CHIPS', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.90, 2.30, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (90, 1, 3, 'NUCITA CRUNCH', NULL, NULL, 'unidad', 1.00, 0.00, 1, 'USD', 1.48, 1.85, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (91, 1, 11, 'FLIPS PEQUEÑO', NULL, NULL, 'paquete', 6.00, 0.00, 0, 'USD', 0.56, 0.80, 0.80, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (92, 1, 11, 'FLIPS MEDIANO', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.84, 2.50, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (93, 1, 16, 'DORITOS G', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 3.30, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (95, 1, 16, 'DORITOS FH G', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 3.30, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (244, 1, 11, 'CHESITO P', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 0.17, 0.40, 0.40, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (98, 1, 16, 'PEPITO G', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.10, 1.43, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (100, 1, 1, 'MAXCOCO', NULL, NULL, 'paquete', 10.00, 0.00, 0, 'USD', 0.78, 1.01, 1.01, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (101, 1, 3, 'CROC-CHOC', NULL, NULL, 'paquete', 24.00, 0.00, 0, 'USD', 0.20, 0.40, 0.40, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (102, 1, 3, 'TRIDENT', NULL, NULL, 'paquete', 18.00, -1.00, 0, 'USD', 0.44, 0.65, 0.65, '2026-01-27 18:05:01', '2026-01-28 10:54:49');
INSERT INTO `productos` VALUES (103, 1, 3, 'MINTY', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 0.37, 0.60, 0.60, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (104, 1, 3, 'CHICLE GUDS', NULL, NULL, 'paquete', 18.00, 0.00, 0, 'USD', 0.14, 0.30, 0.30, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (105, 1, 3, 'NUCITA TUBO', NULL, NULL, 'paquete', 12.00, 0.00, 1, 'USD', 0.92, 1.30, 1.30, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (106, 1, 16, 'DANDY', NULL, NULL, 'paquete', 16.00, 0.00, 1, 'USD', 0.29, 0.60, 0.60, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (107, 1, 3, 'OREO DE TUBO', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.33, 1.73, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (108, 1, 3, 'OREO 6S', NULL, NULL, 'paquete', 6.00, 0.00, 0, 'USD', 0.34, 0.50, 2.55, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (110, 1, 3, 'OREO FUDGE', '', NULL, 'paquete', 6.00, 0.00, 0, 'USD', 0.41, 0.65, 3.00, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (111, 1, 3, 'TAKYTA 150GR', NULL, NULL, 'paquete', 8.00, 0.00, 0, 'USD', 0.10, 0.15, 1.00, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (112, 1, 3, 'OREO DE CAJA', NULL, NULL, 'paquete', 8.00, 0.00, 0, 'USD', 0.55, 0.75, 0.75, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (113, 1, 3, 'CHUPETA PIN PON', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.50, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (114, 1, 3, 'POLVO EXPLOSIVO', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.30, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (115, 1, 3, 'CHUPETA EXPLOSIVA', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.40, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (116, 1, 3, 'CHICLE DE YOYO', NULL, NULL, 'paquete', 24.00, 0.00, 0, 'USD', 0.32, 0.50, 0.50, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (118, 1, 3, 'PIRULIN', NULL, NULL, 'paquete', 25.00, 0.00, 0, 'USD', 0.38, 0.55, 0.55, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (119, 1, 3, 'NUCITA', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 0.43, 0.60, 0.60, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (120, 1, 1, 'BRINKY', NULL, NULL, 'paquete', 10.00, 0.00, 0, 'USD', 0.26, 0.50, 0.50, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (121, 1, 16, 'PEPITAS', NULL, NULL, 'paquete', 18.00, 0.00, 0, 'USD', 0.33, 0.45, 0.45, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (122, 1, 16, 'PALITOS', NULL, NULL, 'paquete', 18.00, 0.00, 0, 'USD', 0.41, 0.55, 0.55, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (123, 1, 3, 'COLORETI', NULL, NULL, 'paquete', 24.00, 0.00, 0, 'USD', 0.19, 0.40, 0.40, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (124, 1, 3, 'SPARKIES BUBBALOO', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.40, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (125, 1, 3, 'EXTINTOR', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.95, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (126, 1, 3, 'CHUPETA DE ANILLOS', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.55, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (127, 1, 3, 'CRAYÓN CHICLE', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.25, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (128, 1, 3, 'COLORES CHICLE', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.45, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (129, 1, 3, 'CHUPETA DE MASCOTAS', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 1.30, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (130, 1, 3, 'SPINNER RING', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 1.30, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (131, 1, 3, 'JUGUETE DE POCETA', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.95, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (132, 1, 10, 'COCOSETE', NULL, NULL, 'paquete', 18.00, 0.00, 0, 'USD', 1.15, 1.50, 1.50, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (286, 1, 10, 'CEPILLO DENTAL COLGATE', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.11, 1.50, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (134, 1, 10, 'SAMBA', NULL, NULL, 'paquete', 20.00, 0.00, 0, 'USD', 1.04, 1.35, 1.35, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (135, 1, 10, 'SAMBA PEQUEÑA', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.65, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (136, 1, 11, 'FLIPS CAJA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 3.17, 4.12, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (137, 1, 3, 'CORN FLAKES DE CAJA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 2.56, 3.20, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (138, 1, 11, 'CRONCH FLAKES BOLSA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 3.21, 4.01, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (139, 1, 11, 'FRUTY AROS', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 3.70, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (140, 1, 4, 'JUMBY RIKOS G', NULL, NULL, 'paquete', 18.00, 0.00, 0, 'USD', 0.78, 1.10, 1.10, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (141, 1, 11, 'CHISKESITO GRANDE', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.38, 1.85, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (142, 1, 11, 'CHESITO G', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.58, 0.80, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (143, 1, 4, 'DOBOM 400GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 5.90, 7.38, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (144, 1, 4, 'DOBOM 200GRS', NULL, NULL, 'unidad', 12.00, 0.00, 0, 'USD', 3.00, 3.75, 45.00, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (145, 1, 4, 'DOBOM 125GRS', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 2.00, 2.50, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (146, 1, 3, 'CAMPIÑA 200GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 3.14, 3.77, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (147, 1, 3, 'CAMPIÑA 125GRS', NULL, NULL, 'unidad', 1.00, 0.00, 1, 'USD', 2.02, 2.42, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (148, 1, 11, 'LECHE UPACA', NULL, NULL, 'unidad', 1.00, 0.00, 1, 'USD', 1.69, 2.20, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (149, 1, 3, 'LECHE INDOSA 200GR', NULL, NULL, 'unidad', 1.00, 0.00, 1, 'USD', 1.10, 1.43, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (150, 1, 11, 'AVENA 200GR PANTERA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.83, 1.25, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (151, 1, 11, 'COMPOTA GRANDE', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.10, 1.43, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (152, 1, 11, 'COMPOTA PEQUEÑA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.79, 1.10, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (337, 1, 3, 'ELITE CHOC. TUBO 100GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.95, 1.23, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (154, 1, 11, 'MAIZINA 90GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.82, 1.07, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (155, 1, 11, 'MAIZINA 120GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.00, 1.30, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (156, 1, 10, 'SOPA MAGGY', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 1.71, 2.22, 2.22, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (158, 1, 10, 'LECHE CONDENSADA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 2.96, 3.55, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (159, 1, 4, 'BOKA', NULL, NULL, 'paquete', 10.00, 0.00, 0, 'USD', 0.40, 0.60, 0.60, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (160, 1, 4, 'PEGA LOKA', NULL, NULL, 'paquete', 42.00, 0.00, 0, 'USD', 0.34, 0.70, 0.70, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (161, 1, 17, 'BOMBILLO LED 10W', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.05, 1.31, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (164, 1, 11, 'CARAOTA PANTERA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.71, 2.20, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (165, 1, NULL, 'CARAOTAS DON JUAN', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 1.00, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (166, 1, 11, 'CARAOTA BLANCA PANTERA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 2.02, 2.63, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (167, 1, 11, 'FRIJOL PANTERA', NULL, NULL, 'unidad', 1.00, 0.00, 1, 'USD', 0.00, 1.50, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (168, 1, 11, 'ARVEJAS PANTERA', NULL, '', 'unidad', 1.00, 0.00, 0, 'USD', 1.60, 2.00, 2.00, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (169, 1, 11, 'MAÍZ DE COTUFAS', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.34, 1.65, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (170, 1, 15, 'CAFÉ AMANECER 200GR', NULL, NULL, 'paquete', 6.00, 0.00, 1, 'USD', 2.41, 3.01, 3.01, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (171, 1, 11, 'CAFÉ FLOR ARAUCA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 2.85, 3.71, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (172, 1, 11, 'CAFÉ ARAUCA 200GRS', NULL, NULL, 'unidad', 1.00, 0.00, 1, 'USD', 2.60, 3.30, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (173, 1, 11, 'CAFÉ ARAUCA 100GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.43, 1.75, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (174, 1, 11, 'CAFÉ ARAUCA 50GRS', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.64, 0.90, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (260, 1, 10, 'SALSA DOÑA TITA PEQ', NULL, NULL, 'paquete', 24.00, 0.00, 0, 'USD', 1.06, 1.40, 1.40, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (176, 1, 4, 'YOKOIMA 100GR', NULL, NULL, 'paquete', 10.00, 0.00, 0, 'USD', 1.35, 1.69, 1.69, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (177, 1, 15, 'FAVORITO 100GRS', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 1.50, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (178, 1, 15, 'FAVORITO 50GRS', NULL, NULL, 'paquete', 20.00, 0.00, 0, 'USD', 0.56, 0.73, 0.73, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (179, 1, 9, 'SALSA PAMPERO GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 2.10, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (180, 1, 9, 'SALSA PAMPERO PEQ', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 1.45, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (181, 1, 11, 'SALSA TIQUIRE GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 2.10, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (182, 1, 11, 'SALSA TIQUIRE PEQ', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 1.45, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (183, 1, 10, 'SALSA DOÑA TITA GR', NULL, NULL, 'paquete', 24.00, -1.00, 0, 'USD', 1.71, 2.14, 2.14, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (184, 1, 9, 'MAYONESA MAVESA PEQUEÑA', NULL, NULL, 'paquete', 24.00, 0.00, 0, 'USD', 2.04, 2.55, 2.55, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (185, 1, 3, 'MAYONESA KRAFF 175GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 2.30, 2.76, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (187, 1, 3, 'DIABLITOS 115GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 2.71, 3.25, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (188, 1, 3, 'DIABLITOS 54GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.58, 1.98, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (189, 1, 3, 'ATÚN AZUL SDLA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 2.98, 3.87, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (190, 1, 3, 'ATUN ROJO SDLA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 3.45, 4.14, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (191, 1, 4, 'SARDINA', NULL, '7595122001927', 'paquete', 24.00, 0.00, 0, 'USD', 0.73, 1.00, 1.00, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (192, 1, 11, 'VINAGRE DE MANZANA', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 1.60, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (193, 1, 10, 'VINAGRE DOÑA TITA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.00, 1.55, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (194, 1, 11, 'VINAGRE TIQUIRE', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.07, 1.40, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (195, 1, 4, 'ACEITE IDEAL 900ML', NULL, NULL, 'paquete', 12.00, 6.00, 0, 'USD', 3.28, 4.17, 4.17, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (196, 1, 4, 'ACEITE PAMPA 1/2LT', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 2.42, 3.20, 3.20, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (198, 1, 4, 'PASTA LARGA HORIZONTE', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 2.14, 2.78, 2.78, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (199, 1, 4, 'PASTA HORIZONTE CORTA', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 2.43, 3.15, 3.15, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (200, 1, 4, 'HARINA DE TRIGO', NULL, NULL, 'paquete', 10.00, 0.00, 0, 'USD', 1.16, 1.52, 1.52, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (201, 1, 11, 'AZÚCAR', NULL, '7597304223943', 'paquete', 20.00, 0.00, 0, 'USD', 1.50, 2.00, 2.00, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (202, 1, 1, 'SAL', NULL, NULL, 'paquete', 25.00, -1.00, 0, 'USD', 0.34, 0.60, 0.60, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (203, 1, 4, 'DELINE DE 250GRS', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 1.50, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (204, 1, 9, 'NELLY DE 250GRS', NULL, NULL, 'paquete', 24.00, 0.00, 1, 'USD', 1.17, 1.60, 1.60, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (205, 1, 9, 'NELLY DE 500GRS', NULL, NULL, 'unidad', 1.00, 0.00, 1, 'USD', 0.00, 2.70, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (206, 1, 9, 'MAVESA DE 250GRS', NULL, NULL, 'paquete', 24.00, -1.00, 0, 'USD', 1.44, 1.87, 1.87, '2026-01-27 18:05:01', '2026-01-27 21:38:11');
INSERT INTO `productos` VALUES (207, 1, 9, 'MAVESA DE 500GRS', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 2.00, 2.60, 2.60, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (208, 1, 1, 'HUEVOS', NULL, NULL, 'paquete', 30.00, 0.00, 0, 'USD', 0.22, 0.30, 8.00, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (209, 1, 18, 'MASA PASTELITO ROMY', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.80, 2.20, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (210, 1, 4, 'NUTRIBELLA', NULL, NULL, 'paquete', 12.00, 0.00, 1, 'USD', 0.65, 0.85, 0.85, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (211, 1, 10, 'DESODORANTE CLINICAL', NULL, NULL, 'paquete', 20.00, 0.00, 0, 'USD', 0.45, 0.65, 0.65, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (212, 1, 4, 'DESODORANTE', NULL, NULL, 'paquete', 18.00, 0.00, 0, 'USD', 0.43, 0.58, 0.58, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (213, 1, 4, 'SHAMPOO H&S', NULL, NULL, 'unidad', 1.00, 0.00, 1, 'USD', 0.00, 0.60, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (214, 1, 1, 'BOLSAS NEGRAS', NULL, NULL, 'paquete', 25.00, 0.00, 0, 'USD', 0.34, 0.55, 0.55, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (215, 1, 10, 'AXION EN CREMA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 2.11, 2.74, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (346, 1, 3, 'MARSHMALLOWS NAVIDEÑO', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.95, 1.20, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (349, 1, 10, 'CUBITOS MAGGIE', NULL, NULL, 'paquete', 250.00, 0.00, 0, 'USD', 0.20, 0.35, 0.35, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (217, 1, 10, 'COLGATE TOTAL', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 2.10, 2.63, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (218, 1, 10, 'COLGATE PLAX', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 3.25, 4.23, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (219, 1, 10, 'COLGATE TRIPLE ACCIÓN 60ML', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.73, 2.16, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (220, 1, 10, 'COLGATE TRADICIONAL 90ML', NULL, NULL, 'unidad', 12.00, 0.00, 0, 'USD', 1.50, 1.88, 22.56, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (221, 1, 10, 'COLGATE NIÑOS', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.60, 2.00, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (322, 1, 3, 'MARIA SELECTA', NULL, NULL, 'paquete', 9.00, 0.00, 0, 'USD', 0.16, 0.25, 1.86, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (223, 1, 4, 'TOALLAS AZULES', NULL, NULL, 'paquete', 30.00, 0.00, 0, 'USD', 1.34, 1.70, 1.70, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (224, 1, 1, 'TOALLAS MORADAS', NULL, NULL, 'paquete', 30.00, 0.00, 1, 'USD', 0.98, 1.40, 1.40, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (225, 1, 19, 'JABÓN ESPECIAL', NULL, NULL, 'paquete', 50.00, 0.00, 0, 'USD', 0.80, 1.20, 1.20, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (226, 1, 4, 'JABÓN POPULAR', NULL, NULL, 'paquete', 72.00, 0.00, 0, 'USD', 0.80, 1.30, 1.30, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (227, 1, 9, 'JABÓN LAS LLAVES', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 1.30, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (228, 1, 3, 'JABÓN DE AVENA', '', NULL, 'unidad', 1.00, 0.00, 1, 'USD', 0.00, 0.60, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (229, 1, 4, 'JABÓN HUGME', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.65, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (231, 1, 4, 'JABÓN LAK', NULL, NULL, 'paquete', 4.00, 0.00, 0, 'USD', 1.03, 1.50, 1.50, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (232, 1, 4, 'GELATINA CABELLO PEQ', NULL, NULL, 'paquete', 24.00, 0.00, 0, 'USD', 1.83, 2.40, 2.40, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (233, 1, 1, 'ACE ALIVE 1KG', NULL, '', 'unidad', 12.00, -1.00, 1, 'USD', 39.00, 4.23, 50.76, '2026-01-27 18:05:01', '2026-01-28 10:54:08');
INSERT INTO `productos` VALUES (234, 1, 1, 'ACE ALIVE 500GRS', NULL, NULL, 'unidad', 1.00, 10.00, 1, 'USD', 39.00, 2.15, 0.00, '2026-01-27 18:05:01', '2026-01-28 13:20:44');
INSERT INTO `productos` VALUES (235, 1, 1, 'ACE OSO BLANCO 400GRS', NULL, NULL, 'paquete', 20.00, -21.00, 0, 'USD', 1.40, 1.82, 1.82, '2026-01-27 18:05:01', '2026-01-27 18:41:01');
INSERT INTO `productos` VALUES (236, 1, 4, 'SUAVITEL', NULL, NULL, 'paquete', 12.00, 0.00, 1, 'USD', 0.66, 0.86, 0.86, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (237, 1, 4, 'CLORO LOFO 1LT', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 1.00, 1.30, 1.30, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (238, 1, 4, 'AFEITADORA', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 0.53, 0.75, 0.75, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (239, 1, 4, 'HOJILLAS', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 0.60, 1.00, 1.00, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (240, 1, 20, 'LECHE 1LT LOS ANDES', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 2.15, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (285, 1, 1, 'APUREÑITO', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 0.49, 0.75, 0.75, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (242, 1, 1, 'YESQUERO', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 0.40, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (243, 1, NULL, 'TRIDENT INDIVIDUAL', NULL, NULL, 'paquete', 60.00, 0.00, 0, 'USD', 0.09, 0.15, 0.15, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (245, 1, 3, 'ATUN RICA DELI', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 2.45, 2.94, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (246, 1, 3, 'SALSA PASTA UW 190GR', NULL, NULL, 'unidad', 1.00, 0.00, 1, 'USD', 1.17, 1.50, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (247, 1, 3, 'SORBETICO PEQ', '', NULL, 'paquete', 4.00, 0.00, 0, 'USD', 0.27, 0.40, 1.35, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (248, 1, 3, 'SORBETICO WAFER', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.17, 1.52, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (249, 1, 3, 'TANG', '', NULL, 'paquete', 15.00, 0.00, 0, 'USD', 0.43, 0.60, 0.60, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (250, 1, 3, 'CHICLE FREEGELLS', NULL, NULL, 'paquete', 15.00, 0.00, 0, 'USD', 0.24, 0.40, 0.40, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (251, 1, 3, 'CHICLE TATTOO', NULL, NULL, 'paquete', 90.00, 0.00, 0, 'USD', 0.03, 0.07, 0.07, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (254, 1, 3, 'GALLETA MARIA MINI', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.50, 0.70, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (256, 1, 1, 'COCO CRUCH', '', NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.00, 1.20, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (257, 1, 16, 'CHEESE TRIS G', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.66, 2.16, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (258, 1, 11, 'BOLI KRUNCH G', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.85, 1.25, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (259, 1, 11, 'KESITOS G', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.89, 1.25, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (262, 1, 21, 'CHAKARO GDE', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 0.67, 0.90, 0.90, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (261, 1, 22, 'DESINFECTANTE', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.78, 1.20, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (263, 1, 21, 'MANDADOR', NULL, NULL, 'paquete', 12.00, 0.00, 1, 'USD', 0.75, 1.00, 1.00, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (264, 1, 4, 'CHUPETA', NULL, NULL, 'paquete', 46.00, 0.00, 1, 'USD', 0.13, 0.20, 0.20, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (265, 1, 18, 'SALCHICHAS', NULL, NULL, 'kg', 1.00, 0.00, 0, 'USD', 4.05, 5.30, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (266, 1, 22, 'CLORO AAA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.53, 1.00, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (267, 1, 22, 'LAVAPLATOS AAA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.81, 2.35, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (268, 1, 22, 'LAVAPLATOS AA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.38, 1.80, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (269, 1, 22, 'CLORO AA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.48, 0.80, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (270, 1, 22, 'CERA BLANCA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.87, 1.13, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (271, 1, 22, 'SUAVIZANTE', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.12, 1.65, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (272, 1, 22, 'DESENGRASANTE AAA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.51, 2.00, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (329, 1, 17, 'BOMBILLO LED 20W', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.86, 2.33, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (273, 1, 3, 'MARSHMALLOWS 100GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.02, 1.30, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (274, 1, 3, 'HUEVITO SORPRESA', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 0.49, 0.70, 0.70, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (276, 1, 4, 'GALLETA SODA EL SOL', NULL, NULL, 'paquete', 10.00, 0.00, 0, 'USD', 0.16, 0.25, 2.00, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (277, 1, 4, 'YOKOIMA 50GR', NULL, NULL, 'paquete', 20.00, 0.00, 0, 'USD', 0.63, 0.81, 0.81, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (279, 1, 1, 'TIGRITO', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 0.49, 0.75, 0.75, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (280, 1, 5, 'PLAQUITAS', NULL, NULL, 'paquete', 15.00, 0.00, 1, 'USD', 0.12, 0.17, 0.17, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (282, 1, 11, 'KETCHUP CAPRI 198GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.13, 1.41, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (284, 1, 9, 'ATUN MARGARITA', NULL, NULL, 'paquete', 35.00, 0.00, 1, 'USD', 1.90, 2.38, 2.38, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (287, 1, 1, 'HOJA EXAMEN', NULL, NULL, 'paquete', 50.00, 0.00, 1, 'USD', 0.05, 0.10, 0.10, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (288, 1, 3, 'BOMBONES CORAZON', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.32, 1.75, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (289, 1, 3, 'BOMBONES ROSA', NULL, NULL, 'unidad', 1.00, 0.00, 1, 'USD', 2.23, 2.70, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (290, 1, 3, 'NUCITA CRUNCH JR', NULL, NULL, 'paquete', 6.00, 0.00, 1, 'USD', 0.40, 0.60, 0.60, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (291, 1, 3, 'YOYO NEON', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.86, 1.15, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (292, 1, 3, 'GUSANITO LOCO', NULL, NULL, 'unidad', 30.00, 0.00, 0, 'USD', 0.66, 0.86, 25.80, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (293, 1, 3, 'ACONDICIONADOR SEDAL', NULL, NULL, 'paquete', 12.00, 0.00, 1, 'USD', 0.34, 0.50, 0.50, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (294, 1, 18, 'JAMÓN', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.60, 2.00, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (295, 1, 18, 'QUESO AMARILLO', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.60, 2.00, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (296, 1, 16, 'RAQUETY G', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.83, 1.10, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (297, 1, 11, 'PAPEL AMARILLO 600', NULL, NULL, 'paquete', 4.00, 0.00, 0, 'USD', 1.00, 1.40, 5.00, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (298, 1, 3, 'COLORETI MINI', NULL, NULL, 'paquete', 36.00, 0.00, 0, 'USD', 0.11, 0.20, 0.20, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (299, 1, 3, 'MENTITAS AMBROSOLI', NULL, NULL, 'paquete', 24.00, 0.00, 0, 'USD', 0.48, 0.70, 0.70, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (310, 1, 4, 'CARAMELOS', NULL, NULL, 'paquete', 100.00, 0.00, 0, 'USD', 0.03, 0.05, 0.05, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (301, 1, 8, 'BARQUILLON', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.00, 1.40, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (302, 1, 23, 'PALETA FRESH LIMON', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.28, 0.40, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (303, 1, 23, 'PALETA PASION YOGURT', NULL, NULL, 'unidad', 9.00, 0.00, 0, 'USD', 0.35, 0.50, 4.50, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (304, 1, 23, 'PALETA EXOTICO', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.35, 0.50, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (305, 1, 23, 'BARQUILLA SUPER CONO', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.82, 1.10, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (306, 1, 23, 'POLET FERRERO ROCHER', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.36, 2.00, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (307, 1, 23, 'POLET TRIPLE CAPITA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.36, 2.00, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (308, 1, 23, 'POLET TRIPLE CAPITA COCO', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.36, 2.00, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (309, 1, 23, 'MAXI SANDWICH', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.82, 1.10, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (311, 1, 9, 'RIKESA 200GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 3.02, 3.77, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (312, 1, 11, 'PAPEL ROJO 180', NULL, NULL, 'paquete', 4.00, 0.00, 0, 'USD', 0.29, 0.50, 1.48, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (313, 1, 11, 'PAPEL VERDE 215', NULL, NULL, 'paquete', 4.00, 0.00, 0, 'USD', 0.31, 0.60, 1.85, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (314, 1, 11, 'PAPEL MARRÓN 300', NULL, NULL, 'paquete', 4.00, 0.00, 0, 'USD', 0.60, 0.90, 3.10, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (315, 1, 15, 'CAFÉ NONNA 100GR', NULL, NULL, 'paquete', 10.00, 0.00, 0, 'USD', 1.30, 1.63, 1.63, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (316, 1, 11, 'LENTEJA PANTERA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.72, 2.10, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (336, 1, 3, 'MINI MARILU TUBO 100GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.07, 1.39, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (318, 1, 10, 'MAYONESA TITA', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.62, 1.94, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (319, 1, 3, 'BOMBONES BEL', NULL, NULL, 'paquete', 50.00, 0.00, 0, 'USD', 0.08, 0.10, 0.10, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (338, 1, 3, 'ELITE VAINI TUBO 100GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.82, 1.07, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (323, 1, 3, 'MARILU TUBO 240GR', NULL, NULL, 'paquete', 6.00, 0.00, 0, 'USD', 0.32, 0.50, 2.40, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (324, 1, 3, 'CARAMELO MIEL', NULL, NULL, 'paquete', 100.00, 0.00, 1, 'USD', 0.02, 0.05, 0.05, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (325, 1, 3, 'NUTTELINI', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 0.29, 0.45, 0.45, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (330, 1, 10, 'CEPILLO DENTAL COLGATE NIÑO', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.23, 1.60, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (327, 1, 11, 'BARRILETE', NULL, NULL, 'paquete', 50.00, 0.00, 0, 'USD', 0.06, 0.80, 0.80, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (328, 1, 1, 'FRUTYS', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 1.04, 1.40, 1.40, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (341, 1, 3, 'GALLE MARILU CAJA', NULL, NULL, 'paquete', 24.00, 0.00, 0, 'USD', 0.19, 0.30, 0.30, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (332, 1, 11, 'ACEITE COPOSA 850ML', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 3.92, 4.90, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (331, 1, 10, 'JABÓN PROTEX 75GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.28, 1.66, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (333, 1, 24, 'RECARGA MOVISTAR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'BS', 150.00, 190.00, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (334, 1, 24, 'RECARGA DIGITEL', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'BS', 160.00, 200.00, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (335, 1, 24, 'RECARGA MOVILNET', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 150.00, 185.00, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (340, 1, 3, 'GALLETA BROWNIE 175GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.55, 2.02, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (342, 1, 3, 'GALLE Q-KISS 200GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 2.63, 3.16, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (343, 1, 3, 'GALLETA REX 200GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 1.26, 1.60, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (344, 1, 3, 'GALLETA LIMON 77GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.64, 0.83, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (345, 1, 3, 'GALLETA LIMON 90GR', NULL, NULL, 'unidad', 1.00, 0.00, 0, 'USD', 0.88, 1.14, NULL, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (347, 1, 3, 'CHUPA POP SURTIDO', NULL, NULL, 'paquete', 24.00, 0.00, 0, 'USD', 0.13, 0.20, 0.20, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (348, 1, 3, 'TATTOO CHUPETA', NULL, NULL, 'paquete', 50.00, 0.00, 0, 'USD', 0.06, 0.10, 0.10, '2026-01-27 18:05:01', '2026-01-27 18:05:01');
INSERT INTO `productos` VALUES (350, 1, 1, 'CREMA ALIDENT', NULL, NULL, 'paquete', 12.00, 0.00, 0, 'USD', 1.50, 1.95, 1.95, '2026-01-27 18:05:01', '2026-01-27 18:05:01');

-- ----------------------------
-- Table structure for proveedores
-- ----------------------------
DROP TABLE IF EXISTS `proveedores`;
CREATE TABLE `proveedores`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `negocio_id` int NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `contacto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of proveedores
-- ----------------------------
INSERT INTO `proveedores` VALUES (1, 1, 'CUEVITA', '', '', '2026-01-27 17:10:57');
INSERT INTO `proveedores` VALUES (2, 1, 'ANGELA', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (3, 1, 'TINITO', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (4, 1, 'LEO', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (5, 1, 'CATALINERO', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (6, 1, 'PANADERIA FRENTE ARABITO', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (7, 1, 'PANADERIA 4X4', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (8, 1, '4X4', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (9, 1, 'POLAR', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (10, 1, 'GADUCA', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (11, 1, 'COMARCA', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (12, 1, 'VERDUREROS', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (13, 1, 'CIGARRERO', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (14, 1, 'FARMALUNA', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (15, 1, 'ITC AMANECER', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (16, 1, 'PACO LOS LLANOS', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (17, 1, 'LA 14', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (18, 1, 'RAUL', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (19, 1, 'RAMON', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (20, 1, 'LOS ANDES', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (21, 1, 'CHAKARO', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (22, 1, 'LIMPIEZA', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (23, 1, 'CALI', NULL, NULL, '2026-01-27 18:05:01');
INSERT INTO `proveedores` VALUES (24, 1, 'EMILIO', NULL, NULL, '2026-01-27 18:05:01');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `negocio_id` int NOT NULL,
  `cedula` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `created_at` datetime NULL DEFAULT current_timestamp,
  `nombre_completo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'Usuario',
  `rol` enum('superadmin','admin','vendedor') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'admin',
  `activo` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`cedula`) USING BTREE,
  UNIQUE INDEX `cedula`(`cedula`) USING BTREE,
  INDEX `fk_user_negocio`(`negocio_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (2, 1, '16912337', '$2y$10$HJqK94WVEJk1ZAisyYtu0eQVdHCP6UqnlPk5YDfG02iQSDxayNMJC', '2026-01-26 17:43:06', 'Javier Ponciano', 'admin', 1);
INSERT INTO `users` VALUES (3, 1, '1234', '$2y$10$HJqK94WVEJk1ZAisyYtu0eQVdHCP6UqnlPk5YDfG02iQSDxayNMJC', '2026-01-26 17:43:06', 'Super Administrador', 'superadmin', 1);
INSERT INTO `users` VALUES (4, 1, '32616444', '$2y$10$HJqK94WVEJk1ZAisyYtu0eQVdHCP6UqnlPk5YDfG02iQSDxayNMJC', '2026-01-26 23:47:21', 'Adrian Ponciano', 'admin', 1);
INSERT INTO `users` VALUES (5, 2, '123456789', '$2y$10$HJqK94WVEJk1ZAisyYtu0eQVdHCP6UqnlPk5YDfG02iQSDxayNMJC', '2026-01-27 02:00:48', 'Usuario Prueba', 'admin', 1);

-- ----------------------------
-- Table structure for usuarios
-- ----------------------------
DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE `usuarios`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `cedula` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `telefono` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `foto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `cedula`(`cedula`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of usuarios
-- ----------------------------
INSERT INTO `usuarios` VALUES (1, '16912337', 'JAVIER ALEJANDRO PONCIANO', '04144679693', 'uploads/16912337.jpeg');
INSERT INTO `usuarios` VALUES (3, '15100387', 'JOAQUIN SAEZ', NULL, 'uploads/15100387.jpeg');
INSERT INTO `usuarios` VALUES (5, '30168262', 'YORVIC BETANCOURT', NULL, 'uploads/30168262.jpeg');
INSERT INTO `usuarios` VALUES (6, '33655507', 'ANAHIR PONCIANO', '04243213611', 'uploads/33655507.jpeg');
INSERT INTO `usuarios` VALUES (7, '32616444', 'ADRIAN PONCIANO', NULL, 'uploads/32616444.jpeg');
INSERT INTO `usuarios` VALUES (11, '18220246', 'MARYURY GUILLEN ', NULL, 'uploads/18220246.jpeg');
INSERT INTO `usuarios` VALUES (12, '26027662', 'JULIO MEDINA', '04141476580', 'uploads/26027662.jpeg');
INSERT INTO `usuarios` VALUES (13, '27331463', 'JOSE VALERA', '04243134281', 'uploads/27331463.jpeg');
INSERT INTO `usuarios` VALUES (14, '17165965', 'EDWUIN TORRES', '04143584499', 'uploads/17165965.jpeg');
INSERT INTO `usuarios` VALUES (15, '19476241', 'MARIA ALEJANDRA MERCADO ', '04121378506', 'uploads/19476241.jpeg');
INSERT INTO `usuarios` VALUES (16, '13820854', 'JOSE PEREZ', '04243482744', 'uploads/13820854.jpeg');
INSERT INTO `usuarios` VALUES (17, '19760009', 'JACKLIN POLANCO', '00000000000', 'uploads/19760009.jpeg');
INSERT INTO `usuarios` VALUES (18, '24662785', 'RAFAEL POLANCO', '00000000000', 'uploads/24662785.jpeg');
INSERT INTO `usuarios` VALUES (19, '15710575', 'DENNY VELIZ', '04243102770', 'uploads/15710575.jpeg');
INSERT INTO `usuarios` VALUES (20, '18220800', 'SOL KARINA RUIZ DE MEDINA', '04127775892', 'uploads/18220800.jpeg');
INSERT INTO `usuarios` VALUES (21, '28393556', 'PEDRO ALEJANDRO ROJAS GALINDO', '04129797432', 'uploads/28393556.jpeg');
INSERT INTO `usuarios` VALUES (22, '18219662', 'GERFRANK JOSE GONZALEZ CORONIL', '04124968505', 'uploads/18219662.jpeg');
INSERT INTO `usuarios` VALUES (23, '6625503', 'FIDEL RAúL MEDINA TOVAR', '04268444291', 'uploads/6625503.jpeg');

-- ----------------------------
-- Table structure for ventas
-- ----------------------------
DROP TABLE IF EXISTS `ventas`;
CREATE TABLE `ventas`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `negocio_id` int NOT NULL DEFAULT 1,
  `fecha` datetime NULL DEFAULT current_timestamp,
  `total_bs` decimal(10, 2) NULL DEFAULT NULL,
  `total_usd` decimal(10, 2) NULL DEFAULT NULL,
  `tasa` decimal(10, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_venta_negocio`(`negocio_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of ventas
-- ----------------------------
INSERT INTO `ventas` VALUES (1, 1, '2026-01-26 17:57:09', 1503.99, 4.23, 355.55);
INSERT INTO `ventas` VALUES (2, 1, '2026-01-26 23:26:59', 764.44, 2.15, 355.55);
INSERT INTO `ventas` VALUES (3, 1, '2026-01-26 23:50:06', 974.21, 2.74, 355.55);
INSERT INTO `ventas` VALUES (4, 1, '2026-01-27 13:21:39', 771.69, 2.15, 358.92);
INSERT INTO `ventas` VALUES (5, 1, '2026-01-27 18:41:01', 1306.49, 3.64, 358.92);
INSERT INTO `ventas` VALUES (6, 1, '2026-01-27 21:38:11', 2336.60, 6.51, 358.92);
INSERT INTO `ventas` VALUES (7, 1, '2026-01-28 10:54:49', 234.97, 0.65, 361.49);
INSERT INTO `ventas` VALUES (8, 1, '2026-01-28 13:20:44', 777.20, 2.15, 361.49);
INSERT INTO `ventas` VALUES (9, 1, '2026-01-28 14:58:33', 759.13, 2.10, 361.49);

SET FOREIGN_KEY_CHECKS = 1;
