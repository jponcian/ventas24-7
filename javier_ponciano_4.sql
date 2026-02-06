/*
 Navicat Premium Dump SQL

 Source Server         : ZZ Miranda
 Source Server Type    : MySQL
 Source Server Version : 101114 (10.11.14-MariaDB-0+deb12u2)
 Source Host           : zz.com.ve:3306
 Source Schema         : javier_ponciano_4

 Target Server Type    : MySQL
 Target Server Version : 101114 (10.11.14-MariaDB-0+deb12u2)
 File Encoding         : 65001

 Date: 05/02/2026 11:01:24
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
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of abonos
-- ----------------------------

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
) ENGINE = MyISAM AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Fixed;

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
) ENGINE = MyISAM AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Fixed;

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
) ENGINE = MyISAM AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Fixed;

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
INSERT INTO `fiados` VALUES (12, 1, 12, 8789.74, 23.74, 23.74, 370.25, 'pendiente', '2026-02-04 21:14:50');

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
) ENGINE = MyISAM AUTO_INCREMENT = 370 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of productos
-- ----------------------------
INSERT INTO `productos` VALUES (1, 1, 2, 'QUESO', '', '', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 4.80, 7.00, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 1, NULL);
INSERT INTO `productos` VALUES (2, 1, 3, 'CLUB SOCIAL', '', '7590011205158', 'unidad', 6.00, 10.00, NULL, 0, 'USD', 1.58, 0.40, 2.15, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (63, 1, 4, 'GLUP 2LTS', '', '', 'unidad', 6.00, 8.00, NULL, 0, 'USD', 1.05, 1.37, 1.41, '2026-01-27 18:05:01', '2026-02-04 23:32:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (4, 1, 5, 'CATALINAS', NULL, NULL, 'unidad', 10.00, 10.00, NULL, 0, 'USD', 3.00, 0.40, 3.50, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (5, 1, 6, 'PAN SALADO', NULL, NULL, 'unidad', 1.00, 9.00, NULL, 0, 'USD', 0.80, 1.00, NULL, '2026-01-27 18:05:01', '2026-02-04 23:32:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (6, 1, 7, 'PAN CLINEJA', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.30, 1.60, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (300, 1, 8, 'HELADO YOGURT', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.40, 0.55, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (8, 1, 7, 'PAN RELLENO GUAYABA', NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 0.33, 0.45, 4.50, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (9, 1, 7, 'PAN COCO', NULL, NULL, 'paquete', 10.00, 10.00, NULL, 1, 'USD', 0.27, 0.40, 3.30, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (10, 1, 9, 'RIQUESA', '', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 0.00, 3.50, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (11, 1, 10, 'SALSA SOYA AJO INGLESA DOÑA TITA', '', '7597459000055', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 1.10, 1.43, 1.43, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (12, 1, 11, 'ACEITE VATEL', '', '7591049193035', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 5.00, 6.00, 6.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (13, 1, 3, 'SALSA PASTA UW 490GR', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 0.00, 2.95, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (14, 1, 4, 'ARROZ', '', '7590274000026', 'unidad', 24.00, 10.00, NULL, 0, 'USD', 1.38, 1.79, 1.79, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (15, 1, 1, 'HARINA PAN', NULL, NULL, 'paquete', 20.00, 10.00, NULL, 0, 'USD', 1.55, 1.94, 1.94, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (16, 1, 3, 'CARAMELO FREEGELLS', '', '7891151039673', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.23, 0.50, 0.50, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (17, 1, 3, 'HALLS', NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 0.46, 0.65, 0.65, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (339, 1, 3, 'GALLE LULU LIMON 175GR', '', '7591082000802', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.61, 2.01, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (19, 1, 10, 'TORONTO', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.65, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (20, 1, 10, 'CHOCOLATE SAVOY', '', '7591016851135', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 1.29, 1.70, 1.70, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (21, 1, 3, 'CHICLE GIGANTE', '', '8964001247173', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.55, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (22, 1, NULL, 'GALLETAS MALTN\'MILK', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.25, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (23, 1, 11, 'JABÓN PROTEX 110GR', NULL, NULL, 'paquete', 3.00, 10.00, NULL, 0, 'USD', 2.50, 3.25, 9.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (24, 1, 4, 'ESPONJAS', NULL, NULL, 'paquete', 2.00, 10.00, NULL, 1, 'USD', 0.60, 0.85, 0.85, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (25, 1, 4, 'FREGADOR', NULL, NULL, 'paquete', 15.00, 10.00, NULL, 0, 'USD', 0.37, 0.70, 0.70, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (26, 1, NULL, 'COCA-COLA 1.5LTS', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 1.60, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (28, 1, 9, 'GATORADE', '', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 0.00, 1.80, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (29, 1, 12, 'TOMATE', NULL, NULL, 'kg', 1.00, 10.00, NULL, 0, 'BS', 390.00, 550.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (30, 1, 12, 'CEBOLLA', NULL, NULL, 'kg', 1.00, 10.00, NULL, 0, 'BS', 380.00, 550.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (31, 1, 12, 'PAPA', NULL, NULL, 'kg', 1.00, 10.00, NULL, 0, 'BS', 380.00, 650.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (32, 1, 12, 'PLaTANO', '', '', 'kg', 1.00, 10.00, NULL, 0, 'BS', 700.00, 1040.00, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (33, 1, 13, 'LUCKY', '', '', 'paquete', 20.00, 10.00, NULL, 0, 'USD', 0.17, 0.25, 4.40, '2026-01-27 18:05:01', '2026-02-04 14:58:46', 0, 0, NULL);
INSERT INTO `productos` VALUES (34, 1, 13, 'BELTMONT', '', '75903169', 'paquete', 20.00, 10.00, NULL, 0, 'USD', 0.14, 0.22, 3.60, '2026-01-27 18:05:01', '2026-02-04 15:06:17', 0, 0, NULL);
INSERT INTO `productos` VALUES (35, 1, 13, 'PALLMALL', '', '', 'paquete', 20.00, -10.00, NULL, 0, 'USD', 0.14, 0.22, 3.60, '2026-01-27 18:05:01', '2026-02-05 12:28:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (37, 1, 13, 'UNIVERSAL', '', '', 'paquete', 20.00, 10.00, NULL, 0, 'USD', 0.09, 0.15, 2.35, '2026-01-27 18:05:01', '2026-02-04 14:58:46', 0, 0, NULL);
INSERT INTO `productos` VALUES (38, 1, 13, 'CONSUL', '', '75903206', 'paquete', 20.00, -17.00, NULL, 0, 'USD', 0.08, 0.13, 2.05, '2026-01-27 18:05:01', '2026-02-04 23:32:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (39, 1, 3, 'VELAS', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.25, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (283, 1, 1, 'JUGO JUCOSA', NULL, NULL, 'paquete', 3.00, 10.00, NULL, 0, 'USD', 0.53, 0.70, 2.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (42, 1, 4, 'LOPERAN', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.25, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (45, 1, 14, 'DICLOFENAC POTÁSICO', NULL, NULL, 'paquete', 30.00, 10.00, NULL, 0, 'USD', 0.03, 0.15, 0.15, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (44, 1, 4, 'DICLOFENAC SÓDICO', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.10, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (46, 1, 14, 'METOCLOPRAMIDA', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.35, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (47, 1, 14, 'IBUPROFENO', NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 0.12, 0.20, 0.20, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (48, 1, 14, 'LORATADINA', NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 0.15, 0.25, 0.25, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (49, 1, 14, 'CETIRIZINA', NULL, NULL, 'paquete', 20.00, 10.00, NULL, 0, 'USD', 0.05, 0.15, 0.15, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (50, 1, 14, 'ACETAMINOFÉN', NULL, NULL, 'paquete', 20.00, 10.00, NULL, 0, 'USD', 0.05, 0.15, 0.15, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (51, 1, 14, 'OMEPRAZOL', NULL, NULL, 'paquete', 28.00, 10.00, NULL, 0, 'USD', 0.11, 0.20, 0.20, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (52, 1, 14, 'AMOXICILINA', NULL, NULL, 'paquete', 10.00, 10.00, NULL, 1, 'USD', 0.22, 0.30, 0.30, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (53, 1, 14, 'METRONIDAZOL', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.20, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (54, 1, 4, 'GLUP 1 LT', '', '', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.74, 1.00, 1.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (55, 1, 4, 'GLUP 400ML', NULL, NULL, 'paquete', 15.00, 10.00, NULL, 0, 'USD', 0.39, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (56, 1, 9, 'MALTA DE BOTELLA', '', '', 'unidad', 36.00, 9.00, NULL, 1, 'USD', 16.38, 0.65, 0.65, '2026-01-27 18:05:01', '2026-02-04 23:35:04', 0, 0, NULL);
INSERT INTO `productos` VALUES (57, 1, 9, 'PEPSI-COLA 1.25LTS', '', '', 'unidad', 6.00, 10.00, NULL, 0, 'USD', 4.50, 1.00, 1.10, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (58, 1, 9, 'PEPSI-COLA 2LT', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 2.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (59, 1, 4, 'JUSTY', '', NULL, 'unidad', 1.00, 9.00, NULL, 0, 'USD', 0.00, 1.30, NULL, '2026-01-27 18:05:01', '2026-02-04 16:26:25', 0, 0, NULL);
INSERT INTO `productos` VALUES (60, 1, 4, 'COCA-COLA 2LTS', '', '7591127123626', 'unidad', 6.00, 10.00, NULL, 0, 'USD', 1.67, 2.20, 2.20, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (61, 1, 9, 'MALTA 1.5LTS', '', '', 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.64, 2.13, 2.15, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (62, 1, 3, 'JUGO FRICAJITA', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.99, 1.24, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (65, 1, NULL, 'COCA-COLA 1LT', '', NULL, 'paquete', 6.00, 10.00, NULL, 0, 'USD', 0.83, 1.10, 1.10, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (275, 1, 1, 'GOMITAS PLAY', NULL, NULL, 'paquete', 24.00, 10.00, NULL, 0, 'USD', 0.58, 0.90, 0.90, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (67, 1, 11, 'PAPEL NARANJA 400', NULL, NULL, 'paquete', 4.00, 10.00, NULL, 0, 'USD', 0.73, 1.10, 3.70, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (68, 1, 11, 'GALLETA MARIA ITALIA', '', '7597089000036', 'unidad', 9.00, 10.00, NULL, 0, 'USD', 0.06, 0.10, 0.90, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (69, 1, 15, 'CAFE AMANECER 100GR', '', '7595461001206', 'unidad', 10.00, 9.00, NULL, 1, 'USD', 1.30, 1.63, 1.63, '2026-01-27 18:05:01', '2026-02-04 23:34:28', 0, 0, NULL);
INSERT INTO `productos` VALUES (70, 1, 15, 'CARAOTAS AMANECER', '', '7599450000089', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.00, 1.35, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (71, 1, 15, 'PASTA LARGA NONNA', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.75, 0.95, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (72, 1, 15, 'PASTA CORTA NONNA', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.40, 2.10, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (73, 1, 16, 'DORITOS PEQ', '', '', 'paquete', 1.00, 10.00, NULL, 0, 'USD', 1.11, 1.40, 0.00, '2026-01-27 18:05:01', '2026-02-04 12:24:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (74, 1, 16, 'DORITOS DIN PEQ', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 1.20, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (75, 1, 16, 'DORITOS FH PEQ', '', NULL, 'unidad', 1.00, 9.00, NULL, 0, 'USD', 1.03, 1.30, 0.00, '2026-01-27 18:05:01', '2026-02-04 23:35:04', 0, 0, NULL);
INSERT INTO `productos` VALUES (76, 1, 16, 'DORITOS DIN FH PEQ', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 1.20, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (77, 1, 16, 'CHEESE TRIS P', '', '7591206003924', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.77, 1.00, 0.00, '2026-01-27 18:05:01', '2026-02-04 10:37:07', 0, 0, NULL);
INSERT INTO `productos` VALUES (78, 1, 16, 'PEPITO P', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 1.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (79, 1, 11, 'BOLI KRUCH', '', '7592708000336', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.37, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (80, 1, 11, 'KESITOS P', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.60, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (81, 1, 1, 'PIGSY PICANTE', NULL, NULL, 'paquete', 18.00, 10.00, NULL, 1, 'USD', 0.19, 0.40, 0.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (82, 1, 16, 'RAQUETY', '', NULL, 'unidad', 1.00, 8.00, NULL, 0, 'USD', 0.48, 0.65, 0.00, '2026-01-27 18:05:01', '2026-02-04 23:32:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (83, 1, 11, 'CHISKESITO PEQUEÑO', NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 0.61, 0.80, 0.70, '2026-01-27 18:05:01', '2026-02-04 12:24:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (84, 1, 3, 'CHIPS AHOY', '', '7590011138104', 'paquete', 6.00, 10.00, NULL, 0, 'USD', 0.06, 0.50, 2.75, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (85, 1, 1, 'COCO CRUCH', '', '7973593350896', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.40, 1.82, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (86, 1, 11, 'SALSERITOS GRANDES', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.61, 2.01, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (87, 1, 11, 'SALSERITOS PEQUEÑOS', NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 0.42, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (88, 1, 4, 'TOSTON TOM', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.45, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (89, 1, 3, 'MINI CHIPS', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.90, 2.30, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (90, 1, 3, 'NUCITA CRUNCH', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.48, 1.85, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (91, 1, 11, 'FLIPS PEQUEÑO', NULL, NULL, 'paquete', 6.00, 10.00, NULL, 0, 'USD', 0.56, 0.75, 0.80, '2026-01-27 18:05:01', '2026-02-04 12:24:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (92, 1, 11, 'FLIPS MEDIANO', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.84, 2.30, NULL, '2026-01-27 18:05:01', '2026-02-04 12:24:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (93, 1, 16, 'DORITOS G', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 3.30, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (95, 1, 16, 'DORITOS FH G', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 3.30, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (244, 1, 11, 'CHESITO P', '', '7592708001883', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.17, 0.40, 0.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (98, 1, 16, 'PEPITO G', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.10, 1.43, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (100, 1, 1, 'MAXCOCO', NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 0.78, 1.01, 1.01, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (101, 1, 3, 'CROC-CHOC', '', '7896383000811', 'unidad', 24.00, 10.00, NULL, 0, 'USD', 0.20, 0.40, 0.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (102, 1, 3, 'TRIDENT', NULL, NULL, 'paquete', 18.00, 10.00, NULL, 0, 'USD', 0.44, 0.65, 0.65, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (103, 1, 3, 'MINTY', NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 0.37, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (104, 1, 3, 'CHICLE GUDS', '', '7897190307834', 'unidad', 18.00, 10.00, NULL, 0, 'USD', 0.14, 0.30, 0.30, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (105, 1, 3, 'NUCITA TUBO', '', '7591675010102', 'unidad', 12.00, 10.00, NULL, 1, 'USD', 13.22, 1.43, 1.30, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (106, 1, 16, 'DANDY', '', '7702011040558', 'unidad', 16.00, 10.00, NULL, 1, 'USD', 0.63, 0.82, 0.60, '2026-01-27 18:05:01', '2026-02-04 10:34:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (107, 1, 3, 'OREO DE TUBO', '', '7622202213656', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.24, 1.65, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (108, 1, 3, 'OREO 6S', '', '7622202213779', 'unidad', 6.00, 10.00, NULL, 0, 'USD', 0.06, 0.50, 2.55, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (110, 1, 3, 'OREO FUDGE', '', '7622202228742', 'paquete', 6.00, 10.00, NULL, 0, 'USD', 0.07, 0.65, 3.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (111, 1, 3, 'TAKYTA 150GR', NULL, NULL, 'paquete', 8.00, 10.00, NULL, 0, 'USD', 0.10, 0.15, 1.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (112, 1, 3, 'OREO DE CAJA', NULL, NULL, 'paquete', 8.00, 10.00, NULL, 0, 'USD', 0.55, 0.75, 0.75, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (113, 1, 3, 'CHUPETA PIN PON', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.50, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (114, 1, 3, 'POLVO EXPLOSIVO', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.30, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (115, 1, 3, 'CHUPETA EXPLOSIVA', '', '745853860912', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.40, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (116, 1, 3, 'CHICLE DE YOYO', '', '745853860998', 'unidad', 24.00, 10.00, NULL, 0, 'USD', 0.32, 0.50, 0.50, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (118, 1, 3, 'PIRULIN', '', '7591675013042', 'unidad', 25.00, 10.00, NULL, 0, 'USD', 11.33, 0.65, 0.55, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (119, 1, 3, 'NUCITA', '', '75970109', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.43, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (120, 1, 1, 'BRINKY', NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 0.26, 0.50, 0.50, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (121, 1, 16, 'PEPITAS', '', '7591620010157', 'unidad', 18.00, 10.00, NULL, 0, 'USD', 0.33, 0.45, 0.45, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (122, 1, 16, 'PALITOS', '', '805579523116', 'unidad', 18.00, 10.00, NULL, 0, 'USD', 0.41, 0.55, 0.55, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (123, 1, 3, 'COLORETI', '', '7896383000422', 'unidad', 24.00, 10.00, NULL, 0, 'USD', 0.19, 0.40, 0.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (124, 1, 3, 'SPARKIES BUBBALOO', '', '7702133879494', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.40, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (125, 1, 3, 'EXTINTOR', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.95, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (126, 1, 3, 'CHUPETA DE ANILLOS', '', '659525562182', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.55, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (127, 1, 3, 'CRAYÓN CHICLE', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.25, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (128, 1, 3, 'COLORES CHICLE', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.45, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (129, 1, 3, 'CHUPETA DE MASCOTAS', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 1.30, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (130, 1, 3, 'SPINNER RING', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 1.30, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (131, 1, 3, 'JUGUETE DE POCETA', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.95, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (132, 1, 10, 'COCOSETE', '', '7591016871089', 'unidad', 18.00, 10.00, NULL, 0, 'USD', 1.15, 1.50, 1.50, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (286, 1, 10, 'CEPILLO DENTAL COLGATE', '', '6910021007206', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.11, 1.50, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (134, 1, 10, 'SAMBA', NULL, NULL, 'paquete', 20.00, 10.00, NULL, 0, 'USD', 1.04, 1.35, 1.35, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (135, 1, 10, 'SAMBA PEQUEÑA', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.65, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (136, 1, 11, 'FLIPS CAJA', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.17, 4.00, NULL, '2026-01-27 18:05:01', '2026-02-04 12:24:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (137, 1, 3, 'CORN FLAKES DE CAJA', '', '7591057001285', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.56, 3.20, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (138, 1, 11, 'CRONCH FLAKES BOLSA', '', '7591039100050', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.21, 4.01, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (139, 1, 11, 'FRUTY AROS', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 3.70, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (140, 1, 4, 'JUMBY RIKOS G', NULL, NULL, 'paquete', 18.00, 10.00, NULL, 0, 'USD', 0.78, 1.10, 1.10, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (141, 1, 11, 'CHISKESITO GRANDE', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.38, 1.85, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (142, 1, 11, 'CHESITO G', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.64, 0.85, NULL, '2026-01-27 18:05:01', '2026-02-04 12:24:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (143, 1, 4, 'DOBOM 400GR', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 5.90, 7.38, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (144, 1, 4, 'DOBOM 200GRS', '', '7891097102042', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 3.00, 3.75, 45.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (145, 1, 4, 'DOBOM 125GRS', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.00, 2.50, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (146, 1, 3, 'CAMPIÑA 200GR', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.14, 3.77, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (147, 1, 3, 'CAMPIÑA 125GRS', '', '7591014014747', 'unidad', 1.00, 10.00, NULL, 1, 'USD', 2.17, 2.70, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (148, 1, 11, 'LECHE UPACA', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.69, 2.20, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (149, 1, 3, 'LECHE INDOSA 200GR', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.10, 1.43, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (150, 1, 11, 'AVENA 200GR PANTERA', '', '7591794000558', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.83, 1.25, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (151, 1, 11, 'COMPOTA GRANDE', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.00, 1.30, NULL, '2026-01-27 18:05:01', '2026-02-04 12:24:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (152, 1, 11, 'COMPOTA PEQUEÑA', '', '75916084', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.79, 1.10, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (337, 1, 3, 'ELITE CHOC. TUBO 100GR', '', '7591082001366', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.95, 1.23, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (154, 1, 11, 'MAIZINA 90GR', '', '521439601526', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.82, 1.07, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (155, 1, 11, 'MAIZINA 120GR', '', '7591039770734', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.00, 1.30, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (156, 1, 10, 'SOPA MAGGY', NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 1.71, 2.22, 2.22, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (158, 1, 10, 'LECHE CONDENSADA', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.96, 3.55, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (159, 1, 4, 'BOKA', NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 0.40, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (160, 1, 4, 'PEGA LOKA', NULL, NULL, 'paquete', 42.00, 10.00, NULL, 0, 'USD', 0.34, 0.70, 0.70, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (161, 1, 17, 'BOMBILLO LED 10W', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.05, 1.31, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (164, 1, 11, 'CARAOTA PANTERA', '', 'https://granospantera.start.page', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.71, 2.20, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (165, 1, 27, 'CARAOTAS DON JUAN', '', '527455000244', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 1.00, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (166, 1, 11, 'CARAOTA BLANCA PANTERA', '', '7591794000442', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.02, 2.63, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (167, 1, 11, 'FRIJOL PANTERA', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 0.00, 1.50, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (168, 1, 11, 'ARVEJAS PANTERA', '', 'https://granospantera.start.page', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.60, 2.00, 2.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (169, 1, 11, 'MAÍZ DE COTUFAS', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.34, 1.65, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (170, 1, 15, 'CAFÉ AMANECER 200GR', '', '7595461000049', 'unidad', 6.00, 10.00, NULL, 1, 'USD', 2.41, 3.01, 3.01, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (171, 1, 11, 'CAFÉ FLOR ARAUCA', NULL, NULL, 'unidad', 1.00, 9.00, NULL, 0, 'USD', 2.85, 3.71, NULL, '2026-01-27 18:05:01', '2026-02-04 16:26:25', 0, 0, NULL);
INSERT INTO `productos` VALUES (172, 1, 11, 'CAFÉ ARAUCA 200GRS', '', '7596540000257', 'unidad', 1.00, 9.00, NULL, 1, 'USD', 2.78, 3.50, 0.00, '2026-01-27 18:05:01', '2026-02-05 12:28:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (173, 1, 11, 'CAFÉ ARAUCA 100GR', '', '7596540000264', 'unidad', 1.00, 9.00, NULL, 0, 'USD', 1.43, 1.75, 0.00, '2026-01-27 18:05:01', '2026-02-04 22:34:10', 0, 0, NULL);
INSERT INTO `productos` VALUES (174, 1, 11, 'CAFÉ ARAUCA 50GRS', '', '7596540001544', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.64, 0.90, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (260, 1, 10, 'SALSA DOÑA TITA PEQ', '', '7597459000680', 'unidad', 24.00, 10.00, NULL, 0, 'USD', 1.06, 1.40, 1.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (176, 1, 4, 'YOKOIMA 100GR', NULL, NULL, 'paquete', 10.00, -1.00, NULL, 0, 'USD', 1.35, 1.69, 1.69, '2026-01-27 18:05:01', '2026-02-05 12:28:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (177, 1, 15, 'FAVORITO 100GRS', '', '7595461000292', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 1.50, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (178, 1, 15, 'FAVORITO 50GRS', '', '7595461000315', 'unidad', 20.00, 10.00, NULL, 0, 'USD', 0.56, 0.73, 0.73, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (179, 1, 9, 'SALSA PAMPERO GR', '', '75919191', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 2.10, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (180, 1, 9, 'SALSA PAMPERO PEQ', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 1.45, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (181, 1, 11, 'SALSA TIQUIRE GR', '', '75919740', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 2.10, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (182, 1, 11, 'SALSA TIQUIRE PEQ', '', '75920531', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 1.45, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (183, 1, 10, 'SALSA DOÑA TITA GR', '', '1007400934293', 'unidad', 24.00, 10.00, NULL, 0, 'USD', 1.71, 2.14, 2.14, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (184, 1, 9, 'MAYONESA MAVESA PEQUEÑA', NULL, NULL, 'paquete', 24.00, 10.00, NULL, 0, 'USD', 2.04, 2.55, 2.55, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (185, 1, 3, 'MAYONESA KRAFF 175GR', '', '', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.97, 2.56, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (187, 1, 3, 'DIABLITOS 115GR', '', '7591072003622', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.71, 3.25, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (188, 1, 3, 'DIABLITOS 54GR', '', '7591072000027', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.58, 1.98, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (189, 1, 3, 'ATÚN AZUL SDLA', '', '7591072002342', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.98, 3.87, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (190, 1, 3, 'ATUN ROJO SDLA', '', '7591072002359', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.45, 4.14, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (191, 1, 4, 'SARDINA', NULL, '7595122001927', 'paquete', 24.00, 10.00, NULL, 0, 'USD', 0.73, 1.00, 1.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (192, 1, 11, 'VINAGRE DE MANZANA', '', '7591112000239', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 1.60, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (193, 1, 10, 'VINAGRE DOÑA TITA', '', '7597459000352', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.00, 1.55, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (194, 1, 11, 'VINAGRE TIQUIRE', '', '7591112049016', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.07, 1.40, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (195, 1, 4, 'ACEITE IDEAL 900ML', NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 3.28, 4.17, 4.17, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (196, 1, 4, 'ACEITE PAMPA 1/2LT', '', '7599959000016', 'unidad', 12.00, 9.00, NULL, 0, 'USD', 2.42, 3.20, 3.20, '2026-01-27 18:05:01', '2026-02-04 23:32:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (198, 1, 4, 'PASTA LARGA HORIZONTE', NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 2.14, 2.78, 2.78, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (199, 1, 4, 'PASTA HORIZONTE CORTA', NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 2.43, 3.15, 3.15, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (200, 1, 4, 'HARINA DE TRIGO', NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 1.16, 1.52, 1.52, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (201, 1, 11, 'AZÚCAR', NULL, '7597304223943', 'paquete', 20.00, 10.00, NULL, 0, 'USD', 1.50, 2.00, 2.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (202, 1, 1, 'SAL', '', '7593575001129', 'unidad', 25.00, 9.00, NULL, 0, 'USD', 0.34, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-04 23:32:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (203, 1, 4, 'DELINE DE 250GRS', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 1.50, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (204, 1, 9, 'NELLY DE 250GRS', NULL, NULL, 'paquete', 24.00, 10.00, NULL, 1, 'USD', 1.17, 1.60, 1.60, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (205, 1, 9, 'NELLY DE 500GRS', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 0.00, 2.70, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (206, 1, 9, 'MAVESA DE 250GRS', '', '', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.50, 1.90, 43.20, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (207, 1, 9, 'MAVESA DE 500GRS', '', '', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.69, 3.23, 2.60, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (208, 1, 1, 'HUEVOS', NULL, NULL, 'paquete', 30.00, 10.00, NULL, 0, 'USD', 0.22, 0.30, 8.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (209, 1, 18, 'MASA PASTELITO ROMY', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.80, 2.20, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (210, 1, 4, 'NUTRIBELLA', NULL, NULL, 'paquete', 12.00, 10.00, NULL, 1, 'USD', 0.65, 0.85, 0.85, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (211, 1, 10, 'DESODORANTE CLINICAL', '', '7501033210778', 'unidad', 20.00, 10.00, NULL, 0, 'USD', 0.45, 0.65, 0.65, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (212, 1, 4, 'DESODORANTE', '', '7501033206580', 'unidad', 18.00, 10.00, NULL, 0, 'USD', 0.43, 0.58, 0.58, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (213, 1, 4, 'SHAMPOO H&S', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 0.00, 0.60, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (214, 1, 1, 'BOLSAS NEGRAS', NULL, NULL, 'paquete', 25.00, 10.00, NULL, 0, 'USD', 0.34, 0.55, 0.55, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (215, 1, 10, 'AXION EN CREMA', '', '7509546694566', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.11, 2.74, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (346, 1, 3, 'MARSHMALLOWS NAVIDEÑO', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.95, 1.20, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (349, 1, 10, 'CUBITOS MAGGIE', '', '7591016205709', 'unidad', 250.00, 10.00, NULL, 0, 'USD', 0.20, 0.35, 0.35, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (217, 1, 10, 'COLGATE TOTAL', '', '7793100111143', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.10, 2.63, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (218, 1, 10, 'COLGATE PLAX', '', '7591083018547', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.25, 4.23, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (219, 1, 10, 'COLGATE TRIPLE ACCIÓN 60ML', '', '7702010111501', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.73, 2.16, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (220, 1, 10, 'COLGATE TRADICIONAL 90ML', '', '7891024134702', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 1.50, 1.88, 22.56, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (221, 1, 10, 'COLGATE NIÑOS', '', '7891024036075', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.60, 2.00, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (322, 1, 3, 'MARIA SELECTA', '', '7591082010016', 'paquete', 9.00, 10.00, NULL, 0, 'USD', 0.02, 0.25, 1.86, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (223, 1, 4, 'TOALLAS AZULES', NULL, NULL, 'paquete', 30.00, 10.00, NULL, 0, 'USD', 1.34, 1.70, 1.70, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (224, 1, 1, 'TOALLAS MORADAS', NULL, NULL, 'paquete', 30.00, 10.00, NULL, 1, 'USD', 0.98, 1.40, 1.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (225, 1, 19, 'JABÓN ESPECIAL', NULL, NULL, 'paquete', 50.00, 10.00, NULL, 0, 'USD', 0.80, 1.20, 1.20, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (226, 1, 4, 'JABÓN POPULAR', NULL, NULL, 'paquete', 72.00, 10.00, NULL, 0, 'USD', 0.80, 1.30, 1.30, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (227, 1, 9, 'JABÓN LAS LLAVES', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 1.30, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (228, 1, 3, 'JABÓN DE AVENA', '', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 0.00, 0.60, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (229, 1, 4, 'JABÓN HUGME', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.65, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (231, 1, 4, 'JABÓN LAK', NULL, NULL, 'paquete', 4.00, 10.00, NULL, 0, 'USD', 1.03, 1.50, 1.50, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (232, 1, 4, 'GELATINA CABELLO PEQ', NULL, NULL, 'paquete', 24.00, 10.00, NULL, 0, 'USD', 1.83, 2.40, 2.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (233, 1, 1, 'ACE ALIVE 1KG', '', '', 'unidad', 12.00, 10.00, NULL, 1, 'USD', 3.25, 4.23, 50.76, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (234, 1, 1, 'ACE ALIVE 500GRS', '', '7597597003017', 'unidad', 1.00, 10.00, NULL, 1, 'USD', 39.00, 2.15, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (235, 1, 1, 'ACE OSO BLANCO 400GRS', '', '6904542109563', 'unidad', 20.00, 10.00, NULL, 0, 'USD', 1.40, 1.82, 1.82, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (236, 1, 4, 'SUAVITEL', NULL, NULL, 'paquete', 12.00, 10.00, NULL, 1, 'USD', 0.66, 0.86, 0.86, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (237, 1, 4, 'CLORO LOFO 1LT', NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 1.00, 1.30, 1.30, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (238, 1, 4, 'AFEITADORA', '', '6950769302133', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.53, 0.75, 0.75, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (239, 1, 4, 'HOJILLAS', NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 0.60, 1.00, 1.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (240, 1, 20, 'LECHE 1LT LOS ANDES', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 2.15, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (285, 1, 1, 'APUREÑITO', NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 0.49, 0.75, 0.75, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (242, 1, 1, 'YESQUERO', '', '7703562035369', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 0.40, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (243, 1, NULL, 'TRIDENT INDIVIDUAL', NULL, NULL, 'paquete', 60.00, 10.00, NULL, 0, 'USD', 0.09, 0.15, 0.15, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (245, 1, 3, 'ATUN RICA DELI', '', '7591072002403', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.45, 2.94, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (246, 1, 3, 'SALSA PASTA UW 190GR', '', '7591072000263', 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.35, 1.70, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (247, 1, 3, 'SORBETICO PEQ', '', '7590011227105', 'unidad', 4.00, 10.00, NULL, 0, 'USD', 0.27, 0.40, 1.35, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (248, 1, 3, 'SORBETICO WAFER', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.17, 1.52, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (249, 1, 3, 'TANG', '', NULL, 'paquete', 15.00, 10.00, NULL, 0, 'USD', 0.43, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (250, 1, 3, 'CHICLE FREEGELLS', '', '7891151031189', 'unidad', 15.00, 10.00, NULL, 0, 'USD', 0.24, 0.40, 0.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (251, 1, 3, 'CHICLE TATTOO', NULL, NULL, 'paquete', 90.00, 10.00, NULL, 0, 'USD', 0.03, 0.07, 0.07, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (254, 1, 3, 'GALLETA MARIA MINI', '', '7592809000761', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.50, 0.70, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (256, 1, 1, 'COCO CRUCH', '', NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 1.20, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (257, 1, 16, 'CHEESE TRIS G', '', '7591206000381', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.66, 2.16, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (258, 1, 11, 'BOLI KRUNCH G', '', '7592708000343', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.85, 1.25, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (259, 1, 11, 'KESITOS G', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.89, 1.25, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (262, 1, 21, 'CHAKARO GDE', NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 0.67, 0.90, 0.90, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (261, 1, 22, 'DESINFECTANTE', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.78, 1.20, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (263, 1, 21, 'MANDADOR', NULL, NULL, 'paquete', 12.00, 10.00, NULL, 1, 'USD', 0.75, 1.00, 1.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (264, 1, 4, 'CHUPETA', NULL, NULL, 'paquete', 46.00, 10.00, NULL, 1, 'USD', 0.13, 0.20, 0.20, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (265, 1, 18, 'SALCHICHAS', NULL, NULL, 'kg', 1.00, 10.00, NULL, 0, 'USD', 4.05, 5.30, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (266, 1, 22, 'CLORO AAA', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.53, 1.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (267, 1, 22, 'LAVAPLATOS AAA', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.81, 2.35, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (268, 1, 22, 'LAVAPLATOS AA', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.38, 1.80, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (269, 1, 22, 'CLORO AA', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.48, 0.80, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (270, 1, 22, 'CERA BLANCA', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.87, 1.13, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (271, 1, 22, 'SUAVIZANTE', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.12, 1.65, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (272, 1, 22, 'DESENGRASANTE AAA', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.51, 2.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (329, 1, 17, 'BOMBILLO LED 20W', '', '6935787900165', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.86, 2.33, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (273, 1, 3, 'MARSHMALLOWS 100GR', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.02, 1.30, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (274, 1, 3, 'HUEVITO SORPRESA', NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 0.49, 0.70, 0.70, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (276, 1, 4, 'GALLETA SODA EL SOL', NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 0.16, 0.25, 2.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (277, 1, 4, 'YOKOIMA 50GR', NULL, NULL, 'paquete', 20.00, 10.00, NULL, 0, 'USD', 0.63, 0.81, 0.81, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (279, 1, 1, 'TIGRITO', NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 0.49, 0.75, 0.75, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (280, 1, 5, 'PLAQUITAS', NULL, NULL, 'paquete', 15.00, 10.00, NULL, 1, 'USD', 0.12, 0.17, 0.17, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (282, 1, 11, 'KETCHUP CAPRI 198GR', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.13, 1.41, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (284, 1, 9, 'ATUN MARGARITA', NULL, NULL, 'paquete', 35.00, 10.00, NULL, 1, 'USD', 1.90, 2.38, 2.38, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (287, 1, 1, 'HOJA EXAMEN', NULL, NULL, 'paquete', 50.00, 10.00, NULL, 1, 'USD', 0.05, 0.10, 0.10, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (288, 1, 3, 'BOMBONES CORAZON', '', '', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.65, 2.15, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (289, 1, 3, 'BOMBONES ROSA', '', '745853860783', 'unidad', 1.00, 10.00, NULL, 1, 'USD', 3.18, 3.90, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (290, 1, 3, 'NUCITA CRUNCH JR', NULL, NULL, 'paquete', 6.00, 10.00, NULL, 1, 'USD', 0.40, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (291, 1, 3, 'YOYO NEON', '', '659525562250', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.86, 1.15, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (292, 1, 3, 'GUSANITO LOCO', NULL, NULL, 'unidad', 30.00, 10.00, NULL, 0, 'USD', 0.66, 0.86, 25.80, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (293, 1, 3, 'ACONDICIONADOR SEDAL', '', '7702006207690', 'unidad', 12.00, 10.00, NULL, 1, 'USD', 0.34, 0.50, 0.50, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (294, 1, 18, 'JAMÓN', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.60, 2.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (295, 1, 18, 'QUESO AMARILLO', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.60, 2.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (296, 1, 16, 'RAQUETY G', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.83, 1.10, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (297, 1, 11, 'PAPEL AMARILLO 600', NULL, NULL, 'paquete', 4.00, 10.00, NULL, 0, 'USD', 1.00, 1.40, 5.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (298, 1, 3, 'COLORETI MINI', '', '7896383000033', 'unidad', 36.00, 10.00, NULL, 0, 'USD', 0.11, 0.20, 0.20, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (299, 1, 3, 'MENTITAS AMBROSOLI', NULL, NULL, 'paquete', 24.00, 10.00, NULL, 0, 'USD', 0.48, 0.70, 0.70, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (310, 1, 4, 'CARAMELOS', NULL, NULL, 'paquete', 100.00, 10.00, NULL, 0, 'USD', 0.03, 0.05, 0.05, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (301, 1, 8, 'BARQUILLON', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.00, 1.40, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (302, 1, 23, 'PALETA FRESH LIMON', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.28, 0.40, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (303, 1, 23, 'PALETA PASION YOGURT', NULL, NULL, 'unidad', 9.00, 10.00, NULL, 0, 'USD', 0.35, 0.50, 4.50, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (304, 1, 23, 'PALETA EXOTICO', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.35, 0.50, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (305, 1, 23, 'BARQUILLA SUPER CONO', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.82, 1.10, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (306, 1, 23, 'POLET FERRERO ROCHER', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.36, 2.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (307, 1, 23, 'POLET TRIPLE CAPITA', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.36, 2.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (308, 1, 23, 'POLET TRIPLE CAPITA COCO', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.36, 2.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (309, 1, 23, 'MAXI SANDWICH', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.82, 1.10, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (311, 1, 9, 'RIKESA 200GR', '', '75971939', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.47, 4.20, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (312, 1, 11, 'PAPEL ROJO 180', NULL, NULL, 'paquete', 4.00, 6.00, NULL, 0, 'USD', 0.29, 0.50, 1.48, '2026-01-27 18:05:01', '2026-02-04 23:32:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (313, 1, 11, 'PAPEL VERDE 215', NULL, NULL, 'paquete', 4.00, 10.00, NULL, 0, 'USD', 0.31, 0.60, 1.85, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (314, 1, 11, 'PAPEL MARRÓN 300', NULL, NULL, 'paquete', 4.00, 10.00, NULL, 0, 'USD', 0.60, 0.90, 3.10, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (315, 1, 15, 'CAFÉ NONNA 100GR', NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 1.30, 1.63, 1.63, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (316, 1, 11, 'LENTEJA PANTERA', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.72, 2.10, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (336, 1, 3, 'MINI MARILU TUBO 100GR', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.07, 1.39, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (318, 1, 10, 'MAYONESA TITA', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.62, 1.94, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (319, 1, 3, 'BOMBONES BEL', NULL, NULL, 'paquete', 50.00, 10.00, NULL, 0, 'USD', 0.08, 0.10, 0.10, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (338, 1, 3, 'ELITE VAINI TUBO 100GR', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.82, 1.07, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (323, 1, 3, 'MARILU TUBO 240GR', '', '7591082014007', 'unidad', 6.00, 10.00, NULL, 0, 'USD', 0.32, 0.50, 2.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (324, 1, 3, 'CARAMELO MIEL', NULL, NULL, 'paquete', 100.00, 10.00, NULL, 1, 'USD', 0.02, 0.05, 0.05, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (325, 1, 3, 'NUTTELINI', '', '7702011115232', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.29, 0.45, 0.45, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (330, 1, 10, 'CEPILLO DENTAL COLGATE NIÑO', '', '7509546074122', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.23, 1.60, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (327, 1, 11, 'BARRILETE', NULL, NULL, 'paquete', 50.00, 10.00, NULL, 0, 'USD', 0.06, 0.80, 0.80, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (328, 1, 1, 'FRUTYS', NULL, NULL, 'paquete', 12.00, 10.00, NULL, 0, 'USD', 1.04, 1.40, 1.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (341, 1, 3, 'GALLE MARILU CAJA', '', '7591082010221', 'unidad', 24.00, 10.00, NULL, 0, 'USD', 0.19, 0.30, 0.30, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (332, 1, 11, 'ACEITE COPOSA 850ML', '', '7591058001024', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.92, 4.90, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (331, 1, 10, 'JABÓN PROTEX 75GR', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.28, 1.66, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (333, 1, 24, 'RECARGA MOVISTAR', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'BS', 150.00, 190.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (334, 1, 24, 'RECARGA DIGITEL', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'BS', 160.00, 200.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (335, 1, 24, 'RECARGA MOVILNET', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 150.00, 185.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (340, 1, 3, 'GALLETA BROWNIE 175GR', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.55, 2.02, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (342, 1, 3, 'GALLE Q-KISS 200GR', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.63, 3.16, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (343, 1, 3, 'GALLETA REX 200GR', '', '7591082000574', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.26, 1.60, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (344, 1, 3, 'GALLETA LIMON 77GR', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.64, 0.83, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (345, 1, 3, 'GALLETA LIMON 90GR', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.88, 1.14, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (347, 1, 3, 'CHUPA POP SURTIDO', NULL, NULL, 'paquete', 24.00, 10.00, NULL, 0, 'USD', 0.13, 0.20, 0.20, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (348, 1, 3, 'TATTOO CHUPETA', NULL, NULL, 'paquete', 50.00, 10.00, NULL, 0, 'USD', 0.06, 0.10, 0.10, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (350, 1, 1, 'CREMA ALIDENT', '', '7597257001650', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 1.50, 1.95, 1.95, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (356, 1, 18, 'J. espalda con todo', '', '100400001567', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 6.80, 0.00, '2026-01-29 21:17:36', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (355, 1, 18, 'Carne Molida', '', '103004004392', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 8.00, 0.00, '2026-01-29 21:15:48', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (357, 1, 18, 'q. amarillo ortiz', '', '121002001748', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 1.74, 0.00, '2026-01-29 21:18:19', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (359, 1, 27, 'prueba', '', 'https://consultaqr.seniat.gob.ve/qr/459f8f1a-0f15-454a-b3df-1bddcf9638f4', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.00, 5.00, 0.00, '2026-02-02 12:52:17', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (360, 2, 2, 'QUESO (Prueba)', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 4.80, 7.00, NULL, '2026-02-02 14:09:15', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (361, 2, 3, 'CLUB SOCIAL (Prueba)', '', '7590011205158', 'unidad', 6.00, 10.00, NULL, 0, 'USD', 1.58, 0.40, 2.15, '2026-02-02 14:09:15', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (362, 2, 4, 'GLUP 2LTS (Prueba)', '', '', 'unidad', 6.00, 10.00, NULL, 0, 'USD', 1.05, 1.37, 1.41, '2026-02-02 14:09:15', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (363, 2, 5, 'CATALINAS (Prueba)', NULL, NULL, 'unidad', 10.00, 10.00, NULL, 0, 'USD', 3.00, 0.40, 3.50, '2026-02-02 14:09:15', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (364, 2, 6, 'PAN SALADO (Prueba)', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.80, 1.00, NULL, '2026-02-02 14:09:15', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (365, 2, 7, 'PAN CLINEJA (Prueba)', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.30, 1.60, NULL, '2026-02-02 14:09:15', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (366, 2, 8, 'HELADO YOGURT (Prueba)', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.40, 0.55, NULL, '2026-02-02 14:09:15', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (367, 2, 7, 'PAN RELLENO GUAYABA (Prueba)', NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 0.33, 0.45, 4.50, '2026-02-02 14:09:15', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (368, 2, 7, 'PAN COCO (Prueba)', NULL, NULL, 'paquete', 10.00, 10.00, NULL, 1, 'USD', 0.27, 0.40, 3.30, '2026-02-02 14:09:15', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (369, 2, 9, 'RIQUESA (Prueba)', '', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 0.00, 3.50, NULL, '2026-02-02 14:09:15', '2026-02-04 02:12:15', 0, 0, NULL);

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
) ENGINE = MyISAM AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

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
INSERT INTO `proveedores` VALUES (25, 2, 'seniat', NULL, NULL, '2026-01-29 13:13:56');
INSERT INTO `proveedores` VALUES (26, 2, 'Pan ', NULL, NULL, '2026-01-29 19:18:31');
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
INSERT INTO `user_negocios` VALUES (2, 1);
INSERT INTO `user_negocios` VALUES (4, 1);
INSERT INTO `user_negocios` VALUES (5, 2);
INSERT INTO `user_negocios` VALUES (6, 1);

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
) ENGINE = MyISAM AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (6, '31338532', '$2y$10$HJqK94WVEJk1ZAisyYtu0eQVdHCP6UqnlPk5YDfG02iQSDxayNMJC', '2026-01-29 10:46:55', 'Luna', 'admin', 1);
INSERT INTO `users` VALUES (2, '16912337', '$2y$10$HJqK94WVEJk1ZAisyYtu0eQVdHCP6UqnlPk5YDfG02iQSDxayNMJC', '2026-01-26 17:43:06', 'Javier Ponciano', 'superadmin', 1);
INSERT INTO `users` VALUES (4, '32616444', '$2y$10$HJqK94WVEJk1ZAisyYtu0eQVdHCP6UqnlPk5YDfG02iQSDxayNMJC', '2026-01-26 23:47:21', 'Adrian Ponciano', 'admin', 1);
INSERT INTO `users` VALUES (5, '123456789', '$2y$10$HJqK94WVEJk1ZAisyYtu0eQVdHCP6UqnlPk5YDfG02iQSDxayNMJC', '2026-01-27 02:00:48', 'Usuario Prueba', 'admin', 1);

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
) ENGINE = MyISAM AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of ventas
-- ----------------------------
INSERT INTO `ventas` VALUES (1, 1, '2026-02-04 16:26:25', 1879.16, 5.01, 375.08);
INSERT INTO `ventas` VALUES (2, 1, '2026-02-04 22:34:10', 1511.58, 4.03, 375.08);
INSERT INTO `ventas` VALUES (3, 1, '2026-02-04 23:32:13', 4759.80, 12.69, 375.08);
INSERT INTO `ventas` VALUES (4, 1, '2026-02-04 23:34:28', 611.38, 1.63, 375.08);
INSERT INTO `ventas` VALUES (5, 1, '2026-02-04 23:35:04', 731.41, 1.95, 375.08);

SET FOREIGN_KEY_CHECKS = 1;
