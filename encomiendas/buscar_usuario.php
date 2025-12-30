<?php
header('Content-Type: application/json');
include 'conexion.php';

$cedula = isset($_GET['cedula']) ? $_GET['cedula'] : '';
$respuesta = ["existe" => false];

if ($cedula !== '') {
    $consulta = $conn->prepare("SELECT id, nombre, cedula, telefono, foto FROM usuarios WHERE cedula = ? LIMIT 1");
    $consulta->bind_param("s", $cedula);
    $consulta->execute();
    $resultado = $consulta->get_result();
    if ($usuario = $resultado->fetch_assoc()) {
        $respuesta["existe"] = true;
        $respuesta["usuario"] = $usuario;
    }
    $consulta->close();
}

$conn->close();
echo json_encode($respuesta);
