<?php
include_once "encabezado.php";

$payload = json_decode(file_get_contents("php://input"));
if (!$payload) {
    http_response_code(500);
    exit;
}

include_once "funciones_categorias_ejercicios.php";

$metodo = $payload->metodo;

switch ($metodo) {
    case "post":
        echo json_encode(registrarCategoria($payload->categoria));
        break;
    case "get":
        echo json_encode(obtenerCategorias());
        break;
    case "delete":
        echo json_encode(eliminarCategoria($payload->id));
        break;
    case "put":
        echo json_encode(editarCategoria($payload->categoria));
        break;
}
