import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'product_model.dart';

class ApiService {
  static const String baseUrl = 'https://ponciano.zz.com.ve/bodega/api';

  Future<int> getNegocioId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('negocio_id') ?? 1;
  }

  Future<Map<String, dynamic>> login(String cedula, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'cedula': cedula, 'password': password}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['ok'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('negocio_id', data['user']['negocio_id']);
        await prefs.setString('negocio_nombre', data['user']['negocio_nombre']);
        await prefs.setString('user_name', data['user']['nombre']);
        await prefs.setBool('is_logged_in', true);
        return {'ok': true, 'user': data['user']};
      }
      return {'ok': false, 'error': data['error'] ?? 'Error desconocido'};
    } catch (e) {
      return {'ok': false, 'error': 'Error de conexión: $e'};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<double> getTasa({String? fecha}) async {
    try {
      String url = '$baseUrl/tasa.php';
      if (fecha != null) url += '?fecha=$fecha';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true) {
          return double.tryParse(data['valor'].toString()) ?? 0.0;
        }
      }
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      final nid = await getNegocioId();
      final response = await http.get(
        Uri.parse('$baseUrl/ver.php?negocio_id=$nid'),
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Product.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> createProduct(Map<String, dynamic> data) async {
    data['negocio_id'] = await getNegocioId();
    final response = await http.post(
      Uri.parse('$baseUrl/crear.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response.statusCode == 200 &&
        jsonDecode(response.body)['ok'] == true;
  }

  Future<bool> updateProduct(int id, Map<String, dynamic> data) async {
    data['id'] = id;
    data['negocio_id'] = await getNegocioId();
    final response = await http.post(
      Uri.parse('$baseUrl/editar.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response.statusCode == 200 &&
        jsonDecode(response.body)['ok'] == true;
  }

  Future<bool> registrarVenta(Map<String, dynamic> ventaData) async {
    ventaData['negocio_id'] = await getNegocioId();
    final response = await http.post(
      Uri.parse('$baseUrl/vender.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ventaData),
    );
    return response.statusCode == 200 &&
        jsonDecode(response.body)['ok'] == true;
  }

  Future<List<String>> getProviders() async {
    try {
      final nid = await getNegocioId();
      final response = await http.get(
        Uri.parse('$baseUrl/proveedores.php?negocio_id=$nid'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['ok'] == true) {
          final List<dynamic> list = data['proveedores'];
          return list.map((e) => e.toString()).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> getReporteDia(String fecha) async {
    try {
      final nid = await getNegocioId();
      final response = await http.get(
        Uri.parse('$baseUrl/reporte_dia.php?negocio_id=$nid&fecha=$fecha'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'ok': false, 'error': 'Error ${response.statusCode}'};
    } catch (e) {
      return {'ok': false, 'error': e.toString()};
    }
  }

  Future<bool> cargarCompra(
    int productId,
    double cantidad,
    double? nuevoCosto,
  ) async {
    try {
      final nid = await getNegocioId();
      final body = {
        'negocio_id': nid,
        'producto_id': productId,
        'cantidad': cantidad,
      };
      if (nuevoCosto != null) body['costo_nuevo'] = nuevoCosto;

      final response = await http.post(
        Uri.parse('$baseUrl/comprar.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      return response.statusCode == 200 &&
          jsonDecode(response.body)['ok'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getReporteCompras(String fecha) async {
    try {
      final nid = await getNegocioId();
      final response = await http.get(
        Uri.parse('$baseUrl/reporte_compras.php?negocio_id=$nid&fecha=$fecha'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'ok': false, 'error': 'Error ${response.statusCode}'};
    } catch (e) {
      return {'ok': false, 'error': e.toString()};
    }
  }
}
