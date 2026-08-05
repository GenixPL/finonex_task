import 'package:finonex_task/models/ticker/model/ticker_data.dart';
import 'package:finonex_task/models/ticker/model/ticker_model.dart';
import 'package:finonex_task/models/ticker/service/ticker_service.dart';

class TickerModelImpl extends TickerModel {
  TickerModelImpl({
    required this._service,
  });

  final TickerService _service;

  Stream<TickerData>? _sharedStream;

  @override
  Stream<TickerData>? getTickerStream(String symbol) {
    final shared = _sharedStream ??= Stream.fromFuture(
      _service.getTickerDataStream(),
    ).asyncExpand((stream) => stream).asBroadcastStream();

    return shared.where((ticker) => ticker.symbol == symbol);
  }
}
