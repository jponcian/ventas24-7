<!-- He eliminado el contenido anterior y lo he reemplazado con el código que implementa la nueva animación -->
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Bodega - móvil</title>
    <meta name="description" content="Gestión de inventario optimizada para móvil" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <!-- <link rel="stylesheet" href="style.css"> -->

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        @keyframes marquee {
            0% {
                transform: translateX(0);
            }

            100% {
                transform: translateX(-30%);
            }
        }

        .productos-grid {
            margin-top: 1.2em;
            margin-bottom: 1em;
            display: flex;
            justify-content: center;
            width: 100%;
            overflow-x: hidden;
            /* Eliminar el scroll horizontal */
        }

        .row.no-gutter {
            margin-right: 0;
            margin-left: 0;
        }

        .row.no-gutter>[class^='col-'],
        .row.no-gutter>.col {
            padding-right: 10px;
            padding-left: 10px;
        }

        .item.card {
            /* Allow card to fill container */
            box-shadow: 0 2px 12px 0 #1976d21a;
            border: none;
            background: #fff;
            transition: box-shadow 0.3s, transform 0.3s;
            border-radius: 0;
            /* No rounded corners for a seamless grid */
        }



        .item.card .fw-bold {
            color: #1976d2;
        }

        .item.card .text-success {
            color: #388e3c !important;
        }

        .item.card .text-primary {
            color: #1976d2 !important;
        }

        .empty {
            text-align: center;
            color: #888;
            font-size: 1.5em;
            margin-top: 2em;
        }

        .productos-separadas {
            margin-top: 2.5em;
        }

        html,
        body,
        .app,
        main {
            height: 100%;
            margin: 0;
            padding: 0;
            overflow: hidden;
            /* Evitar scroll */
        }

        .full-screen-grid {
            display: flex;
            flex-wrap: wrap;
            width: 100vw;
            height: 100vh;
            padding: 0;
            margin: 0;
        }

        .h-33 {
            height: 33.33%;
            padding: 5px !important;
            transition: all 0.5s ease-in-out;
        }

        .card-disappear {
            animation: fadeOutShrink 0.5s forwards;
        }

        @keyframes fadeOutShrink {
            from {
                opacity: 1;
                transform: scale(1);
            }

            to {
                opacity: 0;
                transform: scale(0);
                height: 0;
                padding: 0;
                margin: 0;
                border: none;
            }
        }

        .card-appear {
            animation: fadeIn 0.5s forwards;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }

            to {
                opacity: 1;
            }
        }
    </style>
    <?php
    // Zona horaria de Caracas, Venezuela
    if (function_exists('date_default_timezone_set')) {
        date_default_timezone_set('America/Caracas');
    }

    // Conexión manual a la base de datos (ajusta los datos según tu entorno)
    $host = 'localhost';
    $dbname = 'javier_ponciano_4';
    $user = 'ponciano';
    $pass = 'Prueba016.';
    $db = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
    ]);

    // Mostrar la tasa y fecha del día (si no hay para hoy, usar la más reciente anterior)
    function obtener_tasa_actual($db)
    {
        $hoy = date('Y-m-d');
        $stmt = $db->prepare("SELECT * FROM tasas_cambio WHERE fecha <= ? ORDER BY fecha DESC LIMIT 1");
        $stmt->execute([$hoy]);
        if ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            return [$row['valor'], $row['fecha']];
        }
        return [null, null];
    }
    list($tasa, $fecha_tasa) = obtener_tasa_actual($db);

    function mostrar_precio($valor, $moneda)
    {
        if ($valor === null) return '--';
        if (fmod($valor, 1) == 0.0) {
            return number_format($valor, 0) . ($moneda === 'BS' ? ' Bs' : ' $');
        } else {
            return number_format($valor, 2) . ($moneda === 'BS' ? ' Bs' : ' $');
        }
    }

    function render_product_card($i, $tasa)
    {
        $unidad = $i['unidad_medida'] ?? 'unidad';
        $precioPaquete = isset($i['precio_venta_paquete']) && $i['precio_venta_paquete'] !== '' ? (float)$i['precio_venta_paquete'] : null;
        $precioUnidad = isset($i['precio_venta_unidad']) && $i['precio_venta_unidad'] !== '' ? (float)$i['precio_venta_unidad'] : null;
        $nombre = htmlspecialchars($i['nombre'] ?? '', ENT_QUOTES, 'UTF-8');
        $moneda = isset($i['moneda_compra']) ? strtoupper($i['moneda_compra']) : 'USD';
        $precioUnidadBs = ($precioUnidad !== null && $moneda !== 'BS' && $tasa) ? $precioUnidad * $tasa : $precioUnidad;
        $precioPaqueteBs = ($precioPaquete !== null && $moneda !== 'BS' && $tasa) ? $precioPaquete * $tasa : $precioPaquete;
        $soloBs = ($moneda === 'BS');
        $dataAttrs = 'data-nombre="' . $nombre . '" data-preciounidad="' . ($soloBs ? mostrar_precio($precioUnidadBs, 'BS') : mostrar_precio($precioUnidad, $moneda)) . '" data-preciounidadbs="' . mostrar_precio($precioUnidadBs, 'BS') . '" data-preciopaquete="' . ($soloBs ? mostrar_precio($precioPaqueteBs, 'BS') : mostrar_precio($precioPaquete, $moneda)) . '" data-preciopaquetebs="' . mostrar_precio($precioPaqueteBs, 'BS') . '" data-solo-bs="' . ($soloBs ? '1' : '0') . '"';

        $html = '<div class="col-3 h-33">';
        $html .= '<div class="item card h-100 shadow p-2 producto-modal-trigger" tabindex="0" ' . $dataAttrs . ' style="background: linear-gradient(135deg, #e3f2fd 60%, #fff 100%); box-shadow: none; display:flex; flex-direction:column; justify-content:center; align-items:center; text-align:center; border: 1px solid #dee2e6;">';
        $html .= '<div class="fw-bold mb-2" style="font-size:1.5em; color:#1976d2; min-height:2.5em; letter-spacing:0.5px; padding: 0 10px;">' . $nombre . '</div>';
        $html .= '<div style="width:100%;">';
        if ($unidad === 'paquete' && !empty($i['tam_paquete']) && (int)$i['tam_paquete'] > 0) {
            $paquetePrecio = $precioPaquete !== null ? $precioPaquete : 0;
            $per = $paquetePrecio / (int)$i['tam_paquete'];
            $perBs = ($moneda !== 'BS' && $tasa) ? $per * $tasa : $per;
            if ($soloBs) {
                $html .= '<div class="mb-2"><span class="badge bg-primary px-3 py-2" style="font-size:1.2em;">c/u: ' . mostrar_precio(($precioUnidad !== null ? $precioUnidad : $per), 'BS') . '</span></div>';
                if ($precioPaquete !== null) {
                    $html .= '<div><span class="badge bg-success px-3 py-2" style="font-size:1.2em;">Paq.: ' . mostrar_precio($precioPaquete, 'BS') . '</span></div>';
                }
            } else {
                $html .= '<div class="mb-2"><span class="badge bg-primary px-3 py-2" style="font-size:1.2em;">c/u: ' . mostrar_precio(($precioUnidad !== null ? $precioUnidad : $per), $moneda) . '</span> <span class="badge bg-secondary px-2 py-1" style="font-size:1em;">' . mostrar_precio(($precioUnidadBs !== null ? $precioUnidadBs : $perBs), 'BS') . '</span></div>';
                if ($precioPaquete !== null) {
                    $html .= '<div><span class="badge bg-success px-3 py-2" style="font-size:1.2em;">Paq.: ' . mostrar_precio($precioPaquete, $moneda) . '</span> <span class="badge bg-secondary px-2 py-1" style="font-size:1em;">' . mostrar_precio($precioPaqueteBs, 'BS') . '</span></div>';
                }
            }
        } else {
            $use = $precioUnidad !== null ? $precioUnidad : 0;
            $useBs = ($moneda !== 'BS' && $tasa) ? $use * $tasa : $use;
            if ($soloBs) {
                $html .= '<span class="badge bg-primary px-4 py-3" style="font-size:1.8em;">' . mostrar_precio($use, 'BS') . '</span>';
            } else {
                $html .= '<span class="badge bg-primary px-4 py-3" style="font-size:1.8em;">' . mostrar_precio($use, $moneda) . '</span> <span class="badge bg-secondary px-3 py-2" style="font-size:1.2em;">' . mostrar_precio($useBs, 'BS') . '</span>';
            }
        }
        $html .= '</div>';
        $html .= '</div>';
        $html .= '</div>';
        return $html;
    }
    ?>
</head>

<body>
    <div class="app">

        <header class="app-header d-flex align-items-center justify-content-center">

            <div class="w-100" style="position:sticky;top:0;z-index:1000;background:#e3f2fd;box-shadow:0 2px 6px rgba(0,0,0,0.04);padding:0.3em 2vw;overflow-x:auto;">
                <div class="d-flex align-items-center justify-content-center flex-nowrap" style="gap:2em;white-space:nowrap;animation:marquee 18s linear infinite;min-height:2.5em;">
                    <span class="fw-bold" style="font-size:2em;color:#1565c0;">
                        <i class="fa-solid fa-dollar-sign"></i> Tasa: <?php echo $tasa !== null ? number_format($tasa, 2) . ' Bs' : '--'; ?>
                    </span>
                    <span class="fw-bold" style="font-size:1.3em;color:#1976d2;">
                        <?php echo $fecha_tasa ? date('d-m-Y', strtotime($fecha_tasa)) : '--'; ?>
                    </span>
                </div>
            </div>
        </header>
        <main>
            <?php
            $stmt = $db->query("SELECT * FROM productos ORDER BY nombre ASC");
            $productos = $stmt->fetchAll(PDO::FETCH_ASSOC);
            $productos_json = json_encode($productos);

            $productos_en_pantalla = array_slice($productos, 0, 12);
            ?>

            <?php if (empty($productos)) : ?>
                <div class="empty">Sin productos</div>
            <?php else : ?>
                <div id="product-grid" class="full-screen-grid row g-0">
                    <?php
                    foreach ($productos_en_pantalla as $i) {
                        echo render_product_card($i, $tasa);
                    }
                    ?>
                </div>
            <?php endif; ?>
        </main>

        <!-- Modal Bootstrap para mostrar precios -->
        <div class="modal fade" id="preciosModal" tabindex="-1" aria-labelledby="preciosModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" style="max-width: 600px;">
                <div class="modal-content" style="background: #f8fafc; border-radius: 2em; box-shadow: 0 8px 32px #1976d255;">
                    <div class="modal-header border-0" style="justify-content: center; background: #1976d2; border-top-left-radius: 2em; border-top-right-radius: 2em;">
                        <h2 class="modal-title w-100 text-center" id="preciosModalLabel" style="font-size:2.5em; color: #fff; letter-spacing: 1px;">Precios del producto</h2>
                        <button type="button" class="btn-close btn-close-white position-absolute end-0 me-3 mt-2" data-bs-dismiss="modal" aria-label="Cerrar" style="font-size:2em;"></button>
                    </div>
                    <div class="modal-body text-center" style="padding: 2.5em 1.5em;">
                        <div style="font-size:2.2em; font-weight:700; color:#1976d2; margin-bottom:0.7em;">
                            <i class="fa-solid fa-box"></i> <span id="modalNombre"></span>
                        </div>
                        <div style="font-size:1.7em; margin-bottom:0.5em;">
                            <span class="badge bg-primary" style="font-size:1em;">Unidad</span>
                            <span id="modalPrecioUnidad" style="font-weight:600; margin-left:0.5em;"></span>
                            <span id="modalPrecioUnidadBs" class="text-success" style="font-weight:600; margin-left:0.7em;"></span>
                        </div>
                        <div id="modalPaqueteRow" style="font-size:1.7em; display:none;">
                            <span class="badge bg-success" style="font-size:1em;">Paquete</span>
                            <span id="modalPrecioPaquete" style="font-weight:600; margin-left:0.5em;"></span>
                            <span id="modalPrecioPaqueteBs" class="text-success" style="font-weight:600; margin-left:0.7em;"></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            const allProducts = <?php echo $productos_json; ?>;
            let currentProductIndex = 12;
            const tasa = <?php echo $tasa ?? 0; ?>;

            function mostrarPrecio(valor, moneda) {
                if (valor === null) return '--';
                const options = {
                    minimumFractionDigits: (valor % 1 === 0) ? 0 : 2,
                    maximumFractionDigits: 2
                };
                return new Intl.NumberFormat('es-VE', options).format(valor) + (moneda === 'BS' ? ' Bs' : ' $');
            }

            function renderProductCard(i) {
                const unidad = i.unidad_medida || 'unidad';
                const precioPaquete = i.precio_venta_paquete ? parseFloat(i.precio_venta_paquete) : null;
                const precioUnidad = i.precio_venta_unidad ? parseFloat(i.precio_venta_unidad) : null;
                const nombre = i.nombre || '';
                const moneda = i.moneda_compra ? i.moneda_compra.toUpperCase() : 'USD';
                const precioUnidadBs = (precioUnidad !== null && moneda !== 'BS' && tasa) ? precioUnidad * tasa : precioUnidad;
                const precioPaqueteBs = (precioPaquete !== null && moneda !== 'BS' && tasa) ? precioPaquete * tasa : precioPaquete;
                const soloBs = (moneda === 'BS');

                let dataAttrs = `data-nombre="${nombre}"`;
                dataAttrs += ` data-preciounidad="${soloBs ? mostrarPrecio(precioUnidadBs, 'BS') : mostrarPrecio(precioUnidad, moneda)}"`;
                dataAttrs += ` data-preciounidadbs="${mostrarPrecio(precioUnidadBs, 'BS')}"`;
                dataAttrs += ` data-preciopaquete="${soloBs ? mostrarPrecio(precioPaqueteBs, 'BS') : mostrarPrecio(precioPaquete, moneda)}"`;
                dataAttrs += ` data-preciopaquetebs="${mostrarPrecio(precioPaqueteBs, 'BS')}"`;
                dataAttrs += ` data-solo-bs="${soloBs ? '1' : '0'}"`;

                let cardHtml = `<div class="item card h-100 shadow p-2 producto-modal-trigger" tabindex="0" ${dataAttrs} style="background: linear-gradient(135deg, #e3f2fd 60%, #fff 100%); box-shadow: none; display:flex; flex-direction:column; justify-content:center; align-items:center; text-align:center; border: 1px solid #dee2e6;">`;
                cardHtml += `<div class="fw-bold mb-2" style="font-size:1.5em; color:#1976d2; min-height:2.5em; letter-spacing:0.5px; padding: 0 10px;">${nombre}</div>`;
                cardHtml += `<div style="width:100%;">`;

                if (unidad === 'paquete' && i.tam_paquete && parseInt(i.tam_paquete) > 0) {
                    const paquetePrecio = precioPaquete !== null ? precioPaquete : 0;
                    const per = paquetePrecio / parseInt(i.tam_paquete);
                    const perBs = (moneda !== 'BS' && tasa) ? per * tasa : per;
                    if (soloBs) {
                        cardHtml += `<div class="mb-2"><span class="badge bg-primary px-3 py-2" style="font-size:1.2em;">c/u: ${mostrarPrecio((precioUnidad !== null ? precioUnidad : per), 'BS')}</span></div>`;
                        if (precioPaquete !== null) {
                            cardHtml += `<div><span class="badge bg-success px-3 py-2" style="font-size:1.2em;">Paq.: ${mostrarPrecio(precioPaquete, 'BS')}</span></div>`;
                        }
                    } else {
                        cardHtml += `<div class="mb-2"><span class="badge bg-primary px-3 py-2" style="font-size:1.2em;">c/u: ${mostrarPrecio((precioUnidad !== null ? precioUnidad : per), moneda)}</span> <span class="badge bg-secondary px-2 py-1" style="font-size:1em;">${mostrarPrecio((precioUnidadBs !== null ? precioUnidadBs : perBs), 'BS')}</span></div>`;
                        if (precioPaquete !== null) {
                            cardHtml += `<div><span class="badge bg-success px-3 py-2" style="font-size:1.2em;">Paq.: ${mostrarPrecio(precioPaquete, moneda)}</span> <span class="badge bg-secondary px-2 py-1" style="font-size:1em;">${mostrarPrecio(precioPaqueteBs, 'BS')}</span></div>`;
                        }
                    }
                } else {
                    const use = precioUnidad !== null ? precioUnidad : 0;
                    const useBs = (moneda !== 'BS' && tasa) ? use * tasa : use;
                    if (soloBs) {
                        cardHtml += `<span class="badge bg-primary px-4 py-3" style="font-size:1.8em;">${mostrarPrecio(use, 'BS')}</span>`;
                    } else {
                        cardHtml += `<span class="badge bg-primary px-4 py-3" style="font-size:1.8em;">${mostrarPrecio(use, moneda)}</span> <span class="badge bg-secondary px-3 py-2" style="font-size:1.2em;">${mostrarPrecio(useBs, 'BS')}</span>`;
                    }
                }
                cardHtml += `</div></div>`;

                const col = document.createElement('div');
                col.className = 'col-3 h-33 card-appear';
                col.innerHTML = cardHtml;
                return col;
            }

            document.addEventListener('DOMContentLoaded', function() {
                const grid = document.getElementById('product-grid');
                if (!grid) return;

                // Modal logic
                var modal = new bootstrap.Modal(document.getElementById('preciosModal'));
                grid.addEventListener('click', function(e) {
                    const card = e.target.closest('.producto-modal-trigger');
                    if (!card) return;

                    var soloBs = card.getAttribute('data-solo-bs') === '1';
                    document.getElementById('modalNombre').textContent = card.getAttribute('data-nombre');
                    document.getElementById('modalPrecioUnidad').textContent = card.getAttribute('data-preciounidad');
                    document.getElementById('modalPrecioUnidadBs').textContent = soloBs ? '' : ('(' + card.getAttribute('data-preciounidadbs') + ')');

                    var paquete = card.getAttribute('data-preciopaquete');
                    if (paquete && paquete !== '--' && Number(paquete.replace(/[^\d.-]+/g, '')) > 0) {
                        document.getElementById('modalPaqueteRow').style.display = '';
                        document.getElementById('modalPrecioPaquete').textContent = paquete;
                        document.getElementById('modalPrecioPaqueteBs').textContent = soloBs ? '' : ('(' + card.getAttribute('data-preciopaquetebs') + ')');
                    } else {
                        document.getElementById('modalPaqueteRow').style.display = 'none';
                    }

                    if (soloBs) {
                        document.getElementById('modalPrecioUnidadBs').style.display = 'none';
                        document.getElementById('modalPrecioPaqueteBs').style.display = 'none';
                    } else {
                        document.getElementById('modalPrecioUnidadBs').style.display = '';
                        document.getElementById('modalPrecioPaqueteBs').style.display = '';
                    }
                    modal.show();
                });


                // Animation logic
                setInterval(() => {
                    if (grid.children.length === 0 || allProducts.length <= 12) return;

                    const firstChild = grid.children[0];
                    firstChild.classList.add('card-disappear');

                    // Refuerzo: si la animación no ocurre, forzar el ciclo tras 600ms
                    let animTimeout = setTimeout(() => {
                        if (grid.contains(firstChild)) {
                            firstChild.remove();
                            addNextProduct();
                        }
                    }, 600);

                    function addNextProduct() {
                        if (currentProductIndex >= allProducts.length) {
                            currentProductIndex = 0; // Loop back to the start
                        }
                        const newProduct = allProducts[currentProductIndex];
                        const newCard = renderProductCard(newProduct);
                        grid.appendChild(newCard);
                        currentProductIndex++;
                    }

                    firstChild.addEventListener('animationend', () => {
                        clearTimeout(animTimeout);
                        if (grid.contains(firstChild)) {
                            firstChild.remove();
                        }
                        addNextProduct();
                    }, {
                        once: true
                    });

                }, 3000);
            });
        </script>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
<?php
function mostrar_precio_viejo($valor, $moneda)
{
    if ($valor === null) return '--';
    if (fmod($valor, 1) == 0.0) {
        return number_format($valor, 0) . ($moneda === 'BS' ? ' Bs' : ' $');
    } else {
        return number_format($valor, 2) . ($moneda === 'BS' ? ' Bs' : ' $');
    }
}
?>