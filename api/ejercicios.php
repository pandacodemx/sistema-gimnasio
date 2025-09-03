<?php
include_once "encabezado.php";

$payload = json_decode(file_get_contents("php://input"));
if (!$payload) {
    http_response_code(500);
    exit;
}

include_once "funciones_ejercicios.php";

$metodo = $payload->metodo;

switch ($metodo) {
    case "post":
        echo json_encode(registrarEjercicio($payload->ejercicio));
        break;
    case "get":
        echo json_encode(obtenerEjercicios());
        break;
    case "delete":
        echo json_encode(eliminarEjercicio($payload->id));
        break;
    case "put":
        echo json_encode(editarEjercicio($payload->ejercicio));
        break;
}
