<?php
include_once "encabezado.php";
$payload = json_decode(file_get_contents("php://input"));
date_default_timezone_set('America/Mexico_City');

if (!$payload) {
    http_response_code(400);
    echo json_encode(['error' => 'Datos no proporcionados']);
    exit;
}

include_once "funciones_clases.php";

$metodo = $payload->metodo;

switch ($payload->metodo) {
    case "obtener_clases":
        echo json_encode(obtenerClases());
        break;

    case "obtener_instructores":
        echo json_encode(obtenerInstructores());
        break;

    case "obtener_salas":
        echo json_encode(obtenerSalas());
        break;

    case "obtener_horarios":
        if (!isset($payload->fecha_inicio) || !isset($payload->fecha_fin)) {
            http_response_code(400);
            echo json_encode(['error' => 'Fechas no proporcionadas']);
            exit;
        }

        $horarios = obtenerHorarios($payload->fecha_inicio, $payload->fecha_fin);
        echo json_encode($horarios);
        break;

    case "crear_clase":
        echo json_encode(crearClase($payload->clase));
        break;

    case "programar_horario":
        echo json_encode(programarHorario($payload->horario));
        break;

    case "registrar_reserva":
        echo json_encode(registrarReserva($payload->reserva));
        break;

    case "crear_instructor":
        echo json_encode(crearInstructor($payload->instructor));
        break;

    case "actualizar_instructor":
        echo json_encode(actualizarInstructor($payload->instructor));
        break;

    case "eliminar_instructor":
        echo json_encode(eliminarInstructor($payload->id));
        break;
    case "crear_sala":
        echo json_encode(crearSala($payload->sala));
        break;

    case "actualizar_sala":
        echo json_encode(actualizarSala($payload->sala));
        break;

    case "eliminar_sala":
        echo json_encode(eliminarSala($payload->id));
        break;

    case "obtener_salas":
        echo json_encode(obtenerSalas());
        break;
    case "obtener_miembros_inscritos":
        echo json_encode(obtenerMiembrosInscritos($payload->id_horario));
        break;

    case "agregar_miembro_clase":
        echo json_encode(agregarMiembroAClase($payload->inscripcion));
        break;

    case "eliminar_miembro_clase":
        echo json_encode(eliminarMiembroDeClase($payload->id_inscripcion));
        break;

    case "verificar_reserva_usuario":
        echo json_encode(verificarReservaUsuario($payload->id_horario, $payload->id_usuario));
        break;

    default:
        http_response_code(404);
        break;
}
