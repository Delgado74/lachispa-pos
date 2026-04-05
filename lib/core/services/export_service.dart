import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/sale.dart';
import '../../models/sale_item.dart';
import '../database/database_helper.dart';

class ExportService {
  static final ExportService instance = ExportService._();
  ExportService._();

  Future<String> generateJson({
    required String dependienteId,
    required String dependienteNombre,
    required List<Sale> ventas,
    required int totalSats,
    required String appVersion,
  }) async {
    final exportData = {
      'exportId': DateTime.now().millisecondsSinceEpoch.toString(),
      'appVersion': appVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'dependiente': {'id': dependienteId, 'nombre': dependienteNombre},
      'resumen': {'totalVentas': ventas.length, 'totalSats': totalSats},
      'ventas': ventas.map((v) => v.toJson()).toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(exportData);
  }

  Future<void> shareJson({
    required String json,
    required String dependienteNombre,
  }) async {
    final directory = await getTemporaryDirectory();
    final timestamp = DateTime.now().toIso8601String().split('T')[0];
    final fileName = 'ventas_${dependienteNombre}_$timestamp.json';
    final file = File('${directory.path}/$fileName');

    await file.writeAsString(json);
    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'Exportación de ventas POS Lightning');
  }

  Future<Map<String, dynamic>?> pickAndParseJson() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.isEmpty) return null;

    final file = File(result.files.first.path!);
    final content = await file.readAsString();

    try {
      return json.decode(content) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Archivo JSON inválido');
    }
  }

  Future<ImportPreview> getPreview(Map<String, dynamic> data) async {
    final dependiente = data['dependiente'] as Map<String, dynamic>?;
    final ventas = data['ventas'] as List<dynamic>?;

    return ImportPreview(
      exportId: data['exportId'] as String? ?? '',
      dependienteId: dependiente?['id'] as String? ?? '',
      dependienteNombre: dependiente?['nombre'] as String? ?? 'Desconocido',
      totalVentas: ventas?.length ?? 0,
      totalSats: data['resumen']?['totalSats'] as int? ?? 0,
    );
  }

  Future<int> importSales(Map<String, dynamic> data, DatabaseHelper db) async {
    final ventas = data['ventas'] as List<dynamic>?;
    if (ventas == null) return 0;

    int imported = 0;
    final database = await db.database;

    await database.execute('PRAGMA foreign_keys = OFF');

    for (final ventaData in ventas) {
      final venta = ventaData as Map<String, dynamic>;
      final items = venta['items'] as List<dynamic>? ?? [];

      final exists = await database.query(
        'sales',
        where: 'id = ?',
        whereArgs: [venta['id']],
      );

      if (exists.isNotEmpty) continue;

      final saleId = venta['id'] as String;
      final now = DateTime.now().toIso8601String();

      await database.insert('sales', {
        'id': saleId,
        'user_id': 'imported',
        'user_nombre': data['dependiente']?['nombre'] ?? 'Importado',
        'fecha': venta['fecha'] ?? now,
        'total_fiat': (venta['totalFiat'] as num?)?.toDouble() ?? 0.0,
        'moneda': venta['moneda'] ?? 'USD',
        'total_sats': venta['totalSats'] ?? 0,
        'rate_usado': (venta['rateUsado'] as num?)?.toDouble() ?? 0.0,
        'invoice_id': venta['invoiceId'],
        'estado': 'completada',
        'exported_at': now,
      });

      for (final item in items) {
        await database.insert('sale_items', {
          'sale_id': saleId,
          'nombre': item['nombre'] ?? '',
          'precio_unitario':
              (item['precioUnitario'] as num?)?.toDouble() ?? 0.0,
          'moneda': item['moneda'] ?? 'USD',
          'cantidad': item['cantidad'] ?? 1,
          'subtotal_fiat': (item['subtotalFiat'] as num?)?.toDouble() ?? 0.0,
          'subtotal_sats': item['subtotalSats'] ?? 0,
        });
      }

      imported++;
    }

    return imported;
  }
}

class ImportPreview {
  final String exportId;
  final String dependienteId;
  final String dependienteNombre;
  final int totalVentas;
  final int totalSats;

  ImportPreview({
    required this.exportId,
    required this.dependienteId,
    required this.dependienteNombre,
    required this.totalVentas,
    required this.totalSats,
  });
}
