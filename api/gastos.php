<?php
include_once "base_datos.php";

$input = json_decode(file_get_contents('php://input'), true);

if ($input['metodo'] === 'registrarGasto') {
    $descripcion = $input['gasto']['descripcion'];
    $monto = $input['gasto']['monto'];
    $id_usuario = $_SESSION['id_usuario'] ?? null; // si tienes sesión activa

    $stmt = $conn->prepare("INSERT INTO gastos (descripcion, monto, id_usuario) VALUES (?, ?, ?)");
    $stmt->bind_param("sdi", $descripcion, $monto, $id_usuario);

    if ($stmt->execute()) {
        echo json_encode(true);
    } else {
        echo json_encode(false);
    }
}
