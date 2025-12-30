<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="UTF-8">
  <title>Registro de Usuario</title>
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
  <!-- SweetAlert2 -->
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body class="bg-light">
  <div class="container mt-5">
    <?php
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
      $nombre = strtoupper($_POST["nombre"]);
      $cedula = $_POST["cedula"];
      $telefono = $_POST["telefono"];
      $foto_nombre = $_FILES["foto"]["name"];
      $foto_temporal = $_FILES["foto"]["tmp_name"];
      $foto_destino = "uploads/" . $cedula . ".jpeg"; // Carpeta para guardar las imágenes
      include 'conexion.php';

      if (move_uploaded_file($foto_temporal, $foto_destino)) {
        $consulta = $conn->prepare("INSERT INTO usuarios (nombre, cedula, telefono, foto) VALUES (?, ?, ?, ?)");
        $consulta->bind_param("ssss", $nombre, $cedula, $telefono, $foto_destino);
        if ($consulta->execute()) {
          echo '<script>
                        Swal.fire({
                            icon: "success",
                            title: "Registro exitoso",
                            text: "El usuario ha sido registrado correctamente.",
                            confirmButtonText: "Aceptar"
                        }).then(() => {
                            window.location.href = "index.php";
                        });
                    </script>';
        } else {
          echo '<script>
                        Swal.fire({
                            icon: "error",
                            title: "Error",
                            text: "Error al registrar: ' . $consulta->error . '"
                        }).then(() => {
                            window.location.href = "registro.php";
                        });
                    </script>';
        }
        $consulta->close();
      } else {
        echo '<script>
                    Swal.fire({
                        icon: "error",
                        title: "Error",
                        text: "Error al subir la imagen."
                    }).then(() => {
                        window.location.href = "registro.php";
                    });
                </script>';
      }

      $conn->close();
    }
    ?>
  </div>
</body>

</html>