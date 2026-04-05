import 'package:flutter/material.dart';
import '../core/constants/currencies.dart';
import '../core/theme/app_theme.dart';

class CartItemTile extends StatelessWidget {
  final String nombre;
  final double precioUnitario;
  final String moneda;
  final int cantidad;
  final double subtotal;
  final int subtotalSats;
  final VoidCallback? onDelete;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const CartItemTile({
    super.key,
    required this.nombre,
    required this.precioUnitario,
    required this.moneda,
    required this.cantidad,
    required this.subtotal,
    required this.subtotalSats,
    this.onDelete,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final monedaEnum = Moneda.fromCodigo(moneda);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  nombre,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: onDelete,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${monedaEnum.simbolo}${precioUnitario.toStringAsFixed(2)} $moneda',
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
              const Spacer(),
              Text(
                'x$cantidad',
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
            ],
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (moneda != 'SAT')
                Text(
                  '${monedaEnum.simbolo}${subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              Text(
                '≈ $subtotalSats sats',
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
            ],
          ),
          if (onIncrement != null || onDecrement != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: cantidad > 1 ? onDecrement : null,
                  color: AppTheme.primaryColor,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    cantidad.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: onIncrement,
                  color: AppTheme.primaryColor,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
