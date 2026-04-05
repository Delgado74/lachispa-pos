import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/currency_rates_service.dart';
import '../models/currency_info.dart';

class CurrencySettingsProvider extends ChangeNotifier {
  final CurrencyRatesService _ratesService = CurrencyRatesService();

  List<String> _selectedCurrencies = ['USD', 'CUP'];
  List<String> _availableCurrencies = [];
  Map<String, double> _exchangeRates = {};
  DateTime? _lastRatesUpdate;

  bool _isLoadingCurrencies = false;
  bool _isLoadingRates = false;
  bool _isInitialized = false;

  String? _serverUrl;

  static const String _selectedCurrenciesKey = 'selected_currencies';
  static const String _exchangeRatesKey = 'exchange_rates_cache';
  static const String _lastUpdateKey = 'last_rates_update';

  List<String> get selectedCurrencies => List<String>.from(_selectedCurrencies);
  List<String> get availableCurrencies =>
      List<String>.from(_availableCurrencies);
  Map<String, double> get exchangeRates =>
      Map<String, double>.from(_exchangeRates);
  bool get isLoadingCurrencies => _isLoadingCurrencies;
  bool get isLoadingRates => _isLoadingRates;
  bool get isInitialized => _isInitialized;
  DateTime? get lastRatesUpdate => _lastRatesUpdate;

  List<String> get displaySequence => ['SAT', ..._selectedCurrencies];

  CurrencyInfo? getCurrencyInfo(String currencyCode) {
    return CurrencyInfo.getInfo(currencyCode);
  }

  String getCurrencyDisplayName(String currencyCode) {
    final info = CurrencyInfo.getInfo(currencyCode);
    return info?.name ?? currencyCode;
  }

  String getCurrencySymbol(String currencyCode) {
    final info = CurrencyInfo.getInfo(currencyCode);
    return info?.symbol ?? currencyCode;
  }

  String getCurrencyFlag(String currencyCode) {
    final info = CurrencyInfo.getInfo(currencyCode);
    return info?.flag ?? '💰';
  }

  String getCurrencyCountry(String currencyCode) {
    final info = CurrencyInfo.getInfo(currencyCode);
    return info?.country ?? currencyCode;
  }

  Future<void> initialize({required String serverUrl}) async {
    if (_isInitialized) return;

    print('[CURRENCY_SETTINGS_PROVIDER] Initializing with server: $serverUrl');

    _serverUrl = serverUrl;

    _availableCurrencies = [
      'USD',
      'EUR',
      'CUP',
      'MLC',
      'GBP',
      'CAD',
      'JPY',
      'AUD',
      'CHF',
    ];

    await _loadSavedSettings();
    _validateSelectedCurrencies();

    if (_selectedCurrencies.isNotEmpty) {
      await loadExchangeRates();
    }

    _isInitialized = true;
  }

  Future<void> loadAvailableCurrencies() async {
    _availableCurrencies = [
      'USD',
      'EUR',
      'CUP',
      'MLC',
      'GBP',
      'CAD',
      'JPY',
      'AUD',
      'CHF',
    ];

    if (_serverUrl != null && _serverUrl!.isNotEmpty) {
      _isLoadingCurrencies = true;
      notifyListeners();

      try {
        print('[CURRENCY_SETTINGS_PROVIDER] Loading currencies from server');
        final serverCurrencies = await _ratesService.getAvailableCurrencies(
          serverUrl: _serverUrl!,
        );

        if (serverCurrencies.isNotEmpty) {
          print(
            '[CURRENCY_SETTINGS_PROVIDER] SUCCESS: ${serverCurrencies.length} currencies',
          );

          for (final currency in serverCurrencies) {
            if (!_availableCurrencies.contains(currency)) {
              _availableCurrencies.add(currency);
            }
          }
        }
        _validateSelectedCurrencies();
      } catch (e) {
        print('[CURRENCY_SETTINGS_PROVIDER] FAILED: $e');
      } finally {
        _isLoadingCurrencies = false;
        notifyListeners();
      }
    } else {
      notifyListeners();
    }
  }

  Future<void> loadExchangeRates({bool forceRefresh = false}) async {
    if (_isLoadingRates) return;

    if (_serverUrl == null || _serverUrl!.isEmpty) {
      _exchangeRates = _getHardcodedFallbackRates(_selectedCurrencies);
      _lastRatesUpdate = DateTime.now();
      notifyListeners();
      return;
    }

    if (!forceRefresh && _lastRatesUpdate != null) {
      final timeSinceUpdate = DateTime.now().difference(_lastRatesUpdate!);
      if (timeSinceUpdate.inMinutes < 5) {
        print('[CURRENCY_SETTINGS_PROVIDER] Using cached rates');
        return;
      }
    }

    _isLoadingRates = true;
    notifyListeners();

    try {
      print('[CURRENCY_SETTINGS_PROVIDER] Loading rates from server');

      _exchangeRates = await _ratesService.getExchangeRates(
        currencies: _selectedCurrencies,
        serverUrl: _serverUrl!,
      );

      _lastRatesUpdate = DateTime.now();
      print(
        '[CURRENCY_SETTINGS_PROVIDER] SUCCESS: ${_exchangeRates.length} rates',
      );
      await _saveRatesToCache();
    } catch (e) {
      print('[CURRENCY_SETTINGS_PROVIDER] FAILED: $e, using fallback');
      _exchangeRates = _getHardcodedFallbackRates(_selectedCurrencies);
      _lastRatesUpdate = DateTime.now();
    } finally {
      _isLoadingRates = false;
      notifyListeners();
    }
  }

  Future<void> setSelectedCurrencies(List<String> currencies) async {
    print(
      '[CURRENCY_SETTINGS_PROVIDER] Setting selected currencies: $currencies',
    );

    final validCurrencies = currencies
        .where(
          (currency) =>
              currency != 'SAT' && _availableCurrencies.contains(currency),
        )
        .toList();

    if (validCurrencies.isEmpty) {
      print(
        '[CURRENCY_SETTINGS_PROVIDER] No valid currencies, keeping defaults',
      );
      return;
    }

    _selectedCurrencies = validCurrencies;
    await _saveSelectedCurrencies();
    await loadExchangeRates(forceRefresh: true);
    notifyListeners();
  }

  Future<void> addCurrency(String currencyCode) async {
    if (!_availableCurrencies.contains(currencyCode) ||
        _selectedCurrencies.contains(currencyCode) ||
        currencyCode == 'SAT') {
      return;
    }

    final newList = [..._selectedCurrencies, currencyCode];
    await setSelectedCurrencies(newList);
  }

  Future<void> removeCurrency(String currencyCode) async {
    if (!_selectedCurrencies.contains(currencyCode)) return;

    final newList = _selectedCurrencies
        .where((c) => c != currencyCode)
        .toList();

    if (newList.isEmpty) {
      newList.add('USD');
    }

    await setSelectedCurrencies(newList);
  }

  Future<void> reorderCurrencies(int oldIndex, int newIndex) async {
    if (oldIndex < 0 ||
        oldIndex >= _selectedCurrencies.length ||
        newIndex < 0 ||
        newIndex >= _selectedCurrencies.length) {
      return;
    }

    final newList = List<String>.from(_selectedCurrencies);
    final item = newList.removeAt(oldIndex);
    newList.insert(newIndex, item);

    await setSelectedCurrencies(newList);
  }

  bool isCurrencySelected(String currencyCode) {
    return currencyCode == 'SAT' || _selectedCurrencies.contains(currencyCode);
  }

  Future<bool> validateCurrencyAvailability(String currencyCode) async {
    if (currencyCode == 'SAT') return true;

    if (_serverUrl == null || _serverUrl!.isEmpty) {
      return _availableCurrencies.contains(currencyCode);
    }

    try {
      return await _ratesService.testCurrencyAvailability(
        currency: currencyCode,
        serverUrl: _serverUrl!,
      );
    } catch (e) {
      print('[CURRENCY_SETTINGS_PROVIDER] Error validating $currencyCode: $e');
      return false;
    }
  }

  double? getRateForCurrency(String currencyCode) {
    return _exchangeRates[currencyCode];
  }

  Future<String> convertSatsToFiat(int sats, String currencyCode) async {
    print(
      '[CURRENCY_SETTINGS_PROVIDER] convertSatsToFiat called: $sats sats to $currencyCode',
    );

    if (currencyCode == 'SAT') {
      return '$sats';
    }

    if (_serverUrl == null || _serverUrl!.isEmpty) {
      return '--';
    }

    try {
      final result = await _ratesService.convertSatsToFiat(
        sats: sats,
        currency: currencyCode,
        rates: _exchangeRates,
        serverUrl: _serverUrl!,
      );

      print('[CURRENCY_SETTINGS_PROVIDER] Conversion result: $result');
      return result;
    } catch (e) {
      print('[CURRENCY_SETTINGS_PROVIDER] Conversion failed: $e');
      return '--';
    }
  }

  Future<int> convertFiatToSats(double amount, String currencyCode) async {
    if (currencyCode == 'SAT') {
      return amount.round();
    }

    if (_serverUrl == null || _serverUrl!.isEmpty) {
      throw Exception('No server URL');
    }

    try {
      return await _ratesService.convertFiatToSats(
        amount: amount,
        currency: currencyCode,
        rates: _exchangeRates,
        serverUrl: _serverUrl!,
      );
    } catch (e) {
      print('[CURRENCY_SETTINGS_PROVIDER] Conversion failed: $e');
      throw Exception('Conversion failed');
    }
  }

  Future<void> updateServerUrl(String? serverUrl) async {
    if (_serverUrl == serverUrl) return;

    print(
      '[CURRENCY_SETTINGS_PROVIDER] Updating server URL: ${serverUrl ?? 'none'}',
    );
    _serverUrl = serverUrl;

    _exchangeRates.clear();
    _availableCurrencies.clear();
    _lastRatesUpdate = null;

    await loadAvailableCurrencies();
    await loadExchangeRates(forceRefresh: true);
  }

  void _validateSelectedCurrencies() {
    if (_availableCurrencies.isEmpty) return;

    final validCurrencies = _selectedCurrencies
        .where((currency) => _availableCurrencies.contains(currency))
        .toList();

    if (validCurrencies.isEmpty) {
      validCurrencies.addAll(
        ['USD', 'EUR'].where((c) => _availableCurrencies.contains(c)),
      );

      if (validCurrencies.isEmpty && _availableCurrencies.isNotEmpty) {
        validCurrencies.add(_availableCurrencies.first);
      }
    }

    if (validCurrencies.length != _selectedCurrencies.length) {
      print(
        '[CURRENCY_SETTINGS_PROVIDER] Validated currencies: ${validCurrencies.length}/${_selectedCurrencies.length}',
      );
      _selectedCurrencies = validCurrencies;
      _saveSelectedCurrencies();
    }
  }

  Future<void> _loadSavedSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final savedCurrencies = prefs.getStringList(_selectedCurrenciesKey);
      if (savedCurrencies != null && savedCurrencies.isNotEmpty) {
        _selectedCurrencies = savedCurrencies;
        print(
          '[CURRENCY_SETTINGS_PROVIDER] Loaded saved currencies: $_selectedCurrencies',
        );
      }

      await _loadRatesFromCache();
    } catch (e) {
      print('[CURRENCY_SETTINGS_PROVIDER] Error loading settings: $e');
    }
  }

  Future<void> _saveSelectedCurrencies() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_selectedCurrenciesKey, _selectedCurrencies);
      print(
        '[CURRENCY_SETTINGS_PROVIDER] Saved currencies: $_selectedCurrencies',
      );
    } catch (e) {
      print('[CURRENCY_SETTINGS_PROVIDER] Error saving currencies: $e');
    }
  }

  Future<void> _saveRatesToCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final ratesJson = _exchangeRates.map(
        (key, value) => MapEntry(key, value.toString()),
      );
      final ratesString = ratesJson.entries
          .map((e) => '${e.key}:${e.value}')
          .join(',');

      await prefs.setString(_exchangeRatesKey, ratesString);
      await prefs.setString(
        _lastUpdateKey,
        _lastRatesUpdate?.millisecondsSinceEpoch.toString() ?? '',
      );

      print(
        '[CURRENCY_SETTINGS_PROVIDER] Saved ${_exchangeRates.length} rates to cache',
      );
    } catch (e) {
      print('[CURRENCY_SETTINGS_PROVIDER] Error saving cache: $e');
    }
  }

  Future<void> _loadRatesFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final ratesString = prefs.getString(_exchangeRatesKey);
      final lastUpdateString = prefs.getString(_lastUpdateKey);

      if (ratesString != null && ratesString.isNotEmpty) {
        final rates = <String, double>{};

        for (final pair in ratesString.split(',')) {
          final parts = pair.split(':');
          if (parts.length == 2) {
            rates[parts[0]] = double.tryParse(parts[1]) ?? 0.0;
          }
        }

        if (rates.isNotEmpty) {
          _exchangeRates = rates;
          print(
            '[CURRENCY_SETTINGS_PROVIDER] Loaded ${rates.length} rates from cache',
          );
        }
      }

      if (lastUpdateString != null && lastUpdateString.isNotEmpty) {
        final timestamp = int.tryParse(lastUpdateString);
        if (timestamp != null) {
          _lastRatesUpdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
        }
      }
    } catch (e) {
      print('[CURRENCY_SETTINGS_PROVIDER] Error loading cache: $e');
    }
  }

  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_exchangeRatesKey);
      await prefs.remove(_lastUpdateKey);

      _exchangeRates.clear();
      _lastRatesUpdate = null;

      print('[CURRENCY_SETTINGS_PROVIDER] Cleared cache');
      notifyListeners();
    } catch (e) {
      print('[CURRENCY_SETTINGS_PROVIDER] Error clearing cache: $e');
    }
  }

  Map<String, double> _getHardcodedFallbackRates(List<String>? currencies) {
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

  @override
  void dispose() {
    _ratesService.dispose();
    super.dispose();
  }
}
