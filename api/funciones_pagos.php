<?php
include_once "base_datos.php";

function obtenerPagos($filtros)
{
    $fechaInicio = (isset($filtros->fechaInicio)) ? $filtros->fechaInicio : FECHA_HOY;
    $fechaFin = (isset($filtros->fechaFin)) ? $filtros->fechaFin : FECHA_HOY;

    $sentencia = "SELECT 
        pagos.*,
        miembros.nombre,
        miembros.imagen,
        miembros.matricula,
        usuarios.usuario,
        IFNULL(membresias.nombre, 'Visita Regular') AS membresia,
        clases.nombre AS nombre_clase
    FROM pagos
    LEFT JOIN miembros ON miembros.matricula = pagos.matricula 
    LEFT JOIN usuarios ON usuarios.id = pagos.idUsuario
    LEFT JOIN membresias ON membresias.id = pagos.idMembresia
    LEFT JOIN clases ON clases.id = pagos.id_clase
    WHERE DATE(pagos.fecha) >= ? AND DATE(pagos.fecha) <= ?
    ORDER BY pagos.fecha DESC";

    $parametros = [$fechaInicio, $fechaFin];
    $resultado = selectPrepare($sentencia, $parametros);

    return $resultado;
}

function obtenerTotalesPago($filtros)
{
    $fechaInicio = (isset($filtros->fechaInicio)) ? $filtros->fechaInicio : FECHA_HOY;
    $fechaFin = (isset($filtros->fechaFin)) ? $filtros->fechaFin : FECHA_HOY;

    $sentencia = "SELECT IFNULL(SUM(monto),0) AS totalPagos FROM pagos WHERE DATE(fecha) >= ? AND DATE(fecha) <= ?";
    $parametros = [$fechaInicio, $fechaFin];
    return selectPrepare($sentencia, $parametros)[0]->totalPagos;
}

function obtenerTotalesMembresia($filtros)
{
    $fechaInicio = (isset($filtros->fechaInicio)) ? $filtros->fechaInicio : FECHA_HOY;
    $fechaFin = (isset($filtros->fechaFin)) ? $filtros->fechaFin : FECHA_HOY;

    $sentencia  = "SELECT 
        SUM(pagos.monto) AS total, 
        COUNT(pagos.id) AS cantidad,
        IFNULL(membresias.nombre, 'Visita regular') AS nombre 
    FROM pagos
    LEFT JOIN membresias ON membresias.id = pagos.idMembresia
    WHERE DATE(pagos.fecha) >= ? 
    AND DATE(pagos.fecha) <= ? 
    AND pagos.tipo = 'membresia'  
    GROUP BY pagos.idMembresia
    ORDER BY total DESC";

    $parametros = [$fechaInicio, $fechaFin];
    return selectPrepare($sentencia, $parametros);
}

function obtenerTotalesClases($filtros)
{
    $fechaInicio = (isset($filtros->fechaInicio)) ? $filtros->fechaInicio : FECHA_HOY;
    $fechaFin = (isset($filtros->fechaFin)) ? $filtros->fechaFin : FECHA_HOY;

    $sentencia  = "SELECT 
        SUM(pagos.monto) AS total, 
        COUNT(pagos.id) AS cantidad,
        IFNULL(clases.nombre, 'Clase general') AS nombre
    FROM pagos
    LEFT JOIN clases ON clases.id = pagos.id_clase
    WHERE DATE(pagos.fecha) >= ? 
    AND DATE(pagos.fecha) <= ? 
    AND pagos.tipo = 'clase' 
    GROUP BY pagos.id_clase
    ORDER BY total DESC";

    $parametros = [$fechaInicio, $fechaFin];
    return selectPrepare($sentencia, $parametros);
}

function obtenerTotalesPorUsuario($filtros)
{
    $fechaInicio = (isset($filtros->fechaInicio)) ? $filtros->fechaInicio : FECHA_HOY;
    $fechaFin = (isset($filtros->fechaFin)) ? $filtros->fechaFin : FECHA_HOY;

    $sentencia  = "SELECT SUM(pagos.monto) AS total, usuarios.usuario AS nombre FROM pagos
    INNER JOIN usuarios ON usuarios.id = pagos.idUsuario
    WHERE DATE(pagos.fecha) >= ? AND DATE(pagos.fecha) <= ? 
    GROUP BY pagos.idUsuario
    ORDER BY total DESC";
    $parametros = [$fechaInicio, $fechaFin];
    return selectPrepare($sentencia, $parametros);
}

function obtenerTotalesPorMiembro($filtros)
{
    $fechaInicio = (isset($filtros->fechaInicio)) ? $filtros->fechaInicio : FECHA_HOY;
    $fechaFin = (isset($filtros->fechaFin)) ? $filtros->fechaFin : FECHA_HOY;

    $sentencia  = "SELECT SUM(pagos.monto) AS total, miembros.nombre, miembros.matricula, miembros.imagen FROM pagos
    INNER JOIN miembros ON miembros.matricula = pagos.matricula
    WHERE DATE(pagos.fecha) >= ? AND DATE(pagos.fecha) <= ? 
    GROUP BY pagos.matricula
    ORDER BY total DESC
    LIMIT 5";
    $parametros = [$fechaInicio, $fechaFin];
    return selectPrepare($sentencia, $parametros);
}
