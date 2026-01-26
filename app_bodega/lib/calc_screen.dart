import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  void initState() {
    super.initState();

    _usdCtrl = TextEditingController(text: '1.00');
    _bsCtrl = TextEditingController(text: widget.tasa.toStringAsFixed(2));

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

  void _onUsdChanged(String value) {
    if (value.isEmpty) return;
    double? usd = double.tryParse(value);
    if (usd != null) {
      double bs = usd * widget.tasa;
      String newBs = bs.toStringAsFixed(2);
      if (_bsCtrl.text != newBs) {
        _bsCtrl.text = newBs;
      }
    }
  }

  void _onBsChanged(String value) {
    if (value.isEmpty) return;
    double? bs = double.tryParse(value);
    if (bs != null && widget.tasa > 0) {
      double usd = bs / widget.tasa;
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
    ).format(DateTime.now());
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
<<<<<<< HEAD
                  Row(
=======
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF66BB6A),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'Dólar BCV',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _usdCtrl,
                    focusNode: _usdFocus,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                    onChanged: _onUsdChanged,
                    inputFormatters: [SlidingDecimalFormatter()],
                    onTap: () => _selectAll(_usdCtrl),
                    decoration: const InputDecoration(
                      prefixText: '\$   ',
                      prefixStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _bsCtrl,
                    focusNode: _bsFocus,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                    onChanged: _onBsChanged,
                    inputFormatters: [SlidingDecimalFormatter()],
                    onTap: () => _selectAll(_bsCtrl),
                    decoration: InputDecoration(
                      prefixText: 'Bs   ',
                      prefixStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.copy,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _bsCtrl.text));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Valor copiado al portapapeles'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Row(
>>>>>>> 55dc2826b0ed8a61b5dc2f74b547d2b55a83c2b3
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bolt, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'TASA DEL DÍA',
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
                  Text(
                    '${widget.tasa.toStringAsFixed(2)} BS/USD',
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
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
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
                ],
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
