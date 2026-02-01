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
        await prefs.setString(
          'user_rol',
          data['user']['rol'].toString().toLowerCase(),
        );
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

  Future<List<Product>> getProducts([String? query]) async {
    try {
      final nid = await getNegocioId();
      String url = '$baseUrl/ver.php?negocio_id=$nid';
      if (query != null && query.isNotEmpty) {
        url += '&q=$query';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Product.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> data) async {
    try {
      data['negocio_id'] = await getNegocioId();
      final response = await http.post(
        Uri.parse('$baseUrl/crear.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['ok'] == true) {
        return {'success': true};
      }
      return {
        'success': false,
        'message': body['error'] ?? 'Error desconocido del servidor',
      };
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  Future<Map<String, dynamic>> updateProduct(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      data['id'] = id;
      data['negocio_id'] = await getNegocioId();
      final response = await http.post(
        Uri.parse('$baseUrl/editar.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['ok'] == true) {
        return {'success': true};
      }
      return {
        'success': false,
        'message': body['error'] ?? 'Error desconocido del servidor',
      };
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
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
          final List<dynamic> list = data['proveedores'] ?? [];
          return list.map((e) => e['nombre'].toString()).toList();
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

  Future<List<Map<String, dynamic>>> getProveedoresList() async {
    try {
      final nid = await getNegocioId();
      final response = await http.get(
        Uri.parse('$baseUrl/proveedores.php?negocio_id=$nid'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true) {
          return List<Map<String, dynamic>>.from(data['proveedores']);
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> addProveedor(String nombre, String contacto, String tel) async {
    try {
      final nid = await getNegocioId();
      final response = await http.post(
        Uri.parse('$baseUrl/proveedores.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'negocio_id': nid,
          'nombre': nombre,
          'contacto': contacto,
          'telefono': tel,
        }),
      );
      return response.statusCode == 200 &&
          jsonDecode(response.body)['ok'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> cargarCompra(
    List<Map<String, dynamic>> items, {
    int? proveedorId,
    String? moneda,
    double? tasa,
  }) async {
    try {
      final nid = await getNegocioId();
      final body = {
        'negocio_id': nid,
        'items': items,
        'proveedor_id': proveedorId,
        'moneda': moneda ?? 'USD',
        'tasa': tasa ?? 1.0,
      };

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

  Future<List<Map<String, dynamic>>> getHistorialCompras() async {
    try {
      final nid = await getNegocioId();
      final response = await http.get(
        Uri.parse('$baseUrl/compras_historial.php?negocio_id=$nid'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true) {
          return List<Map<String, dynamic>>.from(data['compras']);
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> anularCompra(int compraId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/anular_compra.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'compra_id': compraId}),
      );
      return response.statusCode == 200 &&
          jsonDecode(response.body)['ok'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> generarEtiquetasPDF(List<int>? productIds) async {
    try {
      final nid = await getNegocioId();
      final response = await http.post(
        Uri.parse('$baseUrl/generar_etiquetas.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'negocio_id': nid, 'ids': productIds ?? []}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true) {
          return data['pdf_url'];
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // --- Usuarios ---
  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final nid = await getNegocioId();
      final response = await http.get(
        Uri.parse('$baseUrl/usuarios.php?negocio_id=$nid'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true) {
          return List<Map<String, dynamic>>.from(data['usuarios']);
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> saveUser(Map<String, dynamic> userData) async {
    try {
      final nid = await getNegocioId();
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios.php?negocio_id=$nid'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );
      final data = jsonDecode(response.body);
      return response.statusCode == 200 && data['ok'] == true;
    } catch (e) {
      return false;
    }
  }
}
