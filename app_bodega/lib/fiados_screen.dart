import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'api_service.dart';
import 'cliente_form_screen.dart';
import 'cliente_model.dart';
import 'fiado_model.dart';
import 'fiado_detail_screen.dart';
import 'cliente_cuenta_screen.dart';

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
    try {
      final clientesData = await _apiService.getClientes();
      final fiadosData = await _apiService.getFiados();
      setState(() {
        _clientes = clientesData;
        _fiados = fiadosData;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar datos: $e')),
        );
      }
    }
  }

  Future<void> _enviarEstadoCuentaWhatsApp(Cliente cliente) async {
    if (cliente.telefono == null || cliente.telefono!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El cliente no tiene teléfono registrado')),
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
              backgroundColor: const Color(0xFF25D366),
            ),
            child: const Text('ENVIAR'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    double totalDeuda = 0;
    for (var f in fiadosPendientes) totalDeuda += f.saldoPendiente;

    String temporal = "¡Hola, *${cliente.nombre}*! 😊\n\n";
    temporal += "Te escribimos de parte de *Ventas 24/7* para enviarte tu estado de cuenta actualizado.\n\n";
    temporal += "*Tu deuda total es:* ✅ *\$${totalDeuda.toStringAsFixed(2)} USD*\n\n";
    temporal += "Te invitamos a pasar por la tienda cuando gustes para ponerte al día. Valoramos mucho tu confianza en nosotros. 🙌\n\n";
    temporal += "¡Que tengas un excelente día! ✨";

    setState(() => _loading = true);
    try {
      final res = await _apiService.enviarNotificacionDeuda(
        telefono: cliente.telefono!,
        cliente: cliente.nombre,
        deuda: totalDeuda.toStringAsFixed(2),
        mensaje: temporal,
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
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _verCuentaCliente(Cliente cliente) async {
    final fiadosCliente = _fiados.where((f) => f.clienteId == cliente.id).toList();

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
    final filteredClientes = (_searchQuery.isEmpty
            ? _clientes
            : _clientes.where((c) =>
                c.nombre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                (c.cedula?.contains(_searchQuery) ?? false) ||
                (c.telefono?.contains(_searchQuery) ?? false)))
        .toList();

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
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar cliente...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                Expanded(
                  child: filteredClientes.isEmpty
                      ? const Center(child: Text('No se encontraron clientes'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredClientes.length,
                          itemBuilder: (context, index) {
                            final cliente = filteredClientes[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: cliente.deudaTotal > 0
                                      ? Colors.red[50]
                                      : Colors.green[50],
                                  child: Icon(
                                    Icons.person,
                                    color: cliente.deudaTotal > 0
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                                title: Text(
                                  cliente.nombre,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Deuda: \$${cliente.deudaTotal.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: cliente.deudaTotal > 0
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (cliente.deudaTotal > 0)
                                      IconButton(
                                        icon: const Icon(Icons.send, color: Colors.blue),
                                        onPressed: () => _enviarEstadoCuentaWhatsApp(cliente),
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
            ),
    );
  }
}
