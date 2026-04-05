import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../core/database/database_helper.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  final _uuid = const Uuid();
  static const String _currentUserKey = 'current_user_id';

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isJefe => _currentUser?.isJefe ?? false;
  bool get isDependiente => _currentUser?.isDependiente ?? false;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_currentUserKey);

    if (userId != null) {
      final db = await DatabaseHelper.instance.database;
      final result = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (result.isNotEmpty) {
        _currentUser = User.fromMap(result.first);
        notifyListeners();
      }
    }
  }

  Future<void> login({
    required String nombre,
    required String rol,
    String? lndhubUrl,
    String? lndhubCreds,
  }) async {
    final db = await DatabaseHelper.instance.database;

    final existing = await db.query(
      'users',
      where: 'nombre = ? AND rol = ?',
      whereArgs: [nombre, rol],
    );

    if (existing.isNotEmpty) {
      _currentUser = User.fromMap(existing.first);
      if (lndhubUrl != null || lndhubCreds != null) {
        await _updateLndhub(lndhubUrl, lndhubCreds);
      }
    } else {
      final user = User(
        id: _uuid.v4(),
        nombre: nombre,
        rol: rol,
        lndhubUrl: lndhubUrl,
        lndhubCreds: lndhubCreds,
        createdAt: DateTime.now(),
      );

      await db.insert('users', user.toMap());
      _currentUser = user;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, _currentUser!.id);

    notifyListeners();
  }

  Future<void> _updateLndhub(String? url, String? creds) async {
    if (_currentUser == null) return;

    final updated = _currentUser!.copyWith(lndhubUrl: url, lndhubCreds: creds);

    final db = await DatabaseHelper.instance.database;
    await db.update(
      'users',
      {'lndhub_url': url, 'lndhub_creds': creds},
      where: 'id = ?',
      whereArgs: [_currentUser!.id],
    );

    _currentUser = updated;
    notifyListeners();
  }

  Future<void> updateLndhub({
    required String url,
    required String creds,
  }) async {
    await _updateLndhub(url, creds);
  }

  Future<List<User>> getDependientes() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'users',
      where: 'rol = ?',
      whereArgs: ['dependiente'],
    );
    return result.map((m) => User.fromMap(m)).toList();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
