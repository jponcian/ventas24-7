import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';
import 'product_model.dart';
import 'calc_screen.dart';
import 'product_form_screen.dart';
import 'scanner_screen.dart';

void main() {
  initializeDateFormatting('es_ES', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: const ProductListScreen(),
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
  final ApiService _apiService = ApiService();
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
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

  void _filter(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        final lower = query.toLowerCase();
        _filteredProducts = _allProducts
            .where(
              (p) =>
                  p.nombre.toLowerCase().contains(lower) ||
                  (p.codigoBarras?.toLowerCase().contains(lower) ?? false) ||
                  (p.proveedor?.toLowerCase().contains(lower) ?? false),
            )
            .toList();
      }
    });
  }

  Future<void> _scanBarcode() async {
    FocusScope.of(context).unfocus();

    final String? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _searchCtrl.text = result;
        _filter(result);
      });
    }
  }

  Future<void> _toggleBajoInventario(Product product) async {
    int originalId = product.id.abs();
    int newValue = (product.bajoInventario == 1) ? 0 : 1;

    try {
      Map<String, dynamic> data = {
        'id': originalId,
        'nombre': product.nombre.replaceAll(' (Paquete)', ''),
        'bajo_inventario': newValue,
        'descripcion': product.descripcion,
        'unidad_medida': product.unidadMedida == 'paquete'
            ? 'paquete'
            : 'unidad',
        'precio_compra': product.precioCompra,
        'precio_venta': product.precioVenta,
        'proveedor': product.proveedor,
        'codigo_barras': product.codigoBarras,
        'tam_paquete': product.tamPaquete,
        'precio_venta_paquete': product.precioVentaPaquete,
        'precio_venta_unidad': product.precioVentaUnidad,
      };

      bool ok = await _apiService.updateProduct(originalId, data);
      if (ok) {
        _loadData();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  double get _totalBs {
    double total = 0;
    for (var p in _allProducts) {
      if (p.qty > 0) {
        double precio = p.precioVenta ?? 0;
        bool esDolar = (p.monedaCompra != 'BS');
        double precioEnBs = esDolar ? (precio * _tasa) : precio;
        total += precioEnBs * p.qty;
      }
    }
    return total;
  }

  double get _totalUsd {
    if (_tasa == 0) return 0;
    return _totalBs / _tasa;
  }

  int get _totalItems => _allProducts.fold(0, (sum, item) => sum + item.qty);

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
                                  fontSize: 16,
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
                                    '${_totalBs.toStringAsFixed(2)} Bs',
                                    style: GoogleFonts.outfit(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1E3A8A),
                                    ),
                                  ),
                                  Text(
                                    '${_totalUsd.toStringAsFixed(2)} USD',
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
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A8A),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'CONTINUAR COMPRA',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 180,
                floating: false,
                pinned: true,
                backgroundColor: const Color(0xFF1E3A8A),
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 1.2,
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 60),
                  title: Text(
                    'Bodega Ponciano',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Opacity(
                      opacity: 0.1,
                      child: Center(
                        child: Icon(
                          Icons.inventory_2,
                          size: 150,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      bool? added = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductFormScreen(),
                        ),
                      );
                      if (added == true) _loadData();
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.calculate_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CalcScreen(tasa: _tasa > 0 ? _tasa : 0.0),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchCtrl,
                            onChanged: _filter,
                            decoration: InputDecoration(
                              hintText: 'Buscar productos...',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.qr_code_scanner,
                                  color: Color(0xFF1E3A8A),
                                ),
                                onPressed: _scanBarcode,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'BS/USD',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A8A),
                              ),
                            ),
                            Text(
                              _tasa.toStringAsFixed(2),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A8A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (_loading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_errorMessage.isNotEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.cloud_off,
                          size: 60,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(_errorMessage, textAlign: TextAlign.center),
                        ElevatedButton(
                          onPressed: _loadData,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final p = _filteredProducts[index];
                      return _buildProductCard(p);
                    }, childCount: _filteredProducts.length),
                  ),
                ),
            ],
          ),

          if (_totalItems > 0)
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: _showTicket,
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E3A8A).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_bag,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$_totalItems productos',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${_totalBs.toStringAsFixed(2)} Bs',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'VER DETALLE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product p) {
    double precio = p.precioVenta ?? 0;
    bool esDolar = p.monedaCompra != 'BS';
    String precioStr = esDolar
        ? '${precio.toStringAsFixed(2)} \$ / ${(precio * _tasa).toStringAsFixed(2)} Bs'
        : '${precio.toStringAsFixed(2)} Bs';

    bool esBajo = p.bajoInventario == 1;

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
          child: Column(
            children: [
              Padding(
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
                          if (p.proveedor != null && p.proveedor!.isNotEmpty)
                            Text(
                              'Prov: ${p.proveedor}',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            bool? updated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductFormScreen(product: p),
                              ),
                            );
                            if (updated == true) _loadData();
                          },
                          icon: const Icon(
                            Icons.edit_note_outlined,
                            color: Colors.blue,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _toggleBajoInventario(p),
                          icon: Icon(
                            esBajo ? Icons.bookmark : Icons.bookmark_border,
                            color: esBajo ? Colors.orange : Colors.grey[300],
                          ),
                          tooltip: 'Marcar Stock Bajo',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.grey[50],
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      p.unidadMedida?.toUpperCase() ?? 'UNIDAD',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                        letterSpacing: 1,
                      ),
                    ),
                    Row(
                      children: [
                        _qtyBtn(Icons.remove, () {
                          if (p.qty > 0) setState(() => p.qty--);
                        }, color: Colors.red),
                        SizedBox(
                          width: 40,
                          child: Text(
                            '${p.qty}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        _qtyBtn(Icons.add, () {
                          setState(() => p.qty++);
                        }, color: Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap, {required Color color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}
