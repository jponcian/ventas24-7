import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _history = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _loading = true);
    final data = await _apiService.getHistorialCompras();
    if (mounted) {
      setState(() {
        _history = data;
        _loading = false;
      });
    }
  }

  Future<void> _anular(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Anular Compra'),
        content: const Text(
          '¿Estás seguro? Esto revertirá el stock de todos los productos incluidos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Anular'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _loading = true);
      final ok = await _apiService.anularCompra(id);
      if (mounted) {
        if (ok) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Compra anulada'),
              backgroundColor: Colors.green,
            ),
          );
          _loadHistory();
        } else {
          setState(() => _loading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al anular'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Historial de Compras',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
          ? const Center(child: Text('No hay compras registradas'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                final estado = item['estado'] ?? 'completada';
                final isAnulada = estado == 'anulada';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: isAnulada ? Colors.grey[200] : Colors.white,
                  child: ListTile(
                    title: Text('Compra #${item['id']} - ${item['fecha']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Prov: ${item['proveedor_nombre'] ?? 'General'}'),
                        Text(
                          'Total: ${double.tryParse(item['total'].toString())?.toStringAsFixed(2) ?? '0.00'} ${item['moneda']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isAnulada ? Colors.grey : Colors.green[800],
                          ),
                        ),
                        if (isAnulada)
                          const Text(
                            'ANULADA',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                    trailing: isAnulada
                        ? const Icon(Icons.block, color: Colors.grey)
                        : IconButton(
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                            onPressed: () =>
                                _anular(int.parse(item['id'].toString())),
                          ),
                  ),
                );
              },
            ),
    );
  }
}
