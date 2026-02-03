import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';
import 'fiado_model.dart';
import 'product_model.dart';
import 'scanner_screen.dart';

class NuevoFiadoScreen extends StatefulWidget {
  const NuevoFiadoScreen({super.key});

  @override
  State<NuevoFiadoScreen> createState() => _NuevoFiadoScreenState();
}

class _NuevoFiadoScreenState extends State<NuevoFiadoScreen> {
  final ApiService _apiService = ApiService();
  List<Cliente> _clientes = [];
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  Cliente? _selectedCliente;
  bool _loading = true;
  double _tasa = 0.0;
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      _tasa = await _apiService.getTasa();
    } catch (e) {
      _tasa = 0.0;
    }
    final clientes = await _apiService.getClientes();
    final products = await _apiService.getProducts();

    setState(() {
      _clientes = clientes;
      _allProducts = products.map((p) {
        p.qty = 0;
        return p;
      }).toList();
      _filteredProducts = _allProducts;
      _loading = false;
    });
  }

  void _filter(String q) {
    setState(() {
      _searchQuery = q.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((p) {
          return p.nombre.toLowerCase().contains(_searchQuery) ||
              (p.codigoBarras != null &&
                  p.codigoBarras!.contains(_searchQuery)) ||
              (p.descripcion != null &&
                  p.descripcion!.toLowerCase().contains(_searchQuery));
        }).toList();
      }
    });
  }

  Future<void> _guardarFiado() async {
    if (_selectedCliente == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes seleccionar un cliente'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final productosConCantidad = _allProducts.where((p) => p.qty > 0).toList();

    if (productosConCantidad.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes agregar al menos un producto'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    double totalBs = 0;
    double totalUsd = 0;

    final detalles = productosConCantidad.map((p) {
      double precio = p.precioReal;
      bool esDolar = p.monedaCompra != 'BS';
      double precioBs = esDolar ? precio * _tasa : precio;
      double precioUsd = esDolar ? precio : precio / _tasa;

      double cantDescuento = (p.id < 0) ? p.qty * (p.tamPaquete ?? 1.0) : p.qty;

      totalBs += precioBs * p.qty;
      totalUsd += precioUsd * p.qty;

      return {
        'producto_id': p.id.abs(),
        'cantidad': cantDescuento,
        'precio_unitario_bs': precioBs,
        'precio_unitario_usd': precioUsd,
      };
    }).toList();

    final data = {
      'cliente_id': _selectedCliente!.id,
      'total_bs': totalBs,
      'total_usd': totalUsd,
      'tasa': _tasa,
      'detalles': detalles,
    };

    setState(() => _loading = true);
    final result = await _apiService.crearFiado(data);
    setState(() => _loading = false);

    if (mounted) {
      if (result['ok'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fiado registrado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? 'Error al registrar fiado'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Nuevo Fiado',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              final selected = _allProducts.where((p) => p.qty > 0).toList();
              if (selected.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No hay productos seleccionados'),
                  ),
                );
                return;
              }
              _showResumen();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Selector de cliente
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cliente',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<Cliente>(
                        value: _selectedCliente,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                        hint: const Text('Seleccionar cliente'),
                        items: _clientes.map((c) {
                          return DropdownMenuItem(
                            value: c,
                            child: Text(c.nombre),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedCliente = value);
                        },
                      ),
                    ],
                  ),
                ),

                // Buscador de productos con escaneo
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: _filter,
                          decoration: InputDecoration(
                            hintText: 'Buscar producto...',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.qr_code_scanner,
                            color: Color(0xFF1E3A8A),
                          ),
                          onPressed: _scanBarcode,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Lista de productos
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, i) {
                      final p = _filteredProducts[i];
                      double precio = p.precioReal;
                      bool esDolar = p.monedaCompra != 'BS';
                      double precioBs = esDolar ? precio * _tasa : precio;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(
                            p.nombre,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${precioBs.toStringAsFixed(2)} Bs',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              if (p.stock != null)
                                Text(
                                  'Stock: ${p.stock}',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                          trailing: p.qty > 0
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E3A8A),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    p.qty % 1 == 0
                                        ? p.qty.toInt().toString()
                                        : p.qty.toStringAsFixed(2),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : null,
                          onTap: () => _showQuantityDialog(p),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _guardarFiado,
        backgroundColor: const Color(0xFF10B981),
        icon: const Icon(Icons.check),
        label: Text(
          'Guardar Fiado',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> _scanBarcode() async {
    final String? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _searchCtrl.text = result;
      });
      _filter(result);

      // Si hay un solo producto con ese código, abrir el diálogo de cantidad de una vez
      final matching = _allProducts
          .where((p) => p.codigoBarras == result)
          .toList();
      if (matching.length == 1) {
        _showQuantityDialog(matching.first);
      }
    }
  }

  void _showQuantityDialog(Product product) {
    final qtyCtrl = TextEditingController(
      text: product.qty > 0 ? product.qty.toString() : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.nombre),
        content: TextField(
          controller: qtyCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Cantidad',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          if (product.qty > 0)
            TextButton(
              onPressed: () {
                setState(() => product.qty = 0);
                Navigator.pop(context);
              },
              child: const Text('Eliminar'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final qty = double.tryParse(qtyCtrl.text) ?? 0;
              if (qty > 0) {
                setState(() => product.qty = qty);
              }
              Navigator.pop(context);
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void _showResumen() {
    final selected = _allProducts.where((p) => p.qty > 0).toList();
    double totalBs = 0;
    double totalUsd = 0;

    for (var p in selected) {
      double precio = p.precioReal;
      bool esDolar = p.monedaCompra != 'BS';
      double precioBs = esDolar ? precio * _tasa : precio;
      totalBs += precioBs * p.qty;
      totalUsd += (esDolar ? precio : precio / _tasa) * p.qty;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Resumen del Fiado',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: selected.length,
                itemBuilder: (context, i) {
                  final p = selected[i];
                  double precio = p.precioReal;
                  bool esDolar = p.monedaCompra != 'BS';
                  double precioBs = esDolar ? precio * _tasa : precio;

                  return ListTile(
                    title: Text(p.nombre),
                    subtitle: Text(
                      '${p.qty % 1 == 0 ? p.qty.toInt() : p.qty.toStringAsFixed(2)} x ${precioBs.toStringAsFixed(2)} Bs',
                    ),
                    trailing: Text(
                      '${(precioBs * p.qty).toStringAsFixed(2)} Bs',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TOTAL',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${totalBs.toStringAsFixed(2)} Bs',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E3A8A),
                            ),
                          ),
                          Text(
                            '\$${totalUsd.toStringAsFixed(2)} USD',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
