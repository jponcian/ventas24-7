import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class PatientService {
  final _authService = AuthService();

  // Obtener datos del dashboard
  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('No hay sesión activa');

      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/paciente/dashboard'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          return {'success': true, 'data': data['data']};
        }
      }

      return {'success': false, 'message': 'Error al cargar datos'};
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // Obtener información de suscripción
  Future<Map<String, dynamic>> getSubscription() async {
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('No hay sesión activa');

      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/paciente/suscripcion'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          return {'success': true, 'data': data['data']};
        }
      }

      return {'success': false, 'message': 'Error al cargar suscripción'};
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // Obtener resultados de laboratorio
  Future<Map<String, dynamic>> getLabResults() async {
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('No hay sesión activa');

      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/paciente/resultados'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          return {'success': true, 'data': data['data']};
        }
      }

      return {'success': false, 'message': 'Error al cargar resultados'};
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // Obtener detalle de un resultado específico
  Future<Map<String, dynamic>> getLabResultDetail(int id) async {
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('No hay sesión activa');

      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/paciente/resultados/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          return {'success': true, 'data': data['data']};
        }
      }

      return {'success': false, 'message': 'Error al cargar detalle'};
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // Obtener citas médicas
  Future<Map<String, dynamic>> getAppointments() async {
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('No hay sesión activa');

      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/paciente/citas'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          return {'success': true, 'data': data['data']};
        }
      }

      return {'success': false, 'message': 'Error al cargar citas'};
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // Reportar pago de suscripción
  Future<Map<String, dynamic>> reportPayment(
    Map<String, dynamic> paymentData,
  ) async {
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('No hay sesión activa');

      final response = await http.post(
        Uri.parse('${AuthService.baseUrl}/paciente/reportar-pago'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(paymentData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          return {'success': true, 'message': data['message']};
        }
      }

      return {'success': false, 'message': 'Error al reportar pago'};
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // Actualizar perfil
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('No hay sesión activa');

      final response = await http.post(
        Uri.parse('${AuthService.baseUrl}/paciente/perfil'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          // Actualizar datos locales del usuario si es necesario
          return {'success': true, 'message': responseData['message']};
        }
      }

      return {'success': false, 'message': 'Error al actualizar perfil'};
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // Obtener tasa de cambio
  Future<Map<String, dynamic>> getExchangeRate() async {
    try {
      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/tasa'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // La respuesta es directa: {"date":..., "rate":...}
        final Map<String, dynamic> data = jsonDecode(response.body);
        return {'success': true, 'rate': data['rate']};
      }

      return {'success': false, 'message': 'Error al obtener tasa'};
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // Obtener especialidades
  Future<Map<String, dynamic>> getSpecialties() async {
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('No hay sesión activa');

      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/paciente/especialidades'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          return {'success': true, 'data': data['data']};
        }
      }

      return {'success': false, 'message': 'Error al cargar especialidades'};
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // Obtener doctores por especialidad
  Future<Map<String, dynamic>> getDoctors(int? specialtyId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('No hay sesión activa');

      final uri = Uri.parse('${AuthService.baseUrl}/paciente/doctores').replace(
        queryParameters: specialtyId != null
            ? {'especialidad_id': specialtyId.toString()}
            : null,
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          return {'success': true, 'data': data['data']};
        }
      }

      return {'success': false, 'message': 'Error al cargar doctores'};
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // Obtener slots disponibles
  Future<Map<String, dynamic>> getAvailableSlots(
    int doctorId,
    String date,
  ) async {
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('No hay sesión activa');

      final uri = Uri.parse('${AuthService.baseUrl}/paciente/slots').replace(
        queryParameters: {'doctor_id': doctorId.toString(), 'fecha': date},
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          return {'success': true, 'data': data['data']};
        }
      }

      return {'success': false, 'message': 'Error al cargar horarios'};
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // Crear cita
  Future<Map<String, dynamic>> createAppointment(
    Map<String, dynamic> appointmentData,
  ) async {
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('No hay sesión activa');

      final response = await http.post(
        Uri.parse('${AuthService.baseUrl}/paciente/citas'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(appointmentData),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['success'] == true) {
          return {'success': true, 'message': responseData['message']};
        }
      }

      return {
        'success': false,
        'message': responseData['message'] ?? 'Error al agendar cita',
      };
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }
}
