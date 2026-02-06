import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'api_service.dart';
import 'main.dart';
import 'calc_screen.dart';
import 'low_stock_screen.dart';

import 'update_helper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _data;
  bool _loading = true;
  double _tasa = 0.0;
  String _userName = '';
  String _negocioName = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadDashboard();
    // Verificar actualizaciones
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateHelper.checkUpdate(context);
    });
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Usuario';
      _negocioName = prefs.getString('negocio_nombre') ?? 'Ventas 24/7';
    });
    try {
      _tasa = await _apiService.getTasa();
    } catch (e) {
      _tasa = 0.0;
    }
  }

  Future<void> _loadDashboard() async {
    setState(() => _loading = true);
    final res = await _apiService.getDashboardData();
    setState(() {
      _data = res;
      _loading = false;
    });
  }

  Future<void> _generarEtiquetasPDF() async {
    final productos = await _apiService.getProducts();
    if (productos.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hay productos para generar etiquetas'),
          ),
        );
      }
      return;
    }

    final selectedIds = await showDialog<List<int>>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            Set<int> selectedIds = {};
            return AlertDialog(
              title: const Text('Seleccionar Productos'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: productos.length,
                  itemBuilder: (context, i) {
                    final p = productos[i];
                    final isSelected = selectedIds.contains(p.id.abs());
                    return CheckboxListTile(
                      title: Text(p.nombre),
                      value: isSelected,
                      onChanged: (val) {
                        setStateDialog(() {
                          if (val == true) {
                            selectedIds.add(p.id.abs());
                          } else {
                            selectedIds.remove(p.id.abs());
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, selectedIds.toList()),
                  child: const Text('Imprimir Selección'),
                ),
              ],
            );
          },
        );
      },
    );

    if (selectedIds == null || selectedIds.isEmpty) return;

    final seleccionados = productos
        .where((p) => selectedIds.contains(p.id.abs()))
        .toList();

    final pdf = pw.Document();
    const etiquetasPorPagina = 15;
    const columnas = 3;

    for (int i = 0; i < seleccionados.length; i += etiquetasPorPagina) {
      final chunk = seleccionados.skip(i).take(etiquetasPorPagina).toList();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.letter,
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) {
            return pw.GridView(
              crossAxisCount: columnas,
              childAspectRatio: 2.5,
              children: chunk.map((p) {
                double precio = p.precioVenta ?? 0;
                bool esDolar = p.monedaCompra != 'BS';
                double precioBs = esDolar ? precio * _tasa : precio;
                return pw.Container(
                  margin: const pw.EdgeInsets.all(4),
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 1),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        p.nombre.length > 25
                            ? '${p.nombre.substring(0, 25)}...'
                            : p.nombre,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Bs. ${precioBs.toStringAsFixed(2)}',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      );
    }

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> _showVentaDetalle(int ventaId) async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final detalles = await _apiService.getVentaDetalle(ventaId);

    if (mounted) Navigator.pop(context); // Close loading

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
                    '${d['codigo_barras'] ?? 'Sin Cód.'}\n${cant % 1 == 0 ? cant.toInt() : cant.toStringAsFixed(3)} x ${precio.toStringAsFixed(2)} Bs',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const MainDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _negocioName,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E3A8A),
              ),
            ),
            Text(
              'Hola, $_userName',
              style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Color(0xFF1E3A8A),
            ),
            tooltip: 'Ir a Ventas',
            onPressed: () => Navigator.pushNamed(context, '/sales'),
          ),
          IconButton(
            icon: const Icon(
              Icons.calculate_outlined,
              color: Color(0xFF1E3A8A),
            ),
            tooltip: 'Calculadora',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalcScreen(tasa: _tasa)),
            ),
          ),
          if (_userName
              .isNotEmpty) // Mostrar PDF para todos los usuarios autenticados
            IconButton(
              icon: const Icon(Icons.print_outlined, color: Color(0xFFEF4444)),
              tooltip: 'Generar Etiquetas PDF',
              onPressed: () => _generarEtiquetasPDF(),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboard,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: _loadDashboard,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resumen de Hoy',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Ventas Hoy',
                              '\$${(double.tryParse((_data?['today_total_usd'] ?? 0).toString()) ?? 0).toStringAsFixed(2)}',
                              Icons.monetization_on_rounded,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LowStockScreen(),
                                  ),
                                );
                              },
                              child: _buildStatCard(
                                'Stock Bajo',
                                '${_data?['low_stock_count'] ?? 0}',
                                Icons.warning_amber_rounded,
                                Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Últimas Ventas',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (_data?['latest_sales'] != null &&
                          (_data!['latest_sales'] as List).isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: (_data!['latest_sales'] as List).length,
                          itemBuilder: (context, i) {
                            final sale = _data!['latest_sales'][i];
                            final dateUtc = DateTime.parse(sale['fecha']);
                            final dateLocal = dateUtc.toLocal();
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                onTap: () => _showVentaDetalle(sale['id']),
                                leading: const CircleAvatar(
                                  backgroundColor: Color(0xFFE2E8F0),
                                  child: Icon(
                                    Icons.receipt_long,
                                    color: Color(0xFF1E3A8A),
                                  ),
                                ),
                                title: Text('Venta #${sale['id']}'),
                                subtitle: Text(
                                  DateFormat('hh:mm a').format(dateLocal),
                                ),
                                trailing: Text(
                                  '\$${(double.tryParse((sale['total_usd'] ?? 0).toString()) ?? 0).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      else
                        const Center(
                          child: Text('No hay ventas registradas hoy'),
                        ),

                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/sales'),
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text('NUEVA VENTA'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 15),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
