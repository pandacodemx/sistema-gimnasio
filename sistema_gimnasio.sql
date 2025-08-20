-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 20-08-2025 a las 23:00:50
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
('Bonito GYM', './imagenes/682627d867412.png', 'Direccion Gimnasio', '1111111111');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clases`
--

CREATE TABLE `clases` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `duracion_min` int(11) DEFAULT 60,
  `nivel_dificultad` enum('principiante','intermedio','avanzado') DEFAULT NULL,
  `color_calendario` varchar(7) DEFAULT '#1976D2',
  `imagen_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clases`
--

INSERT INTO `clases` (`id`, `nombre`, `descripcion`, `duracion_min`, `nivel_dificultad`, `color_calendario`, `imagen_url`) VALUES
(1, 'Prueba Clse', 'Clase blabla', NULL, 'principiante', '#1976D2', NULL),
(2, 'Clase Pilates asasa', 'asdasdas', 60, 'intermedio', '#1976D2', NULL),
(3, 'Clase Yoga', 'Clase Yoga ', 120, 'intermedio', '#D219C4', NULL),
(4, 'Clase Spinning', 'Clase spinning impartida por tal tal', 60, 'avanzado', '#BED219', NULL);

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
-- Estructura de tabla para la tabla `horarios_clases`
--

CREATE TABLE `horarios_clases` (
  `id` int(11) NOT NULL,
  `id_clase` int(11) NOT NULL,
  `id_instructor` int(11) NOT NULL,
  `id_sala` int(11) NOT NULL,
  `fecha_hora_inicio` datetime NOT NULL,
  `fecha_hora_fin` datetime NOT NULL,
  `repeticion` enum('ninguna','diaria','semanal','mensual') DEFAULT 'ninguna',
  `max_participantes` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `horarios_clases`
--

INSERT INTO `horarios_clases` (`id`, `id_clase`, `id_instructor`, `id_sala`, `fecha_hora_inicio`, `fecha_hora_fin`, `repeticion`, `max_participantes`) VALUES
(1, 3, 1, 1, '2025-08-20 14:00:00', '2025-08-20 16:00:00', 'semanal', 20),
(2, 2, 2, 1, '2025-08-20 13:01:00', '2025-08-20 14:01:00', 'semanal', 20),
(3, 4, 3, 2, '2025-08-20 17:00:00', '2025-08-20 18:00:00', 'semanal', 5),
(9, 3, 3, 1, '2025-08-21 10:00:00', '2025-08-21 12:00:00', 'ninguna', 20),
(10, 4, 2, 2, '2025-08-21 10:00:00', '2025-08-21 11:00:00', 'semanal', 5),
(11, 4, 2, 2, '2025-08-22 17:00:00', '2025-08-22 18:00:00', 'diaria', 5),
(14, 4, 2, 2, '2025-08-25 07:00:00', '2025-08-25 08:00:00', 'ninguna', 5),
(15, 4, 2, 2, '2025-08-21 09:00:00', '2025-08-21 10:00:00', 'semanal', 5),
(16, 4, 2, 2, '2025-08-28 09:00:00', '2025-08-28 10:00:00', 'semanal', 5),
(17, 4, 2, 2, '2025-09-04 09:00:00', '2025-09-04 10:00:00', 'semanal', 5),
(18, 4, 2, 2, '2025-09-11 09:00:00', '2025-09-11 10:00:00', 'semanal', 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `instructores`
--

CREATE TABLE `instructores` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `especialidad` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `instructores`
--

INSERT INTO `instructores` (`id`, `nombre`, `especialidad`, `telefono`, `email`) VALUES
(1, 'Said Alfredo Peña Nava', 'Yoga', '3531015780', 'nava.saidalfredo@gmail.com'),
(2, 'Adriana Rodriguez Chavez', 'Crossfit', '1231234488', 'adriana@correo.com'),
(3, 'Monica Yadira Zambrano', 'Spinning', '123456789', 'monicaspi@gmail.com');

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
(1, 'Semestral', 183, 500.00),
(2, 'Mensual Hombre', 30, 500.00),
(3, 'Mensual Mujer', 30, 500.00),
(4, 'Mensual Pareja / Estudiante', 30, 500.00),
(5, 'Semanal', 7, 500.00);

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
  `idMembresia` bigint(20) DEFAULT NULL,
  `afiliacion` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `miembros`
--

INSERT INTO `miembros` (`id`, `matricula`, `nombre`, `telefono`, `direccion`, `edad`, `sufreEnfermedad`, `tieneSeguro`, `enfermedad`, `institucion`, `nombreContacto`, `telefonoContacto`, `imagen`, `estado`, `fechaRegistro`, `fechaInicio`, `fechaFin`, `idMembresia`, `afiliacion`) VALUES
(14, '2025-1', 'Said1', '12312312312', 'dasdasdas', 18, 0, 0, '', '', 'asdasdasd', '1231212312312', './imagenes/usuario.png', 'VENCIDO', '2025-05-21 12:42:55', '2025-07-16 11:40:33', '2025-08-15 11:40:33', 2, ''),
(15, '2025-15', 'fdsfsdfsdfsd', '324324324324', 'dfdsfsdfsdfsd', 18, 0, 0, '', '', 'sdfsdfsd', '32432423', './imagenes/usuario.png', 'VENCIDO', '2025-05-21 12:43:17', NULL, NULL, NULL, ''),
(16, '2025-16', 'asdasdasdas', '12312312312', 'sadasdasda', 18, 0, 0, '', '', 'sadasdas', '21312312', './imagenes/usuario.png', 'ACTIVO', '2025-05-21 12:49:08', '2025-07-27 11:52:26', '2025-08-26 11:52:26', 4, ''),
(17, '2025-17', 'adsdasdasd', '12312321', 'sdadsadas', 18, 0, 0, '', '', 'asdasdas', '21312312', './imagenes/usuario.png', 'ACTIVO', '2025-07-22 09:03:28', '2025-08-20 12:21:49', '2025-08-27 12:21:49', 5, ''),
(18, '2025-18', 'Prueba Fech', '21312321', 'asddsa', 18, 0, 0, '', '', 'dasdas', '12321', './imagenes/usuario.png', 'VENCIDO', '2025-08-11 09:56:00', NULL, NULL, NULL, ''),
(19, '2025-19', 'Prueba Valeria', '123456789', 'Valeria', 18, 0, 0, '', '', 'Baleria', '1234581248', './imagenes/usuario.png', 'VENCIDO', '2025-08-11 11:42:51', NULL, NULL, NULL, '');

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
(1, '0', 0, 1, '2025-05-15 12:57:21', 50.00),
(2, '2025-1', 5, 1, '2025-05-15 00:00:00', 500.00),
(3, '2025-2', 3, 1, '2025-04-05 00:00:00', 500.00),
(4, '2025-3', 1, 1, '2025-07-03 00:00:00', 500.00),
(5, '2025-4', 3, 1, '2025-04-04 00:00:00', 500.00),
(6, '2025-5', 3, 1, '2025-05-01 00:00:00', 500.00),
(7, '2025-4', 3, 1, '2025-04-03 00:00:00', 500.00),
(8, '2025-7', 0, 4, '2025-05-21 00:00:00', 0.00),
(9, '2025-8', 3, 4, '2025-05-22 00:00:00', 500.00),
(10, '2025-9', 4, 4, '2025-05-20 18:07:51', 500.00),
(11, '2025-10', 3, 4, '2025-05-20 18:08:38', 500.00),
(12, '2025-11', 0, 4, '2025-05-20 12:13:23', 0.00),
(13, '2025-12', 0, 4, '2025-04-30 12:15:40', 0.00),
(14, '2025-11', 0, 4, '2025-05-20 12:16:00', 0.00),
(15, '2025-11', 0, 4, '2025-05-01 12:17:19', 0.00),
(16, '2025-11', 0, 4, '2025-05-20 12:19:34', 0.00),
(17, '2025-11', 0, 4, '2025-05-20 12:19:42', 0.00),
(18, '2025-11', 0, 4, '2025-05-20 12:20:42', 0.00),
(19, '2025-11', 0, 4, '2025-05-20 12:21:02', 0.00),
(20, '2025-11', 0, 4, '2025-05-20 12:23:46', 0.00),
(21, '2025-11', 0, 4, '2025-05-20 12:26:39', 0.00),
(22, '2025-11', 1, 4, '2025-05-20 12:26:49', 500.00),
(23, '2025-4', 0, 4, '2025-05-20 12:27:07', 0.00),
(24, '2025-4', 0, 4, '2025-05-20 12:31:12', 0.00),
(25, '2025-12', 0, 4, '2025-05-21 12:31:31', 0.00),
(26, '2025-7', 0, 4, '2025-05-20 12:31:52', 0.00),
(27, '2025-12', 5, 4, '2025-05-20 12:32:14', 500.00),
(28, '2025-4', 0, 4, '2025-05-20 12:35:29', 0.00),
(29, '2025-4', 0, 4, '2025-05-20 12:35:54', 0.00),
(30, '2025-4', 0, 4, '2025-05-20 12:39:05', 0.00),
(31, '2025-4', 0, 4, '2025-05-20 12:39:18', 0.00),
(32, '2025-4', 0, 4, '2025-05-21 12:41:00', 0.00),
(33, '2025-7', 2, 4, '2025-05-01 12:41:27', 500.00),
(34, '2025-4', 2, 4, '2025-05-21 12:41:44', 500.00),
(35, '2025-13', 1, 4, '2025-05-21 12:42:12', 500.00),
(36, '2025-1', 2, 4, '2025-05-21 12:43:04', 500.00),
(37, '2025-15', 4, 4, '2025-05-14 12:43:30', 500.00),
(38, '2025-16', 5, 4, '2025-05-21 12:49:19', 500.00),
(39, '0', 0, 4, '2025-05-26 15:37:48', 50.00),
(40, '0', 0, 1, '2025-05-26 15:39:44', 50.00),
(41, '2025-1', 2, 4, '2025-07-16 11:40:33', 500.00),
(42, '2025-15', 3, 1, '2025-07-21 11:50:42', 500.00),
(43, '0', 0, 1, '2025-07-21 11:51:21', 50.00),
(44, '2025-16', 4, 1, '2025-07-27 11:52:26', 500.00),
(45, '2025-17', 2, 1, '2025-07-22 09:29:51', 500.00),
(46, '0', 0, 1, '2025-07-22 09:30:02', 50.00),
(47, '0', 0, 2, '2025-07-22 10:02:37', 70.00),
(48, '0', 0, 1, '2025-07-29 10:06:45', 50.00),
(49, '2025-18', 5, 1, '2025-08-11 10:17:20', 500.00),
(50, '0', 0, 1, '2025-08-11 11:39:00', 50.00),
(51, '2025-19', 5, 1, '2025-08-04 11:43:25', 500.00),
(52, '2025-19', 5, 1, '2025-08-11 13:37:26', 500.00),
(53, '2025-17', 5, 1, '2025-08-20 12:21:49', 500.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `clave` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `permisos`
--

INSERT INTO `permisos` (`id`, `nombre`, `clave`) VALUES
(1, 'Gestión de usuarios', 'gestion_usuarios'),
(2, 'Gestión de miembros', 'gestion_miembros');

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
  `creado_en` datetime DEFAULT current_timestamp(),
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
-- Estructura de tabla para la tabla `reservas_clases`
--

CREATE TABLE `reservas_clases` (
  `id` int(11) NOT NULL,
  `id_horario` int(11) NOT NULL,
  `fecha_reserva` timestamp NOT NULL DEFAULT current_timestamp(),
  `estado` enum('confirmada','cancelada','asistio','no_asistio') DEFAULT 'confirmada',
  `id_miembro` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `nombre`, `descripcion`) VALUES
(1, 'Administrador', ''),
(2, 'Entrenador', ''),
(3, 'Recepcionista', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol_permisos`
--

CREATE TABLE `rol_permisos` (
  `id_rol` int(11) NOT NULL,
  `id_permiso` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rol_permisos`
--

INSERT INTO `rol_permisos` (`id_rol`, `id_permiso`) VALUES
(1, 1),
(1, 2),
(2, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `salas`
--

CREATE TABLE `salas` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `capacidad` int(11) DEFAULT NULL,
  `equipamiento` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `salas`
--

INSERT INTO `salas` (`id`, `nombre`, `capacidad`, `equipamiento`) VALUES
(1, 'Sala Yoga', 25, 'Tapetes, balones, maquina correr'),
(2, 'Sala Spinning', 5, 'Bicicletas, tapetes, cronometros');

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
  `id_rol` int(11) DEFAULT NULL,
  `rol` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `usuario`, `nombre`, `telefono`, `password`, `id_rol`, `rol`) VALUES
(1, 'Administrador ', 'BonitoGym1', '1111111111', '$2y$10$qHNkJxvoC3chEo6sVaXvIeuhFa0HvN9jo.sv46j/z.nOIz9PpABXK', 1, 'admin'),
(2, 'Mostrador', 'Mostrador Bonito gym', '1111111111', '$2y$10$.V8WhQntelwdRyT7ypYMl.1hxof7qa7NGavT77n9lTGo3yhVqxkQq', NULL, 'empleado'),
(7, 'Prueba13', 'Prueba13', '12312321312', '$2y$10$t6G3d82MITFzmuplpuQZM.Mjdepq4Z227/DZzp1e2Gli6ZsHDkiX.', NULL, ''),
(8, 'Prueba15', 'Prueba15', '123123', '$2y$10$m7YbLXzf9jwaa7VCBOKHhO5DYwk8yDpVXBHkdmpInPF4cCHPX/EOS', NULL, ''),
(9, 'Prueba14', 'Prueba14', '123123', '$2y$10$GZFciQGM3x42Q7POmSxSe.strw54Zi.1GjuOKSg5KR7uwuEmoL6wa', NULL, ''),
(10, 'Pruba18', 'Pruba18', '2312321312', '$2y$10$9ItHtvh.BLKiD/zMPhvnvu.BePifCCM2uP5.koYK5r/8aPtRxbxoa', NULL, 'empleado'),
(11, 'Prueba123', 'Prueba123', '12321321321', '$2y$10$7FpVsFsXWuthsqFqMxbDMuLRyGCiokmbXxVLqY5Lh2FY1LV5dzsC6', NULL, '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id` int(11) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas_productos`
--

CREATE TABLE `ventas_productos` (
  `id` int(11) NOT NULL,
  `venta_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
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
(1, NULL, 1, NULL, '2025-05-15 12:57:21'),
(2, 14, 4, 2, '2025-05-21 12:50:29'),
(3, NULL, 4, NULL, '2025-05-26 15:37:48'),
(4, 14, 4, 2, '2025-05-26 15:38:08'),
(5, 16, 1, 5, '2025-05-26 15:39:23'),
(6, NULL, 1, NULL, '2025-05-26 15:39:44'),
(7, 14, 4, 2, '2025-06-19 09:48:52'),
(8, NULL, 1, NULL, '2025-07-21 11:51:21'),
(9, NULL, 1, NULL, '2025-07-22 09:30:02'),
(10, 16, 1, 4, '2025-07-22 09:31:45'),
(11, 14, 1, 2, '2025-07-22 09:38:55'),
(12, NULL, 2, NULL, '2025-07-22 10:02:37'),
(13, 14, 2, 2, '2025-07-22 11:01:43'),
(14, 14, 1, 2, '2025-07-24 11:55:27'),
(15, NULL, 1, NULL, '2025-07-29 10:06:45'),
(16, 14, 1, 2, '2025-07-29 12:38:35'),
(17, 16, 1, 4, '2025-07-29 12:38:47'),
(18, NULL, 1, NULL, '2025-08-11 11:39:00'),
(19, 16, 1, 4, '2025-08-11 11:39:11'),
(20, 19, 1, 5, '2025-08-11 11:43:48');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `clases`
--
ALTER TABLE `clases`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `gastos`
--
ALTER TABLE `gastos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `horarios_clases`
--
ALTER TABLE `horarios_clases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_clase` (`id_clase`),
  ADD KEY `id_instructor` (`id_instructor`),
  ADD KEY `id_sala` (`id_sala`);

--
-- Indices de la tabla `instructores`
--
ALTER TABLE `instructores`
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
-- Indices de la tabla `reservas_clases`
--
ALTER TABLE `reservas_clases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_horario` (`id_horario`),
  ADD KEY `fk_miembro` (`id_miembro`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `rol_permisos`
--
ALTER TABLE `rol_permisos`
  ADD PRIMARY KEY (`id_rol`,`id_permiso`),
  ADD KEY `id_permiso` (`id_permiso`);

--
-- Indices de la tabla `salas`
--
ALTER TABLE `salas`
  ADD PRIMARY KEY (`id`);

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
-- Indices de la tabla `ventas_productos`
--
ALTER TABLE `ventas_productos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `venta_id` (`venta_id`),
  ADD KEY `producto_id` (`producto_id`);

--
-- Indices de la tabla `visitas`
--
ALTER TABLE `visitas`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `clases`
--
ALTER TABLE `clases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `gastos`
--
ALTER TABLE `gastos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `horarios_clases`
--
ALTER TABLE `horarios_clases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `instructores`
--
ALTER TABLE `instructores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `membresias`
--
ALTER TABLE `membresias`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `miembros`
--
ALTER TABLE `miembros`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `recordatorios_enviados`
--
ALTER TABLE `recordatorios_enviados`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `reservas_clases`
--
ALTER TABLE `reservas_clases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `salas`
--
ALTER TABLE `salas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT de la tabla `ventas_productos`
--
ALTER TABLE `ventas_productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `visitas`
--
ALTER TABLE `visitas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `horarios_clases`
--
ALTER TABLE `horarios_clases`
  ADD CONSTRAINT `horarios_clases_ibfk_1` FOREIGN KEY (`id_clase`) REFERENCES `clases` (`id`),
  ADD CONSTRAINT `horarios_clases_ibfk_2` FOREIGN KEY (`id_instructor`) REFERENCES `instructores` (`id`),
  ADD CONSTRAINT `horarios_clases_ibfk_3` FOREIGN KEY (`id_sala`) REFERENCES `salas` (`id`);

--
-- Filtros para la tabla `reservas_clases`
--
ALTER TABLE `reservas_clases`
  ADD CONSTRAINT `fk_horario` FOREIGN KEY (`id_horario`) REFERENCES `horarios_clases` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_miembro` FOREIGN KEY (`id_miembro`) REFERENCES `miembros` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `rol_permisos`
--
ALTER TABLE `rol_permisos`
  ADD CONSTRAINT `rol_permisos_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id`),
  ADD CONSTRAINT `rol_permisos_ibfk_2` FOREIGN KEY (`id_permiso`) REFERENCES `permisos` (`id`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuarios_roles` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id`);

--
-- Filtros para la tabla `ventas_productos`
--
ALTER TABLE `ventas_productos`
  ADD CONSTRAINT `ventas_productos_ibfk_1` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`),
  ADD CONSTRAINT `ventas_productos_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
