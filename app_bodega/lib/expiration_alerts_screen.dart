import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'api_service.dart';
import 'product_model.dart';

class ExpirationAlertsScreen extends StatefulWidget {
  const ExpirationAlertsScreen({super.key});

  @override
  State<ExpirationAlertsScreen> createState() => _ExpirationAlertsScreenState();
}

class _ExpirationAlertsScreenState extends State<ExpirationAlertsScreen> {
  final ApiService _apiService = ApiService();
  List<Product> _allProducts = [];
  bool _loading = true;
  int _selectedFilter = 30; // Días por defecto

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
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Product> get _filteredProducts {
    final now = DateTime.now();
    final limitDate = now.add(Duration(days: _selectedFilter));

    return _allProducts.where((p) {
      if (p.fechaVencimiento == null || p.fechaVencimiento!.isEmpty) {
        return false;
      }
      try {
        final expirationDate = DateTime.parse(p.fechaVencimiento!);
        return expirationDate.isAfter(now) &&
            expirationDate.isBefore(limitDate);
      } catch (e) {
        return false;
      }
    }).toList()..sort((a, b) {
      final dateA = DateTime.parse(a.fechaVencimiento!);
      final dateB = DateTime.parse(b.fechaVencimiento!);
      return dateA.compareTo(dateB);
    });
  }

  int _getDaysUntilExpiration(String? fechaVencimiento) {
    if (fechaVencimiento == null || fechaVencimiento.isEmpty) return 0;
    try {
      final expirationDate = DateTime.parse(fechaVencimiento);
      final now = DateTime.now();
      return expirationDate.difference(now).inDays;
    } catch (e) {
      return 0;
    }
  }

  Color _getUrgencyColor(int days) {
    if (days <= 7) return Colors.red;
    if (days <= 15) return Colors.orange;
    return Colors.amber;
  }

  IconData _getUrgencyIcon(int days) {
    if (days <= 7) return Icons.warning_amber_rounded;
    if (days <= 15) return Icons.error_outline_rounded;
    return Icons.info_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alertas de Vencimiento',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadProducts),
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
                  'Mostrar productos que vencen en:',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildFilterChip(7, 'Crítico\n7 días', Colors.red),
                    const SizedBox(width: 8),
                    _buildFilterChip(15, 'Urgente\n15 días', Colors.orange),
                    const SizedBox(width: 8),
                    _buildFilterChip(30, 'Próximo\n30 días', Colors.amber),
                  ],
                ),
              ],
            ),
          ),

          // Lista de productos
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 80,
                          color: Colors.green[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay productos próximos a vencer',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'en los próximos $_selectedFilter días',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      final daysLeft = _getDaysUntilExpiration(
                        product.fechaVencimiento,
                      );
                      final urgencyColor = _getUrgencyColor(daysLeft);
                      final urgencyIcon = _getUrgencyIcon(daysLeft);

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
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
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
                            product.nombre,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Vence: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(product.fechaVencimiento!))}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Stock: ${product.stock?.toStringAsFixed(2)} ${product.unidadMedida}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
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
                                  '$daysLeft',
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: urgencyColor,
                                  ),
                                ),
                                Text(
                                  daysLeft == 1 ? 'día' : 'días',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    color: urgencyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(int days, String label, Color color) {
    final isSelected = _selectedFilter == days;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedFilter = days),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.15)
                : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? color : Colors.grey,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? color : Colors.grey[600],
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
