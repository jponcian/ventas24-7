import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

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

    // Iniciar con valores formateados
    _usdCtrl = TextEditingController(text: '1.00');
    _bsCtrl = TextEditingController(text: widget.tasa.toStringAsFixed(2));

    // Escuchar cambios de foco para seleccionar todo
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
      // Solo actualizamos el otro campo si es diferente para evitar ciclos
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
    // Usamos un pequeño delay para que Flutter termine de procesar el tap antes de seleccionar
    Future.delayed(Duration.zero, () {
      ctrl.selection = TextSelection(
        baseOffset: 0,
        extentOffset: ctrl.text.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fecha actual formateada
    String fechaHoy = DateFormat(
      'EEEE, dd/MM/yyyy',
      'es_ES',
    ).format(DateTime.now());
    fechaHoy = fechaHoy[0].toUpperCase() + fechaHoy.substring(1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Calculadora Rápida',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.currency_exchange, size: 60, color: Colors.blue),
            const SizedBox(height: 10),
            const Text(
              'Tasa del Día',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 5),
            Text(
              '1 USD = ${widget.tasa.toStringAsFixed(2)} BS',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_upward, color: Color(0xFF66BB6A)),
                      SizedBox(width: 10),
                      Text(
                        "Conversión Automática",
                        style: TextStyle(color: Color(0xFF66BB6A)),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_downward, color: Color(0xFF66BB6A)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text(
                    fechaHoy,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
}

class SlidingDecimalFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Si se borra todo, dejar en 0.00
    if (newValue.text.isEmpty) {
      return const TextEditingValue(
        text: '0.00',
        selection: TextSelection.collapsed(offset: 4),
      );
    }
    // Solo dígitos
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '0.00',
        selection: TextSelection.collapsed(offset: 4),
      );
    }
    double value = double.parse(digits) / 100;
    String newText = value.toStringAsFixed(2);
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
