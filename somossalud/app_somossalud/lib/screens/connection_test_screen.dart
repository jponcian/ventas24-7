import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';
import 'login_screen.dart';

class ConnectionTestScreen extends StatefulWidget {
  const ConnectionTestScreen({super.key});

  @override
  State<ConnectionTestScreen> createState() => _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends State<ConnectionTestScreen> {
  bool _testing = true;
  String _status = 'Verificando conexión...';
  Color _statusColor = Colors.blue;
  List<Map<String, dynamic>> _tests = [];

  @override
  void initState() {
    super.initState();
    _runTests();
  }

  Future<void> _runTests() async {
    setState(() {
      _testing = true;
      _tests = [];
    });

    // Test 1: Conexión a internet
    await _addTest('Internet', _testInternet());
    
    // Test 2: Servidor principal
    await _addTest('Servidor', _testServer());
    
    // Test 3: API disponible
    await _addTest('API /tasa', _testApiTasa());
    
    // Test 4: API login
    await _addTest('API /login', _testApiLogin());

    setState(() {
      _testing = false;
      final allPassed = _tests.every((t) => t['passed'] == true);
      if (allPassed) {
        _status = '✅ Todo funciona correctamente';
        _statusColor = Colors.green;
      } else {
        _status = '❌ Hay problemas de conexión';
        _statusColor = Colors.red;
      }
    });
  }

  Future<void> _addTest(String name, Future<Map<String, dynamic>> test) async {
    final result = await test;
    setState(() {
      _tests.add({
        'name': name,
        'passed': result['passed'],
        'message': result['message'],
      });
    });
  }

  Future<Map<String, dynamic>> _testInternet() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com')).timeout(
        const Duration(seconds: 5),
      );
      return {
        'passed': response.statusCode == 200,
        'message': 'Conexión OK',
      };
    } catch (e) {
      return {
        'passed': false,
        'message': 'Sin internet: $e',
      };
    }
  }

  Future<Map<String, dynamic>> _testServer() async {
    try {
      final response = await http.get(
        Uri.parse('https://clinicasaludsonrisa.com.ve'),
      ).timeout(const Duration(seconds: 10));
      
      return {
        'passed': response.statusCode == 200,
        'message': 'Servidor responde (${response.statusCode})',
      };
    } catch (e) {
      return {
        'passed': false,
        'message': 'Servidor no responde: $e',
      };
    }
  }

  Future<Map<String, dynamic>> _testApiTasa() async {
    try {
      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/tasa'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'passed': true,
          'message': 'API funciona. Tasa: \$${data['rate']}',
        };
      } else {
        return {
          'passed': false,
          'message': 'Error ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {
        'passed': false,
        'message': 'Error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> _testApiLogin() async {
    try {
      final response = await http.post(
        Uri.parse('${AuthService.baseUrl}/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'cedula': 'V-00000000',
          'password': 'test',
        }),
      ).timeout(const Duration(seconds: 10));
      
      // Esperamos un 401 (credenciales incorrectas) que significa que el endpoint funciona
      if (response.statusCode == 401 || response.statusCode == 422) {
        return {
          'passed': true,
          'message': 'Endpoint funciona (esperado 401/422)',
        };
      } else if (response.statusCode == 404) {
        return {
          'passed': false,
          'message': 'Endpoint no existe (404). Falta configurar en servidor.',
        };
      } else {
        return {
          'passed': false,
          'message': 'Error inesperado: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'passed': false,
        'message': 'Error: $e',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Diagnóstico de Conexión'),
        backgroundColor: const Color(0xFF0ea5e9),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _statusColor),
              ),
              child: Row(
                children: [
                  if (_testing)
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Icon(_statusColor == Colors.green ? Icons.check_circle : Icons.error, 
                         color: _statusColor, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _status,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Tests List
            Expanded(
              child: ListView.builder(
                itemCount: _tests.length,
                itemBuilder: (context, index) {
                  final test = _tests[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(
                        test['passed'] ? Icons.check_circle : Icons.cancel,
                        color: test['passed'] ? Colors.green : Colors.red,
                      ),
                      title: Text(
                        test['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(test['message']),
                    ),
                  );
                },
              ),
            ),
            
            // Buttons
            if (!_testing) ...[
              ElevatedButton.icon(
                onPressed: _runTests,
                icon: const Icon(Icons.refresh),
                label: const Text('Probar de Nuevo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0ea5e9),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 12),
              if (_tests.isNotEmpty && _tests.every((t) => t['passed'] == true))
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Ir al Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
            ],
            
            const SizedBox(height: 16),
            Text(
              'URL: ${AuthService.baseUrl}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
