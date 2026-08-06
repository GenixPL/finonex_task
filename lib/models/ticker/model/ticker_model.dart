import 'package:finonex_task/models/ticker/_ticker.dart';
import 'package:rxdart/rxdart.dart';

abstract class TickerModel {
  Stream<TickerData> getTickerStream(String symbol);

  ValueStream<TickerConnectionState> get connectionStream;
}
