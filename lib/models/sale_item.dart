class SaleItem {
  final int? id;
  final String saleId;
  final String nombre;
  final double precioUnitario;
  final String moneda;
  final int cantidad;
  final double subtotalFiat;
  final int subtotalSats;

  SaleItem({
    this.id,
    required this.saleId,
    required this.nombre,
    required this.precioUnitario,
    required this.moneda,
    required this.cantidad,
    required this.subtotalFiat,
    required this.subtotalSats,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sale_id': saleId,
      'nombre': nombre,
      'precio_unitario': precioUnitario,
      'moneda': moneda,
      'cantidad': cantidad,
      'subtotal_fiat': subtotalFiat,
      'subtotal_sats': subtotalSats,
    };
  }

  factory SaleItem.fromMap(Map<String, dynamic> map) {
    return SaleItem(
      id: map['id'] as int?,
      saleId: map['sale_id'] as String,
      nombre: map['nombre'] as String,
      precioUnitario: (map['precio_unitario'] as num).toDouble(),
      moneda: map['moneda'] as String,
      cantidad: map['cantidad'] as int,
      subtotalFiat: (map['subtotal_fiat'] as num).toDouble(),
      subtotalSats: map['subtotal_sats'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'precioUnitario': precioUnitario,
      'moneda': moneda,
      'cantidad': cantidad,
      'subtotalFiat': subtotalFiat,
      'subtotalSats': subtotalSats,
    };
  }

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      saleId: '',
      nombre: json['nombre'] as String,
      precioUnitario: (json['precioUnitario'] as num).toDouble(),
      moneda: json['moneda'] as String,
      cantidad: json['cantidad'] as int,
      subtotalFiat: (json['subtotalFiat'] as num).toDouble(),
      subtotalSats: json['subtotalSats'] as int,
    );
  }
}
