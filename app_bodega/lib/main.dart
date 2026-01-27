import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'product_model.dart';
import 'calc_screen.dart';
import 'product_form_screen.dart';
import 'scanner_screen.dart';
import 'login_screen.dart';
import 'report_sales_screen.dart';
import 'low_stock_screen.dart';
import 'report_purchases_screen.dart';
import 'purchase_screen.dart';
import 'market_mode_screen.dart';
import 'history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bodega Ponciano',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          primary: const Color(0xFF1E3A8A),
          secondary: const Color(0xFF10B981),
        ),
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const ProductListScreen(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es', 'ES'), Locale('en', 'US')],
    );
  }
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  double _tasa = 0.0;
  bool _loading = true;
  String _errorMessage = '';
  String _searchQuery = '';
  String _userName = '';
  String _negocioName = '';
  final ApiService _apiService = ApiService();
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadData();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Usuario';
      _negocioName = prefs.getString('negocio_nombre') ?? 'Bodega';
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _errorMessage = '';
    });

    try {
      try {
        _tasa = await _apiService.getTasa();
      } catch (e) {
        _tasa = 0.0;
      }

      List<Product> rawProducts = await _apiService.getProducts();

      List<Product> processed = [];
      for (var p in rawProducts) {
        processed.add(
          Product(
            id: p.id,
            nombre: p.nombre,
            descripcion: p.descripcion,
            unidadMedida: 'unidad',
            precioVenta: p.precioReal,
            precioCompra: p.precioCompra,
            monedaCompra: p.monedaCompra,
            bajoInventario: p.bajoInventario,
            codigoBarras: p.codigoBarras,
            proveedor: p.proveedor,
            tamPaquete: p.tamPaquete,
            precioVentaPaquete: p.precioVentaPaquete,
            precioVentaUnidad: p.precioVentaUnidad,
            stock: p.stock,
            qty: 0,
          ),
        );

        if (p.isPaquete &&
            p.precioVentaPaquete != null &&
            p.precioVentaPaquete! > 0) {
          processed.add(
            Product(
              id: -p.id,
              nombre: '${p.nombre} (Paquete)',
              descripcion: p.descripcion,
              unidadMedida: 'paquete',
              precioVenta: p.precioVentaPaquete,
              precioCompra: p.precioCompra,
              monedaCompra: p.monedaCompra,
              bajoInventario: p.bajoInventario,
              codigoBarras: p.codigoBarras,
              proveedor: p.proveedor,
              tamPaquete: p.tamPaquete,
              precioVentaPaquete: p.precioVentaPaquete,
              precioVentaUnidad: p.precioVentaUnidad,
              stock: p.stock,
              qty: 0,
            ),
          );
        }
      }

      setState(() {
        _allProducts = processed;
        _loading = false;
      });
      _filter(_searchQuery);
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _errorMessage = 'Error conectando: $e';
        });
      }
    }
  }

  void _filter(String q) {
    setState(() {
      _searchQuery = q.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((p) {
          return p.nombre.toLowerCase().contains(_searchQuery) ||
              (p.codigoBarras != null &&
                  p.codigoBarras!.contains(_searchQuery)) ||
              (p.descripcion != null &&
                  p.descripcion!.toLowerCase().contains(_searchQuery));
        }).toList();
      }
    });
  }

  void _showTicket() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            List<Product> selected = _allProducts
                .where((p) => p.qty > 0)
                .toList();

            if (selected.isEmpty) {
              Future.microtask(() => Navigator.pop(context));
              return const SizedBox();
            }

            double totalBs = 0;
            double totalUsd = 0;

            for (var p in selected) {
              double precio = p.precioVenta ?? 0;
              bool esDolar = p.monedaCompra != 'BS';
              double precioBs = esDolar ? precio * _tasa : precio;
              totalBs += precioBs * p.qty;
              totalUsd += (esDolar ? precio : precio / _tasa) * p.qty;
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Detalle de Venta',
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              for (var p in _allProducts) {
                                p.qty = 0;
                              }
                            });
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.delete_sweep,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: selected.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: Colors.grey[100]),
                      itemBuilder: (context, index) {
                        final p = selected[index];
                        double precio = p.precioVenta ?? 0;
                        bool esDolar = p.monedaCompra != 'BS';
                        double precioBs = esDolar ? precio * _tasa : precio;
                        double subtotalBs = precioBs * p.qty;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${p.qty}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.nombre,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '${precioBs.toStringAsFixed(2)} Bs c/u',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${subtotalBs.toStringAsFixed(2)} Bs',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TOTAL',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${totalBs.toStringAsFixed(2)} Bs',
                                    style: GoogleFonts.outfit(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1E3A8A),
                                    ),
                                  ),
                                  Text(
                                    '${totalUsd.toStringAsFixed(2)} USD',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () async {
                                final bool? confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Confirmar Venta'),
                                    content: const Text(
                                      '¿Estás seguro de que deseas finalizar esta venta?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancelar'),
                                      ),
                                      FilledButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        style: FilledButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF1E3A8A,
                                          ),
                                        ),
                                        child: const Text('Confirmar'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm != true) return;

                                final items = selected.map((p) {
                                  double precio = p.precioVenta ?? 0;
                                  bool esDolar = p.monedaCompra != 'BS';
                                  double precioBs = esDolar
                                      ? precio * _tasa
                                      : precio;
                                  double cantDescuento = (p.id < 0)
                                      ? p.qty * (p.tamPaquete ?? 1.0)
                                      : p.qty.toDouble();
                                  return {
                                    'id': p.id.abs(),
                                    'cantidad': cantDescuento,
                                    'precio_bs': precioBs,
                                  };
                                }).toList();

                                final ventaData = {
                                  'total_bs': totalBs,
                                  'total_usd': totalUsd,
                                  'tasa': _tasa,
                                  'detalles': items,
                                };

                                Navigator.pop(context);
                                setState(() => _loading = true);
                                bool ok = await _apiService.registrarVenta(
                                  ventaData,
                                );
                                if (ok) {
                                  setState(() {
                                    for (var p in _allProducts) {
                                      p.qty = 0;
                                    }
                                  });
                                  _loadData();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Venta registrada con éxito',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  setState(() => _loading = false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Error al procesar la venta',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A8A),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'FINALIZAR VENTA',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _generarEtiquetasPDF() async {
    // Get all product IDs from current filtered list
    final productIds = _filteredProducts
        .where((p) => p.id > 0) // Only real products, not package variants
        .map((p) => p.id)
        .toList();

    if (productIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay productos para generar etiquetas'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final pdfUrl = await _apiService.generarEtiquetasPDF(productIds);
      if (pdfUrl != null && mounted) {
        // Show dialog with URL to open in browser
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Etiquetas PDF'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Las etiquetas están listas.'),
                const SizedBox(height: 16),
                Text(
                  pdfUrl,
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Copy URL to clipboard or open in browser
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Abre este enlace en tu navegador:\n$pdfUrl',
                      ),
                      duration: const Duration(seconds: 5),
                    ),
                  );
                },
                child: const Text('Copiar'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al generar etiquetas'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalBs = 0;
    for (var p in _allProducts) {
      if (p.qty > 0) {
        double precio = p.precioVenta ?? 0;
        bool esDolar = p.monedaCompra != 'BS';
        double precioBs = esDolar ? precio * _tasa : precio;
        totalBs += precioBs * p.qty;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_negocioName),
              accountEmail: Text(_userName),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  _negocioName.isNotEmpty ? _negocioName[0] : 'B',
                  style: const TextStyle(
                    fontSize: 40.0,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
              ),
              decoration: const BoxDecoration(color: Color(0xFF1E3A8A)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                // Already on Home, do nothing else
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Reporte de Ventas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportSalesScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning, color: Colors.orange),
              title: const Text('Bajo Inventario'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LowStockScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long, color: Colors.purple),
              title: const Text('Reporte de Compras'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportPurchasesScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_shopping_cart, color: Colors.green),
              title: const Text('Cargar Compras'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PurchaseScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.blueGrey),
              title: const Text('Historial Cargas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await _apiService.logout();
                if (mounted) Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _negocioName,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E3A8A),
              ),
            ),
            Text(
              'Hola, $_userName',
              style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_basket_outlined,
              color: Color(0xFF10B981),
            ),
            tooltip: 'Modo Supermercado',
            onPressed: () => _openMarketMode(),
          ),
          IconButton(
            icon: const Icon(
              Icons.calculate_outlined,
              color: Color(0xFF1E3A8A),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalcScreen(tasa: _tasa)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.print_outlined, color: Color(0xFFEF4444)),
            tooltip: 'Generar Etiquetas PDF',
            onPressed: () => _generarEtiquetasPDF(),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              await _apiService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            color: Colors.white,
            child: TextField(
              controller: _searchCtrl,
              onChanged: _filter,
              decoration: InputDecoration(
                hintText: 'Buscar producto o código...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1E3A8A)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () async {
                    final String? res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BarcodeScannerScreen(),
                      ),
                    );
                    if (res != null) {
                      _searchCtrl.text = res;
                      _filter(res);
                    }
                  },
                ),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
                ? const Center(child: Text('No se encontraron productos'))
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) =>
                        _buildProductCard(_filteredProducts[index]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProductFormScreen()),
          );
          if (res == true) _loadData();
        },
        backgroundColor: const Color(0xFF1E3A8A),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: totalBs > 0 ? _buildBottomBar(totalBs) : null,
    );
  }

  Widget _buildBottomBar(double total) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32), // Más padding abajo
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: InkWell(
          onTap: _showTicket,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Ver Carrito',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${total.toStringAsFixed(2)} Bs',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openMarketMode() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarketModeScreen(
          products: _allProducts,
          onProductScanned: (p) {
            setState(() {
              // Buscar el producto original en la lista general para actualizar su qty
              // Usamos p.id para encontrarlo exactamente
              final original = _allProducts.firstWhere(
                (item) => item.id == p.id,
              );
              original.qty += 1;
            });
          },
        ),
      ),
    );
  }

  Widget _buildProductCard(Product p) {
    bool esBajo =
        p.stock != null &&
        p.bajoInventario != null &&
        p.stock! <= p.bajoInventario!;
    double precio = p.precioVenta ?? 0;
    bool esDolar = p.monedaCompra != 'BS';
    double precioBs = esDolar ? precio * _tasa : precio;
    String precioStr = '${precioBs.toStringAsFixed(2)} Bs';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onLongPress: () async {
              final res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductFormScreen(product: p),
                ),
              );
              if (res == true) _loadData();
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: esBajo ? Colors.orange[50] : Colors.blue[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      esBajo
                          ? Icons.warning_amber_rounded
                          : Icons.inventory_2_outlined,
                      color: esBajo ? Colors.orange : const Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          precioStr,
                          style: const TextStyle(
                            color: Color(0xFF1E3A8A),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Stock: ${p.stock?.toStringAsFixed(p.stock! % 1 == 0 ? 0 : 2) ?? "0"}',
                          style: TextStyle(
                            color: esBajo ? Colors.red : Colors.green[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: p.qty > 0
                            ? () => setState(() => p.qty--)
                            : null,
                      ),
                      Text(
                        '${p.qty}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: Color(0xFF1E3A8A),
                        ),
                        onPressed: () => setState(() => p.qty++),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
