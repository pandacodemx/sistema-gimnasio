<?php
include_once "base_datos.php";


// funciones_ventas.php (puedes agregarlo al mismo archivo o crear uno nuevo)
function registrarVenta($venta)
{
    // Primero registramos la venta general
    $sentencia = "INSERT INTO ventas (id_miembro, total, fecha) VALUES (?, ?, NOW())";
    $parametros = [
        $venta->id_miembro,
        $venta->total
    ];
    $idVenta = insertar($sentencia, $parametros);

    if (!$idVenta) return false;

    // Luego registramos los productos vendidos
    foreach ($venta->productos as $producto) {
        $sentencia = "INSERT INTO ventas_productos (id_venta, id_producto, cantidad, precio_unitario)
VALUES (?, ?, ?, ?)";
        $parametros = [
            $idVenta,
            $producto->id,
            $producto->cantidad,
            $producto->precio
        ];
        if (!insertar($sentencia, $parametros)) return false;

        // Actualizamos el stock del producto
        $sentencia = "UPDATE productos SET stock = stock - ? WHERE id = ?";
        $parametros = [$producto->cantidad, $producto->id];
        if (!editar($sentencia, $parametros)) return false;
    }

    return $idVenta;
}

function obtenerVentas()
{
    $sentencia = "SELECT v.*, m.nombre as nombre_miembro
FROM ventas v
LEFT JOIN miembros m ON v.id_miembro = m.id
ORDER BY v.fecha DESC";
    return selectQuery($sentencia);
}

function obtenerDetalleVenta($idVenta)
{
    $sentencia = "SELECT vp.*, p.nombre as nombre_producto
FROM ventas_productos vp
JOIN productos p ON vp.id_producto = p.id
WHERE vp.id_venta = ?";
    return selectQuery($sentencia, [$idVenta]);
}
