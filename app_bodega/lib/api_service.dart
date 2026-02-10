import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'product_model.dart';
import 'fiado_model.dart';

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
        await prefs.setString('user_name', data['user']['nombre']);
        await prefs.setString(
          'user_rol',
          data['user']['rol'].toString().toLowerCase(),
        );
        // Si solo hay un negocio, lo guardamos de una vez
        if (data['negocios'] != null && data['negocios'].length == 1) {
          await prefs.setInt('negocio_id', data['negocios'][0]['id']);
          await prefs.setString(
            'negocio_nombre',
            data['negocios'][0]['nombre'],
          );
          await prefs.setBool('is_logged_in', true);
        }
        return {'ok': true, 'user': data['user'], 'negocios': data['negocios']};
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

  Future<void> setNegocio(int id, String nombre) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('negocio_id', id);
    await prefs.setString('negocio_nombre', nombre);
    await prefs.setBool('is_logged_in', true);
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
        return {'success': true, 'id': body['id']};
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

  Future<List<Map<String, dynamic>>> getVentaDetalle(int ventaId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/venta_detalle.php?id=$ventaId'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true) {
          return List<Map<String, dynamic>>.from(data['detalles']);
        }
      }
      return [];
    } catch (e) {
      return [];
    }
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

  Future<Map<String, dynamic>> getReporteInventario() async {
    try {
      final nid = await getNegocioId();
      final response = await http.get(
        Uri.parse('$baseUrl/reporte_inventario.php?negocio_id=$nid'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'ok': false, 'error': 'Error ${response.statusCode}'};
    } catch (e) {
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Obtiene el historial de ventas de un producto específico
  Future<List<Map<String, dynamic>>> getProductSalesHistory(
    int productId, {
    int days = 30,
  }) async {
    try {
      final nid = await getNegocioId();
      final response = await http.get(
        Uri.parse(
          '$baseUrl/product_sales_history.php?negocio_id=$nid&producto_id=$productId&days=$days',
        ),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true) {
          return List<Map<String, dynamic>>.from(data['ventas'] ?? []);
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Obtiene el historial de ventas de TODOS los productos (optimizado)
  Future<List<Map<String, dynamic>>> getAllProductsSalesHistory({
    int days = 30,
  }) async {
    try {
      final nid = await getNegocioId();
      final response = await http.get(
        Uri.parse(
          '$baseUrl/all_products_sales_history.php?negocio_id=$nid&days=$days',
        ),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true) {
          return List<Map<String, dynamic>>.from(data['productos'] ?? []);
        }
      }
      return [];
    } catch (e) {
      print('Error en getAllProductsSalesHistory: $e');
      return [];
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
      final prefs = await SharedPreferences.getInstance();
      final rol = prefs.getString('user_rol') ?? 'vendedor';

      final response = await http.get(
        Uri.parse('$baseUrl/usuarios.php?negocio_id=$nid&requester_rol=$rol'),
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

  Future<Map<String, dynamic>> saveUser(Map<String, dynamic> userData) async {
    try {
      final nid = await getNegocioId();
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios.php?negocio_id=$nid'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['ok'] == true) {
        return {'ok': true};
      }
      return {'ok': false, 'error': data['error'] ?? 'Error desconocido'};
    } catch (e) {
      return {'ok': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final nid = await getNegocioId();
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard.php?negocio_id=$nid'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'ok': false, 'error': 'Error ${response.statusCode}'};
    } catch (e) {
      return {'ok': false, 'error': e.toString()};
    }
  }

  // --- Negocios ---
  Future<List<Map<String, dynamic>>> getNegocios() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/negocios.php'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true) {
          return List<Map<String, dynamic>>.from(data['negocios']);
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> saveNegocio(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/negocios.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      final body = jsonDecode(response.body);
      return response.statusCode == 200 && body['ok'] == true;
    } catch (e) {
      return false;
    }
  }

  // --- Dashboard Administrativo ---
  Future<Map<String, dynamic>> getAdminDashboardData(String fecha) async {
    try {
      final nid = await getNegocioId();
      final response = await http.get(
        Uri.parse('$baseUrl/admin_dashboard.php?negocio_id=$nid&fecha=$fecha'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'ok': false, 'error': 'Error ${response.statusCode}'};
    } catch (e) {
      return {'ok': false, 'error': e.toString()};
    }
  }

  // --- Clientes ---
  Future<List<Cliente>> getClientes() async {
    try {
      final nid = await getNegocioId();
      final response = await http.get(
        Uri.parse('$baseUrl/clientes.php?negocio_id=$nid'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true) {
          final List<dynamic> list = data['clientes'] ?? [];
          return list.map((e) => Cliente.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Cliente?> getCliente(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/clientes.php?id=$id'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true) {
          return Cliente.fromJson(data['cliente']);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> crearCliente(Map<String, dynamic> data) async {
    try {
      final nid = await getNegocioId();
      data['negocio_id'] = nid;
      final response = await http.post(
        Uri.parse('$baseUrl/clientes.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      final body = jsonDecode(response.body);
      return body;
    } catch (e) {
      return {'ok': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> actualizarCliente(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      data['id'] = id;
      final response = await http.put(
        Uri.parse('$baseUrl/clientes.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      final body = jsonDecode(response.body);
      return body;
    } catch (e) {
      return {'ok': false, 'error': e.toString()};
    }
  }

  // --- Fiados ---
  Future<List<Fiado>> getFiados() async {
    try {
      final nid = await getNegocioId();
      final response = await http.get(
        Uri.parse('$baseUrl/fiados.php?negocio_id=$nid'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true) {
          final List<dynamic> list = data['fiados'] ?? [];
          return list.map((e) => Fiado.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Fiado?> getFiadoDetalle(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/fiados.php?id=$id'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true) {
          return Fiado.fromJson(data['fiado']);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> crearFiado(Map<String, dynamic> data) async {
    try {
      final nid = await getNegocioId();
      data['negocio_id'] = nid;
      final response = await http.post(
        Uri.parse('$baseUrl/fiados.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      final body = jsonDecode(response.body);
      return body;
    } catch (e) {
      return {'ok': false, 'error': e.toString()};
    }
  }

  // --- Abonos ---
  Future<List<Abono>> getAbonosFiado(int fiadoId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/abonos.php?fiado_id=$fiadoId'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true) {
          final List<dynamic> list = data['abonos'] ?? [];
          return list.map((e) => Abono.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> registrarAbono(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/abonos.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      final body = jsonDecode(response.body);
      return body;
    } catch (e) {
      return {'ok': false, 'error': e.toString()};
    }
  }

  // --- Versión del Sistema ---
  Future<Map<String, dynamic>> checkVersion() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/check_version.php'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'ok': false};
    } catch (e) {
      return {'ok': false};
    }
  }

  // --- Notificaciones ---
  Future<Map<String, dynamic>> enviarNotificacionDeuda({
    required String telefono,
    required String cliente,
    required String deuda,
    String? mensaje,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/enviar_deuda.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'telefono': telefono,
          'cliente': cliente,
          'deuda': deuda,
          'mensaje': mensaje,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'ok': false, 'error': e.toString()};
    }
  }

  Future<String?> uploadProductImage(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload_imagen.php'),
      );
      request.files.add(
        await http.MultipartFile.fromPath('imagen', imageFile.path),
      );
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true) {
          return data['url'];
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
