import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';

class BusinessConfigScreen extends StatefulWidget {
  const BusinessConfigScreen({super.key});

  @override
  State<BusinessConfigScreen> createState() => _BusinessConfigScreenState();
}

class _BusinessConfigScreenState extends State<BusinessConfigScreen> {
  final ApiService _apiService = ApiService();
  final _nameCtrl = TextEditingController();
  final _rifCtrl = TextEditingController();
  bool _loading = true;
  int? _negocioId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final nid = await _apiService.getNegocioId();
    final negocios = await _apiService.getNegocios();

    // Buscar la data de mi negocio específico
    final myNeg = negocios.firstWhere((n) => n['id'] == nid, orElse: () => {});

    if (myNeg.isNotEmpty) {
      _negocioId = nid;
      _nameCtrl.text = myNeg['nombre'] ?? '';
      _rifCtrl.text = myNeg['rif'] ?? '';
    }

    setState(() => _loading = false);
  }

  Future<void> _save() async {
    if (_negocioId == null) return;

    setState(() => _loading = true);
    final result = await _apiService.saveNegocio({
      'action': 'update',
      'id': _negocioId,
      'nombre': _nameCtrl.text,
      'rif': _rifCtrl.text,
      'activo': 1, // Mantener activo si está configurándolo
    });

    setState(() => _loading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ? 'Configuración guardada' : 'Error al guardar'),
          backgroundColor: result ? Colors.green : Colors.red,
        ),
      );
      if (result) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Configuración del Negocio',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Datos Generales',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E3A8A),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Nombre del Negocio',
                            prefixIcon: Icon(Icons.business),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _rifCtrl,
                          decoration: const InputDecoration(
                            labelText: 'RIF / Identificación',
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'GUARDAR CAMBIOS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
