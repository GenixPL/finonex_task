class InstrumentData {
  final String symbol;
  final String name;
  final int decimals;

  InstrumentData({
    required this.symbol,
    required this.name,
    required this.decimals,
  });

  factory InstrumentData.fromJson(Map<String, dynamic> json) {
    return InstrumentData(
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      decimals: json['decimals'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'decimals': decimals,
    };
  }

  @override
  String toString() {
    return 'Instrument(symbol: $symbol, name: $name, decimals: $decimals)';
  }
}
