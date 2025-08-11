<?php
include_once "encabezado.php";
$payload = json_decode(file_get_contents("php://input"));

if (!$payload) {
    http_response_code(500);
    exit;
}

include_once "funciones_clases.php";

$metodo = $payload->metodo;

switch ($metodo) {
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
        echo json_encode(obtenerHorarios(
            $payload->fecha_inicio,
            $payload->fecha_fin
        ));
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

    default:
        http_response_code(404);
        break;
}
