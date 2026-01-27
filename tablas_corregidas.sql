-- TABLAS PARA EL MÓDULO DE CASHEA (Independientes)
CREATE TABLE `cashea_compras` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `producto` text DEFAULT NULL,
  `precio` double DEFAULT NULL,
  `inicial` double DEFAULT NULL,
  `cuotas` int(11) DEFAULT NULL,
  `fecha_compra` date DEFAULT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

CREATE TABLE `cashea_pagos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compra_id` int(11) DEFAULT NULL,
  `cuota_num` int(11) DEFAULT NULL,
  `fecha_pago` date DEFAULT NULL,
  `monto` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cashea_compra` (`compra_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

-- TABLAS PARA EL MÓDULO DE BODEGA (Maestro-Detalle)
DROP TABLE IF EXISTS `compras_items`;
DROP TABLE IF EXISTS `compras`;

CREATE TABLE `compras` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `negocio_id` int(11) NOT NULL,
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  `total` decimal(10,2) DEFAULT 0.00,
  PRIMARY KEY (`id`),
  KEY `idx_bodega_negocio` (`negocio_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `compras_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compra_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `cantidad` decimal(10,2) NOT NULL,
  `costo_unitario` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_compra` (`compra_id`),
  KEY `idx_producto` (`producto_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
