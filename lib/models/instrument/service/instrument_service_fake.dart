import 'package:finonex_task/models/instrument/_instrument.dart';

class InstrumentServiceFake extends InstrumentService {
  @override
  Future<List<InstrumentData>?> getInstruments() async {
    return [
      InstrumentData(symbol: 'EURUSD', name: 'Euro / US Dollar', decimals: 5),
      InstrumentData(symbol: 'GBPUSD', name: 'British Pound / US Dollar', decimals: 5),
      InstrumentData(symbol: 'USDJPY', name: 'US Dollar / Japanese Yen', decimals: 3),
      InstrumentData(symbol: 'USDCHF', name: 'US Dollar / Swiss Franc', decimals: 5),
      InstrumentData(symbol: 'AUDUSD', name: 'Australian Dollar / US Dollar', decimals: 5),
      InstrumentData(symbol: 'USDCAD', name: 'US Dollar / Canadian Dollar', decimals: 5),
      InstrumentData(symbol: 'NZDUSD', name: 'New Zealand Dollar / US Dollar', decimals: 5),
      InstrumentData(symbol: 'EURGBP', name: 'Euro / British Pound', decimals: 5),
      InstrumentData(symbol: 'EURJPY', name: 'Euro / Japanese Yen', decimals: 3),
      InstrumentData(symbol: 'GBPJPY', name: 'British Pound / Japanese Yen', decimals: 3),
      InstrumentData(symbol: 'EURCHF', name: 'Euro / Swiss Franc', decimals: 5),
      InstrumentData(symbol: 'AUDJPY', name: 'Australian Dollar / Japanese Yen', decimals: 3),
      InstrumentData(symbol: 'CADJPY', name: 'Canadian Dollar / Japanese Yen', decimals: 3),
      InstrumentData(symbol: 'CHFJPY', name: 'Swiss Franc / Japanese Yen', decimals: 3),
      InstrumentData(symbol: 'EURAUD', name: 'Euro / Australian Dollar', decimals: 5),
      InstrumentData(symbol: 'GBPAUD', name: 'British Pound / Australian Dollar', decimals: 5),
      InstrumentData(symbol: 'XAUUSD', name: 'Gold', decimals: 2),
      InstrumentData(symbol: 'XAGUSD', name: 'Silver', decimals: 3),
      InstrumentData(symbol: 'XPTUSD', name: 'Platinum', decimals: 2),
      InstrumentData(symbol: 'WTIUSD', name: 'Crude Oil WTI', decimals: 2),
      InstrumentData(symbol: 'BRNUSD', name: 'Crude Oil Brent', decimals: 2),
      InstrumentData(symbol: 'NATGAS', name: 'Natural Gas', decimals: 3),
      InstrumentData(symbol: 'US500', name: 'S&P 500', decimals: 1),
      InstrumentData(symbol: 'US30', name: 'Dow Jones 30', decimals: 1),
      InstrumentData(symbol: 'NAS100', name: 'Nasdaq 100', decimals: 1),
      InstrumentData(symbol: 'GER40', name: 'DAX 40', decimals: 1),
      InstrumentData(symbol: 'UK100', name: 'FTSE 100', decimals: 1),
      InstrumentData(symbol: 'JPN225', name: 'Nikkei 225', decimals: 0),
      InstrumentData(symbol: 'FRA40', name: 'CAC 40', decimals: 1),
      InstrumentData(symbol: 'BTCUSD', name: 'Bitcoin', decimals: 2),
      InstrumentData(symbol: 'ETHUSD', name: 'Ethereum', decimals: 2),
      InstrumentData(symbol: 'SOLUSD', name: 'Solana', decimals: 3),
      InstrumentData(symbol: 'XRPUSD', name: 'Ripple', decimals: 5),
      InstrumentData(symbol: 'AAPL', name: 'Apple Inc.', decimals: 2),
      InstrumentData(symbol: 'MSFT', name: 'Microsoft Corp.', decimals: 2),
      InstrumentData(symbol: 'AMZN', name: 'Amazon.com Inc.', decimals: 2),
      InstrumentData(symbol: 'GOOGL', name: 'Alphabet Inc.', decimals: 2),
      InstrumentData(symbol: 'TSLA', name: 'Tesla Inc.', decimals: 2),
      InstrumentData(symbol: 'NVDA', name: 'NVIDIA Corp.', decimals: 2),
      InstrumentData(symbol: 'META', name: 'Meta Platforms Inc.', decimals: 2),
    ];
  }
}
