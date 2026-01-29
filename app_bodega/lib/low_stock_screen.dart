import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';
import 'product_model.dart';
// Reuse for editing if needed

class LowStockScreen extends StatefulWidget {
  const LowStockScreen({super.key});

  @override
  State<LowStockScreen> createState() => _LowStockScreenState();
}

class _LowStockScreenState extends State<LowStockScreen> {
  final ApiService _apiService = ApiService();
  List<Product> _lowStockProducts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final all = await _apiService.getProducts();
      final low = all.where((p) {
        if (p.id < 0) return false; // Skip packages
        double stock = (p.stock ?? 0).toDouble();
        double min = (p.bajoInventario ?? 0).toDouble();
        return stock <= min;
      }).toList();

      setState(() {
        _lowStockProducts = low;
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inventario Bajo',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _lowStockProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Todo en orden',
                    style: GoogleFonts.outfit(fontSize: 18),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: (() {
                // Agrupar por proveedor
                final Map<String, List<Product>> grouped = {};
                for (var p in _lowStockProducts) {
                  final prov = (p.proveedor != null && p.proveedor!.isNotEmpty)
                      ? p.proveedor!
                      : 'Sin Proveedor';
                  if (!grouped.containsKey(prov)) {
                    grouped[prov] = [];
                  }
                  grouped[prov]!.add(p);
                }

                // Ordenar proveedores alfabéticamente
                final sortedKeys = grouped.keys.toList()..sort();

                return sortedKeys.map((provKey) {
                  final products = grouped[provKey]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.business,
                              size: 18,
                              color: Color(0xFF1E3A8A),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              provKey.toUpperCase(),
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E3A8A),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...products.map(
                        (p) => Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.red,
                              ),
                            ),
                            title: Text(
                              p.nombre,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Proveedor: ${p.proveedor ?? "N/A"}',
                              style: GoogleFonts.outfit(fontSize: 12),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Stock: ${p.stock?.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.red[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Mín: ${p.bajoInventario?.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                }).toList();
              })(),
            ),
    );
  }
}
