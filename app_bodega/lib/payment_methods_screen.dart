import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'metodo_pago_model.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final ApiService _apiService = ApiService();
  List<MetodoPago> _metodos = [];
  bool _loading = true;
  int? _defaultMetodoId;

  @override
  void initState() {
    super.initState();
    _loadMetodos();
    _loadDefaultMetodo();
  }

  Future<void> _loadDefaultMetodo() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _defaultMetodoId = prefs.getInt('default_metodo_id');
      });
    }
  }

  Future<void> _setDefaultMetodo(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('default_metodo_id', id);
    setState(() {
      _defaultMetodoId = id;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Método de pago predeterminado actualizado'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _loadMetodos() async {
    setState(() => _loading = true);
    final list = await _apiService.getMetodosPago();
    setState(() {
      _metodos = list;
      _loading = false;
    });
  }

  void _showForm([MetodoPago? metodo]) {
    final nombreController = TextEditingController(text: metodo?.nombre ?? '');
    bool requiereReferencia = metodo?.requiereReferencia ?? false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(metodo == null ? 'Nuevo Método' : 'Editar Método'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre (ej: Pago Móvil)',
                ),
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: const Text('Requiere número de referencia'),
                value: requiereReferencia,
                onChanged: (val) =>
                    setDialogState(() => requiereReferencia = val ?? false),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCELAR'),
            ),
            FilledButton(
              onPressed: () async {
                if (nombreController.text.isEmpty) return;
                final data = {
                  'id': metodo?.id,
                  'nombre': nombreController.text,
                  'requiere_referencia': requiereReferencia ? 1 : 0,
                };
                final res = await _apiService.saveMetodoPago(data);
                if (res['ok'] == true) {
                  Navigator.pop(context);
                  _loadMetodos();
                }
              },
              child: const Text('GUARDAR'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Formas de Pago',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _metodos.length,
              itemBuilder: (context, i) {
                final m = _metodos[i];
                final bool isDefault =
                    m.nombre == 'Efectivo' || m.nombre == 'Crédito';
                return Card(
                  child: ListTile(
                    title: Text(
                      m.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      m.requiereReferencia
                          ? 'Requiere referencia'
                          : 'No requiere referencia',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            _defaultMetodoId == m.id
                                ? Icons.star
                                : Icons.star_border,
                            color: _defaultMetodoId == m.id
                                ? Colors.amber
                                : Colors.grey,
                          ),
                          tooltip: 'Establecer como predeterminado',
                          onPressed: () => _setDefaultMetodo(m.id),
                        ),
                        if (!isDefault) ...[
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showForm(m),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Eliminar'),
                                  content: const Text(
                                    '¿Desea eliminar esta forma de pago?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: const Text('NO'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('SÍ'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await _apiService.deleteMetodoPago(m.id);
                                _loadMetodos();
                              }
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        backgroundColor: const Color(0xFF1E3A8A),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
