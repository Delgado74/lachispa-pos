import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../core/theme/app_theme.dart';
import '../l10n/generated/app_localizations.dart';

class QrDisplay extends StatelessWidget {
  final String paymentRequest;
  final double totalFiat;
  final int totalSats;
  final VoidCallback? onCancel;

  const QrDisplay({
    super.key,
    required this.paymentRequest,
    required this.totalFiat,
    required this.totalSats,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: QrImageView(
              data: paymentRequest,
              version: QrVersions.auto,
              size: 220,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$totalSats sats',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${totalFiat.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16, color: Colors.grey[400]),
          ),
          const SizedBox(height: 12),
          SelectableText(
            paymentRequest,
            style: TextStyle(fontSize: 8, color: Colors.grey[500]),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: paymentRequest));
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(l10n.copiado)));
                  },
                  icon: const Icon(Icons.copy, size: 18),
                  label: Text(l10n.copy_button),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Share.share(paymentRequest);
                  },
                  icon: const Icon(Icons.share, size: 18),
                  label: Text(l10n.compartir),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (onCancel != null)
            OutlinedButton.icon(
              onPressed: onCancel,
              icon: const Icon(Icons.close, size: 18),
              label: Text(l10n.cancel_button),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
