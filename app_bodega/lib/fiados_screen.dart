import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'api_service.dart';
import 'fiado_model.dart';
import 'fiado_detail_screen.dart';
import 'cliente_form_screen.dart';

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

    String mensaje = '¡Hola ${cliente.nombre}! 👋\n\n';
    mensaje += '📋 *Estado de Cuenta*\n\n';

    double totalDeuda = 0;
    for (var fiado in fiadosPendientes) {
      mensaje += '📅 ${DateFormat('dd/MM/yyyy').format(fiado.fecha)}\n';
      mensaje += '💵 Total: \$${fiado.totalUsd.toStringAsFixed(2)} USD\n';
      mensaje +=
          '💰 Saldo: \$${fiado.saldoPendiente.toStringAsFixed(2)} USD\n\n';
      totalDeuda += fiado.saldoPendiente;
    }

    mensaje += '━━━━━━━━━━━━━━━━━\n';
    mensaje += '*TOTAL ADEUDADO: \$${totalDeuda.toStringAsFixed(2)} USD*\n\n';
    mensaje += '¡Gracias por tu preferencia! 🙏';

    setState(() => _loading = true);
    final res = await _apiService.enviarNotificacionDeuda(
      telefono: cliente.telefono!,
      cliente: cliente.nombre,
      deuda: totalDeuda.toStringAsFixed(2),
      mensaje: mensaje,
    );
    setState(() => _loading = false);

    if (mounted) {
      if (res['ok'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
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

  void _verCuentaCliente(Cliente cliente) {
    final fiadosCliente = _fiados
        .where((f) => f.clienteId == cliente.id)
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClienteCuentaScreen(
          cliente: cliente,
          fiados: fiadosCliente,
          onRefresh: _loadData,
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
    final filteredClientes = (_searchQuery.isEmpty
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

class ClienteCuentaScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Cuenta: ${cliente.nombre}',
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
                      ClienteFormScreen(clienteId: cliente.id),
                ),
              );
              if (result == true) {
                onRefresh();
                Navigator.pop(
                  context,
                ); // Volver atrás ya que el nombre pudo cambiar
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
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
                  '\$${cliente.deudaTotal.toStringAsFixed(2)} USD',
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: cliente.deudaTotal > 0 ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: fiados.isEmpty
                ? const Center(child: Text('No hay registros de fiados'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: fiados.length,
                    itemBuilder: (context, i) {
                      final fiado = fiados[i];
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
                            DateFormat('dd/MM/yyyy HH:mm').format(fiado.fecha),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                builder: (context) =>
                                    FiadoDetailScreen(fiadoId: fiado.id),
                              ),
                            );
                            if (result == true) onRefresh();
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
