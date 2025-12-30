<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Bodega - móvil</title>
    <meta name="description" content="Gestión de inventario optimizada para móvil" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body>
    <div class="app">

        <header class="app-header d-flex align-items-center justify-content-between" style="gap:12px;">
            <div style="display:flex;flex-direction:column;align-items:flex-start;min-width:170px;max-width:260px;">
                <span id="tasa-info" class="badge bg-primary" style="overflow:ellipsis;">
                    <i class="fa-solid fa-dollar-sign"></i> <span id="tasa-valor" class="small fw-bold" style="font-size: 1.1em;"></span>
                </span>
                <span class="small text-muted mt-1" style="font-size: 0.8em;">
                    Fecha: <span id="tasa-fecha" class="fw-bold"></span>
                </span>
            </div>
            <div class="header-actions">
                <button id="btn-print" class="btn btn-outline-success btn-sm me-2" title="Imprimir etiquetas"><i class="fa-solid fa-print"></i></button>
                <button id="btn-print-table" class="btn btn-outline-success btn-sm me-2" title="Imprimir tabla de precios"><i class="fa-solid fa-table-list"></i></button>
                <a href="inventario_bajo.php" target="_blank" class="btn btn-outline-warning btn-sm me-2" title="Ver Inventario Bajo"><i class="fa-solid fa-triangle-exclamation"></i></a>
                <button id="btn-add" class="btn btn-outline-primary btn-sm me-2" title="Nuevo"><i class="fa-solid fa-plus"></i></button>
                <a href="cuenta.php" class="btn btn-outline-info btn-sm" title="Calculadora de Cuenta" style="vertical-align:middle;">
                    <i class="fa-solid fa-calculator"></i>
                </a>
                <!-- <a href="tv.php" class="btn btn-outline-dark btn-sm" title="Ver en TV" style="vertical-align:middle;">
                    <i class="fa-solid fa-tv"></i>
                </a> -->
            </div>
        </header>

        <main class="app-main">
            <div class="search-bar">
                <input id="search" type="search" placeholder="Buscar por nombre, proveedor o precio" />
            </div>
            <div id="list" class="list"></div>
        </main>

        <!-- Modal estilo Cashea para el formulario de producto -->
        <div class="modal fade" id="form-sheet" tabindex="-1" aria-labelledby="formModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content modal-add-content">
                    <div class="modal-add-header d-flex align-items-center gap-2 mb-3">
                        <div class="modal-add-icon"><i class="fa-solid fa-box"></i></div>
                        <div class="modal-add-title" id="formModalLabel">Producto</div>
                        <button type="button" class="btn-close ms-auto" data-bs-dismiss="modal"
                            aria-label="Cerrar"></button>
                    </div>
                    <div class="modal-body">
                        <form id="product-form" class="row g-3">
                            <input type="hidden" name="id" />
                            <input type="hidden" name="tasa_actual_oculta" id="tasa_actual_oculta" />
                            <div class="col-12">
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text"><i class="fa-solid fa-tag"></i></span>
                                    <input name="nombre" required class="form-control form-control-sm"
                                        placeholder="Nombre del producto" />
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text"><i class="fa-solid fa-truck"></i></span>
                                    <select name="proveedor" id="proveedor-select" class="form-select form-select-sm"
                                        style="flex:1 1 auto;"></select>
                                    <input name="proveedor_manual" id="proveedor-manual"
                                        class="form-control form-control-sm" placeholder="Otro proveedor"
                                        style="display:none;" />
                                </div>
                            </div>
                            <div class="col-12 col-md-6 d-flex align-items-center">
                                <div class="input-group input-group-sm" style="flex:1;">
                                    <span class="input-group-text"><i class="fa-solid fa-ruler"></i></span>
                                    <select name="unidad_medida" class="form-select form-select-sm" style="max-width:120px;">
                                        <option value="unidad">Unidad</option>
                                        <option value="paquete">Paquete</option>
                                        <option value="kg">Kilogramo</option>
                                    </select>
                                </div>
                                <div class="form-check ms-2">
                                    <input class="form-check-input" type="checkbox" id="cuCheck" name="cuCheck">
                                    <label class="form-check-label" for="cuCheck">c/u</label>
                                </div>
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label">Tamaño paquete (opcional)</label>
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text"><i class="fa-solid fa-cubes"></i></span>
                                    <input name="tam_paquete" type="number" step="0.001" min="0"
                                        class="form-control form-control-sm" placeholder="Ej: 12" />
                                </div>
                            </div>
                            <div class="col-12 col-md-8">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="1" id="vende_media" name="vende_media">
                                    <label class="form-check-label" for="vende_media">
                                        Se vende por medio paquete
                                    </label>
                                </div>
                            </div>
                            <div class="col-12 col-md-6" id="group-precio-venta-medio-paquete" style="display:none;">
                                <label class="form-label">Precio venta medio paquete</label>
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text"><i class="fa-solid fa-box-open"></i></span>
                                    <input name="precio_venta_medio_paquete" type="number" step="0.01" min="0"
                                        class="form-control form-control-sm" placeholder="0.00" />
                                </div>
                            </div>
                            <div class="col-12 col-md-8">
                                <label class="form-label">Precio compra</label>
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text"><i class="fa-solid fa-dollar-sign"></i></span>
                                    <input name="precio_compra" id="precio_compra" type="number" step="0.01" min="0"
                                        value="" class="form-control form-control-sm" placeholder="0.00" />
                                    <select name="moneda_compra" id="moneda_compra" class="form-select form-select-sm"
                                        style="max-width:90px">
                                        <option value="USD">USD</option>
                                        <option value="BS">Bs</option>
                                    </select>
                                </div>
                                    <div class="input-group input-group-sm" style="max-width: 150px;">
                                        <span class="input-group-text p-0">
                                            <input type="date" id="tasa_date_picker" style="width: 0; height: 0; padding: 0; border: none; position: absolute; visibility: hidden;">
                                            <button type="button" class="btn btn-link btn-sm text-decoration-none" id="btn-tasa-calendar" title="Buscar por fecha" style="color: inherit;"><i class="fa-solid fa-calendar-days"></i></button>
                                        </span>
                                        <input type="number" id="tasa_calculo" class="form-control form-control-sm" placeholder="Tasa" step="any">
                                    </div>
                                    <button type="button" id="btn-convert-bs-usd" class="btn btn-outline-primary btn-sm flex-grow-1" title="Convertir con esta tasa"><i class="fa-solid fa-rotate"></i> Convertir</button>
                                    <button type="button" id="btn-add-16-percent" class="btn btn-outline-warning btn-sm" title="Aumentar 16%">+16%</button>
                                </div>
                                <div id="precio_compra_bs_info" class="small text-muted mt-1" style="display:none;"></div>
                                <div id="precio_compra_unitario_info" class="small text-info mt-1" style="display:none;"></div>
                            </div>
                            <div class="col-12 col-md-6" id="group-precio-venta-paquete" style="display:none;">
                                <label class="form-label">Precio venta paquete</label>
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text"><i class="fa-solid fa-box"></i></span>
                                    <input name="precio_venta_paquete" type="number" step="0.01" min="0"
                                        class="form-control form-control-sm" placeholder="0.00" />
                                </div>
                            </div>
                            <div class="col-12 col-md-7" id="label-precio-unidad">
                                <label class="form-label">Precio venta por unidad</label>
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text"><i class="fa-solid fa-dollar-sign"></i></span>
                                    <input id="precio_venta_unidad" name="precio_venta_unidad" type="number" step="0.01"
                                        min="0" value="" class="form-control form-control-sm" placeholder="0.00" />
                                    <button type="button" id="btn-20-percent" class="btn btn-outline-secondary btn-sm">20%</button>
                                    <button type="button" id="btn-25-percent" class="btn btn-outline-secondary btn-sm">25%</button>
                                    <button type="button" id="btn-30-percent" class="btn btn-outline-secondary btn-sm">30%</button>
                                </div>
                                <div id="ganancia_info" class="small text-info mt-1" style="display:none;"></div>
                            </div>
                            <div class="col-12 d-flex justify-content-end gap-2 mt-1">
                                <button type="submit" class="btn btn-sm btn-success"><i
                                        class="fa-solid fa-floppy-disk me-1"></i>Guardar</button>
                                <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal"><i
                                        class="fa-solid fa-xmark me-1"></i>Cancelar</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>


        <!-- Eliminada barra de edición de tasa, solo informativa arriba -->

        <script>
            // Mostrar porcentaje de ganancia debajo del precio de venta por unidad
            function updateGananciaInfo() {
                const pv = parseFloat(document.getElementById('precio_venta_unidad').value);
                const pc = parseFloat(document.getElementById('precio_compra').value);
                const tam = parseFloat(document.querySelector('[name="tam_paquete"]').value) || 1;
                const unidad = document.querySelector('[name="unidad_medida"]').value;
                let pc_unit = pc;
                // Si es paquete, la base es el precio de compra por unidad
                if (unidad === 'paquete' && tam > 0) {
                    pc_unit = pc / tam;
                }
                const info = document.getElementById('ganancia_info');
                if (pc_unit > 0 && pv > 0) {
                    const ganancia = ((pv - pc_unit) / pc_unit) * 100;
                    info.textContent = `Ganancia: ${ganancia.toFixed(1)}% (base: ${pc_unit.toFixed(2)})`;
                    info.style.display = '';
                } else {
                    info.textContent = '';
                    info.style.display = 'none';
                }
            }
            document.addEventListener('DOMContentLoaded', () => {
                document.getElementById('precio_venta_unidad').addEventListener('input', updateGananciaInfo);
                document.getElementById('precio_compra').addEventListener('input', updateGananciaInfo);
                document.querySelector('[name="tam_paquete"]').addEventListener('input', updateGananciaInfo);
                document.querySelector('[name="unidad_medida"]').addEventListener('change', updateGananciaInfo);
            });
            // Seleccionar todo el contenido del input de precio_compra si es 0 al hacer focus
            document.addEventListener('DOMContentLoaded', () => {
                const precioCompraInput = document.getElementById('precio_compra');
                if (precioCompraInput) {
                    precioCompraInput.addEventListener('focus', function() {
                        if (this.value == 0 || this.value == '0' || this.value == '0.00') {
                            this.select();
                        }
                    });
                }
            });
            // Declarar solo una vez las variables globales
            let timeout = null;
            let exchangeRate = 0;
            let exchangeDate = '';
            const btnPrint = document.getElementById('btn-print');
            let actionsVisible = true;

            const API_VER = 'api/ver.php';
            const API_CREAR = 'api/crear.php';
            const API_EDITAR = 'api/editar.php';
            const API_ELIMINAR = 'api/eliminar.php';

            function el(selector, parent = document) {
                return parent.querySelector(selector);
            }

            function show(elm) {
                elm.classList.remove('hidden');
            }

            function hide(elm) {
                elm.classList.add('hidden');
            }

            const listEl = el('#list');
            const searchEl = el('#search');
            const formSheet = el('#form-sheet');
            const form = el('#product-form');
            const btnAdd = el('#btn-add');
            let checkedProductIds = new Set();

            async function fetchList(q) {
                const url = API_VER + (q ? '?q=' + encodeURIComponent(q) : '');
                const res = await fetch(url);
                const data = await res.json();
                renderList(data);
            }

            function renderList(items) {
                if (!Array.isArray(items) || items.length === 0) {
                    listEl.innerHTML = '<div class="empty">Sin productos</div>';
                    return;
                }
                listEl.innerHTML = items.map(i => {
                    const unidad = i.unidad_medida || 'unidad';
                    const precioPaquete = (i.precio_venta_paquete !== undefined && i.precio_venta_paquete !== null && i.precio_venta_paquete !== '') ? Number(i.precio_venta_paquete) : null;
                    const precioUnidad = (i.precio_venta_unidad !== undefined && i.precio_venta_unidad !== null && i.precio_venta_unidad !== '') ? Number(i.precio_venta_unidad) : null;
                    const legacyVenta = Number(i.precio_venta || 0);
                    // Mostrar solo precios de venta
                    let precioVentaInfo = '';
                    if (unidad === 'paquete' && i.tam_paquete && Number(i.tam_paquete) > 0) {
                        // Mostrar primero precio por unidad y luego por paquete, primero Bs y luego USD
                        const paquetePrecio = precioPaquete !== null ? precioPaquete : legacyVenta;
                        const per = paquetePrecio / Number(i.tam_paquete);
                        // Unidad Bs
                        if (exchangeRate) {
                            precioVentaInfo = `Unidad: ${(Number(precioUnidad !== null ? precioUnidad : per) * Number(exchangeRate)).toFixed(2)} Bs`;
                        } else {
                            precioVentaInfo = '';
                        }
                        // Unidad USD
                        if (precioUnidad !== null) {
                            precioVentaInfo += `<br>Unidad: ${Number(precioUnidad).toFixed(2)} USD`;
                        } else {
                            precioVentaInfo += `<br>Unidad: ${Number(per).toFixed(2)} USD`;
                        }
                        // Paquete Bs
                        if (exchangeRate) {
                            precioVentaInfo += `<br>Paquete: ${(Number(paquetePrecio) * Number(exchangeRate)).toFixed(2)} Bs`;
                        }
                        // Paquete USD
                        precioVentaInfo += `<br>Paquete: ${Number(paquetePrecio).toFixed(2)} USD`;

                        if (i.vende_media == 1) {
                            // Medio Paquete Bs
                            if (exchangeRate) {
                                precioVentaInfo += `<br>Medio Paquete: ${(Number(i.precio_venta_medio_paquete !== undefined && i.precio_venta_medio_paquete !== null ? i.precio_venta_medio_paquete : (paquetePrecio / 2)) * Number(exchangeRate)).toFixed(2)} Bs`;
                            }
                            // Medio Paquete USD
                            precioVentaInfo += `<br>Medio Paquete: ${Number(i.precio_venta_medio_paquete !== undefined && i.precio_venta_medio_paquete !== null ? i.precio_venta_medio_paquete : (paquetePrecio / 2)).toFixed(2)} USD`;
                        }

                    } else {
                        // Mostrar solo precio unitario, primero Bs y luego USD
                        const use = precioUnidad !== null ? precioUnidad : legacyVenta;
                        if (exchangeRate) {
                            precioVentaInfo = `Unidad: ${(Number(use) * Number(exchangeRate)).toFixed(2)} Bs`;
                        } else {
                            precioVentaInfo = '';
                        }
                        precioVentaInfo += `<br>Unidad: ${Number(use).toFixed(2)} USD`;
                    }
                    let presentation = '';
                    if (unidad === 'paquete' && i.tam_paquete && Number(i.tam_paquete) > 0) {
                        presentation = `Presentación: 1 paquete = ${parseInt(i.tam_paquete, 10)} unidades`;
                    }
                    // Resaltar nombre y precios por unidad
                    let precioVentaInfoResaltado = precioVentaInfo
                        .replace(/Unidad: ([^<]*) Bs/g, '<span class="fw-bold text-primary">Unidad: $1 Bs</span>')
                        .replace(/Unidad: ([^<]*) USD/g, '<span class="fw-bold text-primary">Unidad: $1 $</span>');
                    // Mostrar precio de compra con moneda
                    let precioCompraInfo = '';
                    let precioVentaInfoResaltadoFinal = '';
                    if (i.moneda_compra === 'BS') {
                        // Mostrar solo precios de venta en Bs y en azul, incluyendo la palabra
                        let ventaBs = '';
                        if (i.precio_venta_paquete) {
                            ventaBs += `<span class=\"fw-bold text-primary\">Paquete:</span> <span class=\"fw-bold text-primary\">${Number(i.precio_venta_paquete).toFixed(2)} Bs</span><br>`;
                        }
                        if (i.precio_venta_unidad) {
                            ventaBs += `<span class=\"fw-bold text-primary\">Unidad:</span> <span class=\"fw-bold text-primary\">${Number(i.precio_venta_unidad).toFixed(2)} Bs</span>`;
                        }
                        precioVentaInfoResaltadoFinal = ventaBs;
                    } else if (i.moneda_compra === 'USD') {
                        precioVentaInfoResaltadoFinal = precioVentaInfoResaltado;
                    } else {
                        precioVentaInfoResaltadoFinal = precioVentaInfoResaltado;
                    }
                    // Si el inventario está bajo, agregar clase de fondo rojo claro
                    const bajoClass = i.bajo_inventario == 1 ? 'bg-danger bg-opacity-25' : '';
                    return `<div class="item d-flex align-items-center ${bajoClass}" data-id="${i.id}">
                        <input type="checkbox" class="select-product me-2" value="${i.id}" style="width:1.5em;height:1.5em;">
                        <div class="flex-grow-1">
                            <div class="row">
                                <div class="col name">
                                    <span class="fw-bold" style="font-size:1.15em;">${escapeHtml(i.nombre)}</span>
                                    ${presentation ? `<div class="presentation small text-muted" style="margin-top:0;">${escapeHtml(presentation)}</div>` : ''}
                                    <div class="actions d-flex gap-2 mt-2">
                                        <button class="btn btn-sm btn-outline-primary edit" title="Editar"><i class="fa-solid fa-pen-to-square"></i></button>
                                        <button class="btn btn-sm btn-outline-danger del" title="Eliminar"><i class="fa-solid fa-trash"></i></button>
                                        <div class="form-check form-switch">
                                            <input class="form-check-input stock-toggle" type="checkbox" role="switch" id="stockToggle_${i.id}" data-id="${i.id}" ${i.bajo_inventario == 1 ? 'checked' : ''}>
                                            <label class="form-check-label" for="stockToggle_${i.id}">Stock Bajo</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col price">
                                    ${precioVentaInfoResaltadoFinal}
                                </div>
                            </div>
                        </div>
                    </div>`;
                }).join('');

                checkedProductIds.forEach(id => {
                    const checkbox = listEl.querySelector(`.select-product[value="${id}"]`);
                    if (checkbox) {
                        checkbox.checked = true;
                    }
                });

                setTimeout(() => {
                    document.querySelectorAll('.actions').forEach(el => {
                        el.style.display = actionsVisible ? '' : 'none';
                    });
                }, 0);
            }

            function escapeHtml(s) {
                if (!s && s !== 0) return '';
                return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
            }

            listEl.addEventListener('click', async (e) => {
                if (e.target.matches('.select-product')) {
                    const id = e.target.value;
                    if (e.target.checked) {
                        checkedProductIds.add(id);
                    } else {
                        checkedProductIds.delete(id);
                    }
                    return;
                }

                const item = e.target.closest('.item');
                if (!item) return;
                const id = item.dataset.id;
                if (e.target.closest('.edit')) {
                    const r = await fetch(API_VER + '?id=' + id);
                    const p = await r.json();
                    form.id.value = p.id;
                    form.nombre.value = p.nombre || '';
                    await cargarProveedores(p.proveedor || '');
                    form.unidad_medida.value = p.unidad_medida || 'unidad';
                    form.tam_paquete.value = p.tam_paquete || '';
                    form.precio_compra.value = p.precio_compra || 0;
                    form.precio_venta_unidad.value = (p.precio_venta_unidad !== undefined && p.precio_venta_unidad !== null) ? p.precio_venta_unidad : '';
                    form.precio_venta_paquete.value = (p.precio_venta_paquete !== undefined && p.precio_venta_paquete !== null) ? p.precio_venta_paquete : '';
                    form.moneda_compra.value = p.moneda_compra || 'USD';
                    form.vende_media.checked = (p.precio_venta_mediopaquete !== undefined && p.precio_venta_mediopaquete !== null && parseFloat(p.precio_venta_mediopaquete) > 0);
                    form.precio_venta_medio_paquete.value = (p.precio_venta_mediopaquete !== undefined && p.precio_venta_mediopaquete !== null) ? p.precio_venta_mediopaquete : '';
                    // Set tasa_calculo to current system rate as default or keep it if we had a way to store it (we don't currently store invoice rate)
                    if (window.exchangeRate) {
                        document.getElementById('tasa_calculo').value = window.exchangeRate.toFixed(2);
                    }
                    updatePrecioCompraInfo();
                    updateTamPaqueteVisibility();
                    updatePrecioLabelsByMoneda();
                    updateMedioPaqueteVisibility();
                    const modalEl = document.getElementById('form-sheet');
                    const modal = new bootstrap.Modal(modalEl);
                    modal.show();
                    return;
                }
                if (e.target.closest('.del')) {
                    // Confirmación con SweetAlert
                    Swal.fire({
                        title: '¿Eliminar producto?',
                        text: 'Esta acción no se puede deshacer.',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#d33',
                        cancelButtonColor: '#3085d6',
                        confirmButtonText: 'Sí, eliminar',
                        cancelButtonText: 'Cancelar'
                    }).then(async (result) => {
                        if (result.isConfirmed) {
                            const formData = new FormData();
                            formData.append('id', id);
                            const r = await fetch(API_ELIMINAR, {
                                method: 'POST',
                                body: formData
                            });
                            const j = await r.json();
                            if (j.ok) {
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Eliminado',
                                    text: 'El producto fue eliminado.',
                                    timer: 1200,
                                    showConfirmButton: false
                                });
                                fetchList(searchEl.value);
                            } else {
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Error',
                                    text: j.error || 'No se pudo eliminar.'
                                });
                            }
                        }
                    });
                    return;
                }
            });

            // Event listener for the stock toggle
            listEl.addEventListener('change', async (e) => {
                if (e.target.matches('.stock-toggle')) {
                    const id = e.target.dataset.id;
                    const stockBajo = e.target.checked ? 1 : 0;

                    const formData = new FormData();
                    formData.append('id', id);
                    formData.append('stock_bajo', stockBajo);

                    // Cambiar el fondo de la tarjeta inmediatamente
                    const card = e.target.closest('.item');
                    if (card) {
                        if (stockBajo) {
                            card.classList.add('bg-danger', 'bg-opacity-25');
                        } else {
                            card.classList.remove('bg-danger', 'bg-opacity-25');
                        }
                    }

                    try {
                        const res = await fetch('api/actualizar_stock_bajo.php', {
                            method: 'POST',
                            body: formData
                        });
                        const j = await res.json();
                        if (j.ok) {
                            // Opcional: mensaje de éxito
                        } else {
                            // Si falla, revertir el cambio visual y el toggle
                            e.target.checked = !e.target.checked;
                            if (card) {
                                if (e.target.checked) {
                                    card.classList.add('bg-danger', 'bg-opacity-25');
                                } else {
                                    card.classList.remove('bg-danger', 'bg-opacity-25');
                                }
                            }
                            Swal.fire({
                                icon: 'error',
                                title: 'Error al actualizar stock',
                                text: j.error || 'Ocurrió un error.',
                            });
                        }
                    } catch (error) {
                        e.target.checked = !e.target.checked;
                        if (card) {
                            if (e.target.checked) {
                                card.classList.add('bg-danger', 'bg-opacity-25');
                            } else {
                                card.classList.remove('bg-danger', 'bg-opacity-25');
                            }
                        }
                        Swal.fire({
                            icon: 'error',
                            title: 'Error de conexión',
                            text: 'No se pudo conectar con el servidor.',
                        });
                    }
                }
            });

            function updateTamPaqueteVisibility() {
                const sel = form.unidad_medida.value;
                // Mostrar/ocultar tamaño paquete
                const tamPaqueteGroup = form.tam_paquete ? form.tam_paquete.closest('.col-12, .col-md-6') : null;
                if (tamPaqueteGroup) {
                    tamPaqueteGroup.style.display = (sel === 'paquete' || sel === 'kg') ? '' : 'none';
                }
                // Mostrar/ocultar precio venta paquete
                const precioPaqueteGroup = document.getElementById('group-precio-venta-paquete');
                if (precioPaqueteGroup) {
                    precioPaqueteGroup.style.display = (sel === 'paquete') ? '' : 'none';
                }
            }

            function updateMedioPaqueteVisibility() {
                const vendeMediaCheckbox = document.getElementById('vende_media');
                const medioPaqueteGroup = document.getElementById('group-precio-venta-medio-paquete');
                if (medioPaqueteGroup) {
                    medioPaqueteGroup.style.display = vendeMediaCheckbox.checked ? '' : 'none';
                }
            }

            // Add this new event listener
            document.getElementById('vende_media').addEventListener('change', updateMedioPaqueteVisibility);

            function updatePriceHelp() {
                const unidad = form.unidad_medida.value;
                const pv_general = parseFloat(form.precio_venta.value) || 0;
                const pv_paquete = form.precio_venta_paquete.value ? parseFloat(form.precio_venta_paquete.value) : null;
                const pv_unidad = form.precio_venta_unidad.value ? parseFloat(form.precio_venta_unidad.value) : null;
                const pc = parseFloat(form.precio_compra.value) || 0;
                const tam = parseFloat(form.tam_paquete.value) || 0;
                const elHelp = document.getElementById('price-help');
                let parts = [];
                if (unidad === 'paquete' && tam > 0) {
                    const paquetePrice = pv_paquete !== null ? pv_paquete : (pv_general || 0);
                    const perUnitSale = paquetePrice / tam;
                    parts.push(`Precio venta por unidad: ${perUnitSale.toFixed(2)} (${tam} unidades por paquete)`);
                    if (pv_paquete !== null) parts.push(`Precio venta por paquete: ${pv_paquete.toFixed(2)}`);
                    if (pv_unidad !== null) parts.push(`Precio venta (unidad explícita): ${pv_unidad.toFixed(2)}`);
                    // costo por unidad: siempre calcular a partir de precio_compra / tam_paquete
                    let perUnitCost = (pc > 0 && tam > 0) ? pc / tam : null;
                    if (perUnitCost !== null) {
                        parts.push(`Precio compra por unidad: ${perUnitCost.toFixed(2)}`);
                        const margen = perUnitCost > 0 ? ((perUnitSale - perUnitCost) / perUnitCost) * 100 : null;
                        if (margen !== null) parts.push(`Ganancia: ${margen.toFixed(1)}%`);
                    }
                } else if (unidad === 'kg' && tam > 0) {
                    const paquetePrice = pv_paquete !== null ? pv_paquete : (pv_general || 0);
                    const perKgSale = paquetePrice / tam;
                    parts.push(`Precio venta por kg: ${perKgSale.toFixed(2)} por ${tam} kg`);
                    let perKgCost = (pc > 0 && tam > 0) ? pc / tam : null;
                    if (perKgCost !== null) {
                        parts.push(`Precio compra por kg: ${perKgCost.toFixed(2)}`);
                        const margen = perKgCost > 0 ? ((perKgSale - perKgCost) / perKgCost) * 100 : null;
                        if (margen !== null) parts.push(`Ganancia: ${margen.toFixed(1)}%`);
                    }
                } else {
                    const sale = pv_unidad !== null ? pv_unidad : pv_general;
                    if (sale > 0) parts.push(`Precio venta: ${sale.toFixed(2)}`);
                    if (pc > 0) parts.push(`Precio compra: ${pc.toFixed(2)}`);
                    if (pc > 0 && sale > 0) {
                        const margen = pc > 0 ? ((sale - pc) / pc) * 100 : null;
                        if (margen !== null) parts.push(`Ganancia: ${margen.toFixed(1)}%`);
                    }
                }
                elHelp.textContent = parts.join(' · ');
            }

            function updatePrecioCompraInfo() {
                const moneda = form.moneda_compra.value;
                const precio = parseFloat(form.precio_compra.value) || 0;
                const info = document.getElementById('precio_compra_bs_info');
                const infoUnitario = document.getElementById('precio_compra_unitario_info');
                if (moneda === 'USD') {
                    if (window.exchangeRate && precio > 0) {
                        info.textContent = `Equivalente: ${(precio * window.exchangeRate).toFixed(2)} Bs (tasa actual)`;
                        info.style.display = '';
                    } else {
                        info.textContent = '';
                        info.style.display = 'none';
                    }
                } else {
                    info.textContent = 'Precio fijo en bolívares. No se recalcula con la tasa.';
                    info.style.display = '';
                }
                // Mostrar precio compra unitario si corresponde
                const unidad = form.unidad_medida.value;
                const tamPaquete = parseFloat(form.tam_paquete.value);
                if (unidad === 'paquete' && precio > 0 && tamPaquete > 0) {
                    infoUnitario.textContent = `Precio compra unitario: ${(precio / tamPaquete).toFixed(2)}`;
                    infoUnitario.style.display = '';
                } else {
                    infoUnitario.textContent = '';
                    infoUnitario.style.display = 'none';
                }
            }

            function updatePrecioLabelsByMoneda() {
                const moneda = form.moneda_compra.value;
                // Label y placeholder para precio compra
                const labelCompra = form.closest('.modal-content')?.querySelector('label[for="precio_compra"]') || document.querySelector('label[for="precio_compra"]');
                if (labelCompra) {
                    labelCompra.textContent = moneda === 'BS' ? 'Precio compra (Bs)' : 'Precio compra (USD)';
                }
                form.precio_compra.placeholder = moneda === 'BS' ? '0.00 Bs' : '0.00';
                // Labels y placeholders para precios de venta
                const labelVentaUnidad = document.getElementById('label-precio-unidad');
                if (labelVentaUnidad) {
                    labelVentaUnidad.querySelector('.form-label').textContent = moneda === 'BS' ? 'Precio venta por unidad (Bs)' : 'Precio venta por unidad (USD)';
                }
                const labelVentaPaquete = document.getElementById('group-precio-venta-paquete');
                if (labelVentaPaquete) {
                    labelVentaPaquete.querySelector('.form-label').textContent = moneda === 'BS' ? 'Precio venta paquete (Bs)' : 'Precio venta paquete (USD)';
                }
                form.precio_venta_unidad.placeholder = moneda === 'BS' ? '0.00 Bs' : '0.00';
                form.precio_venta_paquete.placeholder = moneda === 'BS' ? '0.00 Bs' : '0.00';
            }

            async function cargarProveedores(selected = '') {
                const sel = document.getElementById('proveedor-select');
                const manual = document.getElementById('proveedor-manual');
                sel.innerHTML = '<option value="">(Sin proveedor)</option>';
                try {
                    const res = await fetch('api/proveedores.php');
                    const data = await res.json();
                    if (data.ok && Array.isArray(data.proveedores)) {
                        data.proveedores.forEach(p => {
                            const opt = document.createElement('option');
                            opt.value = p;
                            opt.textContent = p;
                            sel.appendChild(opt);
                        });
                    }
                    // Agregar opción Otro...
                    const optOtro = document.createElement('option');
                    optOtro.value = '__otro__';
                    optOtro.textContent = 'Otro...';
                    sel.appendChild(optOtro);
                } catch {} // Si falla, no hacer nada
                // Si el proveedor no está en la lista, seleccionar Otro y mostrar el input manual
                let found = false;
                for (let i = 0; i < sel.options.length; i++) {
                    if (sel.options[i].value === selected) {
                        sel.selectedIndex = i;
                        found = true;
                        break;
                    }
                }
                if (!found && selected) {
                    sel.value = '__otro__';
                    manual.value = selected;
                    manual.style.display = '';
                    manual.required = true;
                } else {
                    manual.value = '';
                    manual.style.display = 'none';
                    manual.required = false;
                }
                sel.style.display = '';
            }

            document.addEventListener('DOMContentLoaded', () => {
                // Mostrar input manual si selecciona "Otro..."
                const sel = document.getElementById('proveedor-select');
                const manual = document.getElementById('proveedor-manual');
                sel.addEventListener('change', function() {
                    if (this.value === '__otro__') {
                        manual.style.display = '';
                        manual.required = true;
                    } else {
                        manual.style.display = 'none';
                        manual.required = false;
                    }
                });

                const btnAdd16Percent = document.getElementById('btn-add-16-percent');
                if (btnAdd16Percent) {
                    btnAdd16Percent.addEventListener('click', () => {
                        const precioCompraInput = document.getElementById('precio_compra');
                        if (precioCompraInput) {
                            let currentValue = parseFloat(precioCompraInput.value) || 0;
                            let newValue = currentValue * 1.16;
                            precioCompraInput.value = newValue.toFixed(2); // Format to 2 decimal places
                            updatePrecioCompraInfo(); // Update the info text below the input
                        }
                    });
                }
                // Actualizar el label informativo al cambiar unidad, precio_compra o tam_paquete
                form.unidad_medida.addEventListener('change', updatePrecioCompraInfo);
                form.precio_compra.addEventListener('input', updatePrecioCompraInfo);
                form.tam_paquete.addEventListener('input', updatePrecioCompraInfo);

                const btnConvertBsUsd = document.getElementById('btn-convert-bs-usd');

                if (btnConvertBsUsd) {
                    btnConvertBsUsd.addEventListener('click', async () => { // Made async

                        const precioCompraInput = document.getElementById('precio_compra');
                        const monedaCompraSelect = document.getElementById('moneda_compra');
                        // Usar la tasa del input visible
                        const tasaCalculoInput = document.getElementById('tasa_calculo');
                        let tasaParaCalculo = parseFloat(tasaCalculoInput.value) || 0;

                        if (!tasaParaCalculo || tasaParaCalculo === 0) {
                            // Si está vacío, intentar usar la del sistema
                            tasaParaCalculo = parseFloat(document.getElementById('tasa_actual_oculta').value) || 0;
                            if (tasaParaCalculo > 0) {
                                tasaCalculoInput.value = tasaParaCalculo; // Actualizar el input visible
                            } else {
                                await fetchExchangeRate();
                                tasaParaCalculo = parseFloat(document.getElementById('tasa_actual_oculta').value) || 0;
                                if (tasaParaCalculo > 0) {
                                    tasaCalculoInput.value = tasaParaCalculo;
                                }
                            }
                        }

                        if (precioCompraInput && tasaParaCalculo && tasaParaCalculo > 0) {

                            let currentValue = parseFloat(precioCompraInput.value) || 0;
                            let newValue;

                            if (monedaCompraSelect.value === 'USD') {
                                newValue = currentValue * tasaParaCalculo;
                                monedaCompraSelect.value = 'BS'; // Change to BS after conversion
                            } else { // Assuming it's BS
                                newValue = currentValue / tasaParaCalculo;
                                monedaCompraSelect.value = 'USD'; // Change to USD after conversion
                            }

                            precioCompraInput.value = newValue.toFixed(2);
                            updatePrecioCompraInfo();
                            updatePrecioLabelsByMoneda(); // Update labels after currency change

                        } else {

                            Swal.fire({
                                icon: 'info',
                                title: 'Tasa no definida',
                                text: 'Por favor ingrese una tasa de cambio válida para realizar la conversión.',
                            });
                        }
                    });
                }

                // Event listeners for percentage buttons
                function aplicarPorcentaje(porcentaje) {
                    const precioCompra = parseFloat(form.precio_compra.value) || 0;
                    const tamPaquete = parseFloat(form.tam_paquete.value) || 1;
                    let base = precioCompra;
                    if (document.getElementById('cuCheck')?.checked && tamPaquete > 0) {
                        base = precioCompra / tamPaquete;
                    }
                    const nuevoPrecio = base * (1 + porcentaje / 100);
                    form.precio_venta_unidad.value = nuevoPrecio.toFixed(2);
                }

                document.getElementById('btn-20-percent').addEventListener('click', () => aplicarPorcentaje(20));
                document.getElementById('btn-25-percent').addEventListener('click', () => aplicarPorcentaje(25));
                document.getElementById('btn-30-percent').addEventListener('click', () => aplicarPorcentaje(30));


                const picker = document.getElementById('tasa_date_picker');
                const btnCalendar = document.getElementById('btn-tasa-calendar');
                
                if (btnCalendar && picker) {
                    btnCalendar.addEventListener('click', () => {
                        // Show picker
                        if (picker.showPicker) {
                            picker.showPicker();
                        } else {
                            picker.click(); // Fallback
                        }
                    });

                    picker.addEventListener('change', async () => {
                        const date = picker.value;
                        if (!date) return;
                        
                        // Fetch rate for this date
                        try {
                            const res = await fetch(`api/tasa.php?fecha=${date}`);
                            const data = await res.json();
                            if (data.ok && data.valor) {
                                document.getElementById('tasa_calculo').value = parseFloat(data.valor).toFixed(2);
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Tasa encontrada',
                                    text: `Tasa para el ${date}: ${data.valor} Bs`,
                                    toast: true,
                                    position: 'top-end',
                                    showConfirmButton: false,
                                    timer: 2000
                                });
                            } else {
                                Swal.fire({
                                    icon: 'warning',
                                    title: 'Sin datos',
                                    text: `No se encontró tasa para la fecha ${date}. Se muestra la más reciente disponible o mantenga la actual.`,
                                    toast: true
                                });
                            }
                        } catch (e) {
                            console.error(e);
                        }
                    });
                }

            });

            // Al abrir modal para nuevo producto
            btnAdd.addEventListener('click', async () => {
                await cargarProveedores();
                form.reset();
                form.id.value = '';
                form.unidad_medida.value = 'unidad';
                form.moneda_compra.value = 'USD';
                // Resetear tasa calculo a la actual
                if (window.exchangeRate) {
                    document.getElementById('tasa_calculo').value = window.exchangeRate.toFixed(2);
                }
                updatePrecioCompraInfo();
                updateTamPaqueteVisibility();
                updatePrecioLabelsByMoneda();
                const modalEl = document.getElementById('form-sheet');
                const modal = new bootstrap.Modal(modalEl);
                modal.show();
            });

            // Al enviar el formulario, tomar proveedor manual si aplica
            form.addEventListener('submit', async (e) => {
                e.preventDefault();
                // Convertir nombre y proveedor a mayúsculas antes de enviar
                form.nombre.value = form.nombre.value.toUpperCase();
                const sel = document.getElementById('proveedor-select');
                const manual = document.getElementById('proveedor-manual');
                const formData = new FormData(form);

                if (sel.value === '__otro__' && manual.value) {
                    manual.value = manual.value.toUpperCase();
                    formData.set('proveedor', manual.value);
                } else if (sel.value) {
                    formData.set('proveedor', sel.value.toUpperCase());
                }

                formData.set('vende_media', form.vende_media.checked ? '1' : '0');

                if (!form.precio_venta_paquete.value) formData.set('precio_venta_paquete', '');
                if (!form.precio_venta_unidad.value) formData.set('precio_venta_unidad', '');
                // Explicitly handle precio_venta_mediopaquete
                if (form.vende_media.checked && form.precio_venta_medio_paquete.value) {
                    formData.set('precio_venta_mediopaquete', form.precio_venta_medio_paquete.value);
                } else {
                    formData.set('precio_venta_mediopaquete', ''); // Send empty string if not checked or no value
                }
                const isEdit = form.id.value && form.id.value !== '';
                const url = isEdit ? API_EDITAR : API_CREAR;
                const res = await fetch(url, {
                    method: 'POST',
                    body: formData
                });
                const j = await res.json();
                if (j.ok) {
                    // Cerrar modal usando Bootstrap Modal
                    const modalEl = document.getElementById('form-sheet');
                    const modal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
                    modal.hide();
                    // Mensaje de éxito con SweetAlert y refrescar lista después
                    Swal.fire({
                        icon: 'success',
                        title: '¡Guardado exitoso!',
                        text: isEdit ? 'El producto fue actualizado.' : 'El producto fue registrado.',
                        timer: 1800,
                        showConfirmButton: false
                    }).then(() => {
                        fetchList(searchEl.value);
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: j.error || 'No se pudo guardar.'
                    });
                }
            });

            // let exchangeRate = 0;
            // let exchangeDate = '';
            async function fetchExchangeRate() {
                try {
                    const res = await fetch('api/tasa.php');
                    const data = await res.json();
                    if (data.ok && data.valor) {
                        exchangeRate = parseFloat(data.valor);
                        exchangeDate = data.fecha || '';
                        const tasaOcultaInput = document.getElementById('tasa_actual_oculta');
                        if (tasaOcultaInput) {
                            tasaOcultaInput.value = exchangeRate;
                        }
                        // Update visible calculation rate if it's empty
                        const tasaCalculo = document.getElementById('tasa_calculo');
                        if (tasaCalculo && !tasaCalculo.value) {
                            tasaCalculo.value = exchangeRate.toFixed(2);
                        }

                        const valorEl = document.getElementById('tasa-valor');
                        if (valorEl) valorEl.textContent = `${exchangeRate.toFixed(2)} Bs`;
                        const fechaEl = document.getElementById('tasa-fecha');
                        let fechaFormateada = '';
                        if (exchangeDate && /^\d{4}-\d{2}-\d{2}$/.test(exchangeDate)) {
                            const [y, m, d] = exchangeDate.split('-');
                            fechaFormateada = `${d}-${m}-${y}`;
                        }
                        fechaEl.textContent = fechaFormateada ? fechaFormateada : '';
                        fetchList(searchEl.value);
                    } else { // Added else block for debugging

                    }
                } catch (e) {

                }
            }

            window.addEventListener('DOMContentLoaded', () => {
                fetchExchangeRate();
            });

            fetchList();

            // Modificar el botón de impresión para solo imprimir seleccionados
            btnPrint.addEventListener('click', function(e) {
                e.preventDefault();
                const checks = document.querySelectorAll('.select-product:checked');
                if (checks.length === 0) {
                    // Abrir reporte de todos los productos
                    window.open('generar_pdf.php', '_blank');
                    window.open('generar_pdfg.php', '_blank');
                    return;
                }
                const ids = Array.from(checks).map(ch => ch.value).join(',');
                window.open('generar_pdf.php?ids=' + encodeURIComponent(ids), '_blank');
                window.open('generar_pdfg.php?ids=' + encodeURIComponent(ids), '_blank');
            });

            const btnPrintTable = document.getElementById('btn-print-table');
            if (btnPrintTable) {
                btnPrintTable.addEventListener('click', function(e) {
                    e.preventDefault();
                    const checks = document.querySelectorAll('.select-product:checked');
                    if (checks.length === 0) {
                        alert('Selecciona al menos un producto para imprimir la tabla.');
                        return;
                    }
                    const ids = Array.from(checks).map(ch => ch.value).join(',');
                    window.open('generar_pdf_tabla.php?ids=' + encodeURIComponent(ids), '_blank');
                });
            }

            // Asegurar que el input de búsqueda funcione correctamente
            if (searchEl) {
                // input -> búsqueda con debounce
                searchEl.addEventListener('input', () => {
                    clearTimeout(timeout);
                    timeout = setTimeout(() => fetchList(searchEl.value), 300);
                });

                // focus -> seleccionar todo el texto (solo una vez)
                if (!searchEl.dataset.selectOnFocusAdded) {
                    searchEl.addEventListener('focus', function() {
                        this.select();
                        const onMouseUp = function(e) {
                            e.preventDefault();
                            searchEl.removeEventListener('mouseup', onMouseUp);
                        };
                        searchEl.addEventListener('mouseup', onMouseUp);
                    });
                    searchEl.dataset.selectOnFocusAdded = '1';
                }
            }

            // Solución para limpiar el backdrop si queda tras cerrar el modal
            function limpiarBackdrop() {
                // Elimina manualmente cualquier backdrop de Bootstrap si queda
                document.querySelectorAll('.modal-backdrop').forEach(el => el.remove());
                document.body.classList.remove('modal-open');
                document.body.style.overflow = '';
            }

            // Asegurar limpieza al cerrar modal por botón cancelar/cerrar
            const modalEl = document.getElementById('form-sheet');
            modalEl.addEventListener('hidden.bs.modal', limpiarBackdrop);

            // Asegurar que el cambio de unidad_medida actualice los campos relacionados
            if (form.unidad_medida) {
                form.unidad_medida.addEventListener('change', updateTamPaqueteVisibility);
            }

            // 1. Agregar el checkbox 'c/u' junto al select de unidad
            // Busca el bloque del select de unidad_medida y agrega el checkbox
            // Ya está agregado en el HTML del modal

            // 2. Modificar la lógica de los botones de porcentaje
            // Busca el bloque JS donde se calculan los precios con porcentaje y agrega la lógica:
            // ...existing code...
        </script>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
<?php
include_once __DIR__ . '/actualizar_tasa_bcv.php';
?>