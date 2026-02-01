import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
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
                  items: const [
                    DropdownMenuItem(
                      value: 'vendedor',
                      child: Text('Vendedor'),
                    ),
                    DropdownMenuItem(
                      value: 'admin',
                      child: Text('Administrador'),
                    ),
                    DropdownMenuItem(
                      value: 'superadmin',
                      child: Text('Superadmin'),
                    ),
                  ],
                  onChanged: (v) => setDialogState(() => selectedRol = v!),
                  decoration: const InputDecoration(labelText: 'Rol'),
                ),
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
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCELAR'),
            ),
            ElevatedButton(
              onPressed: () async {
                final userData = {
                  'action': isEdit ? 'update' : 'create',
                  'id': user?['id'],
                  'cedula': cedulaCtrl.text,
                  'nombre_completo': nameCtrl.text,
                  'rol': selectedRol,
                  'password': passCtrl.text,
                  'activo': isActive ? 1 : 0,
                };
                final ok = await _apiService.saveUser(userData);
                if (ok) {
                  Navigator.pop(context);
                  _loadUsers();
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
                    trailing: isSuper
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
