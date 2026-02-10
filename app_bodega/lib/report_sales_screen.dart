import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'api_service.dart';

class ReportSalesScreen extends StatefulWidget {
  const ReportSalesScreen({super.key});

  @override
  State<ReportSalesScreen> createState() => _ReportSalesScreenState();
}

class _ReportSalesScreenState extends State<ReportSalesScreen> {
  final ApiService _apiService = ApiService();
  DateTime _selectedDate = DateTime.now();
  Map<String, dynamic>? _reportData;
  bool _loading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    setState(() => _loading = true);
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final data = await _apiService.getReporteDia(dateStr);
    if (mounted) {
      setState(() {
        _reportData = data;
        _loading = false;
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
      _loadReport();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Reporte de Ventas',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _pickDate,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat.yMMMMEEEEd('es_ES').format(_selectedDate),
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: _pickDate,
                      child: const Text('Cambiar Fecha'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre o código interno...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onChanged: (val) =>
                      setState(() => _searchQuery = val.toLowerCase()),
                ),
              ],
            ),
          ),
          if (_loading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_reportData == null || _reportData!['ok'] != true)
            const Expanded(
              child: Center(child: Text('No se pudo cargar el reporte')),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSummaryCards(),
                    const SizedBox(height: 24),
                    _buildPaymentMethodsSummary(),
                    const SizedBox(height: 24),
                    Text(
                      'Ventas por Proveedor',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildGroupedProductList(),
                    const SizedBox(height: 24),
                    Text(
                      'Ventas del Día',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildIndividualSalesList(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showVentaDetalle(int ventaId) async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final detalles = await _apiService.getVentaDetalle(ventaId);

    if (mounted) Navigator.pop(context); // Cerrar loading

    if (detalles.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay detalles para esta venta')),
        );
      }
      return;
    }

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Detalle Venta #$ventaId'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 90),
              shrinkWrap: true,
              itemCount: detalles.length,
              itemBuilder: (context, i) {
                final d = detalles[i];
                double cant = double.tryParse(d['cantidad'].toString()) ?? 0;
                double precio =
                    double.tryParse(d['precio_unitario_bs'].toString()) ?? 0;
                return ListTile(
                  title: Text(d['nombre'] ?? 'Producto'),
                  subtitle: Text(
                    '${cant % 1 == 0 ? cant.toInt() : cant.toStringAsFixed(3)} x ${precio.toStringAsFixed(2)} Bs',
                  ),
                  trailing: Text(
                    '${(cant * precio).toStringAsFixed(2)} Bs',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CERRAR'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildIndividualSalesList() {
    final ventas = _reportData!['ventas'] as List? ?? [];
    if (ventas.isEmpty) {
      return const Center(child: Text('No hay ventas individuales'));
    }

    return Column(
      children: ventas.map((sale) {
        final dateUtc = DateTime.parse(sale['fecha']);
        final dateLocal = dateUtc.toLocal();
        final metodo = sale['metodo_pago'] ?? 'Efectivo';

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: ListTile(
            onTap: () => _showVentaDetalle(sale['id']),
            leading: CircleAvatar(
              backgroundColor: metodo == 'Crédito'
                  ? Colors.orange[50]
                  : Colors.blue[50],
              child: Icon(
                metodo == 'Crédito' ? Icons.timer : Icons.payments_outlined,
                color: metodo == 'Crédito' ? Colors.orange : Colors.blue,
                size: 20,
              ),
            ),
            title: Text('Venta #${sale['id']} - $metodo'),
            subtitle: Text(DateFormat('hh:mm a').format(dateLocal)),
            trailing: Text(
              '\$${(double.tryParse(sale['total_usd'].toString()) ?? 0).toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPaymentMethodsSummary() {
    final metodos = _reportData!['resumen_metodos'] as List? ?? [];
    if (metodos.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumen por Forma de Pago',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: metodos.length,
            itemBuilder: (context, i) {
              final m = metodos[i];
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      m['metodo'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${(double.tryParse(m['total_usd'].toString()) ?? 0).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${(double.tryParse(m['total_bs'].toString()) ?? 0).toStringAsFixed(2)} Bs',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    final resumen = _reportData!['resumen'] ?? {};
    final totalBs = double.tryParse(resumen['total_bs'].toString()) ?? 0.0;
    final totalUsd = double.tryParse(resumen['total_usd'].toString()) ?? 0.0;

    return Row(
      children: [
        Expanded(
          child: _buildCard(
            'Ventas (Bs)',
            '${totalBs.toStringAsFixed(2)} Bs',
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCard(
            'Ventas (USD)',
            '${totalUsd.toStringAsFixed(2)} \$',
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String title, String value, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: color[800],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedProductList() {
    final productos = _reportData!['productos'] as List? ?? [];
    if (productos.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('No hay ventas registradas'),
        ),
      );
    }

    // Agrupar por proveedor y aplicar filtro
    Map<String, List<dynamic>> grouped = {};
    for (var item in productos) {
      final nombre = (item['nombre'] ?? '').toString().toLowerCase();
      final code = (item['codigo_interno'] ?? '').toString().toLowerCase();

      if (_searchQuery.isNotEmpty &&
          !nombre.contains(_searchQuery) &&
          !code.contains(_searchQuery)) {
        continue;
      }

      String prov = item['proveedor'] ?? 'Sin Proveedor';
      if (!grouped.containsKey(prov)) grouped[prov] = [];
      grouped[prov]!.add(item);
    }

    return Column(
      children: grouped.entries.map((entry) {
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header del Proveedor
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Text(
                  entry.key.toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E3A8A),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              // Lista de productos de ese proveedor
              ListView.builder(
                padding: EdgeInsets.only(bottom: 90),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: entry.value.length,
                itemBuilder: (context, index) {
                  final p = entry.value[index];
                  final nombre = p['nombre'] ?? 'Desconocido';
                  final qty =
                      double.tryParse(p['total_cantidad'].toString()) ?? 0;
                  final total = double.tryParse(p['total_bs'].toString()) ?? 0;
                  final unidad = p['unidad_medida'] ?? '';

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: index < entry.value.length - 1
                              ? Colors.grey[100]!
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF1E3A8A,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${qty.toInt()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nombre,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (p['codigo_interno'] != null &&
                                  p['codigo_interno'].toString().isNotEmpty)
                                Text(
                                  'Cod: ${p['codigo_interno']}',
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              Text(
                                '$unidad',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${total.toStringAsFixed(2)} Bs',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
