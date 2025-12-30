<script>
    document.addEventListener('DOMContentLoaded', function() {
        var telInput = document.getElementById('telefono');
        telInput.addEventListener('input', function() {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    });
</script>
<?php
include 'conexion.php';
$cedula = isset($_GET['cedula']) ? $_GET['cedula'] : '';
$usuario = null;
if ($cedula) {
    $consulta = $conn->prepare("SELECT id, nombre, cedula, telefono, foto FROM usuarios WHERE cedula = ? LIMIT 1");
    $consulta->bind_param("s", $cedula);
    $consulta->execute();
    $resultado = $consulta->get_result();
    $usuario = $resultado->fetch_assoc();
    $consulta->close();
}
$conn->close();
?>
<!DOCTYPE html>
<html lang="es">

<head>
    <script>
        function validarFormulario(e) {
            const cedula = document.getElementById('cedula').value.trim();
            const nombre = document.getElementById('nombre').value.trim();
            const telefono = document.getElementById('telefono').value.trim();
            let errores = [];
            if (!/^\d{6,}$/.test(cedula)) {
                errores.push('La cédula debe tener al menos 6 dígitos.');
            }
            if (!/^([A-Za-zÁÉÍÓÚáéíóúÑñ ]{3,})$/.test(nombre)) {
                errores.push('El nombre debe tener al menos 3 letras y solo letras y espacios.');
            }
            if (!/^\d{10,15}$/.test(telefono)) {
                errores.push('El teléfono debe tener entre 10 y 15 dígitos.');
            }
            if (errores.length > 0) {
                e.preventDefault();
                alert(errores.join('\n'));
                return false;
            }
            return true;
        }
    </script>
    <script>
        const fondosPaisaje = [
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1500&q=80',
            'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=1500&q=80',
            'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1500&q=80',
            'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=1500&q=80',
            'https://images.unsplash.com/photo-1444065381814-865dc9da92c0?auto=format&fit=crop&w=1500&q=80'
        ];
        document.addEventListener('DOMContentLoaded', function() {
            var fondoAleatorio = fondosPaisaje[Math.floor(Math.random() * fondosPaisaje.length)];
            document.body.style.backgroundImage = 'url(' + fondoAleatorio + ')';
        });
    </script>
    <style>
        .titulo-resaltado {
            background: rgba(255, 255, 255, 0.85);
            color: #0d6efd;
            font-weight: bold;
            font-size: 2.2rem;
            padding: 0.7em 0.5em;
            border-radius: 0.5em;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.10);
            display: inline-block;
        }

        body.bg-light {
            background: #eaf6fb no-repeat center center fixed;
            background-size: cover;
            transition: background-image 1s ease;
        }

        .card.shadow,
        .p-3.rounded.shadow.bg-white {
            background: rgba(255, 255, 255, 0.92);
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.15);
        }
    </style>
    <meta charset="UTF-8">
    <title>Editar Usuario</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
</head>

<body class="bg-light">
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-12 col-sm-10 col-md-8 col-lg-6">
                <a href="usuario.html" class="btn btn-secondary mb-3 w-100"><i class="bi bi-arrow-left"></i> Volver</a>
                <div class="text-center mb-4">
                    <h2 class="titulo-resaltado"><i class="bi bi-pencil-square"></i> Editar Usuario</h2>
                </div>
                <?php if ($usuario): ?>
                    <form action="actualizar_usuario.php" method="post" enctype="multipart/form-data" class="p-3 rounded shadow bg-white">
                        <input type="hidden" name="id" value="<?php echo $usuario['id']; ?>">
                        <div class="mb-3">
                            <label for="cedula" class="form-label"><i class="bi bi-card-text"></i> Cedula:</label>
                            <input type="number" name="cedula" id="cedula" class="form-control" value="<?php echo $usuario['cedula']; ?>" readonly required pattern="[0-9]{6,}" minlength="6">
                        </div>
                        <div class="mb-3">
                            <label for="nombre" class="form-label"><i class="bi bi-person"></i> Nombre y Apellido:</label>
                            <input type="text" name="nombre" id="nombre" class="form-control" value="<?php echo $usuario['nombre']; ?>" required pattern="[A-Za-zÁÉÍÓÚáéíóúÑñ ]{3,}" minlength="3" autocomplete="off">
                        </div>
                        <div class="mb-3">
                            <label for="telefono" class="form-label"><i class="bi bi-telephone"></i> Teléfono:</label>
                            <input type="tel" name="telefono" id="telefono" class="form-control" value="<?php echo $usuario['telefono']; ?>" required pattern="[0-9]{10,15}" maxlength="15" minlength="10" autocomplete="off" placeholder="Ej: 04141234567">
                        </div>
                        <div class="mb-3">
                            <label for="foto" class="form-label"><i class="bi bi-image"></i> Foto de Cedula:</label>
                            <?php if ($usuario['foto']): ?>
                                <img src="<?php echo $usuario['foto']; ?>" alt="Foto actual" style="max-width:120px;max-height:80px;" class="mb-2"><br>
                            <?php endif; ?>
                            <input type="file" name="foto" id="foto" class="form-control" accept=".jpg,.jpeg,image/jpeg,image/jpg">
                            <small class="text-muted">Si no selecciona una nueva foto, se mantendrá la actual.</small>
                        </div>
                        <button type="submit" class="btn btn-primary w-100"><i class="bi bi-save"></i> Guardar Cambios</button>
                    </form>
                    <script>
                        document.querySelector('form').addEventListener('submit', validarFormulario);
                    </script>
                    </form>
                <?php else: ?>
                    <div class="alert alert-danger">Usuario no encontrado.</div>
                <?php endif; ?>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>