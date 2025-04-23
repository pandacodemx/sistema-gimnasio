<?php
// Configuración de conexión a la base de datos
$conexion = new mysqli("localhost", "root", "", "sistema_gimnasio");
if ($conexion->connect_error) {
    die("Error en la conexión: " . $conexion->connect_error);
}

// Función para enviar WhatsApp con CallMeBot
function enviarWhatsApp($telefono, $mensaje)
{
    $apiKey = 5877750;
    $telefono = urlencode($telefono);
    $mensaje = urlencode($mensaje);
    $url = "https://api.callmebot.com/whatsapp.php?phone=$telefono&text=$mensaje&apikey=$apiKey";
    return file_get_contents($url);
}

// Fecha actual y fecha en 3 días
$hoy = date("Y-m-d");
$proximaFecha = date("Y-m-d", strtotime("+3 days"));

// Consultamos miembros cuyas membresías vencen entre hoy y dentro de 3 días
$sql = "SELECT m.id, m.nombre, m.telefono, m.fechaFin
        FROM miembros m
        WHERE fechaFin BETWEEN '$hoy' AND '$proximaFecha'";

$resultado = $conexion->query($sql);

// Recorremos los resultados
while ($row = $resultado->fetch_assoc()) {
    $idMiembro = $row["id"];
    $telefono = $row["telefono"];
    $nombre = $row["nombre"];
    $fechaFin = date("d/m/Y", strtotime($row["fechaFin"]));

    $mensaje = "Hola $nombre 👋. Te recordamos que tu membresía vence el día $fechaFin. ¡Esperamos verte pronto en el gimnasio! 💪";

    // Enviamos el WhatsApp
    $respuesta = enviarWhatsApp($telefono, $mensaje);
    echo "Mensaje enviado a $nombre ($telefono): $respuesta\n";

    $stmt = $conexion->prepare("INSERT INTO recordatorios_enviados (id_miembro, nombre, telefono, fecha_envio, fecha_vencimiento, mensaje) VALUES (?, ?, ?, NOW(), ?, ?)");
    $stmt->bind_param("issss", $idMiembro, $nombre, $telefono, $row["fechaFin"], $mensaje);
    $stmt->execute();
    $stmt->close();
}

$conexion->close();
