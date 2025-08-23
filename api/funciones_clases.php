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
        m.email, 
        m.telefono,
        r.fecha_inscripcion,
        r.monto_pagado,
        r.estado
    FROM reservas_clases r
    INNER JOIN miembros m ON r.id_miembro = m.id
    WHERE r.id_horario = ? AND r.estado = 'confirmada'
    ORDER BY r.fecha_inscripcion DESC";

    return selectPrepare($sentencia, [$idHorario]);
}


function agregarMiembroAClase($inscripcion)
{

    if (is_object($inscripcion)) {
        $inscripcion = (array) $inscripcion;
    }
    error_log("Datos de inscripción recibidos: " . print_r($inscripcion, true));
    if (!isset($inscripcion['id_horario']) || !isset($inscripcion['id_miembro']) || !isset($inscripcion['fecha_inscripcion'])) {
        return ['exito' => false, 'mensaje' => 'Datos incompletos para la inscripción'];
    }

    $verificarCupos = "SELECT max_participantes FROM horarios_clases WHERE id = ?";
    $cupos = selectPrepare($verificarCupos, [$inscripcion['id_horario']]);
    error_log("Resultado de consulta de cupos: " . print_r($cupos, true));

    if ($cupos === false) {
        error_log("Error en consulta de cupos");
        return ['exito' => false, 'mensaje' => 'Error al verificar cupos disponibles'];
    }

    if (empty($cupos)) {
        error_log("Horario no encontrado: " . $inscripcion['id_horario']);
        return ['exito' => false, 'mensaje' => 'No se encontró el horario especificado'];
    }

    $verificarReservas = "SELECT COUNT(*) as reservas_actuales FROM reservas_clases 
                         WHERE id_horario = ? AND estado = 'confirmada'";
    $reservas = selectPrepare($verificarReservas, [$inscripcion['id_horario']]);

    error_log("Reservas actuales: " . print_r($reservas, true));

    $reservasActuales = 0;
    if (!empty($reservas)) {
        $reservasActuales = (int) $reservas[0]['reservas_actuales'];
    }

    $cuposDisponibles = (int) $cupos[0]['max_participantes'] - $reservasActuales;

    error_log("Cupos disponibles calculados: " . $cuposDisponibles);

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

    // Insertar la reserva
    $sentencia = "INSERT INTO reservas_clases (id_horario, id_miembro, fecha_inscripcion, estado) 
                 VALUES (?, ?, ?, 'confirmada')";

    $resultado = insertar($sentencia, [
        $inscripcion['id_horario'],
        $inscripcion['id_miembro'],
        $inscripcion['fecha_inscripcion']
    ]);

    // VERIFICACIÓN DEL RESULTADO CORREGIDA
    if ($resultado === false) {
        return ['exito' => false, 'mensaje' => 'Error al insertar la reserva'];
    }

    // Registrar el pago si se especificó un monto
    if (($resultado['exito'] ?? false) && isset($inscripcion['monto_pagado']) && $inscripcion['monto_pagado'] > 0) {
        // Incluir el archivo donde está registrarPago()
        include_once "funciones_miembros.php";

        // Obtener el ID de la clase desde el horario
        $idClase = obtenerIdClaseDeHorario($inscripcion['id_horario']);

        $pagoData = [
            'matricula' => $inscripcion['id_miembro'],
            'id_clase' => $idClase,
            'id_horario' => $inscripcion['id_horario'],
            'idUsuario' => $inscripcion['id_usuario_registro'] ?? 1,
            'fecha' => $inscripcion['fecha_inscripcion'],
            'pago' => $inscripcion['monto_pagado']
        ];

        // Convertir a objeto para registrarPago si es necesario
        $pagoObj = (object) $pagoData;

        // Llamar a la función existente registrarPago()
        registrarPago($pagoObj);
    }

    return [
        'exito' => $resultado['exito'] ?? false,
        'mensaje' => ($resultado['exito'] ?? false) ? 'Miembro agregado exitosamente' : 'Error al agregar miembro',
        'id' => $resultado['id'] ?? null
    ];
}

function obtenerIdClaseDeHorario($idHorario)
{
    $sentencia = "SELECT id_clase FROM horarios_clases WHERE id = ?";
    $resultado = selectPrepare($sentencia, [$idHorario]);
    return !empty($resultado) ? $resultado[0]['id_clase'] : null;
}


function eliminarMiembroDeClase($idInscripcion)
{
    $sentencia = "DELETE FROM reservas_clases WHERE id = ?";
    return eliminar($sentencia, [$idInscripcion]);
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
