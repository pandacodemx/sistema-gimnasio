<?php
include_once "base_datos.php";

function registrarCategoria($categoria)
{
    $sentencia = "INSERT INTO categorias_ejercicios (nombre, descripcion, icono) VALUES (?,?,?)";
    $parametros = [$categoria->nombre, $categoria->descripcion, $categoria->icono];
    return insertar($sentencia, $parametros);
}

function obtenerCategorias()
{
    $sentencia = "SELECT * FROM categorias_ejercicios ORDER BY nombre";
    return selectQuery($sentencia);
}

function eliminarCategoria($id)
{
    $sentencia = "DELETE FROM categorias_ejercicios WHERE id = ?";
    return eliminar($sentencia, $id);
}

function editarCategoria($categoria)
{
    $sentencia = "UPDATE categorias_ejercicios SET nombre = ?, descripcion = ?, icono = ? WHERE id = ?";
    $parametros = [$categoria->nombre, $categoria->descripcion, $categoria->icono, $categoria->id];
    return editar($sentencia, $parametros);
}
