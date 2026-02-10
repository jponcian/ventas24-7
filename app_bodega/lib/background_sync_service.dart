import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'offline_service.dart';
import 'api_service.dart';
import 'dart:convert';

/// Callback que se ejecuta en segundo plano
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      print('🔄 Iniciando sincronización en segundo plano...');

      // Obtener ventas pendientes
      final pendingSales = await OfflineService.getPendingSales();

      if (pendingSales.isEmpty) {
        print('✅ No hay ventas pendientes de sincronizar');
        return Future.value(true);
      }

      print('📦 Encontradas ${pendingSales.length} ventas pendientes');

      // Sincronizar cada venta
      final apiService = ApiService();
      int syncedCount = 0;
      int failedCount = 0;

      for (var sale in pendingSales) {
        try {
          final saleData = jsonDecode(sale['venta_data']);
          final success = await apiService.registrarVenta(saleData);

          if (success) {
            await OfflineService.deletePendingVenta(sale['id']);
            syncedCount++;
            print('✅ Venta ${sale['id']} sincronizada');
          } else {
            failedCount++;
            print('❌ Error al sincronizar venta ${sale['id']}');
          }
        } catch (e) {
          failedCount++;
          print('❌ Excepción al sincronizar venta ${sale['id']}: $e');
        }
      }

      print(
        '🎉 Sincronización completada: $syncedCount exitosas, $failedCount fallidas',
      );

      // Guardar estadísticas
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_sync', DateTime.now().toIso8601String());
      await prefs.setInt('last_sync_count', syncedCount);

      return Future.value(true);
    } catch (e) {
      print('💥 Error en sincronización: $e');
      return Future.value(false);
    }
  });
}

class BackgroundSyncService {
  static const String syncTaskName = 'salesSyncTask';
  static const String uniqueTaskName = 'salesSyncUniqueTask';

  /// Inicializa el servicio de sincronización en segundo plano
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false, // Cambiar a true para debug
    );
  }

  /// Registra una tarea periódica de sincronización
  static Future<void> registerPeriodicSync({
    Duration frequency = const Duration(hours: 1),
  }) async {
    await Workmanager().registerPeriodicTask(
      uniqueTaskName,
      syncTaskName,
      frequency: frequency,
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
    print('✅ Sincronización periódica registrada (cada ${frequency.inHours}h)');
  }

  /// Ejecuta una sincronización inmediata
  static Future<void> syncNow() async {
    await Workmanager().registerOneOffTask(
      'syncNow-${DateTime.now().millisecondsSinceEpoch}',
      syncTaskName,
      constraints: Constraints(networkType: NetworkType.connected),
    );
    print('🚀 Sincronización inmediata solicitada');
  }

  /// Cancela todas las tareas de sincronización
  static Future<void> cancelAllSync() async {
    await Workmanager().cancelAll();
    print('🛑 Todas las sincronizaciones canceladas');
  }

  /// Verifica si la sincronización automática está habilitada
  static Future<bool> isAutoSyncEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('auto_sync_enabled') ?? true;
  }

  /// Habilita o deshabilita la sincronización automática
  static Future<void> setAutoSyncEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_sync_enabled', enabled);

    if (enabled) {
      await registerPeriodicSync();
    } else {
      await cancelAllSync();
    }
  }

  /// Obtiene la fecha de la última sincronización
  static Future<DateTime?> getLastSyncDate() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncStr = prefs.getString('last_sync');
    if (lastSyncStr != null) {
      return DateTime.parse(lastSyncStr);
    }
    return null;
  }

  /// Obtiene el número de ventas sincronizadas en la última ejecución
  static Future<int> getLastSyncCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('last_sync_count') ?? 0;
  }
}
