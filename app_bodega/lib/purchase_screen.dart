import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';
import 'product_model.dart';
import 'scanner_screen.dart';

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

  // Carrito de compras: items locales antes de enviar
  final List<Map<String, dynamic>> _cart = [];

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
      setState(() {
        _allProducts = units;
        _filteredProducts = units;
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
              (p.codigoBarras != null && p.codigoBarras!.contains(query));
        }).toList();
      }
    });
  }

  Future<void> _showAddStockDialog(Product p) async {
    final qtyCtrl = TextEditingController();
    final costCtrl = TextEditingController(
      text: p.precioCompra != null ? p.precioCompra.toString() : '',
    );

    // Estado local para el diálogo
    String modoCarga = 'unidad'; // 'unidad' o 'paquete'
    double tamPaquete = p.tamPaquete ?? 1;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(
              'Agregar: ${p.nombre}',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
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
                          onChanged: (v) =>
                              setDialogState(() => modoCarga = v!),
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
                          onChanged: (v) =>
                              setDialogState(() => modoCarga = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                TextField(
                  controller: qtyCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: modoCarga == 'paquete'
                        ? 'Cant. Paquetes'
                        : 'Cant. Unidades',
                    hintText: 'Ej: 10',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.inventory_2),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: costCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: modoCarga == 'paquete'
                        ? 'Costo por Paquete'
                        : 'Costo Unitario',
                    hintText: 'Ej: 5.50',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                ),
                if (modoCarga == 'paquete') ...[
                  const SizedBox(height: 8),
                  Text(
                    'Total unidades: ${(double.tryParse(qtyCtrl.text) ?? 0) * tamPaquete}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () {
                  final rawQty = double.tryParse(qtyCtrl.text);
                  if (rawQty == null || rawQty <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cantidad inválida')),
                    );
                    return;
                  }
                  final rawCost = double.tryParse(costCtrl.text);

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
                      'es_paquete': modoCarga == 'paquete',
                      'cant_original': rawQty,
                      'costo_original': rawCost,
                    });
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Agregado: ${p.nombre} ($finalQty unidades)',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Resumen de Carga',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_sweep, color: Colors.red),
                      onPressed: () {
                        setState(() => _cart.clear());
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _cart.isEmpty
                    ? const Center(child: Text('La lista está vacía'))
                    : ListView.builder(
                        controller: controller,
                        itemCount: _cart.length,
                        itemBuilder: (context, idx) {
                          final it = _cart[idx];
                          final bool esPaq = it['es_paquete'] ?? false;
                          return ListTile(
                            title: Text(it['nombre']),
                            subtitle: Text(
                              esPaq
                                  ? 'Carga: ${it['cant_original']} Paq. (${it['cantidad']} unid) \nCosto Paq: \$${it['costo_original']}'
                                  : 'Carga: ${it['cantidad']} Unid. \nCosto Unid: \$${it['costo_nuevo']}',
                            ),
                            isThreeLine: true,
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                setState(() => _cart.removeAt(idx));
                                if (_cart.isEmpty) {
                                  Navigator.pop(context);
                                } else {
                                  // Refresh the sheet
                                  Navigator.pop(context);
                                  _showCart();
                                }
                              },
                            ),
                          );
                        },
                      ),
              ),
              if (_cart.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF1E3A8A),
                      ),
                      onPressed: _finalizePurchase,
                      child: const Text('PROCESAR COMPRA'),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _finalizePurchase() async {
    Navigator.pop(context); // Close sheet
    setState(() => _loading = true);

    final ok = await _apiService.cargarCompra(_cart);

    if (mounted) {
      setState(() => _loading = false);
      if (ok) {
        setState(() => _cart.clear());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Compra procesada con éxito'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al procesar la compra'),
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
          'Cargar Compras',
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
                        builder: (context) => const BarcodeScannerScreen(),
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
                        subtitle: Text('Stock actual: ${p.stock ?? 0}'),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: Color(0xFF1E3A8A),
                          ),
                          onPressed: () => _showAddStockDialog(p),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[50],
                          child: Text(
                            p.nombre.substring(0, 1).toUpperCase(),
                            style: const TextStyle(color: Color(0xFF1E3A8A)),
                          ),
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
              label: Text('Finalizar (${_cart.length})'),
              icon: const Icon(Icons.shopping_cart),
              backgroundColor: const Color(0xFF1E3A8A),
            ),
    );
  }
}
