class CartItem {
  final int? id;
  final String sessionId;
  final String nombre;
  final double precioUnitario;
  final String moneda;
  final int cantidad;
  final double subtotalFiat;
  final int subtotalSats;

  CartItem({
    this.id,
    required this.sessionId,
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
      'session_id': sessionId,
      'nombre': nombre,
      'precio_unitario': precioUnitario,
      'moneda': moneda,
      'cantidad': cantidad,
      'subtotal_fiat': subtotalFiat,
      'subtotal_sats': subtotalSats,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as int?,
      sessionId: map['session_id'] as String,
      nombre: map['nombre'] as String,
      precioUnitario: (map['precio_unitario'] as num).toDouble(),
      moneda: map['moneda'] as String,
      cantidad: map['cantidad'] as int,
      subtotalFiat: (map['subtotal_fiat'] as num).toDouble(),
      subtotalSats: map['subtotal_sats'] as int,
    );
  }
}
