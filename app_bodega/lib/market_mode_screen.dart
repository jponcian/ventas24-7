import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'product_model.dart';

class MarketModeScreen extends StatefulWidget {
  final List<Product> products;
  final Function(Product) onProductScanned;

  const MarketModeScreen({
    super.key,
    required this.products,
    required this.onProductScanned,
  });

  @override
  State<MarketModeScreen> createState() => _MarketModeScreenState();
}

class _MarketModeScreenState extends State<MarketModeScreen> {
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
        // Buscar el producto por código de barras
        try {
          final p = widget.products.firstWhere(
            (item) => item.codigoBarras == code,
          );

          setState(() {
            lastAdded = p;
            lastScanTime = now;
          });

          widget.onProductScanned(p);

          // Feedback visual rápido
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Añadido: ${p.nombre}'),
              duration: const Duration(milliseconds: 800),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          // Si no encuentra el producto, avisar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Código no encontrado: $code'),
              duration: const Duration(seconds: 1),
              backgroundColor: Colors.orange,
            ),
          );
          setState(() {
            lastScanTime = now; // Evitar spam de errores también
          });
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modo Supermercado'),
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
