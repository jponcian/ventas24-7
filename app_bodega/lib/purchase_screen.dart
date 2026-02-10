import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';
import 'product_model.dart';
import 'scanner_screen.dart';

import 'utils.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchCtrl = TextEditingController();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _loading = true;

  // Carrito de compras
  final List<Map<String, dynamic>> _cart = [];

  // Datos de cabecera de compra
  List<Map<String, dynamic>> _proveedores = [];
  int? _selectedProveedorId;
  String _selectedMoneda = 'USD';
  double _tasa = 1.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final list = await _apiService.getProducts();
      final units = list.where((p) => p.id > 0).toList();
      final provs = await _apiService.getProveedoresList();
      final tasaSys = await _apiService.getTasa();

      setState(() {
        _allProducts = units;
        _filteredProducts = units;
        _proveedores = provs;
        if (tasaSys > 0) _tasa = tasaSys;
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _filter(String q) {
    final query = q.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((p) {
          return p.nombre.toLowerCase().contains(query) ||
              (p.codigoBarras != null && p.codigoBarras!.contains(query)) ||
              (p.codigoInterno != null &&
                  p.codigoInterno!.toLowerCase().contains(query));
        }).toList();
      }
    });
  }

  Future<void> _showAddStockDialog(Product p) async {
    final qtyCtrl = TextEditingController();
    // Pre-llenar con el último costo conocido (en USD), formateado
    final costCtrl = TextEditingController(
      text: p.precioCompra != null
          ? p.precioCompra!.toStringAsFixed(2)
          : '0.00',
    );
    // Para sugerencia de precio
    final suggestionCtrl = TextEditingController();

    String modoCarga = 'unidad';
    double tamPaquete = p.tamPaquete ?? 1;

    // Calcular margen actual para sugerir

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          void updateSuggestion() {
            double? enteredCost = double.tryParse(costCtrl.text);
            if (enteredCost != null && enteredCost > 0) {
              double unitCost = enteredCost;

              // Si el modo es paquete, el costo ingresado es del paquete completo.
              // Convertimos a costo unitario para calcular el precio de venta unitario.
              if (modoCarga == 'paquete' && tamPaquete > 1) {
                unitCost = enteredCost / tamPaquete;
              }

              // Si la moneda seleccionada es BS, convertir a USD
              if (_selectedMoneda == 'BS' && _tasa > 0) {
                unitCost = unitCost / _tasa;
              }

              // Calcular sugerido con 30% por defecto (Precio Unitario)
              double suggested = unitCost * 1.30;
              suggestionCtrl.text = suggested.toStringAsFixed(2);
            }
          }

          Widget marginBtn(int percent) {
            return GestureDetector(
              onTap: () {
                double? enteredCost = double.tryParse(costCtrl.text);
                if (enteredCost != null && enteredCost > 0) {
                  double unitCost = enteredCost;

                  if (modoCarga == 'paquete' && tamPaquete > 1) {
                    unitCost = enteredCost / tamPaquete;
                  }
                  if (_selectedMoneda == 'BS' && _tasa > 0) {
                    unitCost = unitCost / _tasa;
                  }

                  double price = unitCost * (1 + (percent / 100));
                  suggestionCtrl.text = price.toStringAsFixed(2);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF1E3A8A).withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  '+$percent%',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
              ),
            );
          }

          return AlertDialog(
            title: Text('Agregar: ${p.nombre}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tamPaquete > 1) ...[
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text(
                              'Unidad',
                              style: TextStyle(fontSize: 12),
                            ),
                            value: 'unidad',
                            groupValue: modoCarga,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (v) {
                              if (modoCarga != v) {
                                double? currentVal = double.tryParse(
                                  costCtrl.text,
                                );
                                if (currentVal != null) {
                                  // Packet -> Unit: Divide
                                  costCtrl.text = (currentVal / tamPaquete)
                                      .toStringAsFixed(2);
                                }
                                setDialogState(() => modoCarga = v!);
                                updateSuggestion();
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: Text(
                              'Paquete ($tamPaquete)',
                              style: const TextStyle(fontSize: 12),
                            ),
                            value: 'paquete',
                            groupValue: modoCarga,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (v) {
                              if (modoCarga != v) {
                                double? currentVal = double.tryParse(
                                  costCtrl.text,
                                );
                                if (currentVal != null) {
                                  // Unit -> Packet: Multiply
                                  costCtrl.text = (currentVal * tamPaquete)
                                      .toStringAsFixed(2);
                                }
                                setDialogState(() => modoCarga = v!);
                                updateSuggestion();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                  TextField(
                    controller: qtyCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: p.isByWeight
                        ? [WeightDecimalFormatter()]
                        : null,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: modoCarga == 'paquete'
                          ? 'Cant. Paquetes'
                          : 'Cant. Unidades',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: costCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [SlidingDecimalFormatter()],
                    onChanged: (_) => updateSuggestion(),
                    decoration: InputDecoration(
                      labelText: modoCarga == 'paquete'
                          ? 'Costo Paquete ($_selectedMoneda)'
                          : 'Costo Unidad ($_selectedMoneda)',
                      hintText: '0.00',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Sugerencia de Precio
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Precio Venta Actual: \$${p.precioReal}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          controller: suggestionCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [SlidingDecimalFormatter()],
                          decoration: const InputDecoration(
                            labelText: 'Nuevo Precio Venta (Sugerido)',
                            isDense: true,
                            border: OutlineInputBorder(),
                            prefixText: '\$ ',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            marginBtn(10),
                            marginBtn(20),
                            marginBtn(30),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Calculado con 30% por defecto. Deja vacío para no cambiar.',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () {
                  final rawQty = double.tryParse(qtyCtrl.text);
                  if (rawQty == null || rawQty <= 0) return;

                  final rawCost = double.tryParse(costCtrl.text);
                  final newPrice = double.tryParse(suggestionCtrl.text);

                  double finalQty = rawQty;
                  double? finalUnitCost = rawCost;

                  if (modoCarga == 'paquete') {
                    finalQty = rawQty * tamPaquete;
                    if (rawCost != null) {
                      finalUnitCost = rawCost / tamPaquete;
                    }
                  }

                  setState(() {
                    _cart.add({
                      'producto_id': p.id,
                      'nombre': p.nombre,
                      'cantidad': finalQty,
                      'costo_nuevo': finalUnitCost,
                      'precio_venta_nuevo': newPrice,
                      'es_paquete': modoCarga == 'paquete',
                      'cant_original': rawQty,
                      'costo_original': rawCost,
                    });
                  });
                  Navigator.pop(context);
                },
                child: const Text('Agregar'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCart() {
    // Diálogo para procesar
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (_, controller) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Header con opciones globales
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Datos de la Factura',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                initialValue: _selectedProveedorId,
                                hint: const Text('Seleccionar Proveedor'),
                                items: _proveedores
                                    .map(
                                      (p) => DropdownMenuItem(
                                        value: int.parse(p['id'].toString()),
                                        child: Text(p['nombre']),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) => setSheetState(
                                  () => _selectedProveedorId = v,
                                ),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 0,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: Colors.blue,
                              ),
                              onPressed: () =>
                                  _addProveedorDialog(setSheetState),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Moneda de Compra:',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                            ToggleButtons(
                              isSelected: [
                                _selectedMoneda == 'USD',
                                _selectedMoneda == 'BS',
                              ],
                              onPressed: (idx) {
                                setSheetState(
                                  () =>
                                      _selectedMoneda = idx == 0 ? 'USD' : 'BS',
                                );
                              },
                              borderRadius: BorderRadius.circular(8),
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text('USD'),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text('BS'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (_selectedMoneda == 'BS')
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextField(
                              controller: TextEditingController(
                                text: _tasa.toString(),
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Tasa de Cambio',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (v) {
                                final val = double.tryParse(v);
                                if (val != null) _tasa = val;
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Divider(),
                  // Lista de items
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: _cart.length,
                      itemBuilder: (context, idx) {
                        final it = _cart[idx];
                        bool esPaq = it['es_paquete'] ?? false;
                        return ListTile(
                          title: Text(it['nombre']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                esPaq
                                    ? '${it['cant_original']} Paq. x ${it['costo_original']} $_selectedMoneda'
                                    : '${it['cantidad']} Unid. x ${it['costo_nuevo']} $_selectedMoneda',
                              ),
                              if (it['precio_venta_nuevo'] != null)
                                Text(
                                  'Nuevo Precio Venta: \$${it['precio_venta_nuevo']}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setSheetState(() => _cart.removeAt(idx));
                              if (_cart.isEmpty) Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _finalizePurchase,
                        child: const Text('CONFIRMAR MATERIAL'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _addProveedorDialog(StateSetter parentSetState) async {
    final nameCtrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nuevo Proveedor'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty) {
                await _apiService.addProveedor(nameCtrl.text, '', '');
                // Recargar proveedores
                final provs = await _apiService.getProveedoresList();
                setState(() {
                  _proveedores = provs;
                });
                // Intentar seleccionar el nuevo
                final newProv = provs.firstWhere(
                  (p) => p['nombre'] == nameCtrl.text,
                  orElse: () => {},
                );
                if (newProv.isNotEmpty) {
                  parentSetState(() {
                    _selectedProveedorId = int.parse(newProv['id'].toString());
                  });
                }
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _finalizePurchase() async {
    Navigator.pop(context);
    setState(() => _loading = true);

    final ok = await _apiService.cargarCompra(
      _cart,
      proveedorId: _selectedProveedorId,
      moneda: _selectedMoneda,
      tasa: _tasa,
    );

    if (mounted) {
      setState(() => _loading = false);
      if (ok) {
        setState(() => _cart.clear());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Compra exitosa'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al guardar'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nueva Compra',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchCtrl,
              onChanged: _filter,
              decoration: InputDecoration(
                hintText: 'Buscar producto...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () async {
                    final res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BarcodeScannerScreen(),
                      ),
                    );
                    if (res != null) {
                      _searchCtrl.text = res;
                      _filter(res);
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final p = _filteredProducts[index];
                      return ListTile(
                        title: Text(
                          p.nombre,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          'Stock: ${p.stock ?? 0} | PB: \$${p.precioReal}',
                        ),
                        leading: CircleAvatar(child: Text(p.nombre[0])),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: Color(0xFF1E3A8A),
                          ),
                          onPressed: () => _showAddStockDialog(p),
                        ),
                        onTap: () => _showAddStockDialog(p),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: _cart.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _showCart,
              label: Text('Ver Carrito (${_cart.length})'),
              icon: const Icon(Icons.shopping_cart),
              backgroundColor: const Color(0xFF1E3A8A),
            ),
    );
  }
}
