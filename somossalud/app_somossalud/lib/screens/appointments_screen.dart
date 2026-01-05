import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/patient_service.dart';
import 'new_appointment_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final _patientService = PatientService();
  List<dynamic> _citas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() => _isLoading = true);

    final response = await _patientService.getAppointments();

    if (mounted) {
      setState(() {
        _citas = response['success'] ? response['data'] : [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0ea5e9),
        foregroundColor: Colors.white,
        title: const Text(
          'Mis Citas Médicas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _citas.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tienes citas registradas',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadAppointments,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _citas.length,
                itemBuilder: (context, index) {
                  final cita = _citas[index];
                  return _AppointmentCard(cita: cita);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewAppointmentScreen(),
            ),
          );
          if (result == true) {
            _loadAppointments();
          }
        },
        backgroundColor: const Color(0xFF0ea5e9),
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Nueva Cita'),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> cita;

  const _AppointmentCard({required this.cita});

  Color _getStatusColor() {
    if (cita['concluida'] == true) return Colors.grey;

    final estado = cita['estado']?.toString().toLowerCase() ?? 'pendiente';
    switch (estado) {
      case 'confirmada':
        return const Color(0xFF10b981);
      case 'cancelada':
        return Colors.red;
      default:
        return const Color(0xFF0ea5e9);
    }
  }

  String _getStatusText() {
    if (cita['concluida'] == true) return 'Concluida';

    final estado = cita['estado']?.toString() ?? 'Pendiente';
    return estado[0].toUpperCase() + estado.substring(1);
  }

  void _showDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalle de la Cita'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (cita['diagnostico'] != null) ...[
                const Text(
                  'Diagnóstico:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(cita['diagnostico']),
                const SizedBox(height: 12),
              ],
              if (cita['observaciones'] != null) ...[
                const Text(
                  'Observaciones:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(cita['observaciones']),
                const SizedBox(height: 12),
              ],
              if (cita['tratamiento'] != null) ...[
                const Text(
                  'Tratamiento:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(cita['tratamiento']),
                const SizedBox(height: 12),
              ],
              if (cita['motivo'] != null) ...[
                const Text(
                  'Motivo de consulta:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(cita['motivo']),
              ],
              if (cita['diagnostico'] == null &&
                  cita['observaciones'] == null &&
                  cita['tratamiento'] == null &&
                  cita['motivo'] == null)
                const Text(
                  'No hay información adicional disponible para esta cita.',
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _viewRecipe(BuildContext context) async {
    final recipeUrl = cita['recipe_url'];
    if (recipeUrl != null && recipeUrl.toString().isNotEmpty) {
      final uri = Uri.parse(recipeUrl);
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo abrir el récipe')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay récipe digital disponible para esta cita'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final fechaCita = cita['fecha'] != null
        ? DateTime.parse(cita['fecha'])
        : null;

    final isPast = fechaCita != null && fechaCita.isBefore(DateTime.now());

    return Opacity(
      opacity: isPast ? 0.7 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isPast ? const Color(0xFFF8FAFC) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isPast
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
          border: isPast ? Border.all(color: Colors.grey.shade300) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.calendar_month,
                      color: _getStatusColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cita['especialista'] ?? 'Doctor no asignado',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cita['especialidad'] ?? 'Consulta General',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    fechaCita != null
                        ? DateFormat('dd/MM/yyyy', 'es_ES').format(fechaCita)
                        : 'Fecha no disponible',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    cita['hora'] ?? 'Hora no especificada',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      cita['clinica'] ?? 'Clínica no especificada',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              if (cita['motivo'] != null &&
                  cita['motivo'].toString().isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.notes, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          cita['motivo'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (cita['concluida'] == true) ...[
                const SizedBox(height: 16),
                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showDetailDialog(context),
                        icon: const Icon(Icons.description_outlined, size: 18),
                        label: const Text('Ver Detalle'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0ea5e9),
                          side: const BorderSide(color: Color(0xFF0ea5e9)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _viewRecipe(context),
                        icon: const Icon(
                          Icons.medical_services_outlined,
                          size: 18,
                        ),
                        label: const Text('Ver Récipes'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10b981),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
