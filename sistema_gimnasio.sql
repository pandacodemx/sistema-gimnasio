-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 26-04-2025 a las 00:09:24
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sistema_gimnasio`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ajustes`
--

CREATE TABLE `ajustes` (
  `nombre` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ajustes`
--

INSERT INTO `ajustes` (`nombre`, `logo`, `direccion`, `telefono`) VALUES
('Fitness Club', './imagenes/680944357c5be.png', 'General Arteaga 279', '3531018899');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `membresias`
--

CREATE TABLE `membresias` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `duracion` int(6) NOT NULL,
  `precio` decimal(6,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `membresias`
--

INSERT INTO `membresias` (`id`, `nombre`, `duracion`, `precio`) VALUES
(1, 'Oro', 30, 300.00),
(2, 'Bronce', 10, 120.00),
(3, 'Plata', 20, 250.00),
(4, 'Premium', 366, 3000.00),
(5, 'Regular', 1, 50.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `miembros`
--

CREATE TABLE `miembros` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `matricula` varchar(50) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `direccion` varchar(255) NOT NULL,
  `edad` tinyint(4) NOT NULL,
  `sufreEnfermedad` tinyint(1) DEFAULT NULL,
  `tieneSeguro` tinyint(1) DEFAULT NULL,
  `enfermedad` varchar(255) DEFAULT NULL,
  `institucion` varchar(255) DEFAULT NULL,
  `nombreContacto` varchar(255) NOT NULL,
  `telefonoContacto` varchar(255) NOT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `estado` enum('ACTIVO','VENCIDO') DEFAULT NULL,
  `fechaRegistro` datetime NOT NULL,
  `fechaInicio` datetime DEFAULT NULL,
  `fechaFin` datetime DEFAULT NULL,
  `idMembresia` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `miembros`
--

INSERT INTO `miembros` (`id`, `matricula`, `nombre`, `telefono`, `direccion`, `edad`, `sufreEnfermedad`, `tieneSeguro`, `enfermedad`, `institucion`, `nombreContacto`, `telefonoContacto`, `imagen`, `estado`, `fechaRegistro`, `fechaInicio`, `fechaFin`, `idMembresia`) VALUES
(1, '2025-1', 'Said Alfredo Peña ', '3531015780', 'Diego Jose Abad 85 D-7', 30, 0, 1, '', 'IMSS', 'Ma de Lourdes Nava', '3531015780', './imagenes/680803de07cb7.png', 'ACTIVO', '2025-04-11 18:25:23', '2025-04-11 19:40:00', '2025-05-12 19:40:00', 1),
(2, '2025-2', 'Juan Dominguez Urrutia', '4511237888', 'Blvd. Benito Juarez 78', 30, 1, 1, 'Diabetes ', 'ISSTE', 'Juana Dominguez Urrutia', '4511231122', './imagenes/6807c9ad44e56.png', 'ACTIVO', '2025-04-22 18:54:05', '2025-04-22 18:55:30', '2025-05-23 18:55:30', 1),
(3, '2025-3', 'Diana Almada ', '3531018888', 'Villa Bonita 278', 23, 0, 1, '', 'IMSS', 'Valeria Dominguez', '101445580', './imagenes/6807e4ee38622.png', 'ACTIVO', '2025-04-22 20:50:22', '2025-04-22 20:53:03', '2025-05-07 20:53:03', 2),
(4, '2025-4', 'Aurora Antonia Zendejas', '1501028785', 'Mario Moreno 250', 45, 1, 0, 'Asma', 'IMSS', 'Pablo Enrique Escobedo', '314789852', './imagenes/68081533bc9a6.png', 'ACTIVO', '2025-04-23 00:16:19', '2025-04-23 20:15:18', '2026-04-24 20:15:18', 4),
(5, '2025-5', 'Angel Gutierres Orozco', '1451223585', 'Morelos # 75', 30, 0, 0, '', '', 'Ana Maria Gutierrez ', '1454585570', './imagenes/680930516cac6.png', 'ACTIVO', '2025-04-23 20:24:17', '2025-04-23 20:25:07', '2026-04-24 20:25:07', 4),
(6, '2025-6', 'Alondra Ordaz Zapien', '4361045858', 'General Reyna 580', 28, 0, 0, '', '', 'Alondra Guadalupe Zapien', '4361234545', './imagenes/680932e382cfa.png', 'ACTIVO', '2025-04-23 20:35:15', '2025-04-23 20:35:52', '2026-04-24 20:35:52', 4),
(7, '2025-7', 'Prueba WS', '523531015780', 'A', 30, 0, 0, '', '', 'asdasdas', '12312312', './imagenes/usuario.png', 'ACTIVO', '2025-04-23 23:48:15', '2025-04-23 23:48:21', '2025-04-24 23:48:21', 5),
(9, '2025-8', 'Israel Pruea', '45461616', 'Gaksadas', 23, 1, 1, 'sadasdsa', 'adasdas', 'dasdsad', '21312312', './imagenes/usuario.png', 'ACTIVO', '2025-04-24 21:00:12', '2025-04-24 21:00:17', '2025-04-25 21:00:17', 5),
(10, '2025-10', 'wserdfdsfsdf', '432423423', 'dfsdfdsfdsf', 23, 0, 0, '', '', 'asdasdasdsa', '12321312', './imagenes/usuario.png', 'VENCIDO', '2025-04-24 21:01:03', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `matricula` varchar(50) NOT NULL,
  `idMembresia` bigint(20) NOT NULL,
  `idUsuario` bigint(20) NOT NULL,
  `fecha` datetime NOT NULL,
  `monto` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pagos`
--

INSERT INTO `pagos` (`id`, `matricula`, `idMembresia`, `idUsuario`, `fecha`, `monto`) VALUES
(1, '0', 0, 1, '2025-04-11 18:24:07', 0.00),
(2, '2025-1', 1, 1, '2025-04-11 00:00:00', 750.00),
(3, '0', 0, 1, '2025-04-11 19:40:13', 0.00),
(4, '0', 0, 1, '2025-04-11 19:43:17', 50.00),
(5, '2025-2', 1, 1, '2025-04-22 00:00:00', 750.00),
(6, '0', 0, 1, '2025-04-22 20:52:12', 0.00),
(7, '2025-3', 2, 1, '2025-04-22 00:00:00', 250.00),
(8, '0', 0, 1, '2025-04-23 00:17:35', 25.00),
(9, '2025-4', 4, 1, '2025-04-23 00:00:00', 999.99),
(10, '2025-5', 4, 1, '2025-04-23 00:00:00', 999.99),
(11, '2025-6', 4, 1, '2025-04-23 00:00:00', 3000.00),
(12, '2025-7', 5, 1, '2025-04-23 00:00:00', 50.00),
(13, '2025-8', 5, 1, '2025-04-24 00:00:00', 50.00),
(14, '0', 0, 1, '2025-04-24 21:15:57', 50.00),
(15, '0', 0, 1, '2025-04-24 21:16:30', 50.00),
(16, '0', 0, 1, '2025-04-24 21:52:48', 0.00),
(17, '0', 0, 1, '2025-04-24 21:53:08', 150.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recordatorios_enviados`
--

CREATE TABLE `recordatorios_enviados` (
  `id` int(11) NOT NULL,
  `id_miembro` int(11) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `fecha_envio` datetime DEFAULT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `mensaje` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `recordatorios_enviados`
--

INSERT INTO `recordatorios_enviados` (`id`, `id_miembro`, `nombre`, `telefono`, `fecha_envio`, `fecha_vencimiento`, `mensaje`) VALUES
(1, 7, 'Prueba WS', '523531015780', '2025-04-23 16:20:10', '2025-04-24', 'Hola Prueba WS 👋. Te recordamos que tu membresía vence el día 24/04/2025. ¡Esperamos verte pronto en el gimnasio! 💪');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `usuario` varchar(255) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `usuario`, `nombre`, `telefono`, `password`) VALUES
(1, 'Administrador ', 'Said Alfredo Peña', '3531015780', '$2y$10$1AWMiPubhyqAlgjo.u6sAO7A/UPy94Zy7isgnl51wceVvqD4A7Xem');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `visitas`
--

CREATE TABLE `visitas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `idMiembro` bigint(20) DEFAULT NULL,
  `idUsuario` bigint(20) NOT NULL,
  `idMembresia` bigint(20) DEFAULT NULL,
  `fecha` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `visitas`
--

INSERT INTO `visitas` (`id`, `idMiembro`, `idUsuario`, `idMembresia`, `fecha`) VALUES
(1, NULL, 1, NULL, '2025-04-11 18:24:07'),
(2, NULL, 1, NULL, '2025-04-11 19:40:13'),
(3, 1, 1, 1, '2025-04-11 19:42:18'),
(4, NULL, 1, NULL, '2025-04-11 19:43:17'),
(5, 2, 1, 1, '2025-04-22 18:56:24'),
(6, NULL, 1, NULL, '2025-04-22 20:52:12'),
(7, 1, 1, 1, '2025-04-22 23:56:51'),
(8, NULL, 1, NULL, '2025-04-23 00:17:35'),
(9, 1, 1, 1, '2025-04-23 00:28:47'),
(10, 3, 1, 2, '2025-04-23 17:39:43'),
(11, 6, 1, 4, '2025-04-23 21:09:11'),
(12, 6, 1, 4, '2025-04-23 21:53:03'),
(13, 3, 1, 2, '2025-04-24 00:16:29'),
(14, NULL, 1, NULL, '2025-04-24 21:15:56'),
(15, NULL, 1, NULL, '2025-04-24 21:16:28'),
(16, NULL, 1, NULL, '2025-04-24 21:52:48'),
(17, NULL, 1, NULL, '2025-04-24 21:53:08');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `membresias`
--
ALTER TABLE `membresias`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `miembros`
--
ALTER TABLE `miembros`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `recordatorios_enviados`
--
ALTER TABLE `recordatorios_enviados`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `visitas`
--
ALTER TABLE `visitas`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `membresias`
--
ALTER TABLE `membresias`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `miembros`
--
ALTER TABLE `miembros`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `recordatorios_enviados`
--
ALTER TABLE `recordatorios_enviados`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `visitas`
--
ALTER TABLE `visitas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
