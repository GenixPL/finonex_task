import 'dart:async';

import 'package:finonex_task/models/auth/_auth.dart';
import 'package:finonex_task/models/ticker/model/ticker_connection_state.dart';
import 'package:finonex_task/models/ticker/model/ticker_data.dart';
import 'package:finonex_task/models/ticker/model/ticker_model.dart';
import 'package:finonex_task/models/ticker/service/ticker_service.dart';
import 'package:finonex_task/services/connectivity/_connectivity.dart';
import 'package:rxdart/rxdart.dart';

class TickerModelImpl extends TickerModel {
  TickerModelImpl({
    required this._authModel,
    required this._connectivityService,
    required this._tickerService,
  });

  // TODO(genix): add throttling (if we have given sub it should mark as needing emit and periodic timer should then emit all updates)

  final AuthModel _authModel;
  final ConnectivityService _connectivityService;
  final TickerService _tickerService;

  final BehaviorSubject<TickerConnectionState> _connectionStream = BehaviorSubject.seeded(
    TickerConnectionState.connecting,
  );
  StreamController<TickerData>? _controller;
  Timer? _stalledTimer;

  @override
  Stream<TickerData> getTickerStream(String symbol) {
    if (_controller == null) {
      _controller = StreamController<TickerData>.broadcast();
      unawaited(_startStreaming());
    }

    return _controller!.stream.where((ticker) => ticker.symbol == symbol);
  }

  @override
  ValueStream<TickerConnectionState> get connectionStream => _connectionStream.stream;

  Future<void> dispose() async {
    await _connectionStream.close();
    await _controller?.close();
    _stalledTimer?.cancel();
  }

  Future<void> _startStreaming() async {
    while (!_connectionStream.isClosed) {
      try {
        final stream = await _tickerService.getTickerDataStream();
        if (_connectionStream.isClosed) break;

        _connectionStream.add(TickerConnectionState.live);
        _resetStalledTimer();

        await for (final data in stream) {
          if (_connectionStream.isClosed) break;
          _controller?.add(data);
          _resetStalledTimer();
        }
      } catch (e) {
        if (!_connectionStream.isClosed) {
          _controller?.addError(e);
        }
      }

      if (_connectionStream.isClosed) break;

      _stalledTimer?.cancel();
      _connectionStream.add(TickerConnectionState.reconnecting);

      // TODO(genix): the 2s are visible, but it works
      // Wait before reconnecting to avoid tight loops on persistent errors
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  Future<void> _stopStreaming() async {}

  void _resetStalledTimer() {
    _stalledTimer?.cancel();
    _stalledTimer = Timer(const Duration(seconds: 5), () {
      if (_connectionStream.isClosed) {
        return;
      }

      if (_connectionStream.value != TickerConnectionState.live) {
        // If not live, then don't update to stalled.
        return;
      }

      _connectionStream.add(TickerConnectionState.stalled);
    });
  }
}
