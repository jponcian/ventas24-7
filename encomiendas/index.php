<!DOCTYPE html>
<html lang="en">

<head>
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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Autorizaciones</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Select2 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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

        .select2-container--bootstrap-5 .select2-selection {
            border: 2px solid #0d6efd !important;
            border-radius: 0.375rem !important;
            min-height: 38px !important;
            padding-right: 2.5rem !important;
        }

        .select-arrow {
            position: absolute;
            right: 18px;
            top: 50%;
            transform: translateY(-50%);
            pointer-events: none;
            color: #0d6efd;
            font-size: 1.2rem;
        }

        .select2-container {
            position: relative;
            width: 100% !important;
        }

        .card.shadow {
            background: rgba(255, 255, 255, 0.92);
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.15);
        }
    </style>
</head>

<body class="bg-light">
    <div class="container mt-5">
        <div class="text-center mb-4">
            <h2 class="titulo-resaltado">Bienvenido a <br>Autorizacion de Retiro de Encomiendas</h2>
        </div>
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow">
                    <div class="card-body">

                        <a href="usuario.html" class="btn btn-success mb-3">
                            <i class="bi bi-person-plus"></i> Registrar Usuario
                        </a>
                        <form id="form-autorizacion" action="generar_pdf.php" method="post" target="_blank">
                            <div class="mb-3">
                                <label for="destinatario" class="form-label">
                                    <i class="bi bi-person"></i> Selecciona el destinatario:
                                </label>
                                <select name="id_destinatario" id="destinatario" class="form-select select2">
                                    <?php
                                    include 'conexion.php';
                                    $usuarios_js = [];
                                    $consulta = "SELECT id, nombre FROM usuarios ORDER BY nombre ASC";
                                    $resultado = mysqli_query($conn, $consulta);
                                    while ($fila = mysqli_fetch_assoc($resultado)) {
                                        echo '<option value="' . $fila['id'] . '">' . $fila['nombre'] . '</option>';
                                        $usuarios_js[] = [
                                            'id' => $fila['id'],
                                            'nombre' => $fila['nombre']
                                        ];
                                    }
                                    ?>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="autorizado" class="form-label">
                                    <i class="bi bi-person-check"></i> Selecciona el autorizado:
                                </label>
                                <select name="id_autorizado" id="autorizado" class="form-select select2">
                                    <?php
                                    // Las opciones se cargarán dinámicamente con JS
                                    ?>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="track" class="form-label">
                                    <i class="bi bi-truck"></i> Guia:
                                </label>
                                <input type="text" name="track" id="track" class="form-control">
                            </div>
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-file-earmark-pdf"></i> Generar Autorizacion
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Bootstrap JS Bundle (incluye Popper) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script>
        // Array de usuarios generado por PHP
        var usuarios = <?php echo json_encode($usuarios_js); ?>;

        function cargarAutorizados(excluirId) {
            var $autorizado = $('#autorizado');
            $autorizado.empty();
            usuarios.forEach(function(usuario) {
                if (usuario.id != excluirId) {
                    $autorizado.append('<option value="' + usuario.id + '">' + usuario.nombre + '</option>');
                }
            });
            $autorizado.val(null).trigger('change');
        }

        $(document).ready(function() {
            $('.select2').select2();
            // Inicializar autorizados excluyendo el primero seleccionado
            var inicial = $('#destinatario').val();
            cargarAutorizados(inicial);

            $('#destinatario').on('change', function() {
                var seleccionado = $(this).val();
                cargarAutorizados(seleccionado);
            });

            $('#form-autorizacion').on('submit', function(e) {
                var guia = $('#track').val().trim();
                if (guia === '') {
                    e.preventDefault();
                    Swal.fire({
                        title: '¿Continuar sin número de guía?',
                        text: 'El campo guía está vacío. ¿Desea continuar?',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonText: 'Sí, continuar',
                        cancelButtonText: 'Cancelar'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            this.submit();
                        }
                    });
                }
            });
        });
    </script>
    <footer class="text-center text-muted mt-5 mb-2">
        versión 1.3
    </footer>
</body>

</html>