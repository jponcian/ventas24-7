import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'api_service.dart';

class SalesChartsScreen extends StatefulWidget {
  const SalesChartsScreen({super.key});

  @override
  State<SalesChartsScreen> createState() => _SalesChartsScreenState();
}

class _SalesChartsScreenState extends State<SalesChartsScreen> {
  final ApiService _apiService = ApiService();
  bool _loading = true;
  Map<String, dynamic> _data = {};
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final fecha = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final res = await _apiService.getAdminDashboardData(fecha);
    setState(() {
      _data = res;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Análisis de Ventas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2023),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() => _selectedDate = picked);
                _loadData();
              }
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildHourlyChart(),
                  const SizedBox(height: 24),
                  _buildProfitSummary(),
                ],
              ),
            ),
    );
  }

  Widget _buildHourlyChart() {
    final ventas = _data['ventas_por_hora'] as List? ?? [];
    if (ventas.isEmpty) return const Text('Sin datos hoy');

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Text(
            'Ventas por Hora',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: ventas.asMap().entries.map((e) {
                      return FlSpot(
                        e.key.toDouble(),
                        double.tryParse(e.value['total'].toString()) ?? 0,
                      );
                    }).toList(),
                    isCurved: true,
                    color: Colors.blue,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.1),
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

  Widget _buildProfitSummary() {
    final total =
        double.tryParse(_data['total_ventas_usd']?.toString() ?? '0') ?? 0;
    final costos =
        double.tryParse(_data['total_costos_usd']?.toString() ?? '0') ?? 0;
    final ganancia = total - costos;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _statItem('Ventas', '\$${total.toStringAsFixed(2)}', Colors.green),
            _statItem(
              'Ganancia',
              '\$${ganancia.toStringAsFixed(2)}',
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
