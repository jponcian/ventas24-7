<?php
include 'conexion.php';
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $id = $_POST["id"];
    $nombre = strtoupper($_POST["nombre"]);
    $telefono = $_POST["telefono"];
    $cedula = $_POST["cedula"];
    $foto_destino = null;
    $foto_actual = null;

    // Obtener foto actual
    $consulta = $conn->prepare("SELECT foto FROM usuarios WHERE id = ? LIMIT 1");
    $consulta->bind_param("i", $id);
    $consulta->execute();
    $resultado = $consulta->get_result();
    if ($fila = $resultado->fetch_assoc()) {
        $foto_actual = $fila['foto'];
    }
    $consulta->close();

    // Procesar nueva foto si se subió
    if (isset($_FILES["foto"]) && $_FILES["foto"]["size"] > 0) {
        $foto_nombre = $_FILES["foto"]["name"];
        $foto_temporal = $_FILES["foto"]["tmp_name"];
        $foto_destino = "uploads/" . $cedula . ".jpeg";
        move_uploaded_file($foto_temporal, $foto_destino);
    } else {
        $foto_destino = $foto_actual;
    }

    // Actualizar datos
    $update = $conn->prepare("UPDATE usuarios SET nombre = ?, telefono = ?, foto = ? WHERE id = ?");
    $update->bind_param("sssi", $nombre, $telefono, $foto_destino, $id);
    if ($update->execute()) {
        echo '<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>';
        echo '<!DOCTYPE html><html><head><meta charset="utf-8"><script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script></head><body>';
        echo '<script>document.addEventListener("DOMContentLoaded", function() {Swal.fire({icon:"success",title:"Usuario actualizado",text:"Los datos se han guardado correctamente."}).then(()=>{window.location.href="index.php";});});</script>';
        echo '</body></html>';
    } else {
        echo '<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>';
        echo '<!DOCTYPE html><html><head><meta charset="utf-8"><script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script></head><body>';
        echo '<script>document.addEventListener("DOMContentLoaded", function() {Swal.fire({icon:"error",title:"Error",text:"No se pudo actualizar el usuario."}).then(()=>{window.location.href="index.php";});});</script>';
        echo '</body></html>';
    }
    $update->close();
    $conn->close();
}
