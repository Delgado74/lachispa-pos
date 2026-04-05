import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class TotalDisplay extends StatelessWidget {
  final double totalFiat;
  final String moneda;
  final int totalSats;
  final double rateUsado;

  const TotalDisplay({
    super.key,
    required this.totalFiat,
    required this.moneda,
    required this.totalSats,
    required this.rateUsado,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              if (rateUsado > 0)
                Text(
                  '@ ${rateUsado.toStringAsFixed(8)} BTC',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (moneda != 'SAT')
            Text(
              '\$${totalFiat.toStringAsFixed(2)} $moneda',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            '≈ $totalSats sats',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
