import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'api_service.dart';
import 'fiado_model.dart';
import 'fiado_detail_screen.dart';
import 'cliente_form_screen.dart';
import 'utils.dart';

class FiadosScreen extends StatefulWidget {
  const FiadosScreen({super.key});

  @override
  State<FiadosScreen> createState() => _FiadosScreenState();
}

class _FiadosScreenState extends State<FiadosScreen> {
  final ApiService _apiService = ApiService();
  List<Cliente> _clientes = [];
  List<Fiado> _fiados = [];
  bool _loading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final clientes = await _apiService.getClientes();
    final fiados = await _apiService.getFiados();
    setState(() {
      _clientes = clientes;
      _fiados = fiados;
      _loading = false;
    });
  }

  Future<void> _enviarEstadoCuentaWhatsApp(Cliente cliente) async {
    if (cliente.telefono == null || cliente.telefono!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este cliente no tiene teléfono registrado'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final fiadosPendientes = _fiados
        .where(
          (f) =>
              f.clienteId == cliente.id &&
              f.estado == 'pendiente' &&
              f.saldoPendiente > 0,
        )
        .toList();

    if (fiadosPendientes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este cliente no tiene deudas pendientes'),
          backgroundColor: Colors.blue,
        ),
      );
      return;
    }

    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enviar Notificación'),
        content: Text(
          '¿Deseas enviar el estado de cuenta a ${cliente.nombre} por WhatsApp?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCELAR'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF25D366), // Color WhatsApp
            ),
            child: const Text('ENVIAR'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    double totalDeuda = 0;
    for (var f in fiadosPendientes) totalDeuda += f.saldoPendiente;

    // Construimos el mensaje simplificado: Saludo, Total, Invitación y Despedida.
    String temporal = "¡Hola, *${cliente.nombre}*! 😊\n\n";
    temporal += "Te escribimos de parte de *Ventas 24/7* para enviarte tu estado de cuenta actualizado.\n\n";
    
    temporal += "*Tu deuda total es:* ✅ *$totalDeuda USD*\n\n";
    
    temporal += "Te invitamos a pasar por la tienda cuando gustes para ponerte al día. Valoramos mucho tu confianza en nosotros. 🙌\n\n";
    temporal += "¡Que tengas un excelente día! ✨";
    
    String mensaje = temporal;

    setState(() => _loading = true);
    final res = await _apiService.enviarNotificacionDeuda(
      telefono: cliente.telefono!,
      cliente: cliente.nombre,
      deuda: totalDeuda.toStringAsFixed(2),
      mensaje: mensaje,
    );
          const SnackBar(
            content: Text('Notificación enviada por WhatsApp correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['error'] ?? 'Error al enviar notificación'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _verCuentaCliente(Cliente cliente) async {
    final fiadosCliente = _fiados
        .where((f) => f.clienteId == cliente.id)
        .toList();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClienteCuentaScreen(
          cliente: cliente,
          fiados: fiadosCliente,
          onRefresh: _loadData,
        ),
      ),
    );
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gestión de Fiados',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E3A8A),
              ),
            ),
            Text(
              'Créditos y Clientes',
              style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _buildClientesTab(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ClienteFormScreen()),
          );
          if (result == true) _loadData();
        },
        backgroundColor: const Color(0xFF1E3A8A),
        icon: const Icon(Icons.person_add_alt_1),
        label: Text(
          'Nuevo Cliente',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildClientesTab() {
    final filteredClientes =
        (_searchQuery.isEmpty
                ? _clientes
                : _clientes
                      .where(
                        (c) =>
                            c.nombre.toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            ) ||
                            (c.cedula?.contains(_searchQuery) ?? false) ||
                            (c.telefono?.contains(_searchQuery) ?? false),
                      )
                      .toList())
            .where((c) => c.deudaTotal > 0)
            .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Buscar cliente...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: filteredClientes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay clientes registrados',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 0,
                    bottom: 80,
                  ),
                  itemCount: filteredClientes.length,
                  itemBuilder: (context, i) {
                    final cliente = filteredClientes[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: cliente.deudaTotal > 0
                              ? Colors.orange[100]
                              : Colors.green[100],
                          child: Icon(
                            Icons.person,
                            color: cliente.deudaTotal > 0
                                ? Colors.orange[700]
                                : Colors.green[700],
                          ),
                        ),
                        title: Text(
                          cliente.nombre,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (cliente.cedula != null)
                              Text('CI: ${cliente.cedula}'),
                            if (cliente.telefono != null)
                              Text('Tel: ${cliente.telefono}'),
                            const SizedBox(height: 4),
                            Text(
                              'Deuda: \$${cliente.deudaTotal.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: cliente.deudaTotal > 0
                                    ? Colors.red[700]
                                    : Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (cliente.telefono != null &&
                                cliente.deudaTotal > 0)
                              IconButton(
                                icon: const Icon(
                                  Icons.chat_bubble_outline,
                                  color: Color(0xFF25D366),
                                ),
                                onPressed: () =>
                                    _enviarEstadoCuentaWhatsApp(cliente),
                                tooltip: 'Enviar estado de cuenta',
                              ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: () => _verCuentaCliente(cliente),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class ClienteCuentaScreen extends StatefulWidget {
  final Cliente cliente;
  final List<Fiado> fiados;
  final VoidCallback onRefresh;

  const ClienteCuentaScreen({
    super.key,
    required this.cliente,
    required this.fiados,
    required this.onRefresh,
  });

  @override
  State<ClienteCuentaScreen> createState() => _ClienteCuentaScreenState();
}

class _ClienteCuentaScreenState extends State<ClienteCuentaScreen> {
  final ApiService _apiService = ApiService();
  late Cliente _cliente;
  late List<Fiado> _fiados;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _cliente = widget.cliente;
    _fiados = widget.fiados;
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final clienteActualizado = await _apiService.getCliente(_cliente.id);
      final fiadosActualizados = await _apiService.getFiados();
      final misFiados = fiadosActualizados
          .where((f) => f.clienteId == _cliente.id)
          .toList();

      if (mounted) {
        setState(() {
          if (clienteActualizado != null) _cliente = clienteActualizado;
          _fiados = misFiados;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
    widget.onRefresh();
  }

  Future<void> _registrarAbonoGeneral() async {
    final montoCtrl = TextEditingController();
    final obsCtrl = TextEditingController();
    String moneda = 'USD';

    await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Registrar Abono General'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'El abono se distribuirá automáticamente entre las deudas más antiguas.',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: montoCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [SlidingDecimalFormatter()],
                decoration: InputDecoration(
                  labelText: 'Monto total a abonar',
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
                'Deuda total actual: \$${_cliente.deudaTotal.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
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
                if (monto <= 0) return;

                double tasa = await _apiService.getTasa();
                if (tasa <= 0) tasa = 1.0;

                double montoUsdEnviado = moneda == 'USD' ? monto : monto / tasa;

                if (montoUsdEnviado > _cliente.deudaTotal + 0.01) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'El monto (\$$montoUsdEnviado USD) supera la deuda total (\$$_cliente.deudaTotal USD)',
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                Navigator.pop(context, true);

                double montoBs = moneda == 'BS' ? monto : monto * tasa;
                double montoUsdEnviadoFinal = moneda == 'USD'
                    ? monto
                    : monto / tasa;

                setState(() => _loading = true);
                try {
                  final res = await _apiService.registrarAbono({
                    'cliente_id': _cliente.id,
                    'monto_bs': montoBs,
                    'monto_usd': montoUsdEnviadoFinal,
                    'observaciones': obsCtrl.text.trim().isEmpty
                        ? 'Abono general'
                        : obsCtrl.text.trim(),
                  });

                  if (res['ok'] == true) {
                    await _loadData();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Abono general registrado y aplicado correctamente',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // Si ya no tiene deuda, sugerimos volver
                      if (_cliente.deudaTotal <= 0.01) {
                        Future.delayed(const Duration(seconds: 1), () {
                          if (mounted && Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        });
                      }
                    }
                  } else {
                    if (mounted) {
                      setState(() => _loading = false);
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
                } catch (e) {
                  if (mounted) {
                    setState(() => _loading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error de conexión: $e'),
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
        title: Text(
          'Cuenta: ${_cliente.nombre}',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E3A8A),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar Cliente',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ClienteFormScreen(clienteId: _cliente.id),
                ),
              );
              if (result == true) {
                _loadData();
              }
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'DEUDA TOTAL',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${_cliente.deudaTotal.toStringAsFixed(2)} USD',
                            style: GoogleFonts.outfit(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: _cliente.deudaTotal > 0
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                          if (_cliente.deudaTotal > 0) ...[
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: _registrarAbonoGeneral,
                              icon: const Icon(Icons.add_card),
                              label: const Text('ABONO GENERAL'),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A8A),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  _fiados.isEmpty
                      ? SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 64,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No hay registros de fiados pendientes',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.all(16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((context, i) {
                              final fiado = _fiados[i];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  leading: CircleAvatar(
                                    backgroundColor: const Color(0xFFEFF6FF),
                                    child: const Icon(
                                      Icons.receipt,
                                      color: Color(0xFF1E3A8A),
                                    ),
                                  ),
                                  title: Text(
                                    DateFormat(
                                      'dd/MM/yyyy HH:mm',
                                    ).format(fiado.fecha),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        'Total: \$${fiado.totalUsd.toStringAsFixed(2)}',
                                      ),
                                      Text(
                                        'Pendiente: \$${fiado.saldoPendiente.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: fiado.saldoPendiente > 0
                                              ? Colors.red[700]
                                              : Colors.green[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FiadoDetailScreen(
                                          fiadoId: fiado.id,
                                        ),
                                      ),
                                    );
                                    if (result == true) _loadData();
                                  },
                                ),
                              );
                            }, childCount: _fiados.length),
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
