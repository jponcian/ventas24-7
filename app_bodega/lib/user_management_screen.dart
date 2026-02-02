import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _allNegocios = [];
  bool _loading = true;
  String _myRol = 'vendedor';

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final prefs = await SharedPreferences.getInstance();
    _myRol = prefs.getString('user_rol') ?? 'vendedor';
    await _loadUsers();
    if (_myRol == 'superadmin') {
      _allNegocios = await _apiService.getNegocios();
    }
  }

  Future<void> _loadUsers() async {
    setState(() => _loading = true);
    final users = await _apiService.getUsers();
    setState(() {
      _users = users;
      _loading = false;
    });
  }

  void _showUserForm([Map<String, dynamic>? user]) {
    final isEdit = user != null;
    final cedulaCtrl = TextEditingController(text: user?['cedula'] ?? '');
    final nameCtrl = TextEditingController(
      text: user?['nombre_completo'] ?? '',
    );
    final passCtrl = TextEditingController();
    String selectedRol = user?['rol'] ?? 'vendedor';
    bool isActive = (user?['activo']?.toString() == '1');

    // Negocios asignados (lista de IDs)
    List<int> assignedNegocios = [];
    if (user != null && user['negocios'] != null) {
      assignedNegocios = List<int>.from(
        user['negocios'].map((e) => int.parse(e.toString())),
      );
    }

    bool _saving = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Editar Usuario' : 'Nuevo Usuario'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre Completo',
                  ),
                ),
                TextField(
                  controller: cedulaCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Cédula / Usuario',
                  ),
                ),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: isEdit
                        ? 'Nueva Contraseña (opcional)'
                        : 'Contraseña',
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: selectedRol,
                  items: [
                    const DropdownMenuItem(
                      value: 'vendedor',
                      child: Text('Vendedor'),
                    ),
                    const DropdownMenuItem(
                      value: 'admin',
                      child: Text('Administrador'),
                    ),
                    if (_myRol == 'superadmin')
                      const DropdownMenuItem(
                        value: 'superadmin',
                        child: Text('Superadmin'),
                      ),
                  ],
                  onChanged: (v) => setDialogState(() => selectedRol = v!),
                  decoration: const InputDecoration(labelText: 'Rol'),
                ),
                if (_myRol == 'superadmin') ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Asignar Negocios:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._allNegocios.map((n) {
                    final int nId = int.parse(n['id'].toString());
                    return CheckboxListTile(
                      title: Text(n['nombre']),
                      value: assignedNegocios.contains(nId),
                      dense: true,
                      onChanged: (val) {
                        setDialogState(() {
                          if (val == true) {
                            assignedNegocios.add(nId);
                          } else {
                            assignedNegocios.remove(nId);
                          }
                        });
                      },
                    );
                  }).toList(),
                ],
                SwitchListTile(
                  title: const Text('Activo'),
                  value: isActive,
                  onChanged: (v) => setDialogState(() => isActive = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: _saving ? null : () => Navigator.pop(context),
              child: const Text('CANCELAR'),
            ),
            ElevatedButton(
              onPressed: _saving
                  ? null
                  : () async {
                      if (cedulaCtrl.text.isEmpty ||
                          (nameCtrl.text.isEmpty) ||
                          (!isEdit && passCtrl.text.isEmpty)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor completa los campos'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      setDialogState(() => _saving = true);
                      final userData = {
                        'action': isEdit ? 'update' : 'create',
                        'id': user?['id'],
                        'cedula': cedulaCtrl.text,
                        'nombre_completo': nameCtrl.text,
                        'rol': selectedRol,
                        'password': passCtrl.text,
                        'activo': isActive ? 1 : 0,
                        'negocios': assignedNegocios,
                      };
                      final res = await _apiService.saveUser(userData);
                      if (mounted) {
                        if (res['ok'] == true) {
                          Navigator.pop(context);
                          _loadUsers();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Usuario procesado correctamente'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          setDialogState(() => _saving = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${res['error']}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEdit ? 'GUARDAR' : 'CREAR'),
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
          'Gestión de Usuarios',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _users.length,
              itemBuilder: (context, i) {
                final u = _users[i];
                final bool isSuper = u['rol'] == 'superadmin';
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: u['activo'].toString() == '1'
                          ? Colors.blue[50]
                          : Colors.grey[200],
                      child: Icon(
                        Icons.person,
                        color: u['activo'].toString() == '1'
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ),
                    title: Text(
                      u['nombre_completo'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${u['cedula']} • ${u['rol'].toString().toUpperCase()}',
                    ),
                    trailing: isSuper && _myRol != 'superadmin'
                        ? const Icon(Icons.verified, color: Colors.indigo)
                        : IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showUserForm(u),
                          ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserForm(),
        backgroundColor: const Color(0xFF1E3A8A),
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}
