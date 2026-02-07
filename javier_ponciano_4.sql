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

 Date: 06/02/2026 21:23:58
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for abonos
-- ----------------------------
DROP TABLE IF EXISTS `abonos`;
CREATE TABLE `abonos`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `fiado_id` int NOT NULL,
  `monto_bs` decimal(10, 2) NOT NULL,
  `monto_usd` decimal(10, 2) NOT NULL,
  `observaciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `fecha` timestamp NULL DEFAULT current_timestamp,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fiado_id`(`fiado_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of abonos
-- ----------------------------
INSERT INTO `abonos` VALUES (1, 12, 8984.60, 23.74, NULL, '2026-02-05 22:52:40');

-- ----------------------------
-- Table structure for clientes
-- ----------------------------
DROP TABLE IF EXISTS `clientes`;
CREATE TABLE `clientes`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `negocio_id` int NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cedula` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `direccion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `deuda_total` decimal(10, 2) NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT current_timestamp,
  `updated_at` timestamp NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `negocio_id`(`negocio_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of clientes
-- ----------------------------
INSERT INTO `clientes` VALUES (1, 1, 'Teresa', NULL, '04243812619', NULL, 68.82, '2026-02-03 07:23:48', '2026-02-04 21:36:09');
INSERT INTO `clientes` VALUES (2, 1, 'Maryury Rivero', NULL, '04125839246', NULL, 37.26, '2026-02-03 15:31:11', '2026-02-04 21:15:56');
INSERT INTO `clientes` VALUES (3, 1, 'Congui Lisandro Salas', NULL, '04243604887', NULL, 69.42, '2026-02-04 21:07:43', '2026-02-04 21:07:43');
INSERT INTO `clientes` VALUES (4, 1, 'Enrique Ortiz', NULL, '04129070729', NULL, 309.08, '2026-02-04 21:07:43', '2026-02-04 21:07:43');
INSERT INTO `clientes` VALUES (5, 1, 'Jose Miguel Ortiz', NULL, '04144866837', NULL, 11.22, '2026-02-04 21:07:43', '2026-02-04 21:07:43');
INSERT INTO `clientes` VALUES (6, 1, 'Noelito Noel Ortiz', NULL, '04243275662', NULL, 272.76, '2026-02-04 21:07:43', '2026-02-04 21:07:43');
INSERT INTO `clientes` VALUES (7, 1, 'Ramón Abreu', NULL, '04144472849', NULL, 49.40, '2026-02-04 21:14:03', '2026-02-04 21:14:03');
INSERT INTO `clientes` VALUES (8, 1, 'Miguel Calderón', NULL, '04144748183', NULL, 10.31, '2026-02-04 21:14:03', '2026-02-04 21:20:00');
INSERT INTO `clientes` VALUES (9, 1, 'Yohana', NULL, '', NULL, 12.40, '2026-02-04 21:14:03', '2026-02-04 21:14:03');
INSERT INTO `clientes` VALUES (10, 1, 'Regina', NULL, '', NULL, 12.82, '2026-02-04 21:14:03', '2026-02-04 21:14:03');
INSERT INTO `clientes` VALUES (12, 1, 'Noel Brizuela', NULL, NULL, NULL, 23.74, '2026-02-04 21:14:50', '2026-02-04 21:30:22');

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
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of compras
-- ----------------------------

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
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of compras_items
-- ----------------------------

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
) ENGINE = MyISAM AUTO_INCREMENT = 38 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of detalle_ventas
-- ----------------------------
INSERT INTO `detalle_ventas` VALUES (1, 1, 171, 1.00, 1391.56);
INSERT INTO `detalle_ventas` VALUES (2, 1, 59, 1.00, 487.61);
INSERT INTO `detalle_ventas` VALUES (3, 2, 173, 1.00, 656.39);
INSERT INTO `detalle_ventas` VALUES (4, 2, 38, 7.00, 48.76);
INSERT INTO `detalle_ventas` VALUES (5, 2, 63, 1.00, 513.86);
INSERT INTO `detalle_ventas` VALUES (6, 3, 196, 1.00, 1200.26);
INSERT INTO `detalle_ventas` VALUES (7, 3, 38, 20.00, 768.92);
INSERT INTO `detalle_ventas` VALUES (8, 3, 63, 1.00, 513.86);
INSERT INTO `detalle_ventas` VALUES (9, 3, 5, 1.00, 375.08);
INSERT INTO `detalle_ventas` VALUES (10, 3, 312, 4.00, 555.12);
INSERT INTO `detalle_ventas` VALUES (11, 3, 82, 2.00, 243.80);
INSERT INTO `detalle_ventas` VALUES (12, 3, 202, 1.00, 225.05);
INSERT INTO `detalle_ventas` VALUES (13, 3, 176, 10.00, 633.89);
INSERT INTO `detalle_ventas` VALUES (14, 4, 69, 1.00, 611.38);
INSERT INTO `detalle_ventas` VALUES (15, 5, 75, 1.00, 487.61);
INSERT INTO `detalle_ventas` VALUES (16, 5, 56, 1.00, 243.80);
INSERT INTO `detalle_ventas` VALUES (17, 6, 333, 2.00, 190.00);
INSERT INTO `detalle_ventas` VALUES (18, 6, 249, 1.00, 227.07);
INSERT INTO `detalle_ventas` VALUES (19, 7, 173, 1.00, 662.30);
INSERT INTO `detalle_ventas` VALUES (20, 7, 264, 1.00, 75.69);
INSERT INTO `detalle_ventas` VALUES (21, 8, 56, 1.00, 246.00);
INSERT INTO `detalle_ventas` VALUES (22, 8, 107, 1.00, 624.46);
INSERT INTO `detalle_ventas` VALUES (23, 9, 226, 1.00, 495.44);
INSERT INTO `detalle_ventas` VALUES (29, 14, 38, 20.00, 781.27);
INSERT INTO `detalle_ventas` VALUES (28, 13, 38, 20.00, 781.27);
INSERT INTO `detalle_ventas` VALUES (27, 13, 38, 1.00, 49.54);
INSERT INTO `detalle_ventas` VALUES (30, 14, 63, 1.00, 522.12);
INSERT INTO `detalle_ventas` VALUES (31, 15, 38, 8.00, 49.54);
INSERT INTO `detalle_ventas` VALUES (32, 16, 122, 2.00, 209.61);
INSERT INTO `detalle_ventas` VALUES (33, 16, 102, 1.00, 247.72);
INSERT INTO `detalle_ventas` VALUES (34, 17, 79, 1.00, 228.66);
INSERT INTO `detalle_ventas` VALUES (35, 17, 56, 1.00, 247.72);
INSERT INTO `detalle_ventas` VALUES (36, 18, 63, 1.00, 522.12);
INSERT INTO `detalle_ventas` VALUES (37, 18, 275, 1.00, 343.00);

-- ----------------------------
-- Table structure for fiado_detalles
-- ----------------------------
DROP TABLE IF EXISTS `fiado_detalles`;
CREATE TABLE `fiado_detalles`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `fiado_id` int NOT NULL,
  `producto_id` int NOT NULL,
  `cantidad` decimal(10, 3) NOT NULL,
  `precio_unitario_bs` decimal(10, 2) NOT NULL,
  `precio_unitario_usd` decimal(10, 2) NOT NULL,
  `subtotal_bs` decimal(10, 2) NOT NULL,
  `subtotal_usd` decimal(10, 2) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fiado_id`(`fiado_id`) USING BTREE,
  INDEX `producto_id`(`producto_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of fiado_detalles
-- ----------------------------
INSERT INTO `fiado_detalles` VALUES (1, 1, 189, 1.000, 1440.05, 3.87, 1440.05, 3.87);
INSERT INTO `fiado_detalles` VALUES (2, 1, 69, 2.000, 606.53, 1.63, 1213.06, 3.26);
INSERT INTO `fiado_detalles` VALUES (3, 1, 15, 1.000, 721.89, 1.94, 721.89, 1.94);
INSERT INTO `fiado_detalles` VALUES (4, 1, 23, 1.000, 1209.34, 3.25, 1209.34, 3.25);
INSERT INTO `fiado_detalles` VALUES (5, 1, 122, 2.000, 204.66, 0.55, 409.32, 1.10);
INSERT INTO `fiado_detalles` VALUES (6, 1, 312, 4.000, 550.72, 1.48, 2202.87, 5.92);
INSERT INTO `fiado_detalles` VALUES (7, 1, 198, 2.000, 1034.45, 2.78, 2068.91, 5.56);
INSERT INTO `fiado_detalles` VALUES (8, 1, 32, 0.315, 1040.00, 2.79, 327.60, 0.88);
INSERT INTO `fiado_detalles` VALUES (9, 1, 311, 1.000, 1562.84, 4.20, 1562.84, 4.20);
INSERT INTO `fiado_detalles` VALUES (10, 1, 29, 0.150, 550.00, 1.48, 82.50, 0.22);
INSERT INTO `fiado_detalles` VALUES (11, 2, 151, 2.000, 532.11, 1.43, 1064.22, 2.86);
INSERT INTO `fiado_detalles` VALUES (12, 2, 63, 1.000, 509.78, 1.37, 509.78, 1.37);
INSERT INTO `fiado_detalles` VALUES (13, 13, 172, 1.000, 1324.60, 3.50, 1324.60, 3.50);
INSERT INTO `fiado_detalles` VALUES (14, 13, 35, 20.000, 1362.45, 3.60, 27248.99, 72.00);
INSERT INTO `fiado_detalles` VALUES (15, 13, 176, 1.000, 639.59, 1.69, 639.59, 1.69);
INSERT INTO `fiado_detalles` VALUES (16, 14, 208, 2.000, 114.33, 0.30, 228.66, 0.60);
INSERT INTO `fiado_detalles` VALUES (17, 14, 35, 20.000, 1371.99, 3.60, 27439.73, 72.00);
INSERT INTO `fiado_detalles` VALUES (18, 15, 14, 1.000, 682.18, 1.79, 682.18, 1.79);
INSERT INTO `fiado_detalles` VALUES (19, 15, 201, 1.000, 762.21, 2.00, 762.21, 2.00);

-- ----------------------------
-- Table structure for fiados
-- ----------------------------
DROP TABLE IF EXISTS `fiados`;
CREATE TABLE `fiados`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `negocio_id` int NOT NULL,
  `cliente_id` int NOT NULL,
  `total_bs` decimal(10, 2) NOT NULL,
  `total_usd` decimal(10, 2) NOT NULL,
  `saldo_pendiente` decimal(10, 2) NOT NULL,
  `tasa` decimal(10, 2) NOT NULL,
  `estado` enum('pendiente','pagado','cancelado') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'pendiente',
  `fecha` timestamp NULL DEFAULT current_timestamp,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `negocio_id`(`negocio_id`) USING BTREE,
  INDEX `cliente_id`(`cliente_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of fiados
-- ----------------------------
INSERT INTO `fiados` VALUES (1, 1, 2, 13844.11, 37.26, 37.26, 372.11, 'pendiente', '2026-02-03 15:46:42');
INSERT INTO `fiados` VALUES (2, 1, 1, 25480.61, 68.82, 68.82, 372.11, 'pendiente', '2026-02-03 22:46:47');
INSERT INTO `fiados` VALUES (3, 1, 3, 25702.75, 69.42, 69.42, 370.25, 'pendiente', '2026-02-04 21:09:53');
INSERT INTO `fiados` VALUES (4, 1, 4, 114436.87, 309.08, 309.08, 370.25, 'pendiente', '2026-02-04 21:09:53');
INSERT INTO `fiados` VALUES (5, 1, 5, 4154.20, 11.22, 11.22, 370.25, 'pendiente', '2026-02-04 21:09:53');
INSERT INTO `fiados` VALUES (6, 1, 6, 100989.40, 272.76, 272.76, 370.25, 'pendiente', '2026-02-04 21:09:53');
INSERT INTO `fiados` VALUES (7, 1, 7, 18290.35, 49.40, 49.40, 370.25, 'pendiente', '2026-02-04 21:14:03');
INSERT INTO `fiados` VALUES (8, 1, 8, 3817.28, 10.31, 10.31, 370.25, 'pendiente', '2026-02-04 21:14:03');
INSERT INTO `fiados` VALUES (9, 1, 9, 4591.10, 12.40, 12.40, 370.25, 'pendiente', '2026-02-04 21:14:03');
INSERT INTO `fiados` VALUES (10, 1, 10, 4746.60, 12.82, 12.82, 370.25, 'pendiente', '2026-02-04 21:14:03');
INSERT INTO `fiados` VALUES (13, 1, 7, 3326.65, 8.79, 8.79, 378.46, 'pendiente', '2026-02-05 12:28:57');
INSERT INTO `fiados` VALUES (12, 1, 12, 8789.74, 23.74, 0.00, 370.25, 'pagado', '2026-02-04 21:14:50');
INSERT INTO `fiados` VALUES (14, 1, 7, 1600.65, 4.20, 4.20, 381.11, 'pendiente', '2026-02-06 13:00:12');
INSERT INTO `fiados` VALUES (15, 1, 9, 1444.40, 3.79, 3.79, 381.11, 'pendiente', '2026-02-06 16:27:36');

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
INSERT INTO `negocios` VALUES (1, 'SuperBodega', NULL, 1);
INSERT INTO `negocios` VALUES (2, 'Motorepuestos y Accesorios Nicol C.A', NULL, 1);

-- ----------------------------
-- Table structure for productos
-- ----------------------------
DROP TABLE IF EXISTS `productos`;
CREATE TABLE `productos`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `negocio_id` int NOT NULL,
  `proveedor_id` int NULL DEFAULT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `codigo_interno` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `marca` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `codigo_barras` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `unidad_medida` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'unidad',
  `tam_paquete` decimal(10, 2) NULL DEFAULT 1.00,
  `stock` decimal(10, 2) NULL DEFAULT 0.00,
  `fecha_vencimiento` date NULL DEFAULT NULL,
  `bajo_inventario` int NULL DEFAULT 5,
  `moneda_base` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'USD',
  `costo_unitario` decimal(10, 2) NULL DEFAULT 0.00,
  `precio_venta_unidad` decimal(10, 2) NULL DEFAULT 0.00,
  `precio_venta_paquete` decimal(10, 2) NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT current_timestamp,
  `updated_at` timestamp NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP,
  `vende_media` tinyint(1) NOT NULL DEFAULT 0,
  `vende_por_peso` tinyint NULL DEFAULT 0,
  `imagen` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_negocio`(`negocio_id`) USING BTREE,
  INDEX `idx_proveedor`(`proveedor_id`) USING BTREE,
  INDEX `idx_codigo`(`codigo_barras`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1193 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of productos
-- ----------------------------
INSERT INTO `productos` VALUES (1, 1, 2, 'QUESO', NULL, '', NULL, '', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 4.80, 7.00, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 1, NULL);
INSERT INTO `productos` VALUES (2, 1, 3, 'CLUB SOCIAL', NULL, '', NULL, '7590011205158', 'unidad', 6.00, 10.00, NULL, 0, 'USD', 0.26, 0.40, 2.15, '2026-01-27 18:05:01', '2026-02-06 03:29:11', 0, 0, NULL);
INSERT INTO `productos` VALUES (63, 1, 4, 'GLUP 2LTS', NULL, '', NULL, '', 'unidad', 6.00, 5.00, NULL, 0, 'USD', 1.05, 1.37, 1.41, '2026-01-27 18:05:01', '2026-02-07 00:31:42', 0, 0, NULL);
INSERT INTO `productos` VALUES (4, 1, 5, 'CATALINAS', NULL, NULL, NULL, NULL, 'unidad', 10.00, 10.00, NULL, 0, 'USD', 0.30, 0.40, 3.50, '2026-01-27 18:05:01', '2026-02-06 03:28:06', 0, 0, NULL);
INSERT INTO `productos` VALUES (5, 1, 6, 'PAN SALADO', NULL, NULL, NULL, NULL, 'unidad', 1.00, 9.00, NULL, 20, 'USD', 0.80, 1.00, NULL, '2026-01-27 18:05:01', '2026-02-06 21:33:01', 0, 0, NULL);
INSERT INTO `productos` VALUES (6, 1, 7, 'PAN CLINEJA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.30, 1.60, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (300, 1, 8, 'HELADO YOGURT', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.40, 0.55, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (8, 1, 7, 'PAN RELLENO GUAYABA', NULL, NULL, NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 0.33, 0.45, 4.50, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (9, 1, 7, 'PAN COCO', NULL, NULL, NULL, NULL, 'paquete', 10.00, 10.00, NULL, 1, 'USD', 0.27, 0.40, 3.30, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (10, 1, 9, 'RIQUESA', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 3.15, 3.50, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (11, 1, 10, 'SALSA SOYA AJO INGLESA DOÑA TITA', NULL, '', NULL, '7597459000055', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 1.10, 1.43, 1.43, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (12, 1, 11, 'ACEITE VATEL', NULL, '', NULL, '7591049193035', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 5.00, 6.00, 6.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (13, 1, 3, 'SALSA PASTA UW 490GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 2.66, 2.95, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (14, 1, 4, 'ARROZ', NULL, '', NULL, '7590274000026', 'unidad', 24.00, 9.00, NULL, 0, 'USD', 1.38, 1.79, 1.79, '2026-01-27 18:05:01', '2026-02-06 16:27:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (15, 1, 1, 'HARINA PAN', NULL, NULL, NULL, NULL, 'paquete', 20.00, 10.00, NULL, 20, 'USD', 1.55, 1.94, 1.94, '2026-01-27 18:05:01', '2026-02-06 21:33:01', 0, 0, NULL);
INSERT INTO `productos` VALUES (16, 1, 3, 'CARAMELO FREEGELLS', NULL, '', NULL, '7891151039673', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.23, 0.50, 0.50, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (17, 1, 3, 'HALLS', NULL, NULL, NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 0.46, 0.65, 0.65, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (339, 1, 3, 'GALLE LULU LIMON 175GR', NULL, '', NULL, '7591082000802', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.61, 2.01, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (19, 1, 10, 'TORONTO', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.59, 0.65, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (20, 1, 10, 'CHOCOLATE SAVOY', NULL, '', NULL, '7591016851135', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 1.29, 1.70, 1.70, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (21, 1, 3, 'CHICLE GIGANTE', NULL, '', NULL, '8964001247173', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.50, 0.55, 0.00, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (22, 1, NULL, 'GALLETAS MALTN\'MILK', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.23, 0.25, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (23, 1, 11, 'JABÓN PROTEX 110GR', NULL, NULL, NULL, NULL, 'paquete', 3.00, 10.00, NULL, 0, 'USD', 2.50, 3.25, 9.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (24, 1, 4, 'ESPONJAS', NULL, NULL, NULL, NULL, 'paquete', 2.00, 10.00, NULL, 1, 'USD', 0.60, 0.85, 0.85, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (25, 1, 4, 'FREGADOR', NULL, NULL, NULL, NULL, 'paquete', 15.00, 10.00, NULL, 0, 'USD', 0.37, 0.70, 0.70, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (26, 1, NULL, 'COCA-COLA 1.5LTS', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.44, 1.60, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (28, 1, 9, 'GATORADE', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.62, 1.80, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (29, 1, 12, 'TOMATE', NULL, NULL, NULL, NULL, 'kg', 1.00, 10.00, NULL, 0, 'BS', 390.00, 550.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (30, 1, 12, 'CEBOLLA', NULL, NULL, NULL, NULL, 'kg', 1.00, 10.00, NULL, 0, 'BS', 380.00, 550.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (31, 1, 12, 'PAPA', NULL, NULL, NULL, NULL, 'kg', 1.00, 10.00, NULL, 0, 'BS', 380.00, 650.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (32, 1, 12, 'PLaTANO', NULL, '', NULL, '', 'kg', 1.00, 10.00, NULL, 0, 'BS', 700.00, 1040.00, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (33, 1, 13, 'LUCKY', NULL, '', NULL, '', 'paquete', 20.00, 10.00, NULL, 0, 'USD', 0.17, 0.25, 4.40, '2026-01-27 18:05:01', '2026-02-04 14:58:46', 0, 0, NULL);
INSERT INTO `productos` VALUES (34, 1, 13, 'BELTMONT', NULL, '', NULL, '75903169', 'paquete', 20.00, 10.00, NULL, 0, 'USD', 0.14, 0.22, 3.60, '2026-01-27 18:05:01', '2026-02-04 15:06:17', 0, 0, NULL);
INSERT INTO `productos` VALUES (35, 1, 13, 'PALLMALL', NULL, '', NULL, '', 'paquete', 20.00, 60.00, NULL, 0, 'USD', 0.14, 0.22, 3.60, '2026-01-27 18:05:01', '2026-02-06 21:19:29', 0, 0, NULL);
INSERT INTO `productos` VALUES (37, 1, 13, 'UNIVERSAL', NULL, '', NULL, '', 'paquete', 20.00, 10.00, NULL, 0, 'USD', 0.09, 0.15, 2.35, '2026-01-27 18:05:01', '2026-02-04 14:58:46', 0, 0, NULL);
INSERT INTO `productos` VALUES (38, 1, 13, 'CONSUL', NULL, '', NULL, '75903206', 'paquete', 20.00, 11.00, NULL, 0, 'USD', 0.08, 0.13, 2.05, '2026-01-27 18:05:01', '2026-02-06 22:16:04', 0, 0, NULL);
INSERT INTO `productos` VALUES (39, 1, 3, 'VELAS', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.23, 0.25, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (283, 1, 1, 'JUGO JUCOSA', NULL, NULL, NULL, NULL, 'paquete', 3.00, 10.00, NULL, 0, 'USD', 0.53, 0.70, 2.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (42, 1, 4, 'LOPERAN', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.23, 0.25, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (45, 1, 14, 'DICLOFENAC POTÁSICO', NULL, NULL, NULL, NULL, 'paquete', 30.00, 10.00, NULL, 0, 'USD', 0.03, 0.15, 0.15, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (44, 1, 4, 'DICLOFENAC SÓDICO', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.09, 0.10, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (46, 1, 14, 'METOCLOPRAMIDA', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.32, 0.35, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (47, 1, 14, 'IBUPROFENO', NULL, NULL, NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 0.12, 0.20, 0.20, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (48, 1, 14, 'LORATADINA', NULL, NULL, NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 0.15, 0.25, 0.25, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (49, 1, 14, 'CETIRIZINA', NULL, NULL, NULL, NULL, 'paquete', 20.00, 10.00, NULL, 0, 'USD', 0.05, 0.15, 0.15, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (50, 1, 14, 'ACETAMINOFÉN', NULL, NULL, NULL, NULL, 'paquete', 20.00, 10.00, NULL, 0, 'USD', 0.05, 0.15, 0.15, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (51, 1, 14, 'OMEPRAZOL', NULL, NULL, NULL, NULL, 'paquete', 28.00, 10.00, NULL, 0, 'USD', 0.11, 0.20, 0.20, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (52, 1, 14, 'AMOXICILINA', NULL, NULL, NULL, NULL, 'paquete', 10.00, 10.00, NULL, 1, 'USD', 0.22, 0.30, 0.30, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (53, 1, 14, 'METRONIDAZOL', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.18, 0.20, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (54, 1, 4, 'GLUP 1 LT', NULL, '', NULL, '', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.74, 1.00, 1.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (55, 1, 4, 'GLUP 400ML', NULL, NULL, NULL, NULL, 'paquete', 15.00, 9.00, NULL, 0, 'USD', 0.39, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-06 15:23:03', 0, 0, NULL);
INSERT INTO `productos` VALUES (56, 1, 9, 'MALTA DE BOTELLA', NULL, '', NULL, '', 'unidad', 36.00, 7.00, NULL, 1, 'USD', 0.46, 0.65, 0.65, '2026-01-27 18:05:01', '2026-02-07 00:29:32', 0, 0, NULL);
INSERT INTO `productos` VALUES (57, 1, 9, 'PEPSI-COLA 1.25LTS', NULL, '', NULL, '', 'unidad', 6.00, 10.00, NULL, 0, 'USD', 0.75, 1.00, 1.10, '2026-01-27 18:05:01', '2026-02-06 03:28:06', 0, 0, NULL);
INSERT INTO `productos` VALUES (58, 1, 9, 'PEPSI-COLA 2LT', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.80, 2.00, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (59, 1, 4, 'JUSTY', NULL, '', NULL, NULL, 'unidad', 1.00, 9.00, NULL, 0, 'USD', 1.17, 1.30, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (60, 1, 4, 'COCA-COLA 2LTS', NULL, '', NULL, '7591127123626', 'unidad', 6.00, 10.00, NULL, 0, 'USD', 1.67, 2.20, 2.20, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (61, 1, 9, 'MALTA 1.5LTS', NULL, '', NULL, '', 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.64, 2.13, 2.15, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (62, 1, 3, 'JUGO FRICAJITA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.99, 1.24, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (65, 1, NULL, 'COCA-COLA 1LT', NULL, '', NULL, NULL, 'paquete', 6.00, 10.00, NULL, 0, 'USD', 0.83, 1.10, 1.10, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (275, 1, 1, 'GOMITAS PLAY', NULL, NULL, NULL, NULL, 'paquete', 24.00, 9.00, NULL, 0, 'USD', 0.58, 0.90, 0.90, '2026-01-27 18:05:01', '2026-02-07 00:31:42', 0, 0, NULL);
INSERT INTO `productos` VALUES (67, 1, 11, 'PAPEL NARANJA 400', NULL, NULL, NULL, NULL, 'paquete', 4.00, 10.00, NULL, 0, 'USD', 0.73, 1.10, 3.70, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (68, 1, 11, 'GALLETA MARIA ITALIA', NULL, '', NULL, '7597089000036', 'unidad', 9.00, 10.00, NULL, 0, 'USD', 0.06, 0.10, 0.90, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (69, 1, 15, 'CAFE AMANECER 100GR', NULL, '', NULL, '7595461001206', 'unidad', 10.00, 9.00, NULL, 1, 'USD', 1.30, 1.63, 1.63, '2026-01-27 18:05:01', '2026-02-04 23:34:28', 0, 0, NULL);
INSERT INTO `productos` VALUES (70, 1, 15, 'CARAOTAS AMANECER', NULL, '', NULL, '7599450000089', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.00, 1.35, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (71, 1, 15, 'PASTA LARGA NONNA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.75, 0.95, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (72, 1, 15, 'PASTA CORTA NONNA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 20, 'USD', 1.40, 2.10, NULL, '2026-01-27 18:05:01', '2026-02-06 21:33:01', 0, 0, NULL);
INSERT INTO `productos` VALUES (73, 1, 16, 'DORITOS PEQ', NULL, '', NULL, '', 'paquete', 1.00, 10.00, NULL, 0, 'USD', 1.11, 1.40, 0.00, '2026-01-27 18:05:01', '2026-02-04 12:24:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (74, 1, 16, 'DORITOS DIN PEQ', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.08, 1.20, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (75, 1, 16, 'DORITOS FH PEQ', NULL, '', NULL, NULL, 'unidad', 1.00, 9.00, NULL, 0, 'USD', 1.03, 1.30, 0.00, '2026-01-27 18:05:01', '2026-02-04 23:35:04', 0, 0, NULL);
INSERT INTO `productos` VALUES (76, 1, 16, 'DORITOS DIN FH PEQ', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.08, 1.20, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (77, 1, 16, 'CHEESE TRIS P', NULL, '', NULL, '7591206003924', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.77, 1.00, 0.00, '2026-01-27 18:05:01', '2026-02-04 10:37:07', 0, 0, NULL);
INSERT INTO `productos` VALUES (78, 1, 16, 'PEPITO P', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.90, 1.00, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (79, 1, 11, 'BOLI KRUCH', NULL, '', NULL, '7592708000336', 'unidad', 12.00, 9.00, NULL, 0, 'USD', 0.37, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-07 00:29:32', 0, 0, NULL);
INSERT INTO `productos` VALUES (80, 1, 11, 'KESITOS P', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.54, 0.60, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (81, 1, 1, 'PIGSY PICANTE', NULL, NULL, NULL, NULL, 'paquete', 18.00, 10.00, NULL, 1, 'USD', 0.19, 0.40, 0.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (82, 1, 16, 'RAQUETY', NULL, '', NULL, NULL, 'unidad', 1.00, 8.00, NULL, 0, 'USD', 0.48, 0.65, 0.00, '2026-01-27 18:05:01', '2026-02-04 23:32:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (83, 1, 11, 'CHISKESITO PEQUEÑO', NULL, NULL, NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 0.61, 0.80, 0.70, '2026-01-27 18:05:01', '2026-02-04 12:24:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (84, 1, 3, 'CHIPS AHOY', NULL, '', NULL, '7590011138104', 'paquete', 6.00, 10.00, NULL, 0, 'USD', 0.06, 0.50, 2.75, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (85, 1, 1, 'COCO CRUCH', NULL, '', NULL, '7973593350896', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.40, 1.82, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (86, 1, 11, 'SALSERITOS GRANDES', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.61, 2.01, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (87, 1, 11, 'SALSERITOS PEQUEÑOS', NULL, NULL, NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 0.42, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (88, 1, 4, 'TOSTON TOM', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.41, 0.45, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (89, 1, 3, 'MINI CHIPS', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.90, 2.30, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (90, 1, 3, 'NUCITA CRUNCH', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.48, 1.85, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (91, 1, 11, 'FLIPS PEQUEÑO', NULL, NULL, NULL, NULL, 'paquete', 6.00, 10.00, NULL, 0, 'USD', 0.56, 0.75, 0.80, '2026-01-27 18:05:01', '2026-02-04 12:24:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (92, 1, 11, 'FLIPS MEDIANO', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.84, 2.30, NULL, '2026-01-27 18:05:01', '2026-02-04 12:24:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (93, 1, 16, 'DORITOS G', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.97, 3.30, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (95, 1, 16, 'DORITOS FH G', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.97, 3.30, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (244, 1, 11, 'CHESITO P', NULL, '', NULL, '7592708001883', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.17, 0.40, 0.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (98, 1, 16, 'PEPITO G', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.10, 1.43, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (100, 1, 1, 'MAXCOCO', NULL, NULL, NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 0.78, 1.01, 1.01, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (101, 1, 3, 'CROC-CHOC', NULL, '', NULL, '7896383000811', 'unidad', 24.00, 10.00, NULL, 0, 'USD', 0.20, 0.40, 0.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (102, 1, 3, 'TRIDENT', NULL, NULL, NULL, NULL, 'paquete', 18.00, 9.00, NULL, 0, 'USD', 0.44, 0.65, 0.65, '2026-01-27 18:05:01', '2026-02-06 22:20:17', 0, 0, NULL);
INSERT INTO `productos` VALUES (103, 1, 3, 'MINTY', NULL, NULL, NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 0.37, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (104, 1, 3, 'CHICLE GUDS', NULL, '', NULL, '7897190307834', 'unidad', 18.00, 10.00, NULL, 0, 'USD', 0.14, 0.30, 0.30, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (105, 1, 3, 'NUCITA TUBO', NULL, '', NULL, '7591675010102', 'unidad', 12.00, 10.00, NULL, 1, 'USD', 1.10, 1.43, 1.30, '2026-01-27 18:05:01', '2026-02-06 03:28:06', 0, 0, NULL);
INSERT INTO `productos` VALUES (106, 1, 16, 'DANDY', NULL, '', NULL, '7702011040558', 'unidad', 16.00, 10.00, NULL, 1, 'USD', 0.63, 0.82, 0.60, '2026-01-27 18:05:01', '2026-02-04 10:34:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (107, 1, 3, 'OREO DE TUBO', NULL, '', NULL, '7622202213656', 'unidad', 1.00, 9.00, NULL, 0, 'USD', 1.24, 1.65, 0.00, '2026-01-27 18:05:01', '2026-02-05 22:59:11', 0, 0, NULL);
INSERT INTO `productos` VALUES (108, 1, 3, 'OREO 6S', NULL, '', NULL, '7622202213779', 'unidad', 6.00, 10.00, NULL, 0, 'USD', 0.06, 0.50, 2.55, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (110, 1, 3, 'OREO FUDGE', NULL, '', NULL, '7622202228742', 'paquete', 6.00, 10.00, NULL, 0, 'USD', 0.07, 0.65, 3.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (111, 1, 3, 'TAKYTA 150GR', NULL, NULL, NULL, NULL, 'paquete', 8.00, 10.00, NULL, 0, 'USD', 0.10, 0.15, 1.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (112, 1, 3, 'OREO DE CAJA', NULL, NULL, NULL, NULL, 'paquete', 8.00, 10.00, NULL, 0, 'USD', 0.55, 0.75, 0.75, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (113, 1, 3, 'CHUPETA PIN PON', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.45, 0.50, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (114, 1, 3, 'POLVO EXPLOSIVO', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.27, 0.30, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (115, 1, 3, 'CHUPETA EXPLOSIVA', NULL, '', NULL, '745853860912', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.36, 0.40, 0.00, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (116, 1, 3, 'CHICLE DE YOYO', NULL, '', NULL, '745853860998', 'unidad', 24.00, 10.00, NULL, 0, 'USD', 0.32, 0.50, 0.50, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (118, 1, 3, 'PIRULIN', NULL, '', NULL, '7591675013042', 'unidad', 25.00, 10.00, NULL, 0, 'USD', 0.47, 0.65, 0.55, '2026-01-27 18:05:01', '2026-02-06 03:28:06', 0, 0, NULL);
INSERT INTO `productos` VALUES (119, 1, 3, 'NUCITA', NULL, '', NULL, '75970109', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.43, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (120, 1, 1, 'BRINKY', NULL, NULL, NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 0.26, 0.50, 0.50, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (121, 1, 16, 'PEPITAS', NULL, '', NULL, '7591620010157', 'unidad', 18.00, 10.00, NULL, 0, 'USD', 0.33, 0.45, 0.45, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (122, 1, 16, 'PALITOS', NULL, '', NULL, '805579523116', 'unidad', 18.00, 8.00, NULL, 0, 'USD', 0.41, 0.55, 0.55, '2026-01-27 18:05:01', '2026-02-06 22:20:17', 0, 0, NULL);
INSERT INTO `productos` VALUES (123, 1, 3, 'COLORETI', NULL, '', NULL, '7896383000422', 'unidad', 24.00, 10.00, NULL, 0, 'USD', 0.19, 0.40, 0.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (124, 1, 3, 'SPARKIES BUBBALOO', NULL, '', NULL, '7702133879494', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.36, 0.40, 0.00, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (125, 1, 3, 'EXTINTOR', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.86, 0.95, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (126, 1, 3, 'CHUPETA DE ANILLOS', NULL, '', NULL, '659525562182', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.50, 0.55, 0.00, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (127, 1, 3, 'CRAYÓN CHICLE', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.23, 0.25, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (128, 1, 3, 'COLORES CHICLE', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.41, 0.45, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (129, 1, 3, 'CHUPETA DE MASCOTAS', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.17, 1.30, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (130, 1, 3, 'SPINNER RING', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.17, 1.30, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (131, 1, 3, 'JUGUETE DE POCETA', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.86, 0.95, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (132, 1, 10, 'COCOSETE', NULL, '', NULL, '7591016871089', 'unidad', 18.00, 10.00, NULL, 0, 'USD', 1.15, 1.50, 1.50, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (286, 1, 10, 'CEPILLO DENTAL COLGATE', NULL, '', NULL, '6910021007206', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.11, 1.50, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (134, 1, 10, 'SAMBA', NULL, NULL, NULL, NULL, 'paquete', 20.00, 10.00, NULL, 0, 'USD', 1.04, 1.35, 1.35, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (135, 1, 10, 'SAMBA PEQUEÑA', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.59, 0.65, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (136, 1, 11, 'FLIPS CAJA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.17, 4.00, NULL, '2026-01-27 18:05:01', '2026-02-04 12:24:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (137, 1, 3, 'CORN FLAKES DE CAJA', NULL, '', NULL, '7591057001285', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.56, 3.20, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (138, 1, 11, 'CRONCH FLAKES BOLSA', NULL, '', NULL, '7591039100050', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.21, 4.01, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (139, 1, 11, 'FRUTY AROS', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.33, 3.70, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (140, 1, 4, 'JUMBY RIKOS G', NULL, NULL, NULL, NULL, 'paquete', 18.00, 10.00, NULL, 0, 'USD', 0.78, 1.10, 1.10, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (141, 1, 11, 'CHISKESITO GRANDE', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.38, 1.85, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (142, 1, 11, 'CHESITO G', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.64, 0.85, NULL, '2026-01-27 18:05:01', '2026-02-04 12:24:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (143, 1, 4, 'DOBOM 400GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 20, 'USD', 5.90, 7.38, NULL, '2026-01-27 18:05:01', '2026-02-06 21:33:21', 0, 0, NULL);
INSERT INTO `productos` VALUES (144, 1, 4, 'DOBOM 200GRS', NULL, '', NULL, '7891097102042', 'unidad', 12.00, 10.00, NULL, 20, 'USD', 3.00, 3.75, 45.00, '2026-01-27 18:05:01', '2026-02-06 21:33:21', 0, 0, NULL);
INSERT INTO `productos` VALUES (145, 1, 4, 'DOBOM 125GRS', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 20, 'USD', 2.00, 2.50, NULL, '2026-01-27 18:05:01', '2026-02-06 21:33:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (146, 1, 3, 'CAMPIÑA 200GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.14, 3.77, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (147, 1, 3, 'CAMPIÑA 125GRS', NULL, '', NULL, '7591014014747', 'unidad', 1.00, 10.00, NULL, 1, 'USD', 2.17, 2.70, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (148, 1, 11, 'LECHE UPACA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.69, 2.20, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (149, 1, 3, 'LECHE INDOSA 200GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.10, 1.43, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (150, 1, 11, 'AVENA 200GR PANTERA', NULL, '', NULL, '7591794000558', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.83, 1.25, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (151, 1, 11, 'COMPOTA GRANDE', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.00, 1.30, NULL, '2026-01-27 18:05:01', '2026-02-04 12:24:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (152, 1, 11, 'COMPOTA PEQUEÑA', NULL, '', NULL, '75916084', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.79, 1.10, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (337, 1, 3, 'ELITE CHOC. TUBO 100GR', NULL, '', NULL, '7591082001366', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.95, 1.23, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (154, 1, 11, 'MAIZINA 90GR', NULL, '', NULL, '521439601526', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.82, 1.07, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (155, 1, 11, 'MAIZINA 120GR', NULL, '', NULL, '7591039770734', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.00, 1.30, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (156, 1, 10, 'SOPA MAGGY', NULL, NULL, NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 1.71, 2.22, 2.22, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (158, 1, 10, 'LECHE CONDENSADA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.96, 3.55, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (159, 1, 4, 'BOKA', NULL, NULL, NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 0.40, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (160, 1, 4, 'PEGA LOKA', NULL, NULL, NULL, NULL, 'paquete', 42.00, 10.00, NULL, 0, 'USD', 0.34, 0.70, 0.70, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (161, 1, 17, 'BOMBILLO LED 10W', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.05, 1.31, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (164, 1, 11, 'CARAOTA PANTERA', NULL, '', NULL, 'https://granospantera.start.page', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.71, 2.20, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (165, 1, 27, 'CARAOTAS DON JUAN', NULL, '', NULL, '527455000244', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.90, 1.00, 0.00, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (166, 1, 11, 'CARAOTA BLANCA PANTERA', NULL, '', NULL, '7591794000442', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.02, 2.63, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (167, 1, 11, 'FRIJOL PANTERA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.35, 1.50, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (168, 1, 11, 'ARVEJAS PANTERA', NULL, '', NULL, 'https://granospantera.start.page', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.60, 2.00, 2.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (169, 1, 11, 'MAÍZ DE COTUFAS', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.34, 1.65, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (170, 1, 15, 'CAFÉ AMANECER 200GR', NULL, '', NULL, '7595461000049', 'unidad', 6.00, 10.00, NULL, 1, 'USD', 2.41, 3.01, 3.01, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (171, 1, 11, 'CAFÉ FLOR ARAUCA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 9.00, NULL, 0, 'USD', 2.85, 3.71, NULL, '2026-01-27 18:05:01', '2026-02-04 16:26:25', 0, 0, NULL);
INSERT INTO `productos` VALUES (172, 1, 11, 'CAFÉ ARAUCA 200GRS', NULL, '', NULL, '7596540000257', 'unidad', 1.00, 9.00, NULL, 1, 'USD', 2.78, 3.50, 0.00, '2026-01-27 18:05:01', '2026-02-05 12:28:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (173, 1, 11, 'CAFÉ ARAUCA 100GR', NULL, '', NULL, '7596540000264', 'unidad', 1.00, 8.00, NULL, 0, 'USD', 1.43, 1.75, 0.00, '2026-01-27 18:05:01', '2026-02-05 22:17:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (174, 1, 11, 'CAFÉ ARAUCA 50GRS', NULL, '', NULL, '7596540001544', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.64, 0.90, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (260, 1, 10, 'SALSA DOÑA TITA PEQ', NULL, '', NULL, '7597459000680', 'unidad', 24.00, 10.00, NULL, 0, 'USD', 1.06, 1.40, 1.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (176, 1, 4, 'YOKOIMA 100GR', NULL, NULL, NULL, NULL, 'paquete', 10.00, 7.00, NULL, 0, 'USD', 1.35, 1.69, 1.69, '2026-01-27 18:05:01', '2026-02-06 21:19:29', 0, 0, NULL);
INSERT INTO `productos` VALUES (177, 1, 15, 'FAVORITO 100GRS', NULL, '', NULL, '7595461000292', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.35, 1.50, 0.00, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (178, 1, 15, 'FAVORITO 50GRS', NULL, '', NULL, '7595461000315', 'unidad', 20.00, 10.00, NULL, 0, 'USD', 0.56, 0.73, 0.73, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (179, 1, 9, 'SALSA PAMPERO GR', NULL, '', NULL, '75919191', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.89, 2.10, 0.00, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (180, 1, 9, 'SALSA PAMPERO PEQ', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.31, 1.45, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (181, 1, 11, 'SALSA TIQUIRE GR', NULL, '', NULL, '75919740', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.89, 2.10, 0.00, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (182, 1, 11, 'SALSA TIQUIRE PEQ', NULL, '', NULL, '75920531', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.31, 1.45, 0.00, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (183, 1, 10, 'SALSA DOÑA TITA GR', NULL, '', NULL, '1007400934293', 'unidad', 24.00, 10.00, NULL, 0, 'USD', 1.71, 2.14, 2.14, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (184, 1, 9, 'MAYONESA MAVESA PEQUEÑA', NULL, NULL, NULL, NULL, 'paquete', 24.00, 10.00, NULL, 0, 'USD', 2.04, 2.55, 2.55, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (185, 1, 3, 'MAYONESA KRAFF 175GR', NULL, '', NULL, '', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.97, 2.56, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (187, 1, 3, 'DIABLITOS 115GR', NULL, '', NULL, '7591072003622', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.71, 3.25, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (188, 1, 3, 'DIABLITOS 54GR', NULL, '', NULL, '7591072000027', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.58, 1.98, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (189, 1, 3, 'ATÚN AZUL SDLA', NULL, '', NULL, '7591072002342', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.98, 3.87, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (190, 1, 3, 'ATUN ROJO SDLA', NULL, '', NULL, '7591072002359', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.45, 4.14, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (191, 1, 4, 'SARDINA', NULL, NULL, NULL, '7595122001927', 'paquete', 24.00, 10.00, NULL, 20, 'USD', 0.73, 1.00, 1.00, '2026-01-27 18:05:01', '2026-02-06 21:33:01', 0, 0, NULL);
INSERT INTO `productos` VALUES (192, 1, 11, 'VINAGRE DE MANZANA', NULL, '', NULL, '7591112000239', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.44, 1.60, 0.00, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (193, 1, 10, 'VINAGRE DOÑA TITA', NULL, '', NULL, '7597459000352', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.00, 1.55, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (194, 1, 11, 'VINAGRE TIQUIRE', NULL, '', NULL, '7591112049016', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.07, 1.40, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (195, 1, 4, 'ACEITE IDEAL 900ML', NULL, NULL, NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 3.28, 4.17, 4.17, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (196, 1, 4, 'ACEITE PAMPA 1/2LT', NULL, '', NULL, '7599959000016', 'unidad', 12.00, 9.00, NULL, 20, 'USD', 2.42, 3.20, 3.20, '2026-01-27 18:05:01', '2026-02-06 21:49:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (198, 1, 4, 'PASTA LARGA HORIZONTE', NULL, NULL, NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 2.14, 2.78, 2.78, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (199, 1, 4, 'PASTA HORIZONTE CORTA', NULL, NULL, NULL, NULL, 'paquete', 12.00, 10.00, NULL, 20, 'USD', 2.43, 3.15, 3.15, '2026-01-27 18:05:01', '2026-02-06 21:33:01', 0, 0, NULL);
INSERT INTO `productos` VALUES (200, 1, 4, 'HARINA DE TRIGO', NULL, NULL, NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 1.16, 1.52, 1.52, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (201, 1, 11, 'AZÚCAR', NULL, NULL, NULL, '7597304223943', 'paquete', 20.00, 9.00, NULL, 0, 'USD', 1.50, 2.00, 2.00, '2026-01-27 18:05:01', '2026-02-06 16:27:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (202, 1, 1, 'SAL', NULL, '', NULL, '7593575001129', 'unidad', 25.00, 9.00, NULL, 0, 'USD', 0.34, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-04 23:32:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (203, 1, 4, 'DELINE DE 250GRS', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.35, 1.50, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (204, 1, 9, 'NELLY DE 250GRS', NULL, NULL, NULL, NULL, 'paquete', 24.00, 10.00, NULL, 1, 'USD', 1.17, 1.60, 1.60, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (205, 1, 9, 'NELLY DE 500GRS', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 2.43, 2.70, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (206, 1, 9, 'MAVESA DE 250GRS', NULL, '', NULL, '', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.50, 1.90, 43.20, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (207, 1, 9, 'MAVESA DE 500GRS', NULL, '', NULL, '', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.69, 3.23, 2.60, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (208, 1, 1, 'HUEVOS', NULL, NULL, NULL, NULL, 'paquete', 30.00, 8.00, NULL, 0, 'USD', 0.22, 0.30, 8.00, '2026-01-27 18:05:01', '2026-02-06 13:00:12', 0, 0, NULL);
INSERT INTO `productos` VALUES (209, 1, 18, 'MASA PASTELITO ROMY', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.80, 2.20, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (210, 1, 4, 'NUTRIBELLA', NULL, NULL, NULL, NULL, 'paquete', 12.00, 10.00, NULL, 1, 'USD', 0.65, 0.85, 0.85, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (211, 1, 10, 'DESODORANTE CLINICAL', NULL, '', NULL, '7501033210778', 'unidad', 20.00, 10.00, NULL, 0, 'USD', 0.45, 0.65, 0.65, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (212, 1, 4, 'DESODORANTE', NULL, '', NULL, '7501033206580', 'unidad', 18.00, 10.00, NULL, 0, 'USD', 0.43, 0.58, 0.58, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (213, 1, 4, 'SHAMPOO H&S', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 0.54, 0.60, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (214, 1, 1, 'BOLSAS NEGRAS', NULL, NULL, NULL, NULL, 'paquete', 25.00, 10.00, NULL, 0, 'USD', 0.34, 0.55, 0.55, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (215, 1, 10, 'AXION EN CREMA', NULL, '', NULL, '7509546694566', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.11, 2.74, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (346, 1, 3, 'MARSHMALLOWS NAVIDEÑO', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.95, 1.20, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (349, 1, 10, 'CUBITOS MAGGIE', NULL, '', NULL, '7591016205709', 'unidad', 250.00, 10.00, NULL, 0, 'USD', 0.20, 0.35, 0.35, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (217, 1, 10, 'COLGATE TOTAL', NULL, '', NULL, '7793100111143', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.10, 2.63, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (218, 1, 10, 'COLGATE PLAX', NULL, '', NULL, '7591083018547', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.25, 4.23, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (219, 1, 10, 'COLGATE TRIPLE ACCIÓN 60ML', NULL, '', NULL, '7702010111501', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.73, 2.16, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (220, 1, 10, 'COLGATE TRADICIONAL 90ML', NULL, '', NULL, '7891024134702', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 1.50, 1.88, 22.56, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (221, 1, 10, 'COLGATE NIÑOS', NULL, '', NULL, '7891024036075', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.60, 2.00, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (322, 1, 3, 'MARIA SELECTA', NULL, '', NULL, '7591082010016', 'paquete', 9.00, 10.00, NULL, 0, 'USD', 0.02, 0.25, 1.86, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (223, 1, 4, 'TOALLAS AZULES', NULL, NULL, NULL, NULL, 'paquete', 30.00, 10.00, NULL, 0, 'USD', 1.34, 1.70, 1.70, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (224, 1, 1, 'TOALLAS MORADAS', NULL, NULL, NULL, NULL, 'paquete', 30.00, 10.00, NULL, 1, 'USD', 0.98, 1.40, 1.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (225, 1, 19, 'JABÓN ESPECIAL', NULL, NULL, NULL, NULL, 'paquete', 50.00, 10.00, NULL, 0, 'USD', 0.80, 1.20, 1.20, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (226, 1, 4, 'JABÓN POPULAR', NULL, NULL, NULL, NULL, 'paquete', 72.00, 9.00, NULL, 0, 'USD', 0.80, 1.30, 1.30, '2026-01-27 18:05:01', '2026-02-06 14:46:55', 0, 0, NULL);
INSERT INTO `productos` VALUES (227, 1, 9, 'JABÓN LAS LLAVES', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.17, 1.30, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (228, 1, 3, 'JABÓN DE AVENA', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 0.54, 0.60, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (229, 1, 4, 'JABÓN HUGME', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.59, 0.65, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (231, 1, 4, 'JABÓN LAK', NULL, NULL, NULL, NULL, 'paquete', 4.00, 10.00, NULL, 0, 'USD', 1.03, 1.50, 1.50, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (232, 1, 4, 'GELATINA CABELLO PEQ', NULL, NULL, NULL, NULL, 'paquete', 24.00, 10.00, NULL, 0, 'USD', 1.83, 2.40, 2.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (233, 1, 1, 'ACE ALIVE 1KG', NULL, '', NULL, '', 'unidad', 12.00, 9.00, NULL, 1, 'USD', 3.25, 4.23, 50.76, '2026-01-27 18:05:01', '2026-02-06 15:23:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (234, 1, 1, 'ACE ALIVE 500GRS', NULL, '', NULL, '7597597003017', 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.63, 2.15, 0.00, '2026-01-27 18:05:01', '2026-02-06 03:28:06', 0, 0, NULL);
INSERT INTO `productos` VALUES (235, 1, 1, 'ACE OSO BLANCO 400GRS', NULL, '', NULL, '6904542109563', 'unidad', 20.00, 10.00, NULL, 0, 'USD', 1.40, 1.82, 1.82, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (236, 1, 4, 'SUAVITEL', NULL, NULL, NULL, NULL, 'paquete', 12.00, 10.00, NULL, 1, 'USD', 0.66, 0.86, 0.86, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (237, 1, 4, 'CLORO LOFO 1LT', NULL, NULL, NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 1.00, 1.30, 1.30, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (238, 1, 4, 'AFEITADORA', NULL, '', NULL, '6950769302133', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.53, 0.75, 0.75, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (239, 1, 4, 'HOJILLAS', NULL, NULL, NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 0.60, 1.00, 1.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (240, 1, 20, 'LECHE 1LT LOS ANDES', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.94, 2.15, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (285, 1, 1, 'APUREÑITO', NULL, NULL, NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 0.49, 0.75, 0.75, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (242, 1, 1, 'YESQUERO', NULL, '', NULL, '7703562035369', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.36, 0.40, 0.00, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (243, 1, NULL, 'TRIDENT INDIVIDUAL', NULL, NULL, NULL, NULL, 'paquete', 60.00, 10.00, NULL, 0, 'USD', 0.09, 0.15, 0.15, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (245, 1, 3, 'ATUN RICA DELI', NULL, '', NULL, '7591072002403', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.45, 2.94, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (246, 1, 3, 'SALSA PASTA UW 190GR', NULL, '', NULL, '7591072000263', 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.35, 1.70, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (247, 1, 3, 'SORBETICO PEQ', NULL, '', NULL, '7590011227105', 'unidad', 4.00, 10.00, NULL, 0, 'USD', 0.27, 0.40, 1.35, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (248, 1, 3, 'SORBETICO WAFER', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.17, 1.52, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (249, 1, 3, 'TANG', NULL, '', NULL, NULL, 'paquete', 15.00, 9.00, NULL, 0, 'USD', 0.43, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-05 20:21:59', 0, 0, NULL);
INSERT INTO `productos` VALUES (250, 1, 3, 'CHICLE FREEGELLS', NULL, '', NULL, '7891151031189', 'unidad', 15.00, 10.00, NULL, 0, 'USD', 0.24, 0.40, 0.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (251, 1, 3, 'CHICLE TATTOO', NULL, NULL, NULL, NULL, 'paquete', 90.00, 10.00, NULL, 0, 'USD', 0.03, 0.07, 0.07, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (254, 1, 3, 'GALLETA MARIA MINI', NULL, '', NULL, '7592809000761', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.50, 0.70, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (256, 1, 1, 'COCO CRUCH', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.08, 1.20, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (257, 1, 16, 'CHEESE TRIS G', NULL, '', NULL, '7591206000381', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.66, 2.16, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (258, 1, 11, 'BOLI KRUNCH G', NULL, '', NULL, '7592708000343', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.85, 1.25, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (259, 1, 11, 'KESITOS G', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.89, 1.25, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (262, 1, 21, 'CHAKARO GDE', NULL, NULL, NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 0.67, 0.90, 0.90, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (261, 1, 22, 'DESINFECTANTE', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.78, 1.20, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (263, 1, 21, 'MANDADOR', NULL, NULL, NULL, NULL, 'paquete', 12.00, 10.00, NULL, 1, 'USD', 0.75, 1.00, 1.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (264, 1, 4, 'CHUPETA', NULL, NULL, NULL, NULL, 'paquete', 46.00, 9.00, NULL, 1, 'USD', 0.13, 0.20, 0.20, '2026-01-27 18:05:01', '2026-02-05 22:17:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (265, 1, 18, 'SALCHICHAS', NULL, NULL, NULL, NULL, 'kg', 1.00, 10.00, NULL, 0, 'USD', 4.05, 5.30, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (266, 1, 22, 'CLORO AAA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.53, 1.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (267, 1, 22, 'LAVAPLATOS AAA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.81, 2.35, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (268, 1, 22, 'LAVAPLATOS AA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.38, 1.80, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (269, 1, 22, 'CLORO AA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.48, 0.80, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (270, 1, 22, 'CERA BLANCA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.87, 1.13, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (271, 1, 22, 'SUAVIZANTE', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.12, 1.65, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (272, 1, 22, 'DESENGRASANTE AAA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.51, 2.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (329, 1, 17, 'BOMBILLO LED 20W', NULL, '', NULL, '6935787900165', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.86, 2.33, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (273, 1, 3, 'MARSHMALLOWS 100GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.02, 1.30, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (274, 1, 3, 'HUEVITO SORPRESA', NULL, NULL, NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 0.49, 0.70, 0.70, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (276, 1, 4, 'GALLETA SODA EL SOL', NULL, NULL, NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 0.16, 0.25, 2.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (277, 1, 4, 'YOKOIMA 50GR', NULL, NULL, NULL, NULL, 'paquete', 20.00, 10.00, NULL, 0, 'USD', 0.63, 0.81, 0.81, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (279, 1, 1, 'TIGRITO', NULL, NULL, NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 0.49, 0.75, 0.75, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (280, 1, 5, 'PLAQUITAS', NULL, NULL, NULL, NULL, 'paquete', 15.00, 10.00, NULL, 1, 'USD', 0.12, 0.17, 0.17, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (282, 1, 11, 'KETCHUP CAPRI 198GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.13, 1.41, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (284, 1, 9, 'ATUN MARGARITA', NULL, NULL, NULL, NULL, 'paquete', 35.00, 10.00, NULL, 1, 'USD', 1.90, 2.38, 2.38, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (287, 1, 1, 'HOJA EXAMEN', NULL, NULL, NULL, NULL, 'paquete', 50.00, 10.00, NULL, 1, 'USD', 0.05, 0.10, 0.10, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (288, 1, 3, 'BOMBONES CORAZON', NULL, '', NULL, '', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.65, 2.15, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (289, 1, 3, 'BOMBONES ROSA', NULL, '', NULL, '745853860783', 'unidad', 1.00, 10.00, NULL, 1, 'USD', 3.18, 3.90, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (290, 1, 3, 'NUCITA CRUNCH JR', NULL, NULL, NULL, NULL, 'paquete', 6.00, 10.00, NULL, 1, 'USD', 0.40, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (291, 1, 3, 'YOYO NEON', NULL, '', NULL, '659525562250', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.86, 1.15, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (292, 1, 3, 'GUSANITO LOCO', NULL, NULL, NULL, NULL, 'unidad', 30.00, 10.00, NULL, 0, 'USD', 0.66, 0.86, 25.80, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (293, 1, 3, 'ACONDICIONADOR SEDAL', NULL, '', NULL, '7702006207690', 'unidad', 12.00, 10.00, NULL, 1, 'USD', 0.34, 0.50, 0.50, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (294, 1, 18, 'JAMÓN', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.60, 2.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (295, 1, 18, 'QUESO AMARILLO', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.60, 2.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (296, 1, 16, 'RAQUETY G', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.83, 1.10, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (297, 1, 11, 'PAPEL AMARILLO 600', NULL, NULL, NULL, NULL, 'paquete', 4.00, 10.00, NULL, 0, 'USD', 1.00, 1.40, 5.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (298, 1, 3, 'COLORETI MINI', NULL, '', NULL, '7896383000033', 'unidad', 36.00, 10.00, NULL, 0, 'USD', 0.11, 0.20, 0.20, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (299, 1, 3, 'MENTITAS AMBROSOLI', NULL, NULL, NULL, NULL, 'paquete', 24.00, 10.00, NULL, 0, 'USD', 0.48, 0.70, 0.70, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (310, 1, 4, 'CARAMELOS', NULL, NULL, NULL, NULL, 'paquete', 100.00, 10.00, NULL, 0, 'USD', 0.03, 0.05, 0.05, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (301, 1, 8, 'BARQUILLON', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.00, 1.40, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (302, 1, 23, 'PALETA FRESH LIMON', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.28, 0.40, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (303, 1, 23, 'PALETA PASION YOGURT', NULL, NULL, NULL, NULL, 'unidad', 9.00, 10.00, NULL, 0, 'USD', 0.35, 0.50, 4.50, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (304, 1, 23, 'PALETA EXOTICO', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.35, 0.50, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (305, 1, 23, 'BARQUILLA SUPER CONO', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.82, 1.10, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (306, 1, 23, 'POLET FERRERO ROCHER', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.36, 2.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (307, 1, 23, 'POLET TRIPLE CAPITA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.36, 2.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (308, 1, 23, 'POLET TRIPLE CAPITA COCO', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.36, 2.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (309, 1, 23, 'MAXI SANDWICH', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.82, 1.10, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (311, 1, 9, 'RIKESA 200GR', NULL, '', NULL, '75971939', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.47, 4.20, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (312, 1, 11, 'PAPEL ROJO 180', NULL, NULL, NULL, NULL, 'paquete', 4.00, 6.00, NULL, 0, 'USD', 0.29, 0.50, 1.48, '2026-01-27 18:05:01', '2026-02-04 23:32:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (313, 1, 11, 'PAPEL VERDE 215', NULL, NULL, NULL, NULL, 'paquete', 4.00, 10.00, NULL, 0, 'USD', 0.31, 0.60, 1.85, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (314, 1, 11, 'PAPEL MARRÓN 300', NULL, NULL, NULL, NULL, 'paquete', 4.00, 10.00, NULL, 0, 'USD', 0.60, 0.90, 3.10, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (315, 1, 15, 'CAFÉ NONNA 100GR', NULL, NULL, NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 1.30, 1.63, 1.63, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (316, 1, 11, 'LENTEJA PANTERA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.72, 2.10, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (336, 1, 3, 'MINI MARILU TUBO 100GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.07, 1.39, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (318, 1, 10, 'MAYONESA TITA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.62, 1.94, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (319, 1, 3, 'BOMBONES BEL', NULL, NULL, NULL, NULL, 'paquete', 50.00, 10.00, NULL, 0, 'USD', 0.08, 0.10, 0.10, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (338, 1, 3, 'ELITE VAINI TUBO 100GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.82, 1.07, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (323, 1, 3, 'MARILU TUBO 240GR', NULL, '', NULL, '7591082014007', 'unidad', 6.00, 10.00, NULL, 0, 'USD', 0.32, 0.50, 2.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (324, 1, 3, 'CARAMELO MIEL', NULL, NULL, NULL, NULL, 'paquete', 100.00, 10.00, NULL, 1, 'USD', 0.02, 0.05, 0.05, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (325, 1, 3, 'NUTTELINI', NULL, '', NULL, '7702011115232', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.29, 0.45, 0.45, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (330, 1, 10, 'CEPILLO DENTAL COLGATE NIÑO', NULL, '', NULL, '7509546074122', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.23, 1.60, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (327, 1, 11, 'BARRILETE', NULL, NULL, NULL, NULL, 'paquete', 50.00, 10.00, NULL, 0, 'USD', 0.06, 0.80, 0.80, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (328, 1, 1, 'FRUTYS', NULL, NULL, NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 1.04, 1.40, 1.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (341, 1, 3, 'GALLE MARILU CAJA', NULL, '', NULL, '7591082010221', 'unidad', 24.00, 10.00, NULL, 0, 'USD', 0.19, 0.30, 0.30, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (332, 1, 11, 'ACEITE COPOSA 850ML', NULL, '', NULL, '7591058001024', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.92, 4.90, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (331, 1, 10, 'JABÓN PROTEX 75GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.28, 1.66, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (333, 1, 24, 'RECARGA MOVISTAR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 8.00, NULL, 0, 'BS', 150.00, 190.00, NULL, '2026-01-27 18:05:01', '2026-02-05 20:21:59', 0, 0, NULL);
INSERT INTO `productos` VALUES (334, 1, 24, 'RECARGA DIGITEL', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'BS', 160.00, 200.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (335, 1, 24, 'RECARGA MOVILNET', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 150.00, 185.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (340, 1, 3, 'GALLETA BROWNIE 175GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.55, 2.02, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (342, 1, 3, 'GALLE Q-KISS 200GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.63, 3.16, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (343, 1, 3, 'GALLETA REX 200GR', NULL, '', NULL, '7591082000574', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.26, 1.60, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (344, 1, 3, 'GALLETA LIMON 77GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.64, 0.83, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (345, 1, 3, 'GALLETA LIMON 90GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.88, 1.14, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (347, 1, 3, 'CHUPA POP SURTIDO', NULL, NULL, NULL, NULL, 'paquete', 24.00, 10.00, NULL, 0, 'USD', 0.13, 0.20, 0.20, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (348, 1, 3, 'TATTOO CHUPETA', NULL, NULL, NULL, NULL, 'paquete', 50.00, 10.00, NULL, 0, 'USD', 0.06, 0.10, 0.10, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (350, 1, 1, 'CREMA ALIDENT', NULL, '', NULL, '7597257001650', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 1.50, 1.95, 1.95, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (356, 1, 18, 'J. espalda con todo', NULL, '', NULL, '100400001567', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 6.12, 6.80, 0.00, '2026-01-29 21:17:36', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (355, 1, 18, 'Carne Molida', NULL, '', NULL, '103004004392', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 7.20, 8.00, 0.00, '2026-01-29 21:15:48', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (357, 1, 18, 'q. amarillo ortiz', NULL, '', NULL, '121002001748', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.57, 1.74, 0.00, '2026-01-29 21:18:19', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (359, 1, 27, 'prueba', NULL, '', NULL, 'https://consultaqr.seniat.gob.ve/qr/459f8f1a-0f15-454a-b3df-1bddcf9638f4', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 4.50, 5.00, 0.00, '2026-02-02 12:52:17', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (370, 2, NULL, 'ACEITE 20W50 4T', 'A001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 21.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:05', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (371, 2, NULL, 'ACEITE 20W50 GRANEL', 'A002', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:06', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (372, 2, NULL, 'ACEITE 50 GRANEL', 'A003', NULL, 'ROYAL', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:06', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (373, 2, NULL, 'ACEITE 2T 1X50 POTE GRIS ', 'A004', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:06', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (374, 2, NULL, 'ACEITE MOBIL', 'A005', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:07', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (375, 2, NULL, 'ACEITE ROMO', 'A006', NULL, 'ROMO', NULL, 'unidad', 1.00, 12.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:07', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (376, 2, NULL, 'ACEITE MOTUL 3000', 'A007', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:07', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (377, 2, NULL, 'ACEITE MULTILUB', 'A008', NULL, 'ROMO', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:08', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (378, 2, NULL, 'ACEITE BENZOL  PARA CARRO', 'A009', NULL, 'BENZOL', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:08', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (379, 2, NULL, 'ACEITE SKY 2T', 'A010', NULL, 'SKY', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:08', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (380, 2, NULL, 'ACEITE SKY', 'A011', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:09', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (381, 2, NULL, 'ACEITE MOTUL 5100', 'A012', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:09', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (382, 2, NULL, 'ACEITE SHELL ACEITE', 'A013', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:09', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (383, 2, NULL, 'ACEITE SPORT 2 T (AGUA)', 'A014', NULL, 'SUPREMO', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:10', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (384, 2, NULL, 'AMORTIGUADOR FUCSIA SBR', 'A015', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:10', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (385, 2, NULL, 'AMORTIGUADOR ROJO SBR', 'A016', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:10', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (386, 2, NULL, 'AMORTIGUADOR AZUL SBR', 'A017', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:11', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (387, 2, NULL, 'AMORTIGUADOR SOCIAL NEGRO', 'A018', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:11', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (388, 2, NULL, 'AMORTIGUADOR EK SPRESS', 'A019', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:11', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (389, 2, NULL, 'AMORTIGUADOR HORSE', 'A020', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:12', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (390, 2, NULL, 'AMORTIGUADOR MORADO SBR', 'A021', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:12', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (391, 2, NULL, 'ANILLO A 150 0,75', 'A022', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:12', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (392, 2, NULL, 'ANILLO A-150 1,00', 'A023', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:13', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (393, 2, NULL, 'ANILLO A-150 0.50', 'A024', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:13', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (394, 2, NULL, 'ANILLO CG150 STD', 'A025', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:13', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (395, 2, NULL, 'ANILLO GRUESO DE LATA DORADO', 'A026', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:14', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (396, 2, NULL, 'ANILLO HORSE  STD', 'A027', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:14', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (397, 2, NULL, 'ANTIEPICHE CON ESPUMA ', 'A028', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:14', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (398, 2, NULL, 'ANTIEPICHE DE ESPUMA DE LATA ', 'A029', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:15', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (399, 2, NULL, 'ANTIESPICHE 500ML ', 'A030', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:15', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (400, 2, NULL, 'ANTIESPICHE 500ML ', 'A031', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:15', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (401, 2, NULL, 'ARANDELA DE TUBO DE ESCAPE BRONCE', 'A032', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 53.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:15', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (402, 2, NULL, 'ARBOL DE LEVA GN125', 'A033', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:16', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (403, 2, NULL, 'ARBOL DE LEVA GN125', 'A034', NULL, 'SAGA', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:16', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (404, 2, NULL, 'ARBOL DE LEVA OWEN GS125 CONTRA PESO 125', 'A035', NULL, 'SPEED', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:16', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (405, 2, NULL, 'ARRANQUE 200', 'A036', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:17', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (406, 2, NULL, 'ARRANQUE EXPRESS', 'A037', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:17', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (407, 2, NULL, 'ARRANQUE GN 125', 'A038', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:17', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (408, 2, NULL, 'ARRANQUE SBR', 'A039', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:18', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (409, 2, NULL, 'ARRANQUE SBR', 'A040', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:18', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (410, 2, NULL, 'ASIENTO SBR', 'A041', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:18', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (411, 2, NULL, 'ASIENTO GN125', 'A042', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:19', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (412, 2, NULL, 'AUTOMATICO CG150 ', 'A043', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:19', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (413, 2, NULL, 'AUTOMATICO GN 125', 'A044', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:19', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (414, 2, NULL, 'AUTOMATICO H-150', 'A045', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:20', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (415, 2, NULL, 'AUTOMATICO HORSE', 'A046', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:20', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (416, 2, NULL, 'AVISOS DE MOTOTAXIS', 'A047', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:20', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (417, 2, NULL, 'ARBOL DE LEVA CG150 REFORZADO', 'A048', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:21', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (418, 2, NULL, 'ARBOL DE LEVA CG150  ', 'A049', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:21', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (419, 2, NULL, 'ANILLO H-150 STD', 'A050', NULL, 'BENF', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:21', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (420, 2, NULL, 'ANILLO CG150 STD', 'A051', NULL, 'BENF', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:22', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (421, 2, NULL, 'ACEITE ROYAL 20W50 DE CARRO', 'A052', NULL, 'ROYAL', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:22', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (422, 2, NULL, 'ACEITE ROYAL 4 T 20W50', 'A053', NULL, 'ROYAL', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:22', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (423, 2, NULL, 'ACEITE LUBREX', 'A054', NULL, 'MOBIL', NULL, 'unidad', 1.00, 12.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:23', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (424, 2, NULL, 'ANTI ESPICHE ROMO', 'A055', NULL, 'ROMO', NULL, 'unidad', 1.00, 29.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:23', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (425, 2, NULL, 'AMORTIGUADOR DE XPRESS', 'A056', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:23', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (426, 2, NULL, 'AMORTIGUADOR DE HORSE', 'A057', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:24', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (427, 2, NULL, 'ANILLO H-150 STD', 'A058', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:24', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (428, 2, NULL, 'ANILLO CG150 STD', 'A059', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 19.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:24', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (429, 2, NULL, 'ARBOL LEVA CG150', 'A060', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 9.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:25', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (430, 2, NULL, 'ACEITE MINERAL 1X50  2T', 'A061', NULL, 'BENF', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:25', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (431, 2, NULL, 'ANTIESPICHE 340ML ', 'A062', NULL, 'JERET', NULL, 'unidad', 1.00, 13.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:25', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (432, 2, NULL, 'AUTOMATICO CG150 ', 'A063', NULL, 'BENF', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:26', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (433, 2, NULL, 'ACEITE BENZOL 4 T', 'A064', NULL, 'BENZOL', NULL, 'unidad', 1.00, 9.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:26', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (434, 2, NULL, 'ANILLO H-150 STD', 'A065', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:26', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (435, 2, NULL, 'ACEITE 20W50 CARRO', 'A066', NULL, 'SPEED7', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:27', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (436, 2, NULL, 'ACEITE SAE60', 'A067', NULL, 'ROYAL', NULL, 'unidad', 1.00, 10.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:27', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (437, 2, NULL, 'ACEITE HIDRAULICO ATF', 'A068', NULL, 'MOGULF', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:27', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (438, 2, NULL, 'ACEITE HIDRAULICO A GRANEL', 'A069', NULL, '', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:28', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (439, 2, NULL, 'AMORTIGUADOR GN', 'A070', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:28', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (440, 2, 28, 'aceite 2 t pote TRASPARENTE', NULL, '', NULL, '', 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 1.00, 0.00, '2026-02-06 03:53:28', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (441, 2, NULL, 'ANTI ESPICHE BSN 350 ML', 'A072', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:29', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (442, 2, NULL, 'ANILLO STD EXPRESS ', 'A073', NULL, 'MOTO SONYC', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:29', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (443, 2, NULL, 'ANILLO STD SBR', 'A074', NULL, 'MOTO SONYC', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:29', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (444, 2, NULL, 'BALANCINE CG150', 'B001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:29', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (445, 2, NULL, 'BALANCINES H-150 CORTO', 'B002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:30', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (446, 2, NULL, 'BANDA DE FRENO GN125', 'B003', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 16.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:30', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (447, 2, NULL, 'BANDA FRENO DE RAYO', 'B004', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 15.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:30', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (448, 2, NULL, 'BANDA FRENO H-150 RALLADA ', 'B005', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:31', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (449, 2, NULL, 'BARRA DE POZA PIE EK', 'B006', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:31', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (450, 2, NULL, 'BARRA DE POZA PIE COMPLETA H-150', 'B007', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:31', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (451, 2, NULL, 'BARRA DE POZA PIE COMPLETA CG150', 'B008', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:32', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (452, 2, NULL, 'BASE CARBURADOR ALUMINIO CG150 (MANIFOR)', 'B009', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:32', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (453, 2, NULL, 'BASE GUARDAFANGO SBR', 'B011', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:32', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (454, 2, NULL, 'BASE GUARDAFANGO CG150', 'B012', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:33', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (455, 2, NULL, 'BASE GUARDAFANGO H-150 AC', 'B013', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:33', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (456, 2, NULL, 'BASE PATA DE ARRANQUE', 'B014', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 9.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:33', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (457, 2, NULL, 'BASE DE FARO A150', 'B015', NULL, 'BENF', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:34', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (458, 2, NULL, 'BASE PURIFICACION CG150 NEGRO', 'B016', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:34', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (459, 2, NULL, 'BASE TUBO DE ESCAPE', 'B017', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:34', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (460, 2, NULL, 'BASE DE CRUCE', 'B018', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:35', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (461, 2, NULL, 'BASE TUBO DE ESCAPE', 'B019', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:35', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (462, 2, NULL, 'BATERIA 12N6,5', 'B020', NULL, 'BENF', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:35', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (463, 2, NULL, 'BATERIA 12N6,5', 'B021', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:36', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (464, 2, NULL, 'BATERIA 12N6,5', 'B022', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:36', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (465, 2, NULL, 'BOMBILLO SBR ', 'B023', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:36', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (466, 2, NULL, 'BOBINA CG150', 'B024', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 11.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:37', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (467, 2, NULL, 'BOBINA CG150', 'B025', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:37', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (468, 2, NULL, 'BOBINA CG150 RAGCIN', 'B026', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:37', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (469, 2, NULL, 'BOLSAS DE ASIENTO', 'B027', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 15.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:38', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (470, 2, NULL, 'BOMBA DE ACEITE GN125', 'B028', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:38', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (471, 2, NULL, 'BOMBA DE ACEITE HORSE 150', 'B029', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:38', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (472, 2, NULL, 'BOMBA DE ACEITE SBR', 'B030', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:39', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (473, 2, NULL, 'BOMBA AIRE NEGRA SENCILLA', 'B031', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:39', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (474, 2, NULL, 'BOMBA AIRE DE PEDAL DE BICI', 'B032', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:39', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (475, 2, NULL, 'BOMBA AIRE DE MOTO DE PEDAL', 'B033', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:40', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (476, 2, NULL, 'BOMBINA C/PIPA', 'B034', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:40', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (477, 2, NULL, 'BOMBA FRENO DE ESCUTER ENVASE', 'B035', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:40', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (478, 2, NULL, 'BUJE DE AMORTIGUADOR', 'B036', NULL, 'BENF', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:41', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (479, 2, NULL, 'BUJIA DE DESMALEZADORA', 'B037', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:41', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (480, 2, NULL, 'BOMBILLO 2 CONTACTO ', 'B038', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:41', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (481, 2, NULL, 'BOMBILLO CABEZON 12/V', 'B039', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:42', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (482, 2, NULL, 'BOMBILLO DE FARO CUADRADO 9 LED', 'B040', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:42', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (483, 2, NULL, 'BOMBILLO 2 CONTACTOS', 'B041', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:42', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (484, 2, NULL, 'BOMBILLO MUELITA', 'B042', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 12.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:43', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (485, 2, NULL, 'BUJE AMORTIGUADOR', 'B043', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 11.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:43', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (486, 2, NULL, 'BUJE DE MANZANA DE HIERRO', 'B044', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:43', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (487, 2, NULL, 'BUJE DE MANZANA PLASTICO ', 'B045', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:44', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (488, 2, NULL, 'BUJE HORQUILLA OWEN', 'B046', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:44', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (489, 2, NULL, 'BUJE HORQUILLA DE CG150', 'B047', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 21.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:44', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (490, 2, NULL, 'BUJE HORQUILLA DE HORSE', 'B048', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 24.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:44', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (491, 2, NULL, 'BUJIA NORMAL ', 'B049', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:45', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (492, 2, NULL, 'BUJIA A7TC GY6', 'B050', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:45', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (493, 2, NULL, 'BUJIA 3 patas', 'B051', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 43.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:45', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (494, 2, NULL, 'BUJIA D8TC PUNTA DIAMANTE', 'B052', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 28.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:46', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (495, 2, NULL, 'BUJIA NORMAL', 'B053', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 40.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:46', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (496, 2, NULL, 'BURRO H-150', 'B054', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:46', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (497, 2, NULL, 'BURRO CG150', 'B055', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:47', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (498, 2, NULL, 'BATERIA DE ACIDO 12N7', 'B056', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:47', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (499, 2, NULL, 'BASE DE TUBO DE ESCAPE', 'B057', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:47', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (500, 2, NULL, 'BASE DE CARBURADOR CG150', 'B058', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:48', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (501, 2, NULL, 'BOBINA CG150', 'B059', NULL, 'BENF', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:48', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (502, 2, NULL, 'BATERIA 12N9', 'B060', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:48', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (503, 2, NULL, 'BATERIA 12N7', 'B061', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:49', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (504, 2, NULL, 'BASE DE MOTOR', 'B062', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:49', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (505, 2, NULL, 'BOMBILLO 3 PATAS', 'B063', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:49', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (506, 2, NULL, 'BANDA DE FRENO GN125', 'B064', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 12.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:50', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (507, 2, NULL, 'BANDA DE FRENO H-150', 'B065', NULL, 'MOTO SONYC', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:50', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (508, 2, NULL, 'BARRA DE POSA PIE CG150', 'B066', NULL, 'MOTO SONYC', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:50', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (509, 2, NULL, 'BARRA DE POSA PIE SBR', 'B067', NULL, 'MOTO SONYC', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:51', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (510, 2, NULL, 'CADENA DORADA REFORZADA', 'C001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:51', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (511, 2, NULL, 'CADENA NERGRA REFORZADA ', 'C002', NULL, 'BENF', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:51', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (512, 2, NULL, 'CADENA ORRIN ', 'C003', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:52', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (513, 2, NULL, 'CAMARA', 'C004', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:52', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (514, 2, NULL, 'CAMARA COMPLETA', 'C005', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:52', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (515, 2, NULL, 'CAMPANA 200 70T', 'C006', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:53', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (516, 2, NULL, 'CAMPANA 70 T', 'C007', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:53', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (517, 2, NULL, 'CAMPANA 73 T', 'C008', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:53', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (518, 2, NULL, 'CAMPANA 200 73T', 'C009', NULL, 'MOTO SONIC ', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:54', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (519, 2, NULL, 'CARBONERA HORSE H-150', 'C010', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:54', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (520, 2, NULL, 'CARBONERA CG150', 'C011', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:54', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (521, 2, NULL, 'CARBURADOR TORNAZOL', 'C012', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:55', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (522, 2, NULL, 'CARBURADOR PZ27', 'C013', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:55', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (523, 2, NULL, 'CARBURADOR PZ27', 'C014', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:55', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (524, 2, NULL, 'CARBURADOR PZ26', 'C015', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:56', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (525, 2, NULL, 'CARCASA DE TACOMETRO SBR', 'C016', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:56', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (526, 2, NULL, 'CARCASA FARO MD', 'C017', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:56', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (527, 2, NULL, 'CARCASA TACOMETRO A-150 3PZ', 'C018', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:57', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (528, 2, NULL, 'CARCASA TACOMETRO H-150', 'C019', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:57', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (529, 2, NULL, 'CARCASA TACOMETRO SOCIALISTA', 'C020', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:57', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (530, 2, NULL, 'CARCASA TACOMETRO SOCIALISTA', 'C021', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:58', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (531, 2, NULL, 'CAREVACA H-150', 'C022', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:58', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (532, 2, NULL, 'CARGADOR USB', 'C023', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:58', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (533, 2, NULL, 'CARGADOR DE BATERIA', 'C024', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:59', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (534, 2, NULL, 'CASCOS SANDOVAL', 'C025', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:59', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (535, 2, NULL, 'CASCOS SEMI INTEGRALES SPORT', 'C026', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:53:59', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (536, 2, NULL, 'CAUCHO 90/90/18 509', 'C027', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:00', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (537, 2, NULL, 'CAUCHO 90/90/18 342', 'C028', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:00', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (538, 2, NULL, 'CAUCHO 410/18 ', 'C029', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:00', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (539, 2, NULL, 'CAUCHO 300/18 CZ818', 'C030', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:00', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (540, 2, NULL, 'CAUCHO 275/18 MZ518', 'C031', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:01', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (541, 2, NULL, 'CAUCHO 275/18 MZ517', 'C032', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:01', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (542, 2, NULL, 'CAUCHO 275/18 MZ240', 'C033', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:01', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (543, 2, NULL, 'CAUCHO 300/18 808', 'C034', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:02', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (544, 2, NULL, 'CAUCHO 300/18 801', 'C035', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:02', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (545, 2, NULL, 'CAUCHO 90/90/18 665', 'C036', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:02', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (546, 2, NULL, 'CAUCHO 90/90/18 663', 'C037', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:03', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (547, 2, NULL, 'CALCOMANIA DE RIN', 'C038', NULL, 'MOTO soNIC', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:03', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (548, 2, NULL, 'CDI CG150', 'C039', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:03', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (549, 2, NULL, 'CDI CG150', 'C040', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:04', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (550, 2, NULL, 'CDI HORSE 150', 'C041', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 15.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:04', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (551, 2, NULL, 'CDI HORSE 150', 'C042', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 13.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:04', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (552, 2, NULL, 'CDI H150', 'C043', NULL, 'BENF', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:05', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (553, 2, NULL, 'CADENA DE ACEITE TX200', 'C044', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:05', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (554, 2, NULL, 'CHAPALETA PROTAPAER VARIADO', 'C045', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:05', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (555, 2, NULL, 'CHARQUERA (GUARDABARRO UNIVERSAL)', 'C046', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:06', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (556, 2, NULL, 'CIGuEÑAL 150 HORSE', 'C047', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:06', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (557, 2, NULL, 'CILINDRO CG150', 'C048', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:06', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (558, 2, NULL, 'CILINDRO OWEN', 'C049', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:07', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (559, 2, NULL, 'CILINDRO PLATEADO CG150', 'C050', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:07', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (560, 2, NULL, 'COLA DE HORSE 1', 'C051', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:07', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (561, 2, NULL, 'COLA DE PLASTICO DE HORSE TRASERO', 'C052', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:08', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (562, 2, NULL, 'COLA DE PLASTICO DE SBR (DELANTERO)', 'C053', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:08', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (563, 2, NULL, 'COLA DE PLASTICO DE SBR (TRASERA)', 'C054', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 18.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:08', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (564, 2, NULL, 'COLA GUARDABARRO AMARILLO SOCIAL', 'C055', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:09', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (565, 2, NULL, 'COLA PEQUEÑA H-150 AZUL ', 'C056', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:09', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (566, 2, NULL, 'CONCHA DE ESCAPE CG150 8MM', 'C057', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:09', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (567, 2, NULL, 'CONECTORES CG150', 'C058', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:10', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (568, 2, NULL, 'CONECTORES DE HORSE', 'C059', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:10', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (569, 2, NULL, 'CORNETA SBR ', 'C060', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:10', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (570, 2, NULL, 'COPA DE ACEITE HORSE', 'C061', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:11', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (571, 2, NULL, 'COPA DE ACEITE HORSE', 'C062', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:11', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (572, 2, NULL, 'COPA DE ACEITE CG150', 'C063', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:11', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (573, 2, NULL, 'CORNETA  SBR', 'C064', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:12', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (574, 2, NULL, 'CORNETA DE HORSE', 'C065', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:12', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (575, 2, NULL, 'CORONA DE PALETA PLATEADA 35 T', 'C066', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:12', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (576, 2, NULL, 'CORONA DE PALETA PLATEADA 35 T', 'C067', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:13', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (577, 2, NULL, 'CORONA DE PALETA PLATEADA 36 T', 'C068', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 14.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:13', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (578, 2, NULL, 'CORONA DE PALETA PLATEADA 36 T', 'C069', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 13.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:13', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (579, 2, NULL, 'CORONA DE PALETA PLATEADA 37 T', 'C070', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:14', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (580, 2, NULL, 'CORONA DE PALETA DORADA 37T EK HORSE', 'C071', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:14', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (581, 2, NULL, 'CORONA DE PALETA 1', 'C072', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:14', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (582, 2, NULL, 'CORONA DE PALETA PLATEADA 35T MD-AGUILA', 'C073', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 11.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:15', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (583, 2, NULL, 'CORONA DE PALETA PLATEADA 36T MD-AGUILA', 'C074', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:15', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (584, 2, NULL, 'CORONA DE PALETA PLATEADA 37T MD-AGUILA', 'C075', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 13.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:15', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (585, 2, NULL, 'CORONA DE PALETA PLATEADA 38T MD-AGUILA', 'C076', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:15', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (586, 2, NULL, 'CORONA DE PALETA PLATEADA 38T GN', 'C077', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:16', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (587, 2, NULL, 'CORONA DE PALETA PLATEADA 40T GN', 'C078', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:16', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (588, 2, NULL, 'CORONA DE PALETA PLATEADA 41T GN', 'C079', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:16', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (589, 2, NULL, 'CORONA DE PALETA PLATEADA 43T GN', 'C080', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:17', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (590, 2, NULL, 'CORONA DE PALETA PLATEADA 45T GN', 'C081', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:17', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (591, 2, NULL, 'CORONA DE RAYO PLATEADA 36T', 'C082', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:17', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (592, 2, NULL, 'CORONA DE RAYO PLATEADA 35T', 'C083', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:18', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (593, 2, NULL, 'CORONA DORADA DE RAYO 37T', 'C084', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:18', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (594, 2, NULL, 'CORONA DORADA DE RAYO 39T', 'C085', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:18', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (595, 2, NULL, 'CORONA PALETA DORADA GN-35T', 'C086', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:19', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (596, 2, NULL, 'CORONA RAYO DORADA 35T', 'C087', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 10.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:19', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (597, 2, NULL, 'CORONA RAYO DORADA 36T', 'C088', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:19', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (598, 2, NULL, 'CORONA RAYO DORADA 37T', 'C089', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 13.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:20', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (599, 2, NULL, 'CORONA PALETRA DORADA GN-38T', 'C090', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:20', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (600, 2, NULL, 'CORONA PALETRA DORADA GN-39T', 'C091', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, -1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:20', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (601, 2, NULL, 'CORONA PALETRA DORADA GN-42T', 'C092', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, -1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:21', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (602, 2, NULL, 'CORONA PALETRA DORADA GN-43T', 'C093', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:21', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (603, 2, NULL, 'CORONA PALETRA DORADA 36T CURVA', 'C094', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:21', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (604, 2, NULL, 'CORONA PALETRA DORADA GN 36T', 'C095', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:22', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (605, 2, NULL, 'CORONA PALETRA DORADA GN 37T', 'C096', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:22', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (606, 2, NULL, 'CORONA PALETRA DORADA 37T CURVA', 'C097', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:22', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (607, 2, NULL, 'CORONA PALETRA DORADA 1', 'C098', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:23', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (608, 2, NULL, 'CORONA PALETA 1', 'C099', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:23', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (609, 2, NULL, 'CORREA DE BATERIA', 'C100', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:23', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (610, 2, NULL, 'CORTA CORRIENTE ', 'C101', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:24', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (611, 2, NULL, 'CREMALLERA 150 COMPLETA', 'C102', NULL, 'ZETA', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:24', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (612, 2, NULL, 'CREMALLERA 200 COMPLETA', 'C103', NULL, 'ZETA', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:24', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (613, 2, NULL, 'CREMALLERA CG150 COMPLETA', 'C104', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:25', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (614, 2, NULL, 'CREMALLERA  GN125 COMPLETA', 'C105', NULL, 'ZETA', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:25', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (615, 2, NULL, 'CREMALLERA SOLA', 'C106', NULL, 'ZETA', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:25', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (616, 2, NULL, 'CROCHERA COMPLETA 5 T', 'C107', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:26', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (617, 2, NULL, 'CUCHARA CG150', 'C108', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:26', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (618, 2, NULL, 'CUCHARA CG150', 'C109', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 9.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:26', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (619, 2, NULL, 'CUCHARA DE TX 200', 'C110', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:27', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (620, 2, NULL, 'CUENTA KILOMETRO GN125', 'C111', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:27', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (621, 2, NULL, 'CUENTA KILOMETRO H-150', 'C112', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:27', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (622, 2, NULL, 'CUENTA KILOMETRO SBR', 'C113', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 13.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:28', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (623, 2, NULL, 'CUENTA KILOMETRO EK-SPRESS', 'C114', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:28', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (624, 2, NULL, 'CAJA 150', 'C115', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:28', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (625, 2, NULL, 'CUENTA KILOMETRAJE A150', 'C116', NULL, 'BENF', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:29', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (626, 2, NULL, 'CILINDRO DE CG150', 'C117', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:29', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (627, 2, NULL, 'CILINDRO DE H-150', 'C118', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:29', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (628, 2, NULL, 'COPA DE ACEITE CG200', 'C119', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:30', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (629, 2, NULL, 'COPA DE ACEITE TX200', 'C120', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:30', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (630, 2, NULL, 'CAMARA SOLA A-150', 'C121', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:30', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (631, 2, NULL, 'cigUeñal A-150', 'C122', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:31', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (632, 2, NULL, 'CONCHA DE ESCAPE H-150 6MM', 'C123', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:31', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (633, 2, NULL, 'CAJA 200', 'C124', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:31', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (634, 2, NULL, 'CAñA DE XPRESS', 'C125', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:32', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (635, 2, NULL, 'cuÑa de valvula', 'C126', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:32', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (636, 2, NULL, 'CORNETA MP3', 'C127', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:32', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (637, 2, NULL, 'CABLE NEGRO DE BATERIA ', 'C128', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 20.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:32', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (638, 2, NULL, 'CABLE ROJO DE BATERIA ', 'C129', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 20.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:33', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (639, 2, NULL, 'CADENA REFORZADA NEGRA', 'C130', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:33', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (640, 2, NULL, 'CARBURADOR PZ30', 'C131', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:33', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (641, 2, NULL, 'CARCASA DE FARO SBR', 'C132', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:34', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (642, 2, NULL, 'CARCASA DE TACOMETRO DE XPRES', 'C133', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:34', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (643, 2, NULL, 'CASCO SEMI INTEGRAL 56 PROJECT ROJO', 'C134', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:34', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (644, 2, NULL, 'CASCO SEMI INTEGRAL 56 PROJECT NEGRO', 'C135', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:35', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (645, 2, NULL, 'CASCO SEMI INTEGRAL 56 PROJECT BLANCO', 'C136', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:35', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (646, 2, NULL, 'CASCO SEMI INTEGRAL 56 PROJECT AZUL', 'C137', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:35', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (647, 2, NULL, 'DISCO CROCHE  CG150 6PZ', 'D001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:36', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (648, 2, NULL, 'DISCO CROCHE  H-150 5PZ', 'D002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:36', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (649, 2, NULL, 'DISCO DE CROCHET BSN 200', 'D003', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:36', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (650, 2, NULL, 'DIAFRAGMA', 'D004', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:37', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (651, 2, NULL, 'DESCANSA MANO AZUL', 'D005', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:37', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (652, 2, NULL, 'DESCANSA MANO BLANCO', 'D006', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:37', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (653, 2, NULL, 'DESCANSA MANO NEGRO ', 'D007', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:38', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (654, 2, NULL, 'DISCO CROCHE  CG150 6PZ', 'D008', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:38', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (655, 2, NULL, 'DISCO CROCHE  H-150 5PZ', 'D009', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:38', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (656, 2, NULL, 'DISCO DE FRENO SBR', 'D010', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:39', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (657, 2, NULL, 'DISCO DE FRENO GN ', 'D011', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:39', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (658, 2, NULL, 'EJE DE CAMBIO CG150', 'E001', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:39', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (659, 2, NULL, 'EJE DE HORQUILLA CG150', 'E002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:40', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (660, 2, NULL, 'EJE DE HORQUILLA HORSE', 'E003', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:40', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (661, 2, NULL, 'EJE DELANTERO GN', 'E004', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:40', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (662, 2, NULL, 'EJE DE HORQUILLA CG150', 'E005', NULL, 'BENF', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:41', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (663, 2, NULL, 'EJE DELANTERO SOCIAL', 'E006', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:41', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (664, 2, NULL, 'EJE TRASERO CG150', 'E007', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 22.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:41', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (665, 2, NULL, 'EJE PARA BURRO CENTRAL CG150 ', 'E008', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:42', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (666, 2, NULL, 'EJE TRASERO GN125', 'E009', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:42', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (667, 2, NULL, 'EJE TRASERO SBR', 'E010', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 14.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:42', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (668, 2, NULL, 'EJE DE ARRANQUE CG150', 'E011', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:43', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (669, 2, NULL, 'EJE DE HORQUILLA H-150', 'E012', NULL, 'BENF', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:43', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (670, 2, NULL, 'ELEVADORES HUECO GRANDE', 'E013', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:43', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (671, 2, NULL, 'ELEVADOR DE OCTANAJE', 'E014', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 19.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:44', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (672, 2, NULL, 'EMBLEMA DE HORSE ', 'E015', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:44', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (673, 2, NULL, 'EMBLEMA DE OWEN', 'E016', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 14.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:44', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (674, 2, NULL, 'EMBOBINADO 5 CABLES CLASE A 100% COBRE', 'E017', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:45', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (675, 2, NULL, 'EMPACADURA CILINDRO Y CAMARA 4', 'E018', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:45', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (676, 2, NULL, 'EMPACADURA CON CONTRA PESO', 'E019', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 17.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:45', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (677, 2, NULL, 'EMPACADURA CROCHE CG150 SOLA', 'E020', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 23.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:46', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (678, 2, NULL, 'EMPACADURA MAGNETO CG150 SOLA', 'E021', NULL, 'BENF', NULL, 'unidad', 1.00, 13.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:46', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (679, 2, NULL, 'EMRROLLADO 4 CABLES', 'E022', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:46', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (680, 2, NULL, 'EMRROLLADO DE HORSE', 'E023', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:46', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (681, 2, NULL, 'EROLLADO 5 CABLES', 'E024', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:47', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (682, 2, NULL, 'EROLLADO 5 CABLES', 'E025', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:47', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (683, 2, NULL, 'EROLLADO 5 CABLES', 'E026', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:47', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (684, 2, NULL, 'ESPARRAGO DE ESCAPE 6MM', 'E027', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:48', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (685, 2, NULL, 'EJE TRASERO CG150', 'E028', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 11.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:48', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (686, 2, NULL, 'ESPARRAGO DE ESCAPE 8MM', 'E029', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:48', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (687, 2, NULL, 'ESTOPERA BASTON A-150/H-150 31.43.10.3', 'E030', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:49', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (688, 2, NULL, 'ESTOPERA BASTON CG150 27*39*10.5 ', 'E031', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:49', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (689, 2, NULL, 'ESTOPERA BASTON 1', 'E032', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:49', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (690, 2, NULL, 'ESTOPERA BASTON GN125', 'E033', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:50', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (691, 2, NULL, 'ESTOPERA MOTOR GN 125 INCOMPLETA', 'E034', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:50', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (692, 2, NULL, 'ESTOPERA BASTON  JAGUAR 9,5', 'E035', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:50', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (693, 2, NULL, 'ESTOPERA TX CAÑA', 'E036', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:51', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (694, 2, NULL, 'EXTRACTO DE LEVA', 'E037', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:51', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (695, 2, NULL, 'EXTRACTO DE CROCHERA', 'E038', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:51', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (696, 2, NULL, 'EJE TRASERO DE HORSE', 'E039', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 15.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:52', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (697, 2, NULL, 'FARO BUO TRASPARENTE', 'F001', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:52', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (698, 2, NULL, 'FARO RECTANGULAR LED CON SIRENA', 'F002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:52', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (699, 2, NULL, 'FARO DELGADO LARGO HORIZONTAL', 'F003', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:53', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (700, 2, NULL, 'FARO EXPRESS ', 'F004', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:53', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (701, 2, NULL, 'FARO GN', 'F005', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:53', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (702, 2, NULL, 'FARO SOCIAL', 'F006', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:54', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (703, 2, NULL, 'FARO SBR DECORATIVO', 'F007', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:54', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (704, 2, NULL, 'FAROS SBR', 'F008', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:54', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (705, 2, NULL, 'FAROS MD AGUILA', 'F009', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:55', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (706, 2, NULL, 'FARO CUADRADO MC 606', 'F010', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:55', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (707, 2, NULL, 'FARO CUADRADO MC 607', 'F011', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:55', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (708, 2, NULL, 'FARO DE LUPA CON BASE PEQUEÑO', 'F012', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:56', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (709, 2, NULL, 'FARO DE LUPA CON BASE GRANDE', 'F013', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:56', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (710, 2, NULL, 'FALDA DE H-150 NEGRO', 'F014', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:56', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (711, 2, NULL, 'FALDA DE H-150 ROJO', 'F015', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:57', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (712, 2, NULL, 'FALDA DE H-150 AZUL', 'F016', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:57', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (713, 2, NULL, 'FILTRO CARBURADOR CONICO DE AIRE', 'F017', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:57', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (714, 2, NULL, 'FILTRO DE GASOLINA', 'F018', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 20.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:58', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (715, 2, NULL, 'FILTRO DE GASOLINA DECORATIVO', 'F019', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 101.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:58', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (716, 2, NULL, 'FILTRO GASOLINA ', 'F020', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 28.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:58', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (717, 2, NULL, 'FLAZH CRUCE 12V', 'F021', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:59', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (718, 2, NULL, 'FLOTANTE GASOLINA CG150', 'F022', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:59', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (719, 2, NULL, 'FLOTANTE GASOLINA CG150', 'F023', NULL, 'BENF', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:54:59', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (720, 2, NULL, 'FLOTANTE GASOLINA H-150', 'F024', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:00', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (721, 2, NULL, 'FORRO ASIENTO CG150', 'F025', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:00', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (722, 2, NULL, 'FORRO ASIENTO HORSE', 'F026', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:00', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (723, 2, NULL, 'FORRO DE ASIENTO PARA TAPISAR', 'F027', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:01', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (724, 2, NULL, 'FORROS PARA MANDOS', 'F028', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:01', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (725, 2, NULL, 'FORROS PARA MANDOS', 'F029', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:01', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (726, 2, NULL, 'FUSIBLE', 'F030', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:01', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (727, 2, NULL, 'FUSILERA CON CABLE UNIVERSAL', 'F031', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 15.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:02', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (728, 2, NULL, 'FLAZH CRUCE 12V', 'F032', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 9.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:02', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (729, 2, NULL, 'FORRO DE ASIENTO DE GN', 'F033', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:02', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (730, 2, NULL, 'GEMELO PEQUEÑO', 'G001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:03', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (731, 2, NULL, 'GOMA DE CAMARA', 'G002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 43.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:03', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (732, 2, NULL, 'GOMA DE FARO MORADO CG 150', 'G003', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:03', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (733, 2, NULL, 'GOMA DE FARO NEGRA CG150', 'G004', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:04', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (734, 2, NULL, 'GOMA DE FARO FUCSIA CG150', 'G005', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:04', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (735, 2, NULL, 'GOMA DE FRENO OWEN', 'G006', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 13.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:04', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (736, 2, NULL, 'GOMA DE GUAYA GUARDAFANGO EK', 'G007', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:05', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (737, 2, NULL, 'GOMA DE GUAYA GUARDAFANGO SBR ', 'G008', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:05', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (738, 2, NULL, 'GOMA DE TANQUE GN125', 'G009', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:05', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (739, 2, NULL, 'GOMA DE VALVULA', 'G010', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 54.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:06', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (740, 2, NULL, 'GOMA MANILA DE GUAYA COLORES VARIADOS', 'G011', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 15.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:06', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (741, 2, NULL, 'GOMA MANILLA COLORES AC PARES', 'G012', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:06', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (742, 2, NULL, 'GOMA PATA CAMBIO NARANJANDA MONSTER', 'G013', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:07', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (743, 2, NULL, 'GOMA DE PORTA CORONA GN', 'G014', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 9.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:07', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (744, 2, NULL, 'GOMA POSA PIE', 'G015', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:07', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (745, 2, NULL, 'GOMA POSAPIE H-150 colores FOX', 'G016', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:08', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (746, 2, NULL, 'GOMA POSAPIE H-150 ROJO', 'G017', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:08', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (747, 2, NULL, 'GOMA SOCIALISTA FUCSIA', 'G018', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:08', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (748, 2, NULL, 'GOMA TAPA LATERALE DE CG150', 'G019', NULL, 'MOTO SONYC', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:09', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (749, 2, NULL, 'GOMA TAPA LATERALES DE HORSE', 'G020', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:09', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (750, 2, NULL, 'GRASA DE ESMERILAR', 'G021', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:09', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (751, 2, NULL, 'GUARDA FANGO  DELANTERO AZUL SOCIAL', 'G022', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:10', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (752, 2, NULL, 'GUARDA FANGO DELANTERO ROJO SBR', 'G023', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:10', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (753, 2, NULL, 'GUARDA FANGO DELANTERO OWEN NEGRO', 'G024', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:10', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (754, 2, NULL, 'GUARDA FANGO DELANTERO NEGRO SBR', 'G025', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:11', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (755, 2, NULL, 'GUARDABARRO DELANTERO ROJO', 'G026', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:11', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (756, 2, NULL, 'GUARDAFANGO ESCUDA', 'G027', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:11', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (757, 2, NULL, 'GUARDAFANGO DELANTERO EXPRESS AZUL', 'G028', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:12', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (758, 2, NULL, 'GUAYA CROCHE EK-JORSE', 'G030', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:12', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (759, 2, NULL, 'GUAYA CROCHE UNIVERSAL', 'G031', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 41.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:12', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (760, 2, NULL, 'GUAYA CROCHE UNIVERSAL CON PERNO', 'G032', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 33.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:13', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (761, 2, NULL, 'GUAYA CROCHE OVEN-2014', 'G033', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:13', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (762, 2, NULL, 'GUAYA DE  ACELERACION HORSE ', 'G034', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:13', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (763, 2, NULL, 'GUAYA DE  ACELERACION HORSE ', 'G035', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:14', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (764, 2, NULL, 'GUAYA DE  1', 'G036', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:14', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (765, 2, NULL, 'GUAYA DE ACELERACION DE EXPRESS', 'G037', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 14.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:14', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (766, 2, NULL, 'GUAYA DE ACELERACION DE EXPRESS', 'G038', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:15', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (767, 2, NULL, 'GUAYA DE ACELERACION DE EXPRESS', 'G039', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 19.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:15', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (768, 2, NULL, 'GUAYA DE ACELERACION DE G125H', 'G040', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:15', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (769, 2, NULL, 'GUAYA DE ACELERACION DE OWEN 2009  ', 'G041', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:15', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (770, 2, NULL, 'GUAYA DE ACELERACION DE OWEN 2009  ', 'G042', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:16', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (771, 2, NULL, 'GUAYA DE ACELERACION DE OWEN 2011', 'G043', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:16', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (772, 2, NULL, 'GUAYA DE ACELERACION DE OWEN 2014', 'G044', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:16', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (773, 2, NULL, 'GUAYA DE ACELERACION DE TX200', 'G045', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:17', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (774, 2, NULL, 'GUAYA DE ACELERACION EXPRESS1', 'G046', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:17', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (775, 2, NULL, 'GUAYA DE KILOMETRAJE A-150', 'G047', NULL, 'BENF', NULL, 'unidad', 1.00, 19.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:17', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (776, 2, NULL, 'GUAYA DE ACELERACION CG150', 'G048', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:18', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (777, 2, NULL, 'GUAYA DE CROCHET DE HORSE', 'G049', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:18', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (778, 2, NULL, 'GUAYA DE CROCHE DE CG150', 'G050', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 14.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:18', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (779, 2, NULL, 'GUAYA DE CROCHE DE EK JORSE', 'G051', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:19', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (780, 2, NULL, 'GUAYA DE CROCHE DE OWEN/GS', 'G052', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 12.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:19', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (781, 2, NULL, 'GUAYA DE CROCHE EXPRESS', 'G053', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 22.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:19', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (782, 2, NULL, 'GUAYA DE CROCHE EXPRESS', 'G054', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 11.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:20', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (783, 2, NULL, 'GUAYA DE CROCHE GN', 'G055', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:20', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (784, 2, NULL, 'GUAYA DE CROCHE OWEN', 'G056', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:20', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (785, 2, NULL, 'GUAYA DE FRENO DELANTERO EXPRESS', 'G057', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 11.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:21', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (786, 2, NULL, 'GUAYA DE KILOMETRAJE DE HORSE', 'G058', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:21', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (787, 2, NULL, 'GUAYA DE KILOMETRAJE DE SPREES PALETA', 'G059', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:21', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (788, 2, NULL, 'GUAYA DE KILOMETRAJE DE SPREES RAYO', 'G060', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:22', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (789, 2, NULL, 'GUAYA KILOMETRAJE A-150', 'G061', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 11.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:22', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (790, 2, NULL, 'GUAYA KILOMETRAJE H-150', 'G062', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:22', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (791, 2, NULL, 'GUAYA KILOMETRAJE SPEED', 'G063', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:23', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (792, 2, NULL, 'GUIA DE VALVULA CG150', 'G064', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:23', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (793, 2, NULL, 'GOMA DE PORTA CORONA AZUL MD AGUILA', 'G065', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:23', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (794, 2, NULL, 'GOMA DE PORTA CORONA AZUL GN', 'G066', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:24', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (795, 2, NULL, 'GUAYA DE CROCHET EOW 150', 'G067', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:24', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (796, 2, NULL, 'GOMA DE CAñA CG150', 'G068', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:24', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (797, 2, NULL, 'GOMA DE PORTA CORONA GN125', 'G069', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:25', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (798, 2, NULL, 'GOMA DE CAñA GN', 'G070', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:25', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (799, 2, NULL, 'HORQUILLA HORSE', 'H001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:25', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (800, 2, NULL, 'HORQUILLA OWEN', 'H002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:26', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (801, 2, NULL, 'HORQUILLA SBR', 'H003', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:26', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (802, 2, NULL, 'HORQUILLA DE CG150', 'H004', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:26', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (803, 2, NULL, 'HUESO ACELERADOR CG150-V/H-150 SPEED24', 'H004', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:27', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (804, 2, NULL, 'INSTALACION CG150', 'I001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:27', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (805, 2, NULL, 'INSTALACION CG150', 'I002', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:27', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (806, 2, NULL, 'INSTALACION H-150', 'I003', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:28', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (807, 2, NULL, 'INSTALACION HOWING 2014', 'I004', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:28', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (808, 2, NULL, 'INSTALACION EXPREES', 'I005', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:28', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (809, 2, NULL, 'INSTALACION MD-AGUILA', 'I006', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:29', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (810, 2, NULL, 'INSTALACION SBR', 'I007', NULL, 'BENF', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:29', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (811, 2, NULL, 'INSTALACION TX200', 'I008', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:29', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (812, 2, NULL, 'KIT DE REPARACION DE ARRANQUE', 'K001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:30', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (813, 2, NULL, 'KIT DE BIELA CG150', 'K002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:30', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (814, 2, NULL, 'KIT DE BIELA CG150', 'K003', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:30', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (815, 2, NULL, 'KIT DE BIELA H-150', 'K004', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:30', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (816, 2, NULL, 'KIT DE REPARACION CARBURADOR 150', 'K005', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:31', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (817, 2, NULL, 'KIT DE EMPACADURA CG150', 'K006', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:31', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (818, 2, NULL, 'KIT DE EMPACADURA CG150', 'K007', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:31', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (819, 2, NULL, 'KIT DE ESTRELLA', 'K008', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:32', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (820, 2, NULL, 'KIT DE GOMA DECORATIVO', 'K009', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:32', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (821, 2, NULL, 'KIT DE REPARACION CALIPER H-150', 'K010', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:32', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (822, 2, NULL, 'KIT DE TORNILLO PORTA CORONA PALETA', 'K011', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 27.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:33', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (823, 2, NULL, 'KIT DE TORNILLO PORTA CORONA RIN DE RAYO', 'K012', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 16.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:33', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (824, 2, NULL, 'KIT DE TORNILLO DE PORTA CORONA PALETA', 'K013', NULL, 'BENF', NULL, 'unidad', 1.00, 11.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:33', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (825, 2, NULL, 'KIT DE TORNILLOS DE MOTOR', 'K014', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:34', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (826, 2, NULL, 'KIT EMPACADURA TEX-200 CLASE A', 'K015', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:34', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (827, 2, NULL, 'KIT EMPACADURA CON CONTRA PESO', 'K016', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:34', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (828, 2, NULL, 'KIT ESTOPERA MOTOR CG150', 'K017', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 24.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:35', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (829, 2, NULL, 'KIT DE GOMA PATA PRENDER+CAMBIO AZUL', 'K018', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:35', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (830, 2, NULL, 'KIT REPARACION CALIPER CG150', 'K019', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:35', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (831, 2, NULL, 'KIT REPARACION BOMBA DE FRENO CG200', 'K020', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:36', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (832, 2, NULL, 'KIT REPARACION CALIPER OWEN', 'K021', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:36', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (833, 2, NULL, 'KIT RESORTE CAMARA H-150', 'K022', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:36', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (834, 2, NULL, 'KIT RESORTE CG150 4-PCS', 'K023', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:37', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (835, 2, NULL, 'KIT EMPACADURA CG150', 'K024', NULL, 'MOTO SONIC ', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:37', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (836, 2, NULL, 'KIT TRANCA PIñON', 'K025', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 16.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:37', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (837, 2, NULL, 'KIT TORNILLO/ESPARRAGO CAMARA CG150', 'K026', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:38', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (838, 2, NULL, 'KIT TAPON DE ACEITE CON FILTRO', 'K027', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:38', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (839, 2, NULL, 'KIT VALVULA H-150 CON GOMA', 'K028', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 13.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:38', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (840, 2, NULL, 'KIT VALVULA H-150 CON GOMA', 'K029', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:39', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (841, 2, NULL, 'KIT VALVULA PATA LARGA C/GOMA CG200', 'K030', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:39', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (842, 2, NULL, 'KIT VALVULA PATA LARGA C/GOMA CG200 ACERADA', 'K031', NULL, 'BENF', NULL, 'unidad', 1.00, 9.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:39', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (843, 2, NULL, 'KIT VALVULA PATA LARGA C/GOMA CG200', 'K032', NULL, 'BENF', NULL, 'unidad', 1.00, 13.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:40', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (844, 2, NULL, 'KIT VALVULA PATA LARGA  P/L CAJA DE METAL CG150', 'K033', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:40', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (845, 2, NULL, 'KIT VALVULA PATA LARGA  CG150 ACERADA', 'K034', NULL, 'BENF', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:40', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (846, 2, NULL, 'KIT VALVULA PATA LARGA  P/L CG150', 'K035', NULL, 'BENF', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:41', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (847, 2, NULL, 'KIT VALVULA PATA CORTA  P/C CG150', 'K036', NULL, 'BENF', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:41', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (848, 2, NULL, 'KIT DE GOMA DECORATIVA 7PZA NEGRA S/LLAVERO NEGRO', 'K037', NULL, '', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:41', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (849, 2, NULL, 'KIT DE GOMA DECORATIVA 7PZA ROJA S/LLAVERO NEGRO', 'K038', NULL, '', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:42', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (850, 2, NULL, 'LEVA DE CROCHE CG150', 'L001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 13.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:42', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (851, 2, NULL, 'LEVA DE FRENO CG150', 'L002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:42', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (852, 2, NULL, 'LEVA DE FRENO GN125', 'L003', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:43', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (853, 2, NULL, 'LIGA 250 ML ROMO', 'L004', NULL, 'ROMO', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:43', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (854, 2, NULL, 'LIGA 500 ML ROMO', 'L005', NULL, 'ROMO', NULL, 'unidad', 1.00, 12.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:43', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (855, 2, NULL, 'LIGA DE AMARRE', 'L006', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:44', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (856, 2, NULL, 'LIMPIA CADENA', 'L007', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:44', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (857, 2, NULL, 'LENTES', 'L008', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:44', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (858, 2, NULL, 'LLAVE DE GASOLINA HORSE', 'L009', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:45', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (859, 2, NULL, 'LLAVE GASOLINA DE OWEN', 'L010', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:45', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (860, 2, NULL, 'LLAVE GASOLINA DE GN125', 'L011', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:45', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (861, 2, NULL, 'LLAVE GASOLINA EK-EXPRESS ', 'L012', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:45', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (862, 2, NULL, 'LUCES BARRA 6 LED', 'L013', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:46', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (863, 2, NULL, 'LLAVE T', 'L014', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:46', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (864, 2, NULL, 'LLAVERO ELASTICO', 'L015', NULL, 'BENF', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:46', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (865, 2, NULL, 'LUCES CRUCE DE HORSE', 'L016', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:47', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (866, 2, NULL, 'LUCES CRUCES DE SBR', 'L017', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:47', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (867, 2, NULL, 'LUCES CRUCE DE GN', 'L018', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:47', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (868, 2, NULL, 'LUZ CRUCE CG150 MODELO VIEJO', 'L019', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:48', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (869, 2, NULL, 'LUCES CRUCES HORSE TRASPARENTE', 'L020', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 12.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:48', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (870, 2, NULL, 'LLAVERO ELASTICO', 'L020', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 12.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:48', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (871, 2, NULL, 'LLAVERO RESORTE', 'L021', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 13.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:49', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (872, 2, NULL, 'LLAVERO RESORTE (RECORDATORIO)', 'L022', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 13.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:49', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (873, 2, NULL, 'LUCES DE CRUCES EK XPRESS', 'L023', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:49', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (874, 2, NULL, 'LUZ CRUCE CG150 MODELO LED', 'L024', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 11.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:50', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (875, 2, NULL, 'MAGNETO CG150', 'L025', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:50', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (876, 2, NULL, 'LUCES DE CRUCES EK XPRESS NEW', 'L026', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:50', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (877, 2, NULL, 'MAGNETO GN125', 'M002', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:51', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (878, 2, NULL, 'MAGNETO OWEN', 'M003', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:51', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (879, 2, NULL, 'MALLA DE ASIENTO UNIVERSAL', 'M004', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:51', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (880, 2, NULL, 'MALLA DE PULPO VARIADO', 'M005', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:52', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (881, 2, NULL, 'MANDO DE EXPRESS', 'M006', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:52', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (882, 2, NULL, 'MANDO DE HORSE 150', 'M007', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:52', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (883, 2, NULL, 'MANDO DE HORSE 150', 'M008', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:53', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (884, 2, NULL, 'MANDO OWEN CON PALETA', 'M009', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:53', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (885, 2, NULL, 'MANDO OWEN NORMAL 2014', 'M010', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:53', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (886, 2, NULL, 'MANDO SBR', 'M011', NULL, 'BENF', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:54', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (887, 2, NULL, 'MANGA BRAZO VARIADA', 'M012', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 36.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:54', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (888, 2, NULL, 'MAGNETO  CG150', 'M013', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:54', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (889, 2, NULL, 'MAGNETO HORSE', 'M014', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:55', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (890, 2, NULL, 'MINI KIT EMPACADURA', 'M015', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 25.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:55', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (891, 2, NULL, 'MANILLA DE FRENO   ', 'M016', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:55', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (892, 2, NULL, 'MANGUERA DE FRENO GN125', 'M017', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:56', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (893, 2, NULL, 'MANGUERA DE GASOLINA', 'M018', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:56', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (894, 2, NULL, 'MANGUERA RESPIRADERO MOTOR', 'M019', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:56', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (895, 2, NULL, 'MANIFORT/BASE CARBURADOR', 'M020', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:57', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (896, 2, NULL, 'MANILLA DE FRENO EXPREES', 'M021', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 21.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:57', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (897, 2, NULL, 'MANILLA CROCHE COMPLETA EK-PRESS ', 'M022', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:57', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (898, 2, NULL, 'MANILLA CROCHE COMPLETA EK-PRESS ', 'M023', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:58', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (899, 2, NULL, 'MANILLA CROCHE SOLA CG-150', 'M024', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 32.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:58', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (900, 2, NULL, 'MANILLA COMPLETA MD AGUILA', 'M025', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:58', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (901, 2, NULL, 'MANILLA SBR', 'M026', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:59', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (902, 2, NULL, 'MANZANA delantera', 'M027', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:59', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (903, 2, NULL, 'MANZANA TRASERA', 'M028', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:55:59', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (904, 2, NULL, 'MARTILLERA 150', 'M029', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:00', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (905, 2, NULL, 'MARTILLERA 200', 'M030', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:00', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (906, 2, NULL, 'MASCARA', 'M031', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:00', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (907, 2, NULL, 'MEDIDOR DE ACEITE', 'M032', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:01', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (908, 2, NULL, 'MEDIO KIT DE EMPACADURA', 'M033', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:01', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (909, 2, NULL, 'MEDIO KIT DE EMPACADURA', 'M034', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:01', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (910, 2, NULL, 'MICA DE FARO MD AGUILA', 'M035', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:02', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (911, 2, NULL, 'MICA FARO STOP', 'M036', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:02', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (912, 2, NULL, 'MICA STOP CG TRASPARENTE XPRES', 'M037', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:02', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (913, 2, NULL, 'MINI KIT EMPACADURA', 'M038', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 19.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:03', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (914, 2, NULL, 'MEDIO KIT DE EMPACADURA', 'M039', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:03', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (915, 2, NULL, 'MANDO KAVAK', 'M040', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:03', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (916, 2, NULL, 'MANILLA DE CROCHET COMPLETA A150', 'M041', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:04', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (917, 2, NULL, 'MANILLA DE CROCHET COMPLETA H150', 'M042', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:04', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (918, 2, NULL, 'MUELITA 5PTS BLANCO MZ401B', 'M043', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:04', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (919, 2, NULL, 'PALETA CROCHET PLATEADA HORSE', 'P001', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:05', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (920, 2, NULL, 'PALETA FRENO H-150', 'P002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:05', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (921, 2, NULL, 'PALETA DE FRENO CG150', 'P003', NULL, 'moto fami', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:05', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (922, 2, NULL, 'PALETA DE FRENO  GN125', 'P004', NULL, 'moto fami', NULL, 'unidad', 1.00, 12.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:05', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (923, 2, NULL, 'PALETA DE FRENO hrse', 'P005', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:06', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (924, 2, NULL, 'PARILLA GN', 'P006', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:06', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (925, 2, NULL, 'PARRILA HORSE MEGAZUKI', 'P007', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:06', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (926, 2, NULL, 'PASTILLA DE FRENO CG150', 'P008', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:07', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (927, 2, NULL, 'PASTILLA DE FRENO CG150', 'P009', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:07', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (928, 2, NULL, 'PASTILLA DE FRENO GN125', 'P010', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:07', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (929, 2, NULL, 'PASTILLA DE FRENO TX', 'P011', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:08', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (930, 2, NULL, 'PASTILLA FRENO A-150', 'P012', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 15.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:08', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (931, 2, NULL, 'Paleta DE FRENO CG150', 'P013', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:08', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (932, 2, NULL, 'PASTILLAS A-150', 'P014', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:09', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (933, 2, NULL, 'PASTILLAS DE FRENO SBR', 'P015', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 34.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:09', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (934, 2, NULL, 'PASTILLAS DE HORSE', 'P016', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 18.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:09', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (935, 2, NULL, 'PASTILLAS SBR', 'P017', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:10', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (936, 2, NULL, 'PATA DE PARAL', 'P018', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:10', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (937, 2, NULL, 'PATA DE ARRANQUE CG150', 'P019', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:10', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (938, 2, NULL, 'PATA DE ARRANQUE EK', 'P020', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:11', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (939, 2, NULL, 'PATA DE ARRANQUE EK', 'P021', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:11', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (940, 2, NULL, 'PATA DE CAMBIO  CG150', 'P022', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:11', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (941, 2, NULL, 'PATA DE CAMBIO EXPRESS', 'P023', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:12', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (942, 2, NULL, 'PATA DE CAMBIO RAGCIN', 'P024', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:12', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (943, 2, NULL, 'PATA DE FRENO GN125', 'P025', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:12', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (944, 2, NULL, 'PATA DE FRENO h-150', 'P026', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:13', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (945, 2, NULL, 'PATA DE FRENO EK', 'P027', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:13', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (946, 2, NULL, 'PATA FRENO CG-150', 'P028', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:13', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (947, 2, NULL, 'PATA FRENO NEGRO A-150', 'P029', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:14', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (948, 2, NULL, 'PORTA CELULARES', 'P030', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:14', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (949, 2, NULL, 'PATA DE CAMBIO A-150', 'P031', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:14', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (950, 2, NULL, 'PERNO DE CADENA', 'P032', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 28.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:15', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (951, 2, NULL, 'PICA CADENA', 'P033', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:15', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (952, 2, NULL, 'PIÑON DE ARRANQUE', 'P034', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:15', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (953, 2, NULL, 'PIÑON DE TERCERA 150', 'P035', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 9.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:16', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (954, 2, NULL, 'PIÑON PLATEADO 15T', 'P036', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:16', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (955, 2, NULL, 'PIÑON CG150 DORADO 16T ', 'P037', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 20.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:16', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (956, 2, NULL, 'PIÑON H-150 DORADO 16T ', 'P038', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, -1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:17', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (957, 2, NULL, 'PIÑON DORADO 17T', 'P039', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:17', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (958, 2, NULL, 'PIÑON GN125 PLATEADO 15 T', 'P040', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 15.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:17', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (959, 2, NULL, 'PIPA SILICON', 'P041', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:18', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (960, 2, NULL, 'PISTON H-150', 'P042', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:18', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (961, 2, NULL, 'PISTON COMPL A-150 0.50', 'P043', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:18', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (962, 2, NULL, 'PISTON COMPL A-150 0.75 AUTOASIA', 'P044', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:18', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (963, 2, NULL, 'PIÑON DORADO 15T', 'P045', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:19', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (964, 2, NULL, 'PISTON COMPL H-150 0.75', 'P046', NULL, 'JUYUA', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:19', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (965, 2, NULL, 'PISTON COMPL h-150 1', 'P047', NULL, 'JUYUA', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:19', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (966, 2, NULL, 'PISTO COMPL EXPREES  STD', 'P048', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:20', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (967, 2, NULL, 'PISTON COMPL CG150 STD', 'P049', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:20', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (968, 2, NULL, 'PISTON DE OWEN 2011 STD', 'P050', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:20', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (969, 2, NULL, 'PISTON CG200 1', 'P051', NULL, 'ZHONG HING', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:21', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (970, 2, NULL, 'PISTON CG200 0,75', 'P052', NULL, 'ZHONG HING', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:21', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (971, 2, NULL, 'PISTON CG150 1', 'P053', NULL, 'JUYUA', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:21', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (972, 2, NULL, 'PISTON CG150 ,75', 'P054', NULL, 'JUYUA', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:22', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (973, 2, NULL, 'PISTON  ,25 vera p/d', 'P055', NULL, 'JUYUA', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:22', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (974, 2, NULL, 'PITILLOS', 'P056', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 12.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:22', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (975, 2, NULL, 'PLACA DECORATIVA', 'P057', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 29.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:23', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (976, 2, NULL, 'PORTA BANDA DE AGUILA ', 'P058', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:23', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (977, 2, NULL, 'PORTA BANDA DELANTERA EKEXPRESS', 'P059', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:23', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (978, 2, NULL, 'PORTA BANDA CG150', 'P060', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:24', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (979, 2, NULL, 'PORTA CORONA AGUILA', 'P061', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:24', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (980, 2, NULL, 'PORTA CORONA SBR', 'P062', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:24', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (981, 2, NULL, 'PORTA CORONA HORSE', 'P063', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:25', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (982, 2, NULL, 'PORTA MALETERA METAL ', 'P064', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:25', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (983, 2, NULL, 'PORTA MALETERA PLASTICA NEGRO', 'P065', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:25', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (984, 2, NULL, 'PORTA MALETERA UNIVERSAL VARIADO', 'P066', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:26', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (985, 2, NULL, 'PORTA PLACA MORADO DE METAL', 'P067', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:26', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (986, 2, NULL, 'PORTA PLACA ROJA DE METAL', 'P068', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 11.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:26', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (987, 2, NULL, 'PORTA PLACA VERDE DE METAL', 'P069', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:27', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (988, 2, NULL, 'PORTA PLACA NEGTRO DE METAL', 'P070', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:27', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (989, 2, NULL, 'PORTA PLACA AZUL DE METAL', 'P071', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:27', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (990, 2, NULL, 'POSA PIE DELANTERO AMARILLO CG150', 'P072', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:28', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (991, 2, NULL, 'POSA PIE DELANTERO OWEN', 'P073', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:28', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (992, 2, NULL, 'POSA PIE DELANTERO EXPRESS', 'P074', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:28', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (993, 2, NULL, 'POSA PIE TRASERO HORSE ', 'P075', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:29', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (994, 2, NULL, 'POSA PIE TRASERO HORSE ROSADO', 'P076', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:29', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (995, 2, NULL, 'POSA PIE TRASERO GN125', 'P077', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:29', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (996, 2, NULL, 'POSA PIE DELANTERO HORSE GOMA', 'P078', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:30', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (997, 2, NULL, 'POSA PIE DELANTERO PROTAPPER', 'P079', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:30', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (998, 2, NULL, 'POSA PIE TRASERO SBR', 'P080', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:30', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (999, 2, NULL, 'PORTA BANDA DELANTERA EKEXPRESS', 'P081', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:31', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1000, 2, NULL, 'PRENSA CADENA UNIVERSAL', 'P082', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:31', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1001, 2, NULL, 'PRENSA CADENA GN', 'P083', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:31', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1002, 2, NULL, 'PRENSA CADENA GN', 'P084', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:32', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1003, 2, NULL, 'PRENSA CADENA H-150', 'P085', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 16.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:32', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1004, 2, NULL, 'PRENSA CADENA CG150', 'P086', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:32', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1005, 2, NULL, 'PORTA BANDA TRASERA DE XPRESS', 'P087', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:33', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1006, 2, NULL, 'PROTAPPER FORRO GRUESO PUFF', 'P088', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 24.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:33', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1007, 2, NULL, 'PROTAPPER FORRO NORMAL PUFF', 'P089', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:33', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1008, 2, NULL, 'PROTECTOR  DE MOTOR UNIVERSAL HIERRO TX', 'P090', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:33', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1009, 2, NULL, 'PROTECTOR DE FARO PLASTICO AZUL ', 'P091', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:34', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1010, 2, NULL, 'PROTECTOR DE FARO PLASTICO MORADO', 'P092', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:34', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1011, 2, NULL, 'PROTECTOR DE FARO PLASTICO NEGRO ', 'P093', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:34', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1012, 2, NULL, 'PROTECTOR DE FARO PLASTICO ROJO', 'P094', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:35', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1013, 2, NULL, 'PROTECTOR DE MOTOR UNIVERSAL CROMADO', 'P095', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:35', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1014, 2, NULL, 'PROTECTOR DE MOTOR UNIVERSAL PLASTICO ', 'P096', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:35', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1015, 2, NULL, 'PUÑOS DECORATIVOS', 'P097', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 11.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:36', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1016, 2, NULL, 'PURIFICADOR 150', 'P098', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:36', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1017, 2, NULL, 'PEGA TANQUE', 'P099', NULL, 'ROYAL', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:36', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1018, 2, NULL, 'PUÑOS NORMAL', 'P100', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:37', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1019, 2, NULL, 'PALETA DE FRENO H-150', 'P101', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:37', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1020, 2, NULL, 'PATA DE FRENO', 'P102', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:37', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1021, 2, NULL, 'PRENSA CADENA CG150', 'P103', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:38', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1022, 2, NULL, 'PROTECTOR DE MOTOR UNIVERSAL PLASTICO ', 'P104', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:38', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1023, 2, NULL, 'PURIFICADOR H-150', 'P105', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:38', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1024, 2, NULL, 'PIñON 16T HORSE', 'P106', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:39', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1025, 2, NULL, 'PIñON 15T HORSE', 'P107', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:39', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1026, 2, NULL, 'PATA DE CAMBIO EK XPRES', 'P108', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:39', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1027, 2, NULL, 'PATA DE PARAL CG150 CON RESOLTE', 'P109', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:40', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1028, 2, NULL, 'PATA DE PARAL EK EXPRES', 'P110', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:40', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1029, 2, NULL, 'PIÑON DE CIGÜEÑAL CG150', 'P111', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:40', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1030, 2, NULL, 'RAYa CARRO NEGRO PESA VOLANTE', 'R001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:41', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1031, 2, NULL, 'RAYa CARRO PLATEADO PESA VOLANTE', 'R002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:41', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1032, 2, NULL, 'RETROVISOR OWEN ', 'R003', NULL, 'BENF', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:41', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1033, 2, NULL, 'RETROVISOR A-150', 'R004', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:42', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1034, 2, NULL, 'RETROVISOR EK XPRES', 'R005', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:42', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1035, 2, NULL, 'REGULADOR CG-150', 'R006', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:42', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1036, 2, NULL, 'REGULADOR HORSE', 'R007', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:43', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1037, 2, NULL, 'REGULADOR H-150', 'R008', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:43', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1038, 2, NULL, 'REGULADOR HOWING', 'R009', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 13.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:43', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1039, 2, NULL, 'REGULADOR RAGCIN', 'R010', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:44', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1040, 2, NULL, 'RESOLTE DE FRENO/PIE DE A,IGO', 'R011', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 34.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:44', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1041, 2, NULL, 'RETROVISOR CG150 PATAS CORTA', 'R012', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:44', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1042, 2, NULL, 'RETROVISOR SBR', 'R013', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:45', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1043, 2, NULL, 'RETROVISOR HORSE', 'R014', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:45', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1044, 2, NULL, 'RETEN PORTA CORONA CG150 58 MM', 'R015', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:45', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1045, 2, NULL, 'RIN DE HORSE', 'R015', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:46', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1046, 2, NULL, 'RIN DE RAYO', 'R016', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:46', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1047, 2, NULL, 'ROLINERA 6000', 'R017', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:46', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1048, 2, NULL, 'ROLINERA 6002', 'R018', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:46', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1049, 2, NULL, 'ROLINERA 6004 KOYO', 'R019', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 35.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:47', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1050, 2, NULL, 'ROLINERA 6200 ', 'R020', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:47', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1051, 2, NULL, 'ROLINERA 6301', 'R021', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:47', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1052, 2, NULL, 'ROLINERA DE CUELLO MUNICION', 'R022', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 10.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:48', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1053, 2, NULL, 'ROLINERA 6301', 'R023', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:48', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1054, 2, NULL, 'ROLINERA 6202', 'R024', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 34.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:48', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1055, 2, NULL, 'ROLINERA DE CUELLO CONICA', 'R025', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:49', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1056, 2, NULL, 'ROLINERA 6204', 'R026', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:49', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1057, 2, NULL, 'ROLINERA 6205', 'R027', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:49', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1058, 2, NULL, 'ROLINERA 6207', 'R028', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:50', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1059, 2, NULL, 'ROLINERA 6300 KOYO', 'R029', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:50', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1060, 2, NULL, 'ROLINERA 6301', 'R030', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 30.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:50', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1061, 2, NULL, 'ROLINERA 6204 KOYO', 'R031', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 15.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:51', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1062, 2, NULL, 'ROLINERA 6302 KOYO', 'R032', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 12.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:51', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1063, 2, NULL, 'ROLINERA 6302', 'R033', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 35.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:51', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1064, 2, NULL, 'ROLINERA DE CREMALLERA 200', 'R034', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:52', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1065, 2, NULL, 'ROMPEDIENTE VERDE', 'R035', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:52', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1066, 2, NULL, 'ROSORTE DE FRENO ', 'R036', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:52', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1067, 2, NULL, 'ROSORTE1', 'R037', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:53', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1068, 2, NULL, 'ROLINERA DE CUELLO CONICA', 'R038', NULL, 'BENF', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:53', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1069, 2, NULL, 'ROLINERA DE CUELLO MUNICION', 'R039', NULL, 'BENF', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:53', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1070, 2, NULL, 'RETROVISOR REDONDO MICKIE', 'R040', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:54', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1071, 2, NULL, 'RETROVISOR V-150 P/CORTA', 'R041', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:54', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1072, 2, NULL, 'ROLINERA 6202 KOYO', 'R042', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:54', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1073, 2, NULL, 'ROLINERA 6202', 'R043', NULL, 'BENF', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:55', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1074, 2, NULL, 'ROLINERA 6204', 'R044', NULL, 'BENF', NULL, 'unidad', 1.00, 14.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:55', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1075, 2, NULL, 'ROLINERA 6302', 'R045', NULL, 'BENF', NULL, 'unidad', 1.00, 15.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:55', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1076, 2, NULL, 'SACA BUJIA', 'S001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:56', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1077, 2, NULL, 'SELECTOR CAMBIO H-150', 'S002', NULL, 'MOTO SONYC', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:56', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1078, 2, NULL, 'SEGURO DE TAPA DE HORSE', 'S003', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:56', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1079, 2, NULL, 'SILICON', 'S004', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 21.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:57', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1080, 2, NULL, 'SILICON MEGA GREY', 'S005', NULL, 'ROMO', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:57', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1081, 2, NULL, 'SLAIDER', 'S006', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 14.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:57', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1082, 2, NULL, 'SOCATE FARO CG150', 'S007', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:58', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1083, 2, NULL, 'SOCATE FARO H-150', 'S008', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:58', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1084, 2, NULL, 'SOCATE STOP FRENO H-150', 'S009', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:58', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1085, 2, NULL, 'SOCATE STOP FRENO PAR CG150', 'S010', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:59', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1086, 2, NULL, 'SPRAY BLANCO', 'S011', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:59', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1087, 2, NULL, 'SPRAY COLOR ROJO', 'S012', NULL, 'BENF', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:56:59', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1088, 2, NULL, 'SPRAY ROSADO', 'S013', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:00', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1089, 2, NULL, 'SPRAY ROJO', 'S014', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:00', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1090, 2, NULL, 'SPRAY ECONOMICO AMARILLO', 'S015', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:00', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1091, 2, NULL, 'SPRAY ECONOMICO VERDE JADE', 'S016', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:00', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1092, 2, NULL, 'SPRAY NEGRO BRIllante   ', 'S017', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:01', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1093, 2, NULL, 'SPRAY NEGRO MATE CARIBEZUKI', 'S018', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:01', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1094, 2, NULL, 'SPRAY TRASPARENTE', 'S019', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:01', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1095, 2, NULL, 'STOP DECORATIVO CG150', 'S020', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:02', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1096, 2, NULL, 'STOP  CG150', 'S021', NULL, 'BENF', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:02', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1097, 2, NULL, 'STOP DECORATIVO HORSE', 'S022', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:02', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1098, 2, NULL, 'STOP SBR TRANSPARENTE', 'S023', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:03', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1099, 2, NULL, 'SWICHERA 4 CABLE', 'S024', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:03', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1100, 2, NULL, 'SOPORTE DE PLACA TORNASOL', 'S025', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:03', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1101, 2, NULL, 'SWICHERA ECA EXPRESS', 'S026', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:04', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1102, 2, NULL, 'SWITHERA HORSE', 'S027', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:04', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1103, 2, NULL, 'SWITHERA OWEN', 'S028', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:04', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1104, 2, NULL, 'SELECTOR CAMBIO CG150', 'S029', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 8.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:05', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1105, 2, NULL, 'SPRAY NEGRO MATE', 'S030', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:05', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1106, 2, NULL, 'SPRAY NEGRO BRILLANTE ALTA TEMPERATURA', 'S031', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:05', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1107, 2, NULL, 'SWICHERA SBR', 'S032', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:06', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1108, 2, NULL, 'spray VERDE', 'S033', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:06', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1109, 2, NULL, 'STOP  CG150', 'S034', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:06', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1110, 2, NULL, 'T DE VOLANTE SUPERIOR EK-EXPRESS', 'T001', NULL, 'BENF', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:07', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1111, 2, NULL, 'T DE VOLANTE INFERIOR SOCIAL', 'T002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:07', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1112, 2, NULL, 'TACOMETRO HORSE', 'T003', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:07', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1113, 2, NULL, 'TACOMETRO MD AGUILA', 'T004', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:08', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1114, 2, NULL, 'TACOMETRO OWEN 2011 DIGITAL', 'T005', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:08', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1115, 2, NULL, 'TACOMETRO SBR 2022', 'T006', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:08', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1116, 2, NULL, 'TACOMETRO SBR DIGITAL 2024', 'T007', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:09', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1117, 2, NULL, 'TAPA DE MOTOR DECORATIVO SBR VARIADA', 'T008', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:09', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1118, 2, NULL, 'TAPA CADENA  PLASTICA NEGRO A-150', 'T009', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:09', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1119, 2, NULL, 'TAPA CADENA  PLASTICA H-150 MORAD0', 'T010', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:10', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1120, 2, NULL, 'TAPA CADENA ESV PLASTICA AZUL', 'T011', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:10', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1121, 2, NULL, 'TAPA CADENA ESV PLASTICA MORADA', 'T012', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:10', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1122, 2, NULL, 'TAPA CADENA ESV PLASTICA ', 'T013', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:11', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1123, 2, NULL, 'TAPA CADENA H-150 PLASTICA ', 'T014', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 11.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:11', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1124, 2, NULL, 'TAPA CADENA PASTICO NEGRO EK', 'T015', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:11', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1125, 2, NULL, 'TAPA CADENA PASTICO 1', 'T016', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:12', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1126, 2, NULL, 'TAPA CADENA RAGCIN AZUL', 'T017', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:12', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1127, 2, NULL, 'TAPA CADENA RAGCIN MORADO', 'T018', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:12', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1128, 2, NULL, 'TAPA CADENA RAGCIN NEGRO', 'T019', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:13', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1129, 2, NULL, 'TAPA CADENA RAGCIN PLATIADO', 'T020', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:13', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1130, 2, NULL, 'TAPA CADENA RAGCIN ROJO', 'T021', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:13', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1131, 2, NULL, 'TAPA CARBURADOR DECORATIVO', 'T022', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:13', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1132, 2, NULL, 'TAPA DE TACOMETRO SOCIAL/SBR PROTECTOR', 'T023', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:14', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1133, 2, NULL, 'TAPA DE TANQUE DE GASOLINA', 'T024', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:18', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1134, 2, NULL, 'TAPA DE TANQUE DE GASOLINA', 'T025', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:18', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1135, 2, NULL, 'TAPA DISCO VARIADO', 'T026', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:18', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1136, 2, NULL, 'TAPA HORSE LATERALES NEGRO', 'T027', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:19', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1137, 2, NULL, 'TAPA HORSE LATERALES ROJO', 'T028', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:19', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1138, 2, NULL, 'TAPA SBR ROJA lateral', 'T029', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:19', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1139, 2, NULL, 'TAPA SWICHERA H-150 ROJO', 'T030', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:20', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1140, 2, NULL, 'TAPA TORNILLO PLASTICA MODELO VARIADO', 'T031', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:20', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1141, 2, NULL, 'TAPA VALVULA  DE COLORES', 'T032', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:20', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1142, 2, NULL, 'TAPA VALVULA DE BALA', 'T033', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:21', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1143, 2, NULL, 'TAPA VALVULA DE CARAVELA', 'T034', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:21', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1144, 2, NULL, 'MICAS  1', 'T035', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:21', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1145, 2, NULL, 'TERMINALES AMARILLOS', 'T036', NULL, 'ROMO', NULL, 'unidad', 1.00, 34.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:22', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1146, 2, NULL, 'TERMINALES AZUL', 'T037', NULL, 'ROMO', NULL, 'unidad', 1.00, 41.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:22', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1147, 2, NULL, 'TERMINALES DE BATERIA', 'T038', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 27.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:22', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1148, 2, NULL, 'TRIPA 100/80 14', 'T039', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:23', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1149, 2, NULL, 'TRIPA 110/90/16', 'T040', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:23', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1150, 2, NULL, 'TRIPA 110/90/16', 'T041', NULL, 'ROMO', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:23', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1151, 2, NULL, 'TRIPA 120/70 12', 'T042', NULL, 'MOTO FAMI ', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:24', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1152, 2, NULL, 'TRIPA 300/17', 'T043', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:24', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1153, 2, NULL, 'TRIPA 300/18', 'T044', NULL, 'ROMO', NULL, 'unidad', 1.00, 10.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:24', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1154, 2, NULL, 'TRIPA 410/17', 'T045', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:25', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1155, 2, NULL, 'TRIPA 410/18', 'T046', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:25', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1156, 2, NULL, 'TRIPA RIN 24', 'T047', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:25', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1157, 2, NULL, 'TUBITO MANUBRIO AZUL', 'T048', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:26', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1158, 2, NULL, 'TUBITO MANUBRIO AJUSTABLE VERDE', 'T049', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:26', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1159, 2, NULL, 'TUBITO MANUBRIO MORADO', 'T050', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:26', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1160, 2, NULL, 'TUBITO MANUBRIO NEGRO', 'T051', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:27', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1161, 2, NULL, 'TUBITO MANUBRIO ROJO', 'T052', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:27', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1162, 2, NULL, 'TUBO DE ESCAPE BENF', 'T053', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:27', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1163, 2, NULL, 'TUBO DE ESCAPE BENF  TORNAZOL', 'T054', NULL, 'BENF', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:28', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1164, 2, NULL, 'TUBO DE ESCAPE EXPRESS', 'T055', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:28', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1165, 2, NULL, 'TAPA PINON', 'T056', NULL, 'BENF', NULL, 'unidad', 1.00, 3.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:28', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1166, 2, NULL, 'TAPON DE MOTOR DESAGUE DE ACEITE', 'T057', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:28', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1167, 2, NULL, 'TIRRAJ GRANDE DE TRIPOIDE', 'T058', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 48.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:29', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1168, 2, NULL, 'TIRRAJ  MEDIANO', 'T059', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:29', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1169, 2, NULL, 'TORNILLO DECORATIVO', 'T060', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, -1.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:29', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1170, 2, NULL, 'TUBO DE ESCAPE MEGAZUKI', 'T061', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:30', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1171, 2, NULL, 'TUERCA 14 MM', 'T062', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:30', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1172, 2, NULL, 'TUERCA 12 MM', 'T063', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:30', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1173, 2, NULL, 'TUERCA AMORTIGUADOR', 'T064', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:31', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1174, 2, NULL, 'TAPA SWICHERA DECORATIVA', 'T065', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 11.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:31', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1175, 2, NULL, 'TIRRAJ PEQUEÑO', 'T066', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 72.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:31', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1176, 2, NULL, 'TORNILLO DECORATIVO', 'T067', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 29.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:32', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1177, 2, NULL, 'TEIPE GRANDE', 'T068', NULL, 'COBRA', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:32', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1178, 2, NULL, 'TORNILLO RAGCIN AZUL', 'T069', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:32', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1179, 2, NULL, 'TORNILLO RAGCIN MORADO', 'T070', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:33', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1180, 2, NULL, 'TORNILLO RAGCIN ROJO', 'T071', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:33', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1181, 2, NULL, 'VARILLA FRENO CG150', 'V001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 11.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:33', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1182, 2, NULL, 'VARILLA FRENO 1', 'V002', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:34', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1183, 2, NULL, 'VARILLA FRENO DE OWEN ', 'V003', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 15.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:34', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1184, 2, NULL, 'VOLANTE H-150', 'V004', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:34', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1185, 2, NULL, 'VOLANTE MD AGUILA', 'V005', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 5.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:35', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1186, 2, NULL, 'VOLANTE SBR', 'V006', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:35', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1187, 2, NULL, 'VALVULA DE AIRE PARA CAUCHO', 'V007', NULL, 'ROMO', NULL, 'unidad', 1.00, 0.00, NULL, 0, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:35', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1188, 2, NULL, 'VALVULA CG150 P/L', 'V008', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 10.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:36', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1189, 2, NULL, 'VOLANTE DE OWEN', 'V009', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:36', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1190, 2, NULL, 'VOLANTE SBR', 'V010', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:36', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1191, 2, NULL, 'VOLANTE EXPREES', 'V011', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:37', '2026-02-06 12:43:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (1192, 2, NULL, 'VOLANTE H-150 TORNASOL', 'V012', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 2, 'USD', 0.00, 0.00, 0.00, '2026-02-06 03:57:37', '2026-02-06 12:43:57', 0, 0, NULL);

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
) ENGINE = MyISAM AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

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
INSERT INTO `proveedores` VALUES (28, 2, 'General', NULL, NULL, '2026-02-06 04:12:33');
INSERT INTO `proveedores` VALUES (27, 1, 'General', NULL, NULL, '2026-01-31 22:48:34');

-- ----------------------------
-- Table structure for user_negocios
-- ----------------------------
DROP TABLE IF EXISTS `user_negocios`;
CREATE TABLE `user_negocios`  (
  `user_id` int NOT NULL,
  `negocio_id` int NOT NULL,
  PRIMARY KEY (`user_id`, `negocio_id`) USING BTREE,
  INDEX `negocio_id`(`negocio_id`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of user_negocios
-- ----------------------------
INSERT INTO `user_negocios` VALUES (1, 1);
INSERT INTO `user_negocios` VALUES (2, 1);
INSERT INTO `user_negocios` VALUES (3, 1);
INSERT INTO `user_negocios` VALUES (4, 2);
INSERT INTO `user_negocios` VALUES (5, 2);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `cedula` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `created_at` datetime NULL DEFAULT current_timestamp,
  `nombre_completo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'Usuario',
  `rol` enum('superadmin','admin','vendedor') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'admin',
  `activo` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`cedula`) USING BTREE,
  UNIQUE INDEX `cedula`(`cedula`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (3, '31338532', '$2y$10$HJqK94WVEJk1ZAisyYtu0eQVdHCP6UqnlPk5YDfG02iQSDxayNMJC', '2026-01-29 10:46:55', 'Luna', 'admin', 1);
INSERT INTO `users` VALUES (1, '16912337', '$2y$10$HJqK94WVEJk1ZAisyYtu0eQVdHCP6UqnlPk5YDfG02iQSDxayNMJC', '2026-01-26 17:43:06', 'Javier Ponciano', 'superadmin', 1);
INSERT INTO `users` VALUES (2, '32616444', '$2y$10$HJqK94WVEJk1ZAisyYtu0eQVdHCP6UqnlPk5YDfG02iQSDxayNMJC', '2026-01-26 23:47:21', 'Adrian Ponciano', 'admin', 1);
INSERT INTO `users` VALUES (4, '19942190', '$2y$10$JTVbwCU9qvpuH5uIns8tsuPmP98JvReIbJMIPTATfVGlwf6O0yZNK', '2026-01-27 02:00:48', 'Usuario Admin', 'admin', 1);
INSERT INTO `users` VALUES (5, '12345678', '$2y$10$dRFfyIKeTkiwhM6B.4CKremMEs3MWK343VklPtpCRTYADVFeZpY06', '2026-02-06 04:15:42', 'Vendedor Repuestos', 'vendedor', 1);

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
) ENGINE = MyISAM AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of ventas
-- ----------------------------
INSERT INTO `ventas` VALUES (1, 1, '2026-02-04 12:26:25', 1879.16, 5.01, 375.08);
INSERT INTO `ventas` VALUES (2, 1, '2026-02-04 18:34:10', 1511.58, 4.03, 375.08);
INSERT INTO `ventas` VALUES (3, 1, '2026-02-04 19:32:13', 4759.80, 12.69, 375.08);
INSERT INTO `ventas` VALUES (4, 1, '2026-02-04 19:34:28', 611.38, 1.63, 375.08);
INSERT INTO `ventas` VALUES (5, 1, '2026-02-04 19:35:04', 731.41, 1.95, 375.08);
INSERT INTO `ventas` VALUES (6, 1, '2026-02-05 16:21:59', 607.07, 1.60, 378.46);
INSERT INTO `ventas` VALUES (7, 1, '2026-02-05 18:17:34', 737.99, 1.95, 378.46);
INSERT INTO `ventas` VALUES (8, 1, '2026-02-05 18:59:11', 870.45, 2.30, 378.46);
INSERT INTO `ventas` VALUES (9, 1, '2026-02-06 10:46:55', 495.44, 1.30, 381.11);
INSERT INTO `ventas` VALUES (15, 1, '2026-02-06 18:16:04', 396.35, 1.04, 381.11);
INSERT INTO `ventas` VALUES (14, 1, '2026-02-06 18:14:35', 1303.39, 3.42, 381.11);
INSERT INTO `ventas` VALUES (13, 1, '2026-02-06 18:09:12', 830.81, 2.18, 381.11);
INSERT INTO `ventas` VALUES (16, 1, '2026-02-06 18:20:17', 666.94, 1.75, 381.11);
INSERT INTO `ventas` VALUES (17, 1, '2026-02-06 20:29:32', 476.38, 1.25, 381.11);
INSERT INTO `ventas` VALUES (18, 1, '2026-02-06 20:31:42', 865.11, 2.27, 381.11);

-- ----------------------------
-- Table structure for whatsapp
-- ----------------------------
DROP TABLE IF EXISTS `whatsapp`;
CREATE TABLE `whatsapp`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `destinatario` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `mensaje` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `fecha` timestamp NULL DEFAULT current_timestamp,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of whatsapp
-- ----------------------------

-- ----------------------------
-- Table structure for whatsapp_enviado
-- ----------------------------
DROP TABLE IF EXISTS `whatsapp_enviado`;
CREATE TABLE `whatsapp_enviado`  (
  `id` int NOT NULL,
  `destinatario` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `mensaje` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `fecha_original` timestamp NULL DEFAULT NULL,
  `fecha_envio` timestamp NULL DEFAULT current_timestamp,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of whatsapp_enviado
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
