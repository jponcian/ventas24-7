import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';
import 'reorder_prediction_service.dart';

class ReorderPredictionScreen extends StatefulWidget {
  const ReorderPredictionScreen({super.key});

  @override
  State<ReorderPredictionScreen> createState() =>
      _ReorderPredictionScreenState();
}

class _ReorderPredictionScreenState extends State<ReorderPredictionScreen> {
  final ApiService _apiService = ApiService();
  List<StockPrediction> _predictions = [];
  bool _loading = true;
  String _filterLevel = 'all'; // all, critical, urgent, warning

  @override
  void initState() {
    super.initState();
    _loadPredictions();
  }

  Future<void> _loadPredictions() async {
    setState(() => _loading = true);
    try {
      // Obtener historial de ventas de TODOS los productos en una sola llamada
      final productsWithSales = await _apiService.getAllProductsSalesHistory();

      final predictions = <StockPrediction>[];

      for (var productData in productsWithSales) {
        final productId = productData['producto_id'];
        final productName = productData['producto_nombre'] ?? 'Producto';
        final stock =
            double.tryParse(productData['stock']?.toString() ?? '0') ?? 0.0;
        final salesHistory = List<Map<String, dynamic>>.from(
          productData['ventas'] ?? [],
        );

        if (stock > 0) {
          final prediction = ReorderPredictionService.calculatePrediction(
            productId: productId,
            productName: productName,
            currentStock: stock,
            salesHistory: salesHistory,
          );

          predictions.add(prediction);
        }
      }

      // Ordenar por urgencia
      predictions.sort((a, b) {
        final urgencyOrder = {
          'critical': 0,
          'urgent': 1,
          'warning': 2,
          'normal': 3,
        };
        final aOrder = urgencyOrder[a.urgencyLevel] ?? 999;
        final bOrder = urgencyOrder[b.urgencyLevel] ?? 999;
        return aOrder.compareTo(bOrder);
      });

      setState(() {
        _predictions = predictions;
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar predicciones: $e')),
        );
      }
    }
  }

  List<StockPrediction> get _filteredPredictions {
    if (_filterLevel == 'all') return _predictions;
    return _predictions.where((p) => p.urgencyLevel == _filterLevel).toList();
  }

  Color _getUrgencyColor(String level) {
    switch (level) {
      case 'critical':
        return Colors.red;
      case 'urgent':
        return Colors.orange;
      case 'warning':
        return Colors.amber;
      default:
        return Colors.green;
    }
  }

  IconData _getUrgencyIcon(String level) {
    switch (level) {
      case 'critical':
        return Icons.error;
      case 'urgent':
        return Icons.warning_amber_rounded;
      case 'warning':
        return Icons.info_outline;
      default:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredPredictions = _filteredPredictions;
    final needsReorderCount = _predictions.where((p) => p.needsReorder).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Predicción de Reabastecimiento',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (needsReorderCount > 0)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.shopping_cart,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$needsReorderCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPredictions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filtrar por urgencia:',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('all', 'Todos', Colors.grey),
                      const SizedBox(width: 8),
                      _buildFilterChip('critical', 'Crítico', Colors.red),
                      const SizedBox(width: 8),
                      _buildFilterChip('urgent', 'Urgente', Colors.orange),
                      const SizedBox(width: 8),
                      _buildFilterChip('warning', 'Advertencia', Colors.amber),
                      const SizedBox(width: 8),
                      _buildFilterChip('normal', 'Normal', Colors.green),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Lista de predicciones
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : filteredPredictions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay productos en esta categoría',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredPredictions.length,
                    itemBuilder: (context, index) {
                      final prediction = filteredPredictions[index];
                      final urgencyColor = _getUrgencyColor(
                        prediction.urgencyLevel,
                      );
                      final urgencyIcon = _getUrgencyIcon(
                        prediction.urgencyLevel,
                      );

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: urgencyColor.withValues(alpha: 0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ExpansionTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: urgencyColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              urgencyIcon,
                              color: urgencyColor,
                              size: 28,
                            ),
                          ),
                          title: Text(
                            prediction.productName,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                ReorderPredictionService.getUrgencyMessage(
                                  prediction.urgencyLevel,
                                ),
                                style: TextStyle(
                                  color: urgencyColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Stock actual: ${prediction.currentStock.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: urgencyColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${prediction.daysUntilStockout}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: urgencyColor,
                                  ),
                                ),
                                Text(
                                  'días',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    color: urgencyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDetailRow(
                                    'Ventas diarias promedio:',
                                    '${prediction.averageDailySales.toStringAsFixed(2)} unidades',
                                    Icons.trending_up,
                                  ),
                                  const SizedBox(height: 8),
                                  _buildDetailRow(
                                    'Fecha estimada de agotamiento:',
                                    ReorderPredictionService.formatStockoutDate(
                                      prediction.estimatedStockoutDate,
                                    ),
                                    Icons.event,
                                  ),
                                  const SizedBox(height: 8),
                                  _buildDetailRow(
                                    'Cantidad recomendada a ordenar:',
                                    '${prediction.recommendedOrderQuantity.toStringAsFixed(0)} unidades',
                                    Icons.shopping_cart,
                                  ),
                                  if (prediction.needsReorder) ...[
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          // TODO: Navegar a pantalla de compra
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Funcionalidad de pedido en desarrollo',
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.add_shopping_cart,
                                        ),
                                        label: const Text(
                                          'Crear Orden de Compra',
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: urgencyColor,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, Color color) {
    final isSelected = _filterLevel == value;
    final count = value == 'all'
        ? _predictions.length
        : _predictions.where((p) => p.urgencyLevel == value).length;

    return InkWell(
      onTap: () => setState(() => _filterLevel = value),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey[600],
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
