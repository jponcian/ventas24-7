import 'package:flutter/services.dart';

class SlidingDecimalFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    double value = double.parse(text) / 100;
    String newText = value.toStringAsFixed(2);
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class WeightDecimalFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    double value = double.parse(text) / 1000;
    String newText = value.toStringAsFixed(3);
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class VzlaPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Solo permitir números
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Si empieza por 58, lo permitimos pero validamos el resto
    if (text.startsWith('58')) {
      if (text.length > 2) {
        String rest = text.substring(2);
        if (!_isValidStart(rest)) {
          return oldValue;
        }
      }
    } else {
      // Si no empieza por 58, validamos que empiece por una operadora válida o sea parte de ella
      if (text.isNotEmpty && !_isValidStart(text)) {
        return oldValue;
      }
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  bool _isValidStart(String text) {
    List<String> validPrefixes = [
      '0414',
      '0424',
      '0412',
      '0422',
      '0416',
      '0426',
      '414',
      '424',
      '412',
      '422',
      '416',
      '426',
    ];
    if (text.length <= 4) {
      return validPrefixes.any((p) => p.startsWith(text) || text.startsWith(p));
    }
    String p4 = text.substring(0, 4);
    String p3 = text.substring(0, 3);
    return validPrefixes.contains(p4) || validPrefixes.contains(p3);
  }

  static String formatForApi(String text) {
    String clean = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.isEmpty) return '';
    if (clean.startsWith('58')) return clean;
    if (clean.startsWith('0')) return '58${clean.substring(1)}';
    return '58$clean';
  }
}
