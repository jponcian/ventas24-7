import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api_service.dart';
import 'fiado_model.dart';
import 'fiado_detail_screen.dart';
import 'nuevo_fiado_screen.dart';
import 'cliente_form_screen.dart';

class FiadosScreen extends StatefulWidget {
  const FiadosScreen({super.key});

  @override
  State<FiadosScreen> createState() => _FiadosScreenState();
}

class _FiadosScreenState extends State<FiadosScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  late TabController _tabController;
  List<Cliente> _clientes = [];
  List<Fiado> _fiados = [];
  bool _loading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

    // Obtener fiados pendientes del cliente
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

    // Construir mensaje
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

    // Limpiar número de teléfono
    String telefono = cliente.telefono!.replaceAll(RegExp(r'[^\d]'), '');
    if (!telefono.startsWith('58')) {
      telefono = '58$telefono';
    }

    final url = Uri.parse(
      'https://wa.me/$telefono?text=${Uri.encodeComponent(mensaje)}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir WhatsApp'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1E3A8A),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF1E3A8A),
          tabs: const [
            Tab(text: 'Clientes'),
            Tab(text: 'Fiados'),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [_buildClientesTab(), _buildFiadosTab()],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_tabController.index == 0) {
            // Agregar cliente
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ClienteFormScreen(),
              ),
            );
            if (result == true) _loadData();
          } else {
            // Nuevo fiado
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NuevoFiadoScreen()),
            );
            if (result == true) _loadData();
          }
        },
        backgroundColor: const Color(0xFF1E3A8A),
        icon: const Icon(Icons.add),
        label: Text(
          _tabController.index == 0 ? 'Nuevo Cliente' : 'Nuevo Fiado',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildClientesTab() {
    final filteredClientes = _searchQuery.isEmpty
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
              .toList();

    return Column(
      children: [
        // Buscador
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

        // Lista de clientes
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                icon: Icon(
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
                        onTap: () {
                          // TODO: Ver detalle del cliente
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFiadosTab() {
    final fiadosPendientes = _fiados
        .where((f) => f.estado == 'pendiente')
        .toList();

    return fiadosPendientes.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 80,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'No hay fiados pendientes',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: fiadosPendientes.length,
            itemBuilder: (context, i) {
              final fiado = fiadosPendientes[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFEFF6FF),
                    child: const Icon(Icons.receipt, color: Color(0xFF1E3A8A)),
                  ),
                  title: Text(
                    fiado.clienteNombre ?? 'Cliente #${fiado.clienteId}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat('dd/MM/yyyy HH:mm').format(fiado.fecha)),
                      const SizedBox(height: 4),
                      Text(
                        'Total: \$${fiado.totalUsd.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Pendiente: \$${fiado.saldoPendiente.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
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
                    if (result == true) _loadData();
                  },
                ),
              );
            },
          );
  }
}
