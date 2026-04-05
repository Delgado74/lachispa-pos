import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../core/services/export_service.dart';
import '../core/database/database_helper.dart';
import '../providers/auth_provider.dart';
import '../providers/sales_provider.dart';
import '../widgets/app_drawer.dart';

class HomeJefeScreen extends StatelessWidget {
  const HomeJefeScreen({super.key});

  Future<void> _importar(BuildContext context) async {
    try {
      final exportService = ExportService.instance;
      final data = await exportService.pickAndParseJson();

      if (data == null) return;

      final preview = await exportService.getPreview(data);

      if (context.mounted) {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppTheme.cardColor,
            title: const Text('Importar Ventas'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dependiente: ${preview.dependienteNombre}'),
                const SizedBox(height: 8),
                Text('Ventas: ${preview.totalVentas}'),
                const SizedBox(height: 8),
                Text('Total sats: ${preview.totalSats}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Importar'),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          final db = DatabaseHelper.instance;
          final imported = await exportService.importSales(data, db);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$imported ventas importadas')),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('Eliminar BD Importadas'),
        content: const Text('¿Eliminar todas las ventas importadas?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<SalesProvider>().deleteAllImportedSales();
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('BD eliminadas')));
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('${l10n.boss_panel_title} - ${user?.nombre ?? ""}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _MenuCard(
              icon: Icons.file_upload,
              title: l10n.import_sales,
              subtitle: l10n.import_sales_subtitle,
              onTap: () => _importar(context),
            ),
            const SizedBox(height: 12),
            _MenuCard(
              icon: Icons.history,
              title: l10n.view_history,
              subtitle: l10n.view_history_subtitle,
              onTap: () => Navigator.pushNamed(context, '/history'),
            ),
            const SizedBox(height: 12),
            _MenuCard(
              icon: Icons.delete_forever,
              title: l10n.delete_sales,
              subtitle: l10n.delete_sales_subtitle,
              color: Colors.red,
              onTap: () => _showDeleteConfirmation(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (color ?? AppTheme.primaryColor).withValues(
                    alpha: 0.2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color ?? AppTheme.primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color ?? Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }
}
