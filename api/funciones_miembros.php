<?php
include_once "base_datos.php";
date_default_timezone_set('America/Mexico_City');

function registrarMiembro($miembro)
{
    $matricula = generarMatricula();
    $imagen = ($miembro->imagen) ? obtenerImagen($miembro->imagen) : './imagenes/usuario.png';
    $sentencia = "INSERT INTO miembros 
    (matricula, nombre, telefono, direccion, edad,
    sufreEnfermedad, tieneSeguro, enfermedad, institucion, 
    nombreContacto, telefonoContacto, imagen, fechaRegistro, afiliacion) 
    VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    $parametros = [
        $matricula,
        $miembro->nombre,
        $miembro->telefono,
        $miembro->direccion,
        $miembro->edad,
        $miembro->sufreEnfermedad,
        $miembro->tieneSeguro,
        $miembro->enfermedad,
        $miembro->institucion,
        $miembro->nombreContacto,
        $miembro->telefonoContacto,
        $imagen,
        date("Y-m-d H:i:s"),
        $miembro->afiliacion
    ];
    $resultado = insertar($sentencia, $parametros);
    if ($resultado) return $matricula;
}

function generarMatricula()
{
    $id = selectQuery("SELECT MAX(id) AS id FROM miembros")[0]->id;
    $ultimoId = $id + 1;
    return date('Y') . '-' . $ultimoId;
}

function obtenerMiembros()
{
    $sentencia = "SELECT miembros.*, membresias.nombre AS membresia 
    FROM miembros
    LEFT JOIN membresias ON membresias.id = miembros.idMembresia ";
    $miembros =  selectQuery($sentencia);
    return verificarMembresia($miembros);
}

function obtenerMiembrosDisponibles()
{
    $sentencia = "SELECT miembros.*, membresias.nombre AS membresia 
                 FROM miembros
                 LEFT JOIN membresias ON membresias.id = miembros.idMembresia WHERE miembros.estado = 'activo' 
                 ORDER BY miembros.nombre";

    $miembros = selectPrepare($sentencia);
    return verificarMembresia($miembros);
}

function obtenerMiembroNombreMatricula($busqueda)
{
    $sentencia = "SELECT miembros.*, membresias.nombre AS membresia, membresias.id AS idMembresia 
    FROM miembros
    LEFT JOIN membresias ON membresias.id = miembros.idMembresia
    WHERE (miembros.nombre LIKE ? OR miembros.matricula LIKE ?)";
    $parametros = ["%" . $busqueda . "%", "%" . $busqueda . "%"];
    return selectPrepare($sentencia, $parametros);
}

function registrarPago($pago)
{

    if (is_object($pago)) {
        $pago = (array) $pago;
    }

    $tipo = (isset($pago['id_clase']) || isset($pago['id_horario'])) ? 'clase' : 'membresia';
    $idMembresia = ($tipo === 'membresia') ? ($pago['idMembresia'] ?? null) : null;

    $sentencia = "INSERT INTO pagos (matricula, idMembresia, id_clase, id_horario, idUsuario, fecha, monto, tipo) 
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    $parametros = [
        $pago['matricula'] ?? null,
        $idMembresia,
        $pago['id_clase'] ?? null,
        $pago['id_horario'] ?? null,
        $pago['idUsuario'] ?? 1,
        $pago['fecha'] ?? date('Y-m-d'),
        $pago['pago'] ?? 0,
        $tipo
    ];

    $pagoRegistrado = insertar($sentencia, $parametros);

    // Si es membresía, actualizar la membresía del miembro
    if ($pagoRegistrado && $tipo === 'membresia') {
        return actualizarMembresia(
            $pago['matricula'],
            $pago['idMembresia'],
            $pago['duracion'] ?? 30,
            $pago['fecha'] ?? date('Y-m-d')
        );
    }

    return $pagoRegistrado;
}

function actualizarMembresia($matricula, $idMembresia, $duracion, $fechaInicio)
{
    $sentencia = "UPDATE miembros SET idMembresia = ?, estado = ?, fechaInicio = ?, fechaFin = DATE_ADD(?, INTERVAL ? DAY) WHERE matricula = ? ";
    $parametros = [$idMembresia, 'ACTIVO', $fechaInicio, $fechaInicio, $duracion, $matricula];
    return editar($sentencia, $parametros);
}

function verificarMembresia($miembros)
{
    foreach ($miembros as $miembro) {
        if ($miembro->fechaFin < date("Y-m-d H:i:s")) {
            marcarMembresiaVencida($miembro->id);
        }
    }
    return $miembros;
}

function marcarMembresiaVencida($id)
{
    $sentencia = "UPDATE miembros SET estado = ? WHERE id = ?";
    $parametros = ['VENCIDO', $id];
    editar($sentencia, $parametros);
}

function obtenerPorId($id)
{
    $sentencia = "SELECT * FROM miembros WHERE id = ?";
    $parametros = [$id];
    return selectPrepare($sentencia, $parametros)[0];
}

function eliminarMiembro($id)
{
    $sentencia = "DELETE FROM miembros WHERE id = ?";
    return eliminar($sentencia, $id);
}

function editarMiembro($miembro)
{
    $miembro->imagen = ($miembro->imagenCambia) ? obtenerImagen($miembro->imagen) : $miembro->imagen;
    $sentencia =  "UPDATE miembros SET nombre = ?, telefono = ?, direccion = ?, edad = ?,
    sufreEnfermedad = ?, tieneSeguro = ?, enfermedad = ?, institucion = ?, 
    nombreContacto = ?, telefonoContacto = ?, afiliacion = ?, imagen = ? WHERE id = ?";
    $parametros = [
        $miembro->nombre,
        $miembro->telefono,
        $miembro->direccion,
        $miembro->edad,
        $miembro->sufreEnfermedad,
        $miembro->tieneSeguro,
        $miembro->enfermedad,
        $miembro->institucion,
        $miembro->nombreContacto,
        $miembro->telefonoContacto,
        $miembro->afiliacion,
        $miembro->imagen,
        $miembro->id
    ];
    return editar($sentencia, $parametros);
}

function obtenerImagenPorMatricula($matricula)
{
    $sentencia  = "SELECT imagen FROM miembros WHERE matricula = ?";
    return selectPrepare($sentencia, [$matricula])[0];
}

function obtenerHistorialPagos($matricula)
{
    $sentencia = "SELECT pagos.*, membresias.nombre AS nombreMembresia, usuarios.nombre AS nombreUsuario
        FROM pagos
        LEFT JOIN membresias ON membresias.id = pagos.idMembresia
        LEFT JOIN usuarios ON usuarios.id = pagos.idUsuario
        WHERE pagos.matricula = ?
        ORDER BY pagos.fecha DESC";

    return selectPrepare($sentencia, [$matricula]);
}
function obtenerEstadoCuentaMiembro($matricula)
{
    $sentencia = "
        SELECT p.fecha, m.nombre AS nombre_membresia, p.monto, u.usuario AS cobrado_por
        FROM pagos p
        JOIN membresias m ON p.idMembresia = m.id
        JOIN usuarios u ON p.idUsuario = u.id
        WHERE p.matricula = ?
        ORDER BY p.fecha DESC
    ";

    return selectPrepare($sentencia, [$matricula]);
}

function obtenerMembresiasPorVencer($dias = 7)
{
    $sentencia = "
        SELECT m.matricula, m.nombre, m.telefono, m.fechaFin, me.nombre AS nombre_membresia
        FROM miembros m
        JOIN membresias me ON m.idMembresia = me.id
        WHERE m.fechaFin IS NOT NULL 
          AND m.fechaFin BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL ? DAY)
        ORDER BY m.fechaFin ASC
    ";
    return selectPrepare($sentencia, [$dias]);
}

function quitarMembresia($idMiembro)
{

    $sentencia = "UPDATE miembros SET 
        idMembresia = NULL, 
        estado = NULL, 
        fechaInicio = NULL, 
        fechaFin = NULL
        WHERE id = ?";

    $parametros = [$idMiembro];
    return editar($sentencia, $parametros);
}
