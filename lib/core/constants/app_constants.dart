class AppConstants {
  static const String appName = 'POS Lightning';
  static const String appVersion = '1.0.0';

  static const String lnbitsLocal = 'http://192.168.1.103:5000';
  static const String lnbitsProduction = 'https://lachispa.me/lndhun/ext/';

  static const Duration invoiceTimeout = Duration(minutes: 5);
  static const int wsReconnectAttempts = 3;

  static const String dbName = 'pos_lightning.db';
  static const int dbVersion = 1;
}
