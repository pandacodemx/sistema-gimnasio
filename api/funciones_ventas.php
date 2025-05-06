<?php
include_once "base_datos.php";

function registrarVenta($venta)
{

    $sentencia = "INSERT INTO ventas (total, fecha) VALUES (?, NOW())";
    $parametros = [$venta->total];
    $ventaId = insertarP($sentencia, $parametros);


    foreach ($venta->productos as $producto) {

        $sentenciaProducto = "INSERT INTO ventas_productos (venta_id, producto_id, cantidad, subtotal) VALUES (?, ?, ?, ?)";
        $parametrosProducto = [
            $ventaId,
            $producto->id,
            $producto->cantidad,
            $producto->subtotal
        ];
        insertarP($sentenciaProducto, $parametrosProducto);


        $sentenciaStock = "UPDATE productos SET stock = stock - ? WHERE id = ?";
        $parametrosStock = [
            $producto->cantidad,
            $producto->id
        ];
        insertar($sentenciaStock, $parametrosStock);
    }

    return ['success' => true, 'venta_id' => $ventaId];
}


function obtenerVentas($filtros)
{
    $fechaInicio = (isset($filtros->fechaInicio)) ? $filtros->fechaInicio : FECHA_HOY;
    $fechaFin = (isset($filtros->fechaFin)) ? $filtros->fechaFin : FECHA_HOY;
    $sentencia = "SELECT 
            v.id AS id_venta,
            v.fecha,
            v.total,            
            vp.producto_id,
            vp.subtotal,
            vp.cantidad,          
            p.nombre AS nombre_producto
        FROM ventas v
        INNER JOIN ventas_productos vp ON v.id = vp.venta_id
        INNER JOIN productos p ON vp.producto_id = p.id
        WHERE DATE(v.fecha) >= ? AND DATE(v.fecha) <= ? ";
    $parametros = [$fechaInicio, $fechaFin];

    return selectPrepare($sentencia, $parametros);
}

function obtenerTotalVentas($filtros)
{
    $fechaInicio = (isset($filtros->fechaInicio)) ? $filtros->fechaInicio : FECHA_HOY;
    $fechaFin = (isset($filtros->fechaFin)) ? $filtros->fechaFin : FECHA_HOY;

    $sentencia = "SELECT IFNULL(SUM(total),0) AS totalVentas FROM ventas WHERE DATE(fecha) >= ? AND DATE(fecha) <= ?";
    $parametros = [$fechaInicio, $fechaFin];
    return selectPrepare($sentencia, $parametros)[0]->totalVentas;
}

function obtenerTotalesProductos($filtros)
{
    $fechaInicio = (isset($filtros->fechaInicio)) ? $filtros->fechaInicio : FECHA_HOY;
    $fechaFin = (isset($filtros->fechaFin)) ? $filtros->fechaFin : FECHA_HOY;

    $sentencia  = "SELECT 
    vp.producto_id,
    p.nombre AS nombre,
    SUM(vp.subtotal) AS total,
    SUM(vp.cantidad) AS total_cantidad,
    DATE(v.fecha) AS fecha
    FROM ventas v
    INNER JOIN ventas_productos vp ON v.id = vp.venta_id
    INNER JOIN productos p ON vp.producto_id = p.id
    WHERE DATE(v.fecha) >= ? AND DATE(v.fecha) <= ?
    GROUP BY vp.producto_id, DATE(v.fecha)
    ORDER BY fecha, nombre";
    $parametros = [$fechaInicio, $fechaFin];
    return selectPrepare($sentencia, $parametros);
}


function eliminarVenta($id)
{

    $sentenciaProductos = "DELETE FROM ventas_productos WHERE venta_id = ?";
    eliminar($sentenciaProductos, $id);

    $sentenciaVenta = "DELETE FROM ventas WHERE id = ?";
    return eliminar($sentenciaVenta, $id);
}

function editarVenta($venta)
{
    // Aquí podrías actualizar la venta, si es necesario.
    // Dependiendo de tus requerimientos, podrías permitir modificar el total, productos, etc.
    return ['success' => true]; // Para este ejemplo, no estamos editando ventas directamente.
}
