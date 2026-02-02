import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';

class InventoryReportScreen extends StatefulWidget {
  const InventoryReportScreen({super.key});

  @override
  State<InventoryReportScreen> createState() => _InventoryReportScreenState();
}

class _InventoryReportScreenState extends State<InventoryReportScreen> {
  final ApiService _apiService = ApiService();
  bool _loading = true;
  List<dynamic> _productos = [];
  double _totalCostoUsd = 0;
  double _totalCostoBs = 0;
  double _tasa = 1.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final res = await _apiService.getReporteInventario();
      final tasaSys = await _apiService.getTasa();

      if (res['ok'] == true) {
        final prods = res['productos'] as List;
        double usd = 0;
        double bs = 0;

        for (var p in prods) {
          double stock = double.tryParse(p['stock'].toString()) ?? 0;
          double costo = double.tryParse(p['costo_unitario'].toString()) ?? 0;
          bool esBs = p['moneda_base'] == 'BS';

          if (esBs) {
            bs += stock * costo;
          } else {
            usd += stock * costo;
          }
        }

        setState(() {
          _productos = prods;
          _totalCostoUsd = usd;
          _totalCostoBs = bs;
          _tasa = tasaSys > 0 ? tasaSys : 1.0;
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalGlobalUsd = _totalCostoUsd + (_totalCostoBs / _tasa);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Inventario y Activos',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildHeader(totalGlobalUsd),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _productos.length,
                    itemBuilder: (context, i) {
                      final p = _productos[i];
                      double stock =
                          double.tryParse(p['stock'].toString()) ?? 0;
                      double costo =
                          double.tryParse(p['costo_unitario'].toString()) ?? 0;
                      String moneda = p['moneda_base'] ?? 'USD';
                      double subtotal = stock * costo;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          title: Text(
                            p['nombre'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Stock: ${stock % 1 == 0 ? stock.toInt() : stock.toStringAsFixed(3)} | Costo: $costo $moneda',
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${subtotal.toStringAsFixed(2)} $moneda',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              Text(
                                p['proveedor'] ?? 'Sin Proveedor',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeader(double totalGlobalUsd) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'VALOR TOTAL DEL INVENTARIO',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${totalGlobalUsd.toStringAsFixed(2)}',
            style: GoogleFonts.outfit(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Eq. ${(totalGlobalUsd * _tasa).toStringAsFixed(2)} Bs',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniStat(
                'En USD',
                '\$${_totalCostoUsd.toStringAsFixed(2)}',
              ),
              _buildMiniStat('En BS', '${_totalCostoBs.toStringAsFixed(2)} Bs'),
              _buildMiniStat('Items', '${_productos.length}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
      ],
    );
  }
}
