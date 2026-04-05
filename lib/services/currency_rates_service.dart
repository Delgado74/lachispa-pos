import 'package:dio/dio.dart';

class CurrencyRatesService {
  final Dio _dio = Dio();
  static const String fallbackApiUrl =
      'https://api.exchangerate-api.com/v4/latest/BTC';

  CurrencyRatesService() {
    _configureDio();
  }

  void _configureDio() {
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
        error: true,
        logPrint: (obj) => print('[CURRENCY_RATES_SERVICE] $obj'),
      ),
    );
  }

  Future<List<String>> getAvailableCurrencies({
    required String serverUrl,
  }) async {
    print(
      '[CURRENCY_RATES_SERVICE] Getting currencies from server: $serverUrl',
    );

    if (serverUrl.isEmpty) {
      throw Exception('Server URL is required to get currencies');
    }

    try {
      final lnbitsCurrencies = await _getLNBitsCurrencies(serverUrl);
      if (lnbitsCurrencies.isNotEmpty) {
        print(
          '[CURRENCY_RATES_SERVICE] Found ${lnbitsCurrencies.length} currencies from server',
        );
        return lnbitsCurrencies;
      }

      final commonCurrencies = [
        'USD',
        'EUR',
        'GBP',
        'CUP',
        'CAD',
        'JPY',
        'AUD',
        'CHF',
        'MLC',
      ];
      final availableCurrencies = <String>[];

      for (final currency in commonCurrencies) {
        try {
          final endpoint = '$serverUrl/lnurlp/api/v1/rate/$currency';
          final response = await _dio.get(endpoint);
          if (response.statusCode == 200) {
            availableCurrencies.add(currency);
            print('[CURRENCY_RATES_SERVICE] Currency $currency is available');
          }
        } catch (e) {
          print(
            '[CURRENCY_RATES_SERVICE] Currency $currency not available: $e',
          );
        }
      }

      if (availableCurrencies.isNotEmpty) {
        print(
          '[CURRENCY_RATES_SERVICE] Found ${availableCurrencies.length} working currencies: $availableCurrencies',
        );
        return availableCurrencies;
      }

      return commonCurrencies;
    } catch (e) {
      print('[CURRENCY_RATES_SERVICE] Server failed: $e');
      return ['USD', 'EUR', 'CUP', 'MLC'];
    }
  }

  Future<List<String>> _getLNBitsCurrencies(String serverUrl) async {
    final endpoints = [
      '$serverUrl/lnurlp/api/v1/currencies',
      '$serverUrl/api/v1/currencies',
      '$serverUrl/api/v1/rates',
    ];

    print(
      '[CURRENCY_RATES_SERVICE] Testing ${endpoints.length} currency endpoints',
    );

    for (final endpoint in endpoints) {
      try {
        print('[CURRENCY_RATES_SERVICE] Trying endpoint: $endpoint');
        final response = await _dio.get(endpoint);

        if (response.statusCode == 200 && response.data != null) {
          final currencies = _parseCurrenciesFromResponse(response.data);
          if (currencies.isNotEmpty) {
            print(
              '[CURRENCY_RATES_SERVICE] Found currencies from $endpoint: $currencies',
            );
            return currencies;
          }
        }
      } catch (e) {
        print('[CURRENCY_RATES_SERVICE] Endpoint $endpoint failed: $e');
        continue;
      }
    }

    print('[CURRENCY_RATES_SERVICE] No currency endpoints found on server');
    return [];
  }

  List<String> _parseCurrenciesFromResponse(dynamic data) {
    try {
      print('[CURRENCY_RATES_SERVICE] Parsing currency data: $data');

      if (data is Map<String, dynamic>) {
        if (data.containsKey('currencies')) {
          return List<String>.from(data['currencies']);
        } else if (data.containsKey('rates')) {
          final rates = data['rates'];
          if (rates is Map<String, dynamic>) {
            return List<String>.from(rates.keys);
          }
        }
      } else if (data is List) {
        return data.map((e) => e.toString()).toList();
      }
    } catch (e) {
      print('[CURRENCY_RATES_SERVICE] Error parsing currencies: $e');
    }
    return [];
  }

  Future<Map<String, double>> getExchangeRates({
    List<String>? currencies,
    required String serverUrl,
  }) async {
    print(
      '[CURRENCY_RATES_SERVICE] Getting exchange rates from server: $serverUrl',
    );

    if (serverUrl.isEmpty) {
      throw Exception('Server URL is required to get rates');
    }

    try {
      final lnbitsRates = await _getLNBitsRates(serverUrl, currencies);
      if (lnbitsRates.isNotEmpty) {
        print(
          '[CURRENCY_RATES_SERVICE] Got ${lnbitsRates.length} rates from server',
        );
        return lnbitsRates;
      }

      return _getHardcodedFallbackRates(currencies);
    } catch (e) {
      print('[CURRENCY_RATES_SERVICE] Server rates failed: $e');
      return _getHardcodedFallbackRates(currencies);
    }
  }

  Future<Map<String, double>> _getLNBitsRates(
    String serverUrl,
    List<String>? currencies,
  ) async {
    print(
      '[CURRENCY_RATES_SERVICE] Getting rates from server for currencies: $currencies',
    );

    if (currencies != null && currencies.isNotEmpty) {
      final Map<String, double> rates = {};

      for (final currency in currencies) {
        try {
          final endpoint = '$serverUrl/lnurlp/api/v1/rate/$currency';
          final response = await _dio.get(endpoint);

          if (response.statusCode == 200 && response.data != null) {
            final rate = _parseRateFromResponse(response.data, currency);
            if (rate != null && rate > 0) {
              rates[currency] = rate;
              print('[CURRENCY_RATES_SERVICE] Got rate for $currency: $rate');
            }
          }
        } catch (e) {
          print(
            '[CURRENCY_RATES_SERVICE] Failed to get rate for $currency: $e',
          );
          continue;
        }
      }

      if (rates.isNotEmpty) {
        print(
          '[CURRENCY_RATES_SERVICE] Successfully got ${rates.length} rates from server',
        );
        return rates;
      }
    }

    return {};
  }

  double? _parseRateFromResponse(dynamic data, String currency) {
    try {
      double? rate;

      if (data is Map<String, dynamic>) {
        if (data.containsKey('rate')) {
          rate = (data['rate'] as num).toDouble();
        } else if (data.containsKey(currency)) {
          rate = (data[currency] as num).toDouble();
        }
      } else if (data is num) {
        rate = data.toDouble();
      }

      if (rate != null && rate > 0 && rate < 10000000) {
        print('[CURRENCY_RATES_SERVICE] Valid rate for $currency: $rate');
        return rate;
      }
    } catch (e) {
      print('[CURRENCY_RATES_SERVICE] Error parsing rate for $currency: $e');
    }
    return null;
  }

  Map<String, double> _getHardcodedFallbackRates(List<String>? currencies) {
    print('[CURRENCY_RATES_SERVICE] Using emergency fallback rates');

    final Map<String, double> emergencyRates = {
      'USD': 95000.0,
      'EUR': 88000.0,
      'CUP': 28500000.0,
      'MLC': 95000.0,
      'GBP': 75000.0,
      'JPY': 14500000.0,
      'CAD': 135000.0,
      'AUD': 145000.0,
      'CHF': 82000.0,
      'CNY': 690000.0,
    };

    final Map<String, double> result = {};

    if (currencies != null && currencies.isNotEmpty) {
      for (final currency in currencies) {
        if (emergencyRates.containsKey(currency)) {
          result[currency] = emergencyRates[currency]!;
          print(
            '[CURRENCY_RATES_SERVICE] Emergency rate for $currency: ${emergencyRates[currency]}',
          );
        }
      }
    } else {
      result.addAll(emergencyRates);
    }

    if (result.isEmpty) {
      result['USD'] = 100000.0;
    }

    return result;
  }

  Future<String> convertSatsToFiat({
    required int sats,
    required String currency,
    Map<String, double>? rates,
    required String serverUrl,
  }) async {
    print('[CURRENCY_RATES_SERVICE] Converting $sats sats to $currency');

    try {
      final exchangeRates =
          rates ??
          await getExchangeRates(currencies: [currency], serverUrl: serverUrl);

      if (!exchangeRates.containsKey(currency)) {
        print('[CURRENCY_RATES_SERVICE] Rate not found for $currency');
        return '--';
      }

      final fiatRate = exchangeRates[currency]!;
      final btcAmount = sats / 100000000.0;
      final fiatAmount = btcAmount * fiatRate;

      print(
        '[CURRENCY_RATES_SERVICE] Calculation: $sats sats → $fiatAmount $currency',
      );

      String formatted;
      switch (currency) {
        case 'JPY':
        case 'CUP':
          formatted = fiatAmount.toStringAsFixed(0);
          break;
        case 'BTC':
          formatted = btcAmount.toStringAsFixed(8);
          break;
        default:
          formatted = fiatAmount.toStringAsFixed(2);
          break;
      }

      return formatted;
    } catch (e) {
      print('[CURRENCY_RATES_SERVICE] Error converting to $currency: $e');
      return '--';
    }
  }

  Future<int> convertFiatToSats({
    required double amount,
    required String currency,
    Map<String, double>? rates,
    required String serverUrl,
  }) async {
    print('[CURRENCY_RATES_SERVICE] Converting $amount $currency to sats');

    try {
      final exchangeRates =
          rates ??
          await getExchangeRates(currencies: [currency], serverUrl: serverUrl);

      if (!exchangeRates.containsKey(currency)) {
        throw Exception('Rate not available for $currency');
      }

      final fiatRate = exchangeRates[currency]!;
      final btcAmount = amount / fiatRate;
      final satsAmount = (btcAmount * 100000000).round();

      print('[CURRENCY_RATES_SERVICE] $amount $currency = $satsAmount sats');
      return satsAmount;
    } catch (e) {
      print('[CURRENCY_RATES_SERVICE] Error converting from $currency: $e');
      throw Exception('Conversion failed: $e');
    }
  }

  Future<bool> testCurrencyAvailability({
    required String currency,
    required String serverUrl,
  }) async {
    if (currency == 'sats' || currency == 'SAT') return true;

    try {
      final endpoint = '$serverUrl/lnurlp/api/v1/rate/$currency';
      final response = await _dio.get(endpoint);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('rate') &&
            data['rate'] is num &&
            data['rate'] > 0) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('[CURRENCY_RATES_SERVICE] Currency $currency test failed: $e');
      return false;
    }
  }

  void dispose() {
    _dio.close();
  }
}
