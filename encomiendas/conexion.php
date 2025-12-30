<?php
// conexion.php
$host = 'localhost';
$usuario = 'ponciano';
$contrasena = 'Prueba016.';
$base_de_datos = 'javier_ponciano_4';

$conn = new mysqli($host, $usuario, $contrasena, $base_de_datos);

if ($conn->connect_error) {
    die('Error de conexión: ' . $conn->connect_error);
}
