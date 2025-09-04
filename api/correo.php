<?php
include_once "encabezado.php";
include_once "phpmailer/PHPMailerAutoload.php";

$payload = json_decode(file_get_contents("php://input"));
if (!$payload) {
    http_response_code(500);
    exit;
}

function enviarRutinaPorCorreo($datos)
{
    // Obtener datos del miembro y la rutina
    $miembro = obtenerMiembro($datos->miembro_id);
    $rutina = obtenerRutina($datos->rutina_id);
    $asignacion = obtenerAsignacion($datos->asignacion_id);

    $mail = new PHPMailer;
    $mail->isSMTP();
    $mail->Host = 'tu-servidor-smtp.com';
    $mail->SMTPAuth = true;
    $mail->Username = 'tu-email@dominio.com';
    $mail->Password = 'tu-password';
    $mail->SMTPSecure = 'tls';
    $mail->Port = 587;

    $mail->setFrom('no-reply@gimnasio.com', 'Sistema Gimnasio');
    $mail->addAddress($miembro->email, $miembro->nombre);

    $mail->isHTML(true);
    $mail->Subject = 'Tu nueva rutina de entrenamiento - ' . $rutina->nombre;

    // Plantilla HTML del email
    $mail->Body = generarHtmlEmail($miembro, $rutina, $asignacion);
    $mail->AltBody = generarTextoEmail($miembro, $rutina, $asignacion);

    return $mail->send();
}
