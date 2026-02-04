import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class OfflineService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'bodega_offline.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tabla para guardar ventas pendientes de sincronizar
        await db.execute('''
          CREATE TABLE pending_sales (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            venta_data TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
        ''');
        // Tabla para caché de productos (opcional, para vender sin internet)
        await db.execute('''
          CREATE TABLE products_cache (
            id INTEGER PRIMARY KEY,
            data TEXT
          )
        ''');
      },
    );
  }

  // Guardar venta localmente
  static Future<void> savePendingVenta(Map<String, dynamic> ventaData) async {
    final db = await database;
    await db.insert('pending_sales', {'venta_data': jsonEncode(ventaData)});
  }

  // Obtener ventas pendientes
  static Future<List<Map<String, dynamic>>> getPendingSales() async {
    final db = await database;
    return await db.query('pending_sales');
  }

  // Eliminar venta sincronizada
  static Future<void> deletePendingVenta(int id) async {
    final db = await database;
    await db.delete('pending_sales', where: 'id = ?', whereArgs: [id]);
  }

  // Guardar productos en caché
  static Future<void> cacheProducts(List<dynamic> products) async {
    final db = await database;
    await db.delete('products_cache');
    for (var p in products) {
      await db.insert('products_cache', {'id': p['id'], 'data': jsonEncode(p)});
    }
  }
}
