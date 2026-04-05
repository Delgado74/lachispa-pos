import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class YadioService {
  static final YadioService instance = YadioService._();
  Map<String, double>? _cachedRates;
  DateTime? _lastFetch;
  double _satsPerUsd = 145000.0;

  YadioService._();

  Future<Map<String, double>> getRates() async {
    if (_cachedRates != null && _lastFetch != null) {
      final diff = DateTime.now().difference(_lastFetch!);
      if (diff.inSeconds < 30) return _cachedRates!;
    }

    try {
      final response = await http
          .get(Uri.parse('https://api.yadio.io/json/USD'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final extracted = _extractRates(data);
        _cachedRates = extracted['rates'];
        _satsPerUsd = extracted['satsPerUsd'];
        _lastFetch = DateTime.now();
        return _cachedRates!;
      }
    } catch (e) {
      debugPrint('YadioService: Error fetching rates: $e');
      if (_cachedRates != null) return _cachedRates!;
    }

    _cachedRates = _getFallbackRates();
    return _cachedRates!;
  }

  Map<String, dynamic> _extractRates(Map<String, dynamic> data) {
    final rates = <String, double>{};

    final usdData = data['USD'] as Map<String, dynamic>?;
    if (usdData == null)
      return {'rates': _getFallbackRates(), 'satsPerUsd': _satsPerUsd};

    if (usdData.containsKey('BTC')) {
      final btcRate = (usdData['BTC'] as num).toDouble();
      if (btcRate > 0) {
        _satsPerUsd = btcRate * 100000000;
      }
    }

    final currencies = [
      'CUP',
      'MLC',
      'USD',
      'EUR',
      'GBP',
      'CAD',
      'JPY',
      'AUD',
      'CHF',
    ];
    for (final currency in currencies) {
      if (usdData.containsKey(currency)) {
        final fiatRate = (usdData[currency] as num).toDouble();
        if (fiatRate > 0) {
          rates[currency] = _satsPerUsd / fiatRate;
        }
      }
    }

    rates['SAT'] = 1.0;

    return {'rates': rates, 'satsPerUsd': _satsPerUsd};
  }

  Map<String, double> _getFallbackRates() {
    final satsPerUsd = _satsPerUsd > 0 ? _satsPerUsd : 145000.0;
    return {
      'CUP': satsPerUsd / 285000.0,
      'MLC': satsPerUsd / 1.0,
      'USD': satsPerUsd,
      'EUR': satsPerUsd / 0.92,
      'GBP': satsPerUsd / 0.79,
      'CAD': satsPerUsd / 1.36,
      'JPY': satsPerUsd / 152.0,
      'AUD': satsPerUsd / 1.53,
      'CHF': satsPerUsd / 0.88,
      'SAT': 1.0,
    };
  }

  double getRate(String currency) {
    if (_cachedRates == null) return 0.0;
    return _cachedRates![currency.toUpperCase()] ?? 0.0;
  }

  int fiatToSats(double amount, String currency) {
    final rate = getRate(currency.toUpperCase());
    if (rate <= 0) return 0;
    return (amount * rate).round();
  }

  double satsToFiat(int sats, String currency) {
    final rate = getRate(currency.toUpperCase());
    if (rate <= 0) return 0.0;
    return sats / rate;
  }

  Future<int> fiatToSatsRealTime(double amount, String currency) async {
    if (currency.toUpperCase() == 'SAT') {
      return amount.round();
    }

    final rates = await getRates();
    final rate = rates[currency.toUpperCase()];
    if (rate != null && rate > 0) {
      return (amount * rate).round();
    }

    final fallbackRates = _getFallbackRates();
    final fallbackRate = fallbackRates[currency.toUpperCase()];
    if (fallbackRate != null && fallbackRate > 0) {
      return (amount * fallbackRate).round();
    }

    return 0;
  }
}
