import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';

class BusinessManagementScreen extends StatefulWidget {
  const BusinessManagementScreen({super.key});

  @override
  State<BusinessManagementScreen> createState() =>
      _BusinessManagementScreenState();
}

class _BusinessManagementScreenState extends State<BusinessManagementScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _negocios = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadNegocios();
  }

  Future<void> _loadNegocios() async {
    setState(() => _loading = true);
    final list = await _apiService.getNegocios();
    setState(() {
      _negocios = list;
      _loading = false;
    });
  }

  void _showForm([Map<String, dynamic>? negocio]) {
    final isEdit = negocio != null;
    final nameCtrl = TextEditingController(text: negocio?['nombre'] ?? '');
    final rifCtrl = TextEditingController(text: negocio?['rif'] ?? '');
    bool isActive = (negocio?['activo']?.toString() != '0');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Editar Negocio' : 'Nuevo Negocio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Negocio',
                ),
              ),
              TextField(
                controller: rifCtrl,
                decoration: const InputDecoration(
                  labelText: 'RIF / Identificación',
                ),
              ),
              SwitchListTile(
                title: const Text('Activo'),
                value: isActive,
                onChanged: (v) => setDialogState(() => isActive = v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCELAR'),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await _apiService.saveNegocio({
                  'action': isEdit ? 'update' : 'create',
                  'id': negocio?['id'],
                  'nombre': nameCtrl.text,
                  'rif': rifCtrl.text,
                  'activo': isActive ? 1 : 0,
                });
                if (result) {
                  Navigator.pop(context);
                  _loadNegocios();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Operación exitosa')),
                  );
                }
              },
              child: Text(isEdit ? 'GUARDAR' : 'CREAR'),
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
          'Gestión de Negocios',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _negocios.length,
              itemBuilder: (context, i) {
                final n = _negocios[i];
                final bool active = n['activo'].toString() != '0';
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: active
                          ? Colors.blue[50]
                          : Colors.grey[200],
                      child: Icon(
                        Icons.business,
                        color: active ? Colors.blue : Colors.grey,
                      ),
                    ),
                    title: Text(
                      n['nombre'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('RIF: ${n['rif'] ?? "N/A"}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(n),
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
