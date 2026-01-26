import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'utils.dart';
import 'api_service.dart';

class CalcScreen extends StatefulWidget {
  final double tasa;

  const CalcScreen({super.key, required this.tasa});

  @override
  State<CalcScreen> createState() => _CalcScreenState();
}

class _CalcScreenState extends State<CalcScreen> {
  late TextEditingController _usdCtrl;
  late TextEditingController _bsCtrl;
  final FocusNode _usdFocus = FocusNode();
  final FocusNode _bsFocus = FocusNode();
  final ApiService _apiService = ApiService();

  late double _tasaActual;
  DateTime _selectedDate = DateTime.now();
  bool _isLoadingRate = false;

  @override
  void initState() {
    super.initState();
    _tasaActual = widget.tasa;
    _usdCtrl = TextEditingController(text: '1.00');
    _bsCtrl = TextEditingController(text: _tasaActual.toStringAsFixed(2));

    _usdFocus.addListener(() {
      if (_usdFocus.hasFocus) {
        _selectAll(_usdCtrl);
      }
    });
    _bsFocus.addListener(() {
      if (_bsFocus.hasFocus) {
        _selectAll(_bsCtrl);
      }
    });
  }

  @override
  void dispose() {
    _usdCtrl.dispose();
    _bsCtrl.dispose();
    _usdFocus.dispose();
    _bsFocus.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _isLoadingRate = true;
      });

      try {
        String fechaStr = DateFormat('yyyy-MM-dd').format(picked);
        double nuevaTasa = await _apiService.getTasa(fecha: fechaStr);
        if (nuevaTasa > 0) {
          setState(() {
            _tasaActual = nuevaTasa;
            _onUsdChanged(_usdCtrl.text);
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error obteniendo tasa: $e')));
      } finally {
        setState(() => _isLoadingRate = false);
      }
    }
  }

  void _onUsdChanged(String value) {
    if (value.isEmpty) return;
    double? usd = double.tryParse(value);
    if (usd != null) {
      double bs = usd * _tasaActual;
      String newBs = bs.toStringAsFixed(2);
      if (_bsCtrl.text != newBs) {
        _bsCtrl.text = newBs;
      }
    }
  }

  void _onBsChanged(String value) {
    if (value.isEmpty) return;
    double? bs = double.tryParse(value);
    if (bs != null && _tasaActual > 0) {
      double usd = bs / _tasaActual;
      String newUsd = usd.toStringAsFixed(2);
      if (_usdCtrl.text != newUsd) {
        _usdCtrl.text = newUsd;
      }
    }
  }

  void _selectAll(TextEditingController ctrl) {
    Future.delayed(Duration.zero, () {
      ctrl.selection = TextSelection(
        baseOffset: 0,
        extentOffset: ctrl.text.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String fechaHoy = DateFormat(
      'EEEE, dd/MM/yyyy',
      'es_ES',
    ).format(_selectedDate);
    fechaHoy = fechaHoy[0].toUpperCase() + fechaHoy.substring(1);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF1E3A8A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Calculadora Rápida',
          style: GoogleFonts.outfit(
            color: const Color(0xFF1E3A8A),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3A8A).withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bolt, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'TASA DE CAMBIO',
                        style: GoogleFonts.outfit(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _isLoadingRate
                      ? const SizedBox(
                          height: 48,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          '${_tasaActual.toStringAsFixed(2)} BS/USD',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildInputCard(
              title: 'Dólares (USD)',
              controller: _usdCtrl,
              focusNode: _usdFocus,
              onChanged: _onUsdChanged,
              icon: Icons.attach_money,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            _buildInputCard(
              title: 'Bolívares (BS)',
              controller: _bsCtrl,
              focusNode: _bsFocus,
              onChanged: _onBsChanged,
              icon: Icons.currency_exchange,
              color: Colors.blue,
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Color(0xFF1E3A8A)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        fechaHoy,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const Icon(Icons.edit, size: 18, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required String title,
    required TextEditingController controller,
    required FocusNode focusNode,
    required Function(String) onChanged,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            onChanged: onChanged,
            onTap: () => _selectAll(controller),
            inputFormatters: [SlidingDecimalFormatter()],
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E3A8A),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
