<?php
include_once "base_datos.php";

// Obtener todas las clases
function obtenerClases()
{
    $sentencia = "SELECT * FROM clases ORDER BY nombre";
    return selectPrepare($sentencia);
}

// Obtener horarios por rango de fechas
function obtenerHorarios($fechaInicio, $fechaFin)
{
    $sentencia = "SELECT h.*, c.nombre as nombre_clase, c.color_calendario, 
                 i.nombre as nombre_instructor, s.nombre as nombre_sala
                 FROM horarios_clases h
                 JOIN clases c ON h.id_clase = c.id
                 JOIN instructores i ON h.id_instructor = i.id
                 JOIN salas s ON h.id_sala = s.id
                 WHERE h.fecha_hora_inicio BETWEEN ? AND ?
                 ORDER BY h.fecha_hora_inicio";
    return selectPrepare($sentencia, [$fechaInicio, $fechaFin]);
}

// Crear nueva clase
function crearClase($clase)
{
    $sentencia = "INSERT INTO clases 
                 (nombre, descripcion, duracion_min, nivel_dificultad, color_calendario) 
                 VALUES (?, ?, ?, ?, ?)";
    return insertar($sentencia, [
        $clase->nombre,
        $clase->descripcion,
        $clase->duracion_min,
        $clase->nivel_dificultad,
        $clase->color_calendario
    ]);
}

// Programar horario
function programarHorario($horario)
{
    $sentencia = "INSERT INTO horarios_clases 
                 (id_clase, id_instructor, id_sala, fecha_hora_inicio, fecha_hora_fin, repeticion, max_participantes) 
                 VALUES (?, ?, ?, ?, ?, ?, ?)";
    return insertar($sentencia, [
        $horario->id_clase,
        $horario->id_instructor,
        $horario->id_sala,
        $horario->fecha_hora_inicio,
        $horario->fecha_hora_fin,
        $horario->repeticion,
        $horario->max_participantes
    ]);
}

// Registrar reserva
function registrarReserva($reserva)
{
    // Verificar disponibilidad primero
    $cuposDisponibles = verificarDisponibilidad($reserva->id_horario);

    if ($cuposDisponibles > 0) {
        $sentencia = "INSERT INTO reservas_clases 
                     (id_miembro, id_horario, estado) 
                     VALUES (?, ?, ?)";
        return insertar($sentencia, [
            $reserva->id_miembro,
            $reserva->id_horario,
            'confirmada'
        ]);
    }
    return false;
}

// Verificar disponibilidad
function verificarDisponibilidad($id_horario)
{
    $sentencia = "SELECT h.max_participantes, COUNT(r.id) as reservados
                 FROM horarios_clases h
                 LEFT JOIN reservas_clases r ON h.id = r.id_horario AND r.estado != 'cancelada'
                 WHERE h.id = ?";
    $resultado = selectPrepare($sentencia, [$id_horario]);

    return $resultado[0]->max_participantes - $resultado[0]->reservados;
}

function obtenerInstructores()
{
    $sentencia = "SELECT * FROM instructores ORDER BY nombre";
    return selectPrepare($sentencia);
}

function obtenerSalas()
{
    $sentencia = "SELECT * FROM salas ORDER BY nombre";
    return selectPrepare($sentencia);
}

function obtenerReservasPorHorario($id_horario)
{
    $sentencia = "SELECT COUNT(*) as total FROM reservas_clases 
                 WHERE id_horario = ? AND estado != 'cancelada'";
    $resultado = selectPrepare($sentencia, [$id_horario]);
    return $resultado[0]->total;
}
