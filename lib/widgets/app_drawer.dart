import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../providers/language_provider.dart';
import '../providers/currency_settings_provider.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback? onLanguageChanged;

  const AppDrawer({super.key, this.onLanguageChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = context.watch<LanguageProvider>();
    final currencyProvider = context.watch<CurrencySettingsProvider>();
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Drawer(
      backgroundColor: AppTheme.backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor.withValues(alpha: 0.3),
                    AppTheme.primaryColor.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/Logo/chispabordesredondos.png',
                    height: 60,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'LaChispaPOS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  if (user != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      user.nombre,
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            _DrawerItem(
              icon: Icons.language,
              title: l10n.language_settings,
              subtitle: languageProvider.getCurrentLanguageDisplay(),
              onTap: () => _showLanguageSelector(context),
            ),
            _DrawerItem(
              icon: Icons.attach_money,
              title: l10n.currency_settings,
              subtitle: currencyProvider.selectedCurrencies.isNotEmpty
                  ? currencyProvider.selectedCurrencies.join(', ')
                  : l10n.select_currency,
              onTap: () => _showCurrencySelector(context),
            ),
            const Divider(color: Colors.grey),
            _DrawerItem(
              icon: Icons.settings,
              title: l10n.settings_title,
              subtitle: l10n.server_settings,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            _DrawerItem(
              icon: Icons.info_outline,
              title: l10n.about_app,
              subtitle: l10n.about_title,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '${l10n.about_version} 1.0.0',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    final languageProvider = context.read<LanguageProvider>();
    final l10n = AppLocalizations.of(context)!;
    final languages = languageProvider.getAvailableLanguages();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.select_language,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  return ListTile(
                    leading: Text(
                      lang['flag']!,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(lang['name']!),
                    trailing:
                        languageProvider.currentLocale.languageCode ==
                            lang['code']
                        ? const Icon(Icons.check, color: AppTheme.primaryColor)
                        : null,
                    onTap: () {
                      languageProvider.changeLanguage(Locale(lang['code']!));
                      Navigator.pop(ctx);
                      onLanguageChanged?.call();
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showCurrencySelector(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currencyProvider = context.read<CurrencySettingsProvider>();
    final allCurrencies = [
      'USD',
      'EUR',
      'CUP',
      'MLC',
      'GBP',
      'CAD',
      'JPY',
      'AUD',
      'CHF',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.select_currency,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.select_currencies_hint,
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: allCurrencies.length,
                itemBuilder: (_, index) {
                  final currency = allCurrencies[index];
                  final isSelected = currencyProvider.isCurrencySelected(
                    currency,
                  );
                  final info = currencyProvider.getCurrencyInfo(currency);

                  return ListTile(
                    leading: Text(
                      info?.flag ?? '💰',
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(info?.name ?? currency),
                    subtitle: Text(currency),
                    trailing: Checkbox(
                      value: isSelected,
                      activeColor: AppTheme.primaryColor,
                      onChanged: (value) {
                        if (value == true) {
                          currencyProvider.addCurrency(currency);
                        } else {
                          currencyProvider.removeCurrency(currency);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[400], fontSize: 12),
      ),
      onTap: onTap,
    );
  }
}
