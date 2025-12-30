<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Calendario de Pagos</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <style>
        /* Asegurar que si .layout no muestra la imagen por cualquier motivo, el body la muestre */
        body {
            background-image: url('img/cashea.png');
            background-size: cover;
            background-position: center center;
            background-repeat: no-repeat;
        }

        /* Slight overlay so content is readable */
        .layout::before {
            content: '';
            position: fixed;
            inset: 0;
            background: rgba(255, 255, 255, 0.12);
            pointer-events: none;
            z-index: 0;
        }

        /* Ensure modals and main content render above overlay */
        .layout,
        #modal,
        #modal-agregar {
            position: relative;
            z-index: 1;
        }

        /* Clean auth modal style (slightly narrower and taller) */
        #modal-content.auth-clean {
            max-width: 340px;
            width: 92%;
            border-radius: 10px;
            padding: 20px 18px;
            min-height: 260px;
            /* small yellow stripe at the top to match Agregar compra modal */
            border-top: 4px solid #f59e0b;
            /* tailwind amber-500 */
        }

        @media (min-width: 700px) {
            #modal-content.auth-clean {
                width: 340px;
            }
        }

        /* When auth-clean is active, show only the left/info column */
        #modal-content.auth-clean #modal-actions {
            display: none !important;
        }

        #modal-content.auth-clean #modal-info {
            flex: 1 0 100% !important;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body>
    <div class="layout" style="display:none">
        <div class="pane-left">
            <div id="calendar"></div>
        </div>
        <div class="pane-right">
            <div class="summary-header d-flex align-items-center justify-content-between">
                <div class="fw-semibold">Resumen</div>
                <div class="d-flex align-items-center gap-2">
                    <div id="user-area" class="me-2"></div>
                    <div class="d-flex gap-2">
                        <button id="btn-add-compra" class="btn btn-sm btn-success"><i
                                class="fa-solid fa-plus"></i></button>
                        <button id="refresh-resumen" class="btn btn-sm btn-outline-primary" title="Sincronizar"><i
                                class="fa-solid fa-rotate"></i></button>
                        <button id="btn-toggle-calendar" class="btn btn-sm btn-outline-secondary"
                            title="Ocultar/mostrar calendario"><i class="fa-solid fa-eye-slash"></i></button>
                    </div>
                </div>
            </div>
            <div id="summary" class="summary-body"></div>
        </div>
    </div>

    <!-- Modal simple -->
    <div id="modal"
        style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh; background:rgba(0,0,0,0.5); align-items:center; justify-content:center; z-index:9999; padding:12px; box-sizing:border-box;">
        <div id="modal-content"
            style="background:#fff; padding:16px 18px; border-radius:10px; min-width:340px; width:40%; max-width:560px; text-align:left; position:relative; box-shadow:0 4px 16px rgba(0,0,0,0.10); overflow:hidden; display:flex; gap:12px; max-height:80vh;">
            <div id="modal-spinner">
                <div class="spinner-circle"></div>
            </div>
            <div id="modal-info" style="flex:2; min-width:0; overflow-y:auto;">
                <div id="modal-body-content"></div>
            </div>
            <div id="modal-actions"
                style="flex:1; border-left:1px solid #e5e7eb; padding-left:12px; display:flex; flex-direction:column; gap:8px; overflow-y:auto;">
                <div id="modal-actions-container" style="display:flex; flex-direction:column; gap:6px; margin-top:6px;">
                </div>
            </div>
        </div>
    </div>

    <!-- Modal agregar compra -->
    <div id="modal-agregar"
        style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.5); align-items:center; justify-content:center; z-index:10000; padding:12px; box-sizing:border-box;">
        <div id="modal-agregar-content" class="modal-add-content"
            style="background:#fff; padding:16px; border-radius:10px; width:100%; max-width:540px; box-shadow:0 6px 20px rgba(0,0,0,0.12);">
            <div class="modal-add-header d-flex align-items-center gap-2 mb-3">
                <div class="modal-add-icon"><i id="modal-agregar-icon" class="fa-solid fa-cart-plus"></i></div>
                <div id="modal-agregar-title" class="modal-add-title">Agregar compra</div>
            </div>
            <form id="form-agregar" class="row g-3">
                <input type="hidden" name="compra_id">
                <div class="col-12 col-md-6">
                    <label class="form-label">Usuario</label>
                    <div class="input-group input-group-sm">
                        <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                        <input type="text" name="usuario" class="form-control form-control-sm"
                            placeholder="Nombre del cliente" required>
                    </div>
                </div>
                <div class="col-12 col-md-6">
                    <label class="form-label">Teléfono</label>
                    <div class="input-group input-group-sm">
                        <span class="input-group-text"><i class="fa-solid fa-phone"></i></span>
                        <input type="tel" name="telefono" class="form-control form-control-sm"
                            placeholder="Ej: +58(414)4679693" inputmode="tel" maxlength="20" required>
                    </div>
                </div>
                <div class="col-12 col-md-6">
                    <label class="form-label">Producto</label>
                    <div class="input-group input-group-sm">
                        <span class="input-group-text"><i class="fa-solid fa-box"></i></span>
                        <input type="text" name="producto" class="form-control form-control-sm"
                            placeholder="Descripción" required>
                    </div>
                </div>
                <div class="col-6 col-md-4">
                    <label class="form-label">Precio</label>
                    <div class="input-group input-group-sm">
                        <span class="input-group-text">$</span>
                        <input type="number" name="precio" step="0.01" min="0" class="form-control form-control-sm"
                            placeholder="0.00" required>
                    </div>
                </div>
                <div class="col-6 col-md-4">
                    <label class="form-label">Inicial</label>
                    <div class="input-group input-group-sm">
                        <span class="input-group-text">$</span>
                        <input type="number" name="inicial" step="0.01" min="0" class="form-control form-control-sm"
                            placeholder="0.00" required>
                    </div>
                </div>
                <div class="col-6 col-md-4">
                    <label class="form-label">Cuotas</label>
                    <div class="input-group input-group-sm">
                        <span class="input-group-text"><i class="fa-solid fa-list-ol"></i></span>
                        <input type="number" name="cuotas" min="1" class="form-control form-control-sm"
                            placeholder="Ej: 6" required>
                    </div>
                </div>
                <div class="col-6 col-md-6">
                    <label class="form-label">Fecha compra</label>
                    <div class="input-group input-group-sm">
                        <span class="input-group-text"><i class="fa-solid fa-calendar-day"></i></span>
                        <input type="date" name="fecha_compra" class="form-control form-control-sm" required>
                    </div>
                </div>
                <div class="col-12">
                    <div id="resumen-cuota" class="summary-box small">Completa los campos para ver el monto por cuota.
                    </div>
                </div>
                <div class="col-12 d-flex justify-content-end gap-2 mt-1">
                    <button type="submit" class="btn btn-sm btn-success"><i
                            class="fa-solid fa-check me-1"></i>Guardar</button>
                    <button type="button" id="cancel-agregar" class="btn btn-sm btn-secondary"><i
                            class="fa-solid fa-xmark me-1"></i>Cancelar</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Botón para ocultar/mostrar el calendario (útil en móvil)
            let calendarVisible = true;
            document.getElementById('btn-toggle-calendar').addEventListener('click', function() {
                const paneLeft = document.querySelector('.pane-left');
                if (calendarVisible) {
                    paneLeft.style.display = 'none';
                    this.innerHTML = '<i class="fa-solid fa-eye"></i>';
                    this.title = 'Mostrar calendario';
                } else {
                    paneLeft.style.display = '';
                    this.innerHTML = '<i class="fa-solid fa-eye-slash"></i>';
                    this.title = 'Ocultar calendario';
                }
                calendarVisible = !calendarVisible;
            });
            // Cache de compra_id -> total de cuotas
            let _cuotasMapCache = null;
            <?php
            $is_https = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on') || (!empty($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') || (isset($_SERVER['SERVER_PORT']) && $_SERVER['SERVER_PORT'] == 443);
            $protocol = $is_https ? 'https' : 'http';
            $host = isset($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : 'localhost';
            $script_name = isset($_SERVER['SCRIPT_NAME']) ? $_SERVER['SCRIPT_NAME'] : '';
            $base_path = dirname($script_name);
            if ($base_path === '/' || $base_path === '\\' || $base_path === '.') {
                $base_path = '';
            }
            $api_base_url = $protocol . '://' . $host . $base_path;
            ?>
            const API_BASE = '<?php echo $api_base_url; ?>';

            // Log y mostrar layout ahora que API_BASE está inicializado
            // ...comentario eliminado...
            try {
                const layoutEl = document.querySelector('.layout');
                if (layoutEl && layoutEl.style.display === 'none') layoutEl.style.display = '';
            } catch (e) {
                // ...comentario eliminado...
            }

            // comprobación de imagen removida
            async function getCuotasMap() {
                if (_cuotasMapCache) return _cuotasMapCache;
                try {
                    const res = await fetch(API_BASE + '/api/resumen.php');
                    const data = await res.json();
                    const map = {};
                    if (Array.isArray(data)) {
                        data.forEach(u => {
                            (u.compras || []).forEach(c => {
                                if (c && (c.id || c.compra_id) && c.cuotas) {
                                    map[c.id || c.compra_id] = c.cuotas;
                                }
                            });
                        });
                    }
                    _cuotasMapCache = map;
                    return map;
                } catch (e) {
                    return {};
                }
            }

            // Cache extendido: compra_id -> { totales, pagadas }
            let _cuotasStatsCache = null;
            async function getCuotasStatsMap() {
                if (_cuotasStatsCache) return _cuotasStatsCache;
                try {
                    const res = await fetch(API_BASE + '/api/resumen.php');
                    const data = await res.json();
                    const totales = {};
                    const pagadas = {};
                    if (Array.isArray(data)) {
                        data.forEach(u => {
                            (u.compras || []).forEach(c => {
                                const id = c && (c.id || c.compra_id);
                                if (!id) return;
                                if (typeof c.cuotas === 'number') totales[id] = c.cuotas;
                                if (typeof c.pagadas === 'number') pagadas[id] = c.pagadas;
                            });
                        });
                    }
                    _cuotasStatsCache = {
                        totales,
                        pagadas
                    };
                    return _cuotasStatsCache;
                } catch (e) {
                    return {
                        totales: {},
                        pagadas: {}
                    };
                }
            }

            async function loadResumen() {
                const cont = document.getElementById('summary');
                cont.innerHTML = '<div class="text-muted p-2">Cargando resumen...</div>';
                try {
                    const res = await fetch(API_BASE + '/api/resumen.php');
                    const data = await res.json();
                    if (!Array.isArray(data) || data.length === 0) {
                        cont.innerHTML = '<div class="text-muted p-2">Sin datos.</div>';
                        return;
                    }
                    const fmtDMY = (s) => {
                        if (!s || typeof s !== 'string') return s;
                        const parts = s.split('-');
                        if (parts.length !== 3) return s;
                        const [y, m, d] = parts;
                        return (d || '').padStart(2, '0') + '/' + (m || '').padStart(2, '0') + '/' + y;
                    };
                    let html = '';
                    data.forEach(u => {
                        // Filtrar compras totalmente pagadas
                        const comprasActivas = Array.isArray(u.compras) ? u.compras.filter(c => {
                            const total = Number(c.precio) || 0;
                            const pagado = Number(c.pagado_total != null ? c.pagado_total : (Number(c.inicial) || 0) + (Number(c.pagado_cuotas) || 0)) || 0;
                            const restante = total - pagado;
                            const cuotas = Number(c.cuotas) || 0;
                            const pagadas = Number(c.pagadas) || 0;
                            const pagadaPorMonto = restante <= 0.009; // tolerancia decimales
                            const pagadaPorCuotas = cuotas > 0 && pagadas >= cuotas;
                            return !(pagadaPorMonto || pagadaPorCuotas);
                        }) : [];
                        const cardStyle = u.color ? (' style="--accent-color: ' + u.color + ';"') : '';
                        const totalCompra = Number(u.totales.total_precio) || 0;
                        const pagadoTotal = Number(u.totales.total_pagado_total || (u.totales.total_inicial + u.totales.total_pagado)) || 0;
                        const pct = totalCompra > 0 ? Math.min(100, Math.max(0, (pagadoTotal / totalCompra) * 100)) : 0;
                        html += '<div class="card mb-2 shadow-sm summary-user-card" data-usuario="' + u.usuario.replace(/"/g, '&quot;') + '"' + cardStyle + '>';
                        html += '  <div class="card-body py-2">';
                        html += '    <div class="d-flex justify-content-between align-items-center mb-2">';
                        html += '      <div class="fw-bold">' + u.usuario + (u.telefono ? ' <span class="text-muted small ms-2">' + u.telefono + '</span>' : '') + '</div>';
                        html += '      <div class="small text-muted">Compras: ' + comprasActivas.length + '</div>';
                        html += '    </div>';
                        html += '    <div class="row g-2 small mb-2">';
                        html += '      <div class="col-4">Total compra: $' + Number(u.totales.total_precio).toFixed(2) + '</div>';
                        html += '      <div class="col-4">Pagado: $' + Number(u.totales.total_pagado_total || (u.totales.total_inicial + u.totales.total_pagado)).toFixed(2) + '</div>';
                        html += '      <div class="col-4">Restante: <span class="fw-semibold">$' + Number(u.totales.total_precio - (u.totales.total_pagado_total || (u.totales.total_inicial + u.totales.total_pagado))).toFixed(2) + '</span></div>';
                        html += '    </div>';
                        // (Eliminado) Barra de progreso general por usuario
                        if (comprasActivas.length) {
                            html += '    <div class="list-group list-group-flush">';
                            comprasActivas.forEach(c => {
                                const fecha = fmtDMY(c.fecha_compra);
                                // Añadir atributos data para permitir edición/ eliminación
                                // usar usuario/telefono de la compra si existen, si no caer al usuario del grupo (u.usuario / u.telefono)
                                html += '      <div class="list-group-item px-0 py-2" data-compra-id="' + (c.id || c.compra_id) + '" data-producto="' + ((c.producto || '').replace(/\"/g, '&quot;')) + '" data-precio="' + Number(c.precio || 0).toFixed(2) + '" data-inicial="' + Number(c.inicial || 0).toFixed(2) + '" data-cuotas="' + (c.cuotas || '') + '" data-fecha="' + (c.fecha_compra || '') + '" data-usuario="' + (((c.usuario || u.usuario) || '').replace(/\"/g, '&quot;')) + '" data-telefono="' + ((c.telefono || u.telefono || '') + '') + '">';
                                html += '        <div class="d-flex justify-content-between">';
                                html += '          <div><span class="fw-semibold">' + c.producto + '</span><span class="text-muted small ms-2">' + fecha + '</span></div>';
                                html += '          <div class="text-end small">Restante: <span class="fw-semibold">$' + Number(c.precio - (c.pagado_total || (c.inicial + c.pagado_cuotas))).toFixed(2) + '</span></div>';
                                html += '        </div>';
                                html += '        <div class="small text-muted">Cuotas: ' + c.pagadas + '/' + c.cuotas + ' · Total: $' + Number(c.precio).toFixed(2) + ' · Pagado: $' + Number(c.pagado_total || (c.inicial + c.pagado_cuotas)).toFixed(2) + '</div>';
                                // Progreso según cuotas pagadas (no por monto)
                                const totalCuotas = Number(c.cuotas) || 0;
                                const pagadas = Number(c.pagadas) || 0;
                                const cPct = totalCuotas > 0 ? Math.min(100, Math.max(0, (pagadas / totalCuotas) * 100)) : 0;
                                html += '        <div class="mt-1">';
                                html += '          <div class="d-flex justify-content-between small"><span>Progreso</span><span>' + cPct.toFixed(0) + '%</span></div>';
                                html += '          <div class="progress" style="height:6px; background:#e9ecef;">';
                                html += '            <div class="progress-bar" role="progressbar" style="width:' + cPct.toFixed(0) + '%; background: var(--accent-color, #1976d2);" aria-valuenow="' + pagadas + '" aria-valuemin="0" aria-valuemax="' + totalCuotas + '"></div>';
                                html += '          </div>';
                                html += '        </div>';
                                // Botones de acción por compra: editar / eliminar
                                html += '        <div class="mt-2 d-flex gap-2 justify-content-end">';
                                html += '          <button class="btn btn-sm btn-outline-primary edit-compra" data-compra="' + (c.id || c.compra_id) + '" title="Editar"><i class="fa-solid fa-pen"></i></button>';
                                html += '          <button class="btn btn-sm btn-outline-danger delete-compra" data-compra="' + (c.id || c.compra_id) + '" title="Eliminar"><i class="fa-solid fa-trash"></i></button>';
                                html += '        </div>';
                                html += '      </div>';
                            });
                            html += '    </div>';
                        }
                        html += '  </div>';
                        html += '</div>';
                    });
                    cont.innerHTML = html;
                } catch (e) {
                    cont.innerHTML = '<div class="text-danger p-2">Error cargando resumen</div>';
                }
            }

            document.addEventListener('click', (e) => {
                if (e.target && e.target.id === 'refresh-resumen') {
                    loadResumen();
                }
            });

            // Click en tarjeta de usuario: mostrar modal con cuotas pendientes de la siguiente quincena
            document.getElementById('summary').addEventListener('click', (e) => {
                // Ignorar clicks que provienen de controles (botones de acción) dentro de la tarjeta
                if (e.target.closest('.edit-compra, .delete-compra, .marcar-pagada, .eliminar-pago, button, a')) return;
                const card = e.target.closest('.summary-user-card');
                if (!card) return;
                const usuario = card.dataset.usuario;
                if (!usuario) return;
                showQuincenaModal(usuario);
            });

            // Delegación para botones Editar / Eliminar dentro del resumen
            document.getElementById('summary').addEventListener('click', async function(e) {
                const editBtn = e.target.closest('.edit-compra');
                if (editBtn) {
                    const compraId = editBtn.dataset.compra;
                    // Buscar elemento padre con data-compra-id
                    const parent = this.querySelector('[data-compra-id="' + compraId + '"]');
                    if (!parent) return;
                    // Rellenar el formulario con datos
                    const form = document.getElementById('form-agregar');
                    form.querySelector('input[name="compra_id"]').value = compraId;
                    form.querySelector('input[name="usuario"]').value = parent.dataset.usuario || '';
                    form.querySelector('input[name="telefono"]').value = parent.dataset.telefono || '';
                    form.querySelector('input[name="producto"]').value = parent.dataset.producto || '';
                    form.querySelector('input[name="precio"]').value = parent.dataset.precio || '';
                    form.querySelector('input[name="inicial"]').value = parent.dataset.inicial || '';
                    form.querySelector('input[name="cuotas"]').value = parent.dataset.cuotas || '';
                    form.querySelector('input[name="fecha_compra"]').value = parent.dataset.fecha || '';
                    // modo edición: ajustar título e icono
                    document.getElementById('modal-agregar-title').textContent = 'Editar compra';
                    const icon3 = document.getElementById('modal-agregar-icon');
                    if (icon3) {
                        icon3.className = 'fa-solid fa-pen';
                    }
                    document.getElementById('modal-agregar').style.display = 'flex';
                    return;
                }
                const delBtn = e.target.closest('.delete-compra');
                if (delBtn) {
                    const compraId = delBtn.dataset.compra;
                    if (!compraId) return;
                    // Confirmación con SweetAlert2
                    const conf = await Swal.fire({
                        title: 'Eliminar compra',
                        text: '¿Eliminar compra y sus pagos asociados?',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonText: 'Sí, eliminar',
                        cancelButtonText: 'Cancelar'
                    });
                    if (!conf.isConfirmed) return;
                    delBtn.disabled = true;
                    try {
                        const res = await fetch(API_BASE + '/api/compra_eliminar.php', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify({
                                compra_id: compraId
                            })
                        });
                        const data = await res.json();
                        if (data.ok) {
                            calendar.refetchEvents();
                            loadResumen();
                        } else {
                            await Swal.fire('Error', data.error || 'no se pudo eliminar', 'error');
                            delBtn.disabled = false;
                        }
                    } catch (err) {
                        await Swal.fire('Error', 'Error de red', 'error');
                        delBtn.disabled = false;
                    }
                }
            });

            function showQuincenaModal(usuario) {
                const spinner = document.getElementById('modal-spinner');
                const modalEl = document.getElementById('modal');
                const modalContent = document.getElementById('modal-content');
                const bodyEl = document.getElementById('modal-body-content');
                const actionsContainer = document.getElementById('modal-actions-container');
                bodyEl.innerHTML = '';
                actionsContainer.innerHTML = '';
                // Usar estilo del modal de día: mantener layout flex pero en columna para que #modal-info haga scroll
                modalContent.style.display = 'flex';
                modalContent.style.flexDirection = 'column';
                modalContent.style.width = '32%';
                modalContent.style.maxWidth = '440px';
                modalContent.style.minWidth = '320px';
                actionsContainer.style.display = 'none';
                modalEl.style.display = 'flex';
                spinner.style.display = 'flex';

                // Calcular rango de la quincena actual
                const hoy = new Date();
                const y = hoy.getFullYear();
                const m = hoy.getMonth(); // 0-11
                const dia = hoy.getDate();
                const meses = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];

                function toStr(yy, mm0, dd) {
                    const mm = String(mm0 + 1).padStart(2, '0');
                    const dds = String(dd).padStart(2, '0');
                    return yy + '-' + mm + '-' + dds;
                }
                let rangoIni, rangoFin, rangoLabel;
                if (dia <= 14) {
                    // Quincena actual: 1 al 14 del mes actual
                    rangoIni = toStr(y, m, 1);
                    rangoFin = toStr(y, m, 14);
                    rangoLabel = '1 al 14 de ' + meses[m] + ' ' + y;
                } else {
                    // Quincena actual: 15 al último día del mes actual
                    const lastDayCurr = new Date(y, m + 1, 0).getDate();
                    rangoIni = toStr(y, m, 15);
                    rangoFin = toStr(y, m, lastDayCurr);
                    rangoLabel = '15 al ' + lastDayCurr + ' de ' + meses[m] + ' ' + y;
                }

                Promise.all([
                    fetch(API_BASE + '/api/cuotas.php').then(r => r.json()),
                    getCuotasStatsMap()
                ]).then(([eventos, cuotasStats]) => {
                    const totalsMap = (cuotasStats && cuotasStats.totales) || {};
                    const pagadasMap = (cuotasStats && cuotasStats.pagadas) || {};

                    function normalizeName(s) {
                        return (s || '').toString().trim().toLowerCase();
                    }
                    const usuarioNorm = normalizeName(usuario);
                    const pendientes = eventos.filter(ev => {
                        const evUsuario = ev.extendedProps && ev.extendedProps.usuario ? ev.extendedProps.usuario : (ev.title || '').split(' - ')[0];
                        if (normalizeName(evUsuario) !== usuarioNorm) return false;
                        if (ev.extendedProps && ev.extendedProps.pagada) return false;
                        const f = ev.start;
                        return f >= rangoIni && f <= rangoFin;
                    });

                    // Ordenar cronológicamente por fecha (YYYY-MM-DD) y calcular etiqueta de conteo
                    pendientes.sort((a, b) => (a.start || '').localeCompare(b.start || ''));
                    const countLabel = pendientes.length + ' ' + (pendientes.length === 1 ? 'cuota' : 'cuotas');

                    // Calcular total pendiente
                    const totalPend = pendientes.reduce((sum, ev) => sum + Number(ev.extendedProps?.monto || 0), 0);

                    let html = '';
                    html += '<div class="d-flex justify-content-center align-items-center mb-2 gap-2">';
                    html += '<button id="btn-quincena-prev" class="btn btn-sm btn-light px-2 py-1" title="Quincena anterior"><i class="fa-solid fa-chevron-left"></i></button>';
                    html += '<button id="btn-quincena-next" class="btn btn-sm btn-light px-2 py-1 ms-1" title="Quincena siguiente"><i class="fa-solid fa-chevron-right"></i></button>';
                    html += '</div>';
                    html += '<div style="text-align:center;font-size:1.05rem;font-weight:600;color:#222;margin:0 0 8px;">Pendientes de ' + usuario + ' · ' + rangoLabel + '</div>';
                    if (pendientes.length === 0) {
                        html += '<div class="text-center text-muted">No hay cuotas pendientes en esta quincena.</div>';
                    } else {
                        pendientes.forEach((cuota, idx) => {
                            const fechaStr = cuota.start;
                            const [yy, mm, dd] = fechaStr.split('-');
                            const fechaBonita = parseInt(dd) + ' de ' + meses[parseInt(mm) - 1] + ' de ' + yy;
                            const monto = '$' + Number(cuota.extendedProps.monto).toFixed(2);
                            const compraId = cuota.extendedProps.compra_id;
                            const eventosCompra = (eventos || []).filter(ev => ev.extendedProps && ev.extendedProps.compra_id == compraId);
                            const totalFromMap = totalsMap[compraId];
                            const totalFromProps = (cuota.extendedProps && (cuota.extendedProps.cuotas || cuota.extendedProps.total_cuotas));
                            const totalFromEvents = eventosCompra.length;
                            const totalCuotas = totalFromMap || totalFromProps || totalFromEvents || 0;
                            const pagadasFromMap = pagadasMap[compraId];
                            const pagadasFromEvents = eventosCompra.filter(ev => ev.extendedProps && ev.extendedProps.pagada).length;
                            const pagadasCount = (typeof pagadasFromMap === 'number') ? pagadasFromMap : pagadasFromEvents;
                            const pct = totalCuotas ? Math.round((pagadasCount / totalCuotas) * 100) : 0;
                            // Recuadro con info a la izquierda y botón a la derecha (igual al modal de día)
                            html += '<div class="small border rounded p-2 mb-2 bg-light d-flex justify-content-between align-items-center">';
                            html += '  <div class="cuota-info">';
                            html += '    <div><span class="fw-semibold">' + cuota.extendedProps.producto + '</span> · N° ' + cuota.extendedProps.cuota_num + (totalCuotas ? (' de ' + totalCuotas) : '') + '</div>';
                            html += '    <div class="text-muted">' + fechaBonita + ' · <span class="fw-semibold">' + monto + '</span></div>';
                            // Barra de progreso por compra
                            if (totalCuotas) {
                                html += '    <div class="mt-1">';
                                html += '      <div class="progress" style="height:6px;">';
                                html += '        <div class="progress-bar bg-success" role="progressbar" style="width:' + pct + '%" aria-valuenow="' + pagadasCount + '" aria-valuemin="0" aria-valuemax="' + totalCuotas + '"></div>';
                                html += '      </div>';
                                html += '      <div class="small text-muted mt-1">' + pagadasCount + ' de ' + totalCuotas + ' pagadas</div>';
                                html += '    </div>';
                            }
                            html += '  </div>';
                            html += '  <div class="cuota-actions d-flex gap-2 ms-3 flex-shrink-0">';
                            html += '    <button class="btn btn-sm btn-outline-success btn-square marcar-pagada" data-index="' + idx + '" data-compra="' + cuota.extendedProps.compra_id + '" data-cuota="' + cuota.extendedProps.cuota_num + '" data-monto="' + cuota.extendedProps.monto + '"><i class="fa-solid fa-check me-1"></i>Marcar Pagada</button>';
                            html += '  </div>';
                            html += '</div>';
                        });
                        // Total al final
                        html += '<div id="modal-actions-total" data-total="' + totalPend.toFixed(2) + '" class="d-flex justify-content-end align-items-center mt-2"><span class="fw-semibold total-value">Total: $' + totalPend.toFixed(2) + '</span></div>';
                    }
                    bodyEl.innerHTML = html;
                    spinner.style.display = 'none';

                    // Lógica para navegar entre quincenas
                    let quincenaRef = {
                        y,
                        m,
                        dia
                    };

                    function getQuincenaRange(ref) {
                        let {
                            y,
                            m,
                            dia
                        } = ref;
                        let rangoIni, rangoFin, rangoLabel;
                        const meses = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];

                        function toStr(yy, mm0, dd) {
                            const mm = String(mm0 + 1).padStart(2, '0');
                            const dds = String(dd).padStart(2, '0');
                            return yy + '-' + mm + '-' + dds;
                        }
                        if (dia <= 14) {
                            rangoIni = toStr(y, m, 1);
                            rangoFin = toStr(y, m, 14);
                            rangoLabel = '1 al 14 de ' + meses[m] + ' ' + y;
                        } else {
                            const lastDayCurr = new Date(y, m + 1, 0).getDate();
                            rangoIni = toStr(y, m, 15);
                            rangoFin = toStr(y, m, lastDayCurr);
                            rangoLabel = '15 al ' + lastDayCurr + ' de ' + meses[m] + ' ' + y;
                        }
                        return {
                            rangoIni,
                            rangoFin,
                            rangoLabel
                        };
                    }

                    function cambiarQuincena(dir) {
                        let {
                            y,
                            m,
                            dia
                        } = quincenaRef;
                        if (dia <= 14) {
                            // Si está en la primera quincena, ir a la segunda del mes anterior o actual
                            if (dir === -1) {
                                if (m === 0) {
                                    y -= 1;
                                    m = 11;
                                } else {
                                    m -= 1;
                                }
                                const lastDayPrev = new Date(y, m + 1, 0).getDate();
                                dia = lastDayPrev; // segunda quincena del mes anterior
                            } else {
                                dia = 15; // segunda quincena del mes actual
                            }
                        } else {
                            // Si está en la segunda quincena, ir a la primera del mes siguiente o actual
                            if (dir === 1) {
                                if (m === 11) {
                                    y += 1;
                                    m = 0;
                                } else {
                                    m += 1;
                                }
                                dia = 1; // primera quincena del mes siguiente
                            } else {
                                dia = 1; // primera quincena del mes actual
                            }
                        }
                        quincenaRef = {
                            y,
                            m,
                            dia
                        };
                        recargarQuincena();
                    }

                    function recargarQuincena() {
                        const {
                            rangoIni,
                            rangoFin,
                            rangoLabel
                        } = getQuincenaRange(quincenaRef);
                        // Filtrar cuotas de la nueva quincena
                        function normalizeName(s) {
                            return (s || '').toString().trim().toLowerCase();
                        }
                        const usuarioNorm = normalizeName(usuario);
                        const nuevas = eventos.filter(ev => {
                            const evUsuario = ev.extendedProps && ev.extendedProps.usuario ? ev.extendedProps.usuario : (ev.title || '').split(' - ')[0];
                            if (normalizeName(evUsuario) !== usuarioNorm) return false;
                            if (ev.extendedProps && ev.extendedProps.pagada) return false;
                            const f = ev.start;
                            return f >= rangoIni && f <= rangoFin;
                        });
                        // Actualizar título debajo de las flechas (buscar por texto inicial)
                        const titulo = Array.from(bodyEl.querySelectorAll('div')).find(d => d.textContent && d.textContent.trim().startsWith('Pendientes de'));
                        if (titulo) titulo.innerHTML = 'Pendientes de ' + usuario + ' · ' + rangoLabel;
                        // Ordenar cuotas por fecha ascendente
                        nuevas.sort((a, b) => (a.start || '').localeCompare(b.start || ''));
                        // Actualizar listado
                        let htmlList = '';
                        if (nuevas.length === 0) {
                            htmlList += '<div class="text-center text-muted">No hay cuotas pendientes en esta quincena.</div>';
                        } else {
                            nuevas.forEach((cuota, idx) => {
                                const fechaStr = cuota.start;
                                const [yy, mm, dd] = fechaStr.split('-');
                                const meses = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
                                const fechaBonita = parseInt(dd) + ' de ' + meses[parseInt(mm) - 1] + ' de ' + yy;
                                const monto = '$' + Number(cuota.extendedProps.monto).toFixed(2);
                                const compraId = cuota.extendedProps.compra_id;
                                const eventosCompra = (eventos || []).filter(ev => ev.extendedProps && ev.extendedProps.compra_id == compraId);
                                const totalFromMap = totalsMap[compraId];
                                const totalFromProps = (cuota.extendedProps && (cuota.extendedProps.cuotas || cuota.extendedProps.total_cuotas));
                                const totalFromEvents = eventosCompra.length;
                                const totalCuotas = totalFromMap || totalFromProps || totalFromEvents || 0;
                                const pagadasFromMap = pagadasMap[compraId];
                                const pagadasFromEvents = eventosCompra.filter(ev => ev.extendedProps && ev.extendedProps.pagada).length;
                                const pagadasCount = (typeof pagadasFromMap === 'number') ? pagadasFromMap : pagadasFromEvents;
                                const pct = totalCuotas ? Math.round((pagadasCount / totalCuotas) * 100) : 0;
                                htmlList += '<div class="small border rounded p-2 mb-2 bg-light d-flex justify-content-between align-items-center">';
                                htmlList += '  <div class="cuota-info">';
                                htmlList += '    <div><span class="fw-semibold">' + cuota.extendedProps.producto + '</span> · N° ' + cuota.extendedProps.cuota_num + (totalCuotas ? (' de ' + totalCuotas) : '') + '</div>';
                                htmlList += '    <div class="text-muted">' + fechaBonita + ' · <span class="fw-semibold">' + monto + '</span></div>';
                                if (totalCuotas) {
                                    htmlList += '    <div class="mt-1">';
                                    htmlList += '      <div class="progress" style="height:6px;">';
                                    htmlList += '        <div class="progress-bar bg-success" role="progressbar" style="width:' + pct + '%" aria-valuenow="' + pagadasCount + '" aria-valuemin="0" aria-valuemax="' + totalCuotas + '"></div>';
                                    htmlList += '      </div>';
                                    htmlList += '      <div class="small text-muted mt-1">' + pagadasCount + ' de ' + totalCuotas + ' pagadas</div>';
                                    htmlList += '    </div>';
                                }
                                htmlList += '  </div>';
                                htmlList += '  <div class="cuota-actions d-flex gap-2 ms-3 flex-shrink-0">';
                                htmlList += '    <button class="btn btn-sm btn-outline-success btn-square marcar-pagada" data-index="' + idx + '" data-compra="' + cuota.extendedProps.compra_id + '" data-cuota="' + cuota.extendedProps.cuota_num + '" data-monto="' + cuota.extendedProps.monto + '"><i class="fa-solid fa-check me-1"></i>Marcar Pagada</button>';
                                htmlList += '  </div>';
                                htmlList += '</div>';
                            });
                        }
                        // Remover el listado viejo y el total si existen
                        const oldList = bodyEl.querySelectorAll('.small.border.rounded.p-2.mb-2.bg-light, .text-center.text-muted');
                        oldList.forEach(el => el.remove());
                        const existingTotal = bodyEl.querySelector('#modal-actions-total');
                        if (existingTotal) existingTotal.remove();
                        // Insertar nuevo listado y total (siempre insertar, no depender de contenedor previo)
                        const totalPend = nuevas.reduce((sum, ev) => sum + Number(ev.extendedProps?.monto || 0), 0);
                        const totalHtml = '<div id="modal-actions-total" data-total="' + totalPend.toFixed(2) + '" class="d-flex justify-content-end align-items-center mt-2"><span class="fw-semibold total-value">Total: $' + totalPend.toFixed(2) + '</span></div>';
                        bodyEl.insertAdjacentHTML('beforeend', htmlList + totalHtml);
                        // Reasignar handlers de pago
                        bodyEl.querySelectorAll('.marcar-pagada').forEach(btn => {
                            btn.addEventListener('click', async function() {
                                if (this.disabled) return;
                                this.disabled = true;
                                this.textContent = 'Guardando...';
                                const spinner = document.getElementById('modal-spinner');
                                spinner.style.display = 'flex';
                                try {
                                    const res = await fetch(API_BASE + '/api/pago_marcar.php', {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/json'
                                        },
                                        body: JSON.stringify({
                                            compra_id: this.dataset.compra,
                                            cuota_num: this.dataset.cuota,
                                            monto: this.dataset.monto
                                        })
                                    });
                                    const data = await res.json();
                                    if (data.ok) {
                                        const compra = this.dataset.compra;
                                        const cuota = this.dataset.cuota;
                                        this.outerHTML = '<button class="btn btn-sm btn-outline-danger eliminar-pago" data-compra="' + compra + '" data-cuota="' + cuota + '" title="Eliminar pago"><i class="fa-solid fa-trash-can"></i></button>';
                                        attachEliminarHandlers(document.getElementById('modal-body-content'));
                                        // Actualizar total mostrado en el título
                                        const totalEl = document.getElementById('modal-actions-total');
                                        let curr = parseFloat(totalEl.dataset.total || '0');
                                        curr = Math.max(0, curr - Number(this.dataset.monto || 0));
                                        totalEl.dataset.total = curr.toFixed(2);
                                        totalEl.querySelector('.total-value').textContent = 'Total: $' + curr.toFixed(2);
                                        calendar.refetchEvents();
                                        loadResumen();
                                        spinner.style.display = 'none';
                                    } else {
                                        this.disabled = false;
                                        this.textContent = 'Marcar Pagada';
                                        spinner.style.display = 'none';
                                        alert('Error: ' + (data.error || 'desconocido'));
                                    }
                                } catch (e) {
                                    this.disabled = false;
                                    this.textContent = 'Marcar Pagada';
                                    const spinner = document.getElementById('modal-spinner');
                                    spinner.style.display = 'none';
                                    alert('Error de red');
                                }
                            });
                        });
                        attachEliminarHandlers(document.getElementById('modal-body-content'));
                    }
                    bodyEl.querySelector('#btn-quincena-prev').addEventListener('click', function() {
                        cambiarQuincena(-1);
                    });
                    bodyEl.querySelector('#btn-quincena-next').addEventListener('click', function() {
                        cambiarQuincena(1);
                    });

                    // Handlers para marcar pagada en este modal de quincena
                    function updateTotalAfterPayment(monto) {
                        const totalEl = document.getElementById('modal-actions-total');
                        if (!totalEl) return;
                        const valEl = totalEl.querySelector('.total-value');
                        let curr = parseFloat(totalEl.dataset.total || '0');
                        curr = Math.max(0, curr - Number(monto || 0));
                        totalEl.dataset.total = curr.toFixed(2);
                        if (valEl) valEl.textContent = '$' + curr.toFixed(2);
                    }

                    document.getElementById('modal-body-content').querySelectorAll('.marcar-pagada').forEach(btn => {
                        btn.addEventListener('click', async function() {
                            if (this.disabled) return;
                            this.disabled = true;
                            this.textContent = 'Guardando...';
                            const spinner = document.getElementById('modal-spinner');
                            spinner.style.display = 'flex';
                            try {
                                const res = await fetch(API_BASE + '/api/pago_marcar.php', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/json'
                                    },
                                    body: JSON.stringify({
                                        compra_id: this.dataset.compra,
                                        cuota_num: this.dataset.cuota,
                                        monto: this.dataset.monto
                                    })
                                });
                                const data = await res.json();
                                if (data.ok) {
                                    // Reemplazar por botón eliminar (opcional)
                                    const compra = this.dataset.compra;
                                    const cuota = this.dataset.cuota;
                                    this.outerHTML = '<button class="btn btn-sm btn-outline-danger eliminar-pago" data-compra="' + compra + '" data-cuota="' + cuota + '" title="Eliminar pago"><i class="fa-solid fa-trash-can"></i></button>';
                                    // Adjuntar handler de eliminar dentro del cuerpo del modal
                                    attachEliminarHandlers(document.getElementById('modal-body-content'));
                                    // Actualizar total mostrado en el título
                                    updateTotalAfterPayment(this.dataset.monto);
                                    calendar.refetchEvents();
                                    loadResumen();
                                    spinner.style.display = 'none';
                                } else {
                                    this.disabled = false;
                                    this.textContent = 'Marcar Pagada';
                                    spinner.style.display = 'none';
                                    alert('Error: ' + (data.error || 'desconocido'));
                                }
                            } catch (e) {
                                this.disabled = false;
                                this.textContent = 'Marcar Pagada';
                                const spinner = document.getElementById('modal-spinner');
                                spinner.style.display = 'none';
                                alert('Error de red');
                            }
                        });
                    });

                    function attachEliminarHandlers(scope) {
                        (scope || document).querySelectorAll('.eliminar-pago').forEach(btn => {
                            if (btn.dataset._bound) return;
                            btn.dataset._bound = '1';
                            btn.addEventListener('click', async function() {
                                const btn = this;
                                const conf = await Swal.fire({
                                    title: 'Eliminar pago',
                                    text: '¿Eliminar pago?',
                                    icon: 'warning',
                                    showCancelButton: true,
                                    confirmButtonText: 'Sí, eliminar',
                                    cancelButtonText: 'Cancelar'
                                });
                                if (!conf.isConfirmed) return;
                                btn.disabled = true;
                                const spinner = document.getElementById('modal-spinner');
                                spinner.style.display = 'flex';
                                try {
                                    const res = await fetch(API_BASE + '/api/pago_eliminar.php', {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/json'
                                        },
                                        body: JSON.stringify({
                                            compra_id: btn.dataset.compra,
                                            cuota_num: btn.dataset.cuota
                                        })
                                    });
                                    const data = await res.json();
                                    if (data.ok) {
                                        var act = btn.closest('.cuota-actions');
                                        if (act) act.remove();
                                        calendar.refetchEvents();
                                        loadResumen();
                                        spinner.style.display = 'none';
                                    } else {
                                        btn.disabled = false;
                                        spinner.style.display = 'none';
                                        await Swal.fire('Error', data.error || 'desconocido', 'error');
                                    }
                                } catch (e) {
                                    btn.disabled = false;
                                    const spinner = document.getElementById('modal-spinner');
                                    spinner.style.display = 'none';
                                    await Swal.fire('Error', 'Error de red', 'error');
                                }
                            });
                        });
                    }
                });
            }

            // Abrir modal agregar
            document.getElementById('btn-add-compra').addEventListener('click', () => {
                const form = document.getElementById('form-agregar');
                form.reset();
                form.querySelector('input[name="compra_id"]').value = '';
                document.getElementById('modal-agregar-title').textContent = 'Agregar compra';
                const icon = document.getElementById('modal-agregar-icon');
                if (icon) {
                    icon.className = 'fa-solid fa-cart-plus';
                }
                document.getElementById('modal-agregar').style.display = 'flex';
            });

            // Cerrar modal agregar
            document.getElementById('cancel-agregar').addEventListener('click', () => {
                const form = document.getElementById('form-agregar');
                form.reset();
                form.querySelector('input[name="compra_id"]').value = '';
                document.getElementById('modal-agregar-title').textContent = 'Agregar compra';
                const icon2 = document.getElementById('modal-agregar-icon');
                if (icon2) {
                    icon2.className = 'fa-solid fa-cart-plus';
                }
                document.getElementById('modal-agregar').style.display = 'none';
            });
            // (Removed explicit cancel-edit button — cancel/close uses cancel-agregar or clicking outside)
            document.getElementById('modal-agregar').addEventListener('click', (e) => {
                if (e.target.id === 'modal-agregar') {
                    e.currentTarget.style.display = 'none';
                }
            });

            // Envío formulario agregar
            document.getElementById('form-agregar').addEventListener('submit', async (e) => {
                e.preventDefault();
                const fd = new FormData(e.target);
                const compraId = fd.get('compra_id');
                const payload = {
                    compra_id: compraId ? compraId.toString().trim() : null,
                    usuario: fd.get('usuario')?.toString().trim(),
                    producto: fd.get('producto')?.toString().trim(),
                    precio: parseFloat(fd.get('precio')),
                    inicial: parseFloat(fd.get('inicial')),
                    cuotas: parseInt(fd.get('cuotas')),
                    telefono: fd.get('telefono')?.toString().trim(),
                    fecha_compra: fd.get('fecha_compra')
                };
                // Validación mínima
                if (!payload.usuario || !payload.producto || !payload.fecha_compra || isNaN(payload.precio) || isNaN(payload.inicial) || isNaN(payload.cuotas)) {
                    alert('Completa todos los campos.');
                    return;
                }
                // Normalizar teléfono: dejar solo dígitos y validar longitud
                const rawTel = payload.telefono || '';
                let normalizedTel = rawTel.toString().trim();
                // Quitar espacios y caracteres no numéricos excepto +
                const startsWithPlus = normalizedTel.startsWith('+');
                normalizedTel = normalizedTel.replace(/[^0-9+]/g, '');
                // Si inicia con +58, quitar prefijo para validar operador+numero
                if (normalizedTel.indexOf('+58') === 0) normalizedTel = normalizedTel.slice(3);
                // Si no tiene prefijo y tiene 10 dígitos, asumir formato operadora+numero y usarlo
                normalizedTel = normalizedTel.replace(/[^0-9]/g, '');
                const operadoras = ['414', '424', '416', '426', '412', '422'];
                if (normalizedTel.length === 10) {
                    const op = normalizedTel.slice(0, 3);
                    const resto = normalizedTel.slice(3);
                    if (!operadoras.includes(op)) {
                        alert('Operadora inválida. Operadoras válidas: ' + operadoras.join(', '));
                        return;
                    }
                    payload.telefono = '+58' + op + resto;
                } else if (normalizedTel.length === 7) {
                    alert('Ingresá la operadora (3 dígitos) seguida del número (7 dígitos), o el formato completo con +58.');
                    return;
                } else {
                    alert('Teléfono inválido. Usa formato +58{operadora}{7 dígitos} o operadora+numero.');
                    return;
                }
                try {
                    const endpoint = payload.compra_id ? '/api/compra_editar.php' : '/api/compra_agregar.php';
                    const res = await fetch(API_BASE + endpoint, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify(payload)
                    });
                    const data = await res.json();
                    if (data.ok) {
                        e.target.reset();
                        // limpiar modo edicion
                        e.target.querySelector('input[name="compra_id"]').value = '';
                        document.getElementById('modal-agregar').style.display = 'none';
                        calendar.refetchEvents();
                        loadResumen();
                    } else {
                        alert('Error: ' + (data.error || 'No se pudo guardar'));
                    }
                } catch (err) {
                    alert('Error de red');
                }
            });

            // Helpers para formulario agregar: fecha hoy y cálculo de cuota
            const formAgregar = document.getElementById('form-agregar');
            const inputFecha = formAgregar.querySelector('input[name="fecha_compra"]');
            if (inputFecha && !inputFecha.value) {
                const hoy = new Date();
                const yyyy = hoy.getFullYear();
                const mm = String(hoy.getMonth() + 1).padStart(2, '0');
                const dd = String(hoy.getDate()).padStart(2, '0');
                inputFecha.value = `${yyyy}-${mm}-${dd}`;
            }
            const inputPrecio = formAgregar.querySelector('input[name="precio"]');
            const inputInicial = formAgregar.querySelector('input[name="inicial"]');
            const inputCuotas = formAgregar.querySelector('input[name="cuotas"]');
            const resumenCuota = document.getElementById('resumen-cuota');

            function actualizarResumenCuota() {
                const precio = parseFloat(inputPrecio.value);
                const inicial = parseFloat(inputInicial.value);
                const cuotas = parseInt(inputCuotas.value);
                if (isFinite(precio) && isFinite(inicial) && isFinite(cuotas) && cuotas > 0 && precio >= 0 && inicial >= 0 && precio >= inicial) {
                    const restante = precio - inicial;
                    const montoCuota = restante / cuotas;
                    resumenCuota.textContent = `Restante: $${montoCuota ? (restante).toFixed(2) : '0.00'} · Monto por cuota: $${montoCuota.toFixed(2)} (${cuotas} cuotas)`;
                } else {
                    resumenCuota.textContent = 'Completa los campos para ver el monto por cuota.';
                }
            }
            [inputPrecio, inputInicial, inputCuotas].forEach(el => el && el.addEventListener('input', actualizarResumenCuota));
            actualizarResumenCuota();

            // Forzar formato teléfono en tiempo real: siempre empezar con '+' y permitir sólo dígitos después
            const inputTelefono = formAgregar.querySelector('input[name="telefono"]');
            if (inputTelefono) {
                inputTelefono.addEventListener('input', function(e) {
                    let v = this.value || '';
                    // Limpiar y permitir solo + y dígitos
                    v = v.replace(/[^0-9+]/g, '');
                    // Si comienza con +58 dejarlo, sino permitir que escriban operadora+numero o agregar + automáticamente
                    if (v.startsWith('+58')) {
                        // Mantener +58 y luego sólo dígitos (operadora+numero)
                        let rest = v.slice(3).replace(/[^0-9]/g, '');
                        if (rest.length > 10) rest = rest.slice(0, 10);
                        v = '+58' + rest;
                    } else {
                        // No truncar agresivamente: permitir que el usuario escriba operadora y número con formato libre
                        // Limitar a 19 caracteres en total para evitar overflow, la normalización final ocurre al enviar
                        if (v.length > 19) v = v.slice(0, 19);
                    }
                    this.value = v;
                });
            }

            // Permitir pasar al siguiente campo con Enter dentro del modal de registro
            (function enableEnterToNext() {
                const form = document.getElementById('form-agregar');
                if (!form) return;
                const selector = 'input:not([type=hidden]):not([type=submit]):not([type=button]), select, textarea';
                let fields = Array.from(form.querySelectorAll(selector)).filter(f => !f.disabled && f.offsetParent !== null);
                // Recompute visible fields when modal opens (in case of dynamic display)
                function refreshFields() {
                    fields = Array.from(form.querySelectorAll(selector)).filter(f => !f.disabled && f.offsetParent !== null);
                }
                // Attach handler to form (delegation) to handle dynamically-visible fields
                form.addEventListener('keydown', function(e) {
                    if (e.key !== 'Enter') return;
                    const target = e.target;
                    // Only handle if target is one of our fields
                    if (!form.contains(target)) return;
                    // Allow Enter default for multi-line textareas
                    if (target.tagName === 'TEXTAREA') return;
                    // Prevent form submit and move focus to next field
                    e.preventDefault();
                    refreshFields();
                    const idx = fields.indexOf(target);
                    const next = (idx >= 0) ? fields[idx + 1] : null;
                    if (next) {
                        next.focus();
                        if (typeof next.select === 'function') next.select();
                    } else {
                        // No next field: submit the form
                        if (typeof form.requestSubmit === 'function') form.requestSubmit();
                        else form.submit();
                    }
                });
            })();

            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                locale: 'es',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay'
                },
                // Textos de botones en español
                buttonText: {
                    today: 'Hoy',
                    month: 'Mes',
                    week: 'Semana',
                    day: 'Día',
                    list: 'Lista'
                },
                // Mostrar encabezados con nombre completo del día (domingo, lunes, ...)
                dayHeaderFormat: {
                    weekday: 'long'
                },
                dayMaxEvents: true,
                displayEventTime: false,
                events: API_BASE + '/api/cuotas.php',
                dateClick: function(info) {
                    const spinner = document.getElementById('modal-spinner');
                    const modalEl = document.getElementById('modal');
                    const modalContent = document.getElementById('modal-content');
                    document.getElementById('modal-body-content').innerHTML = '';
                    document.getElementById('modal-actions-container').innerHTML = '';
                    modalEl.style.display = 'flex';
                    // Vista de una sola columna para modal desde calendario: usar flex en columna para evitar 2 columnas
                    modalContent.style.display = 'flex';
                    modalContent.style.flexDirection = 'column';
                    modalContent.style.width = '32%';
                    modalContent.style.maxWidth = '440px';
                    modalContent.style.minWidth = '320px';
                    const actionsContainer = document.getElementById('modal-actions-container');
                    actionsContainer.style.display = 'none';
                    spinner.style.display = 'flex';
                    Promise.all([
                        fetch(API_BASE + '/api/cuotas.php').then(r => r.json()),
                        getCuotasStatsMap()
                    ]).then(([eventos, cuotasStats]) => {
                        const totalsMap = (cuotasStats && cuotasStats.totales) || {};
                        const pagadasMap = (cuotasStats && cuotasStats.pagadas) || {};
                        var cuotasDia = eventos.filter(ev => ev.start === info.dateStr);
                        var html = '';

                        // Formatear fecha (YYYY-MM-DD -> D de mes de YYYY)
                        function formatFecha(fechaStr) {
                            const meses = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
                            const [y, m, d] = fechaStr.split('-');
                            return parseInt(d) + ' de ' + meses[parseInt(m) - 1] + ' de ' + y;
                        }
                        const fechaFormateada = formatFecha(info.dateStr);

                        if (cuotasDia.length > 0) {
                            html = '<div style="text-align:center;font-size:1.05rem;font-weight:600;color:#222;margin:0 0 16px;">' + fechaFormateada + '</div>';
                            cuotasDia.forEach(function(cuota, idx) {
                                const usuario = cuota.title.split(' - ')[0];
                                const monto = '$' + Number(cuota.extendedProps.monto).toFixed(2);
                                const compraId = cuota.extendedProps.compra_id;
                                const eventosCompra = (eventos || []).filter(ev => ev.extendedProps && ev.extendedProps.compra_id == compraId);
                                const totalFromMap = totalsMap[compraId];
                                const totalFromProps = (cuota.extendedProps && (cuota.extendedProps.cuotas || cuota.extendedProps.total_cuotas));
                                const totalFromEvents = eventosCompra.length;
                                const totalCuotas = totalFromMap || totalFromProps || totalFromEvents || 0;
                                const pagadasFromMap = pagadasMap[compraId];
                                const pagadasFromEvents = eventosCompra.filter(ev => ev.extendedProps && ev.extendedProps.pagada).length;
                                const pagadasCount = (typeof pagadasFromMap === 'number') ? pagadasFromMap : pagadasFromEvents;
                                const pct = totalCuotas ? Math.round((pagadasCount / totalCuotas) * 100) : 0;
                                html += '<div class="mb-3 p-3 rounded border d-flex justify-content-between align-items-center" style="background:#f8fbff;">';
                                html += '  <div class="cuota-info" style="min-width:0;">';
                                html += '    <div style="font-weight:600; color:#111;">' + usuario + '</div>';
                                html += '    <div><strong>Monto:</strong> ' + monto + '</div>';
                                html += '    <div><strong>Producto:</strong> ' + cuota.extendedProps.producto + '</div>';
                                html += '    <div><strong>Cuota N°:</strong> ' + cuota.extendedProps.cuota_num + (totalCuotas ? (' de ' + totalCuotas) : '') + '</div>';
                                html += '    <div><strong>Estado:</strong> ' + (cuota.extendedProps.pagada ? '<span class="badge bg-success">Pagada</span>' : '<span class="badge bg-warning text-dark">Pendiente</span>') + '</div>';
                                if (totalCuotas) {
                                    html += '    <div class="mt-2">';
                                    html += '      <div class="progress" style="height:6px;">';
                                    html += '        <div class="progress-bar bg-success" role="progressbar" style="width:' + pct + '%" aria-valuenow="' + pagadasCount + '" aria-valuemin="0" aria-valuemax="' + totalCuotas + '"></div>';
                                    html += '      </div>';
                                    html += '      <div class="small text-muted mt-1">' + pagadasCount + ' de ' + totalCuotas + ' pagadas</div>';
                                    html += '    </div>';
                                }
                                html += '  </div>';
                                html += '  <div class="cuota-actions d-flex gap-2 ms-3 flex-shrink-0">';
                                if (!cuota.extendedProps.pagada) {
                                    html += '    <button class="btn btn-sm btn-outline-success btn-square marcar-pagada" data-index="' + idx + '" data-compra="' + cuota.extendedProps.compra_id + '" data-cuota="' + cuota.extendedProps.cuota_num + '" data-monto="' + cuota.extendedProps.monto + '"><i class="fa-solid fa-check me-1"></i>Marcar Pagada</button>';
                                } else {
                                    html += '    <button class="btn btn-sm btn-outline-danger eliminar-pago" data-index="' + idx + '" data-compra="' + cuota.extendedProps.compra_id + '" data-cuota="' + cuota.extendedProps.cuota_num + '" title="Eliminar pago"><i class="fa-solid fa-trash-can"></i></button>';
                                }
                                html += '  </div>';
                                html += '</div>';
                            });
                        } else {
                            html = '<div class="text-center text-muted">No hay cuotas para este día.</div>';
                        }
                        document.getElementById('modal-body-content').innerHTML = html;
                        spinner.style.display = 'none';

                        // Listeners de acciones (placeholder)
                        function refetchAfter(ms = 400) {
                            setTimeout(() => {
                                calendar.refetchEvents();
                                loadResumen();
                            }, ms);
                        }

                        function attachEliminarHandlers(scope) {
                            (scope || document).querySelectorAll('.eliminar-pago').forEach(btn => {
                                if (btn.dataset._bound) return;
                                btn.dataset._bound = '1';
                                btn.addEventListener('click', async function() {
                                    const btn = this;
                                    const conf = await Swal.fire({
                                        title: 'Eliminar pago',
                                        text: '¿Eliminar pago?',
                                        icon: 'warning',
                                        showCancelButton: true,
                                        confirmButtonText: 'Sí, eliminar',
                                        cancelButtonText: 'Cancelar'
                                    });
                                    if (!conf.isConfirmed) return;
                                    btn.disabled = true;
                                    const spinner = document.getElementById('modal-spinner');
                                    spinner.style.display = 'flex';
                                    try {
                                        const res = await fetch(API_BASE + '/api/pago_eliminar.php', {
                                            method: 'POST',
                                            headers: {
                                                'Content-Type': 'application/json'
                                            },
                                            body: JSON.stringify({
                                                compra_id: btn.dataset.compra,
                                                cuota_num: btn.dataset.cuota
                                            })
                                        });
                                        const data = await res.json();
                                        if (data.ok) {
                                            var act = btn.closest('.cuota-actions');
                                            if (act) act.remove();
                                            refetchAfter();
                                            spinner.style.display = 'none';
                                        } else {
                                            btn.disabled = false;
                                            spinner.style.display = 'none';
                                            await Swal.fire('Error', data.error || 'desconocido', 'error');
                                        }
                                    } catch (e) {
                                        btn.disabled = false;
                                        const spinner = document.getElementById('modal-spinner');
                                        spinner.style.display = 'none';
                                        await Swal.fire('Error', 'Error de red', 'error');
                                    }
                                });
                            });
                        }
                        document.getElementById('modal-body-content').querySelectorAll('.marcar-pagada').forEach(btn => {
                            btn.addEventListener('click', async function() {
                                if (this.disabled) return;
                                this.disabled = true;
                                this.textContent = 'Guardando...';
                                const spinner = document.getElementById('modal-spinner');
                                spinner.style.display = 'flex';
                                try {
                                    const res = await fetch(API_BASE + '/api/pago_marcar.php', {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/json'
                                        },
                                        body: JSON.stringify({
                                            compra_id: this.dataset.compra,
                                            cuota_num: this.dataset.cuota,
                                            monto: this.dataset.monto
                                        })
                                    });
                                    const data = await res.json();
                                    if (data.ok) {
                                        const compra = this.dataset.compra;
                                        const cuota = this.dataset.cuota;
                                        this.outerHTML = '<button class="btn btn-sm btn-outline-danger eliminar-pago" data-compra="' + compra + '" data-cuota="' + cuota + '"><i class="fa-solid fa-trash-can me-1"></i>Eliminar pago</button>';
                                        attachEliminarHandlers(document.getElementById('modal-body-content'));
                                        refetchAfter();
                                        spinner.style.display = 'none';
                                    } else {
                                        this.disabled = false;
                                        this.textContent = 'Marcar Pagada';
                                        spinner.style.display = 'none';
                                        alert('Error: ' + (data.error || 'desconocido'));
                                    }
                                } catch (e) {
                                    this.disabled = false;
                                    this.textContent = 'Marcar Pagada';
                                    const spinner = document.getElementById('modal-spinner');
                                    spinner.style.display = 'none';
                                    alert('Error de red');
                                }
                            });
                        });
                        attachEliminarHandlers(document.getElementById('modal-body-content'));
                    });
                }
            });
            // Ajuste responsive: simplificar toolbar en móviles y restaurar en pantallas grandes
            function applyResponsiveToolbar() {
                const isMobile = window.innerWidth <= 600;
                if (isMobile) {
                    calendar.setOption('headerToolbar', {
                        left: 'prev,next',
                        center: 'title',
                        right: 'today'
                    });
                } else {
                    calendar.setOption('headerToolbar', {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'dayGridMonth,timeGridWeek,timeGridDay'
                    });
                }
            }
            applyResponsiveToolbar();
            window.addEventListener('resize', applyResponsiveToolbar);
            // calendar will be rendered only after successful authentication
            var calendarRendered = false;

            // Cerrar modal al hacer clic fuera del contenido
            var modal = document.getElementById('modal');
            var modalContent = document.getElementById('modal-content');
            modal.addEventListener('click', function(e) {
                if (e.target === modal) {
                    modal.style.display = 'none';
                    document.getElementById('modal-content').classList.remove('auth-clean');
                }
            });
            // Botón cerrar eliminado. Se cierra clic fuera del contenido.

            // --- Autenticación: UI mínima ---
            function refreshUserArea() {
                fetch(API_BASE + '/api/auth_status.php').then(r => r.json()).then(data => {
                    const area = document.getElementById('user-area');
                    const layout = document.querySelector('.layout');
                    if (data && data.ok) {
                        // Mostrar interfaz solo cuando el usuario está autenticado
                        area.innerHTML = '<span class="small text-muted me-2">' + (data.username || '') + '</span><button id="btn-logout" class="btn btn-sm btn-outline-secondary">Salir</button>';
                        document.getElementById('btn-logout').addEventListener('click', async () => {
                            await fetch(API_BASE + '/api/auth_logout.php');
                            // Al cerrar sesión volver a forzar login y ocultar la UI
                            document.getElementById('modal-content').classList.remove('auth-clean');
                            refreshUserArea();
                            if (calendarRendered) {
                                calendar.refetchEvents();
                                loadResumen();
                            }
                        });
                        // Mostrar y renderizar interfaz si aún no se ha hecho
                        if (layout) layout.style.display = '';
                        if (!calendarRendered) {
                            try {
                                calendar.render();
                                calendarRendered = true;
                            } catch (e) {
                                // ignore render errors
                            }
                        } else {
                            calendar.refetchEvents();
                        }
                        loadResumen();
                    } else {
                        // Mantener la UI oculta y forzar modal de login en primera visita
                        if (layout) layout.style.display = 'none';
                        area.innerHTML = '<button id="btn-login" class="btn btn-sm btn-outline-primary">Iniciar sesión</button>';
                        document.getElementById('btn-login').addEventListener('click', () => showAuthModal());
                        // Abrir modal automáticamente para forzar login
                        showAuthModal();
                    }
                }).catch(() => {
                    // En caso de error de red o similar, forzar modal y ocultar UI
                    const layout = document.querySelector('.layout');
                    if (layout) layout.style.display = 'none';
                    showAuthModal();
                });
            }

            function showAuthModal() {
                // Modo combinado: false = login, true = register
                let isRegister = false;
                const modal = document.getElementById('modal');
                const body = document.getElementById('modal-body-content');
                const actions = document.getElementById('modal-actions-container');
                document.getElementById('modal-spinner').style.display = 'none';

                function render() {
                    const title = isRegister ? 'Crear cuenta' : 'Iniciar sesión';
                    const submitText = isRegister ? 'Registrar' : 'Ingresar';
                    const toggleText = isRegister ? '¿Ya tienes cuenta? Iniciar sesión' : 'Crear una cuenta';
                    body.innerHTML = `
                        <div class="card border-0 shadow-sm">
                            <div class="card-body p-3">
                                <div class="text-center mb-3">
                                    <div style="font-size:1.05rem;font-weight:700;">${title}</div>
                                    <div class="text-muted small">Accede para ver y administrar tus compras</div>
                                </div>
                                <div id="auth-error" class="text-danger small" style="display:none;margin-bottom:8px"></div>
                                <form id="auth-form">
                                    <div class="form-floating mb-2">
                                        <input id="auth-username" name="username" type="text" class="form-control form-control-sm" placeholder="Usuario">
                                        <label for="auth-username">Usuario</label>
                                    </div>
                                    <div class="form-floating mb-2">
                                        <input id="auth-password" name="password" type="password" class="form-control form-control-sm" placeholder="Contraseña">
                                        <label for="auth-password">Contraseña</label>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" value="1" id="auth-remember">
                                            <label class="form-check-label small" for="auth-remember">Recordarme</label>
                                        </div>
                                        <a href="#" id="auth-toggle-mode" class="small">${toggleText}</a>
                                    </div>
                                    <div class="d-grid">
                                        <button id="auth-submit" type="submit" class="btn btn-primary btn-sm">${submitText}</button>
                                    </div>
                                </form>
                                <div class="text-center small text-muted mt-3">¿Problemas para ingresar? Contacta al administrador.</div>
                            </div>
                        </div>
                    `;
                    actions.innerHTML = '';
                    // mark modal content as auth-clean for styling
                    const modalContentEl = document.getElementById('modal-content');
                    // remove inline width set by other modal flows
                    modalContentEl.style.width = '';
                    modalContentEl.classList.add('auth-clean');
                    modal.style.display = 'flex';

                    // Focus al primer campo
                    const u = document.getElementById('auth-username');
                    if (u) u.focus();

                    // Bind form submit and toggle using delegation to avoid duplicate listeners
                    const err = document.getElementById('auth-error');
                    const form = document.getElementById('auth-form');
                    const toggle = document.getElementById('auth-toggle-mode');
                    const submitBtn = document.getElementById('auth-submit');

                    // Remove any previous binding marker and listener
                    if (form._bound) {
                        form.removeEventListener('submit', form._bound);
                        form._bound = null;
                    }

                    form._bound = async function(e) {
                        e.preventDefault();
                        err.style.display = 'none';
                        const username = (form.username.value || '').toString().trim();
                        const password = (form.password.value || '').toString();
                        if (!username || !password) {
                            err.textContent = 'Usuario y contraseña son obligatorios';
                            err.style.display = '';
                            return;
                        }
                        submitBtn.disabled = true;
                        submitBtn.textContent = isRegister ? 'Registrando...' : 'Ingresando...';
                        try {
                            const endpoint = isRegister ? API_BASE + '/api/auth_register.php' : API_BASE + '/api/auth_login.php';
                            const res = await fetch(endpoint, {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json'
                                },
                                body: JSON.stringify({
                                    username,
                                    password
                                })
                            });
                            if (res.status === 401) {
                                err.textContent = 'Credenciales inválidas';
                                err.style.display = '';
                                submitBtn.disabled = false;
                                submitBtn.textContent = isRegister ? 'Registrar' : 'Ingresar';
                                return;
                            }
                            const data = await res.json();
                            if (data && data.ok) {
                                modal.style.display = 'none';
                                document.getElementById('modal-content').classList.remove('auth-clean');
                                refreshUserArea();
                                if (!calendarRendered) {
                                    try {
                                        calendar.render();
                                        calendarRendered = true;
                                    } catch (e) {}
                                } else {
                                    calendar.refetchEvents();
                                }
                                loadResumen();
                            } else {
                                err.textContent = data && data.error ? data.error : 'Error desconocido';
                                err.style.display = '';
                                submitBtn.disabled = false;
                                submitBtn.textContent = isRegister ? 'Registrar' : 'Ingresar';
                            }
                        } catch (e) {
                            err.textContent = 'Error de red';
                            err.style.display = '';
                            submitBtn.disabled = false;
                            submitBtn.textContent = isRegister ? 'Registrar' : 'Ingresar';
                        }
                    };
                    form.addEventListener('submit', form._bound);

                    // Toggle entre login / register
                    toggle.addEventListener('click', function(ev) {
                        ev.preventDefault();
                        isRegister = !isRegister;
                        render();
                    });
                }

                render();
            }

            // Detectar 401 y abrir modal de login
            const _fetch = window.fetch;
            window.fetch = async function(input, init) {
                const res = await _fetch(input, init);
                if (res.status === 401) {
                    showAuthModal();
                }
                return res;
            };

            refreshUserArea();
        });
    </script>
</body>

</html>