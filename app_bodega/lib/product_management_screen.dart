import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';
import 'product_model.dart';
import 'product_form_screen.dart';
import 'scanner_screen.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  final ApiService _apiService = ApiService();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _loading = true;
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final products = await _apiService.getProducts();
      setState(() {
        _allProducts = products;
        _loading = false;
      });
      _filter(_searchQuery);
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _filter(String q) {
    setState(() {
      _searchQuery = q.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((p) {
          final query = _searchQuery;
          return p.nombre.toLowerCase().contains(query) ||
              (p.codigoBarras?.contains(query) ?? false) ||
              (p.codigoInterno?.toLowerCase().contains(query) ?? false);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Gestión de Inventario',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF1E3A8A)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E3A8A),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchCtrl,
              onChanged: _filter,
              decoration: InputDecoration(
                hintText: 'Buscar para editar...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1E3A8A)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () async {
                    final code = await Navigator.push(context, MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()));
                    if (code != null) {
                      _searchCtrl.text = code;
                      _filter(code);
                    }
                  },
                ),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100, left: 16, right: 16, top: 10),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final p = _filteredProducts[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue[50],
                            child: const Icon(Icons.edit, color: Color(0xFF1E3A8A)),
                          ),
                          title: Text(p.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Stock: ${p.stock?.toStringAsFixed(2)} ${p.unidadMedida}'),
                              Text('Precio: \$${p.precioVenta?.toStringAsFixed(2)}'),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            final res = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ProductFormScreen(product: p)),
                            );
                            if (res == true) _loadData();
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductFormScreen()));
          if (res == true) _loadData();
        },
        backgroundColor: const Color(0xFF1E3A8A),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Nuevo Producto', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
