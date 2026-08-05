import 'package:finonex_task/models/ticker/model/ticker_data.dart';

abstract class TickerModel {
  Stream<TickerData>? getTickerStream(String symbol);
}
