<?php
include_once "encabezado.php";

$payload = json_decode(file_get_contents("php://input"));
if (!$payload) {
    http_response_code(500);
    exit;
}

include_once "funciones_rutinas.php";

$metodo = $payload->metodo;

switch ($metodo) {
    case "post":
        echo json_encode(crearRutina($payload->rutina));
        break;
    case "get":
        echo json_encode(obtenerRutinas());
        break;
    case "get_by_id":
        echo json_encode(obtenerRutinaPorId($payload->id));
        break;
    case "delete":
        echo json_encode(eliminarRutina($payload->id));
        break;
    case "put":
        echo json_encode(actualizarRutina($payload->rutina));
        break;
    case "asignar":
        echo json_encode(asignarRutinaMiembro($payload->asignacion));
        break;
    case "obtener_asignadas":
        echo json_encode(obtenerRutinasAsignadas($payload->miembro_id));
        break;
    default:
        echo json_encode(['success' => false, 'message' => 'Método no válido']);
        break;
}
