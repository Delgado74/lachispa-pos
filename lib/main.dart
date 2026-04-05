import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/generated/app_localizations.dart';
import 'providers/language_provider.dart';
import 'providers/currency_settings_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/sales_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/database/database_helper.dart';
import 'screens/login_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_jefe_screen.dart';
import 'screens/home_dependiente_screen.dart';
import 'screens/sale_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/about_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;

  final authProvider = AuthProvider();
  await authProvider.init();

  runApp(POSApp(authProvider: authProvider));
}

class POSApp extends StatelessWidget {
  final AuthProvider authProvider;

  const POSApp({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => CurrencySettingsProvider()),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => SalesProvider()),
      ],
      child: Builder(
        builder: (context) {
          final languageProvider = context.watch<LanguageProvider>();
          final currencyProvider = context.watch<CurrencySettingsProvider>();

          final serverUrl = authProvider.currentUser?.lndhubUrl ?? '';
          if (serverUrl.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!currencyProvider.isInitialized) {
                currencyProvider.initialize(serverUrl: serverUrl);
              }
            });
          }

          return MaterialApp(
            title: 'LaChispaPOS',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            locale: languageProvider.currentLocale,
            supportedLocales: LanguageProvider.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: authProvider.isLoggedIn ? '/home' : '/welcome',
            routes: {
              '/welcome': (_) => const WelcomeScreen(),
              '/login': (_) => const LoginScreen(),
              '/home': (context) {
                _checkPendingSales(context);
                final auth = context.read<AuthProvider>();
                if (auth.isJefe) {
                  return const HomeJefeScreen();
                }
                return const HomeDependienteScreen();
              },
              '/sale': (_) => const SaleScreen(),
              '/history': (_) => const HistoryScreen(),
              '/settings': (_) => const SettingsScreen(),
              '/about': (_) => const AboutScreen(),
            },
          );
        },
      ),
    );
  }

  void _checkPendingSales(BuildContext context) async {
    if (!authProvider.isLoggedIn || authProvider.isJefe) return;

    final prefs = await SharedPreferences.getInstance();
    final pendingShown =
        prefs.getBool('pending_sale_shown_${authProvider.currentUser!.id}') ??
        false;
    if (pendingShown) return;

    final salesProvider = context.read<SalesProvider>();
    final pending = await salesProvider.getPendingSales(
      authProvider.currentUser!.id,
    );

    if (pending.isEmpty || !context.mounted) return;

    final sale = pending.first;
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text('Venta Pendiente'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tienes una venta pendiente:'),
            SizedBox(height: 8),
            Text('≈ ${sale.totalSats} sats'),
            Text('\$${sale.totalFiat.toStringAsFixed(2)} ${sale.moneda}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: Text('Descartar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Continuar'),
          ),
        ],
      ),
    );

    if (confirmed == null) {
      await salesProvider.deleteSale(sale.id);
      await prefs.setBool(
        'pending_sale_shown_${authProvider.currentUser!.id}',
        true,
      );
    } else if (confirmed == true && context.mounted) {
      final cart = context.read<CartProvider>();
      cart.loadFromPendingSale(sale);
      if (context.mounted) {
        Navigator.pushNamed(context, '/sale');
      }
    }
  }
}
