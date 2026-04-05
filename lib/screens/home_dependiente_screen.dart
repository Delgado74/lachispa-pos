import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../core/services/export_service.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/sales_provider.dart';
import '../widgets/app_drawer.dart';

class HomeDependienteScreen extends StatefulWidget {
  const HomeDependienteScreen({super.key});

  @override
  State<HomeDependienteScreen> createState() => _HomeDependienteScreenState();
}

class _HomeDependienteScreenState extends State<HomeDependienteScreen> {
  @override
  void initState() {
    super.initState();
    _checkRecoverableCart();
  }

  Future<void> _checkRecoverableCart() async {
    final cartProvider = context.read<CartProvider>();
    await cartProvider.initSession();

    if (cartProvider.hasItems && mounted) {
      _showRecoveryDialog();
    }
  }

  void _showRecoveryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('Venta Pendiente'),
        content: const Text('Tiene una venta pendiente. ¿Desea retomarla?'),
        actions: [
          TextButton(
            onPressed: () {
              context.read<CartProvider>().clearCart();
              Navigator.pop(ctx);
            },
            child: const Text('Descartar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, '/sale');
            },
            child: const Text('Retomar'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportar() async {
    final salesProvider = context.read<SalesProvider>();
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;

    if (user == null) return;

    final sales = await salesProvider.getSalesByUser(user.id);
    if (sales.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay ventas para exportar')),
        );
      }
      return;
    }

    final totalSats = sales.fold<int>(0, (sum, s) => sum + s.totalSats);

    final exportService = ExportService.instance;
    final json = await exportService.generateJson(
      dependienteId: user.id,
      dependienteNombre: user.nombre,
      ventas: sales,
      totalSats: totalSats,
      appVersion: '1.0.0',
    );

    await exportService.shareJson(json: json, dependienteNombre: user.nombre);
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('Eliminar Ventas'),
        content: const Text(
          '¿Está seguro de eliminar todas sus ventas? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              final salesProvider = context.read<SalesProvider>();
              final authProvider = context.read<AuthProvider>();
              await salesProvider.deleteAllSalesByUser(
                authProvider.currentUser!.id,
              );
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ventas eliminadas')),
                );
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
        title: Text('${l10n.employee_panel_title} - ${user?.nombre ?? ""}'),
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
              icon: Icons.point_of_sale,
              title: l10n.new_sale,
              subtitle: l10n.new_sale_subtitle,
              color: AppTheme.primaryColor,
              onTap: () => Navigator.pushNamed(context, '/sale'),
            ),
            const SizedBox(height: 12),
            _MenuCard(
              icon: Icons.history,
              title: l10n.history_title,
              subtitle: l10n.view_history_subtitle,
              onTap: () => Navigator.pushNamed(context, '/history'),
            ),
            const SizedBox(height: 12),
            _MenuCard(
              icon: Icons.file_download,
              title: l10n.export_sales,
              subtitle: l10n.import_sales_subtitle,
              onTap: _exportar,
            ),
            const SizedBox(height: 12),
            _MenuCard(
              icon: Icons.delete_forever,
              title: 'ELIMINAR MIS VENTAS',
              subtitle: 'Borrar todo el historial',
              color: Colors.red,
              onTap: _showDeleteConfirmation,
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
