import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'user_management_screen.dart';
import 'business_management_screen.dart';
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
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dashboard_screen.dart';

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
      title: 'Ventas 24/7',
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
        '/home': (context) => const DashboardScreen(),
        '/sales': (context) => const ProductListScreen(),
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
  String _userRol = 'vendedor';
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
      _negocioName = prefs.getString('negocio_nombre') ?? 'Ventas 24/7';
      _userRol = prefs.getString('user_rol') ?? 'vendedor';
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
            updatedAt: p.updatedAt,
            monedaBase: p.monedaBase,
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
              updatedAt: p.updatedAt,
              monedaBase: p.monedaBase,
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
      _checkExpirations();
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

  void _checkExpirations() {
    final now = DateTime.now();
    final sevenDaysFromNow = now.add(const Duration(days: 7));
    List<Product> expiring = [];

    for (var p in _allProducts) {
      if (p.fechaVencimiento != null && p.fechaVencimiento!.isNotEmpty) {
        try {
          final expDate = DateTime.parse(p.fechaVencimiento!);
          if (expDate.isBefore(sevenDaysFromNow) &&
              expDate.isAfter(now.subtract(const Duration(days: 1)))) {
            expiring.add(p);
          }
        } catch (_) {}
      }
    }

    if (expiring.isNotEmpty) {
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange),
                SizedBox(width: 10),
                Text('Productos por Vencer'),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: expiring.length,
                itemBuilder: (context, i) => ListTile(
                  title: Text(expiring[i].nombre),
                  subtitle: Text('Vence el: ${expiring[i].fechaVencimiento}'),
                  leading: const Icon(
                    Icons.timer_off_outlined,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ENTENDIDO'),
              ),
            ],
          ),
        );
      });
    }
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
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              });
              return const Center(child: Text('Carrito Vacío'));
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
                              // Selector de cantidad horizontal
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Botón decrementar
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (p.qty > 1) {
                                            p.qty--;
                                          }
                                        });
                                        setModalState(() {});
                                      },
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.remove,
                                          size: 16,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Cantidad
                                    Text(
                                      p.qty % 1 == 0
                                          ? p.qty.toInt().toString()
                                          : p.qty.toStringAsFixed(3),
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: const Color(0xFF1E3A8A),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Botón incrementar
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          p.qty++;
                                        });
                                        setModalState(() {});
                                      },
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          size: 16,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${subtotalBs.toStringAsFixed(2)} Bs',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Botón eliminar
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        p.qty = 0;
                                      });
                                      setModalState(() {});
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red[50],
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.delete_outline,
                                            size: 14,
                                            color: Colors.red[700],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Eliminar',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.red[700],
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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

  Future<void> _generarEtiquetasPDF([List<int>? ids]) async {
    // Si no se pasaron IDs, preguntar al usuario qué desea hacer
    if (ids == null) {
      final String? choice = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Imprimir Etiquetas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.history,
                  color: Colors.blue,
                  size: 32,
                ),
                title: const Text('Últimos Modificados'),
                subtitle: const Text(
                  'Genera etiquetas para los últimos 12 cambios',
                ),
                onTap: () => Navigator.pop(ctx, 'last'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.touch_app,
                  color: Colors.green,
                  size: 32,
                ),
                title: const Text('Selección Manual'),
                subtitle: const Text('Buscar y elegir productos específicos'),
                onTap: () => Navigator.pop(ctx, 'manual'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      );

      if (choice == null) return;

      if (choice == 'manual') {
        ids = await _showSelectionDialog();
        if (ids == null || ids.isEmpty) return;
      } else if (choice == 'last') {
        // Ordenar por fecha de actualización (descendente) y tomar los últimos 15
        List<Product> sorted = List.from(_allProducts);
        sorted.sort((a, b) {
          final dateA = DateTime.tryParse(a.updatedAt ?? '') ?? DateTime(2000);
          final dateB = DateTime.tryParse(b.updatedAt ?? '') ?? DateTime(2000);
          return dateB.compareTo(dateA); // Más recientes primero
        });
        ids = sorted.take(15).map((p) => p.id.abs()).toList();
      }
    }

    List<Product> productsToPrint = _allProducts
        .where((p) => ids!.contains(p.id.abs()))
        .toList();

    // Asegurar que se impriman en orden de actualización descendente
    productsToPrint.sort((a, b) {
      final dateA = DateTime.tryParse(a.updatedAt ?? '') ?? DateTime(2000);
      final dateB = DateTime.tryParse(b.updatedAt ?? '') ?? DateTime(2000);
      return dateB.compareTo(dateA);
    });

    if (productsToPrint.isEmpty) return;

    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        build: (pw.Context context) {
          return [
            pw.GridView(
              crossAxisCount: 3,
              childAspectRatio: 0.75,
              children: productsToPrint.map((p) {
                double precio = p.precioReal;
                bool baseEsBs = p.monedaBase == 'BS';

                return pw.Container(
                  margin: const pw.EdgeInsets.all(5),
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(8),
                    ),
                  ),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        p.nombre,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 13,
                        ),
                        textAlign: pw.TextAlign.center,
                        maxLines: 2,
                        overflow: pw.TextOverflow.clip,
                      ),
                      pw.Spacer(),
                      if (!baseEsBs)
                        pw.Text(
                          '${precio.toStringAsFixed(2)} USD',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 26,
                            color: PdfColors.blue900,
                          ),
                        ),
                      pw.Spacer(),
                      if (p.codigoBarras != null && p.codigoBarras!.isNotEmpty)
                        pw.Container(
                          height: 45,
                          width: 120,
                          child: pw.BarcodeWidget(
                            barcode: pw.Barcode.code128(),
                            data: p.codigoBarras!,
                            drawText: false,
                          ),
                        ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        p.codigoBarras ?? '',
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                      pw.SizedBox(height: 5),
                    ],
                  ),
                );
              }).toList(),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  // Diálogo para buscar y seleccionar productos manualmente
  Future<List<int>?> _showSelectionDialog() async {
    return showDialog<List<int>>(
      context: context,
      builder: (context) {
        // Variables locales del diálogo
        Set<int> selectedIds = {};
        List<Product> searchResults = [];
        bool isLoading = false;
        TextEditingController searchCtrl = TextEditingController();

        // Función interna para buscar
        Future<void> doSearch(String query, StateSetter setState) async {
          setState(() => isLoading = true);
          try {
            // Reutilizamos getProducts con query search
            final res = await _apiService.getProducts(query);
            setState(() {
              searchResults = res;
              isLoading = false;
            });
          } catch (e) {
            setState(() => isLoading = false);
          }
        }

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Seleccionar Productos'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchCtrl,
                      decoration: InputDecoration(
                        labelText: 'Buscar producto...',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () => doSearch(searchCtrl.text, setState),
                        ),
                      ),
                      onSubmitted: (val) => doSearch(val, setState),
                    ),
                    const SizedBox(height: 10),
                    // Lista de resultados
                    Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : searchResults.isEmpty
                          ? const Center(
                              child: Text('Busca productos para agregar'),
                            )
                          : ListView.builder(
                              itemCount: searchResults.length,
                              itemBuilder: (ctx, i) {
                                final p = searchResults[i];
                                final isSelected = selectedIds.contains(p.id);
                                return CheckboxListTile(
                                  title: Text(p.nombre),
                                  subtitle: Text(
                                    '${p.precioVentaUnidad?.toStringAsFixed(2) ?? "0.00"} \$ / ${p.precioVentaPaquete?.toStringAsFixed(2) ?? "0.00"} \$ (Paq)',
                                  ),
                                  value: isSelected,
                                  onChanged: (val) {
                                    setState(() {
                                      if (val == true) {
                                        selectedIds.add(p.id);
                                      } else {
                                        selectedIds.remove(p.id);
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 10),
                    Text('${selectedIds.length} productos seleccionados'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, selectedIds.toList()),
                  child: const Text('Imprimir Selección'),
                ),
              ],
            );
          },
        );
      },
    );
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
      drawer: const MainDrawer(),
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
            icon: const Icon(Icons.bolt_rounded, color: Color(0xFF10B981)),
            tooltip: 'Venta Rápida',
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
          if (_userRol == 'administrador' ||
              _userRol == 'admin' ||
              _userRol == 'superadmin')
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
        builder: (context) => QuickSaleScreen(
          products: _allProducts,
          onProductScanned: (p, weight) {
            setState(() {
              final original = _allProducts.firstWhere(
                (item) => item.id == p.id,
              );
              original.qty += weight;
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
                        p.qty % 1 == 0
                            ? p.qty.toInt().toString()
                            : p.qty.toStringAsFixed(3),
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

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String _userName = '';
  String _negocioName = '';
  String _userRol = 'vendedor';
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Usuario';
      _negocioName = prefs.getString('negocio_nombre') ?? 'Ventas 24/7';
      _userRol = prefs.getString('user_rol') ?? 'vendedor';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_negocioName),
            accountEmail: Text('$_userName ($_userRol)'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _negocioName.isNotEmpty ? _negocioName[0] : 'V',
                style: const TextStyle(
                  fontSize: 40.0,
                  color: Color(0xFF1E3A8A),
                ),
              ),
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
              ),
            ),
          ),
          _buildSectionHeader('GENERAL'),
          ListTile(
            leading: const Icon(
              Icons.dashboard_outlined,
              color: Color(0xFF1E3A8A),
            ),
            title: const Text('Resumen Dashboard'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          _buildSectionHeader('OPERACIONES'),
          ListTile(
            leading: const Icon(
              Icons.shopping_cart_outlined,
              color: Color(0xFF1E3A8A),
            ),
            title: const Text('Panel de Ventas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/sales');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.bar_chart_rounded,
            title: 'Mis Ventas',
            color: Colors.blue,
            route: (context) => const ReportSalesScreen(),
          ),
          if (_userRol == 'administrador' ||
              _userRol == 'admin' ||
              _userRol == 'superadmin') ...[
            const Divider(),
            _buildSectionHeader('INVENTARIO Y COMPRAS'),
            _buildDrawerItem(
              context,
              icon: Icons.add_shopping_cart,
              title: 'Cargar Compras',
              color: Colors.green,
              route: (context) => PurchaseScreen(),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.history,
              title: 'Historial Cargas',
              color: Colors.blueGrey,
              route: (context) => const HistoryScreen(),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.receipt_long,
              title: 'Reporte de Compras',
              color: Colors.purple,
              route: (context) => const ReportPurchasesScreen(),
            ),
            const Divider(),
            _buildSectionHeader('REPORTES'),
            _buildDrawerItem(
              context,
              icon: Icons.warning_amber_rounded,
              title: 'Stock Bajo',
              color: Colors.orange,
              route: (context) => const LowStockScreen(),
            ),
            const Divider(),
            _buildSectionHeader('CONFIGURACIÓN'),
            _buildDrawerItem(
              context,
              icon: Icons.people_outline,
              title: 'Gestión de Usuarios',
              color: Colors.indigo,
              route: (context) => const UserManagementScreen(),
            ),
          ],
          if (_userRol == 'superadmin') ...[
            const Divider(),
            _buildSectionHeader('SUPERVISIÓN GLOBAL'),
            _buildDrawerItem(
              context,
              icon: Icons.business_center,
              title: 'GESTIÓN DE NEGOCIOS',
              color: Colors.blueGrey,
              route: (context) => const BusinessManagementScreen(),
            ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              await _apiService.logout();
              if (mounted) Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required Widget Function(BuildContext) route,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: route));
      },
    );
  }
}
