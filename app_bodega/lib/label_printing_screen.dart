import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'api_service.dart';
import 'product_model.dart';

class LabelPrintingScreen extends StatefulWidget {
  const LabelPrintingScreen({super.key});

  @override
  State<LabelPrintingScreen> createState() => _LabelPrintingScreenState();
}

class _LabelPrintingScreenState extends State<LabelPrintingScreen> {
  final ApiService _apiService = ApiService();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  Set<int> _selectedIds = {};
  bool _loading = true;
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _loading = true);
    try {
      final products = await _apiService.getProducts();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar productos: $e')));
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
                  p.codigoBarras!.contains(_searchQuery));
        }).toList();
      }
    });
  }

  Future<void> _generarPDF() async {
    if (_selectedIds.isEmpty) return;

    final productsToPrint = _allProducts
        .where((p) => _selectedIds.contains(p.id))
        .toList();

    // Ordenar por fecha de actualización (más recientes primero)
    productsToPrint.sort((a, b) {
      final dateA = DateTime.tryParse(a.updatedAt ?? '') ?? DateTime(2000);
      final dateB = DateTime.tryParse(b.updatedAt ?? '') ?? DateTime(2000);
      return dateB.compareTo(dateA);
    });

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

  void _selectLast15() {
    List<Product> sorted = List.from(_allProducts);
    sorted.sort((a, b) {
      final dateA = DateTime.tryParse(a.updatedAt ?? '') ?? DateTime(2000);
      final dateB = DateTime.tryParse(b.updatedAt ?? '') ?? DateTime(2000);
      return dateB.compareTo(dateA);
    });

    setState(() {
      _selectedIds = sorted.take(15).map((p) => p.id).toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imprimir Etiquetas'),
        actions: [
          TextButton(
            onPressed: _selectLast15,
            child: const Text(
              'Últimos 15',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchCtrl,
              onChanged: _filter,
              decoration: InputDecoration(
                hintText: 'Buscar producto...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final p = _filteredProducts[index];
                      final isSelected = _selectedIds.contains(p.id);
                      return CheckboxListTile(
                        title: Text(p.nombre),
                        subtitle: Text('Código: ${p.codigoBarras ?? 'N/A'}'),
                        value: isSelected,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              _selectedIds.add(p.id);
                            } else {
                              _selectedIds.remove(p.id);
                            }
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: _selectedIds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _generarPDF,
              label: Text('Imprimir (${_selectedIds.length})'),
              icon: const Icon(Icons.print),
              backgroundColor: const Color(0xFF1E3A8A),
            )
          : null,
    );
  }
}
