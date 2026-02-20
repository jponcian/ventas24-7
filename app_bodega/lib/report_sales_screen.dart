import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'api_service.dart';

class ReportSalesScreen extends StatefulWidget {
  final DateTime? initialDate;
  final bool showProductsOnly;
  const ReportSalesScreen({
    super.key,
    this.initialDate,
    this.showProductsOnly = false,
  });

  @override
  State<ReportSalesScreen> createState() => _ReportSalesScreenState();
}

class _ReportSalesScreenState extends State<ReportSalesScreen> {
  final ApiService _apiService = ApiService();
  late DateTime _selectedDate;
  Map<String, dynamic>? _reportData;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
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
          widget.showProductsOnly ? 'Artículos Vendidos' : 'Reporte de Ventas',
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
                    if (widget.showProductsOnly)
                      _buildProductsList()
                    else ...[
                      _buildPaymentMethodsSummary(),
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
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    final productos = _reportData!['productos'] as List? ?? [];
    if (productos.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('No hay artículos vendidos hoy'),
        ),
      );
    }

    return Column(
      children: productos.map((p) {
        final nombre = p['nombre'] ?? 'Desconocido';
        final qty = double.tryParse(p['total_cantidad'].toString()) ?? 0;
        final total = double.tryParse(p['total_bs'].toString()) ?? 0;
        final unidad = p['unidad_medida'] ?? '';
        final codigo = p['codigo_interno'] ?? '';
        final proveedor = p['proveedor'] ?? '';

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[50],
              child: Text(
                '${qty % 1 == 0 ? qty.toInt() : qty.toStringAsFixed(1)}',
                style: const TextStyle(
                  color: Color(0xFF1E3A8A),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            title: Text(
              nombre,
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (codigo.isNotEmpty)
                  Text(
                    'Código: $codigo',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                if (proveedor.isNotEmpty && proveedor != 'Sin Proveedor')
                  Text(
                    'Prov: $proveedor',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${total.toStringAsFixed(2)} Bs',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  unidad,
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _showVentaDetalle(int ventaId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final res = await _apiService.getVentaDetalle(ventaId);
      if (!mounted) return;
      Navigator.pop(context); // Cerrar loading

      final detalles = res['detalles'] as List;
      final pagos = res['pagos'] as List;
      final info = res['info'] as Map<String, dynamic>?;

      if (detalles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay detalles para esta venta')),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 500,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: IntrinsicHeight(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Detalle Venta #$ventaId',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E3A8A),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'CERRAR',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (info != null && info['cliente_nombre'] != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Cliente: ${info['cliente_nombre']}',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                    const Divider(height: 32),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PRODUCTOS',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...detalles.map((d) {
                              double cant =
                                  double.tryParse(
                                    d['cantidad']?.toString() ?? '0',
                                  ) ??
                                  0;
                              double precio =
                                  double.tryParse(
                                    d['precio_unitario_bs']?.toString() ?? '0',
                                  ) ??
                                  0;
                              String nombre =
                                  d['nombre']?.toString() ?? 'Producto';
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${cant % 1 == 0 ? cant.toInt() : cant.toStringAsFixed(3)} x $nombre',
                                        style: GoogleFonts.outfit(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${(cant * precio).toStringAsFixed(2)} Bs',
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1E3A8A),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 32),
                            Text(
                              'FORMAS DE PAGO',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...pagos.map((p) {
                              double mBs =
                                  double.tryParse(
                                    p['monto_bs']?.toString() ?? '0',
                                  ) ??
                                  0;
                              double mUsd =
                                  double.tryParse(
                                    p['monto_usd']?.toString() ?? '0',
                                  ) ??
                                  0;
                              String ref = p['referencia']?.toString() ?? '';
                              String metodo =
                                  p['metodo_nombre']?.toString() ?? 'Otro';
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            metodo,
                                            style: GoogleFonts.outfit(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          if (ref.isNotEmpty)
                                            Text(
                                              'Ref: $ref',
                                              style: GoogleFonts.outfit(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        if (mUsd > 0)
                                          Text(
                                            '$mUsd USD',
                                            style: GoogleFonts.outfit(
                                              color: Colors.green[700],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        if (mBs > 0)
                                          Text(
                                            '${mBs.toStringAsFixed(2)} Bs',
                                            style: GoogleFonts.outfit(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Anular Venta'),
                              content: const Text(
                                '¿Estás seguro de anular esta venta? El stock se devolverá al inventario.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('CANCELAR'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('ANULAR'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            Navigator.pop(context); // Cerrar detalle
                            setState(() => _loading = true);
                            final ok = await _apiService.anularVenta(ventaId);
                            setState(() => _loading = false);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    ok
                                        ? 'Venta anulada correctamente'
                                        : 'Error al anular la venta',
                                  ),
                                  backgroundColor: ok
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              );
                              if (ok) _loadReport();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFEBEE),
                          foregroundColor: Colors.red[700],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'ANULAR VENTA',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Cerrar loading si falló
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al cargar detalle: $e')));
      }
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
}
