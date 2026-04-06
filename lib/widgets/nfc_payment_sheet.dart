import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';

class NfcPaymentSheet extends StatelessWidget {
  final String paymentRequest;
  final String paymentHash;
  final double totalFiat;
  final int totalSats;
  final VoidCallback onCancel;
  final Function(String) onNfcDataReceived;

  const NfcPaymentSheet({
    super.key,
    required this.paymentRequest,
    required this.paymentHash,
    required this.totalFiat,
    required this.totalSats,
    required this.onCancel,
    required this.onNfcDataReceived,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: Text(l10n.pay_with_nfc),
        backgroundColor: const Color(0xFF1A1A2E),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: onCancel),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFF16213E),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF0A500), width: 3),
                ),
                child: const Icon(
                  Icons.nfc,
                  size: 80,
                  color: Color(0xFFF0A500),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                l10n.nfc_ready,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '${totalFiat.toStringAsFixed(2)} sats',
                style: const TextStyle(
                  color: Color(0xFFF0A500),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$totalSats sats',
                style: const TextStyle(color: Colors.grey, fontSize: 18),
              ),
              const SizedBox(height: 48),
              Text(
                l10n.tap_to_pay,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.close),
                label: Text(l10n.cancel_button),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
