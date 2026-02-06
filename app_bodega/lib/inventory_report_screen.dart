import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
  double _totalVentaUsd = 0;
  double _totalUnidades = 0;
  double _tasa = 1.0;
  bool _showProducts = false;

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
        double ventaUsd = 0;
        double unidades = 0;

        for (var p in prods) {
          double stock = double.tryParse(p['stock'].toString()) ?? 0;
          double costo = double.tryParse(p['costo_unitario'].toString()) ?? 0;
          double venta = double.tryParse(p['precio_venta'].toString()) ?? 0;
          bool esBs = p['moneda_base'] == 'BS';

          unidades += stock;

          if (esBs) {
            bs += stock * costo;
            ventaUsd += (stock * venta) / tasaSys;
          } else {
            usd += stock * costo;
            ventaUsd += stock * venta;
          }
        }

        setState(() {
          _productos = prods;
          _totalCostoUsd = usd;
          _totalCostoBs = bs;
          _totalVentaUsd = ventaUsd;
          _totalUnidades = unidades;
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

  String _formatCurrency(double value) {
    return NumberFormat('#,##0.00', 'es_ES').format(value);
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
                if (_showProducts)
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom: 90,
                      ),
                      itemCount: _productos.length,
                      itemBuilder: (context, i) {
                        final p = _productos[i];
                        double stock =
                            double.tryParse(p['stock'].toString()) ?? 0;
                        double costo =
                            double.tryParse(p['costo_unitario'].toString()) ??
                            0;
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Stock: ${stock % 1 == 0 ? stock.toInt() : stock.toStringAsFixed(3)} | Costo: ${_formatCurrency(costo)} $moneda\nCódigo: ${p['codigo_interno'] ?? p['codigo_barras'] ?? 'Sin Código'} | Marca: ${p['marca'] ?? 'N/A'}',
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${_formatCurrency(subtotal)} $moneda',
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
                  )
                else
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Toca el contador para ver los productos',
                        style: TextStyle(color: Colors.grey),
                      ),
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
            'VALOR TOTAL DETERMINADO (INVERSIÓN)',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${_formatCurrency(totalGlobalUsd)}',
            style: GoogleFonts.outfit(
              fontSize: 38,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF10B981),
            ),
          ),
          Text(
            'Eq. ${_formatCurrency(totalGlobalUsd * _tasa)} Bs',
            style: GoogleFonts.outfit(
              color: Colors.grey[500],
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tasa BCV del día: ${_formatCurrency(_tasa)}',
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 24),
          // Resumen de negocio (Estimaciones)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  'VENTA ESTIMADA',
                  '\$${_formatCurrency(_totalVentaUsd)}',
                  Colors.white,
                ),
                Container(width: 1, height: 40, color: Colors.white24),
                _buildSummaryItem(
                  'GANANCIA BRUTA',
                  '\$${_formatCurrency(_totalVentaUsd - totalGlobalUsd)}',
                  const Color(0xFF34D399),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Única estadística adicional: Cantidad de productos
          InkWell(
            onTap: () => setState(() => _showProducts = !_showProducts),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _showProducts
                      ? const Color(0xFF1E3A8A)
                      : Colors.transparent,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _showProducts
                        ? Icons.visibility_off
                        : Icons.inventory_2_outlined,
                    size: 20,
                    color: const Color(0xFF1E3A8A),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'PRODUCTOS EN STOCK: ',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${_productos.length} (${_totalUnidades % 1 == 0 ? _totalUnidades.toInt() : _totalUnidades.toStringAsFixed(2)} unds)',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1E3A8A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color valColor) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valColor,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
