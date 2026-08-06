// ignore_for_file: close_sinks

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
    this.stalledDuration = const Duration(seconds: 8),
    this.bufferDuration = const Duration(milliseconds: 500),
    this.initialReconnectDelay = const Duration(milliseconds: 500),
  }) {
    _currentReconnectDelay = initialReconnectDelay;
    _init();
  }

  // TODO(genix): add throttling (if we have given sub it should mark as needing emit and periodic timer should then emit all updates)

  // region Dependencies

  final AuthModel _authModel;
  final ConnectivityService _connectivityService;
  final TickerService _tickerService;

  final Duration stalledDuration;
  final Duration bufferDuration;
  final Duration initialReconnectDelay;

  // endregion

  // region Values

  static const _maxReconnectDelay = Duration(seconds: 30);

  late Duration _currentReconnectDelay;
  bool _isReconnecting = false;

  final BehaviorSubject<TickerConnectionState> _connectionStream = BehaviorSubject.seeded(
    TickerConnectionState.connecting,
  );

  Timer? _stalledTimer;

  StreamSubscription<TickerEvent>? _serviceSubscription;
  final Map<String, BehaviorSubject<TickerData>> _tickerStreams = {};

  String? _lastEventId;

  Timer? _bufferTimer;
  final Map<String, TickerData> _buffer = {};

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
          _resetReconnectDelay();
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
      final stream = await _tickerService.getTickerDataStream(lastEventId: _lastEventId);

      _setStalledTimer();

      _serviceSubscription = stream.listen(
        (event) {
          switch (event) {
            case TickerTickEvent tickEvent:
              if (_connectionStream.value != TickerConnectionState.live) {
                _connectionStream.add(TickerConnectionState.live);
                _resetReconnectDelay();
              }
              _setStalledTimer();
              _lastEventId = tickEvent.id;
              _handleTickEvent(tickEvent);

            case TickerPingEvent():
              print('ping, resetting stalled timer');
              if (_connectionStream.value != TickerConnectionState.live) {
                _connectionStream.add(TickerConnectionState.live);
              }
              _setStalledTimer();
              _resetReconnectDelay();

            case TickerGapEvent(resumeFrom: final resumeFrom):
              print('Gap in stream, resume from $resumeFrom');
              _lastEventId = (resumeFrom - 1).toString();
              unawaited(_markStalled());

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

  void _handleTickEvent(TickerTickEvent event) {
    final incomingData = event.data;
    final symbol = incomingData.symbol;

    final bufferedData = _buffer[symbol];
    if (bufferedData != null && bufferedData.timestamp >= incomingData.timestamp) {
      return;
    }

    // TODO(genix): needed?
    final stream = _tickerStreams[symbol];
    if (stream != null && stream.hasValue && stream.value.timestamp >= incomingData.timestamp) {
      return;
    }

    _buffer[symbol] = incomingData;
  }

  Future<void> _stopStreaming({TickerConnectionState targetState = TickerConnectionState.disconnected}) async {
    print('stop streaming');

    await _serviceSubscription?.cancel();
    _serviceSubscription = null;

    _stalledTimer?.cancel();

    _flushBuffer();
    _bufferTimer?.cancel();

    _connectionStream.add(targetState);
  }

  void _setBufferTimer() {
    _bufferTimer?.cancel();
    _bufferTimer = Timer(bufferDuration, _flushBuffer);
  }

  void _setStalledTimer() {
    _stalledTimer?.cancel();
    _stalledTimer = Timer(stalledDuration, () async {
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
    if (_isReconnecting) {
      return;
    }
    _isReconnecting = true;

    try {
      print('marking stalled');

      await _stopStreaming(targetState: TickerConnectionState.stalled);

      print('Waiting ${_currentReconnectDelay.inMilliseconds}ms before reconnecting');
      await Future.delayed(_currentReconnectDelay);

      _currentReconnectDelay = Duration(
        milliseconds: (_currentReconnectDelay.inMilliseconds * 2).clamp(
          initialReconnectDelay.inMilliseconds,
          _maxReconnectDelay.inMilliseconds,
        ),
      );
    } finally {
      _isReconnecting = false;
    }

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

  void _resetReconnectDelay() {
    _currentReconnectDelay = initialReconnectDelay;
  }

  // endregion
}
