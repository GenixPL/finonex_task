class TickerData {
  final String symbol;
  final double bid;
  final double ask;
  final int timestamp;

  TickerData({
    required this.symbol,
    required this.bid,
    required this.ask,
    required this.timestamp,
  });

  factory TickerData.fromJson(Map<String, dynamic> json) {
    return TickerData(
      symbol: json['s'] as String,
      bid: (json['b'] as num).toDouble(),
      ask: (json['a'] as num).toDouble(),
      timestamp: json['ts'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      's': symbol,
      'b': bid,
      'a': ask,
      'ts': timestamp,
    };
  }

  @override
  String toString() {
    return 'TickerData(symbol: $symbol, bid: $bid, ask: $ask, timestamp: $timestamp)';
  }
}
