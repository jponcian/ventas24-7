<?php
// Configuración básica
$configFile = __DIR__ . '/bodega/config.php';
$dbFile = __DIR__ . '/bodega/db.php';

// Si no existe config.php, intentar usar valores por defecto o pedir entrada
if (file_exists($configFile)) {
    require_once $configFile;
} else {
    // Valores por defecto para la conexión
    $host = 'localhost';
    $dbname = 'javier_ponciano_4';
    $user = 'ponciano';
    $pass = 'Prueba016.';
}

try {
    $db = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $user, $pass);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (Exception $e) {
    die("Error de conexión: " . $e->getMessage());
}

$message = "";

// Procesar formulario
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    
    if ($action === 'create_negocio') {
        $nombre = trim($_POST['nombre']);
        if ($nombre) {
            $stmt = $db->prepare("INSERT INTO negocios (nombre, activo) VALUES (?, 1)");
            if ($stmt->execute([$nombre])) {
                $message = "Negocio '$nombre' creado correctamente.";
            } else {
                $message = "Error al crear negocio.";
            }
        }
    } elseif ($action === 'create_user') {
        $cedula = trim($_POST['cedula']);
        $nombre = trim($_POST['nombre_completo']);
        $password = $_POST['password'];
        $rol = $_POST['rol'];
        $negocio_id = $_POST['negocio_id'];
        
        if ($cedula && $nombre && $password) {
            $hash = password_hash($password, PASSWORD_DEFAULT);
            $stmt = $db->prepare("INSERT INTO users (negocio_id, cedula, nombre_completo, password_hash, rol, activo) VALUES (?, ?, ?, ?, ?, 1)");
            try {
                if ($stmt->execute([$negocio_id, $cedula, $nombre, $hash, $rol])) {
                    $message = "Usuario '$nombre' creado correctamente.";
                }
            } catch (Exception $e) {
                $message = "Error: " . $e->getMessage();
            }
        }
    }
}

// Obtener datos
$negocios = $db->query("SELECT * FROM negocios")->fetchAll(PDO::FETCH_ASSOC);
$users = $db->query("SELECT u.*, n.nombre as negocio FROM users u LEFT JOIN negocios n ON u.negocio_id = n.id")->fetchAll(PDO::FETCH_ASSOC);

?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administración del Sistema</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container py-5">
        <h1 class="mb-4 text-center">Panel de Administración</h1>
        
        <?php if ($message): ?>
            <div class="alert alert-info alert-dismissible fade show" role="alert">
                <?= htmlspecialchars($message) ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <?php endif; ?>

        <div class="row g-4">
            <!-- Sección Negocios -->
            <div class="col-md-6">
                <div class="card h-100 shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Gestión de Negocios</h5>
                    </div>
                    <div class="card-body">
                        <form method="POST" class="mb-4">
                            <input type="hidden" name="action" value="create_negocio">
                            <div class="input-group">
                                <input type="text" name="nombre" class="form-control" placeholder="Nombre del Negocio" required>
                                <button class="btn btn-success" type="submit">Crear</button>
                            </div>
                        </form>
                        
                        <h6>Negocios Existentes:</h6>
                        <ul class="list-group">
                            <?php foreach ($negocios as $n): ?>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <?= htmlspecialchars($n['nombre']) ?> 
                                    <span class="badge bg-secondary">ID: <?= $n['id'] ?></span>
                                </li>
                            <?php endforeach; ?>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Sección Usuarios -->
            <div class="col-md-6">
                <div class="card h-100 shadow-sm">
                    <div class="card-header bg-dark text-white">
                        <h5 class="mb-0">Gestión de Usuarios (Login)</h5>
                    </div>
                    <div class="card-body">
                        <form method="POST" class="mb-4">
                            <input type="hidden" name="action" value="create_user">
                            <div class="mb-3">
                                <label class="form-label">Negocio</label>
                                <select name="negocio_id" class="form-select" required>
                                    <?php foreach ($negocios as $n): ?>
                                        <option value="<?= $n['id'] ?>"><?= htmlspecialchars($n['nombre']) ?></option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Nombre Completo</label>
                                <input type="text" name="nombre_completo" class="form-control" required>
                            </div>
                            <div class="row mb-3">
                                <div class="col">
                                    <label class="form-label">Cédula (Usuario)</label>
                                    <input type="text" name="cedula" class="form-control" required>
                                </div>
                                <div class="col">
                                    <label class="form-label">Rol</label>
                                    <select name="rol" class="form-select">
                                        <option value="vendedor">Vendedor</option>
                                        <option value="admin">Admin</option>
                                        <option value="superadmin">Super Admin</option>
                                    </select>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Contraseña</label>
                                <input type="password" name="password" class="form-control" required>
                            </div>
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary">Crear Usuario</button>
                            </div>
                        </form>

                        <h6>Usuarios Existentes:</h6>
                        <div class="table-responsive" style="max-height: 200px;">
                            <table class="table table-sm table-bordered">
                                <thead>
                                    <tr>
                                        <th>Nombre</th>
                                        <th>Cédula</th>
                                        <th>Negocio</th>
                                        <th>Rol</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($users as $u): ?>
                                        <tr>
                                            <td><?= htmlspecialchars($u['nombre_completo']) ?></td>
                                            <td><?= htmlspecialchars($u['cedula']) ?></td>
                                            <td><?= htmlspecialchars($u['negocio'] ?? 'N/A') ?></td>
                                            <td><span class="badge bg-info text-dark"><?= $u['rol'] ?></span></td>
                                        </tr>
                                    <?php endforeach; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
