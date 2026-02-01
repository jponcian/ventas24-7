import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _cedulaCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_cedulaCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor llena todos los campos')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final result = await _apiService.login(_cedulaCtrl.text, _passCtrl.text);
    setState(() => _isLoading = false);

    if (result['ok'] == true) {
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } else {
      if (mounted) {
        final String errorMessage =
            result['error'] ?? 'Cédula o contraseña incorrecta';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 380,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.rocket_launch_rounded,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'VENTAS 24/7',
                          style: GoogleFonts.outfit(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 4,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'PREMIUM BUSINESS SOLUTIONS',
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[100],
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenido de nuevo',
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ingresa tus credenciales para continuar',
                    style: GoogleFonts.outfit(
                      color: Colors.grey[500],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildInputLabel('CÉDULA DE IDENTIDAD'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _cedulaCtrl,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                    decoration: _inputDecoration(
                      hint: 'Ej. 25123456',
                      icon: Icons.badge_outlined,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInputLabel('CONTRASEÑA'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passCtrl,
                    obscureText: true,
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                    decoration: _inputDecoration(
                      hint: '••••••••',
                      icon: Icons.lock_outline_rounded,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E3A8A).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : Text(
                              'INICIAR SESIÓN',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
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

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF0F172A),
        letterSpacing: 1.5,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF1E3A8A), size: 22),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[100]!, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 1.5),
      ),
    );
  }
}
