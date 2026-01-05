import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/patient_service.dart';

class LabResultDetailScreen extends StatefulWidget {
  final int resultId;
  final String codigo;

  const LabResultDetailScreen({
    super.key,
    required this.resultId,
    required this.codigo,
  });

  @override
  State<LabResultDetailScreen> createState() => _LabResultDetailScreenState();
}

class _LabResultDetailScreenState extends State<LabResultDetailScreen> {
  final _patientService = PatientService();
  Map<String, dynamic>? _detalle;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() => _isLoading = true);

    final response = await _patientService.getLabResultDetail(widget.resultId);

    if (mounted) {
      setState(() {
        _detalle = response['success'] ? response['data'] : null;
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadPdf() async {
    if (_detalle == null || _detalle!['pdf_url'] == null) return;

    final Uri url = Uri.parse(_detalle!['pdf_url']);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir el PDF'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9), // Fondo AdminLTE
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0ea5e9), Color(0xFF10b981)], // Gradiente Web
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        title: Text(
          'Orden #${widget.codigo}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_detalle != null && _detalle!['pdf_url'] != null)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: _downloadPdf,
              tooltip: 'Descargar PDF',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _detalle == null
          ? const Center(child: Text('Error al cargar detalle'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 16),
                  _buildPatientInfoCard(),
                  const SizedBox(height: 24),
                  _buildExamsList(),
                  const SizedBox(height: 24),
                  if (_detalle?['observaciones'] != null) ...[
                    _buildObservationsCard(),
                    const SizedBox(height: 24),
                  ],
                  // Botón Descargar PDF grande al final
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _downloadPdf,
                      icon: const Icon(Icons.file_download),
                      label: const Text(
                        'DESCARGAR PDF CON QR',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: _getStatusColor(_detalle!['estado'] ?? ''),
            width: 3,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Estado de la Orden',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      _detalle!['estado'] ?? '',
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(
                        _detalle!['estado'] ?? '',
                      ).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    (_detalle!['estado'] ?? 'N/A').toString().toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(_detalle!['estado'] ?? ''),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: Row(
              children: const [
                Icon(Icons.person_outline, color: Color(0xFF64748B), size: 20),
                SizedBox(width: 8),
                Text(
                  'Información del Paciente',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _infoRow('Paciente', _detalle!['paciente'] ?? 'N/A'),
                const Divider(height: 20),
                _infoRow('Clínica', _detalle!['clinica'] ?? 'N/A'),
                const Divider(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _infoColumn(
                        'Fecha Muestra',
                        _formatDate(_detalle!['fecha_orden']),
                        Icons.calendar_today,
                      ),
                    ),
                    Expanded(
                      child: _infoColumn(
                        'Fecha Resultado',
                        _formatDateTime(_detalle!['fecha_resultado']),
                        Icons.event_available,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamsList() {
    final examenes = _detalle!['examenes'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.science, color: Color(0xFF64748B), size: 20),
            SizedBox(width: 8),
            Text(
              'Exámenes Solicitados',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...examenes.map((examen) => _buildExamCard(examen)),
      ],
    );
  }

  Widget _buildExamCard(Map<String, dynamic> examen) {
    final resultados = examen['resultados'] as List<dynamic>? ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del Examen
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.science,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    examen['nombre'] ?? 'Examen',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          // Tabla de Resultados
          if (resultados.isNotEmpty)
            _buildResultsTable(resultados)
          else
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Sin resultados cargados.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultsTable(List<dynamic> resultados) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth:
              MediaQuery.of(context).size.width - 64, // Ajuste con padding
        ),
        child: DataTable(
          // headingRowColor: MaterialStateProperty.all(const Color(0xFFF8FAFC)),
          columnSpacing: 20,
          horizontalMargin: 16,
          columns: const [
            DataColumn(
              label: Text(
                'Parámetro',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Valor',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Unidad',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Referencia',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                ),
              ),
            ),
          ],
          rows: resultados.map((resultado) {
            return DataRow(
              cells: [
                DataCell(
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 150),
                    child: Text(
                      resultado['parametro'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    resultado['valor'] ?? '',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                DataCell(
                  Text(
                    resultado['unidad'] ?? '-',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
                DataCell(
                  Text(
                    resultado['referencia'] ?? '-',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildObservationsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.amber.shade800,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Observaciones',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _detalle!['observaciones'],
            style: TextStyle(color: Colors.amber.shade900),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B))),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _infoColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF94A3B8), size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF334155),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '--';
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(dateStr).toLocal());
    } catch (_) {
      return dateStr;
    }
  }

  String _formatDateTime(String? dateStr) {
    if (dateStr == null) return '--';
    try {
      return DateFormat(
        'dd/MM/yyyy hh:mm a',
      ).format(DateTime.parse(dateStr).toLocal());
    } catch (_) {
      return dateStr;
    }
  }
}
