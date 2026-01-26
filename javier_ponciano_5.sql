/*
 Navicat Premium Data Transfer

 Source Server         : ZZ - SomosSalud
 Source Server Type    : MySQL
 Source Server Version : 101114
 Source Host           : zz.com.ve:3306
 Source Schema         : javier_ponciano_5

 Target Server Type    : MySQL
 Target Server Version : 101114
 File Encoding         : 65001

 Date: 25/01/2026 21:33:50
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for exchange_rates
-- ----------------------------
DROP TABLE IF EXISTS `exchange_rates`;
CREATE TABLE `exchange_rates`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'BCV',
  `from` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `to` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'VES',
  `rate` decimal(12, 6) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uniq_rate_date_source_pair`(`date`, `source`, `from`, `to`) USING BTREE,
  INDEX `exchange_rates_date_index`(`date`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 38 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exchange_rates
-- ----------------------------
INSERT INTO `exchange_rates` VALUES (1, '2025-11-26', 'BCV', 'USD', 'VES', 243.572700, '2025-11-26 17:00:27', '2025-11-26 17:00:27');
INSERT INTO `exchange_rates` VALUES (2, '2025-11-27', 'BCV', 'USD', 'VES', 244.650400, '2025-11-27 00:16:17', '2025-11-27 00:16:17');
INSERT INTO `exchange_rates` VALUES (3, '2025-11-28', 'BCV', 'USD', 'VES', 245.669700, '2025-11-28 00:00:31', '2025-11-28 00:00:31');
INSERT INTO `exchange_rates` VALUES (4, '2025-12-01', 'BCV', 'USD', 'VES', 247.300300, '2025-11-29 00:14:46', '2025-11-29 00:14:46');
INSERT INTO `exchange_rates` VALUES (5, '2025-12-02', 'BCV', 'USD', 'VES', 247.407100, '2025-12-02 00:15:15', '2025-12-02 00:15:15');
INSERT INTO `exchange_rates` VALUES (6, '2025-12-03', 'BCV', 'USD', 'VES', 249.198900, '2025-12-03 02:55:00', '2025-12-03 02:55:00');
INSERT INTO `exchange_rates` VALUES (7, '2025-12-04', 'BCV', 'USD', 'VES', 251.886700, '2025-12-04 02:25:21', '2025-12-04 02:25:21');
INSERT INTO `exchange_rates` VALUES (8, '2025-12-05', 'BCV', 'USD', 'VES', 254.870500, '2025-12-05 12:38:24', '2025-12-05 12:38:24');
INSERT INTO `exchange_rates` VALUES (9, '2025-12-09', 'BCV', 'USD', 'VES', 257.928700, '2025-12-06 01:09:16', '2025-12-06 01:09:16');
INSERT INTO `exchange_rates` VALUES (10, '2025-12-10', 'BCV', 'USD', 'VES', 262.103600, '2025-12-10 01:17:07', '2025-12-10 01:17:07');
INSERT INTO `exchange_rates` VALUES (11, '2025-12-11', 'BCV', 'USD', 'VES', 265.066200, '2025-12-11 02:09:17', '2025-12-11 02:09:17');
INSERT INTO `exchange_rates` VALUES (12, '2025-12-12', 'BCV', 'USD', 'VES', 267.749900, '2025-12-12 03:04:36', '2025-12-12 03:04:36');
INSERT INTO `exchange_rates` VALUES (13, '2025-12-15', 'BCV', 'USD', 'VES', 270.789300, '2025-12-13 02:46:16', '2025-12-13 02:46:16');
INSERT INTO `exchange_rates` VALUES (14, '2025-12-16', 'BCV', 'USD', 'VES', 273.586100, '2025-12-16 00:26:17', '2025-12-16 00:26:17');
INSERT INTO `exchange_rates` VALUES (15, '2025-12-17', 'BCV', 'USD', 'VES', 276.576900, '2025-12-17 01:49:07', '2025-12-17 01:49:07');
INSERT INTO `exchange_rates` VALUES (16, '2025-12-18', 'BCV', 'USD', 'VES', 279.562900, '2025-12-18 01:45:43', '2025-12-18 01:45:43');
INSERT INTO `exchange_rates` VALUES (17, '2025-12-19', 'BCV', 'USD', 'VES', 282.512800, '2025-12-19 00:07:23', '2025-12-19 00:07:23');
INSERT INTO `exchange_rates` VALUES (18, '2025-12-22', 'BCV', 'USD', 'VES', 285.402400, '2025-12-20 02:50:58', '2025-12-20 02:50:58');
INSERT INTO `exchange_rates` VALUES (19, '2025-12-23', 'BCV', 'USD', 'VES', 288.449400, '2025-12-23 08:17:57', '2025-12-23 08:17:57');
INSERT INTO `exchange_rates` VALUES (20, '2025-12-26', 'BCV', 'USD', 'VES', 291.352400, '2025-12-24 04:40:30', '2025-12-24 04:40:30');
INSERT INTO `exchange_rates` VALUES (21, '2025-12-29', 'BCV', 'USD', 'VES', 294.969900, '2025-12-27 00:32:38', '2025-12-27 00:32:38');
INSERT INTO `exchange_rates` VALUES (22, '2025-12-30', 'BCV', 'USD', 'VES', 298.143100, '2025-12-30 00:51:21', '2025-12-30 00:51:21');
INSERT INTO `exchange_rates` VALUES (23, '2026-01-02', 'BCV', 'USD', 'VES', 301.370900, '2025-12-31 05:49:48', '2025-12-31 05:49:48');
INSERT INTO `exchange_rates` VALUES (24, '2026-01-05', 'BCV', 'USD', 'VES', 304.679600, '2026-01-03 06:40:11', '2026-01-03 06:40:11');
INSERT INTO `exchange_rates` VALUES (25, '2026-01-06', 'BCV', 'USD', 'VES', 308.154600, '2026-01-06 09:17:30', '2026-01-06 09:17:30');
INSERT INTO `exchange_rates` VALUES (26, '2026-01-07', 'BCV', 'USD', 'VES', 311.881400, '2026-01-07 00:01:29', '2026-01-07 00:01:29');
INSERT INTO `exchange_rates` VALUES (27, '2026-01-08', 'BCV', 'USD', 'VES', 321.032300, '2026-01-08 02:14:12', '2026-01-08 02:14:12');
INSERT INTO `exchange_rates` VALUES (28, '2026-01-09', 'BCV', 'USD', 'VES', 325.389400, '2026-01-09 00:21:32', '2026-01-09 00:21:32');
INSERT INTO `exchange_rates` VALUES (29, '2026-01-13', 'BCV', 'USD', 'VES', 330.375100, '2026-01-10 00:06:48', '2026-01-10 00:06:48');
INSERT INTO `exchange_rates` VALUES (30, '2026-01-14', 'BCV', 'USD', 'VES', 336.459600, '2026-01-14 08:12:09', '2026-01-14 08:12:09');
INSERT INTO `exchange_rates` VALUES (31, '2026-01-15', 'BCV', 'USD', 'VES', 339.149500, '2026-01-15 00:12:23', '2026-01-15 00:12:23');
INSERT INTO `exchange_rates` VALUES (32, '2026-01-16', 'BCV', 'USD', 'VES', 341.742500, '2026-01-16 00:15:34', '2026-01-16 00:15:34');
INSERT INTO `exchange_rates` VALUES (33, '2026-01-20', 'BCV', 'USD', 'VES', 344.507100, '2026-01-17 05:53:16', '2026-01-17 05:53:16');
INSERT INTO `exchange_rates` VALUES (34, '2026-01-21', 'BCV', 'USD', 'VES', 347.263100, '2026-01-21 00:37:20', '2026-01-21 00:37:20');
INSERT INTO `exchange_rates` VALUES (35, '2026-01-22', 'BCV', 'USD', 'VES', 349.927200, '2026-01-22 00:51:53', '2026-01-22 00:51:53');
INSERT INTO `exchange_rates` VALUES (36, '2026-01-23', 'BCV', 'USD', 'VES', 352.706300, '2026-01-23 02:54:36', '2026-01-23 02:54:36');
INSERT INTO `exchange_rates` VALUES (37, '2026-01-26', 'BCV', 'USD', 'VES', 355.552800, '2026-01-24 03:43:31', '2026-01-24 03:43:31');

SET FOREIGN_KEY_CHECKS = 1;
