import 'package:flutter/foundation.dart';
import '../core/constants/currencies.dart';
import '../core/services/session_service.dart';
import '../core/services/yadio_service.dart';
import '../models/cart_item.dart';
import '../models/sale.dart';
import '../models/sale_item.dart';

class CartProvider extends ChangeNotifier {
  final SessionService _sessionService = SessionService.instance;
  final YadioService _yadioService = YadioService.instance;

  List<CartItem> _items = [];
  Moneda _monedaVenta = Moneda.sat;
  double _rateUsado = 0.0;
  int _totalSats = 0;

  List<CartItem> get items => _items;
  Moneda get monedaVenta => _monedaVenta;
  double get rateUsado => _rateUsado;
  int get totalSats => _totalSats;
  bool get hasItems => _items.isNotEmpty;

  double get totalFiat {
    return _items.fold(0.0, (sum, item) => sum + item.subtotalFiat);
  }

  int get itemCount => _items.length;

  Future<void> initSession() async {
    _sessionService.getSessionId();
    _items = await _sessionService.getRecoverableCart();
    _calculateTotals();
    notifyListeners();
  }

  void setMoneda(Moneda moneda) {
    _monedaVenta = moneda;
    _recalculateSats();
    notifyListeners();
  }

  Future<void> _recalculateAllItems() async {
    await _yadioService.getRates();

    if (_monedaVenta != Moneda.sat) {
      _rateUsado =
          1.0 /
          await _yadioService.fiatToSatsRealTime(1.0, _monedaVenta.codigo);
    } else {
      _rateUsado = 1.0;
    }

    final newItems = <CartItem>[];
    for (final item in _items) {
      final subtotalFiat = item.precioUnitario * item.cantidad;
      final subtotalSats = _monedaVenta == Moneda.sat
          ? (item.precioUnitario * item.cantidad).round()
          : await _yadioService.fiatToSatsRealTime(
              subtotalFiat,
              _monedaVenta.codigo,
            );

      newItems.add(
        CartItem(
          id: item.id,
          sessionId: item.sessionId,
          nombre: item.nombre,
          precioUnitario: item.precioUnitario,
          moneda: _monedaVenta.codigo,
          cantidad: item.cantidad,
          subtotalFiat: subtotalFiat,
          subtotalSats: subtotalSats,
        ),
      );
    }

    _items = newItems;
  }

  Future<void> addItem({
    required String nombre,
    required double precio,
    required int cantidad,
  }) async {
    final sessionId = _sessionService.getSessionId();

    final subtotalFiat = precio * cantidad;

    final subtotalSats = await _yadioService.fiatToSatsRealTime(
      subtotalFiat,
      _monedaVenta.codigo,
    );

    _rateUsado = subtotalSats / subtotalFiat;

    final item = CartItem(
      sessionId: sessionId,
      nombre: nombre,
      precioUnitario: precio,
      moneda: _monedaVenta.codigo,
      cantidad: cantidad,
      subtotalFiat: subtotalFiat,
      subtotalSats: subtotalSats,
    );

    await _sessionService.saveCartItem(item);
    _items.add(item);
    _calculateTotals();
    notifyListeners();
  }

  Future<void> removeItem(int index) async {
    if (index < 0 || index >= _items.length) return;

    final item = _items[index];
    if (item.id != null) {
      await _sessionService.deleteCartItem(item.id!);
    }

    _items.removeAt(index);
    _calculateTotals();
    notifyListeners();
  }

  Future<void> updateQuantity(int index, int cantidad) async {
    if (index < 0 || index >= _items.length) return;
    if (cantidad <= 0) {
      await removeItem(index);
      return;
    }

    final item = _items[index];
    final subtotalFiat = _monedaVenta == Moneda.sat
        ? 0.0
        : item.precioUnitario * cantidad;

    final subtotalSats = _monedaVenta == Moneda.sat
        ? (item.precioUnitario * cantidad).round()
        : await _yadioService.fiatToSatsRealTime(
            subtotalFiat,
            _monedaVenta.codigo,
          );

    final updated = CartItem(
      id: item.id,
      sessionId: item.sessionId,
      nombre: item.nombre,
      precioUnitario: item.precioUnitario,
      moneda: item.moneda,
      cantidad: cantidad,
      subtotalFiat: subtotalFiat,
      subtotalSats: subtotalSats,
    );

    await _sessionService.updateCartItem(updated);
    _items[index] = updated;
    _calculateTotals();
    notifyListeners();
  }

  void _recalculateSats() {
    if (_monedaVenta == Moneda.sat) {
      _totalSats = _items.fold(0, (sum, item) => sum + item.subtotalSats);
      return;
    }

    _totalSats = _items.fold(0, (sum, item) => sum + item.subtotalSats);
  }

  void _calculateTotals() {
    _recalculateSats();
  }

  Future<void> clearCart() async {
    await _sessionService.clearCart();
    _items = [];
    _totalSats = 0;
    _rateUsado = 0.0;
    _sessionService.clearSession();
    notifyListeners();
  }

  void loadFromPendingSale(Sale sale) {
    _items = sale.items
        .map(
          (item) => CartItem(
            id: item.id,
            sessionId: _sessionService.getSessionId(),
            nombre: item.nombre,
            precioUnitario: item.precioUnitario,
            moneda: item.moneda,
            cantidad: item.cantidad,
            subtotalFiat: item.subtotalFiat,
            subtotalSats: item.subtotalSats,
          ),
        )
        .toList();
    _monedaVenta = Moneda.fromCodigo(sale.moneda);
    _rateUsado = sale.rateUsado;
    _totalSats = sale.totalSats;
    notifyListeners();
  }
}
