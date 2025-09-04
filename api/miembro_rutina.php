<?php
include_once "encabezado.php";

$payload = json_decode(file_get_contents("php://input"));
if (!$payload) {
    http_response_code(500);
    exit;
}

include_once "funciones_miembro_rutinas.php";

$metodo = $payload->metodo;

switch ($metodo) {
    case "asignar":
        echo json_encode(asignarRutinaMiembro($payload->asignacion));
        break;
    case "get_por_miembro":
        echo json_encode(obtenerRutinasPorMiembro($payload->miembro_id));
        break;
    case "get_activas":
        echo json_encode(obtenerRutinasActivas());
        break;
    case "desactivar":
        echo json_encode(desactivarRutina($payload->id));
        break;
}
