-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 03, 2026 at 03:15 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `vygapps`
--

-- --------------------------------------------------------

--
-- Table structure for table `asistencia`
--

CREATE TABLE `asistencia` (
  `id_asistencia` int(11) NOT NULL,
  `hora_entrada` time NOT NULL,
  `hora_salida` time DEFAULT NULL,
  `id_trabajador` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `horas_extras` int(11) NOT NULL DEFAULT 0,
  `marca_anomala` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0: Normal, 1: Llegada tardía o Salida temprana'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Dumping data for table `asistencia`
--

INSERT INTO `asistencia` (`id_asistencia`, `hora_entrada`, `hora_salida`, `id_trabajador`, `fecha`, `horas_extras`, `marca_anomala`) VALUES
(1, '17:44:05', '19:46:14', 4, '2026-03-15', 0, 0),
(2, '17:50:35', '19:46:14', 4, '2026-03-15', 0, 0),
(3, '19:37:45', '19:46:14', 4, '2026-03-21', 0, 0),
(4, '17:44:13', '17:44:14', 5, '2026-03-31', 0, 0),
(5, '16:22:27', '19:46:14', 4, '2026-04-02', 0, 0),
(6, '22:01:05', '19:46:14', 4, '2026-04-03', 0, 0),
(7, '19:47:02', '19:46:14', 4, '2026-04-11', 0, 0),
(8, '20:21:38', '19:46:14', 4, '2026-04-11', 0, 0),
(9, '20:22:36', '19:46:14', 4, '2026-04-11', 0, 0),
(10, '20:23:07', '19:46:14', 4, '2026-04-11', 0, 0),
(11, '00:44:04', '19:46:14', 4, '2026-04-17', 0, 0),
(12, '00:17:37', '19:46:14', 4, '2026-04-23', 0, 0),
(13, '19:46:12', '19:46:14', 4, '2026-05-02', 0, 0),
(14, '19:41:07', '19:41:09', 4, '2026-05-30', 2, 0),
(15, '18:17:03', '21:12:23', 4, '2026-05-31', 1, 0),
(16, '18:32:31', '21:11:30', 4, '2026-05-31', 1, 0),
(17, '18:33:14', '21:11:30', 4, '2026-05-31', 1, 0),
(18, '18:35:52', '21:11:30', 4, '2026-05-31', 1, 0),
(19, '18:53:00', '21:11:30', 4, '2026-05-31', 1, 0),
(20, '18:55:17', '21:11:30', 4, '2026-05-31', 1, 0),
(21, '19:00:58', '21:11:30', 4, '2026-05-31', 1, 0),
(22, '19:02:17', '21:11:30', 4, '2026-05-31', 1, 0),
(23, '19:08:48', '21:11:30', 4, '2026-05-31', 1, 0),
(24, '21:08:17', '21:11:30', 4, '2026-05-31', 1, 0),
(25, '21:11:30', '21:11:30', 4, '2026-05-31', 1, 0),
(26, '21:12:03', NULL, 4, '2026-05-31', 0, 0),
(27, '21:12:23', NULL, 4, '2026-05-31', 0, 0),
(28, '20:12:31', '20:12:33', 4, '2026-06-02', 0, 0),
(29, '13:04:24', NULL, 4, '2026-08-02', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `codigos_asistencia`
--

CREATE TABLE `codigos_asistencia` (
  `id_codigo` int(11) NOT NULL,
  `codigo` varchar(10) NOT NULL,
  `id_supervisor` int(11) NOT NULL,
  `id_proyecto` int(11) NOT NULL,
  `fecha_generacion` datetime DEFAULT current_timestamp(),
  `fecha_expiracion` datetime NOT NULL,
  `estado` varchar(20) DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Dumping data for table `codigos_asistencia`
--

INSERT INTO `codigos_asistencia` (`id_codigo`, `codigo`, `id_supervisor`, `id_proyecto`, `fecha_generacion`, `fecha_expiracion`, `estado`) VALUES
(1, 'VYG-TZKBQZ', 8, 10, '2026-04-11 20:20:36', '2026-04-11 20:35:36', 'Activo'),
(2, 'VYG-CXFF2X', 8, 2, '2026-04-11 20:22:29', '2026-04-11 20:37:29', 'Activo'),
(3, 'VYG-B1AXRR', 8, 1, '2026-04-11 20:22:57', '2026-04-11 20:37:57', 'Activo'),
(4, 'VYG-9VIVRX', 8, 7, '2026-04-11 20:31:31', '2026-04-11 21:31:31', 'Activo'),
(5, 'VYG-14QBOA', 8, 10, '2026-04-16 15:40:31', '2026-04-16 15:55:31', 'Activo'),
(6, 'VYG-V1DZ8J', 8, 10, '2026-04-16 15:41:44', '2026-04-16 15:56:44', 'Activo'),
(7, 'VYG-6UKTNA', 8, 10, '2026-04-16 23:51:13', '2026-04-17 11:51:13', 'Activo'),
(8, 'VYG-79CGXZ', 8, 10, '2026-04-17 00:19:11', '2026-04-17 00:34:11', 'Activo'),
(9, 'VYG-RHOWUD', 8, 10, '2026-04-17 00:43:56', '2026-04-17 00:58:56', 'Activo'),
(10, 'VYG-SIHJPY', 8, 10, '2026-04-23 00:17:29', '2026-04-23 00:32:29', 'Activo'),
(11, 'VYG-V0D1JM', 8, 10, '2026-05-02 19:46:05', '2026-05-02 20:01:05', 'Activo'),
(12, 'VYG-67LXVW', 8, 3, '2026-05-15 22:39:58', '2026-05-15 22:54:58', 'Activo'),
(13, 'VYG-APVY9R', 8, 3, '2026-05-15 22:41:29', '2026-05-15 22:56:29', 'Activo'),
(14, 'VYG-VUM1U4', 8, 10, '2026-05-30 19:40:57', '2026-05-30 19:55:57', 'Activo'),
(15, 'VYG-QSJPI4', 8, 10, '2026-05-31 18:16:54', '2026-05-31 18:31:54', 'Activo'),
(16, 'VYG-1VOLLV', 8, 10, '2026-05-31 18:32:24', '2026-05-31 18:47:24', 'Activo'),
(17, 'VYG-L3NP9O', 8, 10, '2026-05-31 18:52:49', '2026-05-31 19:09:49', 'Activo'),
(18, 'VYG-8M5Z20', 8, 10, '2026-05-31 21:07:57', '2026-05-31 21:22:57', 'Activo'),
(19, 'VYG-0WJM1Q', 8, 10, '2026-06-02 20:12:24', '2026-06-02 20:27:24', 'Activo'),
(20, 'VYG-OH9P0N', 8, 10, '2026-08-02 13:04:13', '2026-08-02 13:19:13', 'Activo'),
(21, 'VYG-OYG11U', 8, 10, '2026-08-02 13:14:59', '2026-08-02 13:29:59', 'Activo'),
(22, 'VYG-8HITM4', 8, 1, '2026-08-02 13:17:47', '2026-08-02 13:32:47', 'Activo');

-- --------------------------------------------------------

--
-- Table structure for table `control_planillas`
--

CREATE TABLE `control_planillas` (
  `id_control` int(11) NOT NULL,
  `tipo_nomina` varchar(50) NOT NULL,
  `dias_ciclo` int(11) NOT NULL,
  `ultima_ejecucion` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Dumping data for table `control_planillas`
--

INSERT INTO `control_planillas` (`id_control`, `tipo_nomina`, `dias_ciclo`, `ultima_ejecucion`) VALUES
(1, 'Administrativa', 14, '2026-05-18'),
(2, 'Operativa', 15, '2026-06-01');

-- --------------------------------------------------------

--
-- Table structure for table `gastos_proyectos`
--

CREATE TABLE `gastos_proyectos` (
  `id_gasto` int(11) NOT NULL,
  `id_proyecto` int(11) NOT NULL,
  `concepto` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `monto` double(10,2) NOT NULL,
  `fecha_gasto` date NOT NULL,
  `nro_comprobante` varchar(50) DEFAULT NULL,
  `categoria` varchar(50) NOT NULL,
  `id_user_registra` int(11) NOT NULL,
  `fecha_registro` datetime DEFAULT current_timestamp(),
  `estado` varchar(20) NOT NULL DEFAULT 'Pendiente',
  `id_user_autoriza` int(11) DEFAULT NULL,
  `fecha_autorizacion` datetime DEFAULT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Dumping data for table `gastos_proyectos`
--

INSERT INTO `gastos_proyectos` (`id_gasto`, `id_proyecto`, `concepto`, `descripcion`, `monto`, `fecha_gasto`, `nro_comprobante`, `categoria`, `id_user_registra`, `fecha_registro`, `estado`, `id_user_autoriza`, `fecha_autorizacion`, `observaciones`) VALUES
(1, 10, 'Almuerzo trabajadores ', 'Compra de almuerzo del dia para trabajadores', 2250.00, '2026-05-16', '000123', 'Alimentacion', 7, '2026-05-16 21:06:41', 'Aprobado', 5, '2026-05-17 21:02:57', ''),
(2, 6, 'Cemento', 'Compra de cemento para avance del proyecto', 4500.00, '2026-05-17', '', 'Materiales', 7, '2026-05-17 21:13:02', 'Aprobado', 5, '2026-05-17 21:15:18', ''),
(3, 6, 'Cemento', 'Compra de cemento para avance del proyecto', 4500.00, '2026-05-17', '', 'Materiales', 5, '2026-05-17 21:13:12', 'Aprobado', 5, '2026-05-17 21:15:10', ''),
(4, 6, 'Cemento', 'Compra cemento para avances', 4500.00, '2026-05-17', '', 'Materiales', 7, '2026-05-17 21:14:03', 'Aprobado', 5, '2026-05-17 21:15:06', ''),
(5, 14, 'Pintura', '15 litros de pintura ', 13500.00, '2026-05-17', '000192', 'Materiales', 7, '2026-05-17 21:23:58', 'Aprobado', 5, '2026-05-17 21:24:29', ''),
(6, 9, 'Topografía y levantamientos de terreno', 'Plano de topografica y levantamientos', 65000.00, '2026-05-18', 'FAC-99322200', 'Otros', 7, '2026-05-18 21:50:51', 'Aprobado', 5, '2026-05-18 21:51:42', ''),
(7, 5, 'Bombillas LED ', '5 bombillas LED. Luz fria.', 500.00, '2026-05-19', 'RUC-99938', 'Materiales', 7, '2026-05-19 21:19:26', 'Aprobado', 5, '2026-05-19 23:09:03', ''),
(8, 8, 'pintura ', 'pintura fachada edificio', 8967.62, '2026-05-29', '', 'Materiales', 7, '2026-05-29 19:53:58', 'Aprobado', 5, '2026-05-31 18:11:25', ''),
(9, 11, 'Transporte ', 'transporte arena y cemento', 3400.00, '2026-05-29', '', 'Combustible', 7, '2026-05-29 19:54:34', 'Aprobado', 5, '2026-05-31 18:11:20', ''),
(10, 5, 'transporte materiales', 'transporte arena y cemento', 3600.00, '2026-05-29', '', 'Materiales', 7, '2026-05-29 20:22:45', 'Aprobado', 5, '2026-05-31 18:11:17', '');

-- --------------------------------------------------------

--
-- Table structure for table `justificaciones`
--

CREATE TABLE `justificaciones` (
  `id_justificacion` int(11) NOT NULL,
  `id_trabajador` int(11) NOT NULL,
  `fecha_incidencia` date NOT NULL,
  `tipo_motivo` varchar(100) NOT NULL COMMENT 'Ej: Enfermedad, Emergencia, Lluvia',
  `descripcion` text NOT NULL,
  `estado` varchar(50) NOT NULL DEFAULT 'Pendiente' COMMENT 'Pendiente, Aprobada, Rechazada'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Dumping data for table `justificaciones`
--

INSERT INTO `justificaciones` (`id_justificacion`, `id_trabajador`, `fecha_incidencia`, `tipo_motivo`, `descripcion`, `estado`) VALUES
(1, 4, '2026-05-31', 'Salida Temprana - Clima/Lluvia', '', 'Aprobada');

-- --------------------------------------------------------

--
-- Table structure for table `maquinas`
--

CREATE TABLE `maquinas` (
  `id_maquina` int(11) NOT NULL,
  `tipo_maquina` varchar(50) NOT NULL,
  `marca` varchar(50) NOT NULL,
  `funcion` varchar(50) NOT NULL,
  `costo_por_hora` double(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Dumping data for table `maquinas`
--

INSERT INTO `maquinas` (`id_maquina`, `tipo_maquina`, `marca`, `funcion`, `costo_por_hora`) VALUES
(1, 'Retroexcabadora', 'Caterpillar', 'excavación, relleno y manipulación de materiales', 0.00),
(2, 'Volquete', 'Caterpillar', 'Transporte de carga pesada', 2500.00),
(3, 'Pipa de agua ', 'Caterpillar', 'Transporte de carga pesada', 2500.00);

-- --------------------------------------------------------

--
-- Table structure for table `materiales`
--

CREATE TABLE `materiales` (
  `id_material` int(11) NOT NULL,
  `nombre_material` varchar(100) NOT NULL,
  `unidad_medida` varchar(20) NOT NULL,
  `costo_unitario` double(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Dumping data for table `materiales`
--

INSERT INTO `materiales` (`id_material`, `nombre_material`, `unidad_medida`, `costo_unitario`) VALUES
(1, 'Cemento', 'm3', 3700.00),
(2, 'Varios', 'm3', 24000.00);

-- --------------------------------------------------------

--
-- Table structure for table `pago`
--

CREATE TABLE `pago` (
  `id_pago` int(11) NOT NULL,
  `monto_presupuestado` double(10,2) NOT NULL,
  `quincena_fecha` date NOT NULL,
  `estado` varchar(20) NOT NULL,
  `id_trabajador` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `id_jefe` int(11) NOT NULL,
  `id_proyecto` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pago_maquinaria`
--

CREATE TABLE `pago_maquinaria` (
  `id_pago_maq` int(11) NOT NULL,
  `fecha_generacion` date NOT NULL DEFAULT curdate(),
  `monto_horas` double(10,2) NOT NULL,
  `monto_combustible` double(10,2) NOT NULL,
  `total_pagado` double(10,2) NOT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'Pendiente',
  `id_uso` int(11) NOT NULL,
  `id_user_genera` int(11) NOT NULL,
  `id_user_autoriza` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Dumping data for table `pago_maquinaria`
--

INSERT INTO `pago_maquinaria` (`id_pago_maq`, `fecha_generacion`, `monto_horas`, `monto_combustible`, `total_pagado`, `estado`, `id_uso`, `id_user_genera`, `id_user_autoriza`) VALUES
(1, '2026-04-02', 0.00, 950.00, 950.00, 'Autorizado', 1, 5, 7),
(2, '2026-04-02', 0.00, 500.00, 500.00, 'Autorizado', 2, 5, 7),
(3, '2026-04-02', 0.00, 500.00, 500.00, 'Autorizado', 3, 5, 7),
(4, '2026-04-02', 0.00, 300.00, 300.00, 'Autorizado', 4, 5, 7),
(5, '2026-04-22', 0.00, 1860.00, 1860.00, 'Autorizado', 5, 5, 7),
(6, '2026-04-25', 0.00, 2999.99, 2999.99, 'Autorizado', 6, 5, 7),
(7, '2026-05-02', 29653.33, 8458.00, 38111.33, 'Autorizado', 7, 5, 7),
(8, '2026-05-02', 2700.00, 750.00, 3450.00, 'Autorizado', 8, 5, 7);

-- --------------------------------------------------------

--
-- Table structure for table `pago_nomina`
--

CREATE TABLE `pago_nomina` (
  `id_pago_nomina` int(11) NOT NULL,
  `fecha_generacion` date NOT NULL DEFAULT curdate(),
  `periodo_inicio` date NOT NULL,
  `periodo_fin` date NOT NULL,
  `dias_trabajados` int(11) NOT NULL,
  `monto_pagado` double(10,2) NOT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'Pendiente',
  `id_trabajador` int(11) NOT NULL,
  `id_user_genera` int(11) NOT NULL,
  `id_user_autoriza` int(11) DEFAULT NULL,
  `monto_horas_extras` decimal(10,2) NOT NULL DEFAULT 0.00,
  `dias_justificados` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Dumping data for table `pago_nomina`
--

INSERT INTO `pago_nomina` (`id_pago_nomina`, `fecha_generacion`, `periodo_inicio`, `periodo_fin`, `dias_trabajados`, `monto_pagado`, `estado`, `id_trabajador`, `id_user_genera`, `id_user_autoriza`, `monto_horas_extras`, `dias_justificados`) VALUES
(1, '2026-04-02', '2026-04-01', '2026-04-15', 0, 0.00, 'Autorizado', 1, 5, 7, 0.00, 0),
(2, '2026-04-02', '2026-04-01', '2026-04-15', 0, 0.00, 'Autorizado', 2, 5, 7, 0.00, 0),
(3, '2026-04-02', '2026-04-01', '2026-04-15', 0, 0.00, 'Autorizado', 3, 5, 7, 0.00, 0),
(4, '2026-04-02', '2026-04-01', '2026-04-15', 1, 520.00, 'Autorizado', 4, 5, 7, 0.00, 0),
(5, '2026-04-02', '2026-04-01', '2026-04-15', 0, 0.00, 'Autorizado', 5, 5, 7, 0.00, 0),
(6, '2026-04-02', '2026-04-01', '2026-04-15', 0, 0.00, 'Autorizado', 6, 5, 7, 0.00, 0),
(7, '2026-04-02', '2026-04-01', '2026-04-15', 0, 0.00, 'Autorizado', 7, 5, 7, 0.00, 0),
(8, '2026-04-02', '2026-04-01', '2026-04-15', 0, 0.00, 'Autorizado', 8, 5, 7, 0.00, 0),
(9, '2026-04-02', '2026-04-01', '2026-04-15', 0, 0.00, 'Autorizado', 52, 5, 7, 0.00, 0),
(10, '2026-04-02', '2026-04-01', '2026-04-15', 0, 0.00, 'Autorizado', 53, 5, 7, 0.00, 0),
(11, '2026-04-02', '2026-04-01', '2026-04-15', 0, 0.00, 'Autorizado', 54, 5, 7, 0.00, 0),
(12, '2026-04-21', '2026-04-01', '2026-04-15', 0, 0.00, 'Autorizado', 1, 5, 7, 0.00, 0),
(13, '2026-04-21', '2026-04-01', '2026-04-15', 0, 0.00, 'Autorizado', 2, 5, 7, 0.00, 0),
(14, '2026-04-21', '2026-04-01', '2026-04-15', 0, 0.00, 'Autorizado', 3, 5, 7, 0.00, 0),
(15, '2026-04-21', '2026-04-01', '2026-04-15', 3, 1560.00, 'Autorizado', 4, 5, 7, 0.00, 0),
(16, '2026-04-21', '2026-04-01', '2026-04-15', 0, 0.00, 'Autorizado', 5, 5, 7, 0.00, 0),
(17, '2026-04-21', '2026-04-01', '2026-04-15', 0, 0.00, 'Autorizado', 6, 5, 7, 0.00, 0),
(18, '2026-04-21', '2026-04-01', '2026-04-15', 0, 0.00, 'Autorizado', 7, 5, 7, 0.00, 0),
(19, '2026-04-21', '2026-04-01', '2026-04-15', 0, 0.00, 'Autorizado', 8, 5, 7, 0.00, 0),
(20, '2026-04-21', '2026-04-01', '2026-04-15', 0, 0.00, 'Autorizado', 52, 5, 7, 0.00, 0),
(21, '2026-04-21', '2026-04-01', '2026-04-15', 0, 0.00, 'Autorizado', 53, 5, 7, 0.00, 0),
(22, '2026-04-21', '2026-04-01', '2026-04-15', 10, 3166.66, 'Autorizado', 54, 5, 7, 0.00, 0),
(27, '2026-04-23', '2026-04-23', '2026-04-26', 0, 0.00, 'Autorizado', 1, 5, 7, 0.00, 0),
(28, '2026-04-23', '2026-04-23', '2026-04-26', 0, 0.00, 'Autorizado', 2, 5, 7, 0.00, 0),
(29, '2026-04-23', '2026-04-23', '2026-04-26', 0, 0.00, 'Autorizado', 3, 5, 7, 0.00, 0),
(30, '2026-04-23', '2026-04-23', '2026-04-26', 1, 520.00, 'Autorizado', 4, 5, 7, 0.00, 0),
(31, '2026-04-23', '2026-04-23', '2026-04-26', 0, 0.00, 'Autorizado', 5, 5, 7, 0.00, 0),
(32, '2026-04-23', '2026-04-23', '2026-04-26', 0, 0.00, 'Autorizado', 6, 5, 7, 0.00, 0),
(33, '2026-04-23', '2026-04-23', '2026-04-26', 0, 0.00, 'Autorizado', 7, 5, 7, 0.00, 0),
(34, '2026-04-23', '2026-04-23', '2026-04-26', 0, 0.00, 'Autorizado', 8, 5, 7, 0.00, 0),
(35, '2026-04-23', '2026-04-23', '2026-04-26', 0, 0.00, 'Autorizado', 52, 5, 7, 0.00, 0),
(36, '2026-04-23', '2026-04-23', '2026-04-26', 0, 0.00, 'Autorizado', 53, 5, 7, 0.00, 0),
(37, '2026-04-23', '2026-04-23', '2026-04-26', 0, 0.00, 'Autorizado', 54, 5, 7, 0.00, 0),
(38, '2026-04-23', '2026-04-23', '2026-04-26', 0, 0.00, 'Autorizado', 56, 5, 7, 0.00, 0),
(42, '2026-05-02', '2026-05-02', '2026-05-02', 0, 0.00, 'Autorizado', 1, 5, 7, 0.00, 0),
(43, '2026-05-02', '2026-05-02', '2026-05-02', 0, 0.00, 'Autorizado', 2, 5, 7, 0.00, 0),
(44, '2026-05-02', '2026-05-02', '2026-05-02', 0, 0.00, 'Autorizado', 3, 5, 7, 0.00, 0),
(45, '2026-05-02', '2026-05-02', '2026-05-02', 1, 520.00, 'Autorizado', 4, 5, 7, 0.00, 0),
(46, '2026-05-02', '2026-05-02', '2026-05-02', 0, 0.00, 'Autorizado', 5, 5, 7, 0.00, 0),
(47, '2026-05-02', '2026-05-02', '2026-05-02', 0, 0.00, 'Autorizado', 6, 5, 7, 0.00, 0),
(48, '2026-05-02', '2026-05-02', '2026-05-02', 0, 0.00, 'Autorizado', 7, 5, 7, 0.00, 0),
(49, '2026-05-02', '2026-05-02', '2026-05-02', 0, 0.00, 'Autorizado', 8, 5, 7, 0.00, 0),
(50, '2026-05-02', '2026-05-02', '2026-05-02', 0, 0.00, 'Autorizado', 52, 5, 7, 0.00, 0),
(51, '2026-05-02', '2026-05-02', '2026-05-02', 0, 0.00, 'Autorizado', 53, 5, 7, 0.00, 0),
(52, '2026-05-02', '2026-05-02', '2026-05-02', 0, 0.00, 'Autorizado', 54, 5, 7, 0.00, 0),
(53, '2026-05-02', '2026-05-02', '2026-05-02', 0, 0.00, 'Autorizado', 56, 5, 7, 0.00, 0),
(57, '2026-08-02', '2026-05-17', '2026-06-01', 2, 2340.00, 'Pendiente', 4, 5, NULL, 1300.00, 0);

-- --------------------------------------------------------

--
-- Table structure for table `proyectos`
--

CREATE TABLE `proyectos` (
  `id_proyecto` int(11) NOT NULL,
  `name_proyect` varchar(50) NOT NULL,
  `estado` varchar(20) NOT NULL,
  `presupuesto_total` double(15,2) NOT NULL DEFAULT 0.00,
  `hora_entrada_oficial` time NOT NULL DEFAULT '08:00:00',
  `hora_salida_oficial` time NOT NULL DEFAULT '17:00:00',
  `tarifa_hora_extra` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Dumping data for table `proyectos`
--

INSERT INTO `proyectos` (`id_proyecto`, `name_proyect`, `estado`, `presupuesto_total`, `hora_entrada_oficial`, `hora_salida_oficial`, `tarifa_hora_extra`) VALUES
(1, 'Reparacion km45 carretera nueva león', 'activo', 10918274.36, '08:00:00', '17:00:00', 0.00),
(2, 'Construcción Edificio Central', 'activo', 19866794.05, '08:00:00', '17:00:00', 0.00),
(3, 'Remodelación Hospital Norte', 'activo', 21583898.78, '08:00:00', '17:00:00', 0.00),
(4, 'Carretera Intermunicipal', 'activo', 23278151.02, '08:00:00', '17:00:00', 0.00),
(5, 'Puente Río Verde', 'activo', 6849517.06, '08:00:00', '17:00:00', 0.00),
(6, 'Centro Comercial Las Palmas', 'activo', 19196128.18, '08:00:00', '17:00:00', 0.00),
(7, 'Planta Solar San Miguel', 'activo', 10504625.67, '08:00:00', '17:00:00', 0.00),
(8, 'Urbanización Los Robles', 'activo', 9931274.77, '08:00:00', '17:00:00', 0.00),
(9, 'Ampliación Aeropuerto Regional', 'activo', 13113034.57, '08:00:00', '17:00:00', 0.00),
(10, 'Sistema de Agua Potable Sur', 'activo', 11077826.32, '18:55:00', '20:00:00', 100.00),
(11, 'Rehabilitación Escuela Nacional', 'activo', 10812877.49, '08:00:00', '17:00:00', 0.00),
(12, 'Reconstruccion Catedral de Managua', 'activo', 15883938.09, '08:00:00', '17:00:00', 0.00),
(13, 'Reconstruccion Catedral de Managua', 'activo', 21969808.62, '08:00:00', '17:00:00', 0.00),
(14, 'Ampliacion Hospital Militar', 'activo', 19986500.00, '08:00:00', '17:00:00', 0.00);

-- --------------------------------------------------------

--
-- Table structure for table `proyecto_supervisor`
--

CREATE TABLE `proyecto_supervisor` (
  `id_proyecto` int(11) NOT NULL,
  `id_trabajador` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Dumping data for table `proyecto_supervisor`
--

INSERT INTO `proyecto_supervisor` (`id_proyecto`, `id_trabajador`) VALUES
(2, 1),
(6, 54),
(9, 1),
(11, 2),
(11, 3);

-- --------------------------------------------------------

--
-- Table structure for table `registro_camiones`
--

CREATE TABLE `registro_camiones` (
  `id_ruta` int(11) NOT NULL,
  `hora_salida` time NOT NULL,
  `hora_llegada` time NOT NULL,
  `origen` varchar(50) NOT NULL,
  `destino` varchar(50) NOT NULL,
  `cantidad_cargada` int(11) NOT NULL,
  `id_uso` int(11) NOT NULL,
  `costo_flete` double(10,2) NOT NULL DEFAULT 0.00,
  `id_material` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Dumping data for table `registro_camiones`
--

INSERT INTO `registro_camiones` (`id_ruta`, `hora_salida`, `hora_llegada`, `origen`, `destino`, `cantidad_cargada`, `id_uso`, `costo_flete`, `id_material`) VALUES
(1, '17:16:00', '19:18:00', 'cemex', 'proyecto los robles', 10, 1, 2500.00, 1),
(2, '19:42:00', '20:39:00', 'Colonia Maximo Jerez, Managua.', 'proyecto los robles', 13, 5, 3500.00, 1),
(3, '22:55:00', '23:55:00', 'Colonia Maximo Jerez, Managua.', 'proyecto los robles', 3, 6, 3500.00, 1),
(4, '18:55:00', '20:55:00', 'Managua', 'Leon', 20, 7, 3000.00, 1),
(5, '18:55:00', '20:55:00', 'Managua', 'Leon', 20, 7, 3000.00, 1),
(6, '18:55:00', '20:55:00', 'Managua', 'Leon', 20, 7, 3000.00, 1),
(7, '19:56:00', '21:57:00', 'Managua', 'proyecto los robles', 20, 7, 3890.00, 1),
(8, '19:56:00', '21:57:00', 'Managua', 'proyecto los robles', 20, 7, 3890.00, 1),
(9, '19:56:00', '21:57:00', 'Managua', 'proyecto los robles', 20, 7, 3890.00, 1),
(10, '19:56:00', '21:57:00', 'Managua', 'proyecto los robles', 20, 7, 3890.00, 1);

-- --------------------------------------------------------

--
-- Table structure for table `trabajadores`
--

CREATE TABLE `trabajadores` (
  `id_trabajador` int(11) NOT NULL,
  `cedula` varchar(50) NOT NULL,
  `full_name` varchar(50) NOT NULL,
  `edad` int(11) NOT NULL,
  `puesto` varchar(50) NOT NULL,
  `salario_quincenal` double(10,2) NOT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'Activo',
  `origen` varchar(100) NOT NULL,
  `id_supervisor` int(11) NOT NULL,
  `id_proyect` int(11) NOT NULL,
  `telefono` varchar(8) DEFAULT NULL,
  `numero_emergencia` varchar(8) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `tipo_nomina` varchar(50) NOT NULL DEFAULT 'Operativa'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Dumping data for table `trabajadores`
--

INSERT INTO `trabajadores` (`id_trabajador`, `cedula`, `full_name`, `edad`, `puesto`, `salario_quincenal`, `estado`, `origen`, `id_supervisor`, `id_proyect`, `telefono`, `numero_emergencia`, `direccion`, `tipo_nomina`) VALUES
(1, '001-131105-1013R', 'Benjamin Dolores De Jesus Telleria Lacayo', 20, 'Ingeniero residente', 12000.00, 'Activo', 'Managua', 8, 10, '83273591', '82000686', 'Colonia Maximo Jerez, Templo mormon, 20 vrs al sur.', 'Administrativa'),
(2, '001-230598-0001A', 'Jose manuel Pomares Alvarez ', 34, 'Supervisor de obra', 34567.00, 'Activo', 'Masaya', 2, 11, NULL, NULL, NULL, 'Operativa'),
(3, '001-010101-0001A', 'Carlos Mendoza', 28, 'Capataz', 14500.00, 'Activo', 'Managua', 2, 8, NULL, NULL, NULL, 'Operativa'),
(4, '001-020202-0002B', 'Luis Ramirez', 35, 'Obrero', 7800.00, 'Activo', 'Granada', 2, 10, NULL, NULL, NULL, 'Operativa'),
(5, '001-090909-0009I', 'Daniel Gutierrez', 45, 'Tecnico operativo', 7800.00, 'Activo', 'Rivas', 2, 7, NULL, NULL, NULL, 'Operativa'),
(6, '001-010907-1424T', 'Emanuel Telleria Lacayo', 18, 'Gerente de proyecto', 6500.00, 'Activo', 'Managua', 2, 1, NULL, NULL, NULL, 'Administrativa'),
(7, '003-030297-0023Q', 'Josue Francisco  Caceres Obando', 45, 'Supervisor de obra', 12000.00, 'Activo', 'Leon', 2, 8, NULL, NULL, NULL, 'Operativa'),
(8, '281-05044-0001Q', 'Marcio Jose Telleria Gurdian', 82, 'Ingeniero residente', 15000.00, 'Activo', 'Leon', 2, 9, NULL, NULL, NULL, 'Administrativa'),
(52, '001-101010-0010J', 'Eduardo Morales', 27, 'Supervisor de obra', 7800.00, 'Activo', 'Bluefields, RACCN', 2, 14, NULL, NULL, NULL, 'Operativa'),
(53, '001-111111-0011K', 'David Josue Tenorio', 20, 'Obrero', 5800.00, 'Activo', 'Chontales', 52, 3, NULL, NULL, NULL, 'Operativa'),
(54, '281-020407-1001S', 'Alexandra Mercedes Rocha Alvarez', 19, 'Ingeniero residente', 9500.00, 'Activo', 'Santa Rita, Mulukuku', 52, 6, NULL, NULL, NULL, 'Administrativa'),
(56, '001-020406-1021J', 'Lucia Guerrero', 19, 'Arquitecto', 7897.00, 'Activo', 'Managua', 52, 7, NULL, NULL, NULL, 'Administrativa'),
(57, '281-271119-3040H', 'Amanda Marcela Rocha Alvarez', 18, 'Capataz', 5600.00, 'Activo', 'RACN', 8, 6, NULL, NULL, NULL, 'Operativa');

-- --------------------------------------------------------

--
-- Table structure for table `uso_registro`
--

CREATE TABLE `uso_registro` (
  `id_uso` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `costo_por_hora` decimal(10,2) NOT NULL DEFAULT 0.00,
  `combustible` int(10) NOT NULL,
  `id_maquinaria` int(11) NOT NULL,
  `id_proyect` int(11) NOT NULL,
  `id_trabajador` int(11) NOT NULL,
  `costo_combustible_total` double(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Dumping data for table `uso_registro`
--

INSERT INTO `uso_registro` (`id_uso`, `fecha`, `hora_inicio`, `hora_fin`, `costo_por_hora`, `combustible`, `id_maquinaria`, `id_proyect`, `id_trabajador`, `costo_combustible_total`) VALUES
(1, '2026-02-28', '19:33:00', '00:38:00', 0.00, 20, 1, 2, 5, 950.00),
(2, '2026-02-27', '10:30:00', '16:40:00', 0.00, 10, 1, 5, 5, 500.00),
(3, '2026-02-27', '10:30:00', '16:40:00', 0.00, 10, 1, 5, 5, 500.00),
(4, '2026-02-20', '08:36:00', '10:42:00', 0.00, 2, 1, 9, 5, 300.00),
(5, '2026-04-03', '12:00:00', '19:02:00', 3600.00, 10, 1, 12, 5, 1860.00),
(6, '2026-04-16', '08:52:00', '02:52:00', 3000.00, 20, 1, 7, 5, 2999.99),
(7, '2026-05-02', '12:20:00', '23:00:00', 2780.00, 45, 1, 4, 5, 8458.00),
(8, '2026-05-02', '19:45:00', '20:45:00', 2700.00, 5, 1, 11, 5, 750.00);

-- --------------------------------------------------------

--
-- Table structure for table `usuarios`
--

CREATE TABLE `usuarios` (
  `id_user` int(11) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `pass` varchar(20) NOT NULL,
  `rol` varchar(50) NOT NULL,
  `id_trabajador` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Dumping data for table `usuarios`
--

INSERT INTO `usuarios` (`id_user`, `user_name`, `pass`, `rol`, `id_trabajador`) VALUES
(1, 'BenjaTelle', 'AdminVyG', 'Administrador', NULL),
(5, 'Ale', 'mapache123', 'Administrador', 54),
(7, 'MarcioTelleria', 'marcio0544', 'Supervisor', 8),
(8, 'LuisR', 'mapache123', 'Trabajador', 4),
(9, 'DaniG', '1234', 'Trabajador', 5);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `asistencia`
--
ALTER TABLE `asistencia`
  ADD PRIMARY KEY (`id_asistencia`),
  ADD KEY `id_trabajador` (`id_trabajador`);

--
-- Indexes for table `codigos_asistencia`
--
ALTER TABLE `codigos_asistencia`
  ADD PRIMARY KEY (`id_codigo`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `id_supervisor` (`id_supervisor`),
  ADD KEY `id_proyecto` (`id_proyecto`);

--
-- Indexes for table `control_planillas`
--
ALTER TABLE `control_planillas`
  ADD PRIMARY KEY (`id_control`);

--
-- Indexes for table `gastos_proyectos`
--
ALTER TABLE `gastos_proyectos`
  ADD PRIMARY KEY (`id_gasto`),
  ADD KEY `fk_gp_proyecto` (`id_proyecto`),
  ADD KEY `fk_gp_user_reg` (`id_user_registra`),
  ADD KEY `fk_gp_user_aut` (`id_user_autoriza`);

--
-- Indexes for table `justificaciones`
--
ALTER TABLE `justificaciones`
  ADD PRIMARY KEY (`id_justificacion`),
  ADD KEY `fk_justificacion_trabajador` (`id_trabajador`);

--
-- Indexes for table `maquinas`
--
ALTER TABLE `maquinas`
  ADD PRIMARY KEY (`id_maquina`);

--
-- Indexes for table `materiales`
--
ALTER TABLE `materiales`
  ADD PRIMARY KEY (`id_material`);

--
-- Indexes for table `pago`
--
ALTER TABLE `pago`
  ADD PRIMARY KEY (`id_pago`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_trabajador` (`id_trabajador`),
  ADD KEY `id_proyecto` (`id_proyecto`);

--
-- Indexes for table `pago_maquinaria`
--
ALTER TABLE `pago_maquinaria`
  ADD PRIMARY KEY (`id_pago_maq`),
  ADD KEY `fk_pm_uso` (`id_uso`),
  ADD KEY `fk_pm_user_gen` (`id_user_genera`),
  ADD KEY `fk_pm_user_aut` (`id_user_autoriza`);

--
-- Indexes for table `pago_nomina`
--
ALTER TABLE `pago_nomina`
  ADD PRIMARY KEY (`id_pago_nomina`),
  ADD KEY `fk_pn_trabajador` (`id_trabajador`),
  ADD KEY `fk_pn_user_gen` (`id_user_genera`),
  ADD KEY `fk_pn_user_aut` (`id_user_autoriza`);

--
-- Indexes for table `proyectos`
--
ALTER TABLE `proyectos`
  ADD PRIMARY KEY (`id_proyecto`);

--
-- Indexes for table `proyecto_supervisor`
--
ALTER TABLE `proyecto_supervisor`
  ADD PRIMARY KEY (`id_proyecto`,`id_trabajador`),
  ADD KEY `id_trabajador` (`id_trabajador`);

--
-- Indexes for table `registro_camiones`
--
ALTER TABLE `registro_camiones`
  ADD PRIMARY KEY (`id_ruta`),
  ADD KEY `id_uso` (`id_uso`),
  ADD KEY `id_material` (`id_material`);

--
-- Indexes for table `trabajadores`
--
ALTER TABLE `trabajadores`
  ADD PRIMARY KEY (`id_trabajador`),
  ADD KEY `id_proyect` (`id_proyect`),
  ADD KEY `trabajadores_ibfk_1` (`id_supervisor`);

--
-- Indexes for table `uso_registro`
--
ALTER TABLE `uso_registro`
  ADD PRIMARY KEY (`id_uso`),
  ADD KEY `id_proyect` (`id_proyect`),
  ADD KEY `id_trabajador` (`id_trabajador`),
  ADD KEY `id_maquinaria` (`id_maquinaria`);

--
-- Indexes for table `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_user`),
  ADD KEY `id_trabajador` (`id_trabajador`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `asistencia`
--
ALTER TABLE `asistencia`
  MODIFY `id_asistencia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `codigos_asistencia`
--
ALTER TABLE `codigos_asistencia`
  MODIFY `id_codigo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `control_planillas`
--
ALTER TABLE `control_planillas`
  MODIFY `id_control` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `gastos_proyectos`
--
ALTER TABLE `gastos_proyectos`
  MODIFY `id_gasto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `justificaciones`
--
ALTER TABLE `justificaciones`
  MODIFY `id_justificacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `maquinas`
--
ALTER TABLE `maquinas`
  MODIFY `id_maquina` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `materiales`
--
ALTER TABLE `materiales`
  MODIFY `id_material` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `pago`
--
ALTER TABLE `pago`
  MODIFY `id_pago` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pago_maquinaria`
--
ALTER TABLE `pago_maquinaria`
  MODIFY `id_pago_maq` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `pago_nomina`
--
ALTER TABLE `pago_nomina`
  MODIFY `id_pago_nomina` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT for table `proyectos`
--
ALTER TABLE `proyectos`
  MODIFY `id_proyecto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `registro_camiones`
--
ALTER TABLE `registro_camiones`
  MODIFY `id_ruta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `trabajadores`
--
ALTER TABLE `trabajadores`
  MODIFY `id_trabajador` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT for table `uso_registro`
--
ALTER TABLE `uso_registro`
  MODIFY `id_uso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `asistencia`
--
ALTER TABLE `asistencia`
  ADD CONSTRAINT `asistencia_ibfk_1` FOREIGN KEY (`id_trabajador`) REFERENCES `trabajadores` (`id_trabajador`);

--
-- Constraints for table `codigos_asistencia`
--
ALTER TABLE `codigos_asistencia`
  ADD CONSTRAINT `codigos_asistencia_ibfk_1` FOREIGN KEY (`id_supervisor`) REFERENCES `trabajadores` (`id_trabajador`),
  ADD CONSTRAINT `codigos_asistencia_ibfk_2` FOREIGN KEY (`id_proyecto`) REFERENCES `proyectos` (`id_proyecto`);

--
-- Constraints for table `gastos_proyectos`
--
ALTER TABLE `gastos_proyectos`
  ADD CONSTRAINT `fk_gp_proyecto` FOREIGN KEY (`id_proyecto`) REFERENCES `proyectos` (`id_proyecto`),
  ADD CONSTRAINT `fk_gp_user_aut` FOREIGN KEY (`id_user_autoriza`) REFERENCES `usuarios` (`id_user`),
  ADD CONSTRAINT `fk_gp_user_reg` FOREIGN KEY (`id_user_registra`) REFERENCES `usuarios` (`id_user`);

--
-- Constraints for table `justificaciones`
--
ALTER TABLE `justificaciones`
  ADD CONSTRAINT `fk_justificacion_trabajador` FOREIGN KEY (`id_trabajador`) REFERENCES `trabajadores` (`id_trabajador`) ON DELETE CASCADE;

--
-- Constraints for table `pago`
--
ALTER TABLE `pago`
  ADD CONSTRAINT `pago_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `usuarios` (`id_user`),
  ADD CONSTRAINT `pago_ibfk_2` FOREIGN KEY (`id_trabajador`) REFERENCES `trabajadores` (`id_trabajador`),
  ADD CONSTRAINT `pago_ibfk_3` FOREIGN KEY (`id_proyecto`) REFERENCES `proyectos` (`id_proyecto`);

--
-- Constraints for table `pago_maquinaria`
--
ALTER TABLE `pago_maquinaria`
  ADD CONSTRAINT `fk_pm_user_aut` FOREIGN KEY (`id_user_autoriza`) REFERENCES `usuarios` (`id_user`),
  ADD CONSTRAINT `fk_pm_user_gen` FOREIGN KEY (`id_user_genera`) REFERENCES `usuarios` (`id_user`),
  ADD CONSTRAINT `fk_pm_uso` FOREIGN KEY (`id_uso`) REFERENCES `uso_registro` (`id_uso`);

--
-- Constraints for table `pago_nomina`
--
ALTER TABLE `pago_nomina`
  ADD CONSTRAINT `fk_pn_trabajador` FOREIGN KEY (`id_trabajador`) REFERENCES `trabajadores` (`id_trabajador`),
  ADD CONSTRAINT `fk_pn_user_aut` FOREIGN KEY (`id_user_autoriza`) REFERENCES `usuarios` (`id_user`),
  ADD CONSTRAINT `fk_pn_user_gen` FOREIGN KEY (`id_user_genera`) REFERENCES `usuarios` (`id_user`);

--
-- Constraints for table `proyecto_supervisor`
--
ALTER TABLE `proyecto_supervisor`
  ADD CONSTRAINT `proyecto_supervisor_ibfk_1` FOREIGN KEY (`id_proyecto`) REFERENCES `proyectos` (`id_proyecto`),
  ADD CONSTRAINT `proyecto_supervisor_ibfk_2` FOREIGN KEY (`id_trabajador`) REFERENCES `trabajadores` (`id_trabajador`);

--
-- Constraints for table `registro_camiones`
--
ALTER TABLE `registro_camiones`
  ADD CONSTRAINT `registro_camiones_ibfk_1` FOREIGN KEY (`id_uso`) REFERENCES `uso_registro` (`id_uso`),
  ADD CONSTRAINT `registro_camiones_ibfk_2` FOREIGN KEY (`id_material`) REFERENCES `materiales` (`id_material`);

--
-- Constraints for table `trabajadores`
--
ALTER TABLE `trabajadores`
  ADD CONSTRAINT `trabajadores_ibfk_1` FOREIGN KEY (`id_supervisor`) REFERENCES `trabajadores` (`id_trabajador`),
  ADD CONSTRAINT `trabajadores_ibfk_2` FOREIGN KEY (`id_proyect`) REFERENCES `proyectos` (`id_proyecto`);

--
-- Constraints for table `uso_registro`
--
ALTER TABLE `uso_registro`
  ADD CONSTRAINT `uso_registro_ibfk_1` FOREIGN KEY (`id_proyect`) REFERENCES `proyectos` (`id_proyecto`),
  ADD CONSTRAINT `uso_registro_ibfk_2` FOREIGN KEY (`id_trabajador`) REFERENCES `trabajadores` (`id_trabajador`),
  ADD CONSTRAINT `uso_registro_ibfk_3` FOREIGN KEY (`id_maquinaria`) REFERENCES `maquinas` (`id_maquina`);

--
-- Estructura de tabla para la tabla `deducciones`
--

CREATE TABLE IF NOT EXISTS `deducciones` (
  `id_deduccion` int(11) NOT NULL AUTO_INCREMENT,
  `id_trabajador` int(11) NOT NULL,
  `concepto` varchar(255) DEFAULT NULL,
  `monto` decimal(10,2) NOT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'Pendiente',
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  `id_user_registra` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_deduccion`),
  KEY `fk_deduccion_trabajador` (`id_trabajador`),
  CONSTRAINT `fk_deduccion_trabajador` FOREIGN KEY (`id_trabajador`) REFERENCES `trabajadores` (`id_trabajador`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

