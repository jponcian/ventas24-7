<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventario Bajo</title>
    <link rel="stylesheet" href="style.css">
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 20px;
            background: #f4f6fb;
        }

        .proveedor-section {
            margin-bottom: 32px;
            border: none;
            box-shadow: 0 2px 12px #0002;
            padding: 18px 18px 12px 18px;
            border-radius: 16px;
            background: #fff;
        }

        .proveedor-title {
            font-size: 1.25em;
            margin-bottom: 14px;
            color: #1976d2;
            font-weight: bold;
            letter-spacing: 0.5px;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: #f8f9fa;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 1px 8px #0001;
        }

        th {
            padding: 12px 14px;
            background: linear-gradient(90deg, #1976d2 80%, #42a5f5 100%);
            color: #fff;
            font-size: 1em;
            font-weight: 600;
            border: none;
        }

        td {
            padding: 10px 14px;
            font-size: 0.98em;
            border: none;
            background: #fff;
            transition: background 0.2s;
        }

        tbody tr {
            border-radius: 8px;
            box-shadow: 0 1px 4px #0001;
        }

        tbody tr:nth-child(odd) td {
            background: #e3f2fd;
        }

        tbody tr:hover td {
            background: #bbdefb;
        }

        td {
            border-bottom: 1px solid #e0e0e0;
        }

        td:last-child {
            border-right: none;
        }

        th:first-child {
            border-radius: 12px 0 0 0;
        }

        th:last-child {
            border-radius: 0 12px 0 0;
        }

        @media (max-width: 600px) {
            .proveedor-section {
                padding: 10px 4px 8px 4px;
                border-radius: 10px;
            }

            table {
                font-size: 0.95em;
                border-radius: 8px;
            }

            th,
            td {
                padding: 8px 6px;
            }
        }
    </style>
</head>

<body>

    <h1>Inventario Bajo</h1>

    <?php
    require_once __DIR__ . '/db.php';

    // Obtener productos con bajo inventario
    $productos = array_filter(obtenerProductos(1), function ($p) {
        return isset($p['bajo_inventario']) && $p['bajo_inventario'] == 1;
    });

    // Agrupar por proveedor
    $agrupados = [];
    foreach ($productos as $p) {
        $prov = $p['proveedor_nombre'] ?? $p['proveedor'] ?? '(Sin proveedor)';
        if (!isset($agrupados[$prov]))
            $agrupados[$prov] = [];
        $agrupados[$prov][] = $p;
    }

    if (empty($agrupados)) {
        echo "<p>No hay productos con bajo inventario en este momento.</p>";
    } else {
        foreach ($agrupados as $proveedor => $lista) {
            // Ordenar alfabéticamente por nombre
            usort($lista, function ($a, $b) {
                return strcasecmp($a['nombre'], $b['nombre']);
            });
            // Generar lista de nombres para copiar
            $nombres = array_map(function ($p) {
                return $p['nombre'];
            }, $lista);
            $nombres_str = htmlspecialchars(implode("\n", $nombres));
            $proveedor_id = md5($proveedor);
    ?>
            <div class="proveedor-section">
                <h2 class="proveedor-title">Proveedor: <?php echo htmlspecialchars($proveedor); ?></h2>
                <button class="btn-copiar" data-nombres="<?php echo $nombres_str; ?>" data-proveedor="<?php echo $proveedor_id; ?>" style="margin-bottom:12px;padding:7px 14px;background:#1976d2;color:#fff;border:none;border-radius:5px;cursor:pointer;display:inline-flex;align-items:center;gap:4px;">
                    <i class="fa-solid fa-copy" style="font-size:1.2em;"></i>
                </button>
                <span id="copiado-<?php echo $proveedor_id; ?>" style="display:none;color:green;margin-left:8px;font-size:1.2em;"><i class="fa-solid fa-check"></i></span>
                <table>
                    <thead>
                        <tr>
                            <th>Nombre</th>
                            <th>Unidad</th>
                            <th>Precio</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($lista as $p):
                            $nombre = htmlspecialchars($p['nombre']);
                            $unidad = isset($p['unidad_medida']) ? htmlspecialchars($p['unidad_medida']) : '';
                            $precio = $p['precio_venta_unidad'] ?
                                (($p['moneda_base'] === 'BS') ? number_format($p['precio_venta_unidad'], 2) . ' Bs' : '$' . number_format($p['precio_venta_unidad'], 2)) : '';
                        ?>
                            <tr>
                                <td><?php echo $nombre; ?></td>
                                <td style="text-align: center;"><?php echo $unidad; ?></td>
                                <td style="text-align: center;"><?php echo $precio; ?></td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
    <?php
        }
    }
    ?>


    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>
    <script>
        document.querySelectorAll('.btn-copiar').forEach(btn => {
            btn.addEventListener('click', function() {
                const nombres = this.getAttribute('data-nombres');
                navigator.clipboard.writeText(nombres).then(() => {
                    const proveedorId = this.getAttribute('data-proveedor');
                    const copiadoSpan = document.getElementById('copiado-' + proveedorId);
                    if (copiadoSpan) {
                        copiadoSpan.style.display = 'inline';
                        setTimeout(() => {
                            copiadoSpan.style.display = 'none';
                        }, 1800);
                    }
                });
            });
        });
    </script>

</body>

</html>