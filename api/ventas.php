<?php
include_once "encabezado.php";

$payload = json_decode(file_get_contents("php://input"));
if (!$payload) {
    http_response_code(500);
    exit;
}

include_once "funciones_ventas.php";

$metodo = $payload->metodo;

switch ($metodo) {
    case "post":
        echo json_encode(registrarVenta($payload->venta));
        break;
    case "get":
        echo json_encode(obtenerVentas());
        break;
    case "delete":
        echo json_encode(eliminarVenta($payload->id));
        break;
    case "put":
        echo json_encode(editarVenta($payload->venta));
        break;
}
