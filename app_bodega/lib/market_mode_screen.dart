import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'product_model.dart';

class QuickSaleScreen extends StatefulWidget {
  final List<Product> products;
  final Function(Product, double) onProductScanned;

  const QuickSaleScreen({
    super.key,
    required this.products,
    required this.onProductScanned,
  });

  @override
  State<QuickSaleScreen> createState() => _QuickSaleScreenState();
}

class _QuickSaleScreenState extends State<QuickSaleScreen> {
  final MobileScannerController controller = MobileScannerController();
  Product? lastAdded;
  DateTime? lastScanTime;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleCapture(BarcodeCapture capture) {
    final now = DateTime.now();
    // Debounce de 1.5 segundos para no escanear el mismo artículo mil veces seguidas
    if (lastScanTime != null &&
        now.difference(lastScanTime!).inMilliseconds < 1500) {
      return;
    }

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final code = barcode.rawValue;
      if (code != null) {
        try {
          final p = widget.products.firstWhere(
            (item) => item.codigoBarras == code,
          );

          if (p.isByWeight) {
            controller.stop();
            _showWeightDialog(p);
          } else {
            _addProduct(p, 1.0);
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Código no encontrado: $code'),
              duration: const Duration(seconds: 1),
              backgroundColor: Colors.orange,
            ),
          );
          setState(() {
            lastScanTime = now;
          });
        }
        break;
      }
    }
  }

  void _addProduct(Product p, double quantity) {
    setState(() {
      lastAdded = p;
      lastScanTime = DateTime.now();
    });

    widget.onProductScanned(p, quantity);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Añadido: ${p.nombre} (${p.isByWeight ? quantity.toStringAsFixed(3) : quantity.toInt()} ${p.unidadMedida})',
        ),
        duration: const Duration(milliseconds: 800),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _showWeightDialog(Product p) async {
    final TextEditingController weightCtrl = TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Ingresar Peso (${p.unidadMedida})'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(p.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: weightCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              autofocus: true,
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
            onPressed: () {
              Navigator.pop(context);
              controller.start();
            },
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              final double? weight = double.tryParse(weightCtrl.text);
              if (weight != null && weight > 0) {
                Navigator.pop(context);
                _addProduct(p, weight);
                controller.start();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venta Rápida'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          MobileScanner(controller: controller, onDetect: _handleCapture),
          // Overlay de visor
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          // Información del último producto
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: AnimatedOpacity(
              opacity: lastAdded != null ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Último añadido:',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            lastAdded?.nombre ?? '',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context),
        label: const Text('Ver Carrito'),
        icon: const Icon(Icons.shopping_cart),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
    );
  }
}
