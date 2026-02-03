import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'api_service.dart';
import 'fiado_model.dart';

class FiadoDetailScreen extends StatefulWidget {
  final int fiadoId;

  const FiadoDetailScreen({super.key, required this.fiadoId});

  @override
  State<FiadoDetailScreen> createState() => _FiadoDetailScreenState();
}

class _FiadoDetailScreenState extends State<FiadoDetailScreen> {
  final ApiService _apiService = ApiService();
  Fiado? _fiado;
  List<Abono> _abonos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final fiado = await _apiService.getFiadoDetalle(widget.fiadoId);
    final abonos = await _apiService.getAbonosFiado(widget.fiadoId);
    setState(() {
      _fiado = fiado;
      _abonos = abonos;
      _loading = false;
    });
  }

  Future<void> _registrarAbono() async {
    if (_fiado == null) return;

    final montoCtrl = TextEditingController();
    final obsCtrl = TextEditingController();
    String moneda = 'USD';

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Registrar Abono'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: montoCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Monto',
                  prefixText: moneda == 'USD' ? '\$ ' : 'Bs ',
                  border: const OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'USD', label: Text('USD')),
                  ButtonSegment(value: 'BS', label: Text('Bs')),
                ],
                selected: {moneda},
                onSelectionChanged: (Set<String> newSelection) {
                  setDialogState(() {
                    moneda = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: obsCtrl,
                decoration: const InputDecoration(
                  labelText: 'Observaciones (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              Text(
                'Saldo pendiente: \$${_fiado!.saldoPendiente.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final monto = double.tryParse(montoCtrl.text) ?? 0;
                if (monto <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ingresa un monto válido'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                Navigator.pop(context, true);

                // Obtener tasa actual
                double tasa = 1.0;
                try {
                  tasa = await _apiService.getTasa();
                } catch (e) {
                  tasa = 1.0;
                }

                double montoBs = moneda == 'BS' ? monto : monto * tasa;
                double montoUsd = moneda == 'USD' ? monto : monto / tasa;

                final abonoData = {
                  'fiado_id': widget.fiadoId,
                  'monto_bs': montoBs,
                  'monto_usd': montoUsd,
                  'observaciones': obsCtrl.text.trim().isEmpty
                      ? null
                      : obsCtrl.text.trim(),
                };

                setState(() => _loading = true);
                final res = await _apiService.registrarAbono(abonoData);
                setState(() => _loading = false);

                if (mounted) {
                  if (res['ok'] == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Abono registrado exitosamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    _loadData();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          res['error'] ?? 'Error al registrar abono',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Detalle de Fiado #${widget.fiadoId}',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E3A8A),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _fiado == null
          ? const Center(child: Text('No se encontró el fiado'))
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información del cliente
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
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
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Color(0xFFEFF6FF),
                                child: Icon(
                                  Icons.person,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _fiado!.clienteNombre ??
                                          'Cliente #${_fiado!.clienteId}',
                                      style: GoogleFonts.outfit(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      DateFormat(
                                        'dd/MM/yyyy HH:mm',
                                      ).format(_fiado!.fecha),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 32),
                          _buildInfoRow(
                            'Total',
                            '\$${_fiado!.totalUsd.toStringAsFixed(2)} USD',
                            Colors.blue,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Saldo Pendiente',
                            '\$${_fiado!.saldoPendiente.toStringAsFixed(2)} USD',
                            _fiado!.saldoPendiente > 0
                                ? Colors.red
                                : Colors.green,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Estado',
                            _fiado!.estado.toUpperCase(),
                            _fiado!.estado == 'pagado'
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Productos
                    Text(
                      'Productos',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_fiado!.detalles != null &&
                        _fiado!.detalles!.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          itemCount: _fiado!.detalles!.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, i) {
                            final detalle = _fiado!.detalles![i];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                detalle.productoNombre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                '${detalle.cantidad % 1 == 0 ? detalle.cantidad.toInt() : detalle.cantidad.toStringAsFixed(2)} x ${detalle.precioUnitarioBs.toStringAsFixed(2)} Bs',
                              ),
                              trailing: Text(
                                '${detalle.subtotalBs.toStringAsFixed(2)} Bs',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 24),

                    // Abonos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Abonos',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_fiado!.saldoPendiente > 0)
                          TextButton.icon(
                            onPressed: _registrarAbono,
                            icon: const Icon(Icons.add),
                            label: const Text('Registrar Abono'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_abonos.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.payments_outlined,
                                size: 48,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No hay abonos registrados',
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          itemCount: _abonos.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, i) {
                            final abono = _abonos[i];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const CircleAvatar(
                                backgroundColor: Color(0xFFDCFCE7),
                                child: Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                              title: Text(
                                '\$${abono.montoUsd.toStringAsFixed(2)} USD',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat(
                                      'dd/MM/yyyy HH:mm',
                                    ).format(abono.fecha),
                                  ),
                                  if (abono.observaciones != null)
                                    Text(
                                      abono.observaciones!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                ],
                              ),
                              trailing: Text(
                                '${abono.montoBs.toStringAsFixed(2)} Bs',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600]),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
