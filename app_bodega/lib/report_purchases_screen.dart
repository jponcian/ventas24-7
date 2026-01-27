import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'api_service.dart';

class ReportPurchasesScreen extends StatefulWidget {
  const ReportPurchasesScreen({super.key});

  @override
  State<ReportPurchasesScreen> createState() => _ReportPurchasesScreenState();
}

class _ReportPurchasesScreenState extends State<ReportPurchasesScreen> {
  final ApiService _apiService = ApiService();
  DateTime _selectedDate = DateTime.now();
  Map<String, dynamic>? _reportData;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    setState(() => _loading = true);
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final data = await _apiService.getReporteCompras(dateStr);
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
          'Reporte de Compras',
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
            child: Row(
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
                    Text(
                      'Compras Detalladas',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildGroupedList(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final resumen = _reportData!['resumen'] ?? {};
    final totalCosto =
        double.tryParse(resumen['total_costo'].toString()) ?? 0.0;
    final trans = resumen['total_transacciones'] ?? 0;

    return Row(
      children: [
        Expanded(
          child: _buildCard(
            'Total Costo',
            '${totalCosto.toStringAsFixed(2)} \$',
            Colors.redAccent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: _buildCard('Transacciones', '$trans', Colors.blueGrey)),
      ],
    );
  }

  Widget _buildCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.3)),
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
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedList() {
    final items = _reportData!['items'] as List? ?? [];
    if (items.isEmpty) {
      return const Center(child: Text('No hay compras registradas'));
    }

    // Group by provider
    Map<String, List<dynamic>> grouped = {};
    for (var item in items) {
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
              // Header Provider
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
              // List Items
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: entry.value.length,
                itemBuilder: (context, index) {
                  final p = entry.value[index];
                  final nombre = p['nombre'] ?? '';
                  final qty = double.tryParse(p['cantidad'].toString()) ?? 0;
                  final cost =
                      double.tryParse(p['costo_unitario'].toString()) ?? 0;
                  final total = double.tryParse(p['total'].toString()) ?? 0;

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nombre,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${qty.toStringAsFixed(2)} unid x ${cost.toStringAsFixed(2)} \$',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${total.toStringAsFixed(2)} \$',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green[700],
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
