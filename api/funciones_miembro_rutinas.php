<?php
include_once "base_datos.php";

function asignarRutinaMiembro($asignacion)
{
    $sentencia = "INSERT INTO miembro_rutinas 
                 (miembro_id, rutina_id, fecha_inicio, fecha_fin, asignada_por, notas) 
                 VALUES (?,?,?,?,?,?)";

    $parametros = [
        $asignacion->miembro_id,
        $asignacion->rutina_id,
        $asignacion->fecha_inicio,
        $asignacion->fecha_fin,
        $asignacion->asignada_por,
        $asignacion->notas
    ];

    $id = insertarP($sentencia, $parametros);

    // Devuelve un objeto con success y el id
    return [
        'success' => $id !== false,
        'id' => $id,
        'message' => $id !== false ? 'Rutina asignada correctamente' : 'Error al asignar rutina'
    ];
}

function obtenerRutinasPorMiembro($miembro_id)
{
    $sentencia = "SELECT mr.*, r.nombre as rutina_nombre, r.descripcion as rutina_descripcion,
                 r.nivel_dificultad, r.objetivo, r.duracion_semanas
                 FROM miembro_rutinas mr
                 JOIN rutinas r ON mr.rutina_id = r.id
                 WHERE mr.miembro_id = ? AND mr.activa = TRUE
                 ORDER BY mr.fecha_inicio DESC";

    return selectPrepare($sentencia, [$miembro_id]);
}

function obtenerRutinasActivas()
{
    $sentencia = "SELECT mr.*, r.nombre as rutina_nombre, 
                 CONCAT(m.nombre) as miembro_nombre,
                 CONCAT(i.nombre) as instructor_nombre
                 FROM miembro_rutinas mr
                 JOIN rutinas r ON mr.rutina_id = r.id
                 JOIN miembros m ON mr.miembro_id = m.id
                 JOIN instructores i ON mr.asignada_por = i.id
                 WHERE mr.activa = TRUE
                 ORDER BY mr.fecha_inicio DESC";

    return selectQuery($sentencia);
}

function desactivarRutina($id)
{
    $sentencia = "UPDATE miembro_rutinas SET activa = FALSE WHERE id = ?";
    $resultado = editar($sentencia, [$id]);

    return [
        'success' => $resultado,
        'message' => $resultado ? 'Rutina desactivada correctamente' : 'Error al desactivar rutina'
    ];
}
function activarRutina($id)
{
    $sentencia = "UPDATE miembro_rutinas SET activa = TRUE WHERE id = ?";
    $resultado = editar($sentencia, [$id]);

    return [
        'success' => $resultado,
        'message' => $resultado ? 'Rutina activada correctamente' : 'Error al activar rutina'
    ];
}

function obtenerTodasAsignaciones()
{
    $sentencia = "SELECT mr.*, r.nombre as rutina_nombre, 
                 CONCAT(m.nombre) as miembro_nombre,
                 CONCAT(i.nombre) as instructor_nombre
                 FROM miembro_rutinas mr
                 JOIN rutinas r ON mr.rutina_id = r.id
                 JOIN miembros m ON mr.miembro_id = m.id
                 JOIN instructores i ON mr.asignada_por = i.id
                 ORDER BY mr.fecha_inicio DESC";

    return selectQuery($sentencia);
}
