import 'package:intl/intl.dart';

class StockPrediction {
  final int productId;
  final String productName;
  final double currentStock;
  final double averageDailySales;
  final int daysUntilStockout;
  final DateTime? estimatedStockoutDate;
  final bool needsReorder;
  final double recommendedOrderQuantity;
  final String urgencyLevel; // 'critical', 'urgent', 'normal'

  StockPrediction({
    required this.productId,
    required this.productName,
    required this.currentStock,
    required this.averageDailySales,
    required this.daysUntilStockout,
    this.estimatedStockoutDate,
    required this.needsReorder,
    required this.recommendedOrderQuantity,
    required this.urgencyLevel,
  });
}

class ReorderPredictionService {
  /// Calcula la predicción de reabastecimiento basada en el historial de ventas
  static StockPrediction calculatePrediction({
    required int productId,
    required String productName,
    required double currentStock,
    required List<Map<String, dynamic>> salesHistory,
    int analysisWindowDays = 30,
    int reorderLeadTimeDays = 7,
    double safetyStockMultiplier = 1.5,
  }) {
    // Calcular ventas diarias promedio
    final averageDailySales = _calculateAverageDailySales(
      salesHistory,
      analysisWindowDays,
    );

    // Calcular días hasta agotamiento
    int daysUntilStockout = 0;
    DateTime? estimatedStockoutDate;

    if (averageDailySales > 0) {
      daysUntilStockout = (currentStock / averageDailySales).floor();
      estimatedStockoutDate = DateTime.now().add(
        Duration(days: daysUntilStockout),
      );
    } else {
      daysUntilStockout = 999; // Stock suficiente si no hay ventas
    }

    // Determinar si necesita reorden
    final needsReorder = daysUntilStockout <= reorderLeadTimeDays;

    // Calcular cantidad recomendada de reorden
    final recommendedOrderQuantity = _calculateReorderQuantity(
      averageDailySales,
      analysisWindowDays,
      safetyStockMultiplier,
    );

    // Determinar nivel de urgencia
    String urgencyLevel;
    if (daysUntilStockout <= 3) {
      urgencyLevel = 'critical';
    } else if (daysUntilStockout <= 7) {
      urgencyLevel = 'urgent';
    } else if (daysUntilStockout <= 14) {
      urgencyLevel = 'warning';
    } else {
      urgencyLevel = 'normal';
    }

    return StockPrediction(
      productId: productId,
      productName: productName,
      currentStock: currentStock,
      averageDailySales: averageDailySales,
      daysUntilStockout: daysUntilStockout,
      estimatedStockoutDate: estimatedStockoutDate,
      needsReorder: needsReorder,
      recommendedOrderQuantity: recommendedOrderQuantity,
      urgencyLevel: urgencyLevel,
    );
  }

  /// Calcula el promedio de ventas diarias
  static double _calculateAverageDailySales(
    List<Map<String, dynamic>> salesHistory,
    int windowDays,
  ) {
    if (salesHistory.isEmpty) return 0.0;

    final cutoffDate = DateTime.now().subtract(Duration(days: windowDays));
    double totalQuantity = 0.0;
    int validDays = 0;

    // Agrupar ventas por día
    final Map<String, double> salesByDay = {};

    for (var sale in salesHistory) {
      try {
        final saleDate = DateTime.parse(sale['fecha_venta'] ?? sale['fecha']);
        if (saleDate.isAfter(cutoffDate)) {
          final dateKey = DateFormat('yyyy-MM-dd').format(saleDate);
          final quantity =
              double.tryParse(sale['cantidad']?.toString() ?? '0') ?? 0.0;
          salesByDay[dateKey] = (salesByDay[dateKey] ?? 0.0) + quantity;
        }
      } catch (e) {
        // Ignorar registros con fechas inválidas
      }
    }

    // Calcular promedio
    if (salesByDay.isEmpty) return 0.0;

    totalQuantity = salesByDay.values.reduce((a, b) => a + b);
    validDays = salesByDay.length;

    return validDays > 0 ? totalQuantity / validDays : 0.0;
  }

  /// Calcula la cantidad recomendada de reorden
  static double _calculateReorderQuantity(
    double averageDailySales,
    int daysToOrder,
    double safetyMultiplier,
  ) {
    if (averageDailySales <= 0) return 0.0;

    // Cantidad base: ventas esperadas durante el período de reorden
    final baseQuantity = averageDailySales * daysToOrder;

    // Agregar stock de seguridad
    final safetyStock = baseQuantity * (safetyMultiplier - 1);

    return baseQuantity + safetyStock;
  }

  /// Obtiene el color según el nivel de urgencia
  static String getUrgencyColor(String urgencyLevel) {
    switch (urgencyLevel) {
      case 'critical':
        return '#EF4444'; // Rojo
      case 'urgent':
        return '#F59E0B'; // Naranja
      case 'warning':
        return '#EAB308'; // Amarillo
      default:
        return '#10B981'; // Verde
    }
  }

  /// Obtiene el mensaje según el nivel de urgencia
  static String getUrgencyMessage(String urgencyLevel) {
    switch (urgencyLevel) {
      case 'critical':
        return '¡CRÍTICO! Ordenar inmediatamente';
      case 'urgent':
        return 'Urgente - Ordenar esta semana';
      case 'warning':
        return 'Advertencia - Planificar pedido';
      default:
        return 'Stock suficiente';
    }
  }

  /// Formatea la fecha estimada de agotamiento
  static String formatStockoutDate(DateTime? date) {
    if (date == null) return 'N/A';
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference <= 0) {
      return 'Hoy o mañana';
    } else if (difference == 1) {
      return 'Mañana';
    } else if (difference <= 7) {
      return 'En $difference días';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}
