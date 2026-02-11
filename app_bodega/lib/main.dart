// Disparo de compilación para nueva versión v1.1.1+3 - Optimus
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
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
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dashboard_screen.dart';
import 'utils.dart';
import 'inventory_report_screen.dart';
import 'admin_dashboard_screen.dart';
import 'fiados_screen.dart';
import 'fiado_model.dart';
import 'label_printing_screen.dart';
import 'sales_charts_screen.dart';
import 'product_management_screen.dart';
import 'offline_service.dart';
import 'theme_provider.dart';
import 'expiration_alerts_screen.dart';
import 'reorder_prediction_screen.dart';
import 'background_sync_service.dart';
import 'payment_methods_screen.dart';
import 'metodo_pago_model.dart';
import 'dart:async';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);

  // Inicializar sincronización en segundo plano (Solo fuera de Web)
  if (!kIsWeb) {
    try {
      await BackgroundSyncService.initialize();
      final autoSyncEnabled = await BackgroundSyncService.isAutoSyncEnabled();
      if (autoSyncEnabled) {
        await BackgroundSyncService.registerPeriodicSync();
      }
    } catch (e) {
      print('Error al inicializar sync: $e');
    }
  }

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;
  final bool biometricEnabled = prefs.getBool('biometric_enabled') ?? false;
  final String userRol = prefs.getString('user_rol') ?? 'vendedor';

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(
        isLoggedIn: isLoggedIn,
        userRol: userRol,
        biometricEnabled: biometricEnabled,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String userRol;
  final bool biometricEnabled;

  const MyApp({
    super.key,
    required this.isLoggedIn,
    required this.userRol,
    required this.biometricEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // Si tiene huella activada, siempre mandamos a login para validar
        // aunque ya esté sesión iniciada técnicamente.
        final String initialRoute = (isLoggedIn && !biometricEnabled)
            ? (userRol == 'admin' ? '/admin' : '/home')
            : '/login';

        return MaterialApp(
          title: 'Ventas 24/7',
          debugShowCheckedModeBanner: false,
          theme: ThemeProvider.lightTheme.copyWith(
            textTheme: GoogleFonts.outfitTextTheme(
              ThemeProvider.lightTheme.textTheme,
            ),
          ),
          darkTheme: ThemeProvider.darkTheme.copyWith(
            textTheme: GoogleFonts.outfitTextTheme(
              ThemeProvider.darkTheme.textTheme,
            ),
          ),
          themeMode: themeProvider.themeMode,
          initialRoute: initialRoute,
          routes: {
            '/login': (context) => const LoginScreen(),
            '/home': (context) => const DashboardScreen(),
            '/admin': (context) => const AdminDashboardScreen(),
            '/sales': (context) => const ProductListScreen(),
          },
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('es', 'ES'), Locale('en', 'US')],
        );
      },
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

  String _searchQuery = '';
  String _userName = '';
  String _negocioName = '';
  String _userRol = 'vendedor';
  List<Cliente> _clientes = [];
  Cliente? _selectedCliente;
  List<MetodoPago> _metodosPago = [];
  MetodoPago? _selectedMetodo;
  final TextEditingController _referenciaController = TextEditingController();
  final ApiService _apiService = ApiService();
  final TextEditingController _searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _pagosRealizados = [];
  int? _defaultMetodoId;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadData();
    _loadMetodos();
    _loadClientes();
    _loadDefaultMetodoPreference();
    _startSyncTimer();
  }

  Timer? _syncTimer;
  int _pendingCount = 0;

  void _startSyncTimer() {
    _syncTimer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      final pending = await OfflineService.getPendingSales();
      if (mounted) setState(() => _pendingCount = pending.length);

      if (pending.isNotEmpty) {
        for (var sale in pending) {
          try {
            final data = jsonDecode(sale['venta_data']);
            final success = await _apiService.registrarVenta(data);
            if (success) {
              await OfflineService.deletePendingVenta(sale['id']);
            }
          } catch (_) {}
        }
        final finalPending = await OfflineService.getPendingSales();
        if (mounted) setState(() => _pendingCount = finalPending.length);
      }
    });
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadDefaultMetodoPreference() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _defaultMetodoId = prefs.getInt('default_metodo_id');
      });
    }
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
            marca: p.marca,
            codigoInterno: p.codigoInterno,
            unidadMedida: p.unidadMedida,
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
            vendePorPeso: p.vendePorPeso,
            fechaVencimiento: p.fechaVencimiento,
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
              marca: p.marca,
              codigoInterno: p.codigoInterno,
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
              vendePorPeso: p.vendePorPeso,
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
          final query = _searchQuery.toLowerCase();
          return p.nombre.toLowerCase().contains(query) ||
              (p.codigoBarras != null && p.codigoBarras!.contains(query)) ||
              (p.codigoInterno != null &&
                  p.codigoInterno!.toLowerCase().contains(query)) ||
              (p.descripcion != null &&
                  p.descripcion!.toLowerCase().contains(query)) ||
              (p.proveedor != null &&
                  p.proveedor!.toLowerCase().contains(query));
        }).toList();
      }
    });
  }

  Future<void> _loadMetodos() async {
    final list = await _apiService.getMetodosPago();
    if (mounted) {
      setState(() {
        _metodosPago = list;
        if (_metodosPago.isNotEmpty && _selectedMetodo == null) {
          _selectedMetodo = _metodosPago.firstWhere(
            (m) => m.nombre == 'Efectivo',
            orElse: () => _metodosPago.first,
          );
        }
      });
    }
  }

  Future<void> _loadClientes() async {
    final list = await _apiService.getClientes();
    if (mounted) {
      setState(() => _clientes = list);
    }
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
    _referenciaController.clear();

    // Inicializar con un pago por defecto si está vacío
    if (_pagosRealizados.isEmpty) {
      MetodoPago? prefMetodo;
      if (_defaultMetodoId != null) {
        try {
          prefMetodo = _metodosPago.firstWhere((m) => m.id == _defaultMetodoId);
        } catch (_) {}
      }

      MetodoPago defaultMetodo =
          prefMetodo ??
          _metodosPago.firstWhere(
            (m) => m.nombre == 'Efectivo',
            orElse: () => _metodosPago.isNotEmpty
                ? _metodosPago.first
                : MetodoPago(
                    id: 1,
                    negocioId: 1,
                    nombre: 'Efectivo',
                    requiereReferencia: false,
                  ),
          );

      _pagosRealizados.add({
        'metodo': defaultMetodo,
        'monto_usd': 0.0,
        'monto_bs': 0.0,
        'referencia': '',
        'ctrl_usd': TextEditingController(text: '0.00'),
        'ctrl_bs': TextEditingController(text: '0.00'),
        'ctrl_ref': TextEditingController(),
      });
    }

    _selectedCliente = null;

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
                if (Navigator.canPop(context)) Navigator.pop(context);
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
              totalUsd +=
                  (esDolar ? precio : precio / (_tasa > 0 ? _tasa : 1)) * p.qty;
            }

            // Si es la primera vez que abrimos con items, seteamos el primer pago al total
            if (_pagosRealizados.length == 1 &&
                _pagosRealizados[0]['monto_usd'] == 0) {
              _pagosRealizados[0]['monto_usd'] = totalUsd;
              _pagosRealizados[0]['monto_bs'] = totalBs;
              _pagosRealizados[0]['ctrl_usd'].text = totalUsd.toStringAsFixed(
                2,
              );
              _pagosRealizados[0]['ctrl_bs'].text = totalBs.toStringAsFixed(2);
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
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
                                for (var p in _allProducts) p.qty = 0;
                                _pagosRealizados.clear();
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
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (p.qty > 1) p.qty--;
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.nombre,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        '${precioBs.toStringAsFixed(2)} Bs (\$${(esDolar ? precio : precio / (_tasa > 0 ? _tasa : 1)).toStringAsFixed(2)}) c/u',
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
                      padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: const Offset(0, -4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
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
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'FORMA DE PAGO',
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                          letterSpacing: 1.1,
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          setModalState(() {
                                            _pagosRealizados.add({
                                              'metodo': _metodosPago.first,
                                              'monto_usd': 0.0,
                                              'monto_bs': 0.0,
                                              'referencia': '',
                                              'ctrl_usd': TextEditingController(
                                                text: '0.00',
                                              ),
                                              'ctrl_bs': TextEditingController(
                                                text: '0.00',
                                              ),
                                              'ctrl_ref':
                                                  TextEditingController(),
                                            });
                                          });
                                        },
                                        icon: const Icon(Icons.add, size: 16),
                                        label: const Text('Dividir Pago'),
                                      ),
                                    ],
                                  ),
                                  ..._pagosRealizados.asMap().entries.map((
                                    entry,
                                  ) {
                                    int idx = entry.key;
                                    var pago = entry.value;

                                    double pagadoOtros = _pagosRealizados
                                        .asMap()
                                        .entries
                                        .where((e) => e.key != idx)
                                        .fold(
                                          0.0,
                                          (sum, e) =>
                                              sum + e.value['monto_usd'],
                                        );
                                    double restanteItem =
                                        totalUsd - pagadoOtros;

                                    return Column(
                                      children: [
                                        if (idx > 0) const Divider(),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child:
                                                  DropdownButtonFormField<
                                                    MetodoPago
                                                  >(
                                                    value: pago['metodo'],
                                                    isExpanded: true,
                                                    items: _metodosPago
                                                        .map(
                                                          (
                                                            m,
                                                          ) => DropdownMenuItem(
                                                            value: m,
                                                            child: Text(
                                                              m.nombre,
                                                              style:
                                                                  const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                    onChanged: (val) {
                                                      if (val != null) {
                                                        setModalState(
                                                          () => pago['metodo'] =
                                                              val,
                                                        );
                                                      }
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                          labelText: 'Método',
                                                          contentPadding:
                                                              EdgeInsets.symmetric(
                                                                horizontal: 12,
                                                              ),
                                                        ),
                                                  ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              flex: 1,
                                              child: InkWell(
                                                onTap: () async {
                                                  bool isUsd = false;
                                                  double startingVal =
                                                      pago['monto_bs'];

                                                  TextEditingController
                                                  amountCtrl =
                                                      TextEditingController(
                                                        text: startingVal > 0
                                                            ? startingVal
                                                                  .toStringAsFixed(
                                                                    2,
                                                                  )
                                                            : '',
                                                      );

                                                  await showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return StatefulBuilder(
                                                        builder: (context, setDialogState) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                              'Ingresar Monto',
                                                            ),
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      isUsd
                                                                          ? "Dólares (USD)"
                                                                          : "Bolivianos (Bs)",
                                                                      style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Switch(
                                                                      value:
                                                                          isUsd,
                                                                      activeColor:
                                                                          Colors
                                                                              .green,
                                                                      onChanged: (val) {
                                                                        setDialogState(() {
                                                                          double?
                                                                          current = double.tryParse(
                                                                            amountCtrl.text,
                                                                          );
                                                                          isUsd =
                                                                              val;
                                                                          if (current !=
                                                                              null) {
                                                                            if (isUsd) {
                                                                              // De Bs a USD
                                                                              amountCtrl.text =
                                                                                  (current /
                                                                                          (_tasa >
                                                                                                  0
                                                                                              ? _tasa
                                                                                              : 1))
                                                                                      .toStringAsFixed(
                                                                                        2,
                                                                                      );
                                                                            } else {
                                                                              // De USD a Bs
                                                                              amountCtrl.text =
                                                                                  (current *
                                                                                          _tasa)
                                                                                      .toStringAsFixed(
                                                                                        2,
                                                                                      );
                                                                            }
                                                                          }
                                                                        });
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                TextField(
                                                                  controller:
                                                                      amountCtrl,
                                                                  keyboardType:
                                                                      const TextInputType.numberWithOptions(
                                                                        decimal:
                                                                            true,
                                                                      ),
                                                                  autofocus:
                                                                      true,
                                                                  inputFormatters: [
                                                                    SlidingDecimalFormatter(),
                                                                  ],
                                                                  decoration: InputDecoration(
                                                                    labelText:
                                                                        'Monto',
                                                                    suffixText:
                                                                        isUsd
                                                                        ? '\$'
                                                                        : 'Bs',
                                                                    border:
                                                                        const OutlineInputBorder(),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    TextButton(
                                                                      onPressed: () {
                                                                        double
                                                                        sugerido =
                                                                            isUsd
                                                                            ? restanteItem
                                                                            : restanteItem *
                                                                                  _tasa;
                                                                        amountCtrl
                                                                            .text = sugerido
                                                                            .toStringAsFixed(
                                                                              2,
                                                                            );
                                                                      },
                                                                      child: const Text(
                                                                        'Completar',
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                      context,
                                                                    ),
                                                                child:
                                                                    const Text(
                                                                      'CANCELAR',
                                                                    ),
                                                              ),
                                                              FilledButton(
                                                                onPressed: () {
                                                                  double?
                                                                  val = double.tryParse(
                                                                    amountCtrl
                                                                        .text,
                                                                  );
                                                                  if (val !=
                                                                      null) {
                                                                    double
                                                                    valUsd =
                                                                        isUsd
                                                                        ? val
                                                                        : (val /
                                                                              (_tasa > 0
                                                                                  ? _tasa
                                                                                  : 1));
                                                                    pago['monto_usd'] =
                                                                        valUsd;
                                                                    pago['monto_bs'] =
                                                                        valUsd *
                                                                        _tasa;
                                                                    pago['ctrl_usd']
                                                                            .text =
                                                                        pago['monto_usd']
                                                                            .toStringAsFixed(
                                                                              2,
                                                                            );
                                                                    pago['ctrl_bs']
                                                                            .text =
                                                                        pago['monto_bs']
                                                                            .toStringAsFixed(
                                                                              2,
                                                                            );
                                                                    setModalState(
                                                                      () {},
                                                                    );
                                                                    Navigator.pop(
                                                                      context,
                                                                    );
                                                                  }
                                                                },
                                                                child:
                                                                    const Text(
                                                                      'ACEPTAR',
                                                                    ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                                child: IgnorePointer(
                                                  child: TextField(
                                                    controller:
                                                        pago['ctrl_usd'],
                                                    decoration:
                                                        const InputDecoration(
                                                          labelText: 'Monto \$',
                                                          hintText:
                                                              'Toca p/ ingresar',
                                                        ),
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (_pagosRealizados.length > 1)
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.remove_circle_outline,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  setModalState(() {
                                                    _pagosRealizados.removeAt(
                                                      idx,
                                                    );
                                                  });
                                                },
                                              ),
                                          ],
                                        ),
                                        if (pago['metodo']
                                                ?.requiereReferencia ==
                                            true)
                                          TextField(
                                            controller: pago['ctrl_ref'],
                                            decoration: const InputDecoration(
                                              labelText:
                                                  'Referencia / Depósito',
                                            ),
                                            onChanged: (val) =>
                                                pago['referencia'] = val,
                                          ),
                                        if (pago['metodo']?.nombre == 'Crédito')
                                          DropdownButtonFormField<Cliente>(
                                            value: _selectedCliente,
                                            isExpanded: true,
                                            decoration: const InputDecoration(
                                              labelText: 'Cliente Crédito',
                                            ),
                                            items: _clientes
                                                .map(
                                                  (c) => DropdownMenuItem(
                                                    value: c,
                                                    child: Text(
                                                      c.nombre,
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (val) {
                                              setModalState(() {
                                                _selectedCliente = val;
                                              });
                                            },
                                          ),
                                      ],
                                    );
                                  }).toList(),
                                  const SizedBox(height: 12),
                                  Builder(
                                    builder: (context) {
                                      double pagado = _pagosRealizados.fold(
                                        0.0,
                                        (sum, p) => sum + p['monto_usd'],
                                      );
                                      double restante = totalUsd - pagado;
                                      bool pendiente = restante > 0.01;
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            pendiente
                                                ? 'Resta p/ pagar:'
                                                : 'Completo',
                                            style: TextStyle(
                                              color: pendiente
                                                  ? Colors.red
                                                  : Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            '${restante.abs().toStringAsFixed(2)} USD (${(restante.abs() * _tasa).toStringAsFixed(2)} Bs)',
                                            style: TextStyle(
                                              color: pendiente
                                                  ? Colors.red
                                                  : Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () async {
                                  double pagado = _pagosRealizados.fold(
                                    0.0,
                                    (sum, p) => sum + p['monto_usd'],
                                  );
                                  if ((totalUsd - pagado).abs() > 0.01) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'El total pagado debe coincidir con el total de la venta',
                                        ),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                    return;
                                  }

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

                                  // Validar créditos si existen
                                  bool hasCredito = _pagosRealizados.any(
                                    (p) => p['metodo'].nombre == 'Crédito',
                                  );
                                  if (hasCredito && _selectedCliente == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Debes seleccionar un cliente para el crédito',
                                        ),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                    return;
                                  }

                                  final items = selected.map((p) {
                                    double precio = p.precioVenta ?? 0;
                                    bool esDolar = p.monedaCompra != 'BS';
                                    return {
                                      'id': p.id.abs(),
                                      'cantidad': p.qty,
                                      'multiplicador': (p.id < 0)
                                          ? (p.tamPaquete ?? 1.0)
                                          : 1.0,
                                      'precio_bs': esDolar
                                          ? precio * _tasa
                                          : precio,
                                    };
                                  }).toList();

                                  final pagosData = _pagosRealizados
                                      .map(
                                        (p) => {
                                          'metodo_pago_id': p['metodo'].id,
                                          'monto_bs': p['monto_bs'],
                                          'monto_usd': p['monto_usd'],
                                          'referencia': p['ctrl_ref'].text,
                                        },
                                      )
                                      .toList();

                                  final ventaData = {
                                    'total_bs': totalBs,
                                    'total_usd': totalUsd,
                                    'tasa': _tasa,
                                    'detalles': items,
                                    'metodo_pago_id':
                                        _pagosRealizados.first['metodo'].id,
                                    'cliente_id': _selectedCliente?.id,
                                    'referencia':
                                        _pagosRealizados.first['ctrl_ref'].text,
                                    'pagos': pagosData,
                                  };

                                  Navigator.pop(context);
                                  setState(() => _loading = true);

                                  bool success = await _apiService
                                      .registrarVenta(ventaData);

                                  if (success) {
                                    setState(() {
                                      for (var p in _allProducts) p.qty = 0;
                                      _pagosRealizados.clear();
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
                                    if (!hasCredito) {
                                      await OfflineService.savePendingVenta(
                                        ventaData,
                                      );
                                      setState(() {
                                        for (var p in _allProducts) p.qty = 0;
                                        _pagosRealizados.clear();
                                        _pendingCount++;
                                      });
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Sin conexión. Venta guardada localmente.',
                                          ),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                    } else {
                                      setState(() => _loading = false);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Error al procesar crédito. Verifique su conexión.',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
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
                  'Genera etiquetas para los últimos 15 cambios',
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
                bool showAsUsd = (p.monedaBase != 'BS' && precio > 0);

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
                      pw.Text(
                        '${precio.toStringAsFixed(2)} ${showAsUsd ? 'USD' : 'BS'}',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 24,
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

  Future<List<int>?> _showSelectionDialog() async {
    // Variables locales del diálogo
    Set<int> selectedIds = {};
    List<Product> displayList = List.from(_allProducts);
    TextEditingController searchCtrl = TextEditingController();

    return showDialog<List<int>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void filterList(String query) {
              setModalState(() {
                if (query.isEmpty) {
                  displayList = List.from(_allProducts);
                } else {
                  displayList = _allProducts.where((p) {
                    final q = query.toLowerCase();
                    return p.nombre.toLowerCase().contains(q) ||
                        (p.codigoBarras ?? '').contains(q);
                  }).toList();
                }
              });
            }

            return AlertDialog(
              title: const Text('Seleccionar Productos'),
              content: SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchCtrl,
                      decoration: InputDecoration(
                        labelText: 'Buscar producto...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: searchCtrl.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  searchCtrl.clear();
                                  filterList('');
                                },
                              )
                            : null,
                      ),
                      onChanged: filterList,
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: displayList.isEmpty
                          ? const Center(child: Text('No hay resultados'))
                          : ListView.builder(
                              itemCount: displayList.length,
                              itemBuilder: (ctx, i) {
                                final p = displayList[i];
                                final isSelected = selectedIds.contains(p.id);
                                return CheckboxListTile(
                                  title: Text(p.nombre),
                                  subtitle: Text(
                                    'Ref: ${p.precioReal.toStringAsFixed(2)}',
                                  ),
                                  value: isSelected,
                                  onChanged: (val) {
                                    setModalState(() {
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
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '${selectedIds.length} productos seleccionados',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: selectedIds.isEmpty
                      ? null
                      : () => Navigator.pop(context, selectedIds.toList()),
                  child: const Text('Confirmar Selección'),
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
          if (_pendingCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
                label: Text(
                  '$_pendingCount',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                backgroundColor: Colors.orange,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
            ),
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
      // floatingActionButton removed
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
            color: Colors.black.withValues(alpha: 0.05),
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

  void _showWeightEntryDialog(Product p) {
    final TextEditingController weightCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ingresar Peso (${p.unidadMedida})'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(p.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: weightCtrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              inputFormatters: [WeightDecimalFormatter()],
              decoration: InputDecoration(
                labelText: 'Peso / Cantidad',
                suffixText: p.unidadMedida,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              final double? weight = double.tryParse(weightCtrl.text);
              if (weight != null && weight > 0) {
                setState(() {
                  p.qty += weight;
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
              foregroundColor: Colors.white,
            ),
            child: const Text('AÑADIR'),
          ),
        ],
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
    double precioUsd = esDolar ? precio : (precio / (_tasa > 0 ? _tasa : 1));
    String precioStr =
        '${precioBs.toStringAsFixed(2)} Bs (\$${precioUsd.toStringAsFixed(2)})';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onLongPress: () async {
              Product productToEdit = p;
              if (p.id < 0) {
                final originalId = p.id.abs();
                final original = _allProducts.firstWhere(
                  (prod) => prod.id == originalId,
                  orElse: () => p,
                );
                productToEdit = original;
              }

              final res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductFormScreen(product: productToEdit),
                ),
              );
              if (res == true) _loadData();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: esBajo ? Colors.orange[50] : Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      esBajo
                          ? Icons.warning_amber_rounded
                          : Icons.inventory_2_outlined,
                      color: esBajo ? Colors.orange : const Color(0xFF1E3A8A),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.codigoInterno != null && p.codigoInterno!.isNotEmpty
                              ? '(${p.codigoInterno}) ${p.nombre}'
                              : p.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          precioStr,
                          style: const TextStyle(
                            color: Color(0xFF1E3A8A),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Stock: ${p.stock?.toStringAsFixed(p.stock! % 1 == 0 ? 0 : 2) ?? "0"}',
                          style: TextStyle(
                            color: esBajo ? Colors.red : Colors.green[700],
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
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
                        onPressed: () {
                          if (p.isByWeight) {
                            _showWeightEntryDialog(p);
                          } else {
                            setState(() => p.qty++);
                          }
                        },
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
  List<dynamic> _negocios = [];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final String? negsJson = prefs.getString('user_negocios');
    if (negsJson != null) {
      try {
        _negocios = jsonDecode(negsJson);
      } catch (_) {}
    }
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Usuario';
      _negocioName = prefs.getString('negocio_nombre') ?? 'Ventas 24/7';
      _userRol = prefs.getString('user_rol') ?? 'vendedor';
    });
  }

  void _switchNegocio() async {
    if (_negocios.length < 2) return;

    final Map<String, dynamic>? selected = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar de Negocio'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _negocios.length,
            itemBuilder: (context, i) {
              final n = _negocios[i];
              final bool isCurrent = n['nombre'] == _negocioName;
              return ListTile(
                leading: Icon(
                  Icons.business,
                  color: isCurrent ? Colors.green : Colors.blue,
                ),
                title: Text(
                  n['nombre'],
                  style: TextStyle(
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCurrent ? Colors.green : Colors.black87,
                  ),
                ),
                trailing: isCurrent
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
                onTap: isCurrent ? null : () => Navigator.pop(context, n),
              );
            },
          ),
        ),
      ),
    );

    if (selected != null) {
      await _apiService.setNegocio(
        selected['id'] as int,
        selected['nombre'] as String,
      );
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          (_userRol == 'admin' || _userRol == 'superadmin')
              ? '/admin'
              : '/home',
          (route) => false,
        );
      }
    }
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
          if (_negocios.length > 1)
            ListTile(
              leading: const Icon(Icons.swap_horiz, color: Colors.blue),
              title: const Text(
                'Cambiar Negocio',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              subtitle: Text('Estás en: $_negocioName'),
              onTap: _switchNegocio,
            ),
          ListTile(
            leading: const Icon(
              Icons.dashboard_outlined,
              color: Color(0xFF1E3A8A),
            ),
            title: const Text('Resumen Dashboard'),
            onTap: () {
              Navigator.pop(context);
              // Si es admin, abre dashboard administrativo, si no, el normal
              if (_userRol == 'administrador' ||
                  _userRol == 'admin' ||
                  _userRol == 'superadmin') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminDashboardScreen(),
                  ),
                );
              } else {
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
          ),
          _buildSectionHeader('OPERACIONES'),
          ListTile(
            leading: const Icon(
              Icons.shopping_cart_outlined,
              color: Color(0xFF1E3A8A),
            ),
            title: const Text('Panel de Ventas (Facturación)'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/sales');
            },
          ),
          if (_userRol == 'administrador' ||
              _userRol == 'admin' ||
              _userRol == 'superadmin') ...[
            const Divider(),
            _buildSectionHeader('CATÁLOGO Y MAESTROS'),
            _buildDrawerItem(
              context,
              icon: Icons.inventory_2_rounded,
              title: 'Catálogo de Productos',
              color: Colors.teal,
              route: (context) => const ProductManagementScreen(),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.print_rounded,
              title: 'Diseño e Impresión de Etiquetas',
              color: Colors.blueGrey,
              route: (context) => const LabelPrintingScreen(),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.payments_rounded,
              title: 'Formas de Pago',
              color: Colors.indigo,
              route: (context) => const PaymentMethodsScreen(),
            ),
            const Divider(),
            _buildSectionHeader('CRÉDITOS Y FIADOS'),
            _buildDrawerItem(
              context,
              icon: Icons.credit_card,
              title: 'Gestión de Fiados',
              color: Colors.deepOrange,
              route: (context) => const FiadosScreen(),
            ),
          ],
          if (_userRol == 'administrador' ||
              _userRol == 'admin' ||
              _userRol == 'superadmin') ...[
            const Divider(),
            _buildSectionHeader('COMPRAS E INVENTARIO'),
            _buildDrawerItem(
              context,
              icon: Icons.add_shopping_cart,
              title: 'Cargar Compra (Entrada)',
              color: Colors.green,
              route: (context) => PurchaseScreen(),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.history,
              title: 'Historial de Compras',
              color: Colors.blueGrey,
              route: (context) => const HistoryScreen(),
            ),
          ],
          const Divider(),
          _buildSectionHeader('REPORTES'),
          _buildDrawerItem(
            context,
            icon: Icons.assessment_rounded,
            title: 'Mis Ventas del Día',
            color: Colors.blue,
            route: (context) => const ReportSalesScreen(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.insights_rounded,
            title: 'Análisis de Ventas',
            color: Colors.indigo,
            route: (context) => const SalesChartsScreen(),
          ),
          if (_userRol == 'administrador' ||
              _userRol == 'admin' ||
              _userRol == 'superadmin') ...[
            _buildDrawerItem(
              context,
              icon: Icons.receipt_long_rounded,
              title: 'Reporte de Compras',
              color: Colors.deepPurple,
              route: (context) => const ReportPurchasesScreen(),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.inventory_outlined,
              title: 'Inventario Actual',
              color: Colors.blueAccent,
              route: (context) => const InventoryReportScreen(),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.warning_amber_rounded,
              title: 'Alerta de Stock Bajo',
              color: Colors.orange,
              route: (context) => const LowStockScreen(),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.event_busy_rounded,
              title: 'Alertas de Vencimiento',
              color: Colors.red,
              route: (context) => const ExpirationAlertsScreen(),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.analytics_outlined,
              title: 'Predicción de Reabastecimiento',
              color: Colors.purple,
              route: (context) => const ReorderPredictionScreen(),
            ),
          ],
          if (_userRol == 'administrador' ||
              _userRol == 'admin' ||
              _userRol == 'superadmin') ...[
            const Divider(),
            _buildSectionHeader('SISTEMA'),
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
          // TODO: Descomentar cuando se termine el modo oscuro
          /* Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return SwitchListTile(
                secondary: Icon(
                  themeProvider.isDarkMode
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  color: themeProvider.isDarkMode
                      ? Colors.amber
                      : const Color(0xFF1E3A8A),
                ),
                title: const Text(
                  'Modo Oscuro',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  themeProvider.isDarkMode ? 'Activado' : 'Desactivado',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
          const Divider(), */
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              await _apiService.logout();
              if (mounted) {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
              if (mounted) Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          const SizedBox(height: 50), // Espacio para botones de Android
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
