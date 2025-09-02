<?php
include_once "base_datos.php";
date_default_timezone_set('America/Mexico_City');

// Obtener todas las clases
function obtenerClases()
{
    $sentencia = "SELECT * FROM clases ORDER BY nombre";
    return selectPrepare($sentencia);
}

// Obtener horarios por rango de fechas
function obtenerHorarios($fechaInicio, $fechaFin)
{
    $sentencia = "SELECT 
        h.*,
        c.nombre as nombre_clase,
        c.color_calendario,
        c.duracion_min,
        c.nivel_dificultad,
        i.nombre as nombre_instructor,
        s.nombre as nombre_sala,
        (h.max_participantes - COUNT(r.id)) as cupos_disponibles
    FROM horarios_clases h
    JOIN clases c ON h.id_clase = c.id
    JOIN instructores i ON h.id_instructor = i.id
    JOIN salas s ON h.id_sala = s.id
    LEFT JOIN reservas_clases r ON h.id = r.id_horario AND r.estado = 'confirmada'
    WHERE DATE(h.fecha_hora_inicio) BETWEEN ? AND ?
    GROUP BY h.id
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

    if (empty($horario->fecha_hora_inicio) || empty($horario->fecha_hora_fin)) {
        return ['error' => 'Fechas de inicio y fin son requeridas'];
    }

    if (
        !preg_match('/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/', $horario->fecha_hora_inicio) ||
        !preg_match('/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/', $horario->fecha_hora_fin)
    ) {
        return ['error' => 'Formato de fecha inválido'];
    }

    $inicio = strtotime($horario->fecha_hora_inicio);
    $fin = strtotime($horario->fecha_hora_fin);

    if ($inicio === false || $fin === false) {
        return ['error' => 'Fechas inválidas'];
    }

    if ($fin <= $inicio) {
        return ['error' => 'La fecha de fin debe ser después de la fecha de inicio'];
    }

    if ($inicio < 0 || date('Y', $inicio) < 2000) {
        return ['error' => 'Fecha de inicio no válida: ' . $horario->fecha_hora_inicio];
    }


    $horariosCreados = [];
    $veces = isset($horario->veces) ? (int)$horario->veces : 1;

    if ($horario->repeticion === 'ninguna') {

        $resultado = crearHorarioIndividual(
            $horario->id_clase,
            $horario->id_instructor,
            $horario->id_sala,
            $horario->fecha_hora_inicio,
            $horario->fecha_hora_fin,
            $horario->max_participantes,
            $horario->repeticion
        );

        if (isset($resultado['error'])) {
            return $resultado;
        }
        $horariosCreados[] = $resultado;
    } else {

        for ($i = 0; $i < $veces; $i++) {
            $nuevaFechaInicio = calcularSiguienteFecha($horario->fecha_hora_inicio, $horario->repeticion, $i);
            $nuevaFechaFin = calcularSiguienteFecha($horario->fecha_hora_fin, $horario->repeticion, $i);

            $resultado = crearHorarioIndividual(
                $horario->id_clase,
                $horario->id_instructor,
                $horario->id_sala,
                $nuevaFechaInicio,
                $nuevaFechaFin,
                $horario->max_participantes,
                $horario->repeticion
            );

            if (isset($resultado['error'])) {

                return $resultado;
            }
            $horariosCreados[] = $resultado;
        }
    }

    return ['success' => true, 'creados' => count($horariosCreados)];
}

function calcularSiguienteFecha($fechaMySQL, $tipoRepeticion, $iteracion)
{
    $timestamp = strtotime($fechaMySQL);

    switch ($tipoRepeticion) {
        case 'diaria':

            return date('Y-m-d H:i:s', strtotime("+$iteracion days", $timestamp));

        case 'semanal':

            return date('Y-m-d H:i:s', strtotime("+$iteracion weeks", $timestamp));

        case 'lunes_viernes':

            $nuevaFecha = strtotime("+$iteracion days", $timestamp);
            $diaSemana = date('N', $nuevaFecha);


            if ($diaSemana >= 6) {
                $diasASaltar = 8 - $diaSemana;
                $nuevaFecha = strtotime("+$diasASaltar days", $nuevaFecha);
            }

            return date('Y-m-d H:i:s', $nuevaFecha);

        case 'fin_semana':

            $nuevaFecha = strtotime("+$iteracion weeks", $timestamp);
            $diaSemana = date('N', $nuevaFecha);


            if ($diaSemana < 6) {
                $diasHastaSabado = 6 - $diaSemana;
                $nuevaFecha = strtotime("+$diasHastaSabado days", $nuevaFecha);
            }

            return date('Y-m-d H:i:s', $nuevaFecha);

        case 'mensual':

            return date('Y-m-d H:i:s', strtotime("+$iteracion months", $timestamp));

        default:
            return $fechaMySQL;
    }
}

function crearHorarioIndividual($id_clase, $id_instructor, $id_sala, $inicio, $fin, $max_participantes, $repeticion)
{

    $superpuesto = verificarSuperposicionHorario($id_sala, $inicio, $fin);

    if ($superpuesto) {
        return ['error' => 'La sala ya está ocupada en el horario: ' . $inicio];
    }

    $sentencia = "INSERT INTO horarios_clases 
                 (id_clase, id_instructor, id_sala, fecha_hora_inicio, fecha_hora_fin, max_participantes, repeticion) 
                 VALUES (?, ?, ?, ?, ?, ?, ?)";

    return insertar($sentencia, [
        $id_clase,
        $id_instructor,
        $id_sala,
        $inicio,
        $fin,
        $max_participantes,
        $repeticion
    ]);
}

function verificarSuperposicionHorario($id_sala, $fecha_inicio, $fecha_fin, $excluir_id = null)
{
    $sql = "SELECT COUNT(*) as total 
            FROM horarios_clases 
            WHERE id_sala = ? 
            AND fecha_hora_inicio < ? 
            AND fecha_hora_fin > ?";

    $params = [$id_sala, $fecha_fin, $fecha_inicio];

    if ($excluir_id) {
        $sql .= " AND id != ?";
        $params[] = $excluir_id;
    }

    $resultado = selectPrepare($sql, $params);
    return $resultado && $resultado[0]->total > 0;
}

function validadorFechaMySQL($fecha)
{
    return preg_match('/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/', $fecha);
}

function obtenerDuracionClase($id_clase)
{
    $sentencia = "SELECT duracion_min FROM clases WHERE id = ?";
    $resultado = selectPrepare($sentencia, [$id_clase]);
    return $resultado[0]->duracion_min;
}

// Registrar reserva
function registrarReserva($reserva)
{

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

function crearInstructor($instructor)
{
    $sentencia = "INSERT INTO instructores (nombre, especialidad, email, telefono) 
                 VALUES (?, ?, ?, ?)";
    return insertar($sentencia, [
        $instructor->nombre,
        $instructor->especialidad,
        $instructor->email,
        $instructor->telefono
    ]);
}

function actualizarInstructor($instructor)
{
    $sentencia = "UPDATE instructores SET nombre = ?, especialidad = ?, email = ?, telefono = ?
                 WHERE id = ?";
    return editar($sentencia, [
        $instructor->nombre,
        $instructor->especialidad,
        $instructor->email,
        $instructor->telefono,
        $instructor->id
    ]);
}

function eliminarInstructor($id)
{
    $clasesFuturas = selectPrepare("SELECT COUNT(*) as total FROM horarios_clases 
                           WHERE id_instructor = ? AND fecha_hora_inicio > NOW()", [$id]);

    if ($clasesFuturas[0]->total > 0) {
        return ['error' => 'No se puede eliminar, el instructor tiene clases programadas'];
    }

    $sentencia = "DELETE FROM instructores WHERE id = ?";
    return eliminar($sentencia, [$id]);
}

function crearSala($sala)
{
    $sentencia = "INSERT INTO salas (nombre, capacidad, equipamiento) 
                 VALUES (?, ?, ?)";
    return insertar($sentencia, [
        $sala->nombre,
        $sala->capacidad,
        $sala->equipamiento
    ]);
}

function actualizarSala($sala)
{
    $sentencia = "UPDATE salas SET nombre = ?, capacidad = ?, equipamiento = ?
                 WHERE id = ?";
    return editar($sentencia, [
        $sala->nombre,
        $sala->capacidad,
        $sala->equipamiento,
        $sala->id
    ]);
}

function eliminarSala($id)
{
    $horariosFuturos = selectPrepare("SELECT COUNT(*) as total FROM horarios_clases 
                             WHERE id_sala = ? AND fecha_hora_inicio > NOW()", [$id]);

    if ($horariosFuturos[0]->total > 0) {
        return ['error' => 'No se puede eliminar, la sala tiene horarios programados'];
    }

    $sentencia = "DELETE FROM salas WHERE id = ?";
    return eliminar($sentencia, [$id]);
}

function obtenerMiembrosInscritos($idHorario)
{
    $sentencia = "SELECT 
        r.id as id_inscripcion,
        m.id,
        m.nombre,
        m.telefono,
        r.fecha_reserva,
        r.estado
    FROM reservas_clases r
    INNER JOIN miembros m ON r.id_miembro = m.id
    WHERE r.id_horario = ? AND r.estado = 'confirmada'
    ORDER BY r.fecha_reserva DESC";

    return selectPrepare($sentencia, [$idHorario]);
}

function agregarMiembroAClase($inscripcion)
{
    // Convertir a array de manera segura
    if (is_object($inscripcion)) {
        $inscripcion = json_decode(json_encode($inscripcion), true);
    }

    // Verificar que los datos necesarios estén presentes
    $camposRequeridos = ['id_horario', 'id_miembro'];
    foreach ($camposRequeridos as $campo) {
        if (!isset($inscripcion[$campo])) {

            return ['exito' => false, 'mensaje' => "Datos incompletos para la inscripción. Falta: $campo"];
        }
    }

    // Asignar fecha_reserva con la fecha actual si no se proporciona
    if (!isset($inscripcion['fecha_reserva']) || empty($inscripcion['fecha_reserva'])) {
        $inscripcion['fecha_reserva'] = date('Y-m-d H:i:s');
    }

    // Primero verificar cupos disponibles - CONSULTA MÁS SEGURA
    $verificarCupos = "SELECT max_participantes FROM horarios_clases WHERE id = ?";
    $cupos = selectPrepare($verificarCupos, [$inscripcion['id_horario']]);


    if ($cupos === false) {

        return ['exito' => false, 'mensaje' => 'Error al verificar cupos disponibles'];
    }

    if (empty($cupos)) {

        return ['exito' => false, 'mensaje' => 'No se encontró el horario especificado'];
    }
    // Verificar reservas existentes
    $verificarReservas = "SELECT COUNT(*) as reservas_actuales FROM reservas_clases 
                         WHERE id_horario = ? AND estado = 'confirmada'";
    $reservas = selectPrepare($verificarReservas, [$inscripcion['id_horario']]);

    $reservasActuales = 0;
    if (!empty($reservas) && isset($reservas[0]->reservas_actuales)) {
        $reservasActuales = (int) $reservas[0]->reservas_actuales;
    }

    $maxParticipantes = (int) $cupos[0]->max_participantes;
    $cuposDisponibles = $maxParticipantes - $reservasActuales;

    if ($cuposDisponibles <= 0) {
        return ['exito' => false, 'mensaje' => 'No hay cupos disponibles'];
    }

    // Verificar si ya está inscrito
    $verificarInscrito = "SELECT id FROM reservas_clases 
                         WHERE id_horario = ? AND id_miembro = ? AND estado = 'confirmada'";
    $yaInscrito = selectPrepare($verificarInscrito, [$inscripcion['id_horario'], $inscripcion['id_miembro']]);

    if ($yaInscrito === false) {
        return ['exito' => false, 'mensaje' => 'Error al verificar inscripción existente'];
    }

    if (!empty($yaInscrito)) {
        return ['exito' => false, 'mensaje' => 'El miembro ya está inscrito en esta clase'];
    }

    $sentencia = "INSERT INTO reservas_clases (id_horario, id_miembro, fecha_reserva, estado) 
                 VALUES (?, ?, ?, 'confirmada')";

    error_log("Sentencia SQL: " . $sentencia);
    error_log("Parámetros: " . print_r([
        $inscripcion['id_horario'],
        $inscripcion['id_miembro'],
        $inscripcion['fecha_reserva']
    ], true));

    $resultado = insertar($sentencia, [
        $inscripcion['id_horario'],
        $inscripcion['id_miembro'],
        $inscripcion['fecha_reserva']
    ]);

    if ($resultado === false) {

        return ['exito' => false, 'mensaje' => 'Error al insertar la reserva'];
    }

    $exito = false;
    $id = null;

    if (is_array($resultado)) {
        $exito = $resultado['exito'] ?? false;
        $id = $resultado['id'] ?? null;
    } elseif (is_object($resultado)) {
        $exito = $resultado->exito ?? false;
        $id = $resultado->id ?? null;
    } elseif (is_bool($resultado)) {
        $exito = $resultado;
    } elseif (is_numeric($resultado)) {
        $exito = true;
        $id = $resultado;
    }

    if (!$exito && $resultado !== false) {

        $verificarInsercion = "SELECT id FROM reservas_clases 
                              WHERE id_horario = ? AND id_miembro = ? AND estado = 'confirmada' 
                              ORDER BY id DESC LIMIT 1";

        $registroInsertado = selectPrepare($verificarInsercion, [
            $inscripcion['id_horario'],
            $inscripcion['id_miembro']
        ]);

        if (!empty($registroInsertado)) {
            $exito = true;
            $id = is_object($registroInsertado[0]) ? $registroInsertado[0]->id : $registroInsertado[0]['id'];
        }
    }

    if ($exito && isset($inscripcion['monto_pagado']) && $inscripcion['monto_pagado'] > 0) {

        include_once "funciones_miembros.php";

        $consultaIdClase = "SELECT id_clase FROM horarios_clases WHERE id = ?";
        $resultadoIdClase = selectPrepare($consultaIdClase, [$inscripcion['id_horario']]);
        $idClase = null;
        if (!empty($resultadoIdClase)) {
            if (is_object($resultadoIdClase[0])) {
                $idClase = $resultadoIdClase[0]->id_clase;
            } else {
                $idClase = $resultadoIdClase[0]['id_clase'];
            }
        }

        if ($idClase) {
            $pagoData = [
                'matricula' => $inscripcion['id_miembro'],
                'id_clase' => $idClase,
                'id_horario' => $inscripcion['id_horario'],
                'idUsuario' => $inscripcion['id_usuario_registro'] ?? 1,
                'fecha' => $inscripcion['fecha_reserva'],
                'pago' => $inscripcion['monto_pagado']
            ];
            error_log("Datos para pago: " . print_r($pagoData, true));
            $pagoObj = (object) $pagoData;
            $resultadoPago = registrarPago($pagoObj);
            error_log("Resultado del pago: " . print_r($resultadoPago, true));
        } else {
            error_log("Error: No se pudo obtener el ID de la clase del horario " . $inscripcion['id_horario']);
        }
    }

    return [
        'exito' => $exito,
        'mensaje' => $exito ? 'Miembro agregado exitosamente' : 'Error al agregar miembro',
        'id' => $id
    ];
}

function eliminarMiembroDeClase($idInscripcion)
{


    $sentencia = "DELETE FROM reservas_clases WHERE id = ?";
    $resultado = eliminar($sentencia, $idInscripcion);


    if ($resultado === true) {
        return ['exito' => true, 'mensaje' => 'Inscripción eliminada correctamente'];
    } elseif (is_array($resultado) && isset($resultado['exito'])) {
        return $resultado;
    } else {
        return ['exito' => false, 'mensaje' => 'Error al eliminar la inscripción'];
    }
}


function verificarReservaUsuario($idHorario, $idUsuario)
{
    $sentencia = "SELECT * FROM reservas_clases 
                 WHERE id_horario = ? AND id_miembro = ? AND estado = 'confirmada'";

    $reserva = selectPrepare($sentencia, [$idHorario, $idUsuario]);

    return [
        'tiene_reserva' => !empty($reserva),
        'reserva' => !empty($reserva) ? $reserva[0] : null
    ];
}
