class CurrencyInfo {
  final String code;
  final String name;
  final String symbol;
  final String flag;
  final String country;

  const CurrencyInfo({
    required this.code,
    required this.name,
    required this.symbol,
    required this.flag,
    required this.country,
  });

  static const Map<String, CurrencyInfo> _currencies = {
    'USD': CurrencyInfo(
      code: 'USD',
      name: 'US Dollar',
      symbol: '\$',
      flag: '🇺🇸',
      country: 'United States',
    ),
    'EUR': CurrencyInfo(
      code: 'EUR',
      name: 'Euro',
      symbol: '€',
      flag: '🇪🇺',
      country: 'European Union',
    ),
    'CUP': CurrencyInfo(
      code: 'CUP',
      name: 'Cuban Peso',
      symbol: '₱',
      flag: '🇨🇺',
      country: 'Cuba',
    ),
    'MLC': CurrencyInfo(
      code: 'MLC',
      name: 'Convertible Peso',
      symbol: '₽',
      flag: '🇨🇺',
      country: 'Cuba',
    ),
    'SAT': CurrencyInfo(
      code: 'SAT',
      name: 'Satoshis',
      symbol: '⚡',
      flag: '₿',
      country: 'Bitcoin',
    ),
    'GBP': CurrencyInfo(
      code: 'GBP',
      name: 'British Pound',
      symbol: '£',
      flag: '🇬🇧',
      country: 'United Kingdom',
    ),
    'JPY': CurrencyInfo(
      code: 'JPY',
      name: 'Japanese Yen',
      symbol: '¥',
      flag: '🇯🇵',
      country: 'Japan',
    ),
    'CAD': CurrencyInfo(
      code: 'CAD',
      name: 'Canadian Dollar',
      symbol: 'CA\$',
      flag: '🇨🇦',
      country: 'Canada',
    ),
    'AUD': CurrencyInfo(
      code: 'AUD',
      name: 'Australian Dollar',
      symbol: 'A\$',
      flag: '🇦🇺',
      country: 'Australia',
    ),
    'CHF': CurrencyInfo(
      code: 'CHF',
      name: 'Swiss Franc',
      symbol: 'Fr',
      flag: '🇨🇭',
      country: 'Switzerland',
    ),
    'CNY': CurrencyInfo(
      code: 'CNY',
      name: 'Chinese Yuan',
      symbol: '¥',
      flag: '🇨🇳',
      country: 'China',
    ),
    'MXN': CurrencyInfo(
      code: 'MXN',
      name: 'Mexican Peso',
      symbol: 'MX\$',
      flag: '🇲🇽',
      country: 'Mexico',
    ),
    'BRL': CurrencyInfo(
      code: 'BRL',
      name: 'Brazilian Real',
      symbol: 'R\$',
      flag: '🇧🇷',
      country: 'Brazil',
    ),
  };

  static CurrencyInfo? getInfo(String currencyCode) {
    return _currencies[currencyCode.toUpperCase()];
  }

  static List<String> get availableCodes => _currencies.keys.toList();

  static String getName(String currencyCode) {
    return getInfo(currencyCode)?.name ?? currencyCode;
  }

  static String getSymbol(String currencyCode) {
    return getInfo(currencyCode)?.symbol ?? currencyCode;
  }

  static String getFlag(String currencyCode) {
    return getInfo(currencyCode)?.flag ?? '💰';
  }

  static String getCountry(String currencyCode) {
    return getInfo(currencyCode)?.country ?? currencyCode;
  }
}
