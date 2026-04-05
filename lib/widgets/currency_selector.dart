import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/currencies.dart';
import '../core/theme/app_theme.dart';
import '../providers/currency_settings_provider.dart';

class CurrencySelector extends StatelessWidget {
  final Moneda selected;
  final ValueChanged<Moneda> onChanged;
  final bool showSat;

  const CurrencySelector({
    super.key,
    required this.selected,
    required this.onChanged,
    this.showSat = true,
  });

  @override
  Widget build(BuildContext context) {
    final currencyProvider = context.watch<CurrencySettingsProvider>();
    final displayCurrencies = currencyProvider.displaySequence;

    final validItems = displayCurrencies
        .map((code) => Moneda.fromCodigo(code))
        .where((m) => showSat || m != Moneda.sat)
        .toSet()
        .toList();

    if (validItems.isEmpty) {
      validItems.add(Moneda.usd);
    }

    final effectiveValue = validItems.contains(selected)
        ? selected
        : validItems.first;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Moneda>(
          value: effectiveValue,
          isExpanded: true,
          dropdownColor: AppTheme.cardColor,
          icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primaryColor),
          items: validItems
              .map(
                (m) => DropdownMenuItem(
                  value: m,
                  child: Row(
                    children: [
                      Text(
                        m.simbolo,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        m.codigo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          m.nombre,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}

class CurrencySelectorRow extends StatelessWidget {
  final Moneda selected;
  final ValueChanged<Moneda> onChanged;
  final bool showSat;

  const CurrencySelectorRow({
    super.key,
    required this.selected,
    required this.onChanged,
    this.showSat = true,
  });

  @override
  Widget build(BuildContext context) {
    final currencyProvider = context.watch<CurrencySettingsProvider>();
    final displayCurrencies = currencyProvider.displaySequence;

    final validItems = displayCurrencies
        .map((code) => Moneda.fromCodigo(code))
        .where((m) => showSat || m != Moneda.sat)
        .toSet()
        .toList();

    if (validItems.isEmpty) {
      validItems.add(Moneda.usd);
    }

    final effectiveSelected = validItems.contains(selected)
        ? selected
        : validItems.first;

    return Row(
      children: validItems
          .map(
            (m) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(m.codigo),
                  selected: effectiveSelected == m,
                  onSelected: (_) => onChanged(m),
                  selectedColor: AppTheme.primaryColor,
                  backgroundColor: AppTheme.cardColor,
                  labelStyle: TextStyle(
                    color: effectiveSelected == m
                        ? Colors.white
                        : Colors.grey[400],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
