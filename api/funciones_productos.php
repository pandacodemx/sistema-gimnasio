<?php
include_once "base_datos.php";

function registrarProducto($producto)
{

    $rutaImagen = guardarImagenBase64($producto->imagen);

    $sentencia = "INSERT INTO productos (nombre, descripcion, precio, stock, categoria, imagen) VALUES (?, ?, ?, ?, ?, ?)";
    $parametros = [
        $producto->nombre,
        $producto->descripcion,
        $producto->precio,
        $producto->stock,
        $producto->categoria,
        $rutaImagen
    ];
    return insertar($sentencia, $parametros);
}

function obtenerProductos()
{
    $sentencia = "SELECT * FROM productos ORDER BY id DESC";
    return selectQuery($sentencia);
}

function eliminarProducto($id)
{
    try {
        $sentencia = "DELETE FROM productos WHERE id = ?";
        return eliminar($sentencia, $id);
    } catch (PDOException $e) {
        if ($e->getCode() == '23000') {
            return [
                "error" => true,
                "mensaje" => "No se puede eliminar el producto porque está relacionado con una venta."
            ];
        } else {
            return [
                "error" => true,
                "mensaje" => "Ocurrió un error al intentar eliminar el producto."
            ];
        }
    }
}

function editarProducto($producto)
{
    $rutaImagen = guardarImagenBase64($producto->imagen);
    if (!$rutaImagen) {
        $rutaImagen = $producto->imagen;
    }
    $sentencia = "UPDATE productos SET nombre = ?, descripcion = ?, precio = ?, stock = ?, categoria = ?, imagen = ? WHERE id = ?";
    $parametros = [
        $producto->nombre,
        $producto->descripcion,
        $producto->precio,
        $producto->stock,
        $producto->categoria,
        $rutaImagen,
        $producto->id
    ];
    return editar($sentencia, $parametros);
}

function guardarImagenBase64($imagenBase64)
{
    // Si no hay imagen, salir
    if (!$imagenBase64) return null;

    // Separar el tipo y los datos
    if (preg_match('/^data:image\/(\w+);base64,/', $imagenBase64, $tipo)) {
        $imagenBase64 = substr($imagenBase64, strpos($imagenBase64, ',') + 1);
        $extension = strtolower($tipo[1]); // jpg, png, etc.

        // Verificar extensiones válidas
        if (!in_array($extension, ['jpg', 'jpeg', 'png', 'gif'])) {
            return null;
        }

        // Decodificar y guardar
        $imagenBase64 = base64_decode($imagenBase64);
        if ($imagenBase64 === false) return null;

        // Crear nombre único
        $nombreArchivo = uniqid() . '.' . $extension;
        $ruta = 'uploads/' . $nombreArchivo;

        // Guardar archivo
        file_put_contents($ruta, $imagenBase64);

        return $ruta;
    }

    return null;
}
