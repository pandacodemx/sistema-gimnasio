<?php
include_once "base_datos.php";

function crearRutina($rutina)
{
    // 1. Insertar la rutina principal
    $sentencia = "INSERT INTO rutinas (nombre, descripcion, nivel_dificultad, duracion_semanas, objetivo, creada_por) VALUES (?,?,?,?,?,?)";
    $parametros = [
        $rutina->nombre,
        $rutina->descripcion,
        $rutina->nivel_dificultad,
        $rutina->duracion_semanas,
        $rutina->objetivo,
        $rutina->creada_por
    ];

    $rutinaId = insertarP($sentencia, $parametros);

    if (!$rutinaId) return false;

    // 2. Insertar los días de la rutina
    foreach ($rutina->dias as $dia) {
        $sentenciaDia = "INSERT INTO rutina_dias (rutina_id, dia_semana, nombre_dia) VALUES (?,?,?)";
        $parametrosDia = [$rutinaId, $dia->dia_semana, $dia->nombre_dia];
        $diaId = insertarP($sentenciaDia, $parametrosDia);

        if (!$diaId) continue;

        // 3. Insertar los ejercicios de cada día
        foreach ($dia->ejercicios as $ejercicio) {
            $sentenciaEj = "INSERT INTO rutina_ejercicios (rutina_dia_id, ejercicio_id, series, repeticiones, peso_recomendado, descanso_segundos, orden, notas) VALUES (?,?,?,?,?,?,?,?)";
            $parametrosEj = [
                $diaId,
                $ejercicio->ejercicio_id,
                $ejercicio->series,
                $ejercicio->repeticiones,
                $ejercicio->peso_recomendado,
                $ejercicio->descanso_segundos,
                $ejercicio->orden,
                $ejercicio->notas
            ];
            insertar($sentenciaEj, $parametrosEj);
        }
    }

    return ['success' => true, 'id' => $rutinaId];
}

function obtenerRutinas()
{
    $sentencia = "SELECT r.*, COUNT(rd.id) as total_dias 
                  FROM rutinas r 
                  LEFT JOIN rutina_dias rd ON r.id = rd.rutina_id 
                  GROUP BY r.id 
                  ORDER BY r.nombre";
    return selectQuery($sentencia);
}

function obtenerRutinaPorId($id)
{
    // Obtener información básica de la rutina
    $sentencia = "SELECT * FROM rutinas WHERE id = ?";
    $rutina = selectPrepare($sentencia, [$id]);

    if (!$rutina || count($rutina) === 0) return false;

    $rutina = $rutina[0]; // Tomar el primer resultado

    // Obtener días de la rutina
    $sentenciaDias = "SELECT * FROM rutina_dias WHERE rutina_id = ? ORDER BY dia_semana";
    $dias = selectPrepare($sentenciaDias, [$id]);

    foreach ($dias as $dia) {
        // Obtener ejercicios de cada día
        $sentenciaEj = "SELECT re.*, e.nombre as ejercicio_nombre, e.descripcion as ejercicio_descripcion,
                        e.imagen_url, e.video_url, c.nombre as categoria_nombre
                        FROM rutina_ejercicios re
                        JOIN ejercicios e ON re.ejercicio_id = e.id
                        LEFT JOIN categorias_ejercicios c ON e.categoria_id = c.id
                        WHERE re.rutina_dia_id = ? 
                        ORDER BY re.orden";
        $ejercicios = selectPrepare($sentenciaEj, [$dia->id]);
        $dia->ejercicios = $ejercicios;
    }

    $rutina->dias = $dias;

    return $rutina;
}

function eliminarRutina($id)
{
    // Las foreign keys con ON DELETE CASCADE se encargarán de eliminar los registros relacionados
    $sentencia = "DELETE FROM rutinas WHERE id = ?";
    return eliminar($sentencia, $id);
}

function actualizarRutina($rutina)
{
    // Primero eliminar la rutina existente y recrearla
    // (esto es más simple que actualizar cada relación individual)
    eliminarRutina($rutina->id);
    return crearRutina($rutina);
}

function asignarRutinaMiembro($asignacion)
{
    $sentencia = "INSERT INTO miembro_rutinas (miembro_id, rutina_id, fecha_inicio, fecha_fin, asignada_por, notas) 
                  VALUES (?,?,?,?,?,?)";
    $parametros = [
        $asignacion->miembro_id,
        $asignacion->rutina_id,
        $asignacion->fecha_inicio,
        $asignacion->fecha_fin,
        $asignacion->asignada_por,
        $asignacion->notas
    ];
    return insertar($sentencia, $parametros);
}

function obtenerRutinasAsignadas($miembro_id)
{
    $sentencia = "SELECT mr.*, r.nombre as rutina_nombre, r.descripcion as rutina_descripcion,
                  CONCAT(m.nombre, ' ', m.apellido) as miembro_nombre,
                  CONCAT(i.nombre, ' ', i.apellido) as instructor_nombre
                  FROM miembro_rutinas mr
                  JOIN rutinas r ON mr.rutina_id = r.id
                  JOIN miembros m ON mr.miembro_id = m.id
                  JOIN instructores i ON mr.asignada_por = i.id
                  WHERE mr.miembro_id = ? AND mr.activa = TRUE
                  ORDER BY mr.fecha_inicio DESC";
    return selectPrepare($sentencia, [$miembro_id]);
}
