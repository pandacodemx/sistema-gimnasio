-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 05-05-2025 a las 23:00:16
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
('Gym Club', './imagenes/680fe750ddc8b.png', 'General Arteaga 279', '3531018899');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `gastos`
--

CREATE TABLE `gastos` (
  `id` int(11) NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(6, '2025-6', 'Alondra Ordaz Zapien', '4361045858', 'General Reyna 580', 28, 0, 1, '', 'IMSS', 'Alondra Guadalupe Zapien', '4361234545', './imagenes/680932e382cfa.png', 'ACTIVO', '2025-04-23 20:35:15', '2025-04-23 20:35:52', '2026-04-24 20:35:52', 4),
(9, '2025-8', 'Israel Pruea', '45461616', 'Gaksadas', 23, 1, 1, 'sadasdsa', 'adasdas', 'dasdsad', '21312312', './imagenes/usuario.png', 'ACTIVO', '2025-04-24 21:00:12', '2025-04-28 13:06:15', '2026-04-29 13:06:15', 4),
(10, '2025-10', 'Monica Dominguez ', '432423423', 'Yandel 65', 23, 0, 0, '', '', 'asdasdasdsa', '12321312', './imagenes/usuario.png', 'ACTIVO', '2025-04-24 21:01:03', '2025-04-28 13:09:12', '2025-05-18 13:09:12', 3),
(11, '2025-11', 'Juan Santiago Urrutia', '4514567898', 'Zapopan Centro', 35, 0, 1, '', 'IMSS', 'Ana Aldama Urrutia', '123458785', './imagenes/usuario.png', 'ACTIVO', '2025-04-28 13:21:12', '2025-04-28 13:36:23', '2025-05-28 13:36:23', 1),
(12, '2025-12', 'Prueba Cliente', '1234578998', 'Prueba Domicilio', 50, 0, 0, '', '', 'asdsadas', '21321312', './imagenes/usuario.png', 'ACTIVO', '2025-04-28 13:56:56', '2025-04-28 13:57:17', '2025-05-18 13:57:17', 3);

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
(17, '0', 0, 1, '2025-04-24 21:53:08', 150.00),
(18, '2025-7', 4, 1, '2025-04-25 00:00:00', 3000.00),
(19, '2025-10', 5, 1, '2025-04-25 00:00:00', 50.00),
(20, '2025-10', 5, 1, '2025-04-25 00:00:00', 50.00),
(21, '2025-8', 5, 1, '2025-04-26 00:00:00', 50.00),
(22, '0', 0, 1, '2025-04-28 20:33:45', 50.00),
(23, '0', 0, 1, '2025-04-28 12:46:53', 50.00),
(24, '2025-8', 0, 1, '2025-04-28 00:00:00', 0.00),
(25, '2025-8', 4, 1, '2025-04-28 00:00:00', 3000.00),
(26, '2025-10', 3, 1, '2025-04-28 00:00:00', 250.00),
(27, '2025-11', 1, 1, '2025-04-28 00:00:00', 300.00),
(28, '2025-12', 3, 1, '2025-05-01 00:00:00', 250.00),
(29, '0', 0, 1, '2025-04-29 08:58:45', 50.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `categoria` varchar(50) DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `creado_en` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `nombre`, `descripcion`, `precio`, `stock`, `categoria`, `imagen`, `creado_en`) VALUES
(5, 'Generic - Formula INS PSYCHOTIC BLACK 35 SERVICIOS/PRE-ENTRENAMIENTO', 'INSANE LABZ PSYCHOTIC BLACK Psychotic Black es la última incorporación a la familia Psychotic de fórmulas pre-entrenamiento de Insane Labz! Es un Pre-entrenamiento de estímulo moderado, que proporciona solo la energía suficiente para hacer el trabajo , es de efecto rápido y suave por los que es conocida toda nuestra línea psicótica.. Solo para atletas de elíte Está hecho para el atleta de élite y no debe ser utilizado por los principiantes.', 450.00, 12, 'Suplementos y nutrición', 'uploads/681913831c3ed.jpeg', '2025-05-05 12:41:18'),
(6, 'MUTANT WHEY 5 LBS CHOCOLATE FUDGE BROWNIE', '0.78 oz de proteína, fabricado con 100% suero de leche puro\n0.56 oz de proteína | Hecho wEAAs y BCAAs | 0.37 oz de EAAs y 0.18 oz de BCAA - Natural Presentith 100% puro suero de leche\nENCIMERA DIGESTIVA | Enzimas digestivas añadidas para optimizar la absorción', 985.00, 5, 'Suplementos y nutrición', 'uploads/68190dd7cb222.jpeg', '2025-05-05 13:13:27'),
(7, 'Botella Shaker para Proteina Gym de 650ml ', 'Con Almacenamiento de Giro y Bloqueo De 3 Capas, 100% Libre de BPA Prueba de Fugas Fitness Deportes (Negro)', 199.00, 30, 'Ropa y accesorios', 'uploads/681910ab9ba92.jpeg', '2025-05-05 13:21:36');

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
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol_permiso`
--

CREATE TABLE `rol_permiso` (
  `id` int(11) NOT NULL,
  `id_rol` int(11) DEFAULT NULL,
  `id_permiso` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `usuario` varchar(255) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `id_rol` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `usuario`, `nombre`, `telefono`, `password`, `id_rol`) VALUES
(1, 'Administrador ', 'Said Alfredo Peña', '3531015780', '$2y$10$FlPveftGbW7L7OGnZadDKOXliinUN968VBAfAycQd8hgj8HDp0R.u', NULL),
(3, 'PacoJR', 'Paco Rodriguez', '3531015888', '$2y$10$4uU2wew3CDte4DI5QZa4j.3N.DpWUUgVJufYAOW8alYF5brrzJ8Ai', NULL),
(5, 'PruebaAdmin', 'Admin Prueba', '123455589', '$2y$10$i6zLqZ4QvZHJti2Idbr3y.YEWxKHYYwtt3nwkf5sTojJ3zeOUVcWa', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id` bigint(20) NOT NULL,
  `id_miembro` bigint(20) DEFAULT NULL,
  `total` decimal(10,2) NOT NULL,
  `fecha` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(17, NULL, 1, NULL, '2025-04-24 21:53:08'),
(18, 1, 1, 1, '2025-04-26 00:36:51'),
(19, 10, 1, 5, '2025-04-26 00:39:08'),
(20, 7, 1, 4, '2025-04-26 00:39:47'),
(21, 5, 5, 4, '2025-04-28 20:32:05'),
(22, 1, 5, 1, '2025-04-28 20:32:09'),
(23, 4, 1, 4, '2025-04-28 20:33:20'),
(24, NULL, 1, NULL, '2025-04-28 20:33:45'),
(25, 6, 1, 4, '2025-04-28 20:35:47'),
(26, NULL, 1, NULL, '2025-04-28 12:46:53'),
(27, 3, 1, 2, '2025-04-28 12:47:20'),
(28, 7, 1, 4, '2025-04-28 13:04:44'),
(29, 11, 1, 1, '2025-04-28 13:36:41'),
(30, 12, 1, 3, '2025-04-28 13:58:08'),
(31, NULL, 1, NULL, '2025-04-29 08:58:45'),
(32, 5, 1, 4, '2025-04-29 09:34:33');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `gastos`
--
ALTER TABLE `gastos`
  ADD PRIMARY KEY (`id`);

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
-- Indices de la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `recordatorios_enviados`
--
ALTER TABLE `recordatorios_enviados`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `rol_permiso`
--
ALTER TABLE `rol_permiso`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_rol` (`id_rol`),
  ADD KEY `id_permiso` (`id_permiso`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_usuarios_roles` (`id_rol`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
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
-- AUTO_INCREMENT de la tabla `gastos`
--
ALTER TABLE `gastos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `membresias`
--
ALTER TABLE `membresias`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `miembros`
--
ALTER TABLE `miembros`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `recordatorios_enviados`
--
ALTER TABLE `recordatorios_enviados`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `rol_permiso`
--
ALTER TABLE `rol_permiso`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `visitas`
--
ALTER TABLE `visitas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `rol_permiso`
--
ALTER TABLE `rol_permiso`
  ADD CONSTRAINT `rol_permiso_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id`),
  ADD CONSTRAINT `rol_permiso_ibfk_2` FOREIGN KEY (`id_permiso`) REFERENCES `permisos` (`id`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuarios_roles` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
