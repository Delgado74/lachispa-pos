enum Moneda {
  cup('CUP', 'Peso Cubano', '₱'),
  mlc('MLC', 'Peso Convertible', '₽'),
  usd('USD', 'Dólar Estadounidense', '\$'),
  eur('EUR', 'Euro', '€'),
  gbp('GBP', 'Libra Esterlina', '£'),
  cad('CAD', 'Dólar Canadiense', 'CA\$'),
  jpy('JPY', 'Yen Japonés', '¥'),
  aud('AUD', 'Dólar Australiano', 'A\$'),
  chf('CHF', 'Franco Suizo', 'Fr'),
  sat('SAT', 'Satoshis', '⚡');

  final String codigo;
  final String nombre;
  final String simbolo;

  const Moneda(this.codigo, this.nombre, this.simbolo);

  static Moneda fromCodigo(String codigo) {
    return Moneda.values.firstWhere(
      (m) => m.codigo.toUpperCase() == codigo.toUpperCase(),
      orElse: () => Moneda.usd,
    );
  }
}
