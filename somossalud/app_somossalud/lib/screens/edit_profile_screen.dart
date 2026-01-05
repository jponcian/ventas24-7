import 'package:flutter/material.dart';
import '../services/patient_service.dart';
import '../models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientService = PatientService();
  String? _sexo;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _fechaNacimientoController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Normalizar valor de sexo para evitar error en Dropdown
    _sexo = widget.user.sexo;
    if (_sexo == 'M') {
      _sexo = 'Masculino';
    } else if (_sexo == 'F')
      _sexo = 'Femenino';

    // Si el valor no coincide con las opciones, lo reseteamos a null
    if (_sexo != null && !['Masculino', 'Femenino'].contains(_sexo)) {
      _sexo = null;
    }

    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    // Convertir formato yyyy-MM-dd a dd/MM/yyyy para visualización
    String fechaVisual = '';
    if (widget.user.fechaNacimiento != null &&
        widget.user.fechaNacimiento!.isNotEmpty) {
      try {
        final parts = widget.user.fechaNacimiento!.split('-');
        if (parts.length == 3) {
          fechaVisual = "${parts[2]}/${parts[1]}/${parts[0]}";
        }
      } catch (e) {
        fechaVisual = widget.user.fechaNacimiento!;
      }
    }

    _fechaNacimientoController = TextEditingController(text: fechaVisual);
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text.isNotEmpty &&
        _passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Convertir dd/MM/yyyy a yyyy-MM-dd para enviar al backend
    String fechaBackend = _fechaNacimientoController.text;
    if (fechaBackend.contains('/')) {
      try {
        final parts = fechaBackend.split('/');
        if (parts.length == 3) {
          fechaBackend = "${parts[2]}-${parts[1]}-${parts[0]}";
        }
      } catch (e) {
        // En caso de error, enviar como está
      }
    }

    final data = {
      'name': _nameController.text,
      'email': _emailController.text,
      'sexo': _sexo,
      'fecha_nacimiento': fechaBackend,
    };

    if (_passwordController.text.isNotEmpty) {
      data['password'] = _passwordController.text;
      data['password_confirmation'] = _confirmPasswordController.text;
    }

    final result = await _patientService.updateProfile(data);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado correctamente'),
          backgroundColor: Color(0xFF10b981),
        ),
      );
      Navigator.pop(context, true); // Retornar true para recargar
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Error al actualizar'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF10b981)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _fechaNacimientoController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: const Color(0xFF10b981),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('Información Personal'),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Nombre Completo', Icons.person),
                validator: (v) => v!.isEmpty ? 'El nombre es requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: _inputDecoration('Correo Electrónico', Icons.email),
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    v!.isEmpty || !v.contains('@') ? 'Email inválido' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _sexo,
                decoration: _inputDecoration('Género / Sexo', Icons.wc),
                items: ['Masculino', 'Femenino'].map((String val) {
                  return DropdownMenuItem(value: val, child: Text(val));
                }).toList(),
                onChanged: (val) => setState(() => _sexo = val),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fechaNacimientoController,
                decoration: _inputDecoration(
                  'Fecha de nacimiento',
                  Icons.calendar_today,
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('Seguridad (Opcional)'),
              const SizedBox(height: 8),
              const Text(
                'Solo llena estos campos si deseas cambiar tu contraseña',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: _inputDecoration('Nueva Contraseña', Icons.lock),
                obscureText: true,
                validator: (v) => v!.isNotEmpty && v.length < 6
                    ? 'Mínimo 6 caracteres'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: _inputDecoration(
                  'Confirmar Contraseña',
                  Icons.lock_outline,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10b981),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'GUARDAR CAMBIOS',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
