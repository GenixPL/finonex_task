import 'dart:async';

import 'package:finonex_task/models/ticker/model/ticker_data.dart';
import 'package:finonex_task/models/ticker/model/ticker_model.dart';
import 'package:finonex_task/models/ticker/service/ticker_service.dart';

class TickerModelImpl extends TickerModel {
  TickerModelImpl({
    required this._service,
  });

  // TODO(genix): add throttling (if we have given sub it should mark as needing emit and periodic timer should then emit all updates)

  final TickerService _service;

  StreamController<TickerData>? _controller;

  @override
  Stream<TickerData>? getTickerStream(String symbol) {
    if (_controller == null) {
      _controller = StreamController<TickerData>.broadcast();
      _startStreaming();
    }

    return _controller!.stream.where((ticker) => ticker.symbol == symbol);
  }

  Future<void> _startStreaming() async {
    while (true) {
      try {
        final stream = await _service.getTickerDataStream();
        await for (final data in stream) {
          _controller?.add(data);
        }
      } catch (e) {
        _controller?.addError(e);
      }

      // TODO(genix): the 2s are visible, but it works
      // Wait before reconnecting to avoid tight loops on persistent errors
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}
