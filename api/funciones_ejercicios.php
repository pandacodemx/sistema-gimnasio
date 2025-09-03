<?php
include_once "base_datos.php";

function registrarEjercicio($ejercicio)
{
    $sentencia = "INSERT INTO ejercicios (nombre, descripcion, instrucciones, categoria_id, imagen_url, video_url, met, nivel_dificultad, equipamiento) VALUES (?,?,?,?,?,?,?,?,?)";
    $parametros = [
        $ejercicio->nombre,
        $ejercicio->descripcion,
        $ejercicio->instrucciones,
        $ejercicio->categoria_id,
        $ejercicio->imagen_url,
        $ejercicio->video_url,
        $ejercicio->met,
        $ejercicio->nivel_dificultad,
        $ejercicio->equipamiento
    ];
    return insertar($sentencia, $parametros);
}

function obtenerEjercicios()
{
    $sentencia = "SELECT e.*, c.nombre as categoria_nombre 
                  FROM ejercicios e 
                  LEFT JOIN categorias_ejercicios c ON e.categoria_id = c.id 
                  ORDER BY e.nombre";
    return selectQuery($sentencia);
}

function eliminarEjercicio($id)
{
    $sentencia = "DELETE FROM ejercicios WHERE id = ?";
    return eliminar($sentencia, $id);
}

function editarEjercicio($ejercicio)
{
    $sentencia = "UPDATE ejercicios SET nombre = ?, descripcion = ?, instrucciones = ?, categoria_id = ?, imagen_url = ?, video_url = ?, met = ?, nivel_dificultad = ?, equipamiento = ? WHERE id = ?";
    $parametros = [
        $ejercicio->nombre,
        $ejercicio->descripcion,
        $ejercicio->instrucciones,
        $ejercicio->categoria_id,
        $ejercicio->imagen_url,
        $ejercicio->video_url,
        $ejercicio->met,
        $ejercicio->nivel_dificultad,
        $ejercicio->equipamiento,
        $ejercicio->id
    ];
    return editar($sentencia, $parametros);
}
