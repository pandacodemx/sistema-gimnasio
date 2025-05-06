<?php
include_once "base_datos.php";

function registrarVenta($venta)
{

    $sentencia = "INSERT INTO ventas (total, fecha) VALUES (?, NOW())";
    $parametros = [$venta->total];
    $ventaId = insertar($sentencia, $parametros);


    foreach ($venta->productos as $producto) {

        $sentenciaProducto = "INSERT INTO ventas_productos (venta_id, producto_id, cantidad, subtotal) VALUES (?, ?, ?, ?)";
        $parametrosProducto = [
            $ventaId,
            $producto->id,
            $producto->cantidad,
            $producto->subtotal
        ];
        insertar($sentenciaProducto, $parametrosProducto);


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
            vp.cantidad,          
            p.nombre AS nombre_producto
        FROM ventas v
        INNER JOIN ventas_productos vp ON v.id = vp.venta_id
        INNER JOIN productos p ON vp.producto_id = p.id
        WHERE v.fecha BETWEEN ? AND ?
        ORDER BY v.fecha DESC";
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
