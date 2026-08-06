import 'dart:async';

import 'package:finonex_task/models/auth/_auth.dart';
import 'package:finonex_task/models/ticker/model/ticker_connection_state.dart';
import 'package:finonex_task/models/ticker/model/ticker_data.dart';
import 'package:finonex_task/models/ticker/model/ticker_event.dart';
import 'package:finonex_task/models/ticker/model/ticker_model.dart';
import 'package:finonex_task/models/ticker/service/ticker_service.dart';
import 'package:finonex_task/services/connectivity/_connectivity.dart';
import 'package:rxdart/rxdart.dart';

// Not closing stuff here as it's gonna live for the whole session and time is of essence now.
class TickerModelImpl extends TickerModel {
  TickerModelImpl({
    required this._authModel,
    required this._connectivityService,
    required this._tickerService,
  }) {
    _init();
  }

  // TODO(genix): add throttling (if we have given sub it should mark as needing emit and periodic timer should then emit all updates)

  // region Dependencies

  final AuthModel _authModel;
  final ConnectivityService _connectivityService;
  final TickerService _tickerService;

  // endregion

  // region Values

  final BehaviorSubject<TickerConnectionState> _connectionStream = BehaviorSubject.seeded(
    TickerConnectionState.connecting,
  );

  Timer? _stalledTimer;

  StreamSubscription<TickerEvent>? _serviceSubscription;
  Map<String, BehaviorSubject<TickerData>> _tickerStreams = {};

  Timer? _bufferTimer;
  Map<String, TickerData> _buffer = {};

  // endregion

  // region Public

  @override
  Stream<TickerData> getTickerStream(String symbol) => _getTickerStream(symbol);

  @override
  ValueStream<TickerConnectionState> get connectionStream => _connectionStream.stream;

  // endregion

  // region Private

  void _init() {
    CombineLatestStream.combine2(
      _authModel.stateStream,
      _connectivityService.stateStream,
      (authState, connectivityState) => (authState, connectivityState),
    ).listen((states) {
      switch (states.$1) {
        case AuthState.noUser:
          unawaited(_stopStreaming());
          return;

        case AuthState.user:
          break;
      }

      switch (states.$2) {
        case ConnectivityState.unknown:
        case ConnectivityState.notConnected:
          unawaited(_stopStreaming());
          return;

        case ConnectivityState.connected:
          unawaited(_startStreaming());
          return;
      }
    });
  }

  Future<void> _startStreaming() async {
    print('start streaming');

    if (_connectionStream.value == TickerConnectionState.live ||
        _connectionStream.value == TickerConnectionState.connecting) {
      return;
    }

    _connectionStream.add(TickerConnectionState.connecting);

    _setBufferTimer();

    try {
      final stream = await _tickerService.getTickerDataStream();

      _setStalledTimer();

      _serviceSubscription = stream.listen(
        (event) {
          switch (event) {
            case TickerTickEvent(data: final data):
              if (_connectionStream.value != TickerConnectionState.live) {
                _connectionStream.add(TickerConnectionState.live);
              }

              _setStalledTimer();

              _buffer[data.symbol] = data;

            case TickerPingEvent():
              print('ping, resetting stalled timer');
              _setStalledTimer();

            case TickerGapEvent(resumeFrom: final resumeFrom):
              print('Gap in stream, resume from $resumeFrom');

            case TickerUnknownEvent(event: final eventName, data: final data):
              print('Unknown event: $eventName, data: $data');
          }
        },
        onError: (_) => unawaited(_markStalled()),
        onDone: () => unawaited(_markStalled()),
        cancelOnError: true,
      );
    } catch (e) {
      unawaited(_markStalled());
    }
  }

  Future<void> _stopStreaming() async {
    print('stop streaming');

    await _serviceSubscription?.cancel();
    _serviceSubscription = null;

    _stalledTimer?.cancel();

    _flushBuffer();
    _bufferTimer?.cancel();

    _connectionStream.add(TickerConnectionState.disconnected);
  }

  void _setBufferTimer() {
    _bufferTimer?.cancel();
    _bufferTimer = Timer(const Duration(milliseconds: 500), _flushBuffer);
  }

  void _setStalledTimer() {
    _stalledTimer?.cancel();
    _stalledTimer = Timer(const Duration(seconds: 8), () async {
      if (_connectionStream.isClosed) {
        return;
      }

      if (_connectionStream.value != TickerConnectionState.live) {
        // If not live, then don't update to stalled.
        return;
      }

      _markStalled();
    });
  }

  Future<void> _flushBuffer() async {
    if (_buffer.isNotEmpty) {
      final updates = Map<String, TickerData>.from(_buffer);
      _buffer.clear();

      for (final entry in updates.entries) {
        _getTickerStream(entry.key).add(entry.value);
      }
    }

    _setBufferTimer();
  }

  Future<void> _markStalled() async {
    print('marking stalled');

    _connectionStream.add(TickerConnectionState.stalled);

    await _stopStreaming();

    // TODO(genix): this could be dynamic (increasing and reset)
    await Future.delayed(const Duration(milliseconds: 500));

    await _startStreaming();
  }

  BehaviorSubject<TickerData> _getTickerStream(String symbol) {
    final BehaviorSubject<TickerData>? stream = _tickerStreams[symbol];
    if (stream != null) {
      return stream;
    }

    final BehaviorSubject<TickerData> newStream = BehaviorSubject();
    _tickerStreams[symbol] = newStream;
    return newStream;
  }

  // endregion
}
