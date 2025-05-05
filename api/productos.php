<?php
include_once "encabezado.php";

$payload = json_decode(file_get_contents("php://input"));
if (!$payload) {
    http_response_code(500);
    exit;
}

include_once "funciones_productos.php";

$metodo = $payload->metodo;

switch ($metodo) {
    case "post":
        echo json_encode(registrarProducto($payload->producto));
        break;
    case "get":
        echo json_encode(obtenerProductos());
        break;
    case "delete":
        echo json_encode(eliminarProducto($payload->id));
        break;
    case "put":
        echo json_encode(editarProducto($payload->producto));
        break;
}
