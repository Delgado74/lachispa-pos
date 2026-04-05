import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../../models/cart_item.dart';

class SessionService {
  static final SessionService instance = SessionService._();
  SessionService._();

  String? _currentSessionId;
  final _uuid = const Uuid();

  String getSessionId() {
    _currentSessionId ??= _uuid.v4();
    return _currentSessionId!;
  }

  void clearSession() {
    _currentSessionId = null;
  }

  Future<List<CartItem>> getRecoverableCart() async {
    final sessionId = getSessionId();
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'cart_temp',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'id ASC',
    );

    return result.map((m) => CartItem.fromMap(m)).toList();
  }

  Future<void> saveCartItem(CartItem item) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(
      'cart_temp',
      item.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCartItem(CartItem item) async {
    if (item.id == null) return;
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'cart_temp',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteCartItem(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('cart_temp', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearCart() async {
    final sessionId = getSessionId();
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'cart_temp',
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );
  }

  Future<bool> hasRecoverableCart() async {
    final items = await getRecoverableCart();
    return items.isNotEmpty;
  }
}
