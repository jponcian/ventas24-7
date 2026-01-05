import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/patient_service.dart';

class NewAppointmentScreen extends StatefulWidget {
  const NewAppointmentScreen({super.key});

  @override
  State<NewAppointmentScreen> createState() => _NewAppointmentScreenState();
}

class _NewAppointmentScreenState extends State<NewAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientService = PatientService();

  bool _isLoading = false;
  List<dynamic> _specialties = [];
  List<dynamic> _doctors = [];
  List<dynamic> _availableSlots = [];

  int? _selectedSpecialtyId;
  int? _selectedDoctorId;
  DateTime? _selectedDate;
  String? _selectedSlot; // Y-m-d H:i

  final _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSpecialties();
  }

  Future<void> _loadSpecialties() async {
    setState(() => _isLoading = true);
    final response = await _patientService.getSpecialties();
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (response['success']) {
          _specialties = response['data'];
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response['message'] ?? 'Error al cargar especialidades',
              ),
            ),
          );
        }
      });
    }
  }

  Future<void> _loadDoctors(int specialtyId) async {
    setState(() => _isLoading = true);
    final response = await _patientService.getDoctors(specialtyId);
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (response['success']) {
          _doctors = response['data'];
        } else {
          _doctors = [];
        }
        // Reset selections dependent on doctor
        _selectedDoctorId = null;
        _selectedDate = null;
        _selectedSlot = null;
        _availableSlots = [];
      });
    }
  }

  Future<void> _loadSlots() async {
    if (_selectedDoctorId == null || _selectedDate == null) return;

    setState(() => _isLoading = true);
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate!);

    final response = await _patientService.getAvailableSlots(
      _selectedDoctorId!,
      dateStr,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (response['success']) {
          _availableSlots = response['data'];
        } else {
          _availableSlots = [];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Error al cargar horarios'),
            ),
          );
        }
        _selectedSlot = null;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    if (_selectedDoctorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero selecciona un especialista')),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0ea5e9),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _availableSlots = [];
        _selectedSlot = null;
      });
      _loadSlots();
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDoctorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un especialista')),
      );
      return;
    }
    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecciona una fecha')));
      return;
    }
    if (_selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un horario disponible')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final appointmentData = {
      'especialidad_id': _selectedSpecialtyId,
      'doctor_id': _selectedDoctorId,
      'fecha_hora':
          _selectedSlot, // Enviamos el valor exacto del slot (Y-m-d H:i)
      'motivo': _reasonController.text,
    };

    final result = await _patientService.createAppointment(appointmentData);

    if (mounted) {
      setState(() => _isLoading = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Cita agendada con éxito'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Error al agendar cita'),
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
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Agendar Cita',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading && _specialties.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Especialidad
                    const Text(
                      'Especialidad',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      initialValue: _selectedSpecialtyId,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      hint: const Text('Selecciona una especialidad'),
                      items: _specialties.map<DropdownMenuItem<int>>((item) {
                        return DropdownMenuItem<int>(
                          value: item['id'],
                          child: Text(item['nombre'] ?? 'Sin nombre'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != _selectedSpecialtyId) {
                          setState(() {
                            _selectedSpecialtyId = value;
                          });
                          if (value != null) _loadDoctors(value);
                        }
                      },
                      validator: (value) => value == null ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 20),

                    // Doctor (Obligatorio ahora)
                    if (_selectedSpecialtyId != null) ...[
                      const Text(
                        'Especialista',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _doctors.isEmpty && !_isLoading
                          ? const Text(
                              'No hay especialistas disponibles para esta especialidad.',
                              style: TextStyle(color: Colors.red),
                            )
                          : DropdownButtonFormField<int>(
                              initialValue: _selectedDoctorId,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              hint: const Text('Selecciona un especialista'),
                              items: _doctors.map<DropdownMenuItem<int>>((
                                item,
                              ) {
                                return DropdownMenuItem<int>(
                                  value: item['id'],
                                  child: Text(item['name'] ?? 'Sin nombre'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedDoctorId = value;
                                  _selectedDate = null;
                                  _availableSlots = [];
                                  _selectedSlot = null;
                                });
                              },
                              validator: (value) =>
                                  value == null ? 'Requerido' : null,
                            ),
                      const SizedBox(height: 20),
                    ],

                    // Fecha
                    if (_selectedDoctorId != null) ...[
                      const Text(
                        'Fecha',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: Color(0xFF64748B),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _selectedDate == null
                                    ? 'Seleccionar fecha'
                                    : DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(_selectedDate!),
                                style: TextStyle(
                                  color: _selectedDate == null
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Horarios (Grid de slots)
                    if (_selectedDate != null) ...[
                      const Text(
                        'Horario Disponible',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _isLoading && _availableSlots.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : _availableSlots.isEmpty
                          ? Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'No hay horarios disponibles para esta fecha.',
                                style: TextStyle(color: Colors.orange),
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 2.5,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                              itemCount: _availableSlots.length,
                              itemBuilder: (context, index) {
                                final slot = _availableSlots[index];
                                final isSelected =
                                    _selectedSlot == slot['valor'];
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedSlot = slot['valor'];
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF0ea5e9)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: isSelected
                                          ? null
                                          : Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      slot['hora_am_pm'] ?? slot['hora'],
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF1E293B),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                      const SizedBox(height: 20),
                    ],

                    // Motivo
                    const Text(
                      'Motivo de la consulta',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _reasonController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintText:
                            'Describe brevemente tus síntomas o razón de la visita',
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el motivo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0ea5e9),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Confirmar Cita',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
