import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/currencies.dart';
import '../models/sale.dart';
import '../providers/auth_provider.dart';
import '../providers/sales_provider.dart';
import '../providers/cart_provider.dart';
import '../l10n/generated/app_localizations.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Sale> _sales = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarVentas();
  }

  Future<void> _cargarVentas() async {
    final auth = context.read<AuthProvider>();
    final salesProvider = context.read<SalesProvider>();

    List<Sale> ventas;
    if (auth.isJefe) {
      ventas = await salesProvider.getCompletedSales();
    } else {
      ventas = await salesProvider.getAllUserSales(auth.currentUser!.id);
    }

    if (mounted) {
      setState(() {
        _sales = ventas;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: Text(l10n.history_title)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _sales.isEmpty
          ? Center(
              child: Text(
                l10n.no_sales,
                style: const TextStyle(color: Colors.grey),
              ),
            )
          : RefreshIndicator(
              onRefresh: _cargarVentas,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _sales.length,
                itemBuilder: (context, index) {
                  final sale = _sales[index];
                  return _SaleCard(
                    sale: sale,
                    isJefe: auth.isJefe,
                    onDelete: auth.isJefe
                        ? () => _eliminarVenta(context, sale.id)
                        : (sale.estado == 'pendiente'
                              ? () => _descartarVenta(context, sale.id)
                              : null),
                    onContinue: sale.estado == 'pendiente'
                        ? () => _continuarVenta(context, sale)
                        : null,
                  );
                },
              ),
            ),
    );
  }

  Future<void> _eliminarVenta(BuildContext context, String saleId) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text(l10n.delete_sale_confirm),
        content: Text(l10n.delete_sale_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel_button),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete_button),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<SalesProvider>().deleteSale(saleId);
      _cargarVentas();
    }
  }

  Future<void> _descartarVenta(BuildContext context, String saleId) async {
    await context.read<SalesProvider>().deleteSale(saleId);
    _cargarVentas();
  }

  Future<void> _continuarVenta(BuildContext context, Sale sale) async {
    final cart = context.read<CartProvider>();
    cart.loadFromPendingSale(sale);
    if (context.mounted) {
      Navigator.pushNamed(context, '/sale');
    }
  }
}

class _SaleCard extends StatelessWidget {
  final Sale sale;
  final bool isJefe;
  final VoidCallback? onDelete;
  final VoidCallback? onContinue;

  const _SaleCard({
    required this.sale,
    required this.isJefe,
    this.onDelete,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(sale.fecha);
    final monedaEnum = Moneda.fromCodigo(sale.moneda);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: sale.estado == 'pendiente'
                ? Colors.orange.withValues(alpha: 0.2)
                : AppTheme.primaryColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            sale.estado == 'pendiente' ? Icons.hourglass_bottom : Icons.bolt,
            color: sale.estado == 'pendiente'
                ? Colors.orange
                : AppTheme.primaryColor,
          ),
        ),
        title: Text(
          '≈ ${sale.totalSats} sats',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: sale.estado == 'pendiente'
                ? Colors.orange
                : AppTheme.primaryColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              formattedDate,
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
            if (isJefe)
              Text(
                sale.userNombre,
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${monedaEnum.simbolo}${sale.totalFiat.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              sale.moneda,
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
          ],
        ),
        children: [
          const Divider(),
          ...sale.items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text('${item.cantidad}x'),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item.nombre)),
                  Text(
                    '${Moneda.fromCodigo(item.moneda).simbolo}${item.subtotalFiat.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rate: ${sale.rateUsado.toStringAsFixed(8)} BTC',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
              if (sale.invoiceId != null)
                Text(
                  'Invoice: ${sale.invoiceId!.substring(0, 8)}...',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
            ],
          ),
          if (sale.estado == 'pendiente' && onContinue != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onContinue,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(l10n.continue_sale),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: Text(
                      l10n.discard_sale,
                      style: const TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ] else if (isJefe) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
