-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 03-09-2025 a las 23:50:21
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
('Gimnasio Nombre', './imagenes/68a78e74c1602.png', 'Direccion Gimnasio #1', '123456789');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias_ejercicios`
--

CREATE TABLE `categorias_ejercicios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `icono` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categorias_ejercicios`
--

INSERT INTO `categorias_ejercicios` (`id`, `nombre`, `descripcion`, `icono`) VALUES
(1, 'Pierna', 'Ejercicios para pierna', 'mdi-run'),
(2, 'Espalda', 'Ejercicios para espalda', 'mdi-arm-flex');

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
(4, 'Clase Spinning', 'Clase spinning impartida por tal tal', 60, 'avanzado', '#BED219', NULL),
(5, 'Clase Spinning Avanzada', '', 180, 'avanzado', '#BA4903', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ejercicios`
--

CREATE TABLE `ejercicios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `instrucciones` text DEFAULT NULL,
  `nivel_dificultad` varchar(100) NOT NULL,
  `equipamiento` varchar(100) NOT NULL,
  `categoria_id` int(11) DEFAULT NULL,
  `imagen_url` varchar(255) DEFAULT NULL,
  `video_url` varchar(255) DEFAULT NULL,
  `met` smallint(6) DEFAULT NULL COMMENT 'Equivalentes metabólicos'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ejercicios`
--

INSERT INTO `ejercicios` (`id`, `nombre`, `descripcion`, `instrucciones`, `nivel_dificultad`, `equipamiento`, `categoria_id`, `imagen_url`, `video_url`, `met`) VALUES
(1, 'Sentadillas', 'Ejercicio fundamental para piernas y glúteos', 'Pies al ancho de hombros, bajar flexionando rodillas', 'principiante', 'peso corporal', 1, 'https://hips.hearstapps.com/hmg-prod/images/cyclistsquats-1676548052.jpeg?resize=980:*', 'https://www.youtube.com/watch?v=80dKqPruEMo', 5),
(2, 'Peso Muerto', 'Este ejercicio es considerado como el mejor para darle grosor a la espalda, proporcionando una gran estimulación del músculo erector de la columna.', 'Posición inicial:\n\nColócate de pie frente a la barra con los pies separados el ancho de los hombros. Contrae los abdominales, saca pecho manteniendo la espalda recta y flexiona las rodillas hasta que puedas llegar a la barra.\nCoge la barra con un agarre prono (los pulgares uno frente al otro), siendo ligeramente más ancho que la anchura de los hombro.\n\nSeries y repeticiones: Realiza 3-4 series de 6-8 repeticiones.', 'intermedio', 'barra', 2, 'https://hips.hearstapps.com/hmg-prod/images/barbell-deadlift-66e96571889ed.jpg?resize=980:*', 'https://www.youtube.com/watch?v=NRg1QLi26Ws&embeds_referring_euri=https%3A%2F%2Fwww.myprotein.es%2F&source_ve_path=OTY3MTQ', NULL);

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
(18, 4, 2, 2, '2025-09-11 09:00:00', '2025-09-11 10:00:00', 'semanal', 5),
(19, 5, 2, 2, '2025-08-22 10:30:00', '2025-08-22 13:30:00', 'mensual', 5),
(20, 5, 2, 2, '2025-09-22 10:30:00', '2025-09-22 13:30:00', 'mensual', 5),
(21, 3, 4, 4, '2025-09-06 09:00:00', '2025-09-06 11:00:00', '', 10),
(22, 3, 4, 4, '2025-09-13 09:00:00', '2025-09-13 11:00:00', '', 10),
(23, 3, 4, 4, '2025-09-20 09:00:00', '2025-09-20 11:00:00', '', 10),
(24, 3, 4, 4, '2025-09-27 09:00:00', '2025-09-27 11:00:00', '', 10),
(25, 5, 3, 2, '2025-09-05 10:30:00', '2025-09-05 13:30:00', 'semanal', 20),
(26, 5, 3, 2, '2025-09-12 10:30:00', '2025-09-12 13:30:00', 'semanal', 20),
(27, 4, 4, 2, '2025-09-02 10:30:00', '2025-09-02 11:30:00', 'ninguna', 30),
(28, 2, 2, 3, '2025-09-02 10:30:00', '2025-09-02 11:30:00', 'ninguna', 20);

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
(3, 'Monica Yadira Zambrano', 'Spinning', '123456789', 'monicaspi@gmail.com'),
(4, 'Instructor Prueba', 'Prueba', '12334568789', 'prueba@correo.com');

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
(14, '2025-1', 'Said1', '12312312312', 'dasdasdas', 18, 0, 0, '', '', 'asdasdasd', '1231212312312', './imagenes/68b75a63c06af.png', 'ACTIVO', '2025-05-21 12:42:55', '2025-09-08 15:38:55', '2025-09-15 15:38:55', 5, ''),
(15, '2025-15', 'Valeria Manzo', '324324324324', 'dfdsfsdfsdfsd', 18, 0, 0, '', '', 'sdfsdfsd', '32432423', './imagenes/usuario.png', 'ACTIVO', '2025-05-21 12:43:17', '2025-09-08 09:12:17', '2025-10-08 09:12:17', 2, ''),
(16, '2025-16', 'asdasdasdas', '12312312312', 'sadasdasda', 18, 0, 0, '', '', 'sadasdas', '21312312', './imagenes/usuario.png', 'ACTIVO', '2025-05-21 12:49:08', '2025-08-26 10:53:26', '2025-09-25 10:53:26', 2, ''),
(17, '2025-17', 'Jose Armando Baños', '12312321', 'sdadsadas', 18, 0, 0, '', '', 'asdasdas', '21312312', './imagenes/usuario.png', 'ACTIVO', '2025-07-22 09:03:28', '2025-09-03 09:45:26', '2026-03-05 09:45:26', 1, ''),
(18, '2025-18', 'Martin Dom Salcedo', '21312321', 'asddsa', 18, 0, 0, '', '', 'dasdas', '12321', './imagenes/usuario.png', 'ACTIVO', '2025-08-11 09:56:00', '2025-09-08 09:45:38', '2026-03-10 09:45:38', 1, ''),
(19, '2025-19', 'Prueba Valeria', '123456789', 'Valeria', 18, 0, 0, '', '', 'Baleria', '1234581248', './imagenes/usuario.png', 'ACTIVO', '2025-08-11 11:42:51', '2025-09-08 09:26:55', '2026-03-10 09:26:55', 1, '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `matricula` varchar(50) NOT NULL,
  `idMembresia` bigint(20) DEFAULT NULL,
  `id_clase` int(11) DEFAULT NULL,
  `id_horario` int(11) DEFAULT NULL,
  `idUsuario` bigint(20) NOT NULL,
  `fecha` datetime NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `tipo` enum('membresia','clase') NOT NULL DEFAULT 'membresia'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pagos`
--

INSERT INTO `pagos` (`id`, `matricula`, `idMembresia`, `id_clase`, `id_horario`, `idUsuario`, `fecha`, `monto`, `tipo`) VALUES
(1, '0', 0, NULL, NULL, 1, '2025-05-15 12:57:21', 50.00, 'membresia'),
(2, '2025-1', 5, NULL, NULL, 1, '2025-05-15 00:00:00', 500.00, 'membresia'),
(3, '2025-2', 3, NULL, NULL, 1, '2025-04-05 00:00:00', 500.00, 'membresia'),
(4, '2025-3', 1, NULL, NULL, 1, '2025-07-03 00:00:00', 500.00, 'membresia'),
(5, '2025-4', 3, NULL, NULL, 1, '2025-04-04 00:00:00', 500.00, 'membresia'),
(6, '2025-5', 3, NULL, NULL, 1, '2025-05-01 00:00:00', 500.00, 'membresia'),
(7, '2025-4', 3, NULL, NULL, 1, '2025-04-03 00:00:00', 500.00, 'membresia'),
(8, '2025-7', 0, NULL, NULL, 4, '2025-05-21 00:00:00', 0.00, 'membresia'),
(9, '2025-8', 3, NULL, NULL, 4, '2025-05-22 00:00:00', 500.00, 'membresia'),
(10, '2025-9', 4, NULL, NULL, 4, '2025-05-20 18:07:51', 500.00, 'membresia'),
(11, '2025-10', 3, NULL, NULL, 4, '2025-05-20 18:08:38', 500.00, 'membresia'),
(12, '2025-11', 0, NULL, NULL, 4, '2025-05-20 12:13:23', 0.00, 'membresia'),
(13, '2025-12', 0, NULL, NULL, 4, '2025-04-30 12:15:40', 0.00, 'membresia'),
(14, '2025-11', 0, NULL, NULL, 4, '2025-05-20 12:16:00', 0.00, 'membresia'),
(15, '2025-11', 0, NULL, NULL, 4, '2025-05-01 12:17:19', 0.00, 'membresia'),
(16, '2025-11', 0, NULL, NULL, 4, '2025-05-20 12:19:34', 0.00, 'membresia'),
(17, '2025-11', 0, NULL, NULL, 4, '2025-05-20 12:19:42', 0.00, 'membresia'),
(18, '2025-11', 0, NULL, NULL, 4, '2025-05-20 12:20:42', 0.00, 'membresia'),
(19, '2025-11', 0, NULL, NULL, 4, '2025-05-20 12:21:02', 0.00, 'membresia'),
(20, '2025-11', 0, NULL, NULL, 4, '2025-05-20 12:23:46', 0.00, 'membresia'),
(21, '2025-11', 0, NULL, NULL, 4, '2025-05-20 12:26:39', 0.00, 'membresia'),
(22, '2025-11', 1, NULL, NULL, 4, '2025-05-20 12:26:49', 500.00, 'membresia'),
(23, '2025-4', 0, NULL, NULL, 4, '2025-05-20 12:27:07', 0.00, 'membresia'),
(24, '2025-4', 0, NULL, NULL, 4, '2025-05-20 12:31:12', 0.00, 'membresia'),
(25, '2025-12', 0, NULL, NULL, 4, '2025-05-21 12:31:31', 0.00, 'membresia'),
(26, '2025-7', 0, NULL, NULL, 4, '2025-05-20 12:31:52', 0.00, 'membresia'),
(27, '2025-12', 5, NULL, NULL, 4, '2025-05-20 12:32:14', 500.00, 'membresia'),
(28, '2025-4', 0, NULL, NULL, 4, '2025-05-20 12:35:29', 0.00, 'membresia'),
(29, '2025-4', 0, NULL, NULL, 4, '2025-05-20 12:35:54', 0.00, 'membresia'),
(30, '2025-4', 0, NULL, NULL, 4, '2025-05-20 12:39:05', 0.00, 'membresia'),
(31, '2025-4', 0, NULL, NULL, 4, '2025-05-20 12:39:18', 0.00, 'membresia'),
(32, '2025-4', 0, NULL, NULL, 4, '2025-05-21 12:41:00', 0.00, 'membresia'),
(33, '2025-7', 2, NULL, NULL, 4, '2025-05-01 12:41:27', 500.00, 'membresia'),
(34, '2025-4', 2, NULL, NULL, 4, '2025-05-21 12:41:44', 500.00, 'membresia'),
(35, '2025-13', 1, NULL, NULL, 4, '2025-05-21 12:42:12', 500.00, 'membresia'),
(36, '2025-1', 2, NULL, NULL, 4, '2025-05-21 12:43:04', 500.00, 'membresia'),
(37, '2025-15', 4, NULL, NULL, 4, '2025-05-14 12:43:30', 500.00, 'membresia'),
(38, '2025-16', 5, NULL, NULL, 4, '2025-05-21 12:49:19', 500.00, 'membresia'),
(39, '0', 0, NULL, NULL, 4, '2025-05-26 15:37:48', 50.00, 'membresia'),
(40, '0', 0, NULL, NULL, 1, '2025-05-26 15:39:44', 50.00, 'membresia'),
(41, '2025-1', 2, NULL, NULL, 4, '2025-07-16 11:40:33', 500.00, 'membresia'),
(42, '2025-15', 3, NULL, NULL, 1, '2025-07-21 11:50:42', 500.00, 'membresia'),
(43, '0', 0, NULL, NULL, 1, '2025-07-21 11:51:21', 50.00, 'membresia'),
(44, '2025-16', 4, NULL, NULL, 1, '2025-07-27 11:52:26', 500.00, 'membresia'),
(45, '2025-17', 2, NULL, NULL, 1, '2025-07-22 09:29:51', 500.00, 'membresia'),
(46, '0', 0, NULL, NULL, 1, '2025-07-22 09:30:02', 50.00, 'membresia'),
(47, '0', 0, NULL, NULL, 2, '2025-07-22 10:02:37', 70.00, 'membresia'),
(48, '0', 0, NULL, NULL, 1, '2025-07-29 10:06:45', 50.00, 'membresia'),
(49, '2025-18', 5, NULL, NULL, 1, '2025-08-11 10:17:20', 500.00, 'membresia'),
(50, '0', 0, NULL, NULL, 1, '2025-08-11 11:39:00', 50.00, 'membresia'),
(51, '2025-19', 5, NULL, NULL, 1, '2025-08-04 11:43:25', 500.00, 'membresia'),
(52, '2025-19', 5, NULL, NULL, 1, '2025-08-11 13:37:26', 500.00, 'membresia'),
(53, '2025-17', 5, NULL, NULL, 1, '2025-08-20 12:21:49', 500.00, 'membresia'),
(54, '2025-18', 3, NULL, NULL, 1, '2025-08-24 12:07:54', 500.00, 'membresia'),
(55, '2025-15', 5, NULL, NULL, 1, '2025-08-21 13:47:51', 500.00, 'membresia'),
(56, '0', 0, NULL, NULL, 1, '2025-08-21 13:48:28', 50.00, 'membresia'),
(57, '0', 0, NULL, NULL, 1, '2025-08-21 14:17:03', 50.00, 'membresia'),
(58, '2025-1', 5, NULL, NULL, 1, '2025-08-21 14:17:24', 500.00, 'membresia'),
(59, '0', 0, NULL, NULL, 1, '2025-08-21 14:40:51', 50.00, 'membresia'),
(60, '2025-16', 0, NULL, NULL, 1, '2025-08-24 10:53:07', 0.00, 'membresia'),
(61, '2025-16', 2, NULL, NULL, 1, '2025-08-26 10:53:26', 500.00, 'membresia'),
(62, '2025-19', 0, NULL, NULL, 1, '2025-08-28 11:10:09', 0.00, 'membresia'),
(63, '2025-19', 3, NULL, NULL, 1, '2025-08-29 11:11:45', 500.00, 'membresia'),
(64, '2025-19', 3, NULL, NULL, 1, '2025-08-24 11:19:54', 500.00, 'membresia'),
(65, '2025-19', 3, NULL, NULL, 1, '2025-08-29 11:32:37', 500.00, 'membresia'),
(66, '2025-1', 0, NULL, NULL, 1, '2025-08-29 09:03:44', 0.00, 'membresia'),
(67, '2025-1', 5, NULL, NULL, 1, '2025-09-08 15:38:55', 500.00, 'membresia'),
(68, '0', 0, NULL, NULL, 1, '2025-09-02 09:11:21', 100.00, 'membresia'),
(69, '2025-15', 2, NULL, NULL, 1, '2025-09-08 09:12:17', 500.00, 'membresia'),
(70, '15', NULL, 4, 17, 1, '2025-09-02 11:30:24', 250.00, 'clase'),
(71, '15', NULL, 4, 17, 1, '2025-09-02 11:36:56', 350.00, 'clase'),
(72, '15', NULL, 4, 17, 1, '2025-09-02 11:41:39', 350.00, 'clase'),
(73, '15', NULL, 4, 17, 1, '2025-09-02 11:48:26', 250.00, 'clase'),
(74, '2025-17', 2, NULL, NULL, 1, '2025-09-03 12:15:40', 500.00, 'membresia'),
(75, '2025-19', 5, NULL, NULL, 1, '2025-09-03 12:16:59', 500.00, 'membresia'),
(76, '17', NULL, 3, 21, 1, '2025-09-02 13:10:50', 300.00, 'clase'),
(77, '0', 0, NULL, NULL, 1, '2025-09-02 13:26:07', 50.00, 'membresia'),
(78, '14', NULL, 4, 17, 1, '2025-09-02 13:57:29', 100.00, 'clase'),
(79, '19', NULL, 4, 17, 1, '2025-09-02 13:57:35', 100.00, 'clase'),
(80, '18', NULL, 4, 17, 1, '2025-09-02 13:57:42', 100.00, 'clase'),
(81, '17', NULL, 4, 17, 1, '2025-09-02 13:57:53', 100.00, 'clase'),
(82, '15', NULL, 3, 21, 1, '2025-09-03 09:10:35', 200.00, 'clase'),
(83, '2025-19', 5, NULL, NULL, 1, '2025-09-03 09:25:59', 500.00, 'membresia'),
(84, '2025-19', 1, NULL, NULL, 1, '2025-09-08 09:26:55', 500.00, 'membresia'),
(85, '2025-17', 1, NULL, NULL, 1, '2025-09-03 09:45:26', 500.00, 'membresia'),
(86, '2025-18', 1, NULL, NULL, 1, '2025-09-08 09:45:38', 500.00, 'membresia');

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

--
-- Volcado de datos para la tabla `reservas_clases`
--

INSERT INTO `reservas_clases` (`id`, `id_horario`, `fecha_reserva`, `estado`, `id_miembro`) VALUES
(1, 27, '2025-09-02 16:19:32', 'confirmada', 15),
(2, 27, '2025-09-02 16:25:50', 'confirmada', 18),
(9, 17, '2025-09-02 17:48:26', 'confirmada', 15),
(10, 21, '2025-09-02 19:10:50', 'confirmada', 17),
(11, 17, '2025-09-02 19:57:29', 'confirmada', 14),
(12, 17, '2025-09-02 19:57:35', 'confirmada', 19),
(13, 17, '2025-09-02 19:57:42', 'confirmada', 18),
(14, 17, '2025-09-02 19:57:53', 'confirmada', 17),
(15, 21, '2025-09-03 15:10:35', 'confirmada', 15);

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
-- Estructura de tabla para la tabla `rutinas`
--

CREATE TABLE `rutinas` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `nivel_dificultad` enum('principiante','intermedio','avanzado') DEFAULT NULL,
  `duracion_semanas` tinyint(4) DEFAULT NULL,
  `objetivo` enum('perdida_grasa','ganancia_muscular','fuerza','resistencia','general') DEFAULT NULL,
  `creada_por` int(11) DEFAULT NULL COMMENT 'ID del instructor',
  `activa` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rutinas`
--

INSERT INTO `rutinas` (`id`, `nombre`, `descripcion`, `nivel_dificultad`, `duracion_semanas`, `objetivo`, `creada_por`, `activa`, `created_at`) VALUES
(2, 'Prueba', 'Prueba', 'intermedio', 4, 'ganancia_muscular', 1, 1, '2025-09-03 21:35:37');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rutina_dias`
--

CREATE TABLE `rutina_dias` (
  `id` int(11) NOT NULL,
  `rutina_id` int(11) DEFAULT NULL,
  `dia_semana` tinyint(4) DEFAULT NULL COMMENT '1-7 (Lunes-Domingo)',
  `nombre_dia` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rutina_dias`
--

INSERT INTO `rutina_dias` (`id`, `rutina_id`, `dia_semana`, `nombre_dia`) VALUES
(4, 2, 1, 'Día de Piernas'),
(5, 2, 4, 'Día de Hombros'),
(6, 2, 7, 'Día de Descanso Acti');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rutina_ejercicios`
--

CREATE TABLE `rutina_ejercicios` (
  `id` int(11) NOT NULL,
  `rutina_dia_id` int(11) DEFAULT NULL,
  `ejercicio_id` int(11) DEFAULT NULL,
  `series` tinyint(4) DEFAULT NULL,
  `repeticiones` varchar(50) DEFAULT NULL,
  `peso_recomendado` varchar(100) DEFAULT NULL,
  `descanso_segundos` smallint(6) DEFAULT NULL,
  `orden` tinyint(4) DEFAULT NULL,
  `notas` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rutina_ejercicios`
--

INSERT INTO `rutina_ejercicios` (`id`, `rutina_dia_id`, `ejercicio_id`, `series`, `repeticiones`, `peso_recomendado`, `descanso_segundos`, `orden`, `notas`) VALUES
(5, 4, 2, 3, '10-12', '', 60, 0, ''),
(6, 4, 1, 3, '10-12', '', 60, 1, ''),
(7, 5, 2, 3, '10-12', '', 60, 0, ''),
(8, 6, 1, 3, '10-12', '', 60, 0, '');

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
(2, 'Sala Spinning', 5, 'Bicicletas, tapetes, cronometros'),
(3, 'Sala Pilates', 20, 'Pesas, tapetes, pelotas'),
(4, 'Sale Prueba', 10, 'Pesas, maquinas ');

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
(20, 19, 1, 5, '2025-08-11 11:43:48'),
(21, NULL, 1, NULL, '2025-08-21 13:48:28'),
(22, NULL, 1, NULL, '2025-08-21 14:17:03'),
(23, NULL, 1, NULL, '2025-08-21 14:40:51'),
(24, 15, 1, 5, '2025-08-21 14:40:56'),
(25, 14, 1, 5, '2025-09-01 15:52:02'),
(26, NULL, 1, NULL, '2025-09-02 09:11:21'),
(27, 14, 1, 5, '2025-09-02 13:26:03'),
(28, NULL, 1, NULL, '2025-09-02 13:26:07'),
(29, 14, 1, 5, '2025-09-03 09:46:52');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categorias_ejercicios`
--
ALTER TABLE `categorias_ejercicios`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `clases`
--
ALTER TABLE `clases`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `ejercicios`
--
ALTER TABLE `ejercicios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categoria_id` (`categoria_id`);

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
-- Indices de la tabla `rutinas`
--
ALTER TABLE `rutinas`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `rutina_dias`
--
ALTER TABLE `rutina_dias`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rutina_id` (`rutina_id`);

--
-- Indices de la tabla `rutina_ejercicios`
--
ALTER TABLE `rutina_ejercicios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rutina_dia_id` (`rutina_dia_id`),
  ADD KEY `ejercicio_id` (`ejercicio_id`);

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
-- AUTO_INCREMENT de la tabla `categorias_ejercicios`
--
ALTER TABLE `categorias_ejercicios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `clases`
--
ALTER TABLE `clases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `ejercicios`
--
ALTER TABLE `ejercicios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `gastos`
--
ALTER TABLE `gastos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `horarios_clases`
--
ALTER TABLE `horarios_clases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT de la tabla `instructores`
--
ALTER TABLE `instructores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `rutinas`
--
ALTER TABLE `rutinas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `rutina_dias`
--
ALTER TABLE `rutina_dias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `rutina_ejercicios`
--
ALTER TABLE `rutina_ejercicios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `salas`
--
ALTER TABLE `salas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `ejercicios`
--
ALTER TABLE `ejercicios`
  ADD CONSTRAINT `ejercicios_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `categorias_ejercicios` (`id`);

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
-- Filtros para la tabla `rutina_dias`
--
ALTER TABLE `rutina_dias`
  ADD CONSTRAINT `rutina_dias_ibfk_1` FOREIGN KEY (`rutina_id`) REFERENCES `rutinas` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `rutina_ejercicios`
--
ALTER TABLE `rutina_ejercicios`
  ADD CONSTRAINT `rutina_ejercicios_ibfk_1` FOREIGN KEY (`rutina_dia_id`) REFERENCES `rutina_dias` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `rutina_ejercicios_ibfk_2` FOREIGN KEY (`ejercicio_id`) REFERENCES `ejercicios` (`id`);

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
