import 'sale_item.dart';

class Sale {
  final String id;
  final String userId;
  final String userNombre;
  final DateTime fecha;
  final List<SaleItem> items;
  final double totalFiat;
  final String moneda;
  final int totalSats;
  final double rateUsado;
  final String? invoiceId;
  final String estado;
  final DateTime? exportedAt;

  Sale({
    required this.id,
    required this.userId,
    required this.userNombre,
    required this.fecha,
    required this.items,
    required this.totalFiat,
    required this.moneda,
    required this.totalSats,
    required this.rateUsado,
    this.invoiceId,
    required this.estado,
    this.exportedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'user_nombre': userNombre,
      'fecha': fecha.toIso8601String(),
      'total_fiat': totalFiat,
      'moneda': moneda,
      'total_sats': totalSats,
      'rate_usado': rateUsado,
      'invoice_id': invoiceId,
      'estado': estado,
      'exported_at': exportedAt?.toIso8601String(),
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map, List<SaleItem> items) {
    return Sale(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      userNombre: map['user_nombre'] as String,
      fecha: DateTime.parse(map['fecha'] as String),
      items: items,
      totalFiat: (map['total_fiat'] as num).toDouble(),
      moneda: map['moneda'] as String,
      totalSats: map['total_sats'] as int,
      rateUsado: (map['rate_usado'] as num).toDouble(),
      invoiceId: map['invoice_id'] as String?,
      estado: map['estado'] as String,
      exportedAt: map['exported_at'] != null
          ? DateTime.parse(map['exported_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha': fecha.toIso8601String(),
      'items': items.map((i) => i.toJson()).toList(),
      'totalFiat': totalFiat,
      'moneda': moneda,
      'totalSats': totalSats,
      'rateUsado': rateUsado,
      'invoiceId': invoiceId,
    };
  }

  Sale copyWith({
    String? id,
    String? userId,
    String? userNombre,
    DateTime? fecha,
    List<SaleItem>? items,
    double? totalFiat,
    String? moneda,
    int? totalSats,
    double? rateUsado,
    String? invoiceId,
    String? estado,
    DateTime? exportedAt,
  }) {
    return Sale(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userNombre: userNombre ?? this.userNombre,
      fecha: fecha ?? this.fecha,
      items: items ?? this.items,
      totalFiat: totalFiat ?? this.totalFiat,
      moneda: moneda ?? this.moneda,
      totalSats: totalSats ?? this.totalSats,
      rateUsado: rateUsado ?? this.rateUsado,
      invoiceId: invoiceId ?? this.invoiceId,
      estado: estado ?? this.estado,
      exportedAt: exportedAt ?? this.exportedAt,
    );
  }
}
