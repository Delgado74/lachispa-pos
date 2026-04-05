import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../core/theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: Text(l10n.about_title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.bolt,
                      size: 64,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.login_title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${l10n.about_version} 1.0.0',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.features_title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _FeatureItem(
              icon: Icons.point_of_sale,
              title: l10n.sale_title,
              description: l10n.new_sale_subtitle,
            ),
            _FeatureItem(
              icon: Icons.qr_code,
              title: l10n.scan_qr_button,
              description: l10n.invoice_key_qr_title,
            ),
            _FeatureItem(
              icon: Icons.attach_money,
              title: l10n.currency_settings,
              description: 'CUP, MLC, USD, EUR, GBP, SATs',
            ),
            _FeatureItem(
              icon: Icons.currency_exchange,
              title: l10n.currency_settings,
              description: l10n.currency_settings,
            ),
            _FeatureItem(
              icon: Icons.cloud_sync,
              title: l10n.pending_sale_title,
              description: l10n.pending_sale_message,
            ),
            _FeatureItem(
              icon: Icons.history,
              title: l10n.history_title,
              description: l10n.view_history_subtitle,
            ),
            _FeatureItem(
              icon: Icons.file_upload,
              title: l10n.export_sales,
              description: l10n.import_sales_subtitle,
            ),
            _FeatureItem(
              icon: Icons.file_download,
              title: l10n.import_button,
              description: l10n.import_sales_subtitle,
            ),
            const SizedBox(height: 32),
            Text(
              l10n.roles_title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _FeatureItem(
              icon: Icons.person,
              title: l10n.employee_role,
              description: l10n.employee_panel_title,
            ),
            _FeatureItem(
              icon: Icons.admin_panel_settings,
              title: l10n.boss_role,
              description: l10n.boss_panel_title,
            ),
            const SizedBox(height: 32),
            Text(
              l10n.how_to_connect,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.steps_title, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 12),
                  _StepItem(number: '1', text: l10n.step_connect_1),
                  _StepItem(number: '2', text: l10n.step_connect_2),
                  _StepItem(number: '3', text: l10n.step_connect_3),
                  _StepItem(number: '4', text: l10n.step_connect_4),
                  const SizedBox(height: 12),
                  Text(
                    l10n.steps_subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  Text(
                    l10n.developed_with,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Flutter'),
                      Text(' + ', style: TextStyle(color: Colors.grey[500])),
                      const Text('LNBits'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Powered by Lachispa.me',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String number;
  final String text;

  const _StepItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
