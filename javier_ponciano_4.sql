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

 Date: 12/02/2026 13:24:10
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
) ENGINE = MyISAM AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of abonos
-- ----------------------------
INSERT INTO `abonos` VALUES (1, 12, 8984.60, 23.74, NULL, '2026-02-05 22:52:40');
INSERT INTO `abonos` VALUES (2, 8, 4007.90, 10.31, NULL, '2026-02-11 13:21:52');

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
) ENGINE = MyISAM AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

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
INSERT INTO `clientes` VALUES (9, 1, 'Yohana', NULL, '04243663181', NULL, 12.40, '2026-02-04 21:14:03', '2026-02-07 03:33:13');
INSERT INTO `clientes` VALUES (10, 1, 'Regina', NULL, '', NULL, 12.82, '2026-02-04 21:14:03', '2026-02-04 21:14:03');
INSERT INTO `clientes` VALUES (12, 1, 'Noel Brizuela', NULL, NULL, NULL, 23.74, '2026-02-04 21:14:50', '2026-02-04 21:30:22');
INSERT INTO `clientes` VALUES (13, 1, 'Noél Ortiz', NULL, NULL, NULL, 9.67, '2026-02-07 21:31:11', '2026-02-08 00:14:43');
INSERT INTO `clientes` VALUES (15, 1, 'Carlos Calderón', NULL, NULL, NULL, 0.00, '2026-02-07 21:32:35', '2026-02-07 23:35:02');
INSERT INTO `clientes` VALUES (16, 1, 'Julio Medina', NULL, '04141476580', NULL, 1.50, '2026-02-07 23:29:09', '2026-02-07 23:29:09');

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
  `es_paquete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Indica si la venta fue por paquete (1) o unidad (0)',
  `precio_unitario_bs` decimal(10, 2) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `venta_id`(`venta_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 191 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of detalle_ventas
-- ----------------------------
INSERT INTO `detalle_ventas` VALUES (1, 1, 171, 1.00, 0, 1391.56);
INSERT INTO `detalle_ventas` VALUES (2, 1, 59, 1.00, 0, 487.61);
INSERT INTO `detalle_ventas` VALUES (3, 2, 173, 1.00, 0, 656.39);
INSERT INTO `detalle_ventas` VALUES (4, 2, 38, 7.00, 0, 48.76);
INSERT INTO `detalle_ventas` VALUES (5, 2, 63, 1.00, 0, 513.86);
INSERT INTO `detalle_ventas` VALUES (6, 3, 196, 1.00, 0, 1200.26);
INSERT INTO `detalle_ventas` VALUES (7, 3, 38, 1.00, 1, 768.92);
INSERT INTO `detalle_ventas` VALUES (8, 3, 63, 1.00, 0, 513.86);
INSERT INTO `detalle_ventas` VALUES (9, 3, 5, 1.00, 0, 375.08);
INSERT INTO `detalle_ventas` VALUES (10, 3, 312, 1.00, 1, 555.12);
INSERT INTO `detalle_ventas` VALUES (11, 3, 82, 2.00, 0, 243.80);
INSERT INTO `detalle_ventas` VALUES (12, 3, 202, 1.00, 0, 225.05);
INSERT INTO `detalle_ventas` VALUES (13, 3, 176, 1.00, 1, 633.89);
INSERT INTO `detalle_ventas` VALUES (14, 4, 69, 1.00, 0, 611.38);
INSERT INTO `detalle_ventas` VALUES (15, 5, 75, 1.00, 0, 487.61);
INSERT INTO `detalle_ventas` VALUES (16, 5, 56, 1.00, 0, 243.80);
INSERT INTO `detalle_ventas` VALUES (17, 6, 333, 2.00, 0, 190.00);
INSERT INTO `detalle_ventas` VALUES (18, 6, 249, 1.00, 0, 227.07);
INSERT INTO `detalle_ventas` VALUES (19, 7, 173, 1.00, 0, 662.30);
INSERT INTO `detalle_ventas` VALUES (20, 7, 264, 1.00, 0, 75.69);
INSERT INTO `detalle_ventas` VALUES (21, 8, 56, 1.00, 0, 246.00);
INSERT INTO `detalle_ventas` VALUES (22, 8, 107, 1.00, 0, 624.46);
INSERT INTO `detalle_ventas` VALUES (23, 9, 226, 1.00, 0, 495.44);
INSERT INTO `detalle_ventas` VALUES (29, 14, 38, 1.00, 1, 781.27);
INSERT INTO `detalle_ventas` VALUES (28, 13, 38, 1.00, 1, 781.27);
INSERT INTO `detalle_ventas` VALUES (27, 13, 38, 1.00, 0, 49.54);
INSERT INTO `detalle_ventas` VALUES (30, 14, 63, 1.00, 0, 522.12);
INSERT INTO `detalle_ventas` VALUES (31, 15, 38, 8.00, 0, 49.54);
INSERT INTO `detalle_ventas` VALUES (32, 16, 122, 2.00, 0, 209.61);
INSERT INTO `detalle_ventas` VALUES (33, 16, 102, 1.00, 0, 247.72);
INSERT INTO `detalle_ventas` VALUES (34, 17, 79, 1.00, 0, 228.66);
INSERT INTO `detalle_ventas` VALUES (35, 17, 56, 1.00, 0, 247.72);
INSERT INTO `detalle_ventas` VALUES (36, 18, 63, 1.00, 0, 522.12);
INSERT INTO `detalle_ventas` VALUES (37, 18, 275, 1.00, 0, 343.00);
INSERT INTO `detalle_ventas` VALUES (38, 19, 244, 2.00, 0, 153.05);
INSERT INTO `detalle_ventas` VALUES (39, 19, 63, 1.00, 0, 524.21);
INSERT INTO `detalle_ventas` VALUES (40, 19, 51, 4.00, 0, 76.53);
INSERT INTO `detalle_ventas` VALUES (41, 19, 5, 3.00, 0, 382.63);
INSERT INTO `detalle_ventas` VALUES (42, 19, 111, 5.00, 0, 57.39);
INSERT INTO `detalle_ventas` VALUES (43, 19, 249, 1.00, 0, 229.58);
INSERT INTO `detalle_ventas` VALUES (44, 20, 269, 0.50, 0, 306.11);
INSERT INTO `detalle_ventas` VALUES (45, 20, 271, 0.50, 0, 631.34);
INSERT INTO `detalle_ventas` VALUES (46, 21, 234, 1.00, 0, 822.66);
INSERT INTO `detalle_ventas` VALUES (47, 21, 227, 1.00, 0, 497.42);
INSERT INTO `detalle_ventas` VALUES (48, 21, 33, 2.00, 0, 95.66);
INSERT INTO `detalle_ventas` VALUES (49, 22, 63, 1.00, 0, 524.21);
INSERT INTO `detalle_ventas` VALUES (50, 22, 140, 1.00, 0, 420.89);
INSERT INTO `detalle_ventas` VALUES (51, 23, 171, 1.00, 0, 1419.56);
INSERT INTO `detalle_ventas` VALUES (52, 23, 38, 1.00, 1, 784.40);
INSERT INTO `detalle_ventas` VALUES (53, 23, 15, 1.00, 0, 742.31);
INSERT INTO `detalle_ventas` VALUES (54, 23, 208, 4.00, 0, 114.79);
INSERT INTO `detalle_ventas` VALUES (55, 23, 206, 1.00, 0, 727.00);
INSERT INTO `detalle_ventas` VALUES (56, 23, 279, 1.00, 0, 286.97);
INSERT INTO `detalle_ventas` VALUES (57, 24, 4, 1.00, 0, 153.05);
INSERT INTO `detalle_ventas` VALUES (58, 24, 348, 2.00, 0, 38.26);
INSERT INTO `detalle_ventas` VALUES (68, 28, 63, 1.00, 0, 524.21);
INSERT INTO `detalle_ventas` VALUES (67, 28, 38, 1.00, 1, 784.40);
INSERT INTO `detalle_ventas` VALUES (66, 27, 208, 3.00, 0, 114.79);
INSERT INTO `detalle_ventas` VALUES (65, 27, 69, 1.00, 0, 623.69);
INSERT INTO `detalle_ventas` VALUES (64, 26, 33, 1.00, 1, 1683.58);
INSERT INTO `detalle_ventas` VALUES (69, 29, 38, 1.00, 1, 784.40);
INSERT INTO `detalle_ventas` VALUES (70, 29, 249, 1.00, 0, 229.58);
INSERT INTO `detalle_ventas` VALUES (71, 30, 63, 1.00, 0, 524.21);
INSERT INTO `detalle_ventas` VALUES (72, 30, 119, 1.00, 0, 229.58);
INSERT INTO `detalle_ventas` VALUES (73, 31, 38, 5.00, 0, 49.74);
INSERT INTO `detalle_ventas` VALUES (74, 32, 211, 2.00, 0, 248.71);
INSERT INTO `detalle_ventas` VALUES (75, 33, 1, 0.13, 0, 2885.04);
INSERT INTO `detalle_ventas` VALUES (76, 34, 2804, 1.00, 0, 1733.72);
INSERT INTO `detalle_ventas` VALUES (77, 35, 2131, 1.00, 0, 577.91);
INSERT INTO `detalle_ventas` VALUES (78, 36, 2368, 1.00, 0, 500.85);
INSERT INTO `detalle_ventas` VALUES (79, 37, 2505, 2.00, 0, 1849.31);
INSERT INTO `detalle_ventas` VALUES (80, 38, 298, 2.00, 0, 77.05);
INSERT INTO `detalle_ventas` VALUES (81, 38, 59, 1.00, 0, 500.85);
INSERT INTO `detalle_ventas` VALUES (82, 38, 202, 1.00, 0, 231.16);
INSERT INTO `detalle_ventas` VALUES (83, 39, 115, 1.00, 0, 154.11);
INSERT INTO `detalle_ventas` VALUES (84, 39, 211, 1.00, 0, 250.43);
INSERT INTO `detalle_ventas` VALUES (85, 40, 4, 1.00, 0, 154.11);
INSERT INTO `detalle_ventas` VALUES (86, 40, 116, 1.00, 0, 192.64);
INSERT INTO `detalle_ventas` VALUES (87, 40, 63, 1.00, 0, 527.82);
INSERT INTO `detalle_ventas` VALUES (88, 41, 2146, 1.00, 0, 462.33);
INSERT INTO `detalle_ventas` VALUES (89, 41, 2617, 1.00, 0, 2465.74);
INSERT INTO `detalle_ventas` VALUES (90, 42, 2022, 1.00, 0, 2234.58);
INSERT INTO `detalle_ventas` VALUES (91, 42, 2347, 1.00, 0, 1232.87);
INSERT INTO `detalle_ventas` VALUES (92, 43, 2804, 1.00, 0, 1733.72);
INSERT INTO `detalle_ventas` VALUES (93, 44, 2145, 1.00, 0, 693.49);
INSERT INTO `detalle_ventas` VALUES (94, 45, 313, 2.00, 0, 231.16);
INSERT INTO `detalle_ventas` VALUES (95, 46, 101, 3.00, 0, 154.11);
INSERT INTO `detalle_ventas` VALUES (96, 46, 63, 1.00, 0, 527.82);
INSERT INTO `detalle_ventas` VALUES (97, 47, 2145, 1.00, 0, 693.49);
INSERT INTO `detalle_ventas` VALUES (98, 48, 2075, 1.00, 0, 1464.03);
INSERT INTO `detalle_ventas` VALUES (99, 48, 2096, 1.00, 0, 654.96);
INSERT INTO `detalle_ventas` VALUES (100, 48, 2120, 1.00, 0, 539.38);
INSERT INTO `detalle_ventas` VALUES (101, 48, 2161, 1.00, 0, 3775.67);
INSERT INTO `detalle_ventas` VALUES (102, 48, 2162, 1.00, 0, 2735.43);
INSERT INTO `detalle_ventas` VALUES (103, 48, 2186, 1.00, 0, 6857.84);
INSERT INTO `detalle_ventas` VALUES (104, 48, 2200, 1.00, 0, 1078.76);
INSERT INTO `detalle_ventas` VALUES (105, 48, 2233, 1.00, 0, 1887.83);
INSERT INTO `detalle_ventas` VALUES (106, 48, 2256, 1.00, 0, 2003.41);
INSERT INTO `detalle_ventas` VALUES (107, 48, 2325, 1.00, 0, 3583.03);
INSERT INTO `detalle_ventas` VALUES (108, 48, 2378, 1.00, 0, 539.38);
INSERT INTO `detalle_ventas` VALUES (109, 48, 2411, 1.00, 0, 385.27);
INSERT INTO `detalle_ventas` VALUES (110, 48, 2458, 1.00, 0, 4815.90);
INSERT INTO `detalle_ventas` VALUES (111, 48, 2497, 1.00, 0, 886.13);
INSERT INTO `detalle_ventas` VALUES (112, 48, 2504, 2.00, 0, 1117.29);
INSERT INTO `detalle_ventas` VALUES (113, 48, 2518, 2.00, 0, 1040.23);
INSERT INTO `detalle_ventas` VALUES (114, 48, 2561, 1.00, 0, 924.65);
INSERT INTO `detalle_ventas` VALUES (115, 48, 2600, 1.00, 0, 1155.82);
INSERT INTO `detalle_ventas` VALUES (116, 48, 2608, 1.00, 0, 732.02);
INSERT INTO `detalle_ventas` VALUES (117, 48, 2610, 1.00, 0, 308.22);
INSERT INTO `detalle_ventas` VALUES (118, 48, 2672, 1.00, 0, 385.27);
INSERT INTO `detalle_ventas` VALUES (119, 48, 2691, 1.00, 0, 154.11);
INSERT INTO `detalle_ventas` VALUES (120, 48, 2700, 1.00, 0, 500.85);
INSERT INTO `detalle_ventas` VALUES (121, 48, 2705, 1.00, 0, 385.27);
INSERT INTO `detalle_ventas` VALUES (122, 48, 2804, 1.00, 0, 1733.72);
INSERT INTO `detalle_ventas` VALUES (123, 49, 234, 1.00, 0, 693.49);
INSERT INTO `detalle_ventas` VALUES (124, 50, 2804, 1.00, 0, 1749.33);
INSERT INTO `detalle_ventas` VALUES (125, 51, 2092, 1.00, 0, 855.23);
INSERT INTO `detalle_ventas` VALUES (126, 52, 2588, 1.00, 0, 1749.33);
INSERT INTO `detalle_ventas` VALUES (127, 53, 349, 1.00, 0, 136.06);
INSERT INTO `detalle_ventas` VALUES (128, 53, 15, 1.00, 0, 719.17);
INSERT INTO `detalle_ventas` VALUES (129, 54, 2446, 1.00, 0, 738.60);
INSERT INTO `detalle_ventas` VALUES (130, 55, 2498, 1.00, 0, 894.10);
INSERT INTO `detalle_ventas` VALUES (131, 58, 2365, 1.00, 0, 116.62);
INSERT INTO `detalle_ventas` VALUES (132, 59, 2632, 1.00, 0, 3965.14);
INSERT INTO `detalle_ventas` VALUES (133, 60, 2501, 1.00, 0, 816.35);
INSERT INTO `detalle_ventas` VALUES (134, 64, 2092, 1.00, 0, 855.23);
INSERT INTO `detalle_ventas` VALUES (135, 64, 2192, 1.00, 0, 9135.38);
INSERT INTO `detalle_ventas` VALUES (136, 65, 2338, 1.00, 0, 427.61);
INSERT INTO `detalle_ventas` VALUES (137, 66, 2337, 1.00, 0, 388.74);
INSERT INTO `detalle_ventas` VALUES (138, 67, 2145, 1.00, 0, 699.73);
INSERT INTO `detalle_ventas` VALUES (139, 68, 2467, 1.00, 0, 894.10);
INSERT INTO `detalle_ventas` VALUES (140, 69, 63, 1.00, 0, 532.57);
INSERT INTO `detalle_ventas` VALUES (141, 69, 5, 1.00, 0, 388.74);
INSERT INTO `detalle_ventas` VALUES (142, 70, 2724, 1.00, 0, 388.74);
INSERT INTO `detalle_ventas` VALUES (143, 71, 2631, 1.00, 0, 3459.78);
INSERT INTO `detalle_ventas` VALUES (144, 71, 2705, 1.00, 0, 388.74);
INSERT INTO `detalle_ventas` VALUES (145, 71, 2726, 1.00, 0, 505.36);
INSERT INTO `detalle_ventas` VALUES (146, 72, 2837, 1.00, 0, 3071.04);
INSERT INTO `detalle_ventas` VALUES (147, 73, 2145, 1.00, 0, 699.73);
INSERT INTO `detalle_ventas` VALUES (148, 74, 2744, 1.00, 0, 1516.08);
INSERT INTO `detalle_ventas` VALUES (149, 75, 122, 1.00, 0, 213.81);
INSERT INTO `detalle_ventas` VALUES (150, 75, 5, 1.00, 0, 388.74);
INSERT INTO `detalle_ventas` VALUES (151, 76, 79, 1.00, 0, 233.24);
INSERT INTO `detalle_ventas` VALUES (152, 76, 104, 1.00, 0, 116.62);
INSERT INTO `detalle_ventas` VALUES (153, 76, 251, 3.00, 0, 27.21);
INSERT INTO `detalle_ventas` VALUES (154, 76, 121, 1.00, 0, 174.93);
INSERT INTO `detalle_ventas` VALUES (155, 76, 1, 0.19, 0, 2931.10);
INSERT INTO `detalle_ventas` VALUES (156, 77, 2023, 4.00, 0, 2254.69);
INSERT INTO `detalle_ventas` VALUES (157, 77, 2073, 4.00, 0, 3265.41);
INSERT INTO `detalle_ventas` VALUES (158, 77, 2040, 1.00, 0, 11584.43);
INSERT INTO `detalle_ventas` VALUES (159, 77, 2092, 1.00, 0, 855.23);
INSERT INTO `detalle_ventas` VALUES (160, 77, 2115, 1.00, 0, 8513.39);
INSERT INTO `detalle_ventas` VALUES (161, 77, 2125, 1.00, 0, 1360.59);
INSERT INTO `detalle_ventas` VALUES (162, 77, 2131, 1.00, 0, 583.11);
INSERT INTO `detalle_ventas` VALUES (163, 77, 2313, 1.00, 0, 971.85);
INSERT INTO `detalle_ventas` VALUES (164, 77, 2338, 1.00, 0, 427.61);
INSERT INTO `detalle_ventas` VALUES (165, 77, 2364, 1.00, 0, 1554.96);
INSERT INTO `detalle_ventas` VALUES (166, 77, 2368, 2.00, 0, 505.36);
INSERT INTO `detalle_ventas` VALUES (167, 77, 2447, 1.00, 0, 894.10);
INSERT INTO `detalle_ventas` VALUES (168, 77, 2427, 1.00, 0, 699.73);
INSERT INTO `detalle_ventas` VALUES (169, 77, 2487, 1.00, 0, 349.87);
INSERT INTO `detalle_ventas` VALUES (170, 77, 2497, 1.00, 0, 894.10);
INSERT INTO `detalle_ventas` VALUES (171, 77, 2521, 1.00, 0, 583.11);
INSERT INTO `detalle_ventas` VALUES (172, 77, 2567, 1.00, 0, 1749.33);
INSERT INTO `detalle_ventas` VALUES (173, 77, 2600, 1.00, 0, 1166.22);
INSERT INTO `detalle_ventas` VALUES (174, 77, 2671, 1.00, 0, 1554.96);
INSERT INTO `detalle_ventas` VALUES (175, 77, 2606, 1.00, 0, 660.86);
INSERT INTO `detalle_ventas` VALUES (176, 77, 2616, 1.00, 0, 2526.81);
INSERT INTO `detalle_ventas` VALUES (177, 77, 2667, 1.00, 0, 2371.31);
INSERT INTO `detalle_ventas` VALUES (178, 77, 2691, 2.00, 0, 155.50);
INSERT INTO `detalle_ventas` VALUES (179, 77, 2721, 1.00, 0, 2138.07);
INSERT INTO `detalle_ventas` VALUES (180, 77, 2705, 1.00, 0, 388.74);
INSERT INTO `detalle_ventas` VALUES (181, 77, 2714, 1.00, 0, 505.36);
INSERT INTO `detalle_ventas` VALUES (182, 77, 2832, 1.00, 0, 427.61);
INSERT INTO `detalle_ventas` VALUES (183, 78, 2365, 1.00, 0, 117.09);
INSERT INTO `detalle_ventas` VALUES (184, 78, 2510, 1.00, 0, 1366.03);
INSERT INTO `detalle_ventas` VALUES (185, 79, 2471, 1.00, 0, 1873.41);
INSERT INTO `detalle_ventas` VALUES (186, 80, 2116, 1.00, 0, 1873.41);
INSERT INTO `detalle_ventas` VALUES (187, 80, 2733, 1.00, 0, 390.29);
INSERT INTO `detalle_ventas` VALUES (188, 81, 2023, 1.00, 0, 2263.71);
INSERT INTO `detalle_ventas` VALUES (189, 82, 63, 1.00, 0, 534.70);
INSERT INTO `detalle_ventas` VALUES (190, 83, 2431, 1.00, 0, 702.53);

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
) ENGINE = MyISAM AUTO_INCREMENT = 48 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Fixed;

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
INSERT INTO `fiado_detalles` VALUES (20, 16, 189, 1.000, 1480.79, 3.87, 1480.79, 3.87);
INSERT INTO `fiado_detalles` VALUES (21, 16, 69, 1.000, 623.69, 1.63, 623.69, 1.63);
INSERT INTO `fiado_detalles` VALUES (22, 16, 138, 1.000, 1534.35, 4.01, 1534.35, 4.01);
INSERT INTO `fiado_detalles` VALUES (23, 16, 63, 1.000, 524.21, 1.37, 524.21, 1.37);
INSERT INTO `fiado_detalles` VALUES (24, 17, 201, 1.000, 765.26, 2.00, 765.26, 2.00);
INSERT INTO `fiado_detalles` VALUES (25, 17, 35, 1.000, 1377.47, 3.60, 1377.47, 3.60);
INSERT INTO `fiado_detalles` VALUES (26, 20, 171, 1.000, 1419.56, 3.71, 1419.56, 3.71);
INSERT INTO `fiado_detalles` VALUES (27, 20, 35, 1.000, 1377.47, 3.60, 1377.47, 3.60);
INSERT INTO `fiado_detalles` VALUES (28, 20, 277, 1.000, 309.93, 0.81, 309.93, 0.81);
INSERT INTO `fiado_detalles` VALUES (29, 21, 234, 1.000, 688.74, 1.80, 688.74, 1.80);
INSERT INTO `fiado_detalles` VALUES (30, 21, 14, 1.000, 684.91, 1.79, 684.91, 1.79);
INSERT INTO `fiado_detalles` VALUES (31, 21, 168, 1.000, 765.26, 2.00, 765.26, 2.00);
INSERT INTO `fiado_detalles` VALUES (32, 21, 4, 3.000, 153.05, 0.40, 459.16, 1.20);
INSERT INTO `fiado_detalles` VALUES (33, 21, 63, 1.000, 524.21, 1.37, 524.21, 1.37);
INSERT INTO `fiado_detalles` VALUES (34, 21, 15, 1.000, 707.87, 1.85, 707.87, 1.85);
INSERT INTO `fiado_detalles` VALUES (35, 21, 208, 5.000, 114.79, 0.30, 573.95, 1.50);
INSERT INTO `fiado_detalles` VALUES (36, 21, 35, 4.000, 1377.47, 3.60, 5509.90, 14.40);
INSERT INTO `fiado_detalles` VALUES (37, 21, 1, 0.200, 2885.04, 7.54, 577.01, 1.51);
INSERT INTO `fiado_detalles` VALUES (38, 21, 29, 0.200, 550.00, 1.44, 110.00, 0.29);
INSERT INTO `fiado_detalles` VALUES (39, 22, 50, 2.000, 57.39, 0.15, 114.79, 0.30);
INSERT INTO `fiado_detalles` VALUES (40, 22, 15, 1.000, 707.87, 1.85, 707.87, 1.85);
INSERT INTO `fiado_detalles` VALUES (41, 22, 208, 5.000, 114.79, 0.30, 573.95, 1.50);
INSERT INTO `fiado_detalles` VALUES (42, 23, 35, 2.000, 1386.98, 3.60, 2773.96, 7.20);
INSERT INTO `fiado_detalles` VALUES (43, 23, 191, 1.000, 385.27, 1.00, 385.27, 1.00);
INSERT INTO `fiado_detalles` VALUES (44, 23, 39, 2.000, 96.32, 0.25, 192.64, 0.50);
INSERT INTO `fiado_detalles` VALUES (45, 24, 34, 1.000, 1386.98, 3.60, 1386.98, 3.60);
INSERT INTO `fiado_detalles` VALUES (46, 24, 242, 1.000, 154.11, 0.40, 154.11, 0.40);
INSERT INTO `fiado_detalles` VALUES (47, 25, 57, 1.000, 385.27, 1.00, 385.27, 1.00);

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
  `venta_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `negocio_id`(`negocio_id`) USING BTREE,
  INDEX `cliente_id`(`cliente_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of fiados
-- ----------------------------
INSERT INTO `fiados` VALUES (1, 1, 2, 13844.11, 37.26, 37.26, 372.11, 'pendiente', '2026-02-03 15:46:42', NULL);
INSERT INTO `fiados` VALUES (2, 1, 1, 25480.61, 68.82, 68.82, 372.11, 'pendiente', '2026-02-03 22:46:47', NULL);
INSERT INTO `fiados` VALUES (3, 1, 3, 25702.75, 69.42, 69.42, 370.25, 'pendiente', '2026-02-04 21:09:53', NULL);
INSERT INTO `fiados` VALUES (4, 1, 4, 114436.87, 309.08, 309.08, 370.25, 'pendiente', '2026-02-04 21:09:53', NULL);
INSERT INTO `fiados` VALUES (5, 1, 5, 4154.20, 11.22, 11.22, 370.25, 'pendiente', '2026-02-04 21:09:53', NULL);
INSERT INTO `fiados` VALUES (6, 1, 6, 100989.40, 272.76, 272.76, 370.25, 'pendiente', '2026-02-04 21:09:53', NULL);
INSERT INTO `fiados` VALUES (7, 1, 7, 18290.35, 49.40, 49.40, 370.25, 'pendiente', '2026-02-04 21:14:03', NULL);
INSERT INTO `fiados` VALUES (8, 1, 8, 3817.28, 10.31, 0.00, 370.25, 'pagado', '2026-02-04 21:14:03', NULL);
INSERT INTO `fiados` VALUES (9, 1, 9, 4591.10, 12.40, 12.40, 370.25, 'pendiente', '2026-02-04 21:14:03', NULL);
INSERT INTO `fiados` VALUES (10, 1, 10, 4746.60, 12.82, 12.82, 370.25, 'pendiente', '2026-02-04 21:14:03', NULL);
INSERT INTO `fiados` VALUES (13, 1, 7, 3326.65, 8.79, 8.79, 378.46, 'pendiente', '2026-02-05 12:28:57', NULL);
INSERT INTO `fiados` VALUES (12, 1, 12, 8789.74, 23.74, 0.00, 370.25, 'pagado', '2026-02-04 21:14:50', NULL);
INSERT INTO `fiados` VALUES (14, 1, 7, 1600.65, 4.20, 4.20, 381.11, 'pendiente', '2026-02-06 13:00:12', NULL);
INSERT INTO `fiados` VALUES (15, 1, 9, 1444.40, 3.79, 3.79, 381.11, 'pendiente', '2026-02-06 16:27:36', NULL);
INSERT INTO `fiados` VALUES (16, 1, 1, 4163.03, 10.88, 10.88, 382.63, 'pendiente', '2026-02-07 15:28:22', NULL);
INSERT INTO `fiados` VALUES (17, 1, 7, 2142.74, 5.60, 5.60, 382.63, 'pendiente', '2026-02-07 22:31:15', NULL);
INSERT INTO `fiados` VALUES (18, 1, 16, 555.38, 1.50, 1.50, 370.25, 'pendiente', '2026-02-07 23:29:09', NULL);
INSERT INTO `fiados` VALUES (19, 1, 13, 3700.05, 9.67, 9.67, 382.63, 'pendiente', '2026-02-08 00:14:43', NULL);
INSERT INTO `fiados` VALUES (20, 1, 7, 3106.97, 8.12, 8.12, 382.63, 'pendiente', '2026-02-09 15:57:33', NULL);
INSERT INTO `fiados` VALUES (21, 1, 12, 10601.00, 27.71, 27.71, 382.63, 'pendiente', '2026-02-09 16:02:36', NULL);
INSERT INTO `fiados` VALUES (22, 1, 12, 1396.61, 3.65, 3.65, 382.63, 'pendiente', '2026-02-09 22:51:49', NULL);
INSERT INTO `fiados` VALUES (23, 1, 12, 3351.87, 8.70, 8.70, 385.27, 'pendiente', '2026-02-10 19:48:47', NULL);
INSERT INTO `fiados` VALUES (24, 1, 7, 1541.09, 4.00, 4.00, 385.27, 'pendiente', '2026-02-10 20:26:30', NULL);
INSERT INTO `fiados` VALUES (25, 1, 9, 385.27, 1.00, 1.00, 385.27, 'pendiente', '2026-02-10 22:54:23', NULL);

-- ----------------------------
-- Table structure for metodos_pago
-- ----------------------------
DROP TABLE IF EXISTS `metodos_pago`;
CREATE TABLE `metodos_pago`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `negocio_id` int NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `requiere_referencia` tinyint(1) NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `negocio_id`(`negocio_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of metodos_pago
-- ----------------------------
INSERT INTO `metodos_pago` VALUES (1, 1, 'Efectivo', 0, 1);
INSERT INTO `metodos_pago` VALUES (2, 2, 'Efectivo', 0, 1);
INSERT INTO `metodos_pago` VALUES (3, 1, 'Crédito', 0, 1);
INSERT INTO `metodos_pago` VALUES (4, 2, 'Crédito', 0, 1);
INSERT INTO `metodos_pago` VALUES (5, 1, 'Punto', 0, 1);
INSERT INTO `metodos_pago` VALUES (6, 1, 'PagoMovil', 1, 1);
INSERT INTO `metodos_pago` VALUES (7, 1, 'BioPago', 0, 1);
INSERT INTO `metodos_pago` VALUES (8, 2, 'pago movil', 1, 1);
INSERT INTO `metodos_pago` VALUES (9, 2, 'punto', 0, 1);
INSERT INTO `metodos_pago` VALUES (10, 2, 'efectivo divisa ', 0, 1);
INSERT INTO `metodos_pago` VALUES (11, 2, 'transferencia divisa', 1, 1);

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
) ENGINE = MyISAM AUTO_INCREMENT = 2849 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of productos
-- ----------------------------
INSERT INTO `productos` VALUES (1, 1, 2, 'QUESO', '', '', '', '', 'unidad', 1.00, 9.49, NULL, 0, 'USD', 5.80, 7.54, 0.00, '2026-01-27 18:05:01', '2026-02-12 00:00:24', 0, 1, NULL);
INSERT INTO `productos` VALUES (2, 1, 3, 'CLUB SOCIAL', NULL, '', NULL, '7590011205158', 'unidad', 6.00, 10.00, NULL, 0, 'USD', 0.26, 0.40, 2.15, '2026-01-27 18:05:01', '2026-02-06 03:29:11', 0, 0, NULL);
INSERT INTO `productos` VALUES (63, 1, 4, 'GLUP 2LTS', NULL, '', NULL, '', 'unidad', 6.00, 1.00, NULL, 0, 'USD', 1.05, 1.37, 1.41, '2026-01-27 18:05:01', '2026-02-12 15:20:48', 0, 0, NULL);
INSERT INTO `productos` VALUES (4, 1, 5, 'CATALINAS', NULL, NULL, NULL, NULL, 'unidad', 10.00, 5.00, NULL, 0, 'USD', 0.30, 0.40, 3.50, '2026-01-27 18:05:01', '2026-02-10 16:03:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (5, 1, 6, 'PAN SALADO', NULL, NULL, NULL, NULL, 'unidad', 1.00, 4.00, NULL, 0, 'USD', 0.80, 1.00, NULL, '2026-01-27 18:05:01', '2026-02-11 22:13:50', 0, 0, NULL);
INSERT INTO `productos` VALUES (6, 1, 7, 'PAN CLINEJA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.30, 1.60, NULL, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (300, 1, 8, 'HELADO YOGURT', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.40, 0.55, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (8, 1, 7, 'PAN RELLENO GUAYABA', NULL, NULL, NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 0.33, 0.45, 4.50, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (9, 1, 7, 'PAN COCO', NULL, NULL, NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 0.27, 0.40, 3.30, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (10, 1, 9, 'RIQUESA', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.15, 3.50, NULL, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (11, 1, 10, 'SALSA SOYA AJO INGLESA DOÑA TITA', NULL, '', NULL, '7597459000055', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 1.10, 1.43, 1.43, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (12, 1, 11, 'ACEITE VATEL', NULL, '', NULL, '7591049193035', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 5.00, 6.00, 6.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (13, 1, 3, 'SALSA PASTA UW 490GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.66, 2.95, NULL, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (14, 1, 4, 'ARROZ', NULL, '', NULL, '7590274000026', 'unidad', 24.00, 8.00, NULL, 0, 'USD', 1.38, 1.79, 1.79, '2026-01-27 18:05:01', '2026-02-09 16:02:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (15, 1, 1, 'HARINA PAN', '', '', '', '', 'unidad', 20.00, 5.00, NULL, 0, 'USD', 1.50, 1.85, 1.94, '2026-01-27 18:05:01', '2026-02-11 13:23:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (16, 1, 3, 'CARAMELO FREEGELLS', NULL, '', NULL, '7891151039673', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.23, 0.50, 0.50, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (17, 1, 3, 'HALLS', NULL, NULL, NULL, NULL, 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.46, 0.65, 0.65, '2026-01-27 18:05:01', '2026-02-07 02:02:27', 0, 0, NULL);
INSERT INTO `productos` VALUES (339, 1, 3, 'GALLE LULU LIMON 175GR', NULL, '', NULL, '7591082000802', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.61, 2.01, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (19, 1, 10, 'TORONTO', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.59, 0.65, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (20, 1, 10, 'CHOCOLATE SAVOY', NULL, '', NULL, '7591016851135', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 1.29, 1.70, 1.70, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (21, 1, 3, 'CHICLE GIGANTE', NULL, '', NULL, '8964001247173', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.50, 0.55, 0.00, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (22, 1, NULL, 'GALLETAS MALTN\'MILK', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.23, 0.25, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (23, 1, 11, 'JABÓN PROTEX 110GR', NULL, NULL, NULL, NULL, 'unidad', 3.00, 10.00, NULL, 0, 'USD', 2.50, 3.25, 9.00, '2026-01-27 18:05:01', '2026-02-07 02:03:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (24, 1, 4, 'ESPONJAS', NULL, NULL, NULL, NULL, 'unidad', 2.00, 10.00, NULL, 0, 'USD', 0.60, 0.85, 0.85, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (25, 1, 4, 'FREGADOR', NULL, NULL, NULL, NULL, 'unidad', 15.00, 10.00, NULL, 0, 'USD', 0.37, 0.70, 0.70, '2026-01-27 18:05:01', '2026-02-07 02:02:07', 0, 0, NULL);
INSERT INTO `productos` VALUES (26, 1, NULL, 'COCA-COLA 1.5LTS', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.44, 1.60, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (28, 1, 9, 'GATORADE', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.62, 1.80, NULL, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (29, 1, 12, 'TOMATE', NULL, NULL, NULL, NULL, 'kg', 1.00, 9.80, NULL, 0, 'BS', 390.00, 550.00, NULL, '2026-01-27 18:05:01', '2026-02-09 16:02:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (30, 1, 12, 'CEBOLLA', NULL, NULL, NULL, NULL, 'kg', 1.00, 10.00, NULL, 0, 'BS', 380.00, 550.00, NULL, '2026-01-27 18:05:01', '2026-02-09 20:58:29', 0, 0, NULL);
INSERT INTO `productos` VALUES (31, 1, 12, 'PAPA', NULL, NULL, NULL, NULL, 'kg', 1.00, 10.00, NULL, 0, 'BS', 380.00, 650.00, NULL, '2026-01-27 18:05:01', '2026-02-09 20:58:29', 0, 0, NULL);
INSERT INTO `productos` VALUES (32, 1, 12, 'PLaTANO', NULL, '', NULL, '', 'kg', 1.00, 10.00, NULL, 0, 'BS', 700.00, 1040.00, 0.00, '2026-01-27 18:05:01', '2026-02-09 20:58:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (33, 1, 13, 'LUCKY', NULL, '', NULL, '', 'paquete', 20.00, 10.00, NULL, 0, 'USD', 0.17, 0.25, 4.40, '2026-01-27 18:05:01', '2026-02-08 16:57:06', 0, 0, NULL);
INSERT INTO `productos` VALUES (34, 1, 13, 'BELTMONT', NULL, '', NULL, '75903169', 'paquete', 20.00, 100.00, NULL, 0, 'USD', 0.14, 0.22, 3.60, '2026-01-27 18:05:01', '2026-02-10 20:26:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (35, 1, 13, 'PALLMALL', NULL, '', NULL, '', 'paquete', 20.00, -35.00, NULL, 0, 'USD', 0.14, 0.22, 3.60, '2026-01-27 18:05:01', '2026-02-10 19:48:47', 0, 0, NULL);
INSERT INTO `productos` VALUES (37, 1, 13, 'UNIVERSAL', NULL, '', NULL, '', 'paquete', 20.00, 10.00, NULL, 0, 'USD', 0.09, 0.15, 2.35, '2026-01-27 18:05:01', '2026-02-04 14:58:46', 0, 0, NULL);
INSERT INTO `productos` VALUES (38, 1, 13, 'CONSUL', NULL, '', NULL, '75903206', 'paquete', 20.00, 35.00, NULL, 0, 'USD', 0.08, 0.13, 2.05, '2026-01-27 18:05:01', '2026-02-09 21:50:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (39, 1, 3, 'VELAS', NULL, '', NULL, NULL, 'unidad', 1.00, 8.00, NULL, 0, 'USD', 0.23, 0.25, NULL, '2026-01-27 18:05:01', '2026-02-10 19:48:47', 0, 0, NULL);
INSERT INTO `productos` VALUES (283, 1, 1, 'JUGO JUCOSA', NULL, NULL, NULL, NULL, 'unidad', 3.00, 10.00, NULL, 0, 'USD', 0.53, 0.70, 2.00, '2026-01-27 18:05:01', '2026-02-07 02:03:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (42, 1, 4, 'LOPERAN', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.23, 0.25, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (45, 1, 14, 'DICLOFENAC POTÁSICO', NULL, NULL, NULL, NULL, 'unidad', 30.00, 10.00, NULL, 0, 'USD', 0.03, 0.15, 0.15, '2026-01-27 18:05:01', '2026-02-07 02:02:04', 0, 0, NULL);
INSERT INTO `productos` VALUES (44, 1, 4, 'DICLOFENAC SÓDICO', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.09, 0.10, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (46, 1, 14, 'METOCLOPRAMIDA', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.32, 0.35, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (47, 1, 14, 'IBUPROFENO', NULL, NULL, NULL, NULL, 'unidad', 10.00, 10.00, NULL, 0, 'USD', 0.12, 0.20, 0.20, '2026-01-27 18:05:01', '2026-02-07 02:03:12', 0, 0, NULL);
INSERT INTO `productos` VALUES (48, 1, 14, 'LORATADINA', NULL, NULL, NULL, NULL, 'unidad', 10.00, 10.00, NULL, 0, 'USD', 0.15, 0.25, 0.25, '2026-01-27 18:05:01', '2026-02-07 02:03:16', 0, 0, NULL);
INSERT INTO `productos` VALUES (49, 1, 14, 'CETIRIZINA', NULL, NULL, NULL, NULL, 'unidad', 20.00, 10.00, NULL, 0, 'USD', 0.05, 0.15, 0.15, '2026-01-27 18:05:01', '2026-02-07 02:01:24', 0, 0, NULL);
INSERT INTO `productos` VALUES (50, 1, 14, 'ACETAMINOFÉN', NULL, NULL, NULL, NULL, 'unidad', 20.00, 8.00, NULL, 0, 'USD', 0.05, 0.15, 0.15, '2026-01-27 18:05:01', '2026-02-09 22:51:49', 0, 0, NULL);
INSERT INTO `productos` VALUES (51, 1, 14, 'OMEPRAZOL', NULL, NULL, NULL, NULL, 'unidad', 28.00, 6.00, NULL, 0, 'USD', 0.11, 0.20, 0.20, '2026-01-27 18:05:01', '2026-02-07 11:26:16', 0, 0, NULL);
INSERT INTO `productos` VALUES (52, 1, 14, 'AMOXICILINA', NULL, NULL, NULL, NULL, 'unidad', 10.00, 10.00, NULL, 0, 'USD', 0.22, 0.30, 0.30, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (53, 1, 14, 'METRONIDAZOL', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.18, 0.20, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (54, 1, 4, 'GLUP 1 LT', NULL, '', NULL, '', 'unidad', 12.00, 5.00, NULL, 0, 'USD', 0.74, 1.00, 1.00, '2026-01-27 18:05:01', '2026-02-09 21:27:45', 0, 0, NULL);
INSERT INTO `productos` VALUES (55, 1, 4, 'GLUP 400ML', NULL, NULL, NULL, NULL, 'unidad', 15.00, 5.00, NULL, 0, 'USD', 0.39, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-09 21:27:45', 0, 0, NULL);
INSERT INTO `productos` VALUES (56, 1, 9, 'MALTA DE BOTELLA', NULL, '', NULL, '', 'unidad', 36.00, 7.00, NULL, 0, 'USD', 0.46, 0.65, 0.65, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (57, 1, 9, 'PEPSI-COLA 1.25LTS', NULL, '', NULL, '', 'unidad', 6.00, 9.00, NULL, 0, 'USD', 0.75, 1.00, 1.10, '2026-01-27 18:05:01', '2026-02-10 22:54:23', 0, 0, NULL);
INSERT INTO `productos` VALUES (58, 1, 9, 'PEPSI-COLA 2LT', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.80, 2.00, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (59, 1, 4, 'JUSTY', NULL, '', NULL, NULL, 'unidad', 1.00, 8.00, NULL, 0, 'USD', 1.17, 1.30, NULL, '2026-01-27 18:05:01', '2026-02-10 15:45:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (60, 1, 4, 'COCA-COLA 2LTS', '', '', '', '7591127123626', 'unidad', 6.00, 10.00, NULL, 0, 'USD', 1.67, 2.17, 2.20, '2026-01-27 18:05:01', '2026-02-08 16:59:22', 0, 0, NULL);
INSERT INTO `productos` VALUES (61, 1, 9, 'MALTA 1.5LTS', NULL, '', NULL, '', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.64, 2.13, 2.15, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (62, 1, 3, 'JUGO FRICAJITA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.99, 1.24, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (65, 1, NULL, 'COCA-COLA 1LT', NULL, '', NULL, NULL, 'unidad', 6.00, 10.00, NULL, 0, 'USD', 0.83, 1.10, 1.10, '2026-01-27 18:05:01', '2026-02-07 02:01:48', 0, 0, NULL);
INSERT INTO `productos` VALUES (275, 1, 1, 'GOMITAS PLAY', NULL, NULL, NULL, NULL, 'unidad', 24.00, 9.00, NULL, 0, 'USD', 0.58, 0.90, 0.90, '2026-01-27 18:05:01', '2026-02-07 02:02:26', 0, 0, NULL);
INSERT INTO `productos` VALUES (67, 1, 11, 'PAPEL NARANJA 400', NULL, NULL, NULL, NULL, 'paquete', 4.00, 10.00, NULL, 0, 'USD', 0.73, 1.10, 3.70, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (68, 1, 11, 'GALLETA MARIA ITALIA', NULL, '', NULL, '7597089000036', 'unidad', 12.00, 16.00, NULL, 0, 'USD', 0.06, 0.10, 0.90, '2026-01-27 18:05:01', '2026-02-11 00:41:26', 1, 0, NULL);
INSERT INTO `productos` VALUES (69, 1, 15, 'CAFE AMANECER 100GR', NULL, '', NULL, '7595461001206', 'unidad', 10.00, 7.00, NULL, 0, 'USD', 1.30, 1.63, 1.63, '2026-01-27 18:05:01', '2026-02-08 15:15:49', 0, 0, NULL);
INSERT INTO `productos` VALUES (70, 1, 15, 'CARAOTAS AMANECER', NULL, '', NULL, '7599450000089', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.00, 1.35, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (71, 1, 15, 'PASTA LARGA NONNA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.75, 0.95, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (72, 1, 15, 'PASTA CORTA NONNA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.40, 2.10, NULL, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (73, 1, 16, 'DORITOS PEQ', NULL, '', NULL, '', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.11, 1.40, 0.00, '2026-01-27 18:05:01', '2026-02-07 02:02:05', 0, 0, NULL);
INSERT INTO `productos` VALUES (74, 1, 16, 'DORITOS DIN PEQ', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.08, 1.20, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (75, 1, 16, 'DORITOS FH PEQ', NULL, '', NULL, NULL, 'unidad', 1.00, 9.00, NULL, 0, 'USD', 1.03, 1.30, 0.00, '2026-01-27 18:05:01', '2026-02-04 23:35:04', 0, 0, NULL);
INSERT INTO `productos` VALUES (76, 1, 16, 'DORITOS DIN FH PEQ', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.08, 1.20, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (77, 1, 16, 'CHEESE TRIS P', NULL, '', NULL, '7591206003924', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.77, 1.00, 0.00, '2026-01-27 18:05:01', '2026-02-04 10:37:07', 0, 0, NULL);
INSERT INTO `productos` VALUES (78, 1, 16, 'PEPITO P', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.90, 1.00, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (79, 1, 11, 'BOLI KRUCH', NULL, '', NULL, '7592708000336', 'unidad', 12.00, 8.00, NULL, 0, 'USD', 0.37, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-12 00:00:24', 0, 0, NULL);
INSERT INTO `productos` VALUES (80, 1, 11, 'KESITOS P', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.54, 0.60, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (81, 1, 1, 'PIGSY PICANTE', NULL, NULL, NULL, NULL, 'unidad', 18.00, 10.00, NULL, 0, 'USD', 0.19, 0.40, 0.40, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (82, 1, 16, 'RAQUETY', NULL, '', NULL, NULL, 'unidad', 1.00, 8.00, NULL, 0, 'USD', 0.48, 0.65, 0.00, '2026-01-27 18:05:01', '2026-02-04 23:32:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (83, 1, 11, 'CHISKESITO PEQUEÑO', NULL, NULL, NULL, NULL, 'unidad', 12.00, 22.00, NULL, 0, 'USD', 0.61, 0.80, 0.70, '2026-01-27 18:05:01', '2026-02-11 00:25:29', 0, 0, NULL);
INSERT INTO `productos` VALUES (84, 1, 3, 'CHIPS AHOY', NULL, '', NULL, '7590011138104', 'paquete', 6.00, 10.00, NULL, 0, 'USD', 0.06, 0.50, 2.75, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (85, 1, 1, 'COCO CRUCH', NULL, '', NULL, '7973593350896', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.40, 1.82, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (86, 1, 11, 'SALSERITOS GRANDES', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.61, 2.01, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (87, 1, 11, 'SALSERITOS PEQUEÑOS', NULL, NULL, NULL, NULL, 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.42, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-07 02:04:08', 0, 0, NULL);
INSERT INTO `productos` VALUES (88, 1, 4, 'TOSTON TOM', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.41, 0.45, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (89, 1, 3, 'MINI CHIPS', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.90, 2.30, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (90, 1, 3, 'NUCITA CRUNCH', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.48, 1.85, NULL, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (91, 1, 11, 'FLIPS PEQUEÑO', NULL, NULL, NULL, NULL, 'unidad', 6.00, 10.00, NULL, 0, 'USD', 0.56, 0.75, 0.80, '2026-01-27 18:05:01', '2026-02-07 02:02:06', 0, 0, NULL);
INSERT INTO `productos` VALUES (92, 1, 11, 'FLIPS MEDIANO', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.84, 2.30, NULL, '2026-01-27 18:05:01', '2026-02-04 12:24:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (93, 1, 16, 'DORITOS G', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.97, 3.30, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (95, 1, 16, 'DORITOS FH G', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.97, 3.30, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (244, 1, 11, 'CHESITO P', NULL, '', NULL, '7592708001883', 'unidad', 12.00, 8.00, NULL, 0, 'USD', 0.17, 0.40, 0.40, '2026-01-27 18:05:01', '2026-02-07 11:26:16', 0, 0, NULL);
INSERT INTO `productos` VALUES (98, 1, 16, 'PEPITO G', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.10, 1.43, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (100, 1, 1, 'MAXCOCO', NULL, NULL, NULL, NULL, 'unidad', 10.00, 10.00, NULL, 0, 'USD', 0.78, 1.01, 1.01, '2026-01-27 18:05:01', '2026-02-07 02:03:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (101, 1, 3, 'CROC-CHOC', NULL, '', NULL, '7896383000811', 'unidad', 24.00, 7.00, NULL, 0, 'USD', 0.20, 0.40, 0.40, '2026-01-27 18:05:01', '2026-02-10 20:59:11', 0, 0, NULL);
INSERT INTO `productos` VALUES (102, 1, 3, 'TRIDENT', NULL, NULL, NULL, NULL, 'unidad', 18.00, 9.00, NULL, 0, 'USD', 0.44, 0.65, 0.65, '2026-01-27 18:05:01', '2026-02-07 02:04:14', 0, 0, NULL);
INSERT INTO `productos` VALUES (103, 1, 3, 'MINTY', NULL, NULL, NULL, NULL, 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.37, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-07 02:03:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (104, 1, 3, 'CHICLE GUDS', NULL, '', NULL, '7897190307834', 'unidad', 18.00, 9.00, NULL, 0, 'USD', 0.14, 0.30, 0.30, '2026-01-27 18:05:01', '2026-02-12 00:00:24', 0, 0, NULL);
INSERT INTO `productos` VALUES (105, 1, 3, 'NUCITA TUBO', NULL, '', NULL, '7591675010102', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 1.10, 1.43, 1.30, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (106, 1, 16, 'DANDY', NULL, '', NULL, '7702011040558', 'unidad', 16.00, 10.00, NULL, 0, 'USD', 0.63, 0.82, 0.60, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (107, 1, 3, 'OREO DE TUBO', NULL, '', NULL, '7622202213656', 'unidad', 1.00, 9.00, NULL, 0, 'USD', 1.24, 1.65, 0.00, '2026-01-27 18:05:01', '2026-02-08 17:51:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (108, 1, 3, 'OREO 6S', NULL, '', NULL, '7622202213779', 'unidad', 6.00, 10.00, NULL, 0, 'USD', 0.06, 0.50, 2.55, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (110, 1, 3, 'OREO FUDGE', NULL, '', NULL, '7622202228742', 'unidad', 6.00, 10.00, NULL, 0, 'USD', 0.07, 0.65, 3.00, '2026-01-27 18:05:01', '2026-02-07 02:03:41', 0, 0, NULL);
INSERT INTO `productos` VALUES (111, 1, 3, 'TAKYTA 150GR', NULL, NULL, NULL, NULL, 'unidad', 8.00, 5.00, NULL, 0, 'USD', 0.10, 0.15, 1.00, '2026-01-27 18:05:01', '2026-02-07 11:26:16', 0, 0, NULL);
INSERT INTO `productos` VALUES (112, 1, 3, 'OREO DE CAJA', NULL, NULL, NULL, NULL, 'unidad', 8.00, 10.00, NULL, 0, 'USD', 0.55, 0.75, 0.75, '2026-01-27 18:05:01', '2026-02-07 02:03:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (113, 1, 3, 'CHUPETA PIN PON', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.45, 0.50, NULL, '2026-01-27 18:05:01', '2026-02-08 17:51:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (114, 1, 3, 'POLVO EXPLOSIVO', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.27, 0.30, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (115, 1, 3, 'CHUPETA EXPLOSIVA', NULL, '', NULL, '745853860912', 'unidad', 1.00, 9.00, NULL, 0, 'USD', 0.36, 0.40, 0.00, '2026-01-27 18:05:01', '2026-02-10 16:00:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (116, 1, 3, 'CHICLE DE YOYO', NULL, '', NULL, '745853860998', 'unidad', 24.00, 9.00, NULL, 0, 'USD', 0.32, 0.50, 0.50, '2026-01-27 18:05:01', '2026-02-10 16:03:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (118, 1, 3, 'PIRULIN', NULL, '', NULL, '7591675013042', 'unidad', 25.00, 10.00, NULL, 0, 'USD', 0.47, 0.65, 0.55, '2026-01-27 18:05:01', '2026-02-06 03:28:06', 0, 0, NULL);
INSERT INTO `productos` VALUES (119, 1, 3, 'NUCITA', NULL, '', NULL, '75970109', 'unidad', 12.00, 9.00, NULL, 0, 'USD', 0.43, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-08 21:40:32', 0, 0, NULL);
INSERT INTO `productos` VALUES (120, 1, 1, 'BRINKY', NULL, NULL, NULL, NULL, 'unidad', 10.00, 10.00, NULL, 0, 'USD', 0.26, 0.50, 0.50, '2026-01-27 18:05:01', '2026-02-07 02:01:21', 0, 0, NULL);
INSERT INTO `productos` VALUES (121, 1, 16, 'PEPITAS', NULL, '', NULL, '7591620010157', 'unidad', 18.00, 9.00, NULL, 0, 'USD', 0.33, 0.45, 0.45, '2026-01-27 18:05:01', '2026-02-12 00:00:24', 0, 0, NULL);
INSERT INTO `productos` VALUES (122, 1, 16, 'PALITOS', NULL, '', NULL, '805579523116', 'unidad', 18.00, 7.00, NULL, 0, 'USD', 0.41, 0.55, 0.55, '2026-01-27 18:05:01', '2026-02-11 22:13:50', 0, 0, NULL);
INSERT INTO `productos` VALUES (123, 1, 3, 'COLORETI', NULL, '', NULL, '7896383000422', 'unidad', 24.00, 10.00, NULL, 0, 'USD', 0.19, 0.40, 0.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (124, 1, 3, 'SPARKIES BUBBALOO', NULL, '', NULL, '7702133879494', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.36, 0.40, 0.00, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (125, 1, 3, 'EXTINTOR', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.86, 0.95, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (126, 1, 3, 'CHUPETA DE ANILLOS', NULL, '', NULL, '659525562182', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.50, 0.55, 0.00, '2026-01-27 18:05:01', '2026-02-08 17:31:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (127, 1, 3, 'CRAYÓN CHICLE', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.23, 0.25, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (128, 1, 3, 'COLORES CHICLE', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.41, 0.45, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (129, 1, 3, 'CHUPETA DE MASCOTAS', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.17, 1.30, NULL, '2026-01-27 18:05:01', '2026-02-08 17:31:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (130, 1, 3, 'SPINNER RING', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.17, 1.30, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (131, 1, 3, 'JUGUETE DE POCETA', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.86, 0.95, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (132, 1, 10, 'COCOSETE', NULL, '', NULL, '7591016871089', 'unidad', 18.00, 10.00, NULL, 0, 'USD', 1.15, 1.50, 1.50, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (286, 1, 10, 'CEPILLO DENTAL COLGATE', NULL, '', NULL, '6910021007206', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.11, 1.50, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (134, 1, 10, 'SAMBA', NULL, NULL, NULL, NULL, 'unidad', 20.00, 10.00, NULL, 0, 'USD', 1.04, 1.35, 1.35, '2026-01-27 18:05:01', '2026-02-07 02:04:09', 0, 0, NULL);
INSERT INTO `productos` VALUES (135, 1, 10, 'SAMBA PEQUEÑA', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.59, 0.65, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (136, 1, 11, 'FLIPS CAJA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.17, 4.00, NULL, '2026-01-27 18:05:01', '2026-02-04 12:24:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (137, 1, 3, 'CORN FLAKES DE CAJA', NULL, '', NULL, '7591057001285', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.56, 3.20, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (138, 1, 11, 'CRONCH FLAKES BOLSA', NULL, '', NULL, '7591039100050', 'unidad', 1.00, 9.00, NULL, 0, 'USD', 3.21, 4.01, 0.00, '2026-01-27 18:05:01', '2026-02-07 15:28:22', 0, 0, NULL);
INSERT INTO `productos` VALUES (139, 1, 11, 'FRUTY AROS', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.33, 3.70, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (140, 1, 4, 'JUMBY RIKOS G', NULL, NULL, NULL, NULL, 'unidad', 18.00, 9.00, NULL, 0, 'USD', 0.78, 1.10, 1.10, '2026-01-27 18:05:01', '2026-02-07 16:47:28', 0, 0, NULL);
INSERT INTO `productos` VALUES (141, 1, 11, 'CHISKESITO GRANDE', NULL, NULL, NULL, NULL, 'unidad', 1.00, 22.00, NULL, 0, 'USD', 0.61, 1.85, NULL, '2026-01-27 18:05:01', '2026-02-11 00:25:29', 0, 0, NULL);
INSERT INTO `productos` VALUES (142, 1, 11, 'CHESITO G', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.64, 0.85, NULL, '2026-01-27 18:05:01', '2026-02-04 12:24:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (143, 1, 4, 'DOBOM 400GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 5.90, 7.38, NULL, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (144, 1, 4, 'DOBOM 200GRS', NULL, '', NULL, '7891097102042', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 3.00, 3.75, 45.00, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (145, 1, 4, 'DOBOM 125GRS', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.00, 2.50, NULL, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (146, 1, 3, 'CAMPIÑA 200GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.14, 3.77, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (147, 1, 3, 'CAMPIÑA 125GRS', NULL, '', NULL, '7591014014747', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.17, 2.70, 0.00, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (148, 1, 11, 'LECHE UPACA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.69, 2.20, NULL, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (149, 1, 3, 'LECHE INDOSA 200GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.10, 1.43, NULL, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (150, 1, 11, 'AVENA 200GR PANTERA', NULL, '', NULL, '7591794000558', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.83, 1.25, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (151, 1, 11, 'COMPOTA GRANDE', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.00, 1.30, NULL, '2026-01-27 18:05:01', '2026-02-04 12:24:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (152, 1, 11, 'COMPOTA PEQUEÑA', NULL, '', NULL, '75916084', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.79, 1.10, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (337, 1, 3, 'ELITE CHOC. TUBO 100GR', NULL, '', NULL, '7591082001366', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.95, 1.23, 0.00, '2026-01-27 18:05:01', '2026-02-08 17:33:26', 0, 0, NULL);
INSERT INTO `productos` VALUES (154, 1, 11, 'MAIZINA 90GR', NULL, '', NULL, '521439601526', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.82, 1.07, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (155, 1, 11, 'MAIZINA 120GR', NULL, '', NULL, '7591039770734', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.00, 1.30, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (156, 1, 10, 'SOPA MAGGY', NULL, NULL, NULL, NULL, 'unidad', 12.00, 10.00, NULL, 0, 'USD', 1.71, 2.22, 2.22, '2026-01-27 18:05:01', '2026-02-07 02:04:10', 0, 0, NULL);
INSERT INTO `productos` VALUES (158, 1, 10, 'LECHE CONDENSADA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.96, 3.55, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (159, 1, 4, 'BOKA', NULL, NULL, NULL, NULL, 'unidad', 10.00, 10.00, NULL, 0, 'USD', 0.40, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-07 02:01:18', 0, 0, NULL);
INSERT INTO `productos` VALUES (160, 1, 4, 'PEGA LOKA', NULL, NULL, NULL, NULL, 'unidad', 42.00, 10.00, NULL, 0, 'USD', 0.34, 0.70, 0.70, '2026-01-27 18:05:01', '2026-02-07 02:04:05', 0, 0, NULL);
INSERT INTO `productos` VALUES (161, 1, 17, 'BOMBILLO LED 10W', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.05, 1.31, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (164, 1, 11, 'CARAOTA PANTERA', NULL, '', NULL, 'https://granospantera.start.page', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.71, 2.20, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (165, 1, 27, 'CARAOTAS DON JUAN', NULL, '', NULL, '527455000244', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.90, 1.00, 0.00, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (166, 1, 11, 'CARAOTA BLANCA PANTERA', NULL, '', NULL, '7591794000442', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.02, 2.63, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (167, 1, 11, 'FRIJOL PANTERA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.35, 1.50, NULL, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (168, 1, 11, 'ARVEJAS PANTERA', NULL, '', NULL, 'https://granospantera.start.page', 'unidad', 1.00, 9.00, NULL, 0, 'USD', 1.60, 2.00, 2.00, '2026-01-27 18:05:01', '2026-02-09 16:02:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (169, 1, 11, 'MAÍZ DE COTUFAS', NULL, NULL, NULL, NULL, 'unidad', 1.00, 16.00, NULL, 0, 'USD', 1.12, 1.65, NULL, '2026-01-27 18:05:01', '2026-02-11 00:25:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (170, 1, 15, 'CAFÉ AMANECER 200GR', NULL, '', NULL, '7595461000049', 'unidad', 6.00, 10.00, NULL, 0, 'USD', 2.41, 3.01, 3.01, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (171, 1, 11, 'CAFÉ FLOR ARAUCA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 7.00, NULL, 0, 'USD', 2.85, 3.71, NULL, '2026-01-27 18:05:01', '2026-02-09 15:57:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (172, 1, 11, 'CAFÉ ARAUCA 200GRS', NULL, '', NULL, '7596540000257', 'unidad', 1.00, 15.00, NULL, 0, 'USD', 2.78, 3.50, 0.00, '2026-01-27 18:05:01', '2026-02-11 00:25:29', 0, 0, NULL);
INSERT INTO `productos` VALUES (173, 1, 11, 'CAFÉ ARAUCA 100GR', NULL, '', NULL, '7596540000264', 'unidad', 1.00, 7.00, NULL, 0, 'USD', 1.43, 1.75, 0.00, '2026-01-27 18:05:01', '2026-02-07 21:33:14', 0, 0, NULL);
INSERT INTO `productos` VALUES (174, 1, 11, 'CAFÉ ARAUCA 50GRS', NULL, '', NULL, '7596540001544', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.64, 0.90, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (260, 1, 10, 'SALSA DOÑA TITA PEQ', NULL, '', NULL, '7597459000680', 'unidad', 24.00, 10.00, NULL, 0, 'USD', 1.06, 1.40, 1.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (176, 1, 4, 'YOKOIMA 100GR', NULL, NULL, NULL, NULL, 'unidad', 10.00, 7.00, NULL, 0, 'USD', 1.35, 1.69, 1.69, '2026-01-27 18:05:01', '2026-02-07 02:04:19', 0, 0, NULL);
INSERT INTO `productos` VALUES (177, 1, 15, 'FAVORITO 100GRS', NULL, '', NULL, '7595461000292', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.35, 1.50, 0.00, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (178, 1, 15, 'FAVORITO 50GRS', NULL, '', NULL, '7595461000315', 'unidad', 20.00, 10.00, NULL, 0, 'USD', 0.56, 0.73, 0.73, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (179, 1, 9, 'SALSA PAMPERO GR', NULL, '', NULL, '75919191', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.89, 2.10, 0.00, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (180, 1, 9, 'SALSA PAMPERO PEQ', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.31, 1.45, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (181, 1, 11, 'SALSA TIQUIRE GR', NULL, '', NULL, '75919740', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.89, 2.10, 0.00, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (182, 1, 11, 'SALSA TIQUIRE PEQ', NULL, '', NULL, '75920531', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.31, 1.45, 0.00, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (183, 1, 10, 'SALSA DOÑA TITA GR', NULL, '', NULL, '1007400934293', 'unidad', 24.00, 10.00, NULL, 0, 'USD', 1.71, 2.14, 2.14, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (184, 1, 9, 'MAYONESA MAVESA PEQUEÑA', NULL, NULL, NULL, NULL, 'unidad', 24.00, 10.00, NULL, 0, 'USD', 2.04, 2.55, 2.55, '2026-01-27 18:05:01', '2026-02-07 02:03:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (185, 1, 3, 'MAYONESA KRAFF 175GR', NULL, '', NULL, '', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.97, 2.56, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (187, 1, 3, 'DIABLITOS 115GR', NULL, '', NULL, '7591072003622', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.71, 3.25, 0.00, '2026-01-27 18:05:01', '2026-02-08 17:51:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (188, 1, 3, 'DIABLITOS 54GR', NULL, '', NULL, '7591072000027', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.58, 1.98, 0.00, '2026-01-27 18:05:01', '2026-02-08 17:21:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (189, 1, 3, 'ATÚN AZUL SDLA', NULL, '', NULL, '7591072002342', 'unidad', 1.00, 9.00, NULL, 0, 'USD', 2.98, 3.87, 0.00, '2026-01-27 18:05:01', '2026-02-08 17:51:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (190, 1, 3, 'ATUN ROJO SDLA', NULL, '', NULL, '7591072002359', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.45, 4.14, 0.00, '2026-01-27 18:05:01', '2026-02-08 17:51:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (191, 1, 4, 'SARDINA', NULL, NULL, NULL, '7595122001927', 'unidad', 24.00, 9.00, NULL, 0, 'USD', 0.73, 1.00, 1.00, '2026-01-27 18:05:01', '2026-02-10 19:48:47', 0, 0, NULL);
INSERT INTO `productos` VALUES (192, 1, 11, 'VINAGRE DE MANZANA', NULL, '', NULL, '7591112000239', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.44, 1.60, 0.00, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (193, 1, 10, 'VINAGRE DOÑA TITA', NULL, '', NULL, '7597459000352', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.00, 1.55, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (194, 1, 11, 'VINAGRE TIQUIRE', NULL, '', NULL, '7591112049016', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.07, 1.40, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (195, 1, 4, 'ACEITE IDEAL 900ML', NULL, NULL, NULL, NULL, 'unidad', 12.00, 10.00, NULL, 0, 'USD', 3.28, 4.17, 4.17, '2026-01-27 18:05:01', '2026-02-07 01:59:58', 0, 0, NULL);
INSERT INTO `productos` VALUES (196, 1, 4, 'ACEITE PAMPA 1/2LT', NULL, '', NULL, '7599959000016', 'unidad', 12.00, 9.00, NULL, 0, 'USD', 2.42, 3.20, 3.20, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (198, 1, 4, 'PASTA LARGA HORIZONTE', NULL, NULL, NULL, NULL, 'unidad', 12.00, 9.00, NULL, 0, 'USD', 2.14, 2.78, 2.78, '2026-01-27 18:05:01', '2026-02-07 21:33:14', 0, 0, NULL);
INSERT INTO `productos` VALUES (199, 1, 4, 'PASTA HORIZONTE CORTA', NULL, NULL, NULL, NULL, 'unidad', 12.00, 10.00, NULL, 0, 'USD', 2.43, 3.15, 3.15, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (200, 1, 4, 'HARINA DE TRIGO', NULL, NULL, NULL, NULL, 'unidad', 10.00, 10.00, NULL, 0, 'USD', 1.16, 1.52, 1.52, '2026-01-27 18:05:01', '2026-02-07 02:02:27', 0, 0, NULL);
INSERT INTO `productos` VALUES (201, 1, 11, 'AZÚCAR', NULL, NULL, NULL, '7597304223943', 'unidad', 20.00, 7.00, NULL, 0, 'USD', 1.50, 2.00, 2.00, '2026-01-27 18:05:01', '2026-02-07 22:31:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (202, 1, 1, 'SAL', NULL, '', NULL, '7593575001129', 'unidad', 25.00, 8.00, NULL, 0, 'USD', 0.34, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-10 15:45:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (203, 1, 4, 'DELINE DE 250GRS', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.35, 1.50, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (204, 1, 9, 'NELLY DE 250GRS', NULL, NULL, NULL, NULL, 'unidad', 24.00, 10.00, NULL, 0, 'USD', 1.17, 1.60, 1.60, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (205, 1, 9, 'NELLY DE 500GRS', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.43, 2.70, NULL, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (206, 1, 9, 'MAVESA DE 250GRS', NULL, '', NULL, '', 'unidad', 1.00, 9.00, NULL, 0, 'USD', 1.50, 1.90, 43.20, '2026-01-27 18:05:01', '2026-02-07 19:06:41', 0, 0, NULL);
INSERT INTO `productos` VALUES (207, 1, 9, 'MAVESA DE 500GRS', NULL, '', NULL, '', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.69, 3.23, 2.60, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (208, 1, 1, 'HUEVOS', NULL, NULL, NULL, NULL, 'paquete', 30.00, 0.00, NULL, 0, 'USD', 0.22, 0.30, 8.00, '2026-01-27 18:05:01', '2026-02-09 22:51:49', 0, 0, NULL);
INSERT INTO `productos` VALUES (209, 1, 18, 'MASA PASTELITO ROMY', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.80, 2.20, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (210, 1, 4, 'NUTRIBELLA', NULL, NULL, NULL, NULL, 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.65, 0.85, 0.85, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (211, 1, 10, 'DESODORANTE CLINICAL', NULL, '', NULL, '7501033210778', 'unidad', 20.00, 7.00, NULL, 0, 'USD', 0.45, 0.65, 0.65, '2026-01-27 18:05:01', '2026-02-10 16:00:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (212, 1, 4, 'DESODORANTE', NULL, '', NULL, '7501033206580', 'unidad', 18.00, 10.00, NULL, 0, 'USD', 0.43, 0.58, 0.58, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (213, 1, 4, 'SHAMPOO H&S', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.54, 0.60, NULL, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (214, 1, 1, 'BOLSAS NEGRAS', NULL, NULL, NULL, NULL, 'unidad', 25.00, 10.00, NULL, 0, 'USD', 0.34, 0.55, 0.55, '2026-01-27 18:05:01', '2026-02-07 02:01:19', 0, 0, NULL);
INSERT INTO `productos` VALUES (215, 1, 10, 'AXION EN CREMA', NULL, '', NULL, '7509546694566', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.11, 2.74, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (346, 1, 3, 'MARSHMALLOWS NAVIDEÑO', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.95, 1.20, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (349, 1, 10, 'CUBITOS MAGGIE', NULL, '', NULL, '7591016205709', 'unidad', 250.00, 9.00, NULL, 0, 'USD', 0.20, 0.35, 0.35, '2026-01-27 18:05:01', '2026-02-11 13:23:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (217, 1, 10, 'COLGATE TOTAL', NULL, '', NULL, '7793100111143', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.10, 2.63, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (218, 1, 10, 'COLGATE PLAX', NULL, '', NULL, '7591083018547', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.25, 4.23, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (219, 1, 10, 'COLGATE TRIPLE ACCIÓN 60ML', NULL, '', NULL, '7702010111501', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.73, 2.16, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (220, 1, 10, 'COLGATE TRADICIONAL 90ML', NULL, '', NULL, '7891024134702', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 1.50, 1.88, 22.56, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (221, 1, 10, 'COLGATE NIÑOS', NULL, '', NULL, '7891024036075', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.60, 2.00, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (322, 1, 3, 'MARIA SELECTA', NULL, '', NULL, '7591082010016', 'paquete', 9.00, 10.00, NULL, 0, 'USD', 0.02, 0.25, 1.86, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (223, 1, 4, 'TOALLAS AZULES', NULL, NULL, NULL, NULL, 'unidad', 30.00, 10.00, NULL, 20, 'USD', 1.34, 1.70, 1.70, '2026-01-27 18:05:01', '2026-02-09 21:19:56', 0, 0, NULL);
INSERT INTO `productos` VALUES (224, 1, 1, 'TOALLAS MORADAS', NULL, NULL, NULL, NULL, 'unidad', 30.00, 10.00, NULL, 20, 'USD', 0.98, 1.40, 1.40, '2026-01-27 18:05:01', '2026-02-09 21:19:56', 0, 0, NULL);
INSERT INTO `productos` VALUES (225, 1, 19, 'JABÓN ESPECIAL', NULL, NULL, NULL, NULL, 'unidad', 50.00, 9.00, NULL, 0, 'USD', 0.80, 1.20, 1.20, '2026-01-27 18:05:01', '2026-02-07 21:33:14', 0, 0, NULL);
INSERT INTO `productos` VALUES (226, 1, 4, 'JABÓN POPULAR', NULL, NULL, NULL, NULL, 'unidad', 72.00, 9.00, NULL, 0, 'USD', 0.80, 1.30, 1.30, '2026-01-27 18:05:01', '2026-02-07 02:03:14', 0, 0, NULL);
INSERT INTO `productos` VALUES (227, 1, 9, 'JABÓN LAS LLAVES', '', '', '', '75971670', 'unidad', 1.00, 9.00, NULL, 0, 'USD', 1.17, 1.30, 0.00, '2026-01-27 18:05:01', '2026-02-07 13:27:43', 0, 0, NULL);
INSERT INTO `productos` VALUES (228, 1, 3, 'JABÓN DE AVENA', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.54, 0.60, NULL, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (229, 1, 4, 'JABÓN HUGME', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.59, 0.65, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (231, 1, 4, 'JABÓN LAK', NULL, NULL, NULL, NULL, 'unidad', 4.00, 10.00, NULL, 0, 'USD', 1.03, 1.50, 1.50, '2026-01-27 18:05:01', '2026-02-07 02:03:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (232, 1, 4, 'GELATINA CABELLO PEQ', NULL, NULL, NULL, NULL, 'unidad', 24.00, 10.00, NULL, 0, 'USD', 1.83, 2.40, 2.40, '2026-01-27 18:05:01', '2026-02-07 02:02:24', 0, 0, NULL);
INSERT INTO `productos` VALUES (233, 1, 1, 'ACE ALIVE 1KG', NULL, '', NULL, '', 'unidad', 12.00, 9.00, NULL, 0, 'USD', 3.25, 4.23, 50.76, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (234, 1, 1, 'ACE ALIVE 500GRS', '', '', '', '7597597003017', 'unidad', 24.00, 13.00, NULL, 0, 'USD', 1.11, 1.80, 0.00, '2026-01-27 18:05:01', '2026-02-11 03:44:29', 0, 0, NULL);
INSERT INTO `productos` VALUES (235, 1, 1, 'ACE OSO BLANCO 400GRS', NULL, '', NULL, '6904542109563', 'unidad', 20.00, 10.00, NULL, 0, 'USD', 1.40, 1.82, 1.82, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (236, 1, 4, 'SUAVITEL', NULL, NULL, NULL, NULL, 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.66, 0.86, 0.86, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (237, 1, 4, 'CLORO LOFO 1LT', NULL, NULL, NULL, NULL, 'unidad', 12.00, 10.00, NULL, 0, 'USD', 1.00, 1.30, 1.30, '2026-01-27 18:05:01', '2026-02-07 02:01:47', 0, 0, NULL);
INSERT INTO `productos` VALUES (238, 1, 4, 'AFEITADORA', NULL, '', NULL, '6950769302133', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.53, 0.75, 0.75, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (239, 1, 4, 'HOJILLAS', NULL, NULL, NULL, NULL, 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.60, 1.00, 1.00, '2026-01-27 18:05:01', '2026-02-07 02:02:59', 0, 0, NULL);
INSERT INTO `productos` VALUES (240, 1, 20, 'LECHE 1LT LOS ANDES', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.94, 2.15, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (285, 1, 1, 'APUREÑITO', NULL, NULL, NULL, NULL, 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.49, 0.75, 0.75, '2026-01-27 18:05:01', '2026-02-07 02:00:56', 0, 0, NULL);
INSERT INTO `productos` VALUES (242, 1, 1, 'YESQUERO', NULL, '', NULL, '7703562035369', 'unidad', 1.00, 9.00, NULL, 0, 'USD', 0.36, 0.40, 0.00, '2026-01-27 18:05:01', '2026-02-10 20:26:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (243, 1, NULL, 'TRIDENT INDIVIDUAL', NULL, NULL, NULL, NULL, 'unidad', 60.00, 10.00, NULL, 0, 'USD', 0.09, 0.15, 0.15, '2026-01-27 18:05:01', '2026-02-07 02:04:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (245, 1, 3, 'ATUN RICA DELI', NULL, '', NULL, '7591072002403', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.45, 2.94, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (246, 1, 3, 'SALSA PASTA UW 190GR', NULL, '', NULL, '7591072000263', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.35, 1.70, 0.00, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (247, 1, 3, 'SORBETICO PEQ', NULL, '', NULL, '7590011227105', 'unidad', 4.00, 10.00, NULL, 0, 'USD', 0.27, 0.40, 1.35, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (248, 1, 3, 'SORBETICO WAFER', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.17, 1.52, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (249, 1, 3, 'TANG', NULL, '', NULL, NULL, 'unidad', 15.00, 7.00, NULL, 0, 'USD', 0.43, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-08 21:38:05', 0, 0, NULL);
INSERT INTO `productos` VALUES (250, 1, 3, 'CHICLE FREEGELLS', NULL, '', NULL, '7891151031189', 'unidad', 15.00, 10.00, NULL, 0, 'USD', 0.24, 0.40, 0.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (251, 1, 3, 'CHICLE TATTOO', NULL, NULL, NULL, NULL, 'unidad', 90.00, 7.00, NULL, 0, 'USD', 0.03, 0.07, 0.07, '2026-01-27 18:05:01', '2026-02-12 00:00:24', 0, 0, NULL);
INSERT INTO `productos` VALUES (254, 1, 3, 'GALLETA MARIA MINI', NULL, '', NULL, '7592809000761', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.50, 0.70, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (256, 1, 1, 'COCO CRUCH', NULL, '', NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.08, 1.20, NULL, '2026-01-27 18:05:01', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (257, 1, 16, 'CHEESE TRIS G', NULL, '', NULL, '7591206000381', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.66, 2.16, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (258, 1, 11, 'BOLI KRUNCH G', NULL, '', NULL, '7592708000343', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.85, 1.25, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (259, 1, 11, 'KESITOS G', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.89, 1.25, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (262, 1, 21, 'CHAKARO GDE', NULL, NULL, NULL, NULL, 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.67, 0.90, 0.90, '2026-01-27 18:05:01', '2026-02-07 02:01:25', 0, 0, NULL);
INSERT INTO `productos` VALUES (261, 1, 22, 'DESINFECTANTE', NULL, NULL, NULL, NULL, 'kg', 1.00, 10.00, NULL, 0, 'USD', 0.78, 1.20, NULL, '2026-01-27 18:05:01', '2026-02-07 13:25:41', 0, 1, NULL);
INSERT INTO `productos` VALUES (263, 1, 21, 'MANDADOR', NULL, NULL, NULL, NULL, 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.75, 1.00, 1.00, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (264, 1, 4, 'CHUPETA', NULL, NULL, NULL, NULL, 'unidad', 46.00, 9.00, NULL, 0, 'USD', 0.13, 0.20, 0.20, '2026-01-27 18:05:01', '2026-02-08 17:31:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (265, 1, 18, 'SALCHICHAS', NULL, NULL, NULL, NULL, 'kg', 1.00, 10.00, NULL, 0, 'USD', 4.05, 5.30, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (266, 1, 22, 'CLORO AAA', '', '', '', '', 'kg', 1.00, 10.00, NULL, 0, 'USD', 0.53, 1.00, 0.00, '2026-01-27 18:05:01', '2026-02-07 13:25:41', 0, 1, NULL);
INSERT INTO `productos` VALUES (267, 1, 22, 'LAVAPLATOS AAA', NULL, NULL, NULL, NULL, 'kg', 1.00, 10.00, NULL, 0, 'USD', 1.81, 2.35, NULL, '2026-01-27 18:05:01', '2026-02-07 13:25:41', 0, 1, NULL);
INSERT INTO `productos` VALUES (268, 1, 22, 'LAVAPLATOS AA', NULL, NULL, NULL, NULL, 'kg', 1.00, 10.00, NULL, 0, 'USD', 1.38, 1.80, NULL, '2026-01-27 18:05:01', '2026-02-07 13:25:41', 0, 1, NULL);
INSERT INTO `productos` VALUES (269, 1, 22, 'CLORO AA', '', '', '', '', 'kg', 1.00, 9.50, NULL, 0, 'USD', 0.48, 0.80, 0.00, '2026-01-27 18:05:01', '2026-02-07 13:25:41', 0, 1, NULL);
INSERT INTO `productos` VALUES (270, 1, 22, 'CERA BLANCA', NULL, NULL, NULL, NULL, 'kg', 1.00, 10.00, NULL, 0, 'USD', 0.87, 1.13, NULL, '2026-01-27 18:05:01', '2026-02-07 13:25:41', 0, 1, NULL);
INSERT INTO `productos` VALUES (271, 1, 22, 'SUAVIZANTE', '', '', '', '', 'kg', 1.00, 9.50, NULL, 0, 'USD', 1.12, 1.65, 0.00, '2026-01-27 18:05:01', '2026-02-07 13:25:41', 0, 1, NULL);
INSERT INTO `productos` VALUES (272, 1, 22, 'DESENGRASANTE AAA', NULL, NULL, NULL, NULL, 'kg', 1.00, 10.00, NULL, 0, 'USD', 1.51, 2.00, NULL, '2026-01-27 18:05:01', '2026-02-07 13:25:41', 0, 1, NULL);
INSERT INTO `productos` VALUES (329, 1, 17, 'BOMBILLO LED 20W', NULL, '', NULL, '6935787900165', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.86, 2.33, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (273, 1, 3, 'MARSHMALLOWS 100GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.02, 1.30, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (274, 1, 3, 'HUEVITO SORPRESA', NULL, NULL, NULL, NULL, 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.49, 0.70, 0.70, '2026-01-27 18:05:01', '2026-02-07 02:03:01', 0, 0, NULL);
INSERT INTO `productos` VALUES (276, 1, 4, 'GALLETA SODA EL SOL', NULL, NULL, NULL, NULL, 'paquete', 10.00, 10.00, NULL, 0, 'USD', 0.16, 0.25, 2.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (277, 1, 4, 'YOKOIMA 50GR', NULL, NULL, NULL, NULL, 'unidad', 20.00, 9.00, NULL, 0, 'USD', 0.63, 0.81, 0.81, '2026-01-27 18:05:01', '2026-02-09 15:57:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (279, 1, 1, 'TIGRITO', NULL, NULL, NULL, NULL, 'unidad', 12.00, 9.00, NULL, 0, 'USD', 0.49, 0.75, 0.75, '2026-01-27 18:05:01', '2026-02-07 19:06:41', 0, 0, NULL);
INSERT INTO `productos` VALUES (280, 1, 5, 'PLAQUITAS', NULL, NULL, NULL, NULL, 'unidad', 15.00, 10.00, NULL, 0, 'USD', 0.12, 0.17, 0.17, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (282, 1, 11, 'KETCHUP CAPRI 198GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.13, 1.41, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (284, 1, 9, 'ATUN MARGARITA', NULL, NULL, NULL, NULL, 'unidad', 35.00, 10.00, NULL, 0, 'USD', 1.90, 2.38, 2.38, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (287, 1, 1, 'HOJA EXAMEN', NULL, NULL, NULL, NULL, 'unidad', 50.00, 10.00, NULL, 0, 'USD', 0.05, 0.10, 0.10, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (288, 1, 3, 'BOMBONES CORAZON', NULL, '', NULL, '', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.65, 2.15, 0.00, '2026-01-27 18:05:01', '2026-02-08 17:51:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (289, 1, 3, 'BOMBONES ROSA', NULL, '', NULL, '745853860783', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.18, 3.90, 0.00, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (290, 1, 3, 'NUCITA CRUNCH JR', NULL, NULL, NULL, NULL, 'unidad', 6.00, 10.00, NULL, 0, 'USD', 0.40, 0.60, 0.60, '2026-01-27 18:05:01', '2026-02-07 13:58:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (291, 1, 3, 'YOYO NEON', NULL, '', NULL, '659525562250', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.86, 1.15, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (292, 1, 3, 'GUSANITO LOCO', NULL, NULL, NULL, NULL, 'unidad', 30.00, 10.00, NULL, 0, 'USD', 0.66, 0.86, 25.80, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (293, 1, 3, 'ACONDICIONADOR SEDAL', NULL, '', NULL, '7702006207690', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.34, 0.50, 0.50, '2026-01-27 18:05:01', '2026-02-08 17:51:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (294, 1, 18, 'JAMÓN', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.60, 2.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (295, 1, 18, 'QUESO AMARILLO', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.60, 2.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (296, 1, 16, 'RAQUETY G', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.83, 1.10, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (297, 1, 11, 'PAPEL AMARILLO 600', NULL, NULL, NULL, NULL, 'paquete', 4.00, 10.00, NULL, 0, 'USD', 1.00, 1.40, 5.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (298, 1, 3, 'COLORETI MINI', NULL, '', NULL, '7896383000033', 'unidad', 36.00, 8.00, NULL, 0, 'USD', 0.11, 0.20, 0.20, '2026-01-27 18:05:01', '2026-02-10 15:45:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (299, 1, 3, 'MENTITAS AMBROSOLI', NULL, NULL, NULL, NULL, 'unidad', 24.00, 10.00, NULL, 0, 'USD', 0.48, 0.70, 0.70, '2026-01-27 18:05:01', '2026-02-08 17:51:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (310, 1, 4, 'CARAMELOS', NULL, NULL, NULL, NULL, 'unidad', 100.00, 10.00, NULL, 0, 'USD', 0.03, 0.05, 0.05, '2026-01-27 18:05:01', '2026-02-07 02:01:24', 0, 0, NULL);
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
INSERT INTO `productos` VALUES (313, 1, 11, 'PAPEL VERDE 215', NULL, NULL, NULL, NULL, 'paquete', 4.00, 8.00, NULL, 0, 'USD', 0.31, 0.60, 1.85, '2026-01-27 18:05:01', '2026-02-10 19:47:27', 0, 0, NULL);
INSERT INTO `productos` VALUES (314, 1, 11, 'PAPEL MARRÓN 300', NULL, NULL, NULL, NULL, 'paquete', 4.00, 10.00, NULL, 0, 'USD', 0.60, 0.90, 3.10, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (315, 1, 15, 'CAFÉ NONNA 100GR', NULL, NULL, NULL, NULL, 'unidad', 10.00, 10.00, NULL, 0, 'USD', 1.30, 1.63, 1.63, '2026-01-27 18:05:01', '2026-02-07 02:01:22', 0, 0, NULL);
INSERT INTO `productos` VALUES (316, 1, 11, 'LENTEJA PANTERA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 16.00, NULL, 0, 'USD', 2.05, 2.70, NULL, '2026-01-27 18:05:01', '2026-02-11 00:39:59', 0, 0, NULL);
INSERT INTO `productos` VALUES (336, 1, 3, 'MINI MARILU TUBO 100GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.07, 1.39, NULL, '2026-01-27 18:05:01', '2026-02-08 17:51:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (318, 1, 10, 'MAYONESA TITA', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.62, 1.94, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (319, 1, 3, 'BOMBONES BEL', NULL, NULL, NULL, NULL, 'unidad', 50.00, 10.00, NULL, 0, 'USD', 0.08, 0.10, 0.10, '2026-01-27 18:05:01', '2026-02-07 02:01:20', 0, 0, NULL);
INSERT INTO `productos` VALUES (338, 1, 3, 'ELITE VAINI TUBO 100GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.82, 1.07, NULL, '2026-01-27 18:05:01', '2026-02-08 17:51:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (323, 1, 3, 'MARILU TUBO 240GR', NULL, '', NULL, '7591082014007', 'unidad', 6.00, 10.00, NULL, 0, 'USD', 0.32, 0.50, 2.40, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (324, 1, 3, 'CARAMELO MIEL', NULL, NULL, NULL, NULL, 'unidad', 100.00, 10.00, NULL, 0, 'USD', 0.02, 0.05, 0.05, '2026-01-27 18:05:01', '2026-02-08 17:21:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (325, 1, 3, 'NUTTELINI', NULL, '', NULL, '7702011115232', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 0.29, 0.45, 0.45, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (330, 1, 10, 'CEPILLO DENTAL COLGATE NIÑO', NULL, '', NULL, '7509546074122', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.23, 1.60, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (327, 1, 11, 'BARRILETE', NULL, NULL, NULL, NULL, 'unidad', 50.00, 10.00, NULL, 0, 'USD', 0.06, 0.80, 0.80, '2026-01-27 18:05:01', '2026-02-07 02:00:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (328, 1, 1, 'FRUTYS', NULL, NULL, NULL, NULL, 'unidad', 12.00, 10.00, NULL, 0, 'USD', 1.04, 1.40, 1.40, '2026-01-27 18:05:01', '2026-02-07 02:02:07', 0, 0, NULL);
INSERT INTO `productos` VALUES (341, 1, 3, 'GALLE MARILU CAJA', NULL, '', NULL, '7591082010221', 'unidad', 24.00, 10.00, NULL, 0, 'USD', 0.19, 0.30, 0.30, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (332, 1, 11, 'ACEITE COPOSA 850ML', NULL, '', NULL, '7591058001024', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 3.92, 4.90, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (331, 1, 10, 'JABÓN PROTEX 75GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.28, 1.66, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (333, 1, 24, 'RECARGA MOVISTAR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 8.00, NULL, 0, 'BS', 150.00, 190.00, NULL, '2026-01-27 18:05:01', '2026-02-05 20:21:59', 0, 0, NULL);
INSERT INTO `productos` VALUES (334, 1, 24, 'RECARGA DIGITEL', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'BS', 160.00, 200.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (335, 1, 24, 'RECARGA MOVILNET', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 150.00, 185.00, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (340, 1, 3, 'GALLETA BROWNIE 175GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.55, 2.02, NULL, '2026-01-27 18:05:01', '2026-02-08 17:51:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (342, 1, 3, 'GALLE Q-KISS 200GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 2.63, 3.16, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (343, 1, 3, 'GALLETA REX 200GR', NULL, '', NULL, '7591082000574', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.26, 1.60, 0.00, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (344, 1, 3, 'GALLETA LIMON 77GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.64, 0.83, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (345, 1, 3, 'GALLETA LIMON 90GR', NULL, NULL, NULL, NULL, 'unidad', 1.00, 10.00, NULL, 0, 'USD', 0.88, 1.14, NULL, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (347, 1, 3, 'CHUPA POP SURTIDO', NULL, NULL, NULL, NULL, 'unidad', 24.00, 10.00, NULL, 0, 'USD', 0.13, 0.20, 0.20, '2026-01-27 18:05:01', '2026-02-07 02:01:45', 0, 0, NULL);
INSERT INTO `productos` VALUES (348, 1, 3, 'TATTOO CHUPETA', NULL, NULL, NULL, NULL, 'unidad', 50.00, 8.00, NULL, 0, 'USD', 0.06, 0.10, 0.10, '2026-01-27 18:05:01', '2026-02-08 17:31:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (350, 1, 1, 'CREMA ALIDENT', NULL, '', NULL, '7597257001650', 'unidad', 12.00, 10.00, NULL, 0, 'USD', 1.50, 1.95, 1.95, '2026-01-27 18:05:01', '2026-02-04 02:12:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (356, 1, 18, 'J. espalda con todo', NULL, '', NULL, '100400001567', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 6.12, 6.80, 0.00, '2026-01-29 21:17:36', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (355, 1, 18, 'Carne Molida', NULL, '', NULL, '103004004392', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 7.20, 8.00, 0.00, '2026-01-29 21:15:48', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (357, 1, 18, 'q. amarillo ortiz', NULL, '', NULL, '121002001748', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 1.57, 1.74, 0.00, '2026-01-29 21:18:19', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (359, 1, 27, 'prueba', NULL, '', NULL, 'https://consultaqr.seniat.gob.ve/qr/459f8f1a-0f15-454a-b3df-1bddcf9638f4', 'unidad', 1.00, 10.00, NULL, 0, 'USD', 4.50, 5.00, 0.00, '2026-02-02 12:52:17', '2026-02-06 03:15:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2811, 2, NULL, 'TUBITO MANUBRIO NEGRO', 'T051', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 2.31, 3.30, 0.00, '2026-02-09 02:30:38', '2026-02-09 02:30:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2812, 2, NULL, 'TUBITO MANUBRIO ROJO', 'T052', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 2.31, 3.30, 0.00, '2026-02-09 02:30:38', '2026-02-09 02:30:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2779, 2, NULL, 'TAPA CADENA RAGCIN NEGRO', 'T019', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 3.43, 4.90, 0.00, '2026-02-09 02:30:35', '2026-02-09 02:30:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2780, 2, NULL, 'TAPA CADENA RAGCIN PLATIADO', 'T020', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 3.43, 4.90, 0.00, '2026-02-09 02:30:35', '2026-02-09 02:30:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2776, 2, NULL, 'TAPA CADENA PASTICO 1', 'T016', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:35', '2026-02-09 02:30:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2777, 2, NULL, 'TAPA CADENA RAGCIN AZUL', 'T017', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 3.43, 4.90, 0.00, '2026-02-09 02:30:35', '2026-02-09 02:30:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2778, 2, NULL, 'TAPA CADENA RAGCIN MORADO', 'T018', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 3.43, 4.90, 0.00, '2026-02-09 02:30:35', '2026-02-09 02:30:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2774, 2, NULL, 'TAPA CADENA H-150 PLASTICA', 'T014', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 11.00, NULL, 1, 'USD', 1.33, 1.90, 0.00, '2026-02-09 02:30:35', '2026-02-09 02:30:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2773, 2, NULL, 'TAPA CADENA ESV PLASTICA', 'T013', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 1.47, 2.10, 0.00, '2026-02-09 02:30:35', '2026-02-09 02:30:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2772, 2, NULL, 'TAPA CADENA ESV PLASTICA MORADA', 'T012', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:34', '2026-02-09 02:30:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2769, 2, NULL, 'TAPA CADENA  PLASTICA NEGRO A-150', 'T009', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 1.33, 1.90, 0.00, '2026-02-09 02:30:34', '2026-02-09 02:30:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2770, 2, NULL, 'TAPA CADENA  PLASTICA H-150 MORAD0', 'T010', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:34', '2026-02-09 02:30:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2767, 2, NULL, 'TACOMETRO SBR DIGITAL 2024', 'T007', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 45.15, 64.50, 0.00, '2026-02-09 02:30:34', '2026-02-09 02:30:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2765, 2, NULL, 'TACOMETRO OWEN 2011 DIGITAL', 'T005', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 45.50, 65.00, 0.00, '2026-02-09 02:30:34', '2026-02-09 02:30:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2766, 2, NULL, 'TACOMETRO SBR 2022', 'T006', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:34', '2026-02-09 02:30:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2764, 2, NULL, 'TACOMETRO MD AGUILA', 'T004', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 24.50, 35.00, 0.00, '2026-02-09 02:30:34', '2026-02-09 02:30:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2760, 2, NULL, 'STOP  CG150', 'S034', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 3.57, 5.10, 0.00, '2026-02-09 02:30:33', '2026-02-09 02:30:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2761, 2, NULL, 'T DE VOLANTE SUPERIOR EK-EXPRESS', 'T001', NULL, 'BENF', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 4.90, 7.00, 0.00, '2026-02-09 02:30:34', '2026-02-09 02:30:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2762, 2, NULL, 'T DE VOLANTE INFERIOR SOCIAL', 'T002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 7.63, 10.90, 0.00, '2026-02-09 02:30:34', '2026-02-09 02:30:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2757, 2, NULL, 'SPRAY NEGRO BRILLANTE ALTA TEMPERATURA', 'S031', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:33', '2026-02-09 02:30:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2758, 2, NULL, 'SWICHERA SBR', 'S032', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 3.92, 5.60, 0.00, '2026-02-09 02:30:33', '2026-02-09 02:30:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2759, 2, NULL, 'spray VERDE', 'S033', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:30:33', '2026-02-09 02:30:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2756, 2, NULL, 'SPRAY NEGRO MATE', 'S030', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:33', '2026-02-09 02:30:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2754, 2, NULL, 'SWITHERA OWEN', 'S028', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 3.22, 4.60, 0.00, '2026-02-09 02:30:33', '2026-02-09 02:30:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2755, 2, NULL, 'SELECTOR CAMBIO CG150', 'S029', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 1.40, 2.00, 0.00, '2026-02-09 02:30:33', '2026-02-09 02:30:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2749, 2, NULL, 'STOP SBR TRANSPARENTE', 'S023', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 11.83, 16.90, 0.00, '2026-02-09 02:30:33', '2026-02-09 02:30:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2750, 2, NULL, 'SWICHERA 4 CABLE', 'S024', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 3.64, 5.20, 0.00, '2026-02-09 02:30:33', '2026-02-09 02:30:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2751, 2, NULL, 'SOPORTE DE PLACA TORNASOL', 'S025', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:33', '2026-02-09 02:30:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2810, 2, NULL, 'TUBITO MANUBRIO MORADO', 'T050', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 2.31, 3.30, 0.00, '2026-02-09 02:30:38', '2026-02-09 02:30:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2746, 2, NULL, 'STOP DECORATIVO CG150 mica trasparente', 'S020', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 9.59, 13.70, 0.00, '2026-02-09 02:30:32', '2026-02-09 02:30:32', 0, 0, NULL);
INSERT INTO `productos` VALUES (2743, 2, NULL, 'SPRAY NEGRO BRIllante', 'S017', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:30:32', '2026-02-09 02:30:32', 0, 0, NULL);
INSERT INTO `productos` VALUES (2744, 2, NULL, 'SPRAY NEGRO MATE CARIBEZUKI', 'S018', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:30:32', '2026-02-11 20:56:49', 0, 0, NULL);
INSERT INTO `productos` VALUES (2745, 2, NULL, 'SPRAY TRASPARENTE', 'S019', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 3.15, 4.50, 0.00, '2026-02-09 02:30:32', '2026-02-09 02:30:32', 0, 0, NULL);
INSERT INTO `productos` VALUES (2741, 2, NULL, 'SPRAY ECONOMICO AMARILLO', 'S015', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:30:32', '2026-02-09 02:30:32', 0, 0, NULL);
INSERT INTO `productos` VALUES (2739, 2, NULL, 'SPRAY ROSADO', 'S013', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 3.43, 4.90, 0.00, '2026-02-09 02:30:32', '2026-02-09 02:30:32', 0, 0, NULL);
INSERT INTO `productos` VALUES (2740, 2, NULL, 'SPRAY ROJO', 'S014', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 3.43, 4.90, 0.00, '2026-02-09 02:30:32', '2026-02-09 02:30:32', 0, 0, NULL);
INSERT INTO `productos` VALUES (2738, 2, NULL, 'SPRAY COLOR ROJO', 'S012', NULL, 'BENF', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:30:32', '2026-02-09 02:30:32', 0, 0, NULL);
INSERT INTO `productos` VALUES (2737, 2, NULL, 'SPRAY BLANCO', 'S011', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:30:32', '2026-02-09 02:30:32', 0, 0, NULL);
INSERT INTO `productos` VALUES (2736, 2, NULL, 'SOCATE STOP FRENO PAR CG150', 'S010', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:32', '2026-02-09 02:30:32', 0, 0, NULL);
INSERT INTO `productos` VALUES (2731, 2, NULL, 'SILICON MEGA GREY', 'S005', NULL, 'ROMO', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 3.15, 4.50, 0.00, '2026-02-09 02:30:31', '2026-02-09 02:30:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2732, 2, NULL, 'SLAIDER', 'S006', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 14.00, NULL, 1, 'USD', 3.36, 4.80, 0.00, '2026-02-09 02:30:31', '2026-02-09 02:30:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2733, 2, NULL, 'SOCATE FARO CG150', 'S007', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:30:31', '2026-02-12 14:40:16', 0, 0, NULL);
INSERT INTO `productos` VALUES (2734, 2, NULL, 'SOCATE FARO H-150', 'S008', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.56, 0.80, 0.00, '2026-02-09 02:30:31', '2026-02-09 02:30:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2735, 2, NULL, 'SOCATE STOP FRENO H-150', 'S009', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:31', '2026-02-09 02:30:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2729, 2, NULL, 'SEGURO DE TAPA DE HORSE', 'S003', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 1.40, 2.00, 0.00, '2026-02-09 02:30:31', '2026-02-09 02:30:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2730, 2, NULL, 'SILICON', 'S004', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 21.00, NULL, 1, 'USD', 1.68, 2.40, 0.00, '2026-02-09 02:30:31', '2026-02-09 02:30:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2723, 2, NULL, 'ROLINERA 6202 KOYO', 'R042', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:30', '2026-02-09 02:30:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2724, 2, NULL, 'ROLINERA 6202', 'R043', NULL, 'BENF', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:30:31', '2026-02-11 19:45:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2725, 2, NULL, 'ROLINERA 6204', 'R044', NULL, 'BENF', NULL, 'unidad', 1.00, 14.00, NULL, 1, 'USD', 1.05, 1.50, 0.00, '2026-02-09 02:30:31', '2026-02-09 02:30:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2722, 2, NULL, 'RETROVISOR V-150 P/CORTA', 'R041', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 3.85, 5.50, 0.00, '2026-02-09 02:30:30', '2026-02-09 02:30:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2721, 2, NULL, 'RETROVISOR REDONDO MICKIE', 'R040', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 3.85, 5.50, 0.00, '2026-02-09 02:30:30', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2716, 2, NULL, 'ROMPEDIENTE VERDE', 'R035', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:30', '2026-02-09 02:30:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2713, 2, NULL, 'ROLINERA 6302 KOYO', 'R032', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 12.00, NULL, 1, 'USD', 0.91, 1.30, 0.00, '2026-02-09 02:30:30', '2026-02-09 02:30:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2709, 2, NULL, 'ROLINERA 6207', 'R028', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 2.24, 3.20, 0.00, '2026-02-09 02:30:29', '2026-02-09 02:30:29', 0, 0, NULL);
INSERT INTO `productos` VALUES (2710, 2, NULL, 'ROLINERA 6300 KOYO', 'R029', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 1.05, 1.50, 0.00, '2026-02-09 02:30:29', '2026-02-09 02:30:29', 0, 0, NULL);
INSERT INTO `productos` VALUES (2711, 2, NULL, 'ROLINERA 6301', 'R030', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 30.00, NULL, 1, 'USD', 0.77, 1.10, 0.00, '2026-02-09 02:30:29', '2026-02-09 02:30:29', 0, 0, NULL);
INSERT INTO `productos` VALUES (2712, 2, NULL, 'ROLINERA 6204 KOYO', 'R031', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 15.00, NULL, 1, 'USD', 1.05, 1.50, 0.00, '2026-02-09 02:30:30', '2026-02-09 02:30:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2707, 2, NULL, 'ROLINERA 6204', 'R026', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 1.05, 1.50, 0.00, '2026-02-09 02:30:29', '2026-02-09 02:30:29', 0, 0, NULL);
INSERT INTO `productos` VALUES (2704, 2, NULL, 'ROLINERA 6301', 'R023', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:30:29', '2026-02-09 02:30:29', 0, 0, NULL);
INSERT INTO `productos` VALUES (2702, 2, NULL, 'ROLINERA 6301', 'R021', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.77, 1.10, 0.00, '2026-02-09 02:30:29', '2026-02-09 02:30:29', 0, 0, NULL);
INSERT INTO `productos` VALUES (2698, 2, NULL, 'ROLINERA 6000', 'R017', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:28', '2026-02-09 02:30:28', 0, 0, NULL);
INSERT INTO `productos` VALUES (2699, 2, NULL, 'ROLINERA 6002', 'R018', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.84, 1.20, 0.00, '2026-02-09 02:30:28', '2026-02-09 02:30:28', 0, 0, NULL);
INSERT INTO `productos` VALUES (2700, 2, NULL, 'ROLINERA 6004 KOYO', 'R019', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 34.00, NULL, 1, 'USD', 0.91, 1.30, 0.00, '2026-02-09 02:30:29', '2026-02-11 01:29:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2701, 2, NULL, 'ROLINERA 6200', 'R020', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 0.84, 1.20, 0.00, '2026-02-09 02:30:29', '2026-02-09 02:30:29', 0, 0, NULL);
INSERT INTO `productos` VALUES (2697, 2, NULL, 'RIN DE RAYO', 'R016', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 51.73, 73.90, 0.00, '2026-02-09 02:30:28', '2026-02-09 02:30:28', 0, 0, NULL);
INSERT INTO `productos` VALUES (2695, 2, NULL, 'RETEN PORTA CORONA CG150 58 MM', 'R015', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 0.35, 0.50, 0.00, '2026-02-09 02:30:28', '2026-02-09 02:30:28', 0, 0, NULL);
INSERT INTO `productos` VALUES (2696, 2, NULL, 'RIN DE HORSE', 'R015', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:28', '2026-02-09 02:30:28', 0, 0, NULL);
INSERT INTO `productos` VALUES (2694, 2, NULL, 'RETROVISOR HORSE', 'R014', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:28', '2026-02-09 02:30:28', 0, 0, NULL);
INSERT INTO `productos` VALUES (2693, 2, NULL, 'RETROVISOR SBR', 'R013', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:28', '2026-02-09 02:30:28', 0, 0, NULL);
INSERT INTO `productos` VALUES (2691, 2, NULL, 'RESOLTE DE FRENO/PIE DE AMIGO', 'R011', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 31.00, NULL, 1, 'USD', 0.28, 0.40, 0.00, '2026-02-09 02:30:28', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2692, 2, NULL, 'RETROVISOR CG150 PATAS CORTA', 'R012', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:30:28', '2026-02-09 02:30:28', 0, 0, NULL);
INSERT INTO `productos` VALUES (2690, 2, NULL, 'REGULADOR RAGCIN', 'R010', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:28', '2026-02-09 02:30:28', 0, 0, NULL);
INSERT INTO `productos` VALUES (2681, 2, NULL, 'RAYa CARRO NEGRO PESA VOLANTE', 'R001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 2.45, 3.50, 0.00, '2026-02-09 02:30:27', '2026-02-09 02:30:27', 0, 0, NULL);
INSERT INTO `productos` VALUES (2682, 2, NULL, 'RAYa CARRO PLATEADO PESA VOLANTE', 'R002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:27', '2026-02-09 02:30:27', 0, 0, NULL);
INSERT INTO `productos` VALUES (2683, 2, NULL, 'RETROVISOR OWEN', 'R003', NULL, 'BENF', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 3.85, 5.50, 0.00, '2026-02-09 02:30:27', '2026-02-09 02:30:27', 0, 0, NULL);
INSERT INTO `productos` VALUES (2684, 2, NULL, 'RETROVISOR A-150', 'R004', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 2.66, 3.80, 0.00, '2026-02-09 02:30:27', '2026-02-09 02:30:27', 0, 0, NULL);
INSERT INTO `productos` VALUES (2679, 2, NULL, 'PATA DE PARAL EK EXPRES', 'P110', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 1.96, 2.80, 0.00, '2026-02-09 02:30:27', '2026-02-09 02:30:27', 0, 0, NULL);
INSERT INTO `productos` VALUES (2680, 2, NULL, 'PIÑON DE CIGÜEÑAL CG150', 'P111', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 2.03, 2.90, 0.00, '2026-02-09 02:30:27', '2026-02-09 02:30:27', 0, 0, NULL);
INSERT INTO `productos` VALUES (2676, 2, NULL, 'PIñON 15T HORSE', 'P107', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 1.19, 1.70, 0.00, '2026-02-09 02:30:27', '2026-02-09 02:30:27', 0, 0, NULL);
INSERT INTO `productos` VALUES (2677, 2, NULL, 'PATA DE CAMBIO EK XPRES', 'P108', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 2.45, 3.50, 0.00, '2026-02-09 02:30:27', '2026-02-09 02:30:27', 0, 0, NULL);
INSERT INTO `productos` VALUES (2678, 2, NULL, 'PATA DE PARAL CG150 CON RESOLTE', 'P109', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 2.24, 3.20, 0.00, '2026-02-09 02:30:27', '2026-02-09 02:30:27', 0, 0, NULL);
INSERT INTO `productos` VALUES (2673, 2, NULL, 'PROTECTOR DE MOTOR UNIVERSAL PLASTICO', 'P104', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 5.18, 7.40, 0.00, '2026-02-09 02:30:26', '2026-02-09 02:30:26', 0, 0, NULL);
INSERT INTO `productos` VALUES (2674, 2, NULL, 'PURIFICADOR H-150', 'P105', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 8.33, 11.90, 0.00, '2026-02-09 02:30:26', '2026-02-09 02:30:26', 0, 0, NULL);
INSERT INTO `productos` VALUES (2672, 2, NULL, 'PRENSA CADENA CG150', 'P103', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:30:26', '2026-02-11 01:29:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2670, 2, NULL, 'PALETA DE FRENO H-150', 'P101', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 5.88, 8.40, 0.00, '2026-02-09 02:30:26', '2026-02-09 02:30:26', 0, 0, NULL);
INSERT INTO `productos` VALUES (2667, 2, NULL, 'PURIFICADOR 150', 'P098', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 4.27, 6.10, 0.00, '2026-02-09 02:30:26', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2668, 2, NULL, 'PEGA TANQUE', 'P099', NULL, 'ROYAL', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 2.45, 3.50, 0.00, '2026-02-09 02:30:26', '2026-02-09 02:30:26', 0, 0, NULL);
INSERT INTO `productos` VALUES (2669, 2, NULL, 'PUÑOS NORMAL', 'P100', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.98, 1.40, 0.00, '2026-02-09 02:30:26', '2026-02-09 02:30:26', 0, 0, NULL);
INSERT INTO `productos` VALUES (2665, 2, NULL, 'PROTECTOR DE MOTOR UNIVERSAL PLASTICO', 'P096', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 5.53, 7.90, 0.00, '2026-02-09 02:30:26', '2026-02-09 02:30:26', 0, 0, NULL);
INSERT INTO `productos` VALUES (2661, 2, NULL, 'PROTECTOR DE FARO PLASTICO MORADO', 'P092', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 3.22, 4.60, 0.00, '2026-02-09 02:30:25', '2026-02-09 02:30:25', 0, 0, NULL);
INSERT INTO `productos` VALUES (2662, 2, NULL, 'PROTECTOR DE FARO PLASTICO NEGRO', 'P093', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 3.22, 4.60, 0.00, '2026-02-09 02:30:25', '2026-02-09 02:30:25', 0, 0, NULL);
INSERT INTO `productos` VALUES (2663, 2, NULL, 'PROTECTOR DE FARO PLASTICO ROJO', 'P094', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 3.22, 4.60, 0.00, '2026-02-09 02:30:25', '2026-02-09 02:30:25', 0, 0, NULL);
INSERT INTO `productos` VALUES (2664, 2, NULL, 'PROTECTOR DE MOTOR UNIVERSAL CROMADO', 'P095', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:26', '2026-02-09 02:30:26', 0, 0, NULL);
INSERT INTO `productos` VALUES (2659, 2, NULL, 'PROTECTOR  DE MOTOR UNIVERSAL HIERRO TX', 'P090', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 5.53, 7.90, 0.00, '2026-02-09 02:30:25', '2026-02-09 02:30:25', 0, 0, NULL);
INSERT INTO `productos` VALUES (2660, 2, NULL, 'PROTECTOR DE FARO PLASTICO AZUL', 'P091', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 3.22, 4.60, 0.00, '2026-02-09 02:30:25', '2026-02-09 02:30:25', 0, 0, NULL);
INSERT INTO `productos` VALUES (2654, 2, NULL, 'PRENSA CADENA H-150', 'P085', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 16.00, NULL, 1, 'USD', 1.68, 2.40, 0.00, '2026-02-09 02:30:25', '2026-02-09 02:30:25', 0, 0, NULL);
INSERT INTO `productos` VALUES (2655, 2, NULL, 'PRENSA CADENA CG150', 'P086', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:30:25', '2026-02-09 02:30:25', 0, 0, NULL);
INSERT INTO `productos` VALUES (2656, 2, NULL, 'PORTA BANDA TRASERA DE XPRESS', 'P087', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 10.43, 14.90, 0.00, '2026-02-09 02:30:25', '2026-02-09 02:30:25', 0, 0, NULL);
INSERT INTO `productos` VALUES (2657, 2, NULL, 'PROTAPPER FORRO GRUESO PUFF', 'P088', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 24.00, NULL, 1, 'USD', 5.04, 7.20, 0.00, '2026-02-09 02:30:25', '2026-02-09 02:30:25', 0, 0, NULL);
INSERT INTO `productos` VALUES (2652, 2, NULL, 'PRENSA CADENA GN', 'P083', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 1.40, 2.00, 0.00, '2026-02-09 02:30:25', '2026-02-09 02:30:25', 0, 0, NULL);
INSERT INTO `productos` VALUES (2653, 2, NULL, 'PRENSA CADENA GN', 'P084', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 1.40, 2.00, 0.00, '2026-02-09 02:30:25', '2026-02-09 02:30:25', 0, 0, NULL);
INSERT INTO `productos` VALUES (2651, 2, NULL, 'PRENSA CADENA UNIVERSAL', 'P082', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 3.29, 4.70, 0.00, '2026-02-09 02:30:24', '2026-02-09 02:30:24', 0, 0, NULL);
INSERT INTO `productos` VALUES (2649, 2, NULL, 'POSA PIE TRASERO SBR', 'P080', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 2.31, 3.30, 0.00, '2026-02-09 02:30:24', '2026-02-09 02:30:24', 0, 0, NULL);
INSERT INTO `productos` VALUES (2648, 2, NULL, 'POSA PIE DELANTERO PROTAPPER', 'P079', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:24', '2026-02-09 02:30:24', 0, 0, NULL);
INSERT INTO `productos` VALUES (2647, 2, NULL, 'POSA PIE DELANTERO HORSE GOMA', 'P078', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 1.75, 2.50, 0.00, '2026-02-09 02:30:24', '2026-02-09 02:30:24', 0, 0, NULL);
INSERT INTO `productos` VALUES (2645, 2, NULL, 'POSA PIE TRASERO HORSE ROSADO', 'P076', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:24', '2026-02-09 02:30:24', 0, 0, NULL);
INSERT INTO `productos` VALUES (2646, 2, NULL, 'POSA PIE TRASERO GN125', 'P077', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 2.17, 3.10, 0.00, '2026-02-09 02:30:24', '2026-02-09 02:30:24', 0, 0, NULL);
INSERT INTO `productos` VALUES (2644, 2, NULL, 'POSA PIE TRASERO HORSE', 'P075', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 3.36, 4.80, 0.00, '2026-02-09 02:30:24', '2026-02-09 02:30:24', 0, 0, NULL);
INSERT INTO `productos` VALUES (2643, 2, NULL, 'POSA PIE DELANTERO EXPRESS', 'P074', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 5.25, 7.50, 0.00, '2026-02-09 02:30:24', '2026-02-09 02:30:24', 0, 0, NULL);
INSERT INTO `productos` VALUES (2638, 2, NULL, 'PORTA PLACA VERDE DE METAL', 'P069', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:30:23', '2026-02-09 02:30:23', 0, 0, NULL);
INSERT INTO `productos` VALUES (2639, 2, NULL, 'PORTA PLACA NEGTRO DE METAL', 'P070', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:30:23', '2026-02-09 02:30:23', 0, 0, NULL);
INSERT INTO `productos` VALUES (2640, 2, NULL, 'PORTA PLACA AZUL DE METAL', 'P071', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:30:24', '2026-02-09 02:30:24', 0, 0, NULL);
INSERT INTO `productos` VALUES (2637, 2, NULL, 'PORTA PLACA ROJA DE METAL', 'P068', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 11.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:30:23', '2026-02-09 02:30:23', 0, 0, NULL);
INSERT INTO `productos` VALUES (2633, 2, NULL, 'PORTA MALETERA METAL', 'P064', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 9.59, 13.70, 0.00, '2026-02-09 02:30:23', '2026-02-09 02:30:23', 0, 0, NULL);
INSERT INTO `productos` VALUES (2634, 2, NULL, 'PORTA MALETERA PLASTICA NEGRO', 'P065', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 8.33, 11.90, 0.00, '2026-02-09 02:30:23', '2026-02-09 02:30:23', 0, 0, NULL);
INSERT INTO `productos` VALUES (2635, 2, NULL, 'PORTA MALETERA UNIVERSAL VARIADO', 'P066', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 6.86, 9.80, 0.00, '2026-02-09 02:30:23', '2026-02-09 02:30:23', 0, 0, NULL);
INSERT INTO `productos` VALUES (2636, 2, NULL, 'PORTA PLACA MORADO DE METAL', 'P067', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:30:23', '2026-02-09 02:30:23', 0, 0, NULL);
INSERT INTO `productos` VALUES (2631, 2, NULL, 'PORTA CORONA SBR', 'P062', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 6.23, 8.90, 0.00, '2026-02-09 02:30:23', '2026-02-11 20:29:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2632, 2, NULL, 'PORTA CORONA HORSE', 'P063', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 7.14, 10.20, 0.00, '2026-02-09 02:30:23', '2026-02-11 15:22:58', 0, 0, NULL);
INSERT INTO `productos` VALUES (2624, 2, NULL, 'PISTON  ,25 vera p/d', 'P055', NULL, 'JUYUA', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 4.76, 6.80, 0.00, '2026-02-09 02:30:22', '2026-02-09 02:30:22', 0, 0, NULL);
INSERT INTO `productos` VALUES (2625, 2, NULL, 'PITILLOS', 'P056', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 12.00, NULL, 1, 'USD', 3.36, 4.80, 0.00, '2026-02-09 02:30:22', '2026-02-09 02:30:22', 0, 0, NULL);
INSERT INTO `productos` VALUES (2626, 2, NULL, 'PLACA DECORATIVA', 'P057', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 29.00, NULL, 1, 'USD', 2.66, 3.80, 0.00, '2026-02-09 02:30:22', '2026-02-09 02:30:22', 0, 0, NULL);
INSERT INTO `productos` VALUES (2627, 2, NULL, 'PORTA BANDA DE AGUILA', 'P058', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 8.96, 12.80, 0.00, '2026-02-09 02:30:22', '2026-02-09 02:30:22', 0, 0, NULL);
INSERT INTO `productos` VALUES (2628, 2, NULL, 'PORTA BANDA horse', 'P059', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 11.83, 16.90, 0.00, '2026-02-09 02:30:23', '2026-02-09 02:30:23', 0, 0, NULL);
INSERT INTO `productos` VALUES (2629, 2, NULL, 'PORTA BANDA CG150', 'P060', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 9.38, 13.40, 0.00, '2026-02-09 02:30:23', '2026-02-09 02:30:23', 0, 0, NULL);
INSERT INTO `productos` VALUES (2623, 2, NULL, 'PISTON CG150 ,75', 'P054', NULL, 'JUYUA', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 4.76, 6.80, 0.00, '2026-02-09 02:30:22', '2026-02-09 02:30:22', 0, 0, NULL);
INSERT INTO `productos` VALUES (2615, 2, NULL, 'PISTON COMPL H-150 0.75', 'P046', NULL, 'JUYUA', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 4.55, 6.50, 0.00, '2026-02-09 02:30:22', '2026-02-09 02:30:22', 0, 0, NULL);
INSERT INTO `productos` VALUES (2616, 2, NULL, 'PISTON COMPL h-150 1', 'P047', NULL, 'JUYUA', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 4.55, 6.50, 0.00, '2026-02-09 02:30:22', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2617, 2, NULL, 'PISTO COMPL EXPREES  STD', 'P048', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 4.48, 6.40, 0.00, '2026-02-09 02:30:22', '2026-02-10 17:50:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2618, 2, NULL, 'PISTON COMPL CG150 STD', 'P049', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:22', '2026-02-09 02:30:22', 0, 0, NULL);
INSERT INTO `productos` VALUES (2619, 2, NULL, 'PISTON DE OWEN 2011 STD', 'P050', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:22', '2026-02-09 02:30:22', 0, 0, NULL);
INSERT INTO `productos` VALUES (2620, 2, NULL, 'PISTON CG200 1', 'P051', NULL, 'ZHONG HING', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 4.76, 6.80, 0.00, '2026-02-09 02:30:22', '2026-02-09 02:30:22', 0, 0, NULL);
INSERT INTO `productos` VALUES (2611, 2, NULL, 'PISTON H-150', 'P042', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 4.48, 6.40, 0.00, '2026-02-09 02:30:21', '2026-02-09 02:30:21', 0, 0, NULL);
INSERT INTO `productos` VALUES (2612, 2, NULL, 'PISTON COMPL A-150 0.50', 'P043', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 5.18, 7.40, 0.00, '2026-02-09 02:30:21', '2026-02-09 02:30:21', 0, 0, NULL);
INSERT INTO `productos` VALUES (2613, 2, NULL, 'PISTON COMPL A-150 0.75 AUTOASIA', 'P044', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:21', '2026-02-09 02:30:21', 0, 0, NULL);
INSERT INTO `productos` VALUES (2614, 2, NULL, 'PIÑON DORADO 15T', 'P045', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:21', '2026-02-09 02:30:21', 0, 0, NULL);
INSERT INTO `productos` VALUES (2605, 2, NULL, 'PIÑON PLATEADO 15T', 'P036', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.98, 1.40, 0.00, '2026-02-09 02:30:21', '2026-02-09 02:30:21', 0, 0, NULL);
INSERT INTO `productos` VALUES (2603, 2, NULL, 'PIÑON DE ARRANQUE', 'P034', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 3.15, 4.50, 0.00, '2026-02-09 02:30:21', '2026-02-09 02:30:21', 0, 0, NULL);
INSERT INTO `productos` VALUES (2604, 2, NULL, 'PIÑON DE TERCERA 150', 'P035', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 2.10, 3.00, 0.00, '2026-02-09 02:30:21', '2026-02-09 02:30:21', 0, 0, NULL);
INSERT INTO `productos` VALUES (2592, 2, NULL, 'PATA DE CAMBIO EXPRESS', 'P023', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:20', '2026-02-09 02:30:20', 0, 0, NULL);
INSERT INTO `productos` VALUES (2587, 2, NULL, 'PATA DE PARAL', 'P018', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:19', '2026-02-09 02:30:19', 0, 0, NULL);
INSERT INTO `productos` VALUES (2588, 2, NULL, 'PATA DE ARRANQUE CG150', 'P019', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 3.15, 4.50, 0.00, '2026-02-09 02:30:19', '2026-02-11 12:03:16', 0, 0, NULL);
INSERT INTO `productos` VALUES (2589, 2, NULL, 'PATA DE ARRANQUE EK', 'P020', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 3.15, 4.50, 0.00, '2026-02-09 02:30:19', '2026-02-09 02:30:19', 0, 0, NULL);
INSERT INTO `productos` VALUES (2590, 2, NULL, 'PATA DE ARRANQUE EK', 'P021', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 2.94, 4.20, 0.00, '2026-02-09 02:30:19', '2026-02-09 02:30:19', 0, 0, NULL);
INSERT INTO `productos` VALUES (2591, 2, NULL, 'PATA DE CAMBIO  CG150', 'P022', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:19', '2026-02-09 02:30:19', 0, 0, NULL);
INSERT INTO `productos` VALUES (2578, 2, NULL, 'PASTILLA DE FRENO CG150', 'P009', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 1.05, 1.50, 0.00, '2026-02-09 02:30:18', '2026-02-09 02:30:18', 0, 0, NULL);
INSERT INTO `productos` VALUES (2579, 2, NULL, 'PASTILLA DE FRENO GN125', 'P010', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:19', '2026-02-09 02:30:19', 0, 0, NULL);
INSERT INTO `productos` VALUES (2580, 2, NULL, 'PASTILLA DE FRENO TX', 'P011', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:30:19', '2026-02-09 02:30:19', 0, 0, NULL);
INSERT INTO `productos` VALUES (2581, 2, NULL, 'PASTILLA FRENO A-150', 'P012', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 15.00, NULL, 1, 'USD', 1.05, 1.50, 0.00, '2026-02-09 02:30:19', '2026-02-09 02:30:19', 0, 0, NULL);
INSERT INTO `productos` VALUES (2582, 2, NULL, 'Paleta DE FRENO CG150', 'P013', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:19', '2026-02-09 02:30:19', 0, 0, NULL);
INSERT INTO `productos` VALUES (2583, 2, NULL, 'PASTILLAS A-150', 'P014', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:19', '2026-02-09 02:30:19', 0, 0, NULL);
INSERT INTO `productos` VALUES (2576, 2, NULL, 'PARRILA HORSE MEGAZUKI', 'P007', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 16.31, 23.30, 0.00, '2026-02-09 02:30:18', '2026-02-09 02:30:18', 0, 0, NULL);
INSERT INTO `productos` VALUES (2575, 2, NULL, 'PARILLA GN', 'P006', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 15.05, 21.50, 0.00, '2026-02-09 02:30:18', '2026-02-09 02:30:18', 0, 0, NULL);
INSERT INTO `productos` VALUES (2574, 2, NULL, 'PALETA DE FRENO hrse', 'P005', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 5.88, 8.40, 0.00, '2026-02-09 02:30:18', '2026-02-09 02:30:18', 0, 0, NULL);
INSERT INTO `productos` VALUES (2572, 2, NULL, 'PALETA DE FRENO CG150', 'P003', NULL, 'moto fami', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 5.74, 8.20, 0.00, '2026-02-09 02:30:18', '2026-02-09 02:30:18', 0, 0, NULL);
INSERT INTO `productos` VALUES (2573, 2, NULL, 'PALETA DE FRENO  GN125', 'P004', NULL, 'moto fami', NULL, 'unidad', 1.00, 12.00, NULL, 1, 'USD', 5.53, 7.90, 0.00, '2026-02-09 02:30:18', '2026-02-09 02:30:18', 0, 0, NULL);
INSERT INTO `productos` VALUES (2567, 2, NULL, 'MANILLA DE CROCHET COMPLETA A150', 'M041', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 3.15, 4.50, 0.00, '2026-02-09 02:30:18', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2568, 2, NULL, 'MANILLA DE CROCHET COMPLETA H150', 'M042', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 3.15, 4.50, 0.00, '2026-02-09 02:30:18', '2026-02-09 02:30:18', 0, 0, NULL);
INSERT INTO `productos` VALUES (2569, 2, NULL, 'MUELITA 5PTS BLANCO MZ401B', 'M043', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:30:18', '2026-02-09 02:30:18', 0, 0, NULL);
INSERT INTO `productos` VALUES (2570, 2, NULL, 'PALETA CROCHET PLATEADA HORSE', 'P001', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:18', '2026-02-09 02:30:18', 0, 0, NULL);
INSERT INTO `productos` VALUES (2566, 2, NULL, 'MANDO KAVAK', 'M040', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 11.13, 15.90, 0.00, '2026-02-09 02:30:17', '2026-02-09 02:30:17', 0, 0, NULL);
INSERT INTO `productos` VALUES (2565, 2, NULL, 'MEDIO KIT DE EMPACADURA', 'M039', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 1.12, 1.60, 0.00, '2026-02-09 02:30:17', '2026-02-09 02:30:17', 0, 0, NULL);
INSERT INTO `productos` VALUES (2560, 2, NULL, 'MEDIO KIT DE EMPACADURA', 'M034', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 1.05, 1.50, 0.00, '2026-02-09 02:30:17', '2026-02-09 02:30:17', 0, 0, NULL);
INSERT INTO `productos` VALUES (2561, 2, NULL, 'MICA DE FARO MD AGUILA', 'M035', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 1.68, 2.40, 0.00, '2026-02-09 02:30:17', '2026-02-11 01:29:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2562, 2, NULL, 'MICA FARO STOP', 'M036', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:17', '2026-02-09 02:30:17', 0, 0, NULL);
INSERT INTO `productos` VALUES (2801, 2, NULL, 'TRIPA 110/90/16', 'T041', NULL, 'ROMO', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 3.92, 5.60, 0.00, '2026-02-09 02:30:37', '2026-02-09 02:30:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2547, 2, NULL, 'MANILLA DE FRENO EXPREES', 'M021', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 21.00, NULL, 1, 'USD', 1.61, 2.30, 0.00, '2026-02-09 02:30:16', '2026-02-09 02:30:16', 0, 0, NULL);
INSERT INTO `productos` VALUES (2548, 2, NULL, 'MANILLA CROCHE COMPLETA EK-PRESS', 'M022', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 2.87, 4.10, 0.00, '2026-02-09 02:30:16', '2026-02-09 02:30:16', 0, 0, NULL);
INSERT INTO `productos` VALUES (2549, 2, NULL, 'MANILLA CROCHE COMPLETA EK-PRESS', 'M023', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:16', '2026-02-09 02:30:16', 0, 0, NULL);
INSERT INTO `productos` VALUES (2799, 2, NULL, 'TRIPA 100/80 14', 'T039', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 3.92, 5.60, 0.00, '2026-02-09 02:30:37', '2026-02-09 02:30:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2538, 2, NULL, 'MANGA BRAZO VARIADA', 'M012', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 34.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:30:15', '2026-02-09 02:30:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (2539, 2, NULL, 'MAGNETO  CG150', 'M013', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 6.93, 9.90, 0.00, '2026-02-09 02:30:15', '2026-02-09 02:30:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (2540, 2, NULL, 'MAGNETO HORSE', 'M014', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 8.96, 12.80, 0.00, '2026-02-09 02:30:15', '2026-02-09 02:30:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (2541, 2, NULL, 'MINI KIT EMPACADURA', 'M015', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 25.00, NULL, 1, 'USD', 0.63, 0.90, 0.00, '2026-02-09 02:30:15', '2026-02-09 02:30:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (2535, 2, NULL, 'MANDO OWEN CON PALETA', 'M009', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 9.45, 13.50, 0.00, '2026-02-09 02:30:15', '2026-02-09 02:30:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (2534, 2, NULL, 'MANDO DE HORSE 150', 'M008', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 6.86, 9.80, 0.00, '2026-02-09 02:30:15', '2026-02-09 02:30:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (2533, 2, NULL, 'MANDO DE HORSE 150', 'M007', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 6.86, 9.80, 0.00, '2026-02-09 02:30:15', '2026-02-09 02:30:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (2532, 2, NULL, 'MANDO DE EXPRESS', 'M006', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 6.65, 9.50, 0.00, '2026-02-09 02:30:15', '2026-02-09 02:30:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (2531, 2, NULL, 'MALLA DE PULPO VARIADO', 'M005', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 1.12, 1.60, 0.00, '2026-02-09 02:30:15', '2026-02-09 02:30:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (2529, 2, NULL, 'MAGNETO OWEN', 'M003', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 16.03, 22.90, 0.00, '2026-02-09 02:30:14', '2026-02-09 02:30:14', 0, 0, NULL);
INSERT INTO `productos` VALUES (2530, 2, NULL, 'MALLA DE ASIENTO UNIVERSAL', 'M004', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:30:14', '2026-02-09 02:30:14', 0, 0, NULL);
INSERT INTO `productos` VALUES (2523, 2, NULL, 'LLAVERO RESORTE (RECORDATORIO)', 'L022', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 13.00, NULL, 1, 'USD', 1.47, 2.10, 0.00, '2026-02-09 02:30:14', '2026-02-09 02:30:14', 0, 0, NULL);
INSERT INTO `productos` VALUES (2524, 2, NULL, 'LUCES DE CRUCES EK XPRESS', 'L023', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:14', '2026-02-09 02:30:14', 0, 0, NULL);
INSERT INTO `productos` VALUES (2525, 2, NULL, 'LUZ CRUCE CG150 MODELO LED', 'L024', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 11.00, NULL, 1, 'USD', 2.45, 3.50, 0.00, '2026-02-09 02:30:14', '2026-02-09 02:30:14', 0, 0, NULL);
INSERT INTO `productos` VALUES (2526, 2, NULL, 'MAGNETO CG150', 'L025', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:14', '2026-02-09 02:30:14', 0, 0, NULL);
INSERT INTO `productos` VALUES (2527, 2, NULL, 'LUCES DE CRUCES EK XPRESS NEW', 'L026', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 3.01, 4.30, 0.00, '2026-02-09 02:30:14', '2026-02-09 02:30:14', 0, 0, NULL);
INSERT INTO `productos` VALUES (2528, 2, NULL, 'MAGNETO GN125', 'M002', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 15.33, 21.90, 0.00, '2026-02-09 02:30:14', '2026-02-09 02:30:14', 0, 0, NULL);
INSERT INTO `productos` VALUES (2522, 2, NULL, 'LLAVERO RESORTE', 'L021', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 13.00, NULL, 1, 'USD', 0.84, 1.20, 0.00, '2026-02-09 02:30:14', '2026-02-09 02:30:14', 0, 0, NULL);
INSERT INTO `productos` VALUES (2517, 2, NULL, 'LUCES CRUCES DE SBR', 'L017', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 2.24, 3.20, 0.00, '2026-02-09 02:30:13', '2026-02-09 02:30:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (2518, 2, NULL, 'LUCES CRUCE DE GN', 'L018', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 1.89, 2.70, 0.00, '2026-02-09 02:30:13', '2026-02-11 01:29:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2519, 2, NULL, 'LUZ CRUCE CG150 MODELO VIEJO', 'L019', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 1.75, 2.50, 0.00, '2026-02-09 02:30:14', '2026-02-09 02:30:14', 0, 0, NULL);
INSERT INTO `productos` VALUES (2520, 2, NULL, 'LUCES CRUCES HORSE TRASPARENTE', 'L100', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 2.31, 3.30, 0.00, '2026-02-09 02:30:14', '2026-02-09 02:30:14', 0, 0, NULL);
INSERT INTO `productos` VALUES (2514, 2, NULL, 'LLAVE T', 'L014', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:13', '2026-02-09 02:30:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (2515, 2, NULL, 'LLAVERO ELASTICO', 'L015', NULL, 'BENF', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 1.05, 1.50, 0.00, '2026-02-09 02:30:13', '2026-02-09 02:30:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (2512, 2, NULL, 'LLAVE GASOLINA EK-EXPRESS', 'L012', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 1.89, 2.70, 0.00, '2026-02-09 02:30:13', '2026-02-09 02:30:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (2508, 2, NULL, 'LENTES', 'L008', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 2.66, 3.80, 0.00, '2026-02-09 02:30:13', '2026-02-09 02:30:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (2509, 2, NULL, 'LLAVE DE GASOLINA HORSE', 'L009', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 1.89, 2.70, 0.00, '2026-02-09 02:30:13', '2026-02-09 02:30:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (2510, 2, NULL, 'LLAVE GASOLINA DE OWEN', 'L010', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 2.45, 3.50, 0.00, '2026-02-09 02:30:13', '2026-02-12 12:48:22', 0, 0, NULL);
INSERT INTO `productos` VALUES (2511, 2, NULL, 'LLAVE GASOLINA DE GN125', 'L011', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 2.59, 3.70, 0.00, '2026-02-09 02:30:13', '2026-02-09 02:30:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (2505, 2, NULL, 'LIGA 500 ML ROMO', 'L005', NULL, 'ROMO', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 3.36, 4.80, 0.00, '2026-02-09 02:30:12', '2026-02-10 15:10:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (2506, 2, NULL, 'LIGA DE AMARRE', 'L006', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 1.05, 1.50, 0.00, '2026-02-09 02:30:12', '2026-02-09 02:30:12', 0, 0, NULL);
INSERT INTO `productos` VALUES (2500, 2, NULL, 'KIT DE GOMA DECORATIVA 7PZA ROJA S/LLAVERO NEGRO', 'K038', NULL, '', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 2.45, 3.50, 0.00, '2026-02-09 02:30:12', '2026-02-09 02:30:12', 0, 0, NULL);
INSERT INTO `productos` VALUES (2501, 2, NULL, 'LEVA DE CROCHE CG150', 'L001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 12.00, NULL, 1, 'USD', 1.47, 2.10, 0.00, '2026-02-09 02:30:12', '2026-02-11 16:17:20', 0, 0, NULL);
INSERT INTO `productos` VALUES (2502, 2, NULL, 'LEVA DE FRENO CG150', 'L002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 1.47, 2.10, 0.00, '2026-02-09 02:30:12', '2026-02-09 02:30:12', 0, 0, NULL);
INSERT INTO `productos` VALUES (2503, 2, NULL, 'LEVA DE FRENO GN125', 'L003', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:12', '2026-02-09 02:30:12', 0, 0, NULL);
INSERT INTO `productos` VALUES (2498, 2, NULL, 'KIT VALVULA PATA CORTA  P/C CG150', 'K036', NULL, 'BENF', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 1.61, 2.30, 0.00, '2026-02-09 02:30:12', '2026-02-11 14:30:16', 0, 0, NULL);
INSERT INTO `productos` VALUES (2496, 2, NULL, 'KIT VALVULA PATA LARGA  CG150 ACERADA', 'K034', NULL, 'BENF', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 2.66, 3.80, 0.00, '2026-02-09 02:30:12', '2026-02-09 02:30:12', 0, 0, NULL);
INSERT INTO `productos` VALUES (2497, 2, NULL, 'KIT VALVULA PATA LARGA  P/L CG150', 'K035', NULL, 'BENF', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 1.61, 2.30, 0.00, '2026-02-09 02:30:12', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2495, 2, NULL, 'KIT VALVULA PATA LARGA  P/L CAJA DE METAL CG150', 'K033', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 3.36, 4.80, 0.00, '2026-02-09 02:30:12', '2026-02-09 02:30:12', 0, 0, NULL);
INSERT INTO `productos` VALUES (2493, 2, NULL, 'KIT VALVULA PATA LARGA C/GOMA CG200 ACERADA', 'K031', NULL, 'BENF', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 2.66, 3.80, 0.00, '2026-02-09 02:30:11', '2026-02-09 02:30:11', 0, 0, NULL);
INSERT INTO `productos` VALUES (2494, 2, NULL, 'KIT VALVULA PATA LARGA C/GOMA CG200', 'K032', NULL, 'BENF', NULL, 'unidad', 1.00, 13.00, NULL, 1, 'USD', 1.68, 2.40, 0.00, '2026-02-09 02:30:11', '2026-02-09 02:30:11', 0, 0, NULL);
INSERT INTO `productos` VALUES (2491, 2, NULL, 'KIT VALVULA H-150 CON GOMA', 'K029', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 1.33, 1.90, 0.00, '2026-02-09 02:30:11', '2026-02-09 02:30:11', 0, 0, NULL);
INSERT INTO `productos` VALUES (2490, 2, NULL, 'KIT VALVULA H-150 CON GOMA', 'K028', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 13.00, NULL, 1, 'USD', 1.33, 1.90, 0.00, '2026-02-09 02:30:11', '2026-02-09 02:30:11', 0, 0, NULL);
INSERT INTO `productos` VALUES (2489, 2, NULL, 'KIT TAPON DE ACEITE CON FILTRO', 'K027', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:11', '2026-02-09 02:30:11', 0, 0, NULL);
INSERT INTO `productos` VALUES (2486, 2, NULL, 'KIT EMPACADURA CG150', 'K024', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 1.82, 2.60, 0.00, '2026-02-09 02:30:11', '2026-02-09 02:30:11', 0, 0, NULL);
INSERT INTO `productos` VALUES (2487, 2, NULL, 'KIT TRANCA PIñON', 'K025', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 15.00, NULL, 1, 'USD', 0.63, 0.90, 0.00, '2026-02-09 02:30:11', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2488, 2, NULL, 'KIT TORNILLO/ESPARRAGO CAMARA CG150', 'K026', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 2.24, 3.20, 0.00, '2026-02-09 02:30:11', '2026-02-09 02:30:11', 0, 0, NULL);
INSERT INTO `productos` VALUES (2483, 2, NULL, 'KIT REPARACION CALIPER OWEN', 'K021', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:11', '2026-02-09 02:30:11', 0, 0, NULL);
INSERT INTO `productos` VALUES (2484, 2, NULL, 'KIT RESORTE CAMARA H-150', 'K022', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 1.82, 2.60, 0.00, '2026-02-09 02:30:11', '2026-02-09 02:30:11', 0, 0, NULL);
INSERT INTO `productos` VALUES (2485, 2, NULL, 'KIT RESORTE CG150 4-PCS', 'K023', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.63, 0.90, 0.00, '2026-02-09 02:30:11', '2026-02-09 02:30:11', 0, 0, NULL);
INSERT INTO `productos` VALUES (2482, 2, NULL, 'KIT REPARACION BOMBA DE FRENO CG200', 'K020', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 1.40, 2.00, 0.00, '2026-02-09 02:30:10', '2026-02-09 02:30:10', 0, 0, NULL);
INSERT INTO `productos` VALUES (2480, 2, NULL, 'KIT DE GOMA PATA PRENDER+CAMBIO AZUL', 'K018', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:10', '2026-02-09 02:30:10', 0, 0, NULL);
INSERT INTO `productos` VALUES (2481, 2, NULL, 'KIT REPARACION CALIPER CG150', 'K019', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:30:10', '2026-02-09 02:30:10', 0, 0, NULL);
INSERT INTO `productos` VALUES (2477, 2, NULL, 'KIT EMPACADURA TEX-200 CLASE A', 'K015', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 2.24, 3.20, 0.00, '2026-02-09 02:30:10', '2026-02-09 02:30:10', 0, 0, NULL);
INSERT INTO `productos` VALUES (2478, 2, NULL, 'KIT EMPACADURA CON CONTRA PESO', 'K016', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 2.03, 2.90, 0.00, '2026-02-09 02:30:10', '2026-02-09 02:30:10', 0, 0, NULL);
INSERT INTO `productos` VALUES (2476, 2, NULL, 'KIT DE TORNILLOS DE MOTOR', 'K014', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 1.82, 2.60, 0.00, '2026-02-09 02:30:10', '2026-02-09 02:30:10', 0, 0, NULL);
INSERT INTO `productos` VALUES (2475, 2, NULL, 'KIT DE TORNILLO DE PORTA CORONA PALETA', 'K013', NULL, 'BENF', NULL, 'unidad', 1.00, 11.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:30:10', '2026-02-09 02:30:10', 0, 0, NULL);
INSERT INTO `productos` VALUES (2468, 2, NULL, 'KIT DE EMPACADURA CG150', 'K006', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 1.75, 2.50, 0.00, '2026-02-09 02:30:09', '2026-02-09 02:30:09', 0, 0, NULL);
INSERT INTO `productos` VALUES (2469, 2, NULL, 'KIT DE EMPACADURA CG150', 'K007', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 2.03, 2.90, 0.00, '2026-02-09 02:30:09', '2026-02-09 02:30:09', 0, 0, NULL);
INSERT INTO `productos` VALUES (2470, 2, NULL, 'KIT DE ESTRELLA', 'K008', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:30:09', '2026-02-09 02:30:09', 0, 0, NULL);
INSERT INTO `productos` VALUES (2471, 2, NULL, 'KIT DE GOMA DECORATIVO', 'K009', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 3.36, 4.80, 0.00, '2026-02-09 02:30:10', '2026-02-12 14:23:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (2472, 2, NULL, 'KIT DE REPARACION CALIPER H-150', 'K010', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:30:10', '2026-02-09 02:30:10', 0, 0, NULL);
INSERT INTO `productos` VALUES (2459, 2, NULL, 'INSTALACION EXPREES', 'I005', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 9.03, 12.90, 0.00, '2026-02-09 02:30:09', '2026-02-09 02:30:09', 0, 0, NULL);
INSERT INTO `productos` VALUES (2454, 2, NULL, 'HUESO ACELERADOR CG150-V/H-150 SPEED24', 'H004', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 0.56, 0.80, 0.00, '2026-02-09 02:30:08', '2026-02-09 02:30:08', 0, 0, NULL);
INSERT INTO `productos` VALUES (2455, 2, NULL, 'INSTALACION CG150', 'I001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 9.59, 13.70, 0.00, '2026-02-09 02:30:08', '2026-02-09 02:30:08', 0, 0, NULL);
INSERT INTO `productos` VALUES (2456, 2, NULL, 'INSTALACION CG150', 'I002', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 9.03, 12.90, 0.00, '2026-02-09 02:30:08', '2026-02-09 02:30:08', 0, 0, NULL);
INSERT INTO `productos` VALUES (2457, 2, NULL, 'INSTALACION H-150', 'I003', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 11.06, 15.80, 0.00, '2026-02-09 02:30:08', '2026-02-09 02:30:08', 0, 0, NULL);
INSERT INTO `productos` VALUES (2458, 2, NULL, 'INSTALACION HOWING 2014', 'I004', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 8.75, 12.50, 0.00, '2026-02-09 02:30:08', '2026-02-11 01:29:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2450, 2, NULL, 'HORQUILLA HORSE', 'H001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 13.86, 19.80, 0.00, '2026-02-09 02:30:08', '2026-02-09 02:30:08', 0, 0, NULL);
INSERT INTO `productos` VALUES (2451, 2, NULL, 'HORQUILLA OWEN', 'H002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 13.16, 18.80, 0.00, '2026-02-09 02:30:08', '2026-02-09 02:30:08', 0, 0, NULL);
INSERT INTO `productos` VALUES (2452, 2, NULL, 'HORQUILLA SBR', 'H003', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 15.33, 21.90, 0.00, '2026-02-09 02:30:08', '2026-02-09 02:30:08', 0, 0, NULL);
INSERT INTO `productos` VALUES (2445, 2, NULL, 'GOMA DE PORTA CORONA AZUL GN', 'G066', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 1.40, 2.00, 0.00, '2026-02-09 02:30:07', '2026-02-09 02:30:07', 0, 0, NULL);
INSERT INTO `productos` VALUES (2444, 2, NULL, 'GOMA DE PORTA CORONA AZUL MD AGUILA', 'G065', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:30:07', '2026-02-09 02:30:07', 0, 0, NULL);
INSERT INTO `productos` VALUES (2443, 2, NULL, 'GUIA DE VALVULA CG150', 'G064', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:30:07', '2026-02-09 02:30:07', 0, 0, NULL);
INSERT INTO `productos` VALUES (2441, 2, NULL, 'GUAYA KILOMETRAJE H-150', 'G062', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:07', '2026-02-09 02:30:07', 0, 0, NULL);
INSERT INTO `productos` VALUES (2442, 2, NULL, 'GUAYA KILOMETRAJE SPEED', 'G063', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:07', '2026-02-09 02:30:07', 0, 0, NULL);
INSERT INTO `productos` VALUES (2436, 2, NULL, 'GUAYA DE FRENO DELANTERO EXPRESS', 'G057', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 11.00, NULL, 1, 'USD', 1.54, 2.20, 0.00, '2026-02-09 02:30:07', '2026-02-09 02:30:07', 0, 0, NULL);
INSERT INTO `productos` VALUES (2437, 2, NULL, 'GUAYA DE KILOMETRAJE DE HORSE', 'G058', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:07', '2026-02-09 02:30:07', 0, 0, NULL);
INSERT INTO `productos` VALUES (2438, 2, NULL, 'GUAYA DE KILOMETRAJE DE SPREES PALETA', 'G059', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:07', '2026-02-09 02:30:07', 0, 0, NULL);
INSERT INTO `productos` VALUES (2434, 2, NULL, 'GUAYA DE CROCHE GN', 'G055', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:07', '2026-02-09 02:30:07', 0, 0, NULL);
INSERT INTO `productos` VALUES (2435, 2, NULL, 'GUAYA DE CROCHE OWEN', 'G056', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:07', '2026-02-09 02:30:07', 0, 0, NULL);
INSERT INTO `productos` VALUES (2428, 2, NULL, 'GUAYA DE CROCHET DE HORSE', 'G049', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:06', '2026-02-09 02:30:06', 0, 0, NULL);
INSERT INTO `productos` VALUES (2426, 2, NULL, 'GUAYA DE KILOMETRAJE A-150', 'G047', NULL, 'BENF', NULL, 'unidad', 1.00, 19.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:30:06', '2026-02-09 02:30:06', 0, 0, NULL);
INSERT INTO `productos` VALUES (2427, 2, NULL, 'GUAYA DE ACELERACION CG150', 'G048', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:30:06', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2424, 2, NULL, 'GUAYA DE ACELERACION DE TX200', 'G045', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:30:06', '2026-02-09 02:30:06', 0, 0, NULL);
INSERT INTO `productos` VALUES (2421, 2, NULL, 'GUAYA DE ACELERACION DE OWEN 2009', 'G042', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 1.19, 1.70, 0.00, '2026-02-09 02:30:05', '2026-02-09 02:30:05', 0, 0, NULL);
INSERT INTO `productos` VALUES (2422, 2, NULL, 'GUAYA DE ACELERACION DE OWEN 2011', 'G043', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 1.19, 1.70, 0.00, '2026-02-09 02:30:06', '2026-02-09 02:30:06', 0, 0, NULL);
INSERT INTO `productos` VALUES (2423, 2, NULL, 'GUAYA DE ACELERACION DE OWEN 2014', 'G044', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 1.19, 1.70, 0.00, '2026-02-09 02:30:06', '2026-02-09 02:30:06', 0, 0, NULL);
INSERT INTO `productos` VALUES (2418, 2, NULL, 'GUAYA DE ACELERACION DE EXPRESS', 'G039', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 19.00, NULL, 1, 'USD', 1.19, 1.70, 0.00, '2026-02-09 02:30:05', '2026-02-09 02:30:05', 0, 0, NULL);
INSERT INTO `productos` VALUES (2419, 2, NULL, 'GUAYA DE ACELERACION DE G125H', 'G040', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:05', '2026-02-09 02:30:05', 0, 0, NULL);
INSERT INTO `productos` VALUES (2420, 2, NULL, 'GUAYA DE ACELERACION DE OWEN 2009', 'G041', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 1.19, 1.70, 0.00, '2026-02-09 02:30:05', '2026-02-09 02:30:05', 0, 0, NULL);
INSERT INTO `productos` VALUES (2417, 2, NULL, 'GUAYA DE ACELERACION DE EXPRESS', 'G038', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 1.19, 1.70, 0.00, '2026-02-09 02:30:05', '2026-02-09 02:30:05', 0, 0, NULL);
INSERT INTO `productos` VALUES (2410, 2, NULL, 'GUAYA CROCHE UNIVERSAL', 'G031', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 41.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:30:05', '2026-02-09 02:30:05', 0, 0, NULL);
INSERT INTO `productos` VALUES (2411, 2, NULL, 'GUAYA CROCHE UNIVERSAL CON PERNO', 'G032', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 32.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:30:05', '2026-02-11 01:29:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2412, 2, NULL, 'GUAYA CROCHE OVEN-2014', 'G033', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:05', '2026-02-09 02:30:05', 0, 0, NULL);
INSERT INTO `productos` VALUES (2413, 2, NULL, 'GUAYA DE  ACELERACION HORSE', 'G034', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 1.19, 1.70, 0.00, '2026-02-09 02:30:05', '2026-02-09 02:30:05', 0, 0, NULL);
INSERT INTO `productos` VALUES (2414, 2, NULL, 'GUAYA DE  ACELERACION HORSE', 'G035', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 1.19, 1.70, 0.00, '2026-02-09 02:30:05', '2026-02-09 02:30:05', 0, 0, NULL);
INSERT INTO `productos` VALUES (2409, 2, NULL, 'GUAYA CROCHE EK-JORSE', 'G030', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 1.47, 2.10, 0.00, '2026-02-09 02:30:04', '2026-02-09 02:30:04', 0, 0, NULL);
INSERT INTO `productos` VALUES (2408, 2, NULL, 'GUARDAFANGO DELANTERO EXPRESS AZUL', 'G028', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:04', '2026-02-09 02:30:04', 0, 0, NULL);
INSERT INTO `productos` VALUES (2407, 2, NULL, 'GUARDAFANGO ESCUDA', 'G027', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:04', '2026-02-09 02:30:04', 0, 0, NULL);
INSERT INTO `productos` VALUES (2405, 2, NULL, 'GUARDA FANGO DELANTERO NEGRO SBR', 'G025', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 6.44, 9.20, 0.00, '2026-02-09 02:30:04', '2026-02-09 02:30:04', 0, 0, NULL);
INSERT INTO `productos` VALUES (2403, 2, NULL, 'GUARDA FANGO DELANTERO ROJO SBR', 'G023', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 6.44, 9.20, 0.00, '2026-02-09 02:30:04', '2026-02-09 02:30:04', 0, 0, NULL);
INSERT INTO `productos` VALUES (2404, 2, NULL, 'GUARDA FANGO DELANTERO OWEN NEGRO', 'G024', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 7.70, 11.00, 0.00, '2026-02-09 02:30:04', '2026-02-09 02:30:04', 0, 0, NULL);
INSERT INTO `productos` VALUES (2397, 2, NULL, 'GOMA POSAPIE H-150 ROJO', 'G017', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:03', '2026-02-09 02:30:03', 0, 0, NULL);
INSERT INTO `productos` VALUES (2394, 2, NULL, 'GOMA DE PORTA CORONA GN', 'G014', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:30:03', '2026-02-09 02:30:03', 0, 0, NULL);
INSERT INTO `productos` VALUES (2391, 2, NULL, 'GOMA MANILA DE GUAYA COLORES VARIADOS', 'G011', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 15.00, NULL, 1, 'USD', 0.42, 0.60, 0.00, '2026-02-09 02:30:03', '2026-02-09 02:30:03', 0, 0, NULL);
INSERT INTO `productos` VALUES (2390, 2, NULL, 'GOMA DE VALVULA', 'G010', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 54.00, NULL, 1, 'USD', 0.21, 0.30, 0.00, '2026-02-09 02:30:03', '2026-02-09 02:30:03', 0, 0, NULL);
INSERT INTO `productos` VALUES (2387, 2, NULL, 'GOMA DE GUAYA GUARDAFANGO EK', 'G007', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:30:03', '2026-02-09 02:30:03', 0, 0, NULL);
INSERT INTO `productos` VALUES (2388, 2, NULL, 'GOMA DE GUAYA GUARDAFANGO SBR', 'G008', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:03', '2026-02-09 02:30:03', 0, 0, NULL);
INSERT INTO `productos` VALUES (2389, 2, NULL, 'GOMA DE TANQUE GN125', 'G009', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 1.19, 1.70, 0.00, '2026-02-09 02:30:03', '2026-02-09 02:30:03', 0, 0, NULL);
INSERT INTO `productos` VALUES (2382, 2, NULL, 'GOMA DE CAMARA', 'G002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 43.00, NULL, 1, 'USD', 0.35, 0.50, 0.00, '2026-02-09 02:30:02', '2026-02-09 02:30:02', 0, 0, NULL);
INSERT INTO `productos` VALUES (2381, 2, NULL, 'GEMELO PEQUEÑO', 'G001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 1.68, 2.40, 0.00, '2026-02-09 02:30:02', '2026-02-09 02:30:02', 0, 0, NULL);
INSERT INTO `productos` VALUES (2380, 2, NULL, 'FORRO DE ASIENTO DE GN', 'F033', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 3.15, 4.50, 0.00, '2026-02-09 02:30:02', '2026-02-09 02:30:02', 0, 0, NULL);
INSERT INTO `productos` VALUES (2377, 2, NULL, 'FUSIBLE', 'F030', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:02', '2026-02-09 02:30:02', 0, 0, NULL);
INSERT INTO `productos` VALUES (2378, 2, NULL, 'FUSILERA CON CABLE UNIVERSAL', 'F031', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 14.00, NULL, 1, 'USD', 0.98, 1.40, 0.00, '2026-02-09 02:30:02', '2026-02-11 01:29:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2379, 2, NULL, 'FLAZH CRUCE 12V', 'F032', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 0.84, 1.20, 0.00, '2026-02-09 02:30:02', '2026-02-09 02:30:02', 0, 0, NULL);
INSERT INTO `productos` VALUES (2376, 2, NULL, 'FORROS PARA MANDOS', 'F029', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:30:02', '2026-02-09 02:30:02', 0, 0, NULL);
INSERT INTO `productos` VALUES (2375, 2, NULL, 'FORROS PARA MANDOS', 'F028', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:02', '2026-02-09 02:30:02', 0, 0, NULL);
INSERT INTO `productos` VALUES (2374, 2, NULL, 'FORRO DE ASIENTO PARA TAPISAR', 'F027', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:02', '2026-02-09 02:30:02', 0, 0, NULL);
INSERT INTO `productos` VALUES (2372, 2, NULL, 'FORRO ASIENTO CG150', 'F025', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:01', '2026-02-09 02:30:01', 0, 0, NULL);
INSERT INTO `productos` VALUES (2373, 2, NULL, 'FORRO ASIENTO HORSE', 'F026', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 3.15, 4.50, 0.00, '2026-02-09 02:30:01', '2026-02-09 02:30:01', 0, 0, NULL);
INSERT INTO `productos` VALUES (2368, 2, NULL, 'FLAZH CRUCE 12V', 'F021', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.91, 1.30, 0.00, '2026-02-09 02:30:01', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2369, 2, NULL, 'FLOTANTE GASOLINA CG150', 'F022', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 2.87, 4.10, 0.00, '2026-02-09 02:30:01', '2026-02-09 02:30:01', 0, 0, NULL);
INSERT INTO `productos` VALUES (2370, 2, NULL, 'FLOTANTE GASOLINA CG150', 'F023', NULL, 'BENF', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 2.87, 4.10, 0.00, '2026-02-09 02:30:01', '2026-02-09 02:30:01', 0, 0, NULL);
INSERT INTO `productos` VALUES (2371, 2, NULL, 'FLOTANTE GASOLINA H-150', 'F024', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 2.87, 4.10, 0.00, '2026-02-09 02:30:01', '2026-02-09 02:30:01', 0, 0, NULL);
INSERT INTO `productos` VALUES (2367, 2, NULL, 'FILTRO GASOLINA', 'F020', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 28.00, NULL, 1, 'USD', 0.21, 0.30, 0.00, '2026-02-09 02:30:01', '2026-02-09 02:30:01', 0, 0, NULL);
INSERT INTO `productos` VALUES (2366, 2, NULL, 'FILTRO DE GASOLINA DECORATIVO', 'F019', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 101.00, NULL, 1, 'USD', 1.96, 2.80, 0.00, '2026-02-09 02:30:01', '2026-02-09 02:30:01', 0, 0, NULL);
INSERT INTO `productos` VALUES (2365, 2, NULL, 'FILTRO DE GASOLINA', 'F018', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 18.00, NULL, 1, 'USD', 0.21, 0.30, 0.00, '2026-02-09 02:30:01', '2026-02-12 12:48:22', 0, 0, NULL);
INSERT INTO `productos` VALUES (2362, 2, NULL, 'FALDA DE H-150 ROJO', 'F015', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:01', '2026-02-09 02:30:01', 0, 0, NULL);
INSERT INTO `productos` VALUES (2363, 2, NULL, 'FALDA DE H-150 AZUL', 'F016', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 8.33, 11.90, 0.00, '2026-02-09 02:30:01', '2026-02-09 02:30:01', 0, 0, NULL);
INSERT INTO `productos` VALUES (2364, 2, NULL, 'FILTRO CARBURADOR CONICO DE AIRE', 'F017', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 2.80, 4.00, 0.00, '2026-02-09 02:30:01', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2360, 2, NULL, 'FARO DE LUPA CON BASE GRANDE', 'F013', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 12.95, 18.50, 0.00, '2026-02-09 02:30:00', '2026-02-09 02:30:00', 0, 0, NULL);
INSERT INTO `productos` VALUES (2361, 2, NULL, 'FALDA DE H-150 NEGRO', 'F014', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 8.33, 11.90, 0.00, '2026-02-09 02:30:00', '2026-02-09 02:30:00', 0, 0, NULL);
INSERT INTO `productos` VALUES (2354, 2, NULL, 'FARO SBR DECORATIVO', 'F007', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 17.43, 24.90, 0.00, '2026-02-09 02:30:00', '2026-02-09 02:30:00', 0, 0, NULL);
INSERT INTO `productos` VALUES (2352, 2, NULL, 'FARO GN', 'F005', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 10.43, 14.90, 0.00, '2026-02-09 02:30:00', '2026-02-09 02:30:00', 0, 0, NULL);
INSERT INTO `productos` VALUES (2353, 2, NULL, 'FARO SOCIAL', 'F006', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 10.43, 14.90, 0.00, '2026-02-09 02:30:00', '2026-02-09 02:30:00', 0, 0, NULL);
INSERT INTO `productos` VALUES (2350, 2, NULL, 'FARO DELGADO LARGO HORIZONTAL', 'F003', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:00', '2026-02-09 02:30:00', 0, 0, NULL);
INSERT INTO `productos` VALUES (2351, 2, NULL, 'FARO EXPRESS', 'F004', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 10.43, 14.90, 0.00, '2026-02-09 02:30:00', '2026-02-09 02:30:00', 0, 0, NULL);
INSERT INTO `productos` VALUES (2347, 2, NULL, 'EJE TRASERO DE HORSE', 'E039', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 14.00, NULL, 1, 'USD', 2.24, 3.20, 0.00, '2026-02-09 02:29:59', '2026-02-10 18:08:44', 0, 0, NULL);
INSERT INTO `productos` VALUES (2346, 2, NULL, 'EXTRACTO DE CROCHERA', 'E038', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:59', '2026-02-09 02:29:59', 0, 0, NULL);
INSERT INTO `productos` VALUES (2345, 2, NULL, 'EXTRACTO DE LEVA', 'E037', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:59', '2026-02-09 02:29:59', 0, 0, NULL);
INSERT INTO `productos` VALUES (2344, 2, NULL, 'ESTOPERA TX CAÑA', 'E036', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 1.05, 1.50, 0.00, '2026-02-09 02:29:59', '2026-02-09 02:29:59', 0, 0, NULL);
INSERT INTO `productos` VALUES (2339, 2, NULL, 'ESTOPERA BASTON CG150 27*39*10.5', 'E031', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 0.77, 1.10, 0.00, '2026-02-09 02:29:59', '2026-02-09 02:29:59', 0, 0, NULL);
INSERT INTO `productos` VALUES (2340, 2, NULL, 'ESTOPERA BASTON 1', 'E032', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:59', '2026-02-09 02:29:59', 0, 0, NULL);
INSERT INTO `productos` VALUES (2341, 2, NULL, 'ESTOPERA BASTON GN125', 'E033', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 0.91, 1.30, 0.00, '2026-02-09 02:29:59', '2026-02-09 02:29:59', 0, 0, NULL);
INSERT INTO `productos` VALUES (2793, 2, NULL, 'TAPA VALVULA DE BALA', 'T033', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:36', '2026-02-09 02:30:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2336, 2, NULL, 'EJE TRASERO CG150', 'E028', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 11.00, NULL, 1, 'USD', 1.75, 2.50, 0.00, '2026-02-09 02:29:58', '2026-02-09 02:29:58', 0, 0, NULL);
INSERT INTO `productos` VALUES (2337, 2, NULL, 'ESPARRAGO DE ESCAPE 8MM', 'E029', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:29:58', '2026-02-11 18:43:53', 0, 0, NULL);
INSERT INTO `productos` VALUES (2338, 2, NULL, 'ESTOPERA BASTON A-150/H-150 31.43.10.3', 'E030', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 0.77, 1.10, 0.00, '2026-02-09 02:29:59', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2335, 2, NULL, 'ESPARRAGO DE ESCAPE 6MM', 'E027', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:29:58', '2026-02-09 02:29:58', 0, 0, NULL);
INSERT INTO `productos` VALUES (2334, 2, NULL, 'ENROLLADO 5 CABLE CG150/XPRESS/MD', 'E026', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 6.16, 8.80, 0.00, '2026-02-09 02:29:58', '2026-02-09 02:29:58', 0, 0, NULL);
INSERT INTO `productos` VALUES (2331, 2, NULL, 'EMRROLLADO 4 CABLE H150', 'E023', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 6.51, 9.30, 0.00, '2026-02-09 02:29:58', '2026-02-09 02:29:58', 0, 0, NULL);
INSERT INTO `productos` VALUES (2332, 2, NULL, 'ENROLLADO 5 CABLE CG150/XPRESS/MD', 'E024', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 8.89, 12.70, 0.00, '2026-02-09 02:29:58', '2026-02-09 02:29:58', 0, 0, NULL);
INSERT INTO `productos` VALUES (2333, 2, NULL, 'ENROLLADO 5 CABLE CG150/XPRESS/MD', 'E025', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 8.05, 11.50, 0.00, '2026-02-09 02:29:58', '2026-02-09 02:29:58', 0, 0, NULL);
INSERT INTO `productos` VALUES (2327, 2, NULL, 'EMPACADURA CON CONTRA PESO', 'E019', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 17.00, NULL, 1, 'USD', 0.56, 0.80, 0.00, '2026-02-09 02:29:58', '2026-02-09 02:29:58', 0, 0, NULL);
INSERT INTO `productos` VALUES (2328, 2, NULL, 'EMPACADURA CROCHE CG150 SOLA', 'E020', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 23.00, NULL, 1, 'USD', 0.42, 0.60, 0.00, '2026-02-09 02:29:58', '2026-02-09 02:29:58', 0, 0, NULL);
INSERT INTO `productos` VALUES (2326, 2, NULL, 'EMPACADURA CILINDRO Y CAMARA 4', 'E018', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:58', '2026-02-09 02:29:58', 0, 0, NULL);
INSERT INTO `productos` VALUES (2325, 2, NULL, 'ENRROLLASDO 5 CABLES CLASE A 100% COBRE', 'E017', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 6.51, 9.30, 0.00, '2026-02-09 02:29:57', '2026-02-11 01:29:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2323, 2, NULL, 'EMBLEMA DE HORSE', 'E015', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:57', '2026-02-09 02:29:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (2324, 2, NULL, 'EMBLEMA DE OWEN par', 'E016', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 14.00, NULL, 1, 'USD', 1.68, 2.40, 0.00, '2026-02-09 02:29:57', '2026-02-09 02:29:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (2321, 2, NULL, 'ELEVADORES HUECO GRANDE', 'E013', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 2.45, 3.50, 0.00, '2026-02-09 02:29:57', '2026-02-09 02:29:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (2320, 2, NULL, 'EJE DE HORQUILLA H-150', 'E012', NULL, 'BENF', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 1.75, 2.50, 0.00, '2026-02-09 02:29:57', '2026-02-09 02:29:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (2319, 2, NULL, 'EJE DE ARRANQUE CG150', 'E011', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 3.78, 5.40, 0.00, '2026-02-09 02:29:57', '2026-02-09 02:29:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (2312, 2, NULL, 'EJE DELANTERO GN', 'E004', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:56', '2026-02-09 02:29:56', 0, 0, NULL);
INSERT INTO `productos` VALUES (2311, 2, NULL, 'EJE DE HORQUILLA HORSE', 'E003', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:56', '2026-02-09 02:29:56', 0, 0, NULL);
INSERT INTO `productos` VALUES (2310, 2, NULL, 'EJE DE HORQUILLA CG150', 'E002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:56', '2026-02-09 02:29:56', 0, 0, NULL);
INSERT INTO `productos` VALUES (2308, 2, NULL, 'DISCO DE FRENO GN', 'D011', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 5.95, 8.50, 0.00, '2026-02-09 02:29:56', '2026-02-09 02:29:56', 0, 0, NULL);
INSERT INTO `productos` VALUES (2307, 2, NULL, 'DISCO DE FRENO SBR', 'D010', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 8.96, 12.80, 0.00, '2026-02-09 02:29:56', '2026-02-09 02:29:56', 0, 0, NULL);
INSERT INTO `productos` VALUES (2306, 2, NULL, 'DISCO CROCHE  H-150 5PZ', 'D009', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 2.10, 3.00, 0.00, '2026-02-09 02:29:56', '2026-02-09 02:29:56', 0, 0, NULL);
INSERT INTO `productos` VALUES (2304, 2, NULL, 'DESCANSA MANO NEGRO', 'D007', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:29:56', '2026-02-09 02:29:56', 0, 0, NULL);
INSERT INTO `productos` VALUES (2301, 2, NULL, 'DIAFRAGMA', 'D004', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 1.40, 2.00, 0.00, '2026-02-09 02:29:55', '2026-02-09 02:29:55', 0, 0, NULL);
INSERT INTO `productos` VALUES (2302, 2, NULL, 'DESCANSA MANO AZUL', 'D005', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:29:56', '2026-02-09 02:29:56', 0, 0, NULL);
INSERT INTO `productos` VALUES (2303, 2, NULL, 'DESCANSA MANO BLANCO', 'D006', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:29:56', '2026-02-09 02:29:56', 0, 0, NULL);
INSERT INTO `productos` VALUES (2298, 2, NULL, 'DISCO CROCHE  CG150 6PZ', 'D001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:55', '2026-02-09 02:29:55', 0, 0, NULL);
INSERT INTO `productos` VALUES (2299, 2, NULL, 'DISCO CROCHE  H-150 5PZ', 'D002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 2.17, 3.10, 0.00, '2026-02-09 02:29:55', '2026-02-09 02:29:55', 0, 0, NULL);
INSERT INTO `productos` VALUES (2300, 2, NULL, 'DISCO DE CROCHET BSN 200', 'D003', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 2.66, 3.80, 0.00, '2026-02-09 02:29:55', '2026-02-09 02:29:55', 0, 0, NULL);
INSERT INTO `productos` VALUES (2296, 2, NULL, 'CASCO SEMI INTEGRAL 56 PROJECT BLANCO', 'C136', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 18.13, 25.90, 0.00, '2026-02-09 02:29:55', '2026-02-09 02:29:55', 0, 0, NULL);
INSERT INTO `productos` VALUES (2297, 2, NULL, 'CASCO SEMI INTEGRAL 56 PROJECT AZUL', 'C137', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 18.13, 25.90, 0.00, '2026-02-09 02:29:55', '2026-02-09 02:29:55', 0, 0, NULL);
INSERT INTO `productos` VALUES (2292, 2, NULL, 'CARCASA DE FARO SBR', 'C132', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 2.52, 3.60, 0.00, '2026-02-09 02:29:55', '2026-02-09 02:29:55', 0, 0, NULL);
INSERT INTO `productos` VALUES (2293, 2, NULL, 'CARCASA DE TACOMETRO DE XPRES', 'C133', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 7.21, 10.30, 0.00, '2026-02-09 02:29:55', '2026-02-09 02:29:55', 0, 0, NULL);
INSERT INTO `productos` VALUES (2294, 2, NULL, 'CASCO SEMI INTEGRAL 56 PROJECT ROJO', 'C134', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 18.13, 25.90, 0.00, '2026-02-09 02:29:55', '2026-02-09 02:29:55', 0, 0, NULL);
INSERT INTO `productos` VALUES (2288, 2, NULL, 'CABLE NEGRO DE BATERIA', 'C128', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 20.00, NULL, 1, 'USD', 0.35, 0.50, 0.00, '2026-02-09 02:29:54', '2026-02-09 02:29:54', 0, 0, NULL);
INSERT INTO `productos` VALUES (2289, 2, NULL, 'CABLE ROJO DE BATERIA', 'C129', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 20.00, NULL, 1, 'USD', 0.35, 0.50, 0.00, '2026-02-09 02:29:55', '2026-02-09 02:29:55', 0, 0, NULL);
INSERT INTO `productos` VALUES (2290, 2, NULL, 'CADENA REFORZADA NEGRA', 'C130', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 4.97, 7.10, 0.00, '2026-02-09 02:29:55', '2026-02-09 02:29:55', 0, 0, NULL);
INSERT INTO `productos` VALUES (2291, 2, NULL, 'CARBURADOR PZ30', 'C131', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 12.18, 17.40, 0.00, '2026-02-09 02:29:55', '2026-02-09 02:29:55', 0, 0, NULL);
INSERT INTO `productos` VALUES (2287, 2, NULL, 'CORNETA MP3', 'C127', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 15.96, 22.80, 0.00, '2026-02-09 02:29:54', '2026-02-09 02:29:54', 0, 0, NULL);
INSERT INTO `productos` VALUES (2284, 2, NULL, 'CAJA 200', 'C124', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 22.33, 31.90, 0.00, '2026-02-09 02:29:54', '2026-02-09 02:29:54', 0, 0, NULL);
INSERT INTO `productos` VALUES (2285, 2, NULL, 'CAñA DE XPRESS', 'C125', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 37.66, 53.80, 0.00, '2026-02-09 02:29:54', '2026-02-09 02:29:54', 0, 0, NULL);
INSERT INTO `productos` VALUES (2281, 2, NULL, 'CAMARA SOLA A-150', 'C121', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 40.04, 57.20, 0.00, '2026-02-09 02:29:54', '2026-02-09 02:29:54', 0, 0, NULL);
INSERT INTO `productos` VALUES (2282, 2, NULL, 'cigUeñal A-150', 'C122', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:54', '2026-02-09 02:29:54', 0, 0, NULL);
INSERT INTO `productos` VALUES (2283, 2, NULL, 'CONCHA DE ESCAPE H-150 6MM', 'C123', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 1.68, 2.40, 0.00, '2026-02-09 02:29:54', '2026-02-09 02:29:54', 0, 0, NULL);
INSERT INTO `productos` VALUES (2276, 2, NULL, 'CUENTA KILOMETRAJE A150', 'C116', NULL, 'BENF', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 2.66, 3.80, 0.00, '2026-02-09 02:29:53', '2026-02-09 02:29:53', 0, 0, NULL);
INSERT INTO `productos` VALUES (2277, 2, NULL, 'CILINDRO DE CG150', 'C117', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:54', '2026-02-09 02:29:54', 0, 0, NULL);
INSERT INTO `productos` VALUES (2278, 2, NULL, 'CILINDRO DE H-150', 'C118', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:54', '2026-02-09 02:29:54', 0, 0, NULL);
INSERT INTO `productos` VALUES (2279, 2, NULL, 'COPA DE ACEITE CG200', 'C119', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 2.03, 2.90, 0.00, '2026-02-09 02:29:54', '2026-02-09 02:29:54', 0, 0, NULL);
INSERT INTO `productos` VALUES (2280, 2, NULL, 'COPA DE ACEITE TX200', 'C120', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 2.31, 3.30, 0.00, '2026-02-09 02:29:54', '2026-02-09 02:29:54', 0, 0, NULL);
INSERT INTO `productos` VALUES (2274, 2, NULL, 'CUENTA KILOMETRO EK-SPRESS', 'C114', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:53', '2026-02-09 02:29:53', 0, 0, NULL);
INSERT INTO `productos` VALUES (2275, 2, NULL, 'CAJA 150', 'C115', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 14.63, 20.90, 0.00, '2026-02-09 02:29:53', '2026-02-09 02:29:53', 0, 0, NULL);
INSERT INTO `productos` VALUES (2271, 2, NULL, 'CUENTA KILOMETRO GN125', 'C111', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:53', '2026-02-09 02:29:53', 0, 0, NULL);
INSERT INTO `productos` VALUES (2272, 2, NULL, 'CUENTA KILOMETRO H-150', 'C112', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 2.59, 3.70, 0.00, '2026-02-09 02:29:53', '2026-02-09 02:29:53', 0, 0, NULL);
INSERT INTO `productos` VALUES (2273, 2, NULL, 'CUENTA KILOMETRO SBR', 'C113', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 13.00, NULL, 1, 'USD', 2.59, 3.70, 0.00, '2026-02-09 02:29:53', '2026-02-09 02:29:53', 0, 0, NULL);
INSERT INTO `productos` VALUES (2266, 2, NULL, 'CREMALLERA SOLA', 'C106', NULL, 'ZETA', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 2.45, 3.50, 0.00, '2026-02-09 02:29:53', '2026-02-09 02:29:53', 0, 0, NULL);
INSERT INTO `productos` VALUES (2265, 2, NULL, 'CREMALLERA  GN125 COMPLETA', 'C105', NULL, 'ZETA', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:53', '2026-02-09 02:29:53', 0, 0, NULL);
INSERT INTO `productos` VALUES (2261, 2, NULL, 'CORTA CORRIENTE', 'C101', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 1.12, 1.60, 0.00, '2026-02-09 02:29:52', '2026-02-09 02:29:52', 0, 0, NULL);
INSERT INTO `productos` VALUES (2257, 2, NULL, 'CORONA PALETRA DORADA 37T CURVA', 'C097', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:52', '2026-02-09 02:29:52', 0, 0, NULL);
INSERT INTO `productos` VALUES (2258, 2, NULL, 'CORONA PALETRA DORADA 1', 'C098', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:52', '2026-02-09 02:29:52', 0, 0, NULL);
INSERT INTO `productos` VALUES (2259, 2, NULL, 'CORONA PALETA 1', 'C099', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:52', '2026-02-09 02:29:52', 0, 0, NULL);
INSERT INTO `productos` VALUES (2260, 2, NULL, 'CORREA DE BATERIA', 'C100', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:29:52', '2026-02-09 02:29:52', 0, 0, NULL);
INSERT INTO `productos` VALUES (2254, 2, NULL, 'CORONA PALETRA DORADA 36T CURVA', 'C094', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 3.64, 5.20, 0.00, '2026-02-09 02:29:52', '2026-02-09 02:29:52', 0, 0, NULL);
INSERT INTO `productos` VALUES (2253, 2, NULL, 'CORONA PALETRA DORADA GN-43T', 'C093', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:52', '2026-02-09 02:29:52', 0, 0, NULL);
INSERT INTO `productos` VALUES (2251, 2, NULL, 'CORONA PALETRA DORADA GN-39T', 'C091', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:51', '2026-02-09 02:29:51', 0, 0, NULL);
INSERT INTO `productos` VALUES (2252, 2, NULL, 'CORONA PALETRA DORADA GN-42T', 'C092', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:51', '2026-02-09 02:29:51', 0, 0, NULL);
INSERT INTO `productos` VALUES (2246, 2, NULL, 'CORONA PALETA DORADA GN-35T', 'C086', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:51', '2026-02-09 02:29:51', 0, 0, NULL);
INSERT INTO `productos` VALUES (2245, 2, NULL, 'CORONA DORADA DE RAYO 39T', 'C085', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 3.64, 5.20, 0.00, '2026-02-09 02:29:51', '2026-02-09 02:29:51', 0, 0, NULL);
INSERT INTO `productos` VALUES (2244, 2, NULL, 'CORONA DORADA DE RAYO 37T', 'C084', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 3.64, 5.20, 0.00, '2026-02-09 02:29:51', '2026-02-09 02:29:51', 0, 0, NULL);
INSERT INTO `productos` VALUES (2242, 2, NULL, 'CORONA DE RAYO PLATEADA 36T', 'C082', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 3.43, 4.90, 0.00, '2026-02-09 02:29:51', '2026-02-09 02:29:51', 0, 0, NULL);
INSERT INTO `productos` VALUES (2241, 2, NULL, 'CORONA DE PALETA PLATEADA 45T GN', 'C081', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 4.06, 5.80, 0.00, '2026-02-09 02:29:51', '2026-02-09 02:29:51', 0, 0, NULL);
INSERT INTO `productos` VALUES (2240, 2, NULL, 'CORONA DE PALETA PLATEADA 43T GN', 'C080', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 4.06, 5.80, 0.00, '2026-02-09 02:29:50', '2026-02-09 02:29:50', 0, 0, NULL);
INSERT INTO `productos` VALUES (2238, 2, NULL, 'CORONA DE PALETA PLATEADA 40T GN', 'C078', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 3.01, 4.30, 0.00, '2026-02-09 02:29:50', '2026-02-09 02:29:50', 0, 0, NULL);
INSERT INTO `productos` VALUES (2237, 2, NULL, 'CORONA DE PALETA PLATEADA 38T GN', 'C077', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:50', '2026-02-09 02:29:50', 0, 0, NULL);
INSERT INTO `productos` VALUES (2236, 2, NULL, 'CORONA DE PALETA PLATEADA 38T MD-AGUILA', 'C076', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:29:50', '2026-02-09 02:29:50', 0, 0, NULL);
INSERT INTO `productos` VALUES (2235, 2, NULL, 'CORONA DE PALETA PLATEADA 37T MD-AGUILA', 'C075', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 13.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:29:50', '2026-02-09 02:29:50', 0, 0, NULL);
INSERT INTO `productos` VALUES (2232, 2, NULL, 'CORONA DE PALETA 1', 'C072', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:50', '2026-02-09 02:29:50', 0, 0, NULL);
INSERT INTO `productos` VALUES (2231, 2, NULL, 'CORONA DE PALETA DORADA 37T EK HORSE', 'C071', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 3.99, 5.70, 0.00, '2026-02-09 02:29:50', '2026-02-09 02:29:50', 0, 0, NULL);
INSERT INTO `productos` VALUES (2227, 2, NULL, 'CORONA DE PALETA PLATEADA 35 T gn', 'C067', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:49', '2026-02-09 02:29:49', 0, 0, NULL);
INSERT INTO `productos` VALUES (2228, 2, NULL, 'CORONA DE PALETA PLATEADA 36 T gn', 'C068', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 14.00, NULL, 1, 'USD', 3.43, 4.90, 0.00, '2026-02-09 02:29:49', '2026-02-09 02:29:49', 0, 0, NULL);
INSERT INTO `productos` VALUES (2229, 2, NULL, 'CORONA DE PALETA PLATEADA 36 T gn', 'C069', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 13.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:29:50', '2026-02-09 02:29:50', 0, 0, NULL);
INSERT INTO `productos` VALUES (2786, 2, NULL, 'TAPA DISCO VARIADO', 'T026', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:30:36', '2026-02-09 02:30:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2220, 2, NULL, 'CORNETA SBR', 'C060', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:49', '2026-02-09 02:29:49', 0, 0, NULL);
INSERT INTO `productos` VALUES (2221, 2, NULL, 'COPA DE ACEITE HORSE', 'C061', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 2.31, 3.30, 0.00, '2026-02-09 02:29:49', '2026-02-09 02:29:49', 0, 0, NULL);
INSERT INTO `productos` VALUES (2222, 2, NULL, 'COPA DE ACEITE HORSE', 'C062', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 2.17, 3.10, 0.00, '2026-02-09 02:29:49', '2026-02-09 02:29:49', 0, 0, NULL);
INSERT INTO `productos` VALUES (2223, 2, NULL, 'COPA DE ACEITE CG150', 'C063', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 2.17, 3.10, 0.00, '2026-02-09 02:29:49', '2026-02-09 02:29:49', 0, 0, NULL);
INSERT INTO `productos` VALUES (2224, 2, NULL, 'CORNETA  SBR', 'C064', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 1.54, 2.20, 0.00, '2026-02-09 02:29:49', '2026-02-09 02:29:49', 0, 0, NULL);
INSERT INTO `productos` VALUES (2225, 2, NULL, 'CORNETA DE HORSE', 'C065', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:49', '2026-02-09 02:29:49', 0, 0, NULL);
INSERT INTO `productos` VALUES (2226, 2, NULL, 'CORONA DE PALETA PLATEADA 35 T gn', 'C066', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 3.43, 4.90, 0.00, '2026-02-09 02:29:49', '2026-02-09 02:29:49', 0, 0, NULL);
INSERT INTO `productos` VALUES (2217, 2, NULL, 'CONCHA DE ESCAPE CG150 8MM', 'C057', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 2.03, 2.90, 0.00, '2026-02-09 02:29:49', '2026-02-09 02:29:49', 0, 0, NULL);
INSERT INTO `productos` VALUES (2216, 2, NULL, 'COLA PEQUEÑA H-150 AZUL', 'C056', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:48', '2026-02-09 02:29:48', 0, 0, NULL);
INSERT INTO `productos` VALUES (2214, 2, NULL, 'COLA DE PLASTICO DE SBR (TRASERA)', 'C054', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 18.00, NULL, 1, 'USD', 0.77, 1.10, 0.00, '2026-02-09 02:29:48', '2026-02-09 02:29:48', 0, 0, NULL);
INSERT INTO `productos` VALUES (2212, 2, NULL, 'COLA DE PLASTICO DE HORSE TRASERO', 'C052', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 1.12, 1.60, 0.00, '2026-02-09 02:29:48', '2026-02-09 02:29:48', 0, 0, NULL);
INSERT INTO `productos` VALUES (2213, 2, NULL, 'COLA DE PLASTICO DE SBR (DELANTERO)', 'C053', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:29:48', '2026-02-09 02:29:48', 0, 0, NULL);
INSERT INTO `productos` VALUES (2208, 2, NULL, 'CILINDRO CG150', 'C048', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:48', '2026-02-09 02:29:48', 0, 0, NULL);
INSERT INTO `productos` VALUES (2209, 2, NULL, 'CILINDRO OWEN', 'C049', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:48', '2026-02-09 02:29:48', 0, 0, NULL);
INSERT INTO `productos` VALUES (2210, 2, NULL, 'CILINDRO PLATEADO CG150', 'C050', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 23.45, 33.50, 0.00, '2026-02-09 02:29:48', '2026-02-09 02:29:48', 0, 0, NULL);
INSERT INTO `productos` VALUES (2211, 2, NULL, 'COLA DE HORSE 1', 'C051', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:48', '2026-02-09 02:29:48', 0, 0, NULL);
INSERT INTO `productos` VALUES (2207, 2, NULL, 'CIGuEÑAL 150 HORSE', 'C047', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 34.65, 49.50, 0.00, '2026-02-09 02:29:48', '2026-02-09 02:29:48', 0, 0, NULL);
INSERT INTO `productos` VALUES (2205, 2, NULL, 'CHAPALETA PROTAPAER VARIADO', 'C045', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.82, 2.60, 0.00, '2026-02-09 02:29:48', '2026-02-09 02:29:48', 0, 0, NULL);
INSERT INTO `productos` VALUES (2203, 2, NULL, 'CDI H150', 'C043', NULL, 'BENF', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 4.13, 5.90, 0.00, '2026-02-09 02:29:47', '2026-02-09 02:29:47', 0, 0, NULL);
INSERT INTO `productos` VALUES (2204, 2, NULL, 'CADENA DE ACEITE TX200', 'C044', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 1.89, 2.70, 0.00, '2026-02-09 02:29:47', '2026-02-09 02:29:47', 0, 0, NULL);
INSERT INTO `productos` VALUES (2199, 2, NULL, 'CDI CG150', 'C039', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 1.82, 2.60, 0.00, '2026-02-09 02:29:47', '2026-02-09 02:29:47', 0, 0, NULL);
INSERT INTO `productos` VALUES (2200, 2, NULL, 'CDI CG150', 'C040', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 1.96, 2.80, 0.00, '2026-02-09 02:29:47', '2026-02-11 01:29:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2198, 2, NULL, 'CALCOMANIA DE RIN', 'C038', NULL, 'MOTO soNIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:29:47', '2026-02-09 02:29:47', 0, 0, NULL);
INSERT INTO `productos` VALUES (2197, 2, NULL, 'CAUCHO 90/90/18 663', 'C037', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 23.73, 33.90, 0.00, '2026-02-09 02:29:47', '2026-02-09 02:29:47', 0, 0, NULL);
INSERT INTO `productos` VALUES (2194, 2, NULL, 'CAUCHO 300/18 808', 'C034', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:47', '2026-02-09 02:29:47', 0, 0, NULL);
INSERT INTO `productos` VALUES (2195, 2, NULL, 'CAUCHO 300/18 801', 'C035', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 23.80, 34.00, 0.00, '2026-02-09 02:29:47', '2026-02-09 02:29:47', 0, 0, NULL);
INSERT INTO `productos` VALUES (2196, 2, NULL, 'CAUCHO 90/90/18 665', 'C036', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 24.43, 34.90, 0.00, '2026-02-09 02:29:47', '2026-02-09 02:29:47', 0, 0, NULL);
INSERT INTO `productos` VALUES (2192, 2, NULL, 'CAUCHO 275/18 MZ517', 'C032', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 16.45, 23.50, 0.00, '2026-02-09 02:29:47', '2026-02-11 16:26:41', 0, 0, NULL);
INSERT INTO `productos` VALUES (2187, 2, NULL, 'CAUCHO 90/90/18 509', 'C027', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 22.33, 31.90, 0.00, '2026-02-09 02:29:46', '2026-02-09 02:29:46', 0, 0, NULL);
INSERT INTO `productos` VALUES (2188, 2, NULL, 'CAUCHO 90/90/18 342', 'C028', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 23.73, 33.90, 0.00, '2026-02-09 02:29:46', '2026-02-09 02:29:46', 0, 0, NULL);
INSERT INTO `productos` VALUES (2189, 2, NULL, 'CAUCHO 410/18', 'C029', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 34.72, 49.60, 0.00, '2026-02-09 02:29:46', '2026-02-09 02:29:46', 0, 0, NULL);
INSERT INTO `productos` VALUES (2190, 2, NULL, 'CAUCHO 300/18 CZ818', 'C030', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:46', '2026-02-09 02:29:46', 0, 0, NULL);
INSERT INTO `productos` VALUES (2191, 2, NULL, 'CAUCHO 275/18 MZ518', 'C031', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 16.45, 23.50, 0.00, '2026-02-09 02:29:46', '2026-02-09 02:29:46', 0, 0, NULL);
INSERT INTO `productos` VALUES (2184, 2, NULL, 'CARGADOR DE BATERIA', 'C024', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 3.92, 5.60, 0.00, '2026-02-09 02:29:46', '2026-02-09 02:29:46', 0, 0, NULL);
INSERT INTO `productos` VALUES (2185, 2, NULL, 'CASCOS SANDOVAL', 'C025', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:46', '2026-02-09 02:29:46', 0, 0, NULL);
INSERT INTO `productos` VALUES (2186, 2, NULL, 'CASCOS SEMI INTEGRALES SPORT', 'C026', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 12.46, 17.80, 0.00, '2026-02-09 02:29:46', '2026-02-11 01:29:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2182, 2, NULL, 'CAREVACA H-150', 'C022', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 4.83, 6.90, 0.00, '2026-02-09 02:29:46', '2026-02-09 02:29:46', 0, 0, NULL);
INSERT INTO `productos` VALUES (2183, 2, NULL, 'CARGADOR USB', 'C023', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 3.15, 4.50, 0.00, '2026-02-09 02:29:46', '2026-02-09 02:29:46', 0, 0, NULL);
INSERT INTO `productos` VALUES (2179, 2, NULL, 'CARCASA TACOMETRO H-150', 'C019', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 3.08, 4.40, 0.00, '2026-02-09 02:29:45', '2026-02-09 02:29:45', 0, 0, NULL);
INSERT INTO `productos` VALUES (2180, 2, NULL, 'CARCASA TACOMETRO SOCIALISTA', 'C020', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 5.25, 7.50, 0.00, '2026-02-09 02:29:46', '2026-02-09 02:29:46', 0, 0, NULL);
INSERT INTO `productos` VALUES (2181, 2, NULL, 'CARCASA TACOMETRO SOCIALISTA', 'C021', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 5.25, 7.50, 0.00, '2026-02-09 02:29:46', '2026-02-09 02:29:46', 0, 0, NULL);
INSERT INTO `productos` VALUES (2174, 2, NULL, 'CARBURADOR PZ27', 'C014', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:45', '2026-02-09 02:29:45', 0, 0, NULL);
INSERT INTO `productos` VALUES (2175, 2, NULL, 'CARBURADOR PZ26', 'C015', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:45', '2026-02-09 02:29:45', 0, 0, NULL);
INSERT INTO `productos` VALUES (2176, 2, NULL, 'CARCASA DE TACOMETRO SBR', 'C016', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 5.53, 7.90, 0.00, '2026-02-09 02:29:45', '2026-02-09 02:29:45', 0, 0, NULL);
INSERT INTO `productos` VALUES (2177, 2, NULL, 'CARCASA FARO MD', 'C017', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 1.75, 2.50, 0.00, '2026-02-09 02:29:45', '2026-02-09 02:29:45', 0, 0, NULL);
INSERT INTO `productos` VALUES (2178, 2, NULL, 'CARCASA TACOMETRO A-150 3PZ', 'C018', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:45', '2026-02-09 02:29:45', 0, 0, NULL);
INSERT INTO `productos` VALUES (2167, 2, NULL, 'CAMPANA 70 T', 'C007', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 7.63, 10.90, 0.00, '2026-02-09 02:29:44', '2026-02-09 02:29:44', 0, 0, NULL);
INSERT INTO `productos` VALUES (2168, 2, NULL, 'CAMPANA 73 T', 'C008', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 7.63, 10.90, 0.00, '2026-02-09 02:29:45', '2026-02-09 02:29:45', 0, 0, NULL);
INSERT INTO `productos` VALUES (2166, 2, NULL, 'CAMPANA 200 70T gruesa', 'C006', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 9.24, 13.20, 0.00, '2026-02-09 02:29:44', '2026-02-09 02:29:44', 0, 0, NULL);
INSERT INTO `productos` VALUES (2164, 2, NULL, 'CAMARA', 'C004', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:44', '2026-02-09 02:29:44', 0, 0, NULL);
INSERT INTO `productos` VALUES (2165, 2, NULL, 'CAMARA COMPLETA', 'C005', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:44', '2026-02-09 02:29:44', 0, 0, NULL);
INSERT INTO `productos` VALUES (2159, 2, NULL, 'BARRA DE POSA PIE CG150', 'B066', NULL, 'MOTO SONYC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 5.53, 7.90, 0.00, '2026-02-09 02:29:44', '2026-02-09 02:29:44', 0, 0, NULL);
INSERT INTO `productos` VALUES (2160, 2, NULL, 'BARRA DE POSA PIE SBR', 'B067', NULL, 'MOTO SONYC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 5.53, 7.90, 0.00, '2026-02-09 02:29:44', '2026-02-09 02:29:44', 0, 0, NULL);
INSERT INTO `productos` VALUES (2161, 2, NULL, 'CADENA DORADA REFORZADA', 'C001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 6.86, 9.80, 0.00, '2026-02-09 02:29:44', '2026-02-11 01:29:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2158, 2, NULL, 'BANDA DE FRENO H-150', 'B065', NULL, 'MOTO SONYC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 2.31, 3.30, 0.00, '2026-02-09 02:29:44', '2026-02-09 02:29:44', 0, 0, NULL);
INSERT INTO `productos` VALUES (2152, 2, NULL, 'BOBINA CG150', 'B059', NULL, 'BENF', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 2.31, 3.30, 0.00, '2026-02-09 02:29:43', '2026-02-09 02:29:43', 0, 0, NULL);
INSERT INTO `productos` VALUES (2140, 2, NULL, 'BUJE HORQUILLA DE CG150', 'B047', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 21.00, NULL, 1, 'USD', 1.12, 1.60, 0.00, '2026-02-09 02:29:42', '2026-02-09 02:29:42', 0, 0, NULL);
INSERT INTO `productos` VALUES (2135, 2, NULL, 'BOMBILLO MUELITA', 'B042', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 12.00, NULL, 1, 'USD', 1.75, 2.50, 0.00, '2026-02-09 02:29:42', '2026-02-09 02:29:42', 0, 0, NULL);
INSERT INTO `productos` VALUES (2134, 2, NULL, 'BOMBILLO 2 CONTACTOS', 'B041', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 0.91, 1.30, 0.00, '2026-02-09 02:29:42', '2026-02-09 02:29:42', 0, 0, NULL);
INSERT INTO `productos` VALUES (2128, 2, NULL, 'BOMBA FRENO DE ESCUTER ENVASE', 'B035', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 1.05, 1.50, 0.00, '2026-02-09 02:29:41', '2026-02-09 02:29:41', 0, 0, NULL);
INSERT INTO `productos` VALUES (2129, 2, NULL, 'BUJE DE AMORTIGUADOR', 'B036', NULL, 'BENF', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 0.84, 1.20, 0.00, '2026-02-09 02:29:41', '2026-02-09 02:29:41', 0, 0, NULL);
INSERT INTO `productos` VALUES (2127, 2, NULL, 'BOMBINA C/PIPA', 'B034', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 2.10, 3.00, 0.00, '2026-02-09 02:29:41', '2026-02-09 02:29:41', 0, 0, NULL);
INSERT INTO `productos` VALUES (2126, 2, NULL, 'BOMBA AIRE DE MOTO DE PEDAL', 'B033', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:41', '2026-02-09 02:29:41', 0, 0, NULL);
INSERT INTO `productos` VALUES (2124, 2, NULL, 'BOMBA AIRE NEGRA SENCILLA', 'B031', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:41', '2026-02-09 02:29:41', 0, 0, NULL);
INSERT INTO `productos` VALUES (2125, 2, NULL, 'BOMBA AIRE DE PEDAL DE BICI', 'B032', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 2.45, 3.50, 0.00, '2026-02-09 02:29:41', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2122, 2, NULL, 'BOMBA DE ACEITE HORSE 150', 'B029', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 3.08, 4.40, 0.00, '2026-02-09 02:29:41', '2026-02-09 02:29:41', 0, 0, NULL);
INSERT INTO `productos` VALUES (2121, 2, NULL, 'BOMBA DE ACEITE GN125', 'B028', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 3.64, 5.20, 0.00, '2026-02-09 02:29:41', '2026-02-09 02:29:41', 0, 0, NULL);
INSERT INTO `productos` VALUES (2114, 2, NULL, 'BATERIA 12N6,5', 'B021', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 18.13, 25.90, 0.00, '2026-02-09 02:29:40', '2026-02-09 02:29:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2115, 2, NULL, 'BATERIA 12N6,5', 'B022', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 15.33, 21.90, 0.00, '2026-02-09 02:29:40', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2116, 2, NULL, 'BOMBILLO SBR', 'B023', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 3.36, 4.80, 0.00, '2026-02-09 02:29:40', '2026-02-12 14:40:16', 0, 0, NULL);
INSERT INTO `productos` VALUES (2783, 2, NULL, 'TAPA DE TACOMETRO SOCIAL/SBR PROTECTOR', 'T023', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:30:35', '2026-02-09 02:30:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2108, 2, NULL, 'BASE DE FARO A150', 'B015', NULL, 'BENF', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 5.46, 7.80, 0.00, '2026-02-09 02:29:40', '2026-02-09 02:29:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2109, 2, NULL, 'BASE PURIFICACION CG150 NEGRO', 'B016', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:40', '2026-02-09 02:29:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2110, 2, NULL, 'BASE TUBO DE ESCAPE', 'B017', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 1.47, 2.10, 0.00, '2026-02-09 02:29:40', '2026-02-09 02:29:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2111, 2, NULL, 'BASE DE CRUCE', 'B018', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 1.12, 1.60, 0.00, '2026-02-09 02:29:40', '2026-02-09 02:29:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2781, 2, NULL, 'TAPA CADENA RAGCIN ROJO', 'T021', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 3.43, 4.90, 0.00, '2026-02-09 02:30:35', '2026-02-09 02:30:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2105, 2, NULL, 'BASE GUARDAFANGO CG150', 'B012', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 2.45, 3.50, 0.00, '2026-02-09 02:29:39', '2026-02-09 02:29:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2103, 2, NULL, 'BASE CARBURADOR ALUMINIO CG150 (MANIFOR)', 'B009', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 1.33, 1.90, 0.00, '2026-02-09 02:29:39', '2026-02-09 02:29:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2104, 2, NULL, 'BASE GUARDAFANGO SBR', 'B011', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 2.45, 3.50, 0.00, '2026-02-09 02:29:39', '2026-02-09 02:29:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2102, 2, NULL, 'BARRA DE POZA PIE COMPLETA CG150', 'B008', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 6.86, 9.80, 0.00, '2026-02-09 02:29:39', '2026-02-09 02:29:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2099, 2, NULL, 'BANDA FRENO H-150 RALLADA', 'B005', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 3.08, 4.40, 0.00, '2026-02-09 02:29:39', '2026-02-09 02:29:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2100, 2, NULL, 'BARRA DE POZA PIE EK', 'B006', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 13.86, 19.80, 0.00, '2026-02-09 02:29:39', '2026-02-09 02:29:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2101, 2, NULL, 'BARRA DE POZA PIE COMPLETA H-150', 'B007', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 6.72, 9.60, 0.00, '2026-02-09 02:29:39', '2026-02-09 02:29:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2097, 2, NULL, 'BANDA DE FRENO GN125', 'B003', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 16.00, NULL, 1, 'USD', 2.31, 3.30, 0.00, '2026-02-09 02:29:39', '2026-02-09 02:29:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2096, 2, NULL, 'BALANCINES H-150 CORTO', 'B002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 1.19, 1.70, 0.00, '2026-02-09 02:29:39', '2026-02-11 01:29:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2094, 2, NULL, 'ANILLO STD SBR', 'A074', NULL, 'MOTO SONYC', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 1.19, 1.70, 0.00, '2026-02-09 02:29:38', '2026-02-09 02:29:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2095, 2, NULL, 'BALANCINE CG150', 'B001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 1.33, 1.90, 0.00, '2026-02-09 02:29:38', '2026-02-09 02:29:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2093, 2, NULL, 'ANILLO STD EXPRESS', 'A073', NULL, 'MOTO SONYC', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 1.19, 1.70, 0.00, '2026-02-09 02:29:38', '2026-02-09 02:29:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2092, 2, NULL, 'ANTI ESPICHE BSN 350 ML', 'A072', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 1.54, 2.20, 0.00, '2026-02-09 02:29:38', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2091, 2, NULL, 'aceite 2 t pote TRASPARENTE', 'A071', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 4.06, 5.80, 0.00, '2026-02-09 02:29:38', '2026-02-09 02:29:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2088, 2, NULL, 'ACEITE HIDRAULICO ATF', 'A068', NULL, 'MOGULF', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 5.25, 7.50, 0.00, '2026-02-09 02:29:38', '2026-02-09 02:29:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2087, 2, NULL, 'ACEITE SAE60', 'A067', NULL, 'ROYAL', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 6.02, 8.60, 0.00, '2026-02-09 02:29:38', '2026-02-09 02:29:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2086, 2, NULL, 'ACEITE 20W50 CARRO', 'A066', NULL, 'SPEED7', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 5.11, 7.30, 0.00, '2026-02-09 02:29:38', '2026-02-09 02:29:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2083, 2, NULL, 'AUTOMATICO CG150', 'A063', NULL, 'BENF', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 2.45, 3.50, 0.00, '2026-02-09 02:29:37', '2026-02-09 02:29:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2084, 2, NULL, 'ACEITE BENZOL 4 T', 'A064', NULL, 'BENZOL', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 9.03, 12.90, 0.00, '2026-02-09 02:29:38', '2026-02-09 02:29:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2775, 2, NULL, 'TAPA CADENA PASTICO NEGRO EK', 'T015', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 1.33, 1.90, 0.00, '2026-02-09 02:30:35', '2026-02-09 02:30:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2771, 2, NULL, 'TAPA CADENA ESV PLASTICA AZUL', 'T011', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:34', '2026-02-09 02:30:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2768, 2, NULL, 'TAPA DE MOTOR DECORATIVO SBR VARIADA', 'T008', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 4.83, 6.90, 0.00, '2026-02-09 02:30:34', '2026-02-09 02:30:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2763, 2, NULL, 'TACOMETRO HORSE', 'T003', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 12.95, 18.50, 0.00, '2026-02-09 02:30:34', '2026-02-09 02:30:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2753, 2, NULL, 'SWITHERA HORSE', 'S027', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 3.85, 5.50, 0.00, '2026-02-09 02:30:33', '2026-02-09 02:30:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2752, 2, NULL, 'SWICHERA ECA EXPRESS', 'S026', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:33', '2026-02-09 02:30:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2748, 2, NULL, 'STOP DECORATIVO HORSE', 'S022', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 12.46, 17.80, 0.00, '2026-02-09 02:30:33', '2026-02-09 02:30:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2747, 2, NULL, 'STOP  CG150', 'S021', NULL, 'BENF', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 4.13, 5.90, 0.00, '2026-02-09 02:30:32', '2026-02-09 02:30:32', 0, 0, NULL);
INSERT INTO `productos` VALUES (2742, 2, NULL, 'SPRAY ECONOMICO VERDE JADE', 'S016', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:30:32', '2026-02-09 02:30:32', 0, 0, NULL);
INSERT INTO `productos` VALUES (2728, 2, NULL, 'SELECTOR CAMBIO H-150', 'S002', NULL, 'MOTO SONYC', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 1.54, 2.20, 0.00, '2026-02-09 02:30:31', '2026-02-09 02:30:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2727, 2, NULL, 'SACA BUJIA', 'S001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 1.19, 1.70, 0.00, '2026-02-09 02:30:31', '2026-02-09 02:30:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2726, 2, NULL, 'ROLINERA 6302', 'R045', NULL, 'BENF', NULL, 'unidad', 1.00, 14.00, NULL, 1, 'USD', 0.91, 1.30, 0.00, '2026-02-09 02:30:31', '2026-02-11 20:29:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2720, 2, NULL, 'ROLINERA DE CUELLO MUNICION', 'R039', NULL, 'BENF', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 1.61, 2.30, 0.00, '2026-02-09 02:30:30', '2026-02-09 02:30:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2719, 2, NULL, 'ROLINERA DE CUELLO CONICA', 'R038', NULL, 'BENF', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 1.61, 2.30, 0.00, '2026-02-09 02:30:30', '2026-02-09 02:30:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2718, 2, NULL, 'ROSORTE1', 'R037', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:30', '2026-02-09 02:30:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2717, 2, NULL, 'ROSORTE DE FRENO', 'R036', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:30', '2026-02-09 02:30:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2715, 2, NULL, 'ROLINERA DE CREMALLERA 200', 'R034', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:30:30', '2026-02-09 02:30:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2714, 2, NULL, 'ROLINERA 6302', 'R033', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 34.00, NULL, 1, 'USD', 0.91, 1.30, 0.00, '2026-02-09 02:30:30', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2708, 2, NULL, 'ROLINERA 6205', 'R027', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:30:29', '2026-02-09 02:30:29', 0, 0, NULL);
INSERT INTO `productos` VALUES (2706, 2, NULL, 'ROLINERA DE CUELLO CONICA', 'R025', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 1.54, 2.20, 0.00, '2026-02-09 02:30:29', '2026-02-09 02:30:29', 0, 0, NULL);
INSERT INTO `productos` VALUES (2705, 2, NULL, 'ROLINERA 6202', 'R024', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 31.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:30:29', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2703, 2, NULL, 'ROLINERA DE CUELLO MUNICION', 'R022', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.54, 2.20, 0.00, '2026-02-09 02:30:29', '2026-02-09 02:30:29', 0, 0, NULL);
INSERT INTO `productos` VALUES (2689, 2, NULL, 'REGULADOR HOWING', 'R009', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 13.00, NULL, 1, 'USD', 3.43, 4.90, 0.00, '2026-02-09 02:30:28', '2026-02-09 02:30:28', 0, 0, NULL);
INSERT INTO `productos` VALUES (2688, 2, NULL, 'REGULADOR H-150', 'R008', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 3.01, 4.30, 0.00, '2026-02-09 02:30:28', '2026-02-09 02:30:28', 0, 0, NULL);
INSERT INTO `productos` VALUES (2687, 2, NULL, 'REGULADOR HORSE', 'R007', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 3.15, 4.50, 0.00, '2026-02-09 02:30:27', '2026-02-09 02:30:27', 0, 0, NULL);
INSERT INTO `productos` VALUES (2686, 2, NULL, 'REGULADOR CG-150', 'R006', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 3.15, 4.50, 0.00, '2026-02-09 02:30:27', '2026-02-09 02:30:27', 0, 0, NULL);
INSERT INTO `productos` VALUES (2685, 2, NULL, 'RETROVISOR EK XPRES', 'R005', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 2.94, 4.20, 0.00, '2026-02-09 02:30:27', '2026-02-09 02:30:27', 0, 0, NULL);
INSERT INTO `productos` VALUES (2809, 2, NULL, 'TUBITO MANUBRIO AJUSTABLE VERDE', 'T049', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 2.31, 3.30, 0.00, '2026-02-09 02:30:38', '2026-02-09 02:30:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2675, 2, NULL, 'PIñON 16T HORSE', 'P106', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 1.33, 1.90, 0.00, '2026-02-09 02:30:26', '2026-02-09 02:30:26', 0, 0, NULL);
INSERT INTO `productos` VALUES (2671, 2, NULL, 'PATA DE FRENO', 'P102', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 2.80, 4.00, 0.00, '2026-02-09 02:30:26', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2666, 2, NULL, 'PUÑOS DECORATIVOS', 'P097', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 11.00, NULL, 1, 'USD', 1.96, 2.80, 0.00, '2026-02-09 02:30:26', '2026-02-09 02:30:26', 0, 0, NULL);
INSERT INTO `productos` VALUES (2658, 2, NULL, 'PROTAPPER FORRO NORMAL PUFF', 'P089', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 2.03, 2.90, 0.00, '2026-02-09 02:30:25', '2026-02-09 02:30:25', 0, 0, NULL);
INSERT INTO `productos` VALUES (2650, 2, NULL, 'PORTA BANDA DELANTERA EKEXPRESS', 'P081', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 10.43, 14.90, 0.00, '2026-02-09 02:30:24', '2026-02-09 02:30:24', 0, 0, NULL);
INSERT INTO `productos` VALUES (2642, 2, NULL, 'POSA PIE DELANTERO OWEN', 'P073', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 5.46, 7.80, 0.00, '2026-02-09 02:30:24', '2026-02-09 02:30:24', 0, 0, NULL);
INSERT INTO `productos` VALUES (2641, 2, NULL, 'POSA PIE DELANTERO AMARILLO CG150', 'P072', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 2.03, 2.90, 0.00, '2026-02-09 02:30:24', '2026-02-09 02:30:24', 0, 0, NULL);
INSERT INTO `productos` VALUES (2808, 2, NULL, 'TUBITO MANUBRIO AZUL', 'T048', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 2.31, 3.30, 0.00, '2026-02-09 02:30:37', '2026-02-09 02:30:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2807, 2, NULL, 'TRIPA RIN 24', 'T047', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:37', '2026-02-09 02:30:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2630, 2, NULL, 'PORTA CORONA AGUILA', 'P061', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 5.25, 7.50, 0.00, '2026-02-09 02:30:23', '2026-02-09 02:30:23', 0, 0, NULL);
INSERT INTO `productos` VALUES (2622, 2, NULL, 'PISTON CG150 1', 'P053', NULL, 'JUYUA', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 4.76, 6.80, 0.00, '2026-02-09 02:30:22', '2026-02-09 02:30:22', 0, 0, NULL);
INSERT INTO `productos` VALUES (2621, 2, NULL, 'PISTON CG200 0,75', 'P052', NULL, 'ZHONG HING', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 4.76, 6.80, 0.00, '2026-02-09 02:30:22', '2026-02-09 02:30:22', 0, 0, NULL);
INSERT INTO `productos` VALUES (2610, 2, NULL, 'PIPA SILICON', 'P041', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.56, 0.80, 0.00, '2026-02-09 02:30:21', '2026-02-11 01:29:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2806, 2, NULL, 'TRIPA 410/18', 'T046', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 4.83, 6.90, 0.00, '2026-02-09 02:30:37', '2026-02-09 02:30:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2609, 2, NULL, 'PIÑON GN125 PLATEADO 15 T', 'P040', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 15.00, NULL, 1, 'USD', 1.12, 1.60, 0.00, '2026-02-09 02:30:21', '2026-02-09 02:30:21', 0, 0, NULL);
INSERT INTO `productos` VALUES (2608, 2, NULL, 'PIÑON DORADO 17T', 'P039', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 1.33, 1.90, 0.00, '2026-02-09 02:30:21', '2026-02-11 01:29:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2607, 2, NULL, 'PIÑON H-150 DORADO 16T', 'P038', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:21', '2026-02-09 02:30:21', 0, 0, NULL);
INSERT INTO `productos` VALUES (2606, 2, NULL, 'PIÑON CG150 DORADO 16T', 'P037', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 19.00, NULL, 1, 'USD', 1.19, 1.70, 0.00, '2026-02-09 02:30:21', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2602, 2, NULL, 'PICA CADENA', 'P033', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 3.43, 4.90, 0.00, '2026-02-09 02:30:20', '2026-02-09 02:30:20', 0, 0, NULL);
INSERT INTO `productos` VALUES (2601, 2, NULL, 'PERNO DE CADENA', 'P032', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 28.00, NULL, 1, 'USD', 0.35, 0.50, 0.00, '2026-02-09 02:30:20', '2026-02-09 02:30:20', 0, 0, NULL);
INSERT INTO `productos` VALUES (2600, 2, NULL, 'PATA DE CAMBIO A-150', 'P031', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 2.10, 3.00, 0.00, '2026-02-09 02:30:20', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2599, 2, NULL, 'PORTA CELULARES', 'P030', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 3.85, 5.50, 0.00, '2026-02-09 02:30:20', '2026-02-09 02:30:20', 0, 0, NULL);
INSERT INTO `productos` VALUES (2598, 2, NULL, 'PATA FRENO NEGRO A-150', 'P029', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 3.08, 4.40, 0.00, '2026-02-09 02:30:20', '2026-02-09 02:30:20', 0, 0, NULL);
INSERT INTO `productos` VALUES (2597, 2, NULL, 'PATA FRENO CG-150', 'P028', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 3.08, 4.40, 0.00, '2026-02-09 02:30:20', '2026-02-09 02:30:20', 0, 0, NULL);
INSERT INTO `productos` VALUES (2596, 2, NULL, 'PATA DE FRENO EK-expres rin rayo', 'P027', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 3.08, 4.40, 0.00, '2026-02-09 02:30:20', '2026-02-09 02:30:20', 0, 0, NULL);
INSERT INTO `productos` VALUES (2595, 2, NULL, 'PATA DE FRENO h-150', 'P026', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:20', '2026-02-09 02:30:20', 0, 0, NULL);
INSERT INTO `productos` VALUES (2594, 2, NULL, 'PATA DE FRENO GN125', 'P025', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 2.87, 4.10, 0.00, '2026-02-09 02:30:20', '2026-02-09 02:30:20', 0, 0, NULL);
INSERT INTO `productos` VALUES (2593, 2, NULL, 'PATA DE CAMBIO RAGCIN', 'P024', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 3.15, 4.50, 0.00, '2026-02-09 02:30:20', '2026-02-09 02:30:20', 0, 0, NULL);
INSERT INTO `productos` VALUES (2586, 2, NULL, 'PASTILLAS SBR', 'P017', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:19', '2026-02-09 02:30:19', 0, 0, NULL);
INSERT INTO `productos` VALUES (2585, 2, NULL, 'PASTILLAS DE HORSE', 'P016', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 18.00, NULL, 1, 'USD', 1.12, 1.60, 0.00, '2026-02-09 02:30:19', '2026-02-09 02:30:19', 0, 0, NULL);
INSERT INTO `productos` VALUES (2584, 2, NULL, 'PASTILLAS DE FRENO SBR', 'P015', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 34.00, NULL, 1, 'USD', 1.05, 1.50, 0.00, '2026-02-09 02:30:19', '2026-02-09 02:30:19', 0, 0, NULL);
INSERT INTO `productos` VALUES (2577, 2, NULL, 'PASTILLA DE FRENO CG150', 'P008', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:18', '2026-02-09 02:30:18', 0, 0, NULL);
INSERT INTO `productos` VALUES (2571, 2, NULL, 'PALETA FRENO H-150', 'P002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 6.23, 8.90, 0.00, '2026-02-09 02:30:18', '2026-02-09 02:30:18', 0, 0, NULL);
INSERT INTO `productos` VALUES (2805, 2, NULL, 'TRIPA 410/17', 'T045', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:37', '2026-02-09 02:30:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2804, 2, NULL, 'TRIPA 300/18', 'T044', NULL, 'ROMO', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 3.15, 4.50, 0.00, '2026-02-09 02:30:37', '2026-02-11 11:31:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2564, 2, NULL, 'MINI KIT EMPACADURA', 'M038', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 19.00, NULL, 1, 'USD', 0.63, 0.90, 0.00, '2026-02-09 02:30:17', '2026-02-09 02:30:17', 0, 0, NULL);
INSERT INTO `productos` VALUES (2563, 2, NULL, 'MICA STOP CG TRASPARENTE XPRES', 'M037', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 1.61, 2.30, 0.00, '2026-02-09 02:30:17', '2026-02-09 02:30:17', 0, 0, NULL);
INSERT INTO `productos` VALUES (2803, 2, NULL, 'TRIPA 300/17', 'T043', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 3.78, 5.40, 0.00, '2026-02-09 02:30:37', '2026-02-09 02:30:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2802, 2, NULL, 'TRIPA 120/70 12', 'T042', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 3.43, 4.90, 0.00, '2026-02-09 02:30:37', '2026-02-09 02:30:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2800, 2, NULL, 'TRIPA 110/90/16', 'T040', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:37', '2026-02-09 02:30:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2559, 2, NULL, 'MEDIO KIT DE EMPACADURA', 'M033', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 0.98, 1.40, 0.00, '2026-02-09 02:30:17', '2026-02-09 02:30:17', 0, 0, NULL);
INSERT INTO `productos` VALUES (2558, 2, NULL, 'MEDIDOR DE ACEITE', 'M032', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 0.56, 0.80, 0.00, '2026-02-09 02:30:17', '2026-02-09 02:30:17', 0, 0, NULL);
INSERT INTO `productos` VALUES (2557, 2, NULL, 'MASCARA', 'M031', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 4.76, 6.80, 0.00, '2026-02-09 02:30:17', '2026-02-09 02:30:17', 0, 0, NULL);
INSERT INTO `productos` VALUES (2556, 2, NULL, 'MARTILLERA 200', 'M030', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 4.83, 6.90, 0.00, '2026-02-09 02:30:17', '2026-02-09 02:30:17', 0, 0, NULL);
INSERT INTO `productos` VALUES (2555, 2, NULL, 'MARTILLERA 150', 'M029', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 3.36, 4.80, 0.00, '2026-02-09 02:30:17', '2026-02-09 02:30:17', 0, 0, NULL);
INSERT INTO `productos` VALUES (2554, 2, NULL, 'MANZANA TRASERA', 'M028', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:16', '2026-02-09 02:30:16', 0, 0, NULL);
INSERT INTO `productos` VALUES (2553, 2, NULL, 'MANZANA delantera', 'M027', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 17.15, 24.50, 0.00, '2026-02-09 02:30:16', '2026-02-09 02:30:16', 0, 0, NULL);
INSERT INTO `productos` VALUES (2552, 2, NULL, 'MANILLA SBR', 'M026', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:16', '2026-02-09 02:30:16', 0, 0, NULL);
INSERT INTO `productos` VALUES (2551, 2, NULL, 'MANILLA COMPLETA MD AGUILA', 'M025', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:16', '2026-02-09 02:30:16', 0, 0, NULL);
INSERT INTO `productos` VALUES (2550, 2, NULL, 'MANILLA CROCHE SOLA CG-150', 'M024', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 32.00, NULL, 1, 'USD', 1.05, 1.50, 0.00, '2026-02-09 02:30:16', '2026-02-09 02:30:16', 0, 0, NULL);
INSERT INTO `productos` VALUES (2546, 2, NULL, 'MANIFORT/BASE CARBURADOR', 'M020', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:16', '2026-02-09 02:30:16', 0, 0, NULL);
INSERT INTO `productos` VALUES (2545, 2, NULL, 'MANGUERA RESPIRADERO MOTOR', 'M019', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 1.05, 1.50, 0.00, '2026-02-09 02:30:16', '2026-02-09 02:30:16', 0, 0, NULL);
INSERT INTO `productos` VALUES (2544, 2, NULL, 'MANGUERA DE GASOLINA', 'M018', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 0.28, 0.40, 0.00, '2026-02-09 02:30:16', '2026-02-09 02:30:16', 0, 0, NULL);
INSERT INTO `productos` VALUES (2543, 2, NULL, 'MANGUERA DE FRENO GN125', 'M017', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 2.94, 4.20, 0.00, '2026-02-09 02:30:16', '2026-02-09 02:30:16', 0, 0, NULL);
INSERT INTO `productos` VALUES (2542, 2, NULL, 'MANILLA DE FRENO', 'M016', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 1.33, 1.90, 0.00, '2026-02-09 02:30:15', '2026-02-09 02:30:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (2537, 2, NULL, 'MANDO SBR', 'M011', NULL, 'BENF', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 7.63, 10.90, 0.00, '2026-02-09 02:30:15', '2026-02-09 02:30:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (2536, 2, NULL, 'MANDO OWEN NORMAL 2014', 'M010', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 8.33, 11.90, 0.00, '2026-02-09 02:30:15', '2026-02-09 02:30:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (2521, 2, NULL, 'LLAVERO ELASTICO', 'L020', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 11.00, NULL, 1, 'USD', 1.05, 1.50, 0.00, '2026-02-09 02:30:14', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2798, 2, NULL, 'TERMINALES DE BATERIA', 'T038', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 27.00, NULL, 1, 'USD', 0.42, 0.60, 0.00, '2026-02-09 02:30:37', '2026-02-09 02:30:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2516, 2, NULL, 'LUCES CRUCE DE HORSE', 'L016', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 1.61, 2.30, 0.00, '2026-02-09 02:30:13', '2026-02-09 02:30:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (2513, 2, NULL, 'LUCES BARRA 6 LED', 'L013', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:13', '2026-02-09 02:30:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (2507, 2, NULL, 'LIMPIA CADENA', 'L007', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 2.66, 3.80, 0.00, '2026-02-09 02:30:13', '2026-02-09 02:30:13', 0, 0, NULL);
INSERT INTO `productos` VALUES (2504, 2, NULL, 'LIGA 250 ML ROMO', 'L004', NULL, 'ROMO', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 2.03, 2.90, 0.00, '2026-02-09 02:30:12', '2026-02-11 01:29:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2797, 2, NULL, 'TERMINALES AZUL', 'T037', NULL, 'ROMO', NULL, 'unidad', 1.00, 41.00, NULL, 1, 'USD', 0.21, 0.30, 0.00, '2026-02-09 02:30:37', '2026-02-09 02:30:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2499, 2, NULL, 'KIT DE GOMA DECORATIVA 7PZA NEGRA S/LLAVERO NEGRO', 'K037', NULL, '', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 2.45, 3.50, 0.00, '2026-02-09 02:30:12', '2026-02-09 02:30:12', 0, 0, NULL);
INSERT INTO `productos` VALUES (2492, 2, NULL, 'KIT VALVULA PATA LARGA C/GOMA CG200', 'K030', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 1.61, 2.30, 0.00, '2026-02-09 02:30:11', '2026-02-09 02:30:11', 0, 0, NULL);
INSERT INTO `productos` VALUES (2479, 2, NULL, 'KIT ESTOPERA MOTOR CG150', 'K017', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 24.00, NULL, 1, 'USD', 1.12, 1.60, 0.00, '2026-02-09 02:30:10', '2026-02-09 02:30:10', 0, 0, NULL);
INSERT INTO `productos` VALUES (2474, 2, NULL, 'KIT DE TORNILLO PORTA CORONA RIN DE RAYO', 'K012', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 16.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:30:10', '2026-02-09 02:30:10', 0, 0, NULL);
INSERT INTO `productos` VALUES (2473, 2, NULL, 'KIT DE TORNILLO PORTA CORONA PALETA', 'K011', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 27.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:30:10', '2026-02-09 02:30:10', 0, 0, NULL);
INSERT INTO `productos` VALUES (2467, 2, NULL, 'KIT DE REPARACION CARBURADOR 150', 'K005', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 1.61, 2.30, 0.00, '2026-02-09 02:30:09', '2026-02-11 19:34:44', 0, 0, NULL);
INSERT INTO `productos` VALUES (2466, 2, NULL, 'KIT DE BIELA H-150', 'K004', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 7.00, 10.00, 0.00, '2026-02-09 02:30:09', '2026-02-09 02:30:09', 0, 0, NULL);
INSERT INTO `productos` VALUES (2465, 2, NULL, 'KIT DE BIELA CG150', 'K003', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 6.86, 9.80, 0.00, '2026-02-09 02:30:09', '2026-02-09 02:30:09', 0, 0, NULL);
INSERT INTO `productos` VALUES (2464, 2, NULL, 'KIT DE BIELA CG150', 'K002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 7.28, 10.40, 0.00, '2026-02-09 02:30:09', '2026-02-09 02:30:09', 0, 0, NULL);
INSERT INTO `productos` VALUES (2463, 2, NULL, 'KIT DE REPARACION DE ARRANQUE', 'K001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:09', '2026-02-09 02:30:09', 0, 0, NULL);
INSERT INTO `productos` VALUES (2462, 2, NULL, 'INSTALACION TX200', 'I008', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 11.76, 16.80, 0.00, '2026-02-09 02:30:09', '2026-02-09 02:30:09', 0, 0, NULL);
INSERT INTO `productos` VALUES (2461, 2, NULL, 'INSTALACION SBR', 'I007', NULL, 'BENF', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 10.92, 15.60, 0.00, '2026-02-09 02:30:09', '2026-02-09 02:30:09', 0, 0, NULL);
INSERT INTO `productos` VALUES (2460, 2, NULL, 'INSTALACION MD-AGUILA', 'I006', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 8.33, 11.90, 0.00, '2026-02-09 02:30:09', '2026-02-09 02:30:09', 0, 0, NULL);
INSERT INTO `productos` VALUES (2453, 2, NULL, 'HORQUILLA DE CG150', 'H004', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 13.86, 19.80, 0.00, '2026-02-09 02:30:08', '2026-02-09 02:30:08', 0, 0, NULL);
INSERT INTO `productos` VALUES (2449, 2, NULL, 'GOMA DE CAñA GN', 'G070', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:30:08', '2026-02-09 02:30:08', 0, 0, NULL);
INSERT INTO `productos` VALUES (2448, 2, NULL, 'GOMA DE PORTA CORONA GN125', 'G069', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.82, 2.60, 0.00, '2026-02-09 02:30:08', '2026-02-09 02:30:08', 0, 0, NULL);
INSERT INTO `productos` VALUES (2447, 2, NULL, 'GOMA DE CAñA CG150', 'G068', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 1.61, 2.30, 0.00, '2026-02-09 02:30:08', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2446, 2, NULL, 'GUAYA DE CROCHET EOW 150', 'G067', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 1.33, 1.90, 0.00, '2026-02-09 02:30:08', '2026-02-11 14:07:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2440, 2, NULL, 'GUAYA KILOMETRAJE A-150', 'G061', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 11.00, NULL, 1, 'USD', 1.33, 1.90, 0.00, '2026-02-09 02:30:07', '2026-02-09 02:30:07', 0, 0, NULL);
INSERT INTO `productos` VALUES (2439, 2, NULL, 'GUAYA DE KILOMETRAJE DE SPREES RAYO', 'G060', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 1.33, 1.90, 0.00, '2026-02-09 02:30:07', '2026-02-09 02:30:07', 0, 0, NULL);
INSERT INTO `productos` VALUES (2796, 2, NULL, 'TERMINALES AMARILLOS', 'T036', NULL, 'ROMO', NULL, 'unidad', 1.00, 34.00, NULL, 1, 'USD', 0.28, 0.40, 0.00, '2026-02-09 02:30:36', '2026-02-09 02:30:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2433, 2, NULL, 'GUAYA DE CROCHE EXPRESS', 'G054', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 11.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:30:06', '2026-02-09 02:30:06', 0, 0, NULL);
INSERT INTO `productos` VALUES (2432, 2, NULL, 'GUAYA DE CROCHE EXPRESS', 'G053', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 22.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:30:06', '2026-02-09 02:30:06', 0, 0, NULL);
INSERT INTO `productos` VALUES (2431, 2, NULL, 'GUAYA DE CROCHE DE OWEN/GS', 'G052', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 11.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:30:06', '2026-02-12 16:02:22', 0, 0, NULL);
INSERT INTO `productos` VALUES (2430, 2, NULL, 'GUAYA DE CROCHE DE EK JORSE', 'G051', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:06', '2026-02-09 02:30:06', 0, 0, NULL);
INSERT INTO `productos` VALUES (2429, 2, NULL, 'GUAYA DE CROCHE DE CG150', 'G050', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 14.00, NULL, 1, 'USD', 1.33, 1.90, 0.00, '2026-02-09 02:30:06', '2026-02-09 02:30:06', 0, 0, NULL);
INSERT INTO `productos` VALUES (2425, 2, NULL, 'GUAYA DE ACELERACION EXPRESS1', 'G046', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:06', '2026-02-09 02:30:06', 0, 0, NULL);
INSERT INTO `productos` VALUES (2795, 2, NULL, 'MICAS  1', 'T035', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:36', '2026-02-09 02:30:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2416, 2, NULL, 'GUAYA DE ACELERACION DE EXPRESS', 'G037', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 14.00, NULL, 1, 'USD', 1.19, 1.70, 0.00, '2026-02-09 02:30:05', '2026-02-09 02:30:05', 0, 0, NULL);
INSERT INTO `productos` VALUES (2415, 2, NULL, 'GUAYA DE  1', 'G036', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:05', '2026-02-09 02:30:05', 0, 0, NULL);
INSERT INTO `productos` VALUES (2406, 2, NULL, 'GUARDABARRO DELANTERO ROJO', 'G026', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:04', '2026-02-09 02:30:04', 0, 0, NULL);
INSERT INTO `productos` VALUES (2402, 2, NULL, 'GUARDA FANGO  DELANTERO AZUL SOCIAL', 'G022', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 6.44, 9.20, 0.00, '2026-02-09 02:30:04', '2026-02-09 02:30:04', 0, 0, NULL);
INSERT INTO `productos` VALUES (2401, 2, NULL, 'GRASA DE ESMERILAR', 'G021', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 2.38, 3.40, 0.00, '2026-02-09 02:30:04', '2026-02-09 02:30:04', 0, 0, NULL);
INSERT INTO `productos` VALUES (2400, 2, NULL, 'GOMA TAPA LATERALES DE HORSE', 'G020', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 0.49, 0.70, 0.00, '2026-02-09 02:30:04', '2026-02-09 02:30:04', 0, 0, NULL);
INSERT INTO `productos` VALUES (2399, 2, NULL, 'GOMA TAPA LATERALE DE CG150', 'G019', NULL, 'MOTO SONYC', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 0.49, 0.70, 0.00, '2026-02-09 02:30:04', '2026-02-09 02:30:04', 0, 0, NULL);
INSERT INTO `productos` VALUES (2398, 2, NULL, 'GOMA SOCIALISTA FUCSIA', 'G018', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:04', '2026-02-09 02:30:04', 0, 0, NULL);
INSERT INTO `productos` VALUES (2396, 2, NULL, 'GOMA POSAPIE H-150 colores FOX', 'G016', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:03', '2026-02-09 02:30:03', 0, 0, NULL);
INSERT INTO `productos` VALUES (2395, 2, NULL, 'GOMA POSA PIE', 'G015', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:03', '2026-02-09 02:30:03', 0, 0, NULL);
INSERT INTO `productos` VALUES (2393, 2, NULL, 'GOMA PATA CAMBIO NARANJANDA MONSTER', 'G013', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 0.56, 0.80, 0.00, '2026-02-09 02:30:03', '2026-02-09 02:30:03', 0, 0, NULL);
INSERT INTO `productos` VALUES (2392, 2, NULL, 'GOMA MANILLA COLORES AC PARES', 'G012', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:30:03', '2026-02-09 02:30:03', 0, 0, NULL);
INSERT INTO `productos` VALUES (2386, 2, NULL, 'GOMA DE FRENO OWEN', 'G006', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 13.00, NULL, 1, 'USD', 3.92, 5.60, 0.00, '2026-02-09 02:30:03', '2026-02-09 02:30:03', 0, 0, NULL);
INSERT INTO `productos` VALUES (2385, 2, NULL, 'GOMA DE FARO FUCSIA CG150', 'G005', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 3.22, 4.60, 0.00, '2026-02-09 02:30:02', '2026-02-09 02:30:02', 0, 0, NULL);
INSERT INTO `productos` VALUES (2384, 2, NULL, 'GOMA DE FARO NEGRA CG150', 'G004', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 3.22, 4.60, 0.00, '2026-02-09 02:30:02', '2026-02-09 02:30:02', 0, 0, NULL);
INSERT INTO `productos` VALUES (2383, 2, NULL, 'GOMA DE FARO MORADO CG 150', 'G003', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 3.22, 4.60, 0.00, '2026-02-09 02:30:02', '2026-02-09 02:30:02', 0, 0, NULL);
INSERT INTO `productos` VALUES (2794, 2, NULL, 'TAPA VALVULA DE CARAVELA', 'T034', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 1.05, 1.50, 0.00, '2026-02-09 02:30:36', '2026-02-09 02:30:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2359, 2, NULL, 'FARO DE LUPA CON BASE PEQUEÑO', 'F012', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 11.13, 15.90, 0.00, '2026-02-09 02:30:00', '2026-02-09 02:30:00', 0, 0, NULL);
INSERT INTO `productos` VALUES (2358, 2, NULL, 'FARO CUADRADO MC 607', 'F011', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 17.85, 25.50, 0.00, '2026-02-09 02:30:00', '2026-02-09 02:30:00', 0, 0, NULL);
INSERT INTO `productos` VALUES (2357, 2, NULL, 'FARO CUADRADO MC 606', 'F010', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:00', '2026-02-09 02:30:00', 0, 0, NULL);
INSERT INTO `productos` VALUES (2356, 2, NULL, 'FAROS MD AGUILA', 'F009', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 10.43, 14.90, 0.00, '2026-02-09 02:30:00', '2026-02-09 02:30:00', 0, 0, NULL);
INSERT INTO `productos` VALUES (2355, 2, NULL, 'FAROS SBR', 'F008', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 16.80, 24.00, 0.00, '2026-02-09 02:30:00', '2026-02-09 02:30:00', 0, 0, NULL);
INSERT INTO `productos` VALUES (2349, 2, NULL, 'FARO RECTANGULAR LED CON SIRENA', 'F002', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:59', '2026-02-09 02:29:59', 0, 0, NULL);
INSERT INTO `productos` VALUES (2348, 2, NULL, 'FARO BUO TRASPARENTE', 'F001', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 4.90, 7.00, 0.00, '2026-02-09 02:29:59', '2026-02-09 02:29:59', 0, 0, NULL);
INSERT INTO `productos` VALUES (2343, 2, NULL, 'ESTOPERA BASTON  JAGUAR 9,5', 'E035', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:59', '2026-02-09 02:29:59', 0, 0, NULL);
INSERT INTO `productos` VALUES (2342, 2, NULL, 'ESTOPERA MOTOR GN 125 INCOMPLETA', 'E034', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.91, 1.30, 0.00, '2026-02-09 02:29:59', '2026-02-09 02:29:59', 0, 0, NULL);
INSERT INTO `productos` VALUES (2792, 2, NULL, 'TAPA VALVULA  DE COLORES', 'T032', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:30:36', '2026-02-09 02:30:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2330, 2, NULL, 'EMRROLLADO 4 CABLE H150', 'E022', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 8.33, 11.90, 0.00, '2026-02-09 02:29:58', '2026-02-09 02:29:58', 0, 0, NULL);
INSERT INTO `productos` VALUES (2329, 2, NULL, 'EMPACADURA MAGNETO CG150 SOLA', 'E021', NULL, 'BENF', NULL, 'unidad', 1.00, 13.00, NULL, 1, 'USD', 0.42, 0.60, 0.00, '2026-02-09 02:29:58', '2026-02-09 02:29:58', 0, 0, NULL);
INSERT INTO `productos` VALUES (2322, 2, NULL, 'ELEVADOR DE OCTANAJE', 'E014', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 19.00, NULL, 1, 'USD', 2.73, 3.90, 0.00, '2026-02-09 02:29:57', '2026-02-09 02:29:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (2318, 2, NULL, 'EJE TRASERO SBR', 'E010', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 14.00, NULL, 1, 'USD', 2.17, 3.10, 0.00, '2026-02-09 02:29:57', '2026-02-09 02:29:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (2317, 2, NULL, 'EJE TRASERO GN125', 'E009', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 1.96, 2.80, 0.00, '2026-02-09 02:29:57', '2026-02-09 02:29:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (2316, 2, NULL, 'EJE PARA BURRO CENTRAL CG150', 'E008', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 1.33, 1.90, 0.00, '2026-02-09 02:29:57', '2026-02-09 02:29:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (2315, 2, NULL, 'EJE TRASERO CG150', 'E007', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 22.00, NULL, 1, 'USD', 1.33, 1.90, 0.00, '2026-02-09 02:29:57', '2026-02-09 02:29:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (2314, 2, NULL, 'EJE DELANTERO SOCIAL', 'E006', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:29:57', '2026-02-09 02:29:57', 0, 0, NULL);
INSERT INTO `productos` VALUES (2313, 2, NULL, 'EJE DE HORQUILLA CG150', 'E005', NULL, 'BENF', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 1.75, 2.50, 0.00, '2026-02-09 02:29:56', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2309, 2, NULL, 'EJE DE CAMBIO CG150', 'E001', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 2.31, 3.30, 0.00, '2026-02-09 02:29:56', '2026-02-09 02:29:56', 0, 0, NULL);
INSERT INTO `productos` VALUES (2305, 2, NULL, 'DISCO CROCHE  CG150 6PZ', 'D008', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 2.31, 3.30, 0.00, '2026-02-09 02:29:56', '2026-02-09 02:29:56', 0, 0, NULL);
INSERT INTO `productos` VALUES (2791, 2, NULL, 'TAPA TORNILLO PLASTICA MODELO VARIADO', 'T031', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.68, 2.40, 0.00, '2026-02-09 02:30:36', '2026-02-09 02:30:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2295, 2, NULL, 'CASCO SEMI INTEGRAL 56 PROJECT NEGRO', 'C135', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 18.13, 25.90, 0.00, '2026-02-09 02:29:55', '2026-02-09 02:29:55', 0, 0, NULL);
INSERT INTO `productos` VALUES (2790, 2, NULL, 'TAPA SWICHERA H-150 ROJO', 'T030', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:36', '2026-02-09 02:30:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2789, 2, NULL, 'TAPA SBR ROJA lateral', 'T029', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:36', '2026-02-09 02:30:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2788, 2, NULL, 'TAPA HORSE LATERALES ROJO', 'T028', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 9.66, 13.80, 0.00, '2026-02-09 02:30:36', '2026-02-09 02:30:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2787, 2, NULL, 'TAPA HORSE LATERALES NEGRO', 'T027', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:36', '2026-02-09 02:30:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2286, 2, NULL, 'cuÑa de valvula', 'C126', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 0.35, 0.50, 0.00, '2026-02-09 02:29:54', '2026-02-09 02:29:54', 0, 0, NULL);
INSERT INTO `productos` VALUES (2270, 2, NULL, 'CUCHARA DE TX 200', 'C110', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 3.64, 5.20, 0.00, '2026-02-09 02:29:53', '2026-02-09 02:29:53', 0, 0, NULL);
INSERT INTO `productos` VALUES (2269, 2, NULL, 'CUCHARA CG150', 'C109', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 2.66, 3.80, 0.00, '2026-02-09 02:29:53', '2026-02-09 02:29:53', 0, 0, NULL);
INSERT INTO `productos` VALUES (2268, 2, NULL, 'CUCHARA CG150', 'C108', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 3.08, 4.40, 0.00, '2026-02-09 02:29:53', '2026-02-09 02:29:53', 0, 0, NULL);
INSERT INTO `productos` VALUES (2267, 2, NULL, 'CROCHERA COMPLETA 5 T', 'C107', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 17.85, 25.50, 0.00, '2026-02-09 02:29:53', '2026-02-09 02:29:53', 0, 0, NULL);
INSERT INTO `productos` VALUES (2264, 2, NULL, 'CREMALLERA CG150 COMPLETA', 'C104', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:52', '2026-02-09 02:29:52', 0, 0, NULL);
INSERT INTO `productos` VALUES (2263, 2, NULL, 'CREMALLERA 200 COMPLETA', 'C103', NULL, 'ZETA', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:52', '2026-02-09 02:29:52', 0, 0, NULL);
INSERT INTO `productos` VALUES (2262, 2, NULL, 'CREMALLERA 150 COMPLETA', 'C102', NULL, 'ZETA', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:52', '2026-02-09 02:29:52', 0, 0, NULL);
INSERT INTO `productos` VALUES (2256, 2, NULL, 'CORONA PALETRA DORADA GN 37T', 'C096', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 3.64, 5.20, 0.00, '2026-02-09 02:29:52', '2026-02-11 01:29:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2255, 2, NULL, 'CORONA PALETRA DORADA GN 36T', 'C095', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 3.64, 5.20, 0.00, '2026-02-09 02:29:52', '2026-02-09 02:29:52', 0, 0, NULL);
INSERT INTO `productos` VALUES (2250, 2, NULL, 'CORONA PALETRA DORADA GN-38T', 'C090', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 3.64, 5.20, 0.00, '2026-02-09 02:29:51', '2026-02-09 02:29:51', 0, 0, NULL);
INSERT INTO `productos` VALUES (2249, 2, NULL, 'CORONA RAYO DORADA 37T', 'C089', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 13.00, NULL, 1, 'USD', 3.64, 5.20, 0.00, '2026-02-09 02:29:51', '2026-02-09 02:29:51', 0, 0, NULL);
INSERT INTO `productos` VALUES (2248, 2, NULL, 'CORONA RAYO DORADA 36T', 'C088', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 3.64, 5.20, 0.00, '2026-02-09 02:29:51', '2026-02-09 02:29:51', 0, 0, NULL);
INSERT INTO `productos` VALUES (2247, 2, NULL, 'CORONA RAYO DORADA 35T', 'C087', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 3.64, 5.20, 0.00, '2026-02-09 02:29:51', '2026-02-09 02:29:51', 0, 0, NULL);
INSERT INTO `productos` VALUES (2243, 2, NULL, 'CORONA DE RAYO PLATEADA 35T', 'C083', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 3.43, 4.90, 0.00, '2026-02-09 02:29:51', '2026-02-09 02:29:51', 0, 0, NULL);
INSERT INTO `productos` VALUES (2239, 2, NULL, 'CORONA DE PALETA PLATEADA 41T GN', 'C079', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 3.50, 5.00, 0.00, '2026-02-09 02:29:50', '2026-02-09 02:29:50', 0, 0, NULL);
INSERT INTO `productos` VALUES (2234, 2, NULL, 'CORONA DE PALETA PLATEADA 36T MD-AGUILA', 'C074', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 3.43, 4.90, 0.00, '2026-02-09 02:29:50', '2026-02-09 02:29:50', 0, 0, NULL);
INSERT INTO `productos` VALUES (2233, 2, NULL, 'CORONA DE PALETA PLATEADA 35T MD-AGUILA', 'C073', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 3.43, 4.90, 0.00, '2026-02-09 02:29:50', '2026-02-11 01:29:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2230, 2, NULL, 'CORONA DE PALETA PLATEADA 37 T gn', 'C070', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:50', '2026-02-09 02:29:50', 0, 0, NULL);
INSERT INTO `productos` VALUES (2219, 2, NULL, 'CONECTORES DE HORSE', 'C059', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:49', '2026-02-09 02:29:49', 0, 0, NULL);
INSERT INTO `productos` VALUES (2218, 2, NULL, 'CONECTORES CG150', 'C058', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:29:49', '2026-02-09 02:29:49', 0, 0, NULL);
INSERT INTO `productos` VALUES (2215, 2, NULL, 'COLA GUARDABARRO AMARILLO SOCIAL', 'C055', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:48', '2026-02-09 02:29:48', 0, 0, NULL);
INSERT INTO `productos` VALUES (2206, 2, NULL, 'CHARQUERA (GUARDABARRO UNIVERSAL)', 'C046', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:48', '2026-02-09 02:29:48', 0, 0, NULL);
INSERT INTO `productos` VALUES (2202, 2, NULL, 'CDI HORSE 150', 'C042', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 13.00, NULL, 1, 'USD', 3.92, 5.60, 0.00, '2026-02-09 02:29:47', '2026-02-09 02:29:47', 0, 0, NULL);
INSERT INTO `productos` VALUES (2201, 2, NULL, 'CDI HORSE 150', 'C041', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 15.00, NULL, 1, 'USD', 4.83, 6.90, 0.00, '2026-02-09 02:29:47', '2026-02-09 02:29:47', 0, 0, NULL);
INSERT INTO `productos` VALUES (2193, 2, NULL, 'CAUCHO 275/18 MZ240', 'C033', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:47', '2026-02-09 02:29:47', 0, 0, NULL);
INSERT INTO `productos` VALUES (2785, 2, NULL, 'TAPA DE TANQUE DE GASOLINA', 'T025', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 5.25, 7.50, 0.00, '2026-02-09 02:30:36', '2026-02-09 02:30:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2173, 2, NULL, 'CARBURADOR PZ27', 'C013', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:45', '2026-02-09 02:29:45', 0, 0, NULL);
INSERT INTO `productos` VALUES (2172, 2, NULL, 'CARBURADOR TORNAZOL', 'C012', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 16.03, 22.90, 0.00, '2026-02-09 02:29:45', '2026-02-09 02:29:45', 0, 0, NULL);
INSERT INTO `productos` VALUES (2171, 2, NULL, 'CARBONERA CG150', 'C011', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 2.24, 3.20, 0.00, '2026-02-09 02:29:45', '2026-02-09 02:29:45', 0, 0, NULL);
INSERT INTO `productos` VALUES (2170, 2, NULL, 'CARBONERA HORSE H-150', 'C010', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:45', '2026-02-09 02:29:45', 0, 0, NULL);
INSERT INTO `productos` VALUES (2169, 2, NULL, 'CAMPANA 200 73T', 'C009', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 8.19, 11.70, 0.00, '2026-02-09 02:29:45', '2026-02-09 02:29:45', 0, 0, NULL);
INSERT INTO `productos` VALUES (2163, 2, NULL, 'CADENA ORRIN', 'C003', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 13.86, 19.80, 0.00, '2026-02-09 02:29:44', '2026-02-09 02:29:44', 0, 0, NULL);
INSERT INTO `productos` VALUES (2162, 2, NULL, 'CADENA NERGRA REFORZADA', 'C002', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 4.97, 7.10, 0.00, '2026-02-09 02:29:44', '2026-02-11 01:29:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2784, 2, NULL, 'TAPA DE TANQUE DE GASOLINA', 'T024', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 6.23, 8.90, 0.00, '2026-02-09 02:30:35', '2026-02-09 02:30:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2157, 2, NULL, 'BANDA DE FRENO GN125', 'B064', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 12.00, NULL, 1, 'USD', 2.94, 4.20, 0.00, '2026-02-09 02:29:44', '2026-02-09 02:29:44', 0, 0, NULL);
INSERT INTO `productos` VALUES (2156, 2, NULL, 'BOMBILLO 3 PATAS', 'B063', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 3.15, 4.50, 0.00, '2026-02-09 02:29:44', '2026-02-09 02:29:44', 0, 0, NULL);
INSERT INTO `productos` VALUES (2155, 2, NULL, 'BASE DE MOTOR', 'B062', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 8.05, 11.50, 0.00, '2026-02-09 02:29:43', '2026-02-09 02:29:43', 0, 0, NULL);
INSERT INTO `productos` VALUES (2154, 2, NULL, 'BATERIA 12N7', 'B061', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 22.33, 31.90, 0.00, '2026-02-09 02:29:43', '2026-02-09 02:29:43', 0, 0, NULL);
INSERT INTO `productos` VALUES (2153, 2, NULL, 'BATERIA 12N9', 'B060', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:43', '2026-02-09 02:29:43', 0, 0, NULL);
INSERT INTO `productos` VALUES (2151, 2, NULL, 'BASE DE CARBURADOR CG150', 'B058', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 1.19, 1.70, 0.00, '2026-02-09 02:29:43', '2026-02-09 02:29:43', 0, 0, NULL);
INSERT INTO `productos` VALUES (2150, 2, NULL, 'BASE DE TUBO DE ESCAPE', 'B057', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:43', '2026-02-09 02:29:43', 0, 0, NULL);
INSERT INTO `productos` VALUES (2149, 2, NULL, 'BATERIA DE ACIDO 12N7', 'B056', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:43', '2026-02-09 02:29:43', 0, 0, NULL);
INSERT INTO `productos` VALUES (2148, 2, NULL, 'BURRO CG150', 'B055', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 4.48, 6.40, 0.00, '2026-02-09 02:29:43', '2026-02-09 02:29:43', 0, 0, NULL);
INSERT INTO `productos` VALUES (2147, 2, NULL, 'BURRO H-150', 'B054', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 6.09, 8.70, 0.00, '2026-02-09 02:29:43', '2026-02-09 02:29:43', 0, 0, NULL);
INSERT INTO `productos` VALUES (2146, 2, NULL, 'BUJIA NORMAL', 'B053', NULL, 'MC LLANOS', NULL, 'unidad', 1.00, 39.00, NULL, 1, 'USD', 0.84, 1.20, 0.00, '2026-02-09 02:29:43', '2026-02-10 17:50:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2145, 2, NULL, 'BUJIA D8TC PUNTA DIAMANTE', 'B052', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 24.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:29:43', '2026-02-11 20:31:19', 0, 0, NULL);
INSERT INTO `productos` VALUES (2144, 2, NULL, 'BUJIA 3 patas', 'B051', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 43.00, NULL, 1, 'USD', 0.98, 1.40, 0.00, '2026-02-09 02:29:43', '2026-02-09 02:29:43', 0, 0, NULL);
INSERT INTO `productos` VALUES (2143, 2, NULL, 'BUJIA A7TC GY6', 'B050', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:29:42', '2026-02-09 02:29:42', 0, 0, NULL);
INSERT INTO `productos` VALUES (2142, 2, NULL, 'BUJIA NORMAL', 'B049', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:42', '2026-02-09 02:29:42', 0, 0, NULL);
INSERT INTO `productos` VALUES (2141, 2, NULL, 'BUJE HORQUILLA DE HORSE', 'B048', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 24.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:29:42', '2026-02-09 02:29:42', 0, 0, NULL);
INSERT INTO `productos` VALUES (2139, 2, NULL, 'BUJE HORQUILLA OWEN', 'B046', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:42', '2026-02-09 02:29:42', 0, 0, NULL);
INSERT INTO `productos` VALUES (2138, 2, NULL, 'BUJE DE MANZANA PLASTICO', 'B045', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:29:42', '2026-02-09 02:29:42', 0, 0, NULL);
INSERT INTO `productos` VALUES (2137, 2, NULL, 'BUJE DE MANZANA DE HIERRO', 'B044', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:29:42', '2026-02-09 02:29:42', 0, 0, NULL);
INSERT INTO `productos` VALUES (2136, 2, NULL, 'BUJE AMORTIGUADOR', 'B043', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 11.00, NULL, 1, 'USD', 0.77, 1.10, 0.00, '2026-02-09 02:29:42', '2026-02-09 02:29:42', 0, 0, NULL);
INSERT INTO `productos` VALUES (2133, 2, NULL, 'BOMBILLO DE FARO CUADRADO 9 LED', 'B040', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 2.94, 4.20, 0.00, '2026-02-09 02:29:42', '2026-02-09 02:29:42', 0, 0, NULL);
INSERT INTO `productos` VALUES (2132, 2, NULL, 'BOMBILLO CABEZON 12/V', 'B039', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 1.05, 1.50, 0.00, '2026-02-09 02:29:42', '2026-02-09 02:29:42', 0, 0, NULL);
INSERT INTO `productos` VALUES (2131, 2, NULL, 'BOMBILLO 2 CONTACTO', 'B038', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 1.05, 1.50, 0.00, '2026-02-09 02:29:41', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2130, 2, NULL, 'BUJIA DE DESMALEZADORA', 'B037', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 1.05, 1.50, 0.00, '2026-02-09 02:29:41', '2026-02-09 02:29:41', 0, 0, NULL);
INSERT INTO `productos` VALUES (2123, 2, NULL, 'BOMBA DE ACEITE SBR', 'B030', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 4.06, 5.80, 0.00, '2026-02-09 02:29:41', '2026-02-09 02:29:41', 0, 0, NULL);
INSERT INTO `productos` VALUES (2120, 2, NULL, 'BOLSAS DE ASIENTO', 'B027', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 14.00, NULL, 1, 'USD', 0.98, 1.40, 0.00, '2026-02-09 02:29:41', '2026-02-11 01:29:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2119, 2, NULL, 'BOBINA CG150 RAGCIN', 'B026', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 3.78, 5.40, 0.00, '2026-02-09 02:29:40', '2026-02-09 02:29:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2118, 2, NULL, 'BOBINA CG150', 'B025', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 2.24, 3.20, 0.00, '2026-02-09 02:29:40', '2026-02-09 02:29:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2117, 2, NULL, 'BOBINA CG150', 'B024', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 11.00, NULL, 1, 'USD', 2.38, 3.40, 0.00, '2026-02-09 02:29:40', '2026-02-09 02:29:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2782, 2, NULL, 'TAPA CARBURADOR DECORATIVO', 'T022', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 3.15, 4.50, 0.00, '2026-02-09 02:30:35', '2026-02-09 02:30:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2113, 2, NULL, 'BATERIA 12N6,5', 'B020', NULL, 'BENF', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 17.43, 24.90, 0.00, '2026-02-09 02:29:40', '2026-02-09 02:29:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2112, 2, NULL, 'BASE TUBO DE ESCAPE', 'B019', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 1.54, 2.20, 0.00, '2026-02-09 02:29:40', '2026-02-09 02:29:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2107, 2, NULL, 'BASE PATA DE ARRANQUE', 'B014', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 0.98, 1.40, 0.00, '2026-02-09 02:29:39', '2026-02-09 02:29:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2106, 2, NULL, 'BASE GUARDAFANGO H-150 AC', 'B013', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 5.46, 7.80, 0.00, '2026-02-09 02:29:39', '2026-02-09 02:29:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2098, 2, NULL, 'BANDA FRENO DE RAYO', 'B004', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 15.00, NULL, 1, 'USD', 1.75, 2.50, 0.00, '2026-02-09 02:29:39', '2026-02-09 02:29:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2090, 2, NULL, 'AMORTIGUADOR GN', 'A070', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 21.56, 30.80, 0.00, '2026-02-09 02:29:38', '2026-02-09 02:29:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2089, 2, NULL, 'ACEITE HIDRAULICO A GRANEL', 'A069', NULL, '', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:38', '2026-02-09 02:29:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2085, 2, NULL, 'ANILLO H-150 STD', 'A065', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 1.47, 2.10, 0.00, '2026-02-09 02:29:38', '2026-02-09 02:29:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2082, 2, NULL, 'ANTIESPICHE 340ML', 'A062', NULL, 'JERET', NULL, 'unidad', 1.00, 13.00, NULL, 1, 'USD', 1.26, 1.80, 0.00, '2026-02-09 02:29:37', '2026-02-09 02:29:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2081, 2, NULL, 'ACEITE MINERAL 1X50  2T', 'A061', NULL, 'BENF', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 4.69, 6.70, 0.00, '2026-02-09 02:29:37', '2026-02-09 02:29:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2080, 2, NULL, 'ARBOL LEVA CG150', 'A060', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 4.62, 6.60, 0.00, '2026-02-09 02:29:37', '2026-02-09 02:29:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2079, 2, NULL, 'ANILLO CG150 STD', 'A059', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 19.00, NULL, 1, 'USD', 1.19, 1.70, 0.00, '2026-02-09 02:29:37', '2026-02-09 02:29:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2078, 2, NULL, 'ANILLO H-150 STD', 'A058', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 1.33, 1.90, 0.00, '2026-02-09 02:29:37', '2026-02-09 02:29:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2077, 2, NULL, 'AMORTIGUADOR DE HORSE', 'A057', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 19.95, 28.50, 0.00, '2026-02-09 02:29:37', '2026-02-09 02:29:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2076, 2, NULL, 'AMORTIGUADOR DE XPRESS', 'A056', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:37', '2026-02-09 02:29:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2075, 2, NULL, 'ANTI ESPICHE ROMO', 'A055', NULL, 'ROMO', NULL, 'unidad', 1.00, 28.00, NULL, 1, 'USD', 2.66, 3.80, 0.00, '2026-02-09 02:29:37', '2026-02-11 01:29:30', 0, 0, NULL);
INSERT INTO `productos` VALUES (2074, 2, NULL, 'ACEITE LUBREX', 'A054', NULL, 'MOBIL', NULL, 'unidad', 1.00, 12.00, NULL, 1, 'USD', 9.03, 12.90, 0.00, '2026-02-09 02:29:37', '2026-02-09 02:29:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2073, 2, NULL, 'ACEITE ROYAL 4 T 20W50', 'A053', NULL, 'ROYAL', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 5.88, 8.40, 0.00, '2026-02-09 02:29:37', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2072, 2, NULL, 'ACEITE ROYAL 20W50 DE CARRO', 'A052', NULL, 'ROYAL', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 6.23, 8.90, 0.00, '2026-02-09 02:29:37', '2026-02-09 02:29:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2071, 2, NULL, 'ANILLO CG150 STD', 'A051', NULL, 'BENF', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 1.40, 2.00, 0.00, '2026-02-09 02:29:37', '2026-02-09 02:29:37', 0, 0, NULL);
INSERT INTO `productos` VALUES (2070, 2, NULL, 'ANILLO H-150 STD', 'A050', NULL, 'BENF', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 1.40, 2.00, 0.00, '2026-02-09 02:29:36', '2026-02-09 02:29:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2069, 2, NULL, 'ARBOL DE LEVA CG150', 'A049', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 5.81, 8.30, 0.00, '2026-02-09 02:29:36', '2026-02-09 02:29:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2068, 2, NULL, 'ARBOL DE LEVA CG150 REFORZADO', 'A048', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 6.23, 8.90, 0.00, '2026-02-09 02:29:36', '2026-02-09 02:29:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2067, 2, NULL, 'AVISOS DE MOTOTAXIS', 'A047', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:29:36', '2026-02-09 02:29:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2066, 2, NULL, 'AUTOMATICO HORSE', 'A046', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:36', '2026-02-09 02:29:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2065, 2, NULL, 'AUTOMATICO H-150', 'A045', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 4.06, 5.80, 0.00, '2026-02-09 02:29:36', '2026-02-09 02:29:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2064, 2, NULL, 'AUTOMATICO GN 125', 'A044', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 4.13, 5.90, 0.00, '2026-02-09 02:29:36', '2026-02-09 02:29:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2063, 2, NULL, 'AUTOMATICO CG150', 'A043', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 2.66, 3.80, 0.00, '2026-02-09 02:29:36', '2026-02-09 02:29:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2062, 2, NULL, 'ASIENTO GN125', 'A042', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 18.83, 26.90, 0.00, '2026-02-09 02:29:36', '2026-02-09 02:29:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2061, 2, NULL, 'ASIENTO SBR', 'A041', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 19.46, 27.80, 0.00, '2026-02-09 02:29:36', '2026-02-09 02:29:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2060, 2, NULL, 'ARRANQUE SBR', 'A040', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 15.19, 21.70, 0.00, '2026-02-09 02:29:36', '2026-02-09 02:29:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2059, 2, NULL, 'ARRANQUE SBR', 'A039', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 11.13, 15.90, 0.00, '2026-02-09 02:29:36', '2026-02-09 02:29:36', 0, 0, NULL);
INSERT INTO `productos` VALUES (2058, 2, NULL, 'ARRANQUE GN 125', 'A038', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 18.83, 26.90, 0.00, '2026-02-09 02:29:35', '2026-02-09 02:29:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2057, 2, NULL, 'ARRANQUE EXPRESS', 'A037', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 11.13, 15.90, 0.00, '2026-02-09 02:29:35', '2026-02-09 02:29:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2056, 2, NULL, 'ARRANQUE 200', 'A036', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 16.45, 23.50, 0.00, '2026-02-09 02:29:35', '2026-02-09 02:29:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2055, 2, NULL, 'ARBOL DE LEVA OWEN GS125 CONTRA PESO 125', 'A035', NULL, 'SPEED', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 9.31, 13.30, 0.00, '2026-02-09 02:29:35', '2026-02-09 02:29:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2054, 2, NULL, 'ARBOL DE LEVA GN125', 'A034', NULL, 'SAGA', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 9.03, 12.90, 0.00, '2026-02-09 02:29:35', '2026-02-09 02:29:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2053, 2, NULL, 'ARBOL DE LEVA GN125', 'A033', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 9.03, 12.90, 0.00, '2026-02-09 02:29:35', '2026-02-09 02:29:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2052, 2, NULL, 'ARANDELA DE TUBO DE ESCAPE BRONCE', 'A032', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 53.00, NULL, 1, 'USD', 0.28, 0.40, 0.00, '2026-02-09 02:29:35', '2026-02-09 02:29:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2051, 2, NULL, 'ANTIESPICHE 500ML', 'A031', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:35', '2026-02-09 02:29:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2050, 2, NULL, 'ANTIESPICHE 500ML', 'A030', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:35', '2026-02-09 02:29:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2049, 2, NULL, 'ANTIEPICHE DE ESPUMA DE LATA', 'A029', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 3.36, 4.80, 0.00, '2026-02-09 02:29:35', '2026-02-09 02:29:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2048, 2, NULL, 'ANTIEPICHE CON ESPUMA', 'A028', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 3.22, 4.60, 0.00, '2026-02-09 02:29:35', '2026-02-09 02:29:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2047, 2, NULL, 'ANILLO HORSE  STD', 'A027', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 1.40, 2.00, 0.00, '2026-02-09 02:29:35', '2026-02-09 02:29:35', 0, 0, NULL);
INSERT INTO `productos` VALUES (2046, 2, NULL, 'ANILLO GRUESO DE LATA DORADO', 'A026', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 2.38, 3.40, 0.00, '2026-02-09 02:29:34', '2026-02-09 02:29:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2045, 2, NULL, 'ANILLO CG150 STD', 'A025', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 1.40, 2.00, 0.00, '2026-02-09 02:29:34', '2026-02-09 02:29:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2044, 2, NULL, 'ANILLO A-150 0.50', 'A024', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 1.75, 2.50, 0.00, '2026-02-09 02:29:34', '2026-02-09 02:29:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2043, 2, NULL, 'ANILLO A-150 1,00', 'A023', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 1.68, 2.40, 0.00, '2026-02-09 02:29:34', '2026-02-09 02:29:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2042, 2, NULL, 'ANILLO A 150 0,75', 'A022', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 1.75, 2.50, 0.00, '2026-02-09 02:29:34', '2026-02-09 02:29:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2041, 2, NULL, 'AMORTIGUADOR MORADO SBR', 'A021', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 22.12, 31.60, 0.00, '2026-02-09 02:29:34', '2026-02-09 02:29:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2040, 2, NULL, 'AMORTIGUADOR HORSE', 'A020', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 20.86, 29.80, 0.00, '2026-02-09 02:29:34', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2039, 2, NULL, 'AMORTIGUADOR EK SPRESS', 'A019', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 20.86, 29.80, 0.00, '2026-02-09 02:29:34', '2026-02-09 02:29:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2038, 2, NULL, 'AMORTIGUADOR SOCIAL NEGRO', 'A018', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 20.86, 29.80, 0.00, '2026-02-09 02:29:34', '2026-02-09 02:29:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2037, 2, NULL, 'AMORTIGUADOR AZUL SBR', 'A017', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 21.63, 30.90, 0.00, '2026-02-09 02:29:34', '2026-02-09 02:29:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2036, 2, NULL, 'AMORTIGUADOR ROJO SBR', 'A016', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 21.63, 30.90, 0.00, '2026-02-09 02:29:34', '2026-02-09 02:29:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2035, 2, NULL, 'AMORTIGUADOR FUCSIA SBR', 'A015', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 21.63, 30.90, 0.00, '2026-02-09 02:29:34', '2026-02-09 02:29:34', 0, 0, NULL);
INSERT INTO `productos` VALUES (2034, 2, NULL, 'ACEITE SPORT 2 T (AGUA)', 'A014', NULL, 'SUPREMO', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 5.53, 7.90, 0.00, '2026-02-09 02:29:33', '2026-02-09 02:29:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2033, 2, NULL, 'ACEITE SHELL ACEITE', 'A013', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:33', '2026-02-09 02:29:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2032, 2, NULL, 'ACEITE MOTUL 5100', 'A012', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:33', '2026-02-09 02:29:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2031, 2, NULL, 'ACEITE SKY', 'A011', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 13.86, 19.80, 0.00, '2026-02-09 02:29:33', '2026-02-09 02:29:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2030, 2, NULL, 'ACEITE SKY 2T', 'A010', NULL, 'SKY', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:33', '2026-02-09 02:29:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2029, 2, NULL, 'ACEITE BENZOL  PARA CARRO', 'A009', NULL, 'BENZOL', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 9.03, 12.90, 0.00, '2026-02-09 02:29:33', '2026-02-09 02:29:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2028, 2, NULL, 'ACEITE MULTILUB', 'A008', NULL, 'ROMO', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:29:33', '2026-02-09 02:29:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2027, 2, NULL, 'ACEITE MOTUL 3000', 'A007', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 14.63, 20.90, 0.00, '2026-02-09 02:29:33', '2026-02-09 02:29:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2026, 2, NULL, 'ACEITE ROMO', 'A006', NULL, 'ROMO', NULL, 'unidad', 1.00, 12.00, NULL, 1, 'USD', 6.23, 8.90, 0.00, '2026-02-09 02:29:33', '2026-02-09 02:29:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2025, 2, NULL, 'ACEITE MOBIL', 'A005', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 10.43, 14.90, 0.00, '2026-02-09 02:29:33', '2026-02-09 02:29:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2024, 2, NULL, 'ACEITE 2T 1X50 POTE GRIS', 'A004', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 4.83, 6.90, 0.00, '2026-02-09 02:29:33', '2026-02-09 02:29:33', 0, 0, NULL);
INSERT INTO `productos` VALUES (2023, 2, NULL, 'ACEITE 50 GRANEL', 'A003', NULL, 'ROYAL', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 4.06, 5.80, 0.00, '2026-02-09 02:29:33', '2026-02-12 14:48:15', 0, 0, NULL);
INSERT INTO `productos` VALUES (2022, 2, NULL, 'ACEITE 20W50 GRANEL', 'A002', NULL, 'MOTO FAMI', NULL, 'unidad', 1.00, -1.00, NULL, 1, 'USD', 4.06, 5.80, 0.00, '2026-02-09 02:29:32', '2026-02-10 18:08:44', 0, 0, NULL);
INSERT INTO `productos` VALUES (2021, 2, NULL, 'ACEITE 20W50 4T', 'A001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 21.00, NULL, 1, 'USD', 3.92, 5.60, 0.00, '2026-02-09 02:29:32', '2026-02-09 02:29:32', 0, 0, NULL);
INSERT INTO `productos` VALUES (2813, 2, NULL, 'TUBO DE ESCAPE BENF', 'T053', NULL, 'BENF', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:38', '2026-02-09 02:30:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2814, 2, NULL, 'TUBO DE ESCAPE BENF  TORNAZOL', 'T054', NULL, 'BENF', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 29.33, 41.90, 0.00, '2026-02-09 02:30:38', '2026-02-09 02:30:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2815, 2, NULL, 'TUBO DE ESCAPE EXPRESS', 'T055', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:38', '2026-02-09 02:30:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2816, 2, NULL, 'TAPA PINON', 'T056', NULL, 'BENF', NULL, 'unidad', 1.00, 3.00, NULL, 1, 'USD', 3.85, 5.50, 0.00, '2026-02-09 02:30:38', '2026-02-09 02:30:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2817, 2, NULL, 'TAPON DE MOTOR DESAGUE DE ACEITE', 'T057', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 9.00, NULL, 1, 'USD', 0.70, 1.00, 0.00, '2026-02-09 02:30:38', '2026-02-09 02:30:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2818, 2, NULL, 'TIRRAJ GRANDE DE TRIPOIDE', 'T058', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 48.00, NULL, 1, 'USD', 0.14, 0.20, 0.00, '2026-02-09 02:30:38', '2026-02-09 02:30:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2819, 2, NULL, 'TIRRAJ  MEDIANO', 'T059', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.07, 0.10, 0.00, '2026-02-09 02:30:38', '2026-02-09 02:30:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2820, 2, NULL, 'TORNILLO DECORATIVO', 'T060', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.28, 0.40, 0.00, '2026-02-09 02:30:38', '2026-02-09 02:30:38', 0, 0, NULL);
INSERT INTO `productos` VALUES (2821, 2, NULL, 'TUBO DE ESCAPE MEGAZUKI', 'T061', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:39', '2026-02-09 02:30:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2822, 2, NULL, 'TUERCA 14 MM', 'T062', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 8.00, NULL, 1, 'USD', 0.28, 0.40, 0.00, '2026-02-09 02:30:39', '2026-02-09 02:30:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2823, 2, NULL, 'TUERCA 12 MM', 'T063', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 7.00, NULL, 1, 'USD', 0.28, 0.40, 0.00, '2026-02-09 02:30:39', '2026-02-09 02:30:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2824, 2, NULL, 'TUERCA AMORTIGUADOR', 'T064', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 6.00, NULL, 1, 'USD', 0.63, 0.90, 0.00, '2026-02-09 02:30:39', '2026-02-09 02:30:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2825, 2, NULL, 'TAPA SWICHERA DECORATIVA', 'T065', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 11.00, NULL, 1, 'USD', 1.40, 2.00, 0.00, '2026-02-09 02:30:39', '2026-02-09 02:30:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2826, 2, NULL, 'TIRRAJ PEQUEÑO', 'T066', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 72.00, NULL, 1, 'USD', 0.07, 0.10, 0.00, '2026-02-09 02:30:39', '2026-02-09 02:30:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2827, 2, NULL, 'TORNILLO DECORATIVO', 'T067', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 29.00, NULL, 1, 'USD', 0.28, 0.40, 0.00, '2026-02-09 02:30:39', '2026-02-09 02:30:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2828, 2, NULL, 'TEIPE GRANDE', 'T068', NULL, 'COBRA', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:39', '2026-02-09 02:30:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2829, 2, NULL, 'TORNILLO RAGCIN AZUL UNIDAD', 'T069', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 0.28, 0.40, 0.00, '2026-02-09 02:30:39', '2026-02-09 02:30:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2830, 2, NULL, 'TORNILLO RAGCIN MORADO UNIDAD', 'T070', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 0.28, 0.40, 0.00, '2026-02-09 02:30:39', '2026-02-09 02:30:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2831, 2, NULL, 'TORNILLO RAGCIN ROJO UNIDAD', 'T071', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 0.28, 0.40, 0.00, '2026-02-09 02:30:39', '2026-02-09 02:30:39', 0, 0, NULL);
INSERT INTO `productos` VALUES (2832, 2, NULL, 'VARILLA FRENO CG150', 'V001', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 0.77, 1.10, 0.00, '2026-02-09 02:30:39', '2026-02-12 00:23:31', 0, 0, NULL);
INSERT INTO `productos` VALUES (2833, 2, NULL, 'VARILLA FRENO 1', 'V002', NULL, '1', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:40', '2026-02-09 02:30:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2834, 2, NULL, 'VARILLA FRENO DE OWEN', 'V003', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 15.00, NULL, 1, 'USD', 1.12, 1.60, 0.00, '2026-02-09 02:30:40', '2026-02-09 02:30:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2835, 2, NULL, 'VOLANTE H-150', 'V004', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 4.00, NULL, 1, 'USD', 6.86, 9.80, 0.00, '2026-02-09 02:30:40', '2026-02-09 02:30:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2836, 2, NULL, 'VOLANTE MD AGUILA', 'V005', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 5.00, NULL, 1, 'USD', 5.25, 7.50, 0.00, '2026-02-09 02:30:40', '2026-02-09 02:30:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2837, 2, NULL, 'VOLANTE SBR', 'V006', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 5.53, 7.90, 0.00, '2026-02-09 02:30:40', '2026-02-11 20:30:10', 0, 0, NULL);
INSERT INTO `productos` VALUES (2838, 2, NULL, 'VALVULA DE AIRE PARA CAUCHO', 'V007', NULL, 'ROMO', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 0.00, 0.00, 0.00, '2026-02-09 02:30:40', '2026-02-09 02:30:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2839, 2, NULL, 'VALVULA CG150 P/L', 'V008', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 10.00, NULL, 1, 'USD', 1.47, 2.10, 0.00, '2026-02-09 02:30:40', '2026-02-09 02:30:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2840, 2, NULL, 'VOLANTE DE OWEN', 'V009', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 6.86, 9.80, 0.00, '2026-02-09 02:30:40', '2026-02-09 02:30:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2841, 2, NULL, 'VOLANTE SBR', 'V010', NULL, 'MOTO SONIC', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 5.53, 7.90, 0.00, '2026-02-09 02:30:40', '2026-02-09 02:30:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2842, 2, NULL, 'VOLANTE EXPREES', 'V011', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 2.00, NULL, 1, 'USD', 5.32, 7.60, 0.00, '2026-02-09 02:30:40', '2026-02-09 02:30:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2843, 2, NULL, 'VOLANTE H-150 TORNASOL', 'V012', NULL, 'MEGAZUKI', NULL, 'unidad', 1.00, 1.00, NULL, 1, 'USD', 7.63, 10.90, 0.00, '2026-02-09 02:30:40', '2026-02-09 02:30:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2844, 2, NULL, 'RODAJE PLATEADO', 'V013', NULL, 'lubricante', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 11.48, 16.40, 0.00, '2026-02-09 02:30:40', '2026-02-09 02:30:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2845, 2, NULL, 'RODAJE DORADO', 'V014', NULL, 'lubricante', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 12.25, 17.50, 0.00, '2026-02-09 02:30:40', '2026-02-09 02:30:40', 0, 0, NULL);
INSERT INTO `productos` VALUES (2846, 2, NULL, 'RODAJE DE ORRIN', 'V015', NULL, 'lubricante', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 19.39, 27.70, 0.00, '2026-02-09 02:30:41', '2026-02-09 02:30:41', 0, 0, NULL);
INSERT INTO `productos` VALUES (2847, 2, NULL, 'PILA DE GASOLINA', 'V016', NULL, 'lubricante', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 14.00, 20.00, 0.00, '2026-02-09 02:30:41', '2026-02-09 02:30:41', 0, 0, NULL);
INSERT INTO `productos` VALUES (2848, 2, NULL, 'RODAJE ECONOMICO P/ESPECIAL', 'V017', NULL, '', NULL, 'unidad', 1.00, 0.00, NULL, 1, 'USD', 9.10, 13.00, 0.00, '2026-02-09 02:30:41', '2026-02-09 02:30:41', 0, 0, NULL);

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
) ENGINE = MyISAM AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

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
INSERT INTO `usuarios` VALUES (24, '30417766', 'RUDY ROXYBE CARREÑO MENDEZ', '04124638495', 'uploads/30417766.jpeg');
INSERT INTO `usuarios` VALUES (25, '29791392', 'YOSELIN DE VALLE VASQUEZ VILLALBA', '04128596992', 'uploads/29791392.jpeg');

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
  `metodo_pago_id` int NULL DEFAULT NULL,
  `cliente_id` int NULL DEFAULT NULL,
  `referencia` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `estado` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'completada',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_venta_negocio`(`negocio_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 84 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ventas
-- ----------------------------
INSERT INTO `ventas` VALUES (1, 1, '2026-02-04 12:26:25', 1879.16, 5.01, 375.08, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (2, 1, '2026-02-04 18:34:10', 1511.58, 4.03, 375.08, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (3, 1, '2026-02-04 19:32:13', 4759.80, 12.69, 375.08, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (4, 1, '2026-02-04 19:34:28', 611.38, 1.63, 375.08, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (5, 1, '2026-02-04 19:35:04', 731.41, 1.95, 375.08, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (6, 1, '2026-02-05 16:21:59', 607.07, 1.60, 378.46, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (7, 1, '2026-02-05 18:17:34', 737.99, 1.95, 378.46, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (8, 1, '2026-02-05 18:59:11', 870.45, 2.30, 378.46, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (9, 1, '2026-02-06 10:46:55', 495.44, 1.30, 381.11, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (15, 1, '2026-02-06 18:16:04', 396.35, 1.04, 381.11, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (14, 1, '2026-02-06 18:14:35', 1303.39, 3.42, 381.11, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (13, 1, '2026-02-06 18:09:12', 830.81, 2.18, 381.11, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (16, 1, '2026-02-06 18:20:17', 666.94, 1.75, 381.11, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (17, 1, '2026-02-06 20:29:32', 476.38, 1.25, 381.11, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (18, 1, '2026-02-06 20:31:42', 865.11, 2.27, 381.11, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (19, 1, '2026-02-07 07:26:16', 2800.86, 7.32, 382.63, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (20, 1, '2026-02-07 09:22:15', 468.72, 1.23, 382.63, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (21, 1, '2026-02-07 09:27:43', 1511.40, 3.95, 382.63, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (22, 1, '2026-02-07 12:47:28', 945.10, 2.47, 382.63, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (23, 1, '2026-02-07 15:06:41', 4419.40, 11.55, 382.63, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (24, 1, '2026-02-07 17:28:56', 229.58, 0.60, 382.63, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (26, 1, '2026-02-08 08:31:35', 1683.58, 4.40, 382.63, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (27, 1, '2026-02-08 11:15:49', 968.06, 2.53, 382.63, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (28, 1, '2026-02-08 12:58:24', 1308.60, 3.42, 382.63, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (29, 1, '2026-02-08 17:38:05', 1013.97, 2.65, 382.63, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (30, 1, '2026-02-08 17:40:32', 753.78, 1.97, 382.63, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (31, 1, '2026-02-09 17:50:57', 248.71, 0.65, 382.63, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (32, 1, '2026-02-09 18:50:12', 497.42, 1.30, 382.63, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (33, 1, '2026-02-09 19:11:26', 360.63, 0.94, 382.63, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (34, 2, '2026-02-10 07:35:08', 1733.72, 4.50, 385.27, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (35, 2, '2026-02-10 09:03:55', 577.91, 1.50, 385.27, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (36, 2, '2026-02-10 11:03:04', 500.85, 1.30, 385.27, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (37, 2, '2026-02-10 11:10:15', 3698.61, 9.60, 385.27, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (38, 1, '2026-02-10 11:45:34', 886.13, 2.30, 385.27, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (39, 1, '2026-02-10 12:00:57', 404.54, 1.05, 385.27, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (40, 1, '2026-02-10 12:03:39', 874.57, 2.27, 385.27, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (41, 2, '2026-02-10 13:50:39', 2928.07, 7.60, 385.27, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (42, 2, '2026-02-10 14:08:44', 3467.45, 9.00, 385.27, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (43, 2, '2026-02-10 14:30:42', 1733.72, 4.50, 385.27, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (44, 2, '2026-02-10 15:27:34', 693.49, 1.80, 385.27, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (45, 1, '2026-02-10 15:47:27', 462.33, 1.20, 385.27, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (46, 1, '2026-02-10 16:59:11', 990.15, 2.57, 385.27, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (47, 2, '2026-02-10 17:03:47', 693.49, 1.80, 385.27, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (48, 2, '2026-02-10 21:29:30', 41802.01, 108.50, 385.27, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (49, 1, '2026-02-10 23:44:29', 693.49, 1.80, 385.27, 5, NULL, '', 'completada');
INSERT INTO `ventas` VALUES (50, 2, '2026-02-11 07:31:30', 1749.33, 4.50, 388.74, 8, NULL, '1010', 'completada');
INSERT INTO `ventas` VALUES (51, 2, '2026-02-11 07:53:48', 855.23, 2.20, 388.74, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (52, 2, '2026-02-11 08:03:16', 1749.33, 4.50, 388.74, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (53, 1, '2026-02-11 09:23:15', 855.23, 2.20, 388.74, 7, NULL, '', 'completada');
INSERT INTO `ventas` VALUES (54, 2, '2026-02-11 10:07:37', 738.60, 1.90, 388.74, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (55, 2, '2026-02-11 10:30:16', 894.10, 2.30, 388.74, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (56, 1, '2026-02-11 10:51:25', 2297.45, 5.91, 388.74, 3, 12, '', 'completada');
INSERT INTO `ventas` VALUES (57, 1, '2026-02-11 10:51:50', 984.52, 2.53, 388.74, 3, 8, '', 'completada');
INSERT INTO `ventas` VALUES (58, 2, '2026-02-11 10:54:00', 116.62, 0.30, 388.74, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (59, 2, '2026-02-11 11:22:58', 3965.14, 10.20, 388.74, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (60, 2, '2026-02-11 12:17:20', 816.35, 2.10, 388.74, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (61, 1, '2026-02-11 12:18:27', 3475.33, 8.94, 388.74, 3, 9, '', 'completada');
INSERT INTO `ventas` VALUES (62, 1, '2026-02-11 12:19:11', 388.74, 1.00, 388.74, 3, 9, '', 'completada');
INSERT INTO `ventas` VALUES (63, 1, '2026-02-11 12:19:51', 3475.33, 8.94, 388.74, 3, 9, '', 'completada');
INSERT INTO `ventas` VALUES (64, 2, '2026-02-11 12:26:41', 9990.60, 25.70, 388.74, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (65, 2, '2026-02-11 12:37:46', 427.61, 1.10, 388.74, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (66, 2, '2026-02-11 14:43:53', 388.74, 1.00, 388.74, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (67, 2, '2026-02-11 15:01:37', 699.73, 1.80, 388.74, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (68, 2, '2026-02-11 15:34:44', 894.10, 2.30, 388.74, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (69, 1, '2026-02-11 15:44:33', 921.31, 2.37, 388.74, 5, NULL, '', 'completada');
INSERT INTO `ventas` VALUES (70, 2, '2026-02-11 15:45:33', 388.74, 1.00, 388.74, NULL, NULL, NULL, 'completada');
INSERT INTO `ventas` VALUES (71, 2, '2026-02-11 16:29:31', 4353.88, 11.20, 388.74, 9, NULL, '', 'completada');
INSERT INTO `ventas` VALUES (72, 2, '2026-02-11 16:30:10', 3071.04, 7.90, 388.74, 9, NULL, '', 'completada');
INSERT INTO `ventas` VALUES (73, 2, '2026-02-11 16:31:19', 699.73, 1.80, 388.74, 9, NULL, '', 'completada');
INSERT INTO `ventas` VALUES (74, 2, '2026-02-11 16:56:49', 1516.08, 3.90, 388.74, 9, NULL, '', 'completada');
INSERT INTO `ventas` VALUES (75, 1, '2026-02-11 18:13:50', 602.55, 1.55, 388.74, 1, NULL, '', 'completada');
INSERT INTO `ventas` VALUES (76, 1, '2026-02-11 20:00:24', 1163.34, 2.99, 388.74, 1, NULL, '', 'completada');
INSERT INTO `ventas` VALUES (77, 2, '2026-02-11 20:23:31', 66163.45, 170.20, 388.74, 2, NULL, '', 'completada');
INSERT INTO `ventas` VALUES (78, 2, '2026-02-12 08:48:22', 1483.12, 3.80, 390.29, 2, NULL, '', 'completada');
INSERT INTO `ventas` VALUES (79, 2, '2026-02-12 10:23:13', 1873.41, 4.80, 390.29, 9, NULL, '', 'completada');
INSERT INTO `ventas` VALUES (80, 2, '2026-02-12 10:40:16', 2263.71, 5.80, 390.29, 8, NULL, '0025', 'completada');
INSERT INTO `ventas` VALUES (81, 2, '2026-02-12 10:48:15', 2263.71, 5.80, 390.29, 9, NULL, '', 'completada');
INSERT INTO `ventas` VALUES (82, 1, '2026-02-12 11:20:48', 534.70, 1.37, 390.29, 5, NULL, '', 'completada');
INSERT INTO `ventas` VALUES (83, 2, '2026-02-12 12:02:22', 702.53, 1.80, 390.29, 9, NULL, '', 'completada');

-- ----------------------------
-- Table structure for ventas_pagos
-- ----------------------------
DROP TABLE IF EXISTS `ventas_pagos`;
CREATE TABLE `ventas_pagos`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `venta_id` int NOT NULL,
  `metodo_pago_id` int NOT NULL,
  `monto_bs` decimal(10, 2) NULL DEFAULT 0.00,
  `monto_usd` decimal(10, 2) NULL DEFAULT 0.00,
  `referencia` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `fecha_pago` timestamp NULL DEFAULT current_timestamp,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `venta_id`(`venta_id`) USING BTREE,
  INDEX `metodo_pago_id`(`metodo_pago_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ventas_pagos
-- ----------------------------
INSERT INTO `ventas_pagos` VALUES (1, 49, 5, 693.49, 1.80, '', '2026-02-11 03:44:29');
INSERT INTO `ventas_pagos` VALUES (2, 50, 8, 1749.33, 4.50, '1010', '2026-02-11 11:31:30');
INSERT INTO `ventas_pagos` VALUES (3, 53, 7, 855.23, 2.20, '', '2026-02-11 13:23:15');
INSERT INTO `ventas_pagos` VALUES (4, 56, 3, 2297.45, 5.91, '', '2026-02-11 14:51:25');
INSERT INTO `ventas_pagos` VALUES (5, 57, 3, 984.52, 2.53, '', '2026-02-11 14:51:50');
INSERT INTO `ventas_pagos` VALUES (6, 61, 3, 3475.33, 8.94, '', '2026-02-11 16:18:27');
INSERT INTO `ventas_pagos` VALUES (7, 62, 3, 388.74, 1.00, '', '2026-02-11 16:19:11');
INSERT INTO `ventas_pagos` VALUES (8, 63, 3, 3475.33, 8.94, '', '2026-02-11 16:19:51');
INSERT INTO `ventas_pagos` VALUES (9, 69, 5, 921.31, 2.37, '', '2026-02-11 19:44:33');
INSERT INTO `ventas_pagos` VALUES (10, 71, 9, 4353.88, 11.20, '', '2026-02-11 20:29:31');
INSERT INTO `ventas_pagos` VALUES (11, 72, 9, 3071.04, 7.90, '', '2026-02-11 20:30:10');
INSERT INTO `ventas_pagos` VALUES (12, 73, 9, 699.73, 1.80, '', '2026-02-11 20:31:19');
INSERT INTO `ventas_pagos` VALUES (13, 74, 9, 1516.08, 3.90, '', '2026-02-11 20:56:49');
INSERT INTO `ventas_pagos` VALUES (14, 75, 1, 602.55, 1.55, '', '2026-02-11 22:13:50');
INSERT INTO `ventas_pagos` VALUES (15, 76, 1, 1162.33, 2.99, '', '2026-02-12 00:00:24');
INSERT INTO `ventas_pagos` VALUES (16, 77, 2, 66163.45, 170.20, '', '2026-02-12 00:23:31');
INSERT INTO `ventas_pagos` VALUES (17, 78, 2, 1483.12, 3.80, '', '2026-02-12 12:48:22');
INSERT INTO `ventas_pagos` VALUES (18, 79, 9, 1873.41, 4.80, '', '2026-02-12 14:23:13');
INSERT INTO `ventas_pagos` VALUES (19, 80, 8, 2263.71, 5.80, '0025', '2026-02-12 14:40:16');
INSERT INTO `ventas_pagos` VALUES (20, 81, 9, 2263.71, 5.80, '', '2026-02-12 14:48:15');
INSERT INTO `ventas_pagos` VALUES (21, 82, 5, 534.70, 1.37, '', '2026-02-12 15:20:48');
INSERT INTO `ventas_pagos` VALUES (22, 83, 9, 702.53, 1.80, '', '2026-02-12 16:02:22');

SET FOREIGN_KEY_CHECKS = 1;
