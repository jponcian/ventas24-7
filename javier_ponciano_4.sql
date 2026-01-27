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

 Date: 26/01/2026 18:47:46
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for compras
-- ----------------------------
DROP TABLE IF EXISTS `compras`;
CREATE TABLE `compras`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `producto` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `precio` double NULL DEFAULT NULL,
  `inicial` double NULL DEFAULT NULL,
  `cuotas` int NULL DEFAULT NULL,
  `fecha_compra` date NULL DEFAULT NULL,
  `usuario` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `telefono` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `owner_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of compras
-- ----------------------------
INSERT INTO `compras` VALUES (1, 'BICI GABRIEL', 140, 56, 3, '2025-11-15', 'JAVIER', '+584144679693', 1);
INSERT INTO `compras` VALUES (2, 'MACUTO', 39, 16, 3, '2025-12-01', 'JAVIER', '+584144679693', 1);
INSERT INTO `compras` VALUES (3, 'PINTURAS', 53.8, 21.52, 3, '2025-12-02', 'JAVIER', '+584144679693', 1);
INSERT INTO `compras` VALUES (4, 'MACUTO', 59.99, 12, 3, '2025-12-08', 'JAVIER', '+584144679693', 1);
INSERT INTO `compras` VALUES (5, 'SASTRERIA EL CARMEN', 50, 20, 3, '2025-12-08', 'JAVIER', '+584144679693', 1);
INSERT INTO `compras` VALUES (6, 'FORTUNA', 38.93, 18.93, 2, '2025-12-12', 'JAVIER', '+584144679693', 1);
INSERT INTO `compras` VALUES (7, 'PINTURA SATINADO', 44.79, 17.92, 3, '2025-12-16', 'JAVIER', '+584144679693', 1);
INSERT INTO `compras` VALUES (8, 'Aceite', 55, 11, 3, '2025-12-23', 'JAVIER', '+584144679693', 1);
INSERT INTO `compras` VALUES (9, 'Pinturas', 44.79, 17.92, 3, '2025-12-23', 'JAVIER', '+584144679693', 1);
INSERT INTO `compras` VALUES (10, 'Pintura azul', 28.3, 11.32, 3, '2026-01-05', 'JAVIER', '+584144679693', 1);
INSERT INTO `compras` VALUES (11, 'Game Pass', 30, 12, 3, '2026-01-20', 'JAVIER', '+584144679693', 1);

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
) ENGINE = MyISAM AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of detalle_ventas
-- ----------------------------
INSERT INTO `detalle_ventas` VALUES (1, 1, 233, 1.00, 1503.99);

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
) ENGINE = MyISAM AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of negocios
-- ----------------------------
INSERT INTO `negocios` VALUES (1, 'Bodega', NULL, 1);

-- ----------------------------
-- Table structure for pagos
-- ----------------------------
DROP TABLE IF EXISTS `pagos`;
CREATE TABLE `pagos`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `compra_id` int NULL DEFAULT NULL,
  `cuota_num` int NULL DEFAULT NULL,
  `fecha_pago` date NULL DEFAULT NULL,
  `monto` double NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `compra_id`(`compra_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of pagos
-- ----------------------------
INSERT INTO `pagos` VALUES (1, 1, 1, '2025-12-17', 28);
INSERT INTO `pagos` VALUES (2, 1, 2, '2025-12-17', 28);
INSERT INTO `pagos` VALUES (3, 2, 1, '2025-12-17', 7.67);
INSERT INTO `pagos` VALUES (4, 3, 1, '2025-12-17', 10.76);
INSERT INTO `pagos` VALUES (5, 4, 1, '2025-12-20', 16);
INSERT INTO `pagos` VALUES (6, 5, 1, '2025-12-22', 10);
INSERT INTO `pagos` VALUES (7, 1, 3, '2025-12-24', 28);
INSERT INTO `pagos` VALUES (8, 6, 1, '2025-12-25', 10);
INSERT INTO `pagos` VALUES (9, 3, 2, '2025-12-29', 10.76);
INSERT INTO `pagos` VALUES (10, 7, 1, '2025-12-29', 8.96);
INSERT INTO `pagos` VALUES (11, 2, 2, '2025-12-30', 7.67);
INSERT INTO `pagos` VALUES (12, 4, 2, '2026-01-05', 16);
INSERT INTO `pagos` VALUES (13, 5, 2, '2026-01-05', 10);
INSERT INTO `pagos` VALUES (14, 8, 1, '2026-01-06', 14.67);
INSERT INTO `pagos` VALUES (15, 9, 1, '2026-01-06', 8.96);
INSERT INTO `pagos` VALUES (16, 6, 2, '2026-01-06', 10);
INSERT INTO `pagos` VALUES (17, 2, 3, '2026-01-12', 7.67);
INSERT INTO `pagos` VALUES (18, 3, 3, '2026-01-13', 10.76);
INSERT INTO `pagos` VALUES (19, 7, 2, '2026-01-13', 8.96);
INSERT INTO `pagos` VALUES (20, 4, 3, '2026-01-17', 16);
INSERT INTO `pagos` VALUES (21, 5, 3, '2026-01-17', 10);
INSERT INTO `pagos` VALUES (22, 10, 1, '2026-01-17', 5.66);
INSERT INTO `pagos` VALUES (23, 8, 2, '2026-01-19', 14.67);
INSERT INTO `pagos` VALUES (24, 9, 2, '2026-01-19', 8.96);

-- ----------------------------
-- Table structure for productos
-- ----------------------------
DROP TABLE IF EXISTS `productos`;
CREATE TABLE `productos`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `negocio_id` int NOT NULL DEFAULT 1,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `codigo_barras` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `precio_compra` decimal(10, 2) NULL DEFAULT 0.00,
  `precio_venta` decimal(10, 2) NULL DEFAULT 0.00,
  `proveedor` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP,
  `unidad_medida` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'unidad',
  `tam_paquete` int NULL DEFAULT NULL,
  `precio_venta_paquete` decimal(10, 2) NULL DEFAULT NULL,
  `precio_venta_unidad` decimal(10, 2) NULL DEFAULT NULL,
  `moneda_compra` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'USD',
  `precio_venta_mediopaquete` decimal(10, 2) NULL DEFAULT NULL,
  `bajo_inventario` tinyint(1) NOT NULL DEFAULT 0,
  `stock` decimal(10, 2) NULL DEFAULT 0.00,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_prod_negocio`(`negocio_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 351 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of productos
-- ----------------------------
INSERT INTO `productos` VALUES (1, 1, 'QUESO', NULL, NULL, 4.80, 7.00, 'ANGELA', '2026-01-26 22:46:36', 'unidad', NULL, NULL, 6.50, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (2, 1, 'CLUB SOCIAL', NULL, NULL, 1.71, 2.15, 'TINITO', '2026-01-08 02:59:12', 'paquete', 6, 2.15, 0.40, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (63, 1, 'GLUP 2LTS', NULL, NULL, 6.50, 1.41, 'LEO', '2026-01-08 21:26:20', 'paquete', 6, NULL, 1.41, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (4, 1, 'CATALINAS', NULL, NULL, 3.00, 0.40, 'CATALINERO', '2025-10-29 23:04:06', 'unidad', 10, 3.50, 0.40, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (5, 1, 'PAN SALADO', NULL, NULL, 0.80, 1.00, 'PANADERIA FRENTE ARABITO', '2026-01-08 23:57:59', 'unidad', NULL, NULL, 1.00, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (6, 1, 'PAN CLINEJA', NULL, NULL, 1.30, 1.60, 'PANADERIA 4X4', '2026-01-17 12:06:32', 'unidad', NULL, NULL, 1.60, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (300, 1, 'HELADO YOGURT', NULL, NULL, 0.40, 0.55, '4X4', '2025-11-01 18:27:03', 'unidad', NULL, NULL, 0.55, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (8, 1, 'PAN RELLENO GUAYABA', NULL, NULL, 3.34, 4.50, 'PANADERIA 4X4', '2026-01-17 15:47:20', 'paquete', 10, 4.50, 0.45, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (9, 1, 'PAN COCO', NULL, NULL, 2.65, 3.30, 'PANADERIA 4X4', '2026-01-17 12:06:32', 'paquete', 10, 3.30, 0.40, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (10, 1, 'RIQUESA', NULL, '', 0.00, 3.50, 'POLAR', '2025-12-26 13:07:27', 'unidad', NULL, NULL, 3.50, 'USD', NULL, 1, 0.00);
INSERT INTO `productos` VALUES (11, 1, 'SALSA SOYA AJO INGLESA DOÑA TITA', NULL, NULL, 13.18, 1.43, 'GADUCA', '2025-12-29 18:14:05', 'paquete', 12, NULL, 1.43, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (12, 1, 'ACEITE VATEL', NULL, NULL, 60.00, 6.00, 'COMARCA', '2026-01-19 12:35:23', 'paquete', 12, NULL, 6.00, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (13, 1, 'SALSA PASTA UW 490GR', NULL, NULL, 0.00, 2.95, 'TINITO', '2026-01-17 12:07:18', 'unidad', NULL, NULL, 2.95, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (14, 1, 'ARROZ', NULL, NULL, 33.00, 1.79, 'LEO', '2026-01-13 16:29:59', 'paquete', 24, NULL, 1.79, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (15, 1, 'HARINA PAN', NULL, NULL, 31.00, 1.94, 'CUEVITA', '2026-01-13 16:29:30', 'paquete', 20, NULL, 1.94, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (16, 1, 'CARAMELO FREEGELLS', NULL, NULL, 2.76, 0.50, 'TINITO', '2025-10-30 23:32:09', 'paquete', 12, NULL, 0.50, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (17, 1, 'HALLS', NULL, NULL, 5.46, 0.65, 'TINITO', '2025-11-27 13:37:53', 'paquete', 12, NULL, 0.65, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (339, 1, 'GALLE LULU LIMON 175GR', NULL, NULL, 1.61, 2.01, 'TINITO', '2026-01-07 01:13:38', 'unidad', NULL, NULL, 2.01, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (19, 1, 'TORONTO', NULL, '', 0.00, 0.65, 'GADUCA', '2025-10-13 15:21:50', 'unidad', NULL, NULL, 0.65, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (20, 1, 'CHOCOLATE SAVOY', NULL, NULL, 15.45, 1.70, 'GADUCA', '2026-01-20 20:25:50', 'paquete', 12, NULL, 1.70, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (21, 1, 'CHICLE GIGANTE', NULL, NULL, 0.00, 0.55, 'TINITO', '2025-10-13 13:48:15', 'unidad', NULL, NULL, 0.55, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (22, 1, 'GALLETAS MALTN\'MILK', NULL, '', 0.00, 0.25, '', '2025-08-22 11:13:32', 'unidad', NULL, NULL, 0.25, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (23, 1, 'JABÓN PROTEX 110GR', NULL, NULL, 7.50, 9.00, 'COMARCA', '2026-01-19 12:44:07', 'paquete', 3, 9.00, 3.25, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (24, 1, 'ESPONJAS', NULL, NULL, 1.20, 0.85, 'LEO', '2026-01-17 12:04:40', 'paquete', 2, NULL, 0.85, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (25, 1, 'FREGADOR', NULL, NULL, 5.50, 0.70, 'LEO', '2025-09-22 20:46:52', 'paquete', 15, NULL, 0.70, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (26, 1, 'COCA-COLA 1.5LTS', NULL, '', 0.00, 1.60, '', '2025-08-22 13:05:43', 'unidad', NULL, NULL, 1.60, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (28, 1, 'GATORADE', NULL, '', 0.00, 1.80, 'POLAR', '2026-01-17 12:04:54', 'unidad', NULL, NULL, 1.80, 'USD', NULL, 1, 0.00);
INSERT INTO `productos` VALUES (29, 1, 'TOMATE', NULL, NULL, 390.00, 550.00, 'VERDUREROS', '2026-01-12 23:33:26', 'kg', NULL, NULL, 550.00, 'BS', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (30, 1, 'CEBOLLA', NULL, NULL, 390.00, 550.00, 'VERDUREROS', '2026-01-12 23:33:45', 'kg', NULL, NULL, 550.00, 'BS', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (31, 1, 'PAPA', NULL, NULL, 490.00, 650.00, 'VERDUREROS', '2026-01-12 23:33:09', 'kg', NULL, NULL, 650.00, 'BS', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (32, 1, 'PLÁTANO', NULL, NULL, 800.00, 1040.00, 'VERDUREROS', '2026-01-12 23:34:09', 'kg', NULL, NULL, 1040.00, 'BS', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (33, 1, 'LUCKY', NULL, NULL, 1055.00, 1380.00, 'CIGARRERO', '2026-01-20 20:33:52', 'paquete', 20, 1380.00, 75.00, 'BS', 700.00, 0, 0.00);
INSERT INTO `productos` VALUES (34, 1, 'BELTMONT', NULL, NULL, 880.00, 1150.00, 'CIGARRERO', '2026-01-20 20:32:37', 'paquete', 20, 1150.00, 65.00, 'BS', 580.00, 0, 0.00);
INSERT INTO `productos` VALUES (35, 1, 'PALLMALL', NULL, NULL, 880.00, 1150.00, 'CIGARRERO', '2026-01-20 20:31:40', 'paquete', 20, 1150.00, 65.00, 'BS', 580.00, 0, 0.00);
INSERT INTO `productos` VALUES (37, 1, 'UNIVERSAL', NULL, NULL, 590.00, 770.00, 'CIGARRERO', '2026-01-20 20:30:27', 'paquete', 20, 770.00, 45.00, 'BS', 390.00, 0, 0.00);
INSERT INTO `productos` VALUES (38, 1, 'CONSUL', NULL, NULL, 495.00, 650.00, 'CIGARRERO', '2026-01-20 20:30:37', 'paquete', 20, 650.00, 40.00, 'BS', 330.00, 0, 0.00);
INSERT INTO `productos` VALUES (39, 1, 'VELAS', NULL, '', 0.00, 0.25, 'TINITO', '2025-08-22 13:25:01', 'unidad', NULL, NULL, 0.25, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (283, 1, 'JUGO JUCOSA', NULL, NULL, 1.60, 2.00, 'CUEVITA', '2026-01-17 12:05:25', 'paquete', 3, 2.00, 0.70, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (42, 1, 'LOPERAN', NULL, '', 0.00, 0.25, 'LEO', '2025-08-23 13:53:03', 'unidad', NULL, NULL, 0.25, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (45, 1, 'DICLOFENAC POTÁSICO', NULL, NULL, 1.00, 0.15, 'FARMALUNA', '2025-12-20 10:29:26', 'paquete', 30, NULL, 0.15, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (44, 1, 'DICLOFENAC SÓDICO', NULL, '', 0.00, 0.10, 'LEO', '2025-08-23 13:54:01', 'unidad', NULL, NULL, 0.10, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (46, 1, 'METOCLOPRAMIDA', NULL, '', 0.00, 0.35, 'FARMALUNA', '2025-08-23 13:55:11', 'unidad', NULL, NULL, 0.35, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (47, 1, 'IBUPROFENO', NULL, NULL, 1.21, 0.20, 'FARMALUNA', '2025-12-20 10:29:28', 'paquete', 10, NULL, 0.20, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (48, 1, 'LORATADINA', NULL, NULL, 1.45, 0.25, 'FARMALUNA', '2026-01-23 00:36:50', 'paquete', 10, NULL, 0.25, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (49, 1, 'CETIRIZINA', NULL, NULL, 1.00, 0.15, 'FARMALUNA', '2026-01-23 00:37:00', 'paquete', 20, NULL, 0.15, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (50, 1, 'ACETAMINOFÉN', NULL, NULL, 1.00, 0.15, 'FARMALUNA', '2026-01-23 00:37:12', 'paquete', 20, NULL, 0.15, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (51, 1, 'OMEPRAZOL', NULL, NULL, 3.04, 0.20, 'FARMALUNA', '2025-10-01 19:20:01', 'paquete', 28, NULL, 0.20, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (52, 1, 'AMOXICILINA', NULL, NULL, 2.15, 0.30, 'FARMALUNA', '2025-12-20 01:03:58', 'paquete', 10, NULL, 0.30, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (53, 1, 'METRONIDAZOL', NULL, '', 0.00, 0.20, 'FARMALUNA', '2025-09-28 15:18:33', 'unidad', NULL, NULL, 0.20, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (54, 1, 'GLUP 1 LT', NULL, NULL, 8.50, 1.00, 'LEO', '2026-01-08 21:26:59', 'paquete', 12, NULL, 1.00, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (55, 1, 'GLUP 400ML', NULL, NULL, 5.90, 0.60, 'LEO', '2026-01-08 21:27:26', 'paquete', 15, NULL, 0.60, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (56, 1, 'MALTA DE BOTELLA', NULL, NULL, 16.38, 0.65, 'POLAR', '2026-01-17 12:05:47', 'paquete', 36, NULL, 0.65, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (57, 1, 'PEPSI-COLA 1.25LTS', NULL, NULL, 4.50, 1.10, 'POLAR', '2025-10-11 14:44:11', 'paquete', 6, NULL, 1.10, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (58, 1, 'PEPSI-COLA 2LT', NULL, '', 0.00, 2.00, 'POLAR', '2025-08-23 14:24:06', 'unidad', NULL, NULL, 2.00, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (59, 1, 'JUSTY', NULL, '', 0.00, 1.30, 'LEO', '2025-08-23 14:24:21', 'unidad', NULL, NULL, 1.30, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (60, 1, 'COCA-COLA 2LTS', NULL, NULL, 10.00, 2.20, 'LEO', '2025-11-19 21:27:08', 'paquete', 6, NULL, 2.20, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (61, 1, 'MALTA 1.5LTS', NULL, NULL, 9.84, 2.15, 'POLAR', '2026-01-17 12:05:47', 'paquete', 6, NULL, 2.15, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (62, 1, 'JUGO FRICAJITA', NULL, NULL, 0.99, 1.24, 'TINITO', '2026-01-08 03:01:34', 'unidad', NULL, NULL, 1.24, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (65, 1, 'COCA-COLA 1LT', NULL, '', 5.00, 1.10, '', '2025-08-23 21:20:10', 'paquete', 6, NULL, 1.10, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (275, 1, 'GOMITAS PLAY', NULL, NULL, 13.85, 0.90, 'CUEVITA', '2026-01-08 03:10:50', 'paquete', 24, NULL, 0.90, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (67, 1, 'PAPEL NARANJA 400', NULL, NULL, 2.90, 3.70, 'COMARCA', '2026-01-19 12:23:11', 'paquete', 4, 3.70, 1.10, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (68, 1, 'GALLETA MARIA ITALIA', NULL, NULL, 0.54, 0.90, 'COMARCA', '2025-10-20 20:43:49', 'paquete', 9, 0.90, NULL, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (69, 1, 'CAFE AMANECER 100GR', NULL, NULL, 13.00, 1.63, 'ITC AMANECER', '2026-01-17 12:02:49', 'paquete', 10, NULL, 1.63, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (70, 1, 'CARAOTAS AMANECER', NULL, NULL, 1.00, 1.35, 'ITC AMANECER', '2025-09-06 20:33:32', 'unidad', NULL, NULL, 1.35, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (71, 1, 'PASTA LARGA NONNA', NULL, NULL, 0.75, 0.95, 'ITC AMANECER', '2025-12-20 01:05:44', 'unidad', NULL, NULL, 0.95, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (72, 1, 'PASTA CORTA NONNA', NULL, NULL, 1.40, 2.10, 'ITC AMANECER', '2025-10-18 14:13:30', 'unidad', NULL, NULL, 2.10, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (73, 1, 'DORITOS PEQ', NULL, NULL, 11.32, 1.23, 'PACO LOS LLANOS', '2025-12-20 12:40:28', 'paquete', 12, NULL, 1.23, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (74, 1, 'DORITOS DIN PEQ', NULL, '', 0.00, 1.20, 'PACO LOS LLANOS', '2025-11-09 15:40:04', 'unidad', NULL, NULL, 1.20, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (75, 1, 'DORITOS FH PEQ', NULL, '', 0.00, 1.30, 'PACO LOS LLANOS', '2025-08-25 11:28:14', 'unidad', NULL, NULL, 1.30, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (76, 1, 'DORITOS DIN FH PEQ', NULL, '', 0.00, 1.20, 'PACO LOS LLANOS', '2025-08-25 11:28:51', 'unidad', NULL, NULL, 1.20, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (77, 1, 'CHEESE TRIS P', NULL, '', 0.00, 1.10, 'PACO LOS LLANOS', '2025-08-25 11:29:10', 'unidad', NULL, NULL, 1.10, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (78, 1, 'PEPITO P', NULL, NULL, 0.00, 1.00, 'PACO LOS LLANOS', '2025-10-19 18:36:11', 'unidad', NULL, NULL, 1.00, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (79, 1, 'BOLI KRUCH', NULL, NULL, 4.40, 0.60, 'COMARCA', '2025-12-22 12:59:01', 'paquete', 12, NULL, 0.60, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (80, 1, 'KESITOS P', NULL, NULL, 0.00, 0.60, 'COMARCA', '2025-12-18 01:39:54', 'unidad', NULL, NULL, 0.60, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (81, 1, 'PIGSY PICANTE', NULL, NULL, 3.40, 0.40, 'CUEVITA', '2025-12-27 14:49:30', 'paquete', 18, NULL, 0.40, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (82, 1, 'RAQUETY', NULL, '', 0.00, 0.65, 'PACO LOS LLANOS', '2025-10-16 15:14:43', 'unidad', NULL, NULL, 0.65, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (83, 1, 'CHISKESITO PEQUEÑO', NULL, NULL, 6.39, 0.70, 'COMARCA', '2025-12-22 12:59:15', 'paquete', 12, NULL, 0.70, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (84, 1, 'CHIPS AHOY', NULL, NULL, 2.29, 2.75, 'TINITO', '2026-01-04 23:45:02', 'paquete', 6, 2.75, 0.50, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (85, 1, 'COCO CRUCH', NULL, NULL, 1.40, 1.82, 'CUEVITA', '2026-01-13 16:33:57', 'unidad', NULL, NULL, 1.82, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (86, 1, 'SALSERITOS GRANDES', NULL, NULL, 1.61, 2.01, 'COMARCA', '2026-01-10 13:46:16', 'unidad', NULL, NULL, 2.01, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (87, 1, 'SALSERITOS PEQUEÑOS', NULL, NULL, 5.00, 0.60, 'COMARCA', '2026-01-19 13:06:36', 'paquete', 12, NULL, 0.60, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (88, 1, 'TOSTON TOM', NULL, '', 0.00, 0.45, 'LEO', '2025-09-19 11:35:10', 'unidad', NULL, NULL, 0.45, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (89, 1, 'MINI CHIPS', NULL, NULL, 1.90, 2.30, 'TINITO', '2026-01-08 03:05:36', 'unidad', NULL, NULL, 2.30, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (90, 1, 'NUCITA CRUNCH', NULL, NULL, 1.48, 1.85, 'TINITO', '2025-12-11 13:51:01', 'unidad', NULL, NULL, 1.85, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (91, 1, 'FLIPS PEQUEÑO', NULL, NULL, 3.37, 0.80, 'COMARCA', '2026-01-20 20:28:18', 'paquete', 6, NULL, 0.80, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (92, 1, 'FLIPS MEDIANO', NULL, NULL, 1.84, 2.50, 'COMARCA', '2026-01-19 12:41:43', 'unidad', NULL, NULL, 2.50, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (93, 1, 'DORITOS G', NULL, '', 0.00, 3.30, 'PACO LOS LLANOS', '2025-11-09 15:40:06', 'unidad', NULL, NULL, 3.30, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (95, 1, 'DORITOS FH G', NULL, '', 0.00, 3.30, 'PACO LOS LLANOS', '2025-08-25 12:12:42', 'unidad', NULL, NULL, 3.30, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (244, 1, 'CHESITO P', NULL, NULL, 2.07, 0.40, 'COMARCA', '2025-10-04 23:31:47', 'paquete', 12, NULL, 0.40, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (98, 1, 'PEPITO G', NULL, NULL, 1.10, 1.43, 'PACO LOS LLANOS', '2025-10-19 18:36:02', 'unidad', NULL, NULL, 1.43, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (100, 1, 'MAXCOCO', NULL, NULL, 7.75, 1.01, 'CUEVITA', '2026-01-13 16:45:29', 'paquete', 10, NULL, 1.01, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (101, 1, 'CROC-CHOC', NULL, NULL, 4.91, 0.40, 'TINITO', '2025-10-18 00:13:39', 'paquete', 24, NULL, 0.40, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (102, 1, 'TRIDENT', NULL, NULL, 7.95, 0.65, 'TINITO', '2025-10-30 23:28:41', 'paquete', 18, NULL, 0.65, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (103, 1, 'MINTY', NULL, NULL, 4.45, 0.60, 'TINITO', '2025-10-30 23:31:44', 'paquete', 12, NULL, 0.60, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (104, 1, 'CHICLE GUDS', NULL, NULL, 2.56, 0.30, 'TINITO', '2025-12-19 14:43:17', 'paquete', 18, NULL, 0.30, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (105, 1, 'NUCITA TUBO', NULL, NULL, 11.03, 1.30, 'TINITO', '2026-01-17 12:06:22', 'paquete', 12, NULL, 1.30, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (106, 1, 'DANDY', NULL, NULL, 4.58, 0.60, 'PACO LOS LLANOS', '2025-12-29 13:29:22', 'paquete', 16, NULL, 0.60, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (107, 1, 'OREO DE TUBO', NULL, NULL, 1.33, 1.73, 'TINITO', '2026-01-08 03:06:09', 'unidad', NULL, NULL, 1.73, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (108, 1, 'OREO 6S', NULL, NULL, 2.04, 2.55, 'TINITO', '2025-12-11 13:49:44', 'paquete', 6, 2.55, 0.50, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (110, 1, 'OREO FUDGE', NULL, '', 2.45, 3.00, 'TINITO', '2025-08-25 12:25:30', 'paquete', 6, 3.00, 0.65, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (111, 1, 'TAKYTA 150GR', NULL, NULL, 0.82, 1.00, 'TINITO', '2025-12-15 12:54:53', 'paquete', 8, 1.00, 0.15, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (112, 1, 'OREO DE CAJA', NULL, NULL, 4.38, 0.75, 'TINITO', '2025-12-15 11:37:14', 'paquete', 8, NULL, 0.75, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (113, 1, 'CHUPETA PIN PON', NULL, '', 0.00, 0.50, 'TINITO', '2025-12-18 14:41:36', 'unidad', NULL, NULL, 0.50, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (114, 1, 'POLVO EXPLOSIVO', NULL, '', 0.00, 0.30, 'TINITO', '2025-08-25 12:26:26', 'unidad', NULL, NULL, 0.30, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (115, 1, 'CHUPETA EXPLOSIVA', NULL, '', 0.00, 0.40, 'TINITO', '2025-08-25 12:26:41', 'unidad', NULL, NULL, 0.40, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (116, 1, 'CHICLE DE YOYO', NULL, NULL, 7.64, 0.50, 'TINITO', '2026-01-08 03:09:24', 'paquete', 24, NULL, 0.50, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (118, 1, 'PIRULIN', NULL, NULL, 9.45, 0.55, 'TINITO', '2025-10-18 00:19:17', 'paquete', 25, NULL, 0.55, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (119, 1, 'NUCITA', NULL, NULL, 5.16, 0.60, 'TINITO', '2026-01-17 12:06:21', 'paquete', 12, NULL, 0.60, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (120, 1, 'BRINKY', NULL, NULL, 2.60, 0.50, 'CUEVITA', '2025-10-08 16:45:42', 'paquete', 10, NULL, 0.50, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (121, 1, 'PEPITAS', NULL, NULL, 5.90, 0.45, 'PACO LOS LLANOS', '2026-01-03 13:00:07', 'paquete', 18, NULL, 0.45, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (122, 1, 'PALITOS', NULL, NULL, 7.35, 0.55, 'PACO LOS LLANOS', '2026-01-03 13:00:02', 'paquete', 18, NULL, 0.55, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (123, 1, 'COLORETI', NULL, NULL, 4.50, 0.40, 'TINITO', '2025-10-18 00:07:52', 'paquete', 24, NULL, 0.40, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (124, 1, 'SPARKIES BUBBALOO', NULL, '', 0.00, 0.40, 'TINITO', '2025-08-25 12:29:38', 'unidad', NULL, NULL, 0.40, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (125, 1, 'EXTINTOR', NULL, '', 0.00, 0.95, 'TINITO', '2025-08-25 12:30:09', 'unidad', NULL, NULL, 0.95, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (126, 1, 'CHUPETA DE ANILLOS', NULL, '', 0.00, 0.55, 'TINITO', '2025-12-18 14:41:55', 'unidad', NULL, NULL, 0.55, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (127, 1, 'CRAYÓN CHICLE', NULL, '', 0.00, 0.25, 'TINITO', '2025-08-25 12:31:02', 'unidad', NULL, NULL, 0.25, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (128, 1, 'COLORES CHICLE', NULL, NULL, 0.00, 0.45, 'TINITO', '2025-10-19 15:40:44', 'unidad', NULL, NULL, 0.45, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (129, 1, 'CHUPETA DE MASCOTAS', NULL, '', 0.00, 1.30, 'TINITO', '2025-09-08 15:22:31', 'unidad', NULL, NULL, 1.30, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (130, 1, 'SPINNER RING', NULL, '', 0.00, 1.30, 'TINITO', '2025-08-25 12:33:08', 'unidad', NULL, NULL, 1.30, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (131, 1, 'JUGUETE DE POCETA', NULL, '', 0.00, 0.95, 'TINITO', '2025-08-25 12:33:20', 'unidad', NULL, NULL, 0.95, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (132, 1, 'COCOSETE', NULL, NULL, 20.64, 1.50, 'GADUCA', '2026-01-09 15:04:49', 'paquete', 18, NULL, 1.50, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (286, 1, 'CEPILLO DENTAL COLGATE', NULL, NULL, 1.11, 1.50, 'GADUCA', '2025-12-29 18:15:13', 'unidad', NULL, NULL, 1.50, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (134, 1, 'SAMBA', NULL, NULL, 20.73, 1.35, 'GADUCA', '2026-01-09 15:05:14', 'paquete', 20, NULL, 1.35, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (135, 1, 'SAMBA PEQUEÑA', NULL, '', 0.00, 0.65, 'GADUCA', '2025-08-25 12:34:45', 'unidad', NULL, NULL, 0.65, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (136, 1, 'FLIPS CAJA', NULL, NULL, 3.17, 4.12, 'COMARCA', '2026-01-19 12:42:09', 'unidad', NULL, NULL, 4.12, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (137, 1, 'CORN FLAKES DE CAJA', NULL, NULL, 2.56, 3.20, 'TINITO', '2026-01-07 00:59:13', 'unidad', NULL, NULL, 3.20, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (138, 1, 'CRONCH FLAKES BOLSA', NULL, NULL, 3.21, 4.01, 'COMARCA', '2026-01-10 13:46:53', 'unidad', NULL, NULL, 4.01, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (139, 1, 'FRUTY AROS', NULL, '', 0.00, 3.70, 'COMARCA', '2025-12-24 02:08:16', 'unidad', NULL, NULL, 3.70, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (140, 1, 'JUMBY RIKOS G', NULL, NULL, 14.00, 1.10, 'LEO', '2026-01-13 16:21:08', 'paquete', 18, NULL, 1.10, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (141, 1, 'CHISKESITO GRANDE', NULL, NULL, 1.38, 1.85, 'COMARCA', '2025-12-24 02:08:14', 'unidad', NULL, NULL, 1.85, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (142, 1, 'CHESITO G', NULL, NULL, 0.58, 0.80, 'COMARCA', '2025-12-18 01:39:49', 'unidad', NULL, NULL, 0.80, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (143, 1, 'DOBOM 400GR', NULL, NULL, 5.90, 7.38, 'LEO', '2026-01-12 23:21:39', 'unidad', NULL, NULL, 7.38, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (144, 1, 'DOBOM 200GRS', NULL, NULL, 3.00, 3.75, 'LEO', '2026-01-12 23:21:25', 'unidad', 12, NULL, 3.75, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (145, 1, 'DOBOM 125GRS', NULL, NULL, 2.00, 2.50, 'LEO', '2026-01-12 23:21:17', 'unidad', NULL, NULL, 2.50, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (146, 1, 'CAMPIÑA 200GR', NULL, NULL, 3.14, 3.77, 'TINITO', '2026-01-17 12:03:10', 'unidad', NULL, NULL, 3.77, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (147, 1, 'CAMPIÑA 125GRS', NULL, NULL, 2.02, 2.42, 'TINITO', '2026-01-17 12:03:04', 'unidad', NULL, NULL, 2.42, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (148, 1, 'LECHE UPACA', NULL, NULL, 1.69, 2.20, 'COMARCA', '2025-12-27 14:50:03', 'unidad', NULL, NULL, 2.20, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (149, 1, 'LECHE INDOSA 200GR', NULL, NULL, 1.10, 1.43, 'TINITO', '2026-01-17 12:05:33', 'unidad', NULL, NULL, 1.43, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (150, 1, 'AVENA 200GR PANTERA', NULL, NULL, 0.83, 1.25, 'COMARCA', '2026-01-19 12:38:55', 'unidad', NULL, NULL, 1.25, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (151, 1, 'COMPOTA GRANDE', NULL, NULL, 1.10, 1.43, 'COMARCA', '2026-01-07 01:14:36', 'unidad', NULL, NULL, 1.43, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (152, 1, 'COMPOTA PEQUEÑA', NULL, NULL, 0.79, 1.10, 'COMARCA', '2026-01-07 01:15:08', 'unidad', NULL, NULL, 1.10, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (337, 1, 'ELITE CHOC. TUBO 100GR', NULL, NULL, 0.95, 1.23, 'TINITO', '2026-01-08 13:45:11', 'unidad', NULL, NULL, 1.23, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (154, 1, 'MAIZINA 90GR', NULL, NULL, 0.82, 1.07, 'COMARCA', '2026-01-19 12:58:51', 'unidad', NULL, NULL, 1.07, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (155, 1, 'MAIZINA 120GR', NULL, NULL, 1.00, 1.30, 'COMARCA', '2026-01-19 12:59:09', 'unidad', NULL, NULL, 1.30, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (156, 1, 'SOPA MAGGY', NULL, NULL, 20.50, 2.22, 'GADUCA', '2026-01-09 15:01:34', 'paquete', 12, NULL, 2.22, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (158, 1, 'LECHE CONDENSADA', NULL, NULL, 2.96, 3.55, 'GADUCA', '2025-10-13 15:19:25', 'unidad', NULL, NULL, 3.55, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (159, 1, 'BOKA', NULL, NULL, 4.00, 0.60, 'LEO', '2026-01-15 20:45:27', 'paquete', 10, NULL, 0.60, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (160, 1, 'PEGA LOKA', NULL, NULL, 14.40, 0.70, 'LEO', '2025-08-25 14:33:25', 'paquete', 42, NULL, 0.70, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (161, 1, 'BOMBILLO LED 10W', NULL, NULL, 1.05, 1.31, 'LA 14', '2026-01-06 20:09:51', 'unidad', NULL, NULL, 1.31, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (164, 1, 'CARAOTA PANTERA', NULL, NULL, 1.71, 2.20, 'COMARCA', '2026-01-10 13:47:19', 'unidad', NULL, NULL, 2.20, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (165, 1, 'CARAOTAS DON JUAN', NULL, '', 0.00, 1.00, '', '2025-08-25 15:06:29', 'unidad', NULL, NULL, 1.00, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (166, 1, 'CARAOTA BLANCA PANTERA', NULL, NULL, 2.02, 2.63, 'COMARCA', '2025-11-09 16:37:38', 'unidad', NULL, NULL, 2.63, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (167, 1, 'FRIJOL PANTERA', NULL, NULL, 0.00, 1.50, 'COMARCA', '2026-01-06 14:05:34', 'unidad', NULL, NULL, 1.50, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (168, 1, 'ARVEJAS PANTERA', '', NULL, 1.60, 2.00, 'COMARCA', '2026-01-26 02:52:04', 'unidad', 1, 0.00, 2.00, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (169, 1, 'MAÍZ DE COTUFAS', NULL, NULL, 1.34, 1.65, 'COMARCA', '2026-01-17 12:05:41', 'unidad', NULL, NULL, 1.65, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (170, 1, 'CAFÉ AMANECER 200GR', NULL, NULL, 14.45, 3.01, 'ITC AMANECER', '2026-01-17 12:02:51', 'paquete', 6, NULL, 3.01, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (171, 1, 'CAFÉ FLOR ARAUCA', NULL, NULL, 2.85, 3.71, 'COMARCA', '2026-01-19 12:39:56', 'unidad', NULL, NULL, 3.71, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (172, 1, 'CAFÉ ARAUCA 200GRS', NULL, NULL, 2.60, 3.30, 'COMARCA', '2026-01-20 20:26:57', 'unidad', NULL, NULL, 3.30, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (173, 1, 'CAFÉ ARAUCA 100GR', NULL, NULL, 1.43, 1.75, 'COMARCA', '2026-01-20 20:26:37', 'unidad', NULL, NULL, 1.75, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (174, 1, 'CAFÉ ARAUCA 50GRS', NULL, NULL, 0.64, 0.90, 'COMARCA', '2025-12-22 12:58:37', 'unidad', NULL, NULL, 0.90, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (260, 1, 'SALSA DOÑA TITA PEQ', NULL, NULL, 25.53, 1.40, 'GADUCA', '2025-11-21 22:39:36', 'paquete', 24, NULL, 1.40, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (176, 1, 'YOKOIMA 100GR', NULL, NULL, 13.50, 1.69, 'LEO', '2026-01-13 16:28:33', 'paquete', 10, NULL, 1.69, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (177, 1, 'FAVORITO 100GRS', NULL, NULL, 0.00, 1.50, 'ITC AMANECER', '2025-12-20 01:05:56', 'unidad', NULL, NULL, 1.50, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (178, 1, 'FAVORITO 50GRS', NULL, NULL, 11.18, 0.73, 'ITC AMANECER', '2025-12-20 01:05:31', 'paquete', 20, NULL, 0.73, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (179, 1, 'SALSA PAMPERO GR', NULL, NULL, 0.00, 2.10, 'POLAR', '2025-09-06 20:46:42', 'unidad', NULL, NULL, 2.10, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (180, 1, 'SALSA PAMPERO PEQ', NULL, NULL, 0.00, 1.45, 'POLAR', '2025-09-06 20:46:50', 'unidad', NULL, NULL, 1.45, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (181, 1, 'SALSA TIQUIRE GR', NULL, NULL, 0.00, 2.10, 'COMARCA', '2025-09-06 20:46:57', 'unidad', NULL, NULL, 2.10, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (182, 1, 'SALSA TIQUIRE PEQ', NULL, NULL, 0.00, 1.45, 'COMARCA', '2025-09-06 20:47:03', 'unidad', NULL, NULL, 1.45, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (183, 1, 'SALSA DOÑA TITA GR', NULL, NULL, 41.10, 2.14, 'GADUCA', '2026-01-20 20:03:21', 'paquete', 24, NULL, 2.14, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (184, 1, 'MAYONESA MAVESA PEQUEÑA', NULL, NULL, 49.00, 2.55, 'POLAR', '2026-01-13 16:31:05', 'paquete', 24, NULL, 2.55, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (185, 1, 'MAYONESA KRAFF 175GR', NULL, NULL, 2.30, 2.76, 'TINITO', '2026-01-08 03:03:47', 'unidad', NULL, NULL, 2.76, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (187, 1, 'DIABLITOS 115GR', NULL, NULL, 2.71, 3.25, 'TINITO', '2026-01-08 02:59:40', 'unidad', NULL, NULL, 3.25, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (188, 1, 'DIABLITOS 54GR', NULL, NULL, 1.58, 1.98, 'TINITO', '2025-11-27 13:35:28', 'unidad', NULL, NULL, 1.98, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (189, 1, 'ATÚN AZUL SDLA', NULL, NULL, 2.98, 3.87, 'TINITO', '2025-11-27 13:37:02', 'unidad', NULL, NULL, 3.87, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (190, 1, 'ATUN ROJO SDLA', NULL, NULL, 3.45, 4.14, 'TINITO', '2025-10-13 13:40:25', 'unidad', NULL, NULL, 4.14, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (191, 1, 'SARDINA', '7595122001927', NULL, 17.50, 1.00, 'LEO', '2026-01-19 20:47:48', 'paquete', 24, NULL, 1.00, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (192, 1, 'VINAGRE DE MANZANA', NULL, '', 0.00, 1.60, 'COMARCA', '2025-08-25 15:51:41', 'unidad', NULL, NULL, 1.60, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (193, 1, 'VINAGRE DOÑA TITA', NULL, NULL, 1.00, 1.55, 'GADUCA', '2026-01-09 15:06:37', 'unidad', NULL, NULL, 1.55, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (194, 1, 'VINAGRE TIQUIRE', NULL, NULL, 1.07, 1.40, 'COMARCA', '2026-01-20 20:27:35', 'unidad', NULL, NULL, 1.40, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (195, 1, 'ACEITE IDEAL 900ML', NULL, NULL, 39.30, 4.17, 'LEO', '2026-01-18 23:45:39', 'paquete', 12, NULL, 4.17, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (196, 1, 'ACEITE PAMPA 1/2LT', NULL, NULL, 29.00, 3.20, 'LEO', '2026-01-13 16:23:12', 'paquete', 12, NULL, 3.20, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (198, 1, 'PASTA LARGA HORIZONTE', NULL, NULL, 25.70, 2.78, 'LEO', '2026-01-13 16:26:57', 'paquete', 12, NULL, 2.78, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (199, 1, 'PASTA HORIZONTE CORTA', NULL, NULL, 29.10, 3.15, 'LEO', '2026-01-13 16:26:44', 'paquete', 12, NULL, 3.15, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (200, 1, 'HARINA DE TRIGO', NULL, NULL, 11.60, 1.52, 'LEO', '2026-01-17 12:05:00', 'paquete', 10, NULL, 1.52, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (201, 1, 'AZÚCAR', '7597304223943', NULL, 30.00, 2.00, 'COMARCA', '2026-01-17 12:54:25', 'paquete', 20, NULL, 2.00, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (202, 1, 'SAL', NULL, NULL, 8.50, 0.60, 'CUEVITA', '2026-01-13 19:07:23', 'paquete', 25, NULL, 0.60, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (203, 1, 'DELINE DE 250GRS', NULL, '', 0.00, 1.50, 'LEO', '2025-08-25 16:06:22', 'unidad', NULL, NULL, 1.50, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (204, 1, 'NELLY DE 250GRS', NULL, NULL, 28.08, 1.60, 'POLAR', '2026-01-17 12:06:12', 'paquete', 24, NULL, 1.60, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (205, 1, 'NELLY DE 500GRS', NULL, NULL, 0.00, 2.70, 'POLAR', '2026-01-17 12:06:13', 'unidad', NULL, NULL, 2.70, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (206, 1, 'MAVESA DE 250GRS', NULL, NULL, 34.50, 1.87, 'POLAR', '2026-01-13 16:30:30', 'paquete', 24, NULL, 1.87, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (207, 1, 'MAVESA DE 500GRS', NULL, NULL, 24.00, 2.60, 'POLAR', '2026-01-13 16:33:24', 'paquete', 12, NULL, 2.60, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (208, 1, 'HUEVOS', NULL, NULL, 6.70, 8.00, 'CUEVITA', '2025-12-10 22:49:36', 'paquete', 30, 8.00, 0.30, 'USD', 4.10, 0, 0.00);
INSERT INTO `productos` VALUES (209, 1, 'MASA PASTELITO ROMY', NULL, NULL, 1.80, 2.20, 'RAUL', '2026-01-18 23:45:09', 'unidad', NULL, NULL, 2.20, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (210, 1, 'NUTRIBELLA', NULL, NULL, 7.80, 0.85, 'LEO', '2026-01-17 12:06:23', 'paquete', 12, NULL, 0.85, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (211, 1, 'DESODORANTE CLINICAL', NULL, NULL, 9.00, 0.65, 'GADUCA', '2026-01-09 15:09:13', 'paquete', 20, NULL, 0.65, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (212, 1, 'DESODORANTE', NULL, NULL, 7.70, 0.58, 'LEO', '2026-01-09 15:09:30', 'paquete', 18, NULL, 0.58, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (213, 1, 'SHAMPOO H&S', NULL, NULL, 0.00, 0.60, 'LEO', '2025-11-15 12:48:21', 'unidad', NULL, NULL, 0.60, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (214, 1, 'BOLSAS NEGRAS', NULL, NULL, 8.50, 0.55, 'CUEVITA', '2026-01-17 12:52:37', 'paquete', 25, NULL, 0.55, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (215, 1, 'AXION EN CREMA', NULL, NULL, 2.11, 2.74, 'GADUCA', '2026-01-20 20:04:03', 'unidad', NULL, NULL, 2.74, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (346, 1, 'MARSHMALLOWS NAVIDEÑO', NULL, NULL, 0.95, 1.20, 'TINITO', '2026-01-08 03:02:45', 'unidad', NULL, NULL, 1.20, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (349, 1, 'CUBITOS MAGGIE', NULL, NULL, 50.00, 0.35, 'GADUCA', '2026-01-09 15:01:12', 'paquete', 250, NULL, 0.35, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (217, 1, 'COLGATE TOTAL', NULL, NULL, 2.10, 2.63, 'GADUCA', '2025-09-23 11:59:29', 'unidad', NULL, NULL, 2.63, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (218, 1, 'COLGATE PLAX', NULL, NULL, 3.25, 4.23, 'GADUCA', '2025-11-21 22:33:51', 'unidad', NULL, NULL, 4.23, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (219, 1, 'COLGATE TRIPLE ACCIÓN 60ML', NULL, NULL, 1.73, 2.16, 'GADUCA', '2026-01-09 15:07:15', 'unidad', NULL, NULL, 2.16, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (220, 1, 'COLGATE TRADICIONAL 90ML', NULL, NULL, 1.50, 1.88, 'GADUCA', '2026-01-09 15:07:48', 'unidad', 12, NULL, 1.88, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (221, 1, 'COLGATE NIÑOS', NULL, NULL, 1.60, 2.00, 'GADUCA', '2026-01-09 15:08:08', 'unidad', NULL, NULL, 2.00, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (322, 1, 'MARIA SELECTA', NULL, NULL, 1.43, 1.86, 'TINITO', '2025-12-15 12:57:21', 'paquete', 9, 1.86, 0.25, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (223, 1, 'TOALLAS AZULES', NULL, NULL, 40.30, 1.70, 'LEO', '2025-12-26 13:11:21', 'paquete', 30, NULL, 1.70, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (224, 1, 'TOALLAS MORADAS', NULL, NULL, 29.30, 1.40, 'CUEVITA', '2025-12-24 19:03:58', 'paquete', 30, NULL, 1.40, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (225, 1, 'JABÓN ESPECIAL', NULL, NULL, 40.00, 1.20, 'RAMON', '2025-11-17 23:18:18', 'paquete', 50, NULL, 1.20, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (226, 1, 'JABÓN POPULAR', NULL, NULL, 57.90, 1.30, 'LEO', '2026-01-18 23:46:23', 'paquete', 72, NULL, 1.30, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (227, 1, 'JABÓN LAS LLAVES', NULL, '', 0.00, 1.30, 'POLAR', '2026-01-18 23:46:54', 'unidad', NULL, NULL, 1.30, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (228, 1, 'JABÓN DE AVENA', NULL, '', 0.00, 0.60, 'TINITO', '2025-12-15 12:53:20', 'unidad', NULL, NULL, 0.60, 'USD', NULL, 1, 0.00);
INSERT INTO `productos` VALUES (229, 1, 'JABÓN HUGME', NULL, NULL, 0.00, 0.65, 'LEO', '2025-11-28 11:28:25', 'unidad', NULL, NULL, 0.65, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (231, 1, 'JABÓN LAK', NULL, NULL, 4.10, 1.50, 'LEO', '2026-01-17 12:53:25', 'paquete', 4, NULL, 1.50, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (232, 1, 'GELATINA CABELLO PEQ', NULL, NULL, 43.90, 2.40, 'LEO', '2025-10-26 14:21:27', 'paquete', 24, NULL, 2.40, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (233, 1, 'ACE ALIVE 1KG', '', NULL, 39.00, 4.23, 'CUEVITA', '2026-01-26 17:57:09', 'unidad', 12, 0.00, 4.23, 'USD', 0.00, 1, -1.00);
INSERT INTO `productos` VALUES (234, 1, 'ACE ALIVE 500GRS', NULL, NULL, 39.00, 2.15, 'CUEVITA', '2026-01-26 02:31:12', 'unidad', NULL, NULL, NULL, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (235, 1, 'ACE OSO BLANCO 400GRS', NULL, NULL, 28.00, 1.82, 'CUEVITA', '2026-01-13 16:24:35', 'paquete', 20, NULL, 1.82, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (236, 1, 'SUAVITEL', NULL, NULL, 7.90, 0.86, 'LEO', '2026-01-17 12:07:37', 'paquete', 12, NULL, 0.86, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (237, 1, 'CLORO LOFO 1LT', NULL, NULL, 12.00, 1.30, 'LEO', '2025-11-17 23:16:42', 'paquete', 12, NULL, 1.30, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (238, 1, 'AFEITADORA', NULL, NULL, 6.40, 0.75, 'LEO', '2025-11-30 14:20:34', 'paquete', 12, NULL, 0.75, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (239, 1, 'HOJILLAS', NULL, NULL, 7.20, 1.00, 'LEO', '2025-11-02 21:48:13', 'paquete', 12, NULL, 1.00, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (240, 1, 'LECHE 1LT LOS ANDES', NULL, '', 0.00, 2.15, 'LOS ANDES', '2025-08-26 12:26:31', 'unidad', NULL, NULL, 2.15, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (285, 1, 'APUREÑITO', NULL, NULL, 5.90, 0.75, 'CUEVITA', '2026-01-15 20:44:07', 'paquete', 12, NULL, 0.75, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (242, 1, 'YESQUERO', NULL, '', 0.00, 0.40, 'CUEVITA', '2025-12-20 01:04:59', 'unidad', NULL, NULL, 0.40, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (243, 1, 'TRIDENT INDIVIDUAL', NULL, NULL, 5.68, 0.15, '', '2025-10-18 00:14:18', 'paquete', 60, NULL, 0.15, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (245, 1, 'ATUN RICA DELI', NULL, NULL, 2.45, 2.94, 'TINITO', '2025-10-13 15:30:33', 'unidad', NULL, NULL, 2.94, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (246, 1, 'SALSA PASTA UW 190GR', NULL, NULL, 1.17, 1.50, 'TINITO', '2025-12-26 13:05:50', 'unidad', NULL, NULL, 1.50, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (247, 1, 'SORBETICO PEQ', NULL, '', 1.07, 1.35, 'TINITO', '2025-08-28 15:38:52', 'paquete', 4, 1.35, 0.40, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (248, 1, 'SORBETICO WAFER', NULL, NULL, 1.17, 1.52, 'TINITO', '2026-01-08 03:06:49', 'unidad', NULL, NULL, 1.52, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (249, 1, 'TANG', NULL, '', 6.45, 0.60, 'TINITO', '2025-08-28 15:44:00', 'paquete', 15, NULL, 0.60, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (250, 1, 'CHICLE FREEGELLS', NULL, NULL, 3.58, 0.40, 'TINITO', '2025-09-24 21:05:33', 'paquete', 15, NULL, 0.40, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (251, 1, 'CHICLE TATTOO', NULL, NULL, 2.87, 0.07, 'TINITO', '2025-12-15 12:52:39', 'paquete', 90, NULL, 0.07, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (254, 1, 'GALLETA MARIA MINI', NULL, '', 0.50, 0.70, 'TINITO', '2025-08-28 16:06:09', 'unidad', NULL, NULL, 0.70, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (256, 1, 'COCO CRUCH', NULL, '', 0.00, 1.20, 'CUEVITA', '2025-09-18 14:52:27', 'unidad', NULL, NULL, 1.20, 'USD', NULL, 0, 0.00);
INSERT INTO `productos` VALUES (257, 1, 'CHEESE TRIS G', NULL, NULL, 1.66, 2.16, 'PACO LOS LLANOS', '2025-12-24 02:08:53', 'unidad', NULL, NULL, 2.16, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (258, 1, 'BOLI KRUNCH G', NULL, NULL, 0.85, 1.25, 'COMARCA', '2025-12-24 02:08:10', 'unidad', NULL, NULL, 1.25, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (259, 1, 'KESITOS G', NULL, NULL, 0.89, 1.25, 'COMARCA', '2025-12-08 11:56:00', 'unidad', NULL, NULL, 1.25, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (262, 1, 'CHAKARO GDE', NULL, NULL, 8.00, 0.90, 'CHAKARO', '2025-09-11 19:44:57', 'paquete', 12, NULL, 0.90, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (261, 1, 'DESINFECTANTE', NULL, NULL, 0.78, 1.20, 'LIMPIEZA', '2026-01-06 20:08:26', 'unidad', NULL, NULL, 1.20, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (263, 1, 'MANDADOR', NULL, NULL, 9.00, 1.00, 'CHAKARO', '2026-01-17 12:05:49', 'paquete', 12, NULL, 1.00, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (264, 1, 'CHUPETA', NULL, NULL, 6.19, 0.20, 'LEO', '2026-01-17 12:03:34', 'paquete', 46, NULL, 0.20, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (265, 1, 'SALCHICHAS', NULL, NULL, 4.05, 5.30, 'RAUL', '2025-12-06 09:11:59', 'kg', NULL, NULL, 5.30, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (266, 1, 'CLORO AAA', NULL, NULL, 0.53, 1.00, 'LIMPIEZA', '2025-11-01 16:09:27', 'unidad', NULL, NULL, 1.00, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (267, 1, 'LAVAPLATOS AAA', NULL, NULL, 1.81, 2.35, 'LIMPIEZA', '2026-01-03 15:34:30', 'unidad', NULL, NULL, 2.35, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (268, 1, 'LAVAPLATOS AA', NULL, NULL, 1.38, 1.80, 'LIMPIEZA', '2025-09-22 20:13:37', 'unidad', NULL, NULL, 1.80, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (269, 1, 'CLORO AA', NULL, NULL, 0.48, 0.80, 'LIMPIEZA', '2025-09-22 20:24:23', 'unidad', NULL, NULL, 0.80, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (270, 1, 'CERA BLANCA', NULL, NULL, 0.87, 1.13, 'LIMPIEZA', '2026-01-03 15:34:47', 'unidad', NULL, NULL, 1.13, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (271, 1, 'SUAVIZANTE', NULL, NULL, 1.12, 1.65, 'LIMPIEZA', '2025-11-01 16:09:13', 'unidad', NULL, NULL, 1.65, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (272, 1, 'DESENGRASANTE AAA', NULL, NULL, 1.51, 2.00, 'LIMPIEZA', '2025-09-22 20:16:43', 'unidad', NULL, NULL, 2.00, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (329, 1, 'BOMBILLO LED 20W', NULL, NULL, 1.86, 2.33, 'LA 14', '2026-01-06 20:09:40', 'unidad', NULL, NULL, 2.33, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (273, 1, 'MARSHMALLOWS 100GR', NULL, NULL, 1.02, 1.30, 'TINITO', '2026-01-08 03:02:55', 'unidad', NULL, NULL, 1.30, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (274, 1, 'HUEVITO SORPRESA', NULL, NULL, 5.83, 0.70, 'TINITO', '2025-10-28 20:14:20', 'paquete', 12, NULL, 0.70, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (276, 1, 'GALLETA SODA EL SOL', NULL, NULL, 1.55, 2.00, 'LEO', '2026-01-07 01:07:57', 'paquete', 10, 2.00, 0.25, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (277, 1, 'YOKOIMA 50GR', NULL, NULL, 12.50, 0.81, 'LEO', '2025-09-25 22:20:24', 'paquete', 20, NULL, 0.81, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (279, 1, 'TIGRITO', NULL, NULL, 5.90, 0.75, 'CUEVITA', '2026-01-15 20:44:35', 'paquete', 12, NULL, 0.75, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (280, 1, 'PLAQUITAS', NULL, NULL, 1.80, 0.17, 'CATALINERO', '2026-01-17 12:06:52', 'paquete', 15, NULL, 0.17, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (282, 1, 'KETCHUP CAPRI 198GR', NULL, NULL, 1.13, 1.41, 'COMARCA', '2025-10-04 22:53:37', 'unidad', NULL, NULL, 1.41, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (284, 1, 'ATUN MARGARITA', NULL, NULL, 66.58, 2.38, 'POLAR', '2026-01-17 12:02:21', 'paquete', 35, NULL, 2.38, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (287, 1, 'HOJA EXAMEN', NULL, NULL, 2.40, 0.10, 'CUEVITA', '2026-01-17 12:05:06', 'paquete', 50, NULL, 0.10, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (288, 1, 'BOMBONES CORAZON', NULL, NULL, 1.32, 1.75, 'TINITO', '2025-10-18 00:30:58', 'unidad', NULL, NULL, 1.75, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (289, 1, 'BOMBONES ROSA', NULL, NULL, 2.23, 2.70, 'TINITO', '2026-01-04 23:43:51', 'unidad', NULL, NULL, 2.70, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (290, 1, 'NUCITA CRUNCH JR', NULL, NULL, 2.39, 0.60, 'TINITO', '2026-01-04 23:46:01', 'paquete', 6, NULL, 0.60, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (291, 1, 'YOYO NEON', NULL, NULL, 0.86, 1.15, 'TINITO', '2025-10-18 00:11:25', 'unidad', NULL, NULL, 1.15, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (292, 1, 'GUSANITO LOCO', NULL, NULL, 0.66, 0.86, 'TINITO', '2025-10-18 00:12:56', 'unidad', 30, NULL, 0.86, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (293, 1, 'ACONDICIONADOR SEDAL', NULL, NULL, 4.07, 0.50, 'TINITO', '2025-12-26 13:10:38', 'paquete', 12, NULL, 0.50, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (294, 1, 'JAMÓN', NULL, NULL, 1.60, 2.00, 'RAUL', '2025-11-09 15:39:42', 'unidad', NULL, NULL, 2.00, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (295, 1, 'QUESO AMARILLO', NULL, NULL, 1.60, 2.00, 'RAUL', '2025-11-09 15:39:47', 'unidad', NULL, NULL, 2.00, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (296, 1, 'RAQUETY G', NULL, NULL, 0.83, 1.10, 'PACO LOS LLANOS', '2025-10-19 18:38:49', 'unidad', NULL, NULL, 1.10, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (297, 1, 'PAPEL AMARILLO 600', NULL, NULL, 4.00, 5.00, 'COMARCA', '2026-01-19 12:22:39', 'paquete', 4, 5.00, 1.40, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (298, 1, 'COLORETI MINI', NULL, NULL, 4.09, 0.20, 'TINITO', '2025-10-30 23:33:35', 'paquete', 36, NULL, 0.20, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (299, 1, 'MENTITAS AMBROSOLI', NULL, NULL, 11.54, 0.70, 'TINITO', '2025-10-30 23:35:43', 'paquete', 24, NULL, 0.70, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (310, 1, 'CARAMELOS', NULL, NULL, 2.70, 0.05, 'LEO', '2025-11-02 21:50:21', 'paquete', 100, NULL, 0.05, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (301, 1, 'BARQUILLON', NULL, NULL, 1.00, 1.40, '4X4', '2025-11-01 18:27:36', 'unidad', NULL, NULL, 1.40, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (302, 1, 'PALETA FRESH LIMON', NULL, NULL, 0.28, 0.40, 'CALI', '2025-11-01 19:14:12', 'unidad', NULL, NULL, 0.40, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (303, 1, 'PALETA PASION YOGURT', NULL, NULL, 0.35, 0.50, 'CALI', '2025-11-01 19:14:13', 'unidad', 9, NULL, 0.50, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (304, 1, 'PALETA EXOTICO', NULL, NULL, 0.35, 0.50, 'CALI', '2025-11-01 19:14:13', 'unidad', NULL, NULL, 0.50, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (305, 1, 'BARQUILLA SUPER CONO', NULL, NULL, 0.82, 1.10, 'CALI', '2025-11-01 19:43:19', 'unidad', NULL, NULL, 1.10, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (306, 1, 'POLET FERRERO ROCHER', NULL, NULL, 1.36, 2.00, 'CALI', '2025-11-01 19:40:24', 'unidad', NULL, NULL, 2.00, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (307, 1, 'POLET TRIPLE CAPITA', NULL, NULL, 1.36, 2.00, 'CALI', '2025-11-01 19:40:51', 'unidad', NULL, NULL, 2.00, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (308, 1, 'POLET TRIPLE CAPITA COCO', NULL, NULL, 1.36, 2.00, 'CALI', '2025-11-01 19:41:49', 'unidad', NULL, NULL, 2.00, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (309, 1, 'MAXI SANDWICH', NULL, NULL, 0.82, 1.10, 'CALI', '2025-11-01 19:43:07', 'unidad', NULL, NULL, 1.10, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (311, 1, 'RIKESA 200GR', NULL, NULL, 3.02, 3.77, 'POLAR', '2025-11-04 23:18:55', 'unidad', NULL, NULL, 3.77, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (312, 1, 'PAPEL ROJO 180', NULL, NULL, 1.14, 1.48, 'COMARCA', '2026-01-19 12:25:48', 'paquete', 4, 1.48, 0.50, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (313, 1, 'PAPEL VERDE 215', NULL, NULL, 1.23, 1.85, 'COMARCA', '2026-01-19 12:25:08', 'paquete', 4, 1.85, 0.60, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (314, 1, 'PAPEL MARRÓN 300', NULL, NULL, 2.40, 3.10, 'COMARCA', '2026-01-19 12:24:14', 'paquete', 4, 3.10, 0.90, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (315, 1, 'CAFÉ NONNA 100GR', NULL, NULL, 13.00, 1.63, 'ITC AMANECER', '2026-01-13 16:28:14', 'paquete', 10, NULL, 1.63, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (316, 1, 'LENTEJA PANTERA', NULL, NULL, 1.72, 2.10, 'COMARCA', '2025-11-09 16:35:48', 'unidad', NULL, NULL, 2.10, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (336, 1, 'MINI MARILU TUBO 100GR', NULL, NULL, 1.07, 1.39, 'TINITO', '2026-01-07 01:10:10', 'unidad', NULL, NULL, 1.39, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (318, 1, 'MAYONESA TITA', NULL, NULL, 1.62, 1.94, 'GADUCA', '2026-01-09 15:05:40', 'unidad', NULL, NULL, 1.94, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (319, 1, 'BOMBONES BEL', NULL, NULL, 3.82, 0.10, 'TINITO', '2025-12-15 14:01:40', 'paquete', 50, NULL, 0.10, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (338, 1, 'ELITE VAINI TUBO 100GR', NULL, NULL, 0.82, 1.07, 'TINITO', '2026-01-08 13:45:11', 'unidad', NULL, NULL, 1.07, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (323, 1, 'MARILU TUBO 240GR', NULL, NULL, 1.94, 2.40, 'TINITO', '2026-01-07 01:10:26', 'paquete', 6, 2.40, 0.50, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (324, 1, 'CARAMELO MIEL', NULL, NULL, 1.60, 0.05, 'TINITO', '2026-01-04 23:44:49', 'paquete', 100, NULL, 0.05, 'USD', 0.00, 1, 0.00);
INSERT INTO `productos` VALUES (325, 1, 'NUTTELINI', NULL, NULL, 3.50, 0.45, 'TINITO', '2025-11-30 00:42:15', 'paquete', 12, NULL, 0.45, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (330, 1, 'CEPILLO DENTAL COLGATE NIÑO', NULL, NULL, 1.23, 1.60, 'GADUCA', '2025-12-29 18:15:52', 'unidad', NULL, NULL, 1.60, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (327, 1, 'BARRILETE', NULL, NULL, 2.75, 0.80, 'COMARCA', '2025-12-15 14:05:50', 'paquete', 50, NULL, 0.80, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (328, 1, 'FRUTYS', NULL, NULL, 12.50, 1.40, 'CUEVITA', '2026-01-10 14:30:23', 'paquete', 12, NULL, 1.40, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (341, 1, 'GALLE MARILU CAJA', NULL, NULL, 4.62, 0.30, 'TINITO', '2026-01-07 01:18:31', 'paquete', 24, NULL, 0.30, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (332, 1, 'ACEITE COPOSA 850ML', NULL, NULL, 3.92, 4.90, 'COMARCA', '2026-01-20 16:22:37', 'unidad', NULL, NULL, 4.90, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (331, 1, 'JABÓN PROTEX 75GR', NULL, NULL, 1.28, 1.66, 'GADUCA', '2026-01-23 13:07:18', 'unidad', NULL, NULL, 1.66, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (333, 1, 'RECARGA MOVISTAR', NULL, NULL, 150.00, 190.00, 'EMILIO', '2026-01-19 12:16:40', 'unidad', NULL, NULL, 190.00, 'BS', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (334, 1, 'RECARGA DIGITEL', NULL, NULL, 160.00, 200.00, 'EMILIO', '2026-01-04 13:03:32', 'unidad', NULL, NULL, 200.00, 'BS', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (335, 1, 'RECARGA MOVILNET', NULL, NULL, 150.00, 185.00, 'EMILIO', '2026-01-04 13:04:16', 'unidad', NULL, NULL, 185.00, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (340, 1, 'GALLETA BROWNIE 175GR', NULL, NULL, 1.55, 2.02, 'TINITO', '2026-01-07 01:13:20', 'unidad', NULL, NULL, 2.02, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (342, 1, 'GALLE Q-KISS 200GR', NULL, NULL, 2.63, 3.16, 'TINITO', '2026-01-07 01:22:53', 'unidad', NULL, NULL, 3.16, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (343, 1, 'GALLETA REX 200GR', NULL, NULL, 1.26, 1.60, 'TINITO', '2026-01-07 01:23:53', 'unidad', NULL, NULL, 1.60, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (344, 1, 'GALLETA LIMON 77GR', NULL, NULL, 0.64, 0.83, 'TINITO', '2026-01-07 01:30:20', 'unidad', NULL, NULL, 0.83, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (345, 1, 'GALLETA LIMON 90GR', NULL, NULL, 0.88, 1.14, 'TINITO', '2026-01-07 01:31:49', 'unidad', NULL, NULL, 1.14, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (347, 1, 'CHUPA POP SURTIDO', NULL, NULL, 3.06, 0.20, 'TINITO', '2026-01-08 03:08:28', 'paquete', 24, NULL, 0.20, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (348, 1, 'TATTOO CHUPETA', NULL, NULL, 3.18, 0.10, 'TINITO', '2026-01-08 03:10:12', 'paquete', 50, NULL, 0.10, 'USD', 0.00, 0, 0.00);
INSERT INTO `productos` VALUES (350, 1, 'CREMA ALIDENT', NULL, NULL, 18.00, 1.95, 'CUEVITA', '2026-01-13 16:24:07', 'paquete', 12, NULL, 1.95, 'USD', 0.00, 0, 0.00);

-- ----------------------------
-- Table structure for tasas_cambio
-- ----------------------------
DROP TABLE IF EXISTS `tasas_cambio`;
CREATE TABLE `tasas_cambio`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `valor` decimal(18, 8) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `fecha`(`fecha`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 103 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of tasas_cambio
-- ----------------------------
INSERT INTO `tasas_cambio` VALUES (1, '2025-07-20', 138.13000000, '2025-08-20 22:15:12');
INSERT INTO `tasas_cambio` VALUES (2, '2025-08-21', 139.40160000, '2025-08-20 22:33:41');
INSERT INTO `tasas_cambio` VALUES (3, '2025-07-22', 139.40160000, '2025-08-21 02:53:13');
INSERT INTO `tasas_cambio` VALUES (4, '2025-08-22', 140.66000000, '2025-08-21 23:39:33');
INSERT INTO `tasas_cambio` VALUES (5, '2025-08-25', 141.88430000, '2025-08-22 22:32:22');
INSERT INTO `tasas_cambio` VALUES (6, '2025-08-26', 143.03810000, '2025-08-26 12:25:17');
INSERT INTO `tasas_cambio` VALUES (7, '2025-08-27', 144.37320000, '2025-08-27 10:11:28');
INSERT INTO `tasas_cambio` VALUES (8, '2025-08-28', 145.74530000, '2025-08-28 15:24:34');
INSERT INTO `tasas_cambio` VALUES (9, '2025-08-29', 147.08250000, '2025-08-29 04:07:45');
INSERT INTO `tasas_cambio` VALUES (10, '2025-09-01', 148.44400000, '2025-08-30 12:18:54');
INSERT INTO `tasas_cambio` VALUES (11, '2025-09-02', 149.46770000, '2025-09-02 11:17:53');
INSERT INTO `tasas_cambio` VALUES (12, '2025-09-03', 150.79520000, '2025-09-03 08:35:19');
INSERT INTO `tasas_cambio` VALUES (13, '2025-09-04', 151.76270000, '2025-09-04 11:40:56');
INSERT INTO `tasas_cambio` VALUES (14, '2025-09-05', 152.82160000, '2025-09-05 11:31:05');
INSERT INTO `tasas_cambio` VALUES (15, '2025-09-08', 154.01080000, '2025-09-06 05:20:26');
INSERT INTO `tasas_cambio` VALUES (16, '2025-09-09', 154.98250000, '2025-09-09 21:20:40');
INSERT INTO `tasas_cambio` VALUES (17, '2025-09-10', 156.37390000, '2025-09-10 10:31:45');
INSERT INTO `tasas_cambio` VALUES (18, '2025-09-11', 157.72870000, '2025-09-11 11:16:24');
INSERT INTO `tasas_cambio` VALUES (19, '2025-09-12', 158.92890000, '2025-09-12 09:35:40');
INSERT INTO `tasas_cambio` VALUES (20, '2025-09-16', 160.44790000, '2025-09-13 14:21:14');
INSERT INTO `tasas_cambio` VALUES (21, '2025-09-17', 161.88800000, '2025-09-17 13:12:18');
INSERT INTO `tasas_cambio` VALUES (22, '2025-09-18', 163.64740000, '2025-09-18 10:12:57');
INSERT INTO `tasas_cambio` VALUES (23, '2025-09-19', 165.41010000, '2025-09-19 11:34:47');
INSERT INTO `tasas_cambio` VALUES (24, '2025-09-22', 166.58340000, '2025-09-20 11:14:32');
INSERT INTO `tasas_cambio` VALUES (25, '2025-09-23', 168.41570000, '2025-09-23 11:33:04');
INSERT INTO `tasas_cambio` VALUES (26, '2025-09-24', 169.97610000, '2025-09-24 15:36:45');
INSERT INTO `tasas_cambio` VALUES (27, '2025-09-25', 171.84580000, '2025-09-25 15:46:53');
INSERT INTO `tasas_cambio` VALUES (28, '2025-09-26', 173.73610000, '2025-09-26 13:03:44');
INSERT INTO `tasas_cambio` VALUES (29, '2025-09-29', 175.64710000, '2025-09-27 12:22:17');
INSERT INTO `tasas_cambio` VALUES (30, '2025-09-30', 177.61430000, '2025-09-30 16:37:28');
INSERT INTO `tasas_cambio` VALUES (31, '2025-10-01', 179.43080000, '2025-10-01 21:28:59');
INSERT INTO `tasas_cambio` VALUES (32, '2025-10-02', 181.30370000, '2025-10-02 18:34:20');
INSERT INTO `tasas_cambio` VALUES (33, '2025-10-03', 183.13690000, '2025-10-03 13:38:58');
INSERT INTO `tasas_cambio` VALUES (34, '2025-10-06', 185.39830000, '2025-10-04 17:45:22');
INSERT INTO `tasas_cambio` VALUES (35, '2025-10-07', 187.28930000, '2025-10-07 11:47:28');
INSERT INTO `tasas_cambio` VALUES (36, '2025-10-08', 189.25940000, '2025-10-08 11:22:06');
INSERT INTO `tasas_cambio` VALUES (37, '2025-10-09', 191.36610000, '2025-10-09 12:36:04');
INSERT INTO `tasas_cambio` VALUES (38, '2025-10-10', 193.29960000, '2025-10-10 11:55:10');
INSERT INTO `tasas_cambio` VALUES (39, '2025-10-13', 195.24910000, '2025-10-11 11:14:57');
INSERT INTO `tasas_cambio` VALUES (40, '2025-10-14', 197.24560000, '2025-10-14 16:33:48');
INSERT INTO `tasas_cambio` VALUES (41, '2025-10-15', 199.10720000, '2025-10-15 11:18:53');
INSERT INTO `tasas_cambio` VALUES (42, '2025-10-16', 201.46650000, '2025-10-16 11:27:44');
INSERT INTO `tasas_cambio` VALUES (43, '2025-10-17', 203.74200000, '2025-10-17 13:31:12');
INSERT INTO `tasas_cambio` VALUES (44, '2025-10-20', 205.67540000, '2025-10-18 12:15:42');
INSERT INTO `tasas_cambio` VALUES (45, '2025-10-21', 207.89380000, '2025-10-21 11:36:02');
INSERT INTO `tasas_cambio` VALUES (46, '2025-10-22', 210.28250000, '2025-10-22 11:13:20');
INSERT INTO `tasas_cambio` VALUES (47, '2025-10-23', 212.48370000, '2025-10-23 04:56:33');
INSERT INTO `tasas_cambio` VALUES (48, '2025-10-24', 214.41900000, '2025-10-24 10:36:10');
INSERT INTO `tasas_cambio` VALUES (49, '2025-10-27', 216.37140000, '2025-10-26 09:47:52');
INSERT INTO `tasas_cambio` VALUES (50, '2025-10-28', 218.17000000, '2025-10-28 23:59:07');
INSERT INTO `tasas_cambio` VALUES (51, '2025-10-29', 219.87370000, '2025-10-29 06:59:59');
INSERT INTO `tasas_cambio` VALUES (52, '2025-10-30', 221.74380000, '2025-10-30 11:22:36');
INSERT INTO `tasas_cambio` VALUES (53, '2025-10-31', 223.64590000, '2025-10-31 10:57:37');
INSERT INTO `tasas_cambio` VALUES (54, '2025-11-03', 223.96220000, '2025-11-01 12:15:34');
INSERT INTO `tasas_cambio` VALUES (55, '2025-11-04', 224.37620000, '2025-11-04 13:14:05');
INSERT INTO `tasas_cambio` VALUES (56, '2025-11-05', 226.13050000, '2025-11-05 11:43:00');
INSERT INTO `tasas_cambio` VALUES (57, '2025-11-06', 227.55670000, '2025-11-06 14:21:15');
INSERT INTO `tasas_cambio` VALUES (58, '2025-11-07', 228.47960000, '2025-11-06 21:36:29');
INSERT INTO `tasas_cambio` VALUES (59, '2025-11-10', 231.04620000, '2025-11-08 11:51:20');
INSERT INTO `tasas_cambio` VALUES (60, '2025-11-11', 231.09380000, '2025-11-11 13:41:50');
INSERT INTO `tasas_cambio` VALUES (61, '2025-11-12', 233.04580000, '2025-11-12 11:48:50');
INSERT INTO `tasas_cambio` VALUES (62, '2025-11-13', 233.55760000, '2025-11-13 13:44:38');
INSERT INTO `tasas_cambio` VALUES (63, '2025-11-14', 234.87150000, '2025-11-14 13:07:10');
INSERT INTO `tasas_cambio` VALUES (64, '2025-11-17', 236.46010000, '2025-11-15 12:43:08');
INSERT INTO `tasas_cambio` VALUES (65, '2025-11-18', 236.83890000, '2025-11-18 12:17:05');
INSERT INTO `tasas_cambio` VALUES (66, '2025-11-19', 237.75050000, '2025-11-19 15:18:45');
INSERT INTO `tasas_cambio` VALUES (67, '2025-11-20', 240.32090000, '2025-11-20 11:25:31');
INSERT INTO `tasas_cambio` VALUES (68, '2025-11-21', 241.57800000, '2025-11-21 10:59:06');
INSERT INTO `tasas_cambio` VALUES (69, '2025-11-25', 243.11050000, '2025-11-22 16:08:38');
INSERT INTO `tasas_cambio` VALUES (70, '2025-11-27', 244.65040000, '2025-11-26 20:50:48');
INSERT INTO `tasas_cambio` VALUES (71, '2025-11-28', 245.66970000, '2025-11-28 11:27:25');
INSERT INTO `tasas_cambio` VALUES (72, '2025-12-01', 247.30030000, '2025-11-29 16:01:51');
INSERT INTO `tasas_cambio` VALUES (73, '2025-12-02', 247.40710000, '2025-12-02 16:43:12');
INSERT INTO `tasas_cambio` VALUES (74, '2025-12-05', 254.87050000, '2025-12-04 21:08:29');
INSERT INTO `tasas_cambio` VALUES (75, '2025-12-09', 257.92870000, '2025-12-06 13:24:14');
INSERT INTO `tasas_cambio` VALUES (76, '2025-12-10', 262.10360000, '2025-12-10 11:31:55');
INSERT INTO `tasas_cambio` VALUES (77, '2025-12-11', 265.06620000, '2025-12-11 13:48:27');
INSERT INTO `tasas_cambio` VALUES (78, '2025-12-12', 267.74990000, '2025-12-12 11:57:43');
INSERT INTO `tasas_cambio` VALUES (79, '2025-12-15', 270.78930000, '2025-12-13 13:10:40');
INSERT INTO `tasas_cambio` VALUES (80, '2025-12-16', 273.58610000, '2025-12-16 12:21:51');
INSERT INTO `tasas_cambio` VALUES (81, '2025-12-17', 276.57690000, '2025-12-17 17:12:30');
INSERT INTO `tasas_cambio` VALUES (82, '2025-12-18', 279.56290000, '2025-12-18 14:40:30');
INSERT INTO `tasas_cambio` VALUES (83, '2025-12-19', 282.51280000, '2025-12-19 12:38:36');
INSERT INTO `tasas_cambio` VALUES (84, '2025-12-22', 285.40240000, '2025-12-20 10:28:34');
INSERT INTO `tasas_cambio` VALUES (85, '2025-12-23', 288.44940000, '2025-12-23 10:40:32');
INSERT INTO `tasas_cambio` VALUES (86, '2025-12-26', 291.35240000, '2025-12-24 13:28:29');
INSERT INTO `tasas_cambio` VALUES (87, '2025-12-29', 294.96990000, '2025-12-27 14:50:58');
INSERT INTO `tasas_cambio` VALUES (88, '2025-12-30', 298.14310000, '2025-12-30 11:55:40');
INSERT INTO `tasas_cambio` VALUES (89, '2026-01-02', 301.37090000, '2025-12-31 12:50:56');
INSERT INTO `tasas_cambio` VALUES (90, '2026-01-05', 304.67960000, '2026-01-03 12:49:32');
INSERT INTO `tasas_cambio` VALUES (91, '2026-01-06', 308.15460000, '2026-01-06 12:17:38');
INSERT INTO `tasas_cambio` VALUES (92, '2026-01-07', 311.88140000, '2026-01-07 05:22:41');
INSERT INTO `tasas_cambio` VALUES (93, '2026-01-08', 321.03230000, '2026-01-08 11:24:26');
INSERT INTO `tasas_cambio` VALUES (94, '2026-01-09', 325.38940000, '2026-01-09 13:49:17');
INSERT INTO `tasas_cambio` VALUES (95, '2026-01-13', 330.37510000, '2026-01-10 13:45:01');
INSERT INTO `tasas_cambio` VALUES (96, '2026-01-14', 336.45960000, '2026-01-14 15:24:22');
INSERT INTO `tasas_cambio` VALUES (97, '2026-01-15', 339.14950000, '2026-01-15 13:23:53');
INSERT INTO `tasas_cambio` VALUES (98, '2026-01-16', 341.74250000, '2026-01-16 14:01:41');
INSERT INTO `tasas_cambio` VALUES (99, '2026-01-20', 344.50710000, '2026-01-17 12:00:52');
INSERT INTO `tasas_cambio` VALUES (100, '2026-01-21', 347.26310000, '2026-01-21 20:02:03');
INSERT INTO `tasas_cambio` VALUES (101, '2026-01-23', 352.70630000, '2026-01-23 00:35:53');
INSERT INTO `tasas_cambio` VALUES (102, '2026-01-26', 355.55280000, '2026-01-25 12:00:52');

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
) ENGINE = MyISAM AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 0, 'JAVIER', '$2y$10$rr6PECvkq.xJxxJGoQxQB.bfcC2ouAST.H7T94GeCBOiwhqXLeeY6', '2025-08-16 15:12:45', 'Usuario', 'admin', 1);
INSERT INTO `users` VALUES (2, 1, '16912337', '$2y$10$8Qe7Zp2X1.G3F/H0.Jk5.OeRjI.D1M3.C1/Z/Z/Z/Z/Z/Z/Z/Z/Z', '2026-01-26 17:43:06', 'Javier Ponciano', 'admin', 1);
INSERT INTO `users` VALUES (3, 1, '0', '$2y$10$8Qe7Zp2X1.G3F/H0.Jk5.OeRjI.D1M3.C1/Z/Z/Z/Z/Z/Z/Z/Z/Z', '2026-01-26 17:43:06', 'Super Administrador', 'superadmin', 1);

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
) ENGINE = MyISAM AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of ventas
-- ----------------------------
INSERT INTO `ventas` VALUES (1, 1, '2026-01-26 17:57:09', 1503.99, 4.23, 355.55);

SET FOREIGN_KEY_CHECKS = 1;
