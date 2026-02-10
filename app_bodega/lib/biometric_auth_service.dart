import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  static const String _biometricEnabledKey = 'biometric_enabled';

  /// Verifica si el dispositivo soporta autenticación biométrica
  Future<bool> isBiometricAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();
      return canAuthenticate;
    } on PlatformException {
      return false;
    }
  }

  /// Obtiene la lista de biométricos disponibles
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException {
      return <BiometricType>[];
    }
  }

  /// Autentica al usuario usando biométricos
  Future<bool> authenticate({
    String reason = 'Por favor autentícate para continuar',
  }) async {
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      print('Error en autenticación biométrica: $e');
      return false;
    }
  }

  /// Verifica si la autenticación biométrica está habilitada
  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricEnabledKey) ?? false;
  }

  /// Habilita o deshabilita la autenticación biométrica
  Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, enabled);
  }

  /// Obtiene el nombre del tipo de biométrico disponible
  String getBiometricTypeName(List<BiometricType> biometrics) {
    if (biometrics.isEmpty) return 'Biométrico';

    if (biometrics.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (biometrics.contains(BiometricType.fingerprint)) {
      return 'Huella Digital';
    } else if (biometrics.contains(BiometricType.iris)) {
      return 'Iris';
    } else {
      return 'Biométrico';
    }
  }

  /// Obtiene el ícono según el tipo de biométrico
  String getBiometricIcon(List<BiometricType> biometrics) {
    if (biometrics.isEmpty) return '🔐';

    if (biometrics.contains(BiometricType.face)) {
      return '👤';
    } else if (biometrics.contains(BiometricType.fingerprint)) {
      return '👆';
    } else if (biometrics.contains(BiometricType.iris)) {
      return '👁️';
    } else {
      return '🔐';
    }
  }
}
