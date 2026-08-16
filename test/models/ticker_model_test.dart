import 'dart:async';

import 'package:finonex_task/models/auth/_auth.dart';
import 'package:finonex_task/models/ticker/_ticker.dart';
import 'package:finonex_task/services/connectivity/_connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

class MockAuthModel implements AuthModel {
  final _stateController = BehaviorSubject<AuthState>.seeded(AuthState.noUser);

  @override
  ValueStream<AuthState> get stateStream => _stateController.stream;

  @override
  Future<String?> getToken() async => 'mock_token';

  @override
  Future<String?> login() async {
    _stateController.add(AuthState.user);
    return null;
  }

  @override
  Future<void> logout() async {
    _stateController.add(AuthState.noUser);
  }

  void setState(AuthState state) => _stateController.add(state);
}

class MockConnectivityService implements ConnectivityService {
  final _stateController = BehaviorSubject<ConnectivityState>.seeded(ConnectivityState.connected);

  @override
  ValueStream<ConnectivityState> get stateStream => _stateController.stream;

  void setState(ConnectivityState state) => _stateController.add(state);
}

class MockTickerService implements TickerService {
  final _controller = StreamController<TickerEvent>.broadcast();
  int callCount = 0;
  String? lastId;
  Exception? getStreamException;

  @override
  Future<Stream<TickerEvent>> getTickerDataStream({String? lastEventId}) async {
    callCount++;
    lastId = lastEventId;

    if (getStreamException != null) {
      throw getStreamException!;
    }

    return _controller.stream;
  }

  void addEvent(TickerEvent event) => _controller.add(event);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late TickerModelImpl tickerModel;
  late MockAuthModel authModel;
  late MockConnectivityService connectivityService;
  late MockTickerService tickerService;

  const stalledDuration = Duration(milliseconds: 50);
  const bufferDuration = Duration(milliseconds: 10);
  const reconnectDelay = Duration(milliseconds: 50); // Increased to catch stalled state

  setUp(() async {
    authModel = MockAuthModel();
    connectivityService = MockConnectivityService();
    tickerService = MockTickerService();

    tickerModel = TickerModelImpl(
      authModel: authModel,
      connectivityService: connectivityService,
      tickerService: tickerService,
      stalledDuration: stalledDuration,
      bufferDuration: bufferDuration,
      initialReconnectDelay: reconnectDelay,
    );

    // Let the initial _init settle
    await Future.delayed(const Duration(milliseconds: 10));
  });

  Future<void> pump() => Future.delayed(const Duration(milliseconds: 10));

  test('model connects and becomes live when user is logged in and connected', () async {
    await authModel.login();
    await pump();

    expect(tickerService.callCount, 1);
    expect(tickerModel.connectionStream.value, TickerConnectionState.connecting);

    final data = TickerData(symbol: 'BTC', bid: 50000, ask: 50010, timestamp: 1000);
    tickerService.addEvent(TickerTickEvent(data));

    await pump();

    expect(tickerModel.connectionStream.value, TickerConnectionState.live);
  });

  test('model disconnects when user logs out', () async {
    await authModel.login();
    await pump();
    expect(tickerService.callCount, 1);

    await authModel.logout();
    await pump();
    expect(tickerModel.connectionStream.value, TickerConnectionState.disconnected);
  });

  test('model disconnects when connection drops', () async {
    await authModel.login();
    await pump();
    expect(tickerService.callCount, 1);

    connectivityService.setState(ConnectivityState.notConnected);
    await pump();
    expect(tickerModel.connectionStream.value, TickerConnectionState.disconnected);
  });

  test('model reconnects upon stale', () async {
    await authModel.login();
    await pump();

    tickerService.addEvent(const TickerPingEvent());
    await pump();
    expect(tickerModel.connectionStream.value, TickerConnectionState.live);

    // Wait for stalled timer to trigger
    await Future.delayed(stalledDuration + const Duration(milliseconds: 10));

    // It should be stalled now (waiting for reconnectDelay)
    expect(tickerModel.connectionStream.value, TickerConnectionState.stalled);

    // After reconnect delay, it should try to reconnect
    await Future.delayed(reconnectDelay + const Duration(milliseconds: 20));
    expect(tickerService.callCount, 2);
    expect(tickerModel.connectionStream.value, TickerConnectionState.connecting);
  });

  test('model reconnects upon stale but only until connection is possible', () async {
    await authModel.login();
    await pump();

    tickerService.addEvent(const TickerPingEvent());
    await pump();
    expect(tickerModel.connectionStream.value, TickerConnectionState.live);

    // Wait for stalled timer to trigger
    await Future.delayed(stalledDuration + const Duration(milliseconds: 10));

    // It should be stalled now (waiting for reconnectDelay)
    expect(tickerModel.connectionStream.value, TickerConnectionState.stalled);

    // Simulate failing connection (but yet without actual update from the system).
    tickerService.getStreamException = Exception('simulating failed request due to lacking connection');

    // After reconnect delay, it should try to reconnect.
    await Future.delayed(reconnectDelay + const Duration(milliseconds: 20));
    expect(tickerService.callCount, 2);
    expect(tickerModel.connectionStream.value, TickerConnectionState.stalled);

    // System-inform about missing connection.
    connectivityService.setState(ConnectivityState.notConnected);

    // After reconnect delay, it should NOT try to reconnect due to guaranteed missing connection.
    await Future.delayed((reconnectDelay * 2) + const Duration(milliseconds: 20));
    expect(tickerService.callCount, 2);
    expect(tickerModel.connectionStream.value, TickerConnectionState.disconnected);
  });

  test('model reconnects upon stale but only until user is logged in', () async {
    await authModel.login();
    await pump();

    tickerService.addEvent(const TickerPingEvent());
    await pump();
    expect(tickerModel.connectionStream.value, TickerConnectionState.live);

    // Wait for stalled timer to trigger
    await Future.delayed(stalledDuration + const Duration(milliseconds: 10));

    // It should be stalled now (waiting for reconnectDelay)
    expect(tickerModel.connectionStream.value, TickerConnectionState.stalled);

    // Simulate failing connection (but yet without actual update from the system).
    tickerService.getStreamException = Exception('simulating failed request due to lacking connection');

    // After reconnect delay, it should try to reconnect.
    await Future.delayed(reconnectDelay + const Duration(milliseconds: 20));
    expect(tickerService.callCount, 2);
    expect(tickerModel.connectionStream.value, TickerConnectionState.stalled);

    await authModel.logout();

    // After reconnect delay, it should NOT try to reconnect due to guaranteed missing connection.
    await Future.delayed((reconnectDelay * 2) + const Duration(milliseconds: 20));
    expect(tickerService.callCount, 2);
    expect(tickerModel.connectionStream.value, TickerConnectionState.disconnected);
  });

  test('model doesnt override new data with old', () async {
    await authModel.login();
    await pump();

    final btcStream = tickerModel.getTickerStream('BTC') as ValueStream<TickerData>;

    // Emit new data
    tickerService.addEvent(TickerTickEvent(TickerData(symbol: 'BTC', bid: 50000, ask: 50010, timestamp: 1000)));

    // Wait for buffer flush
    await Future.delayed(bufferDuration * 3);

    expect(btcStream.value.timestamp, 1000);

    // Emit old data
    tickerService.addEvent(TickerTickEvent(TickerData(symbol: 'BTC', bid: 49000, ask: 49010, timestamp: 900)));
    await Future.delayed(bufferDuration * 3);

    expect(btcStream.value.timestamp, 1000);

    // Emit even newer data
    tickerService.addEvent(TickerTickEvent(TickerData(symbol: 'BTC', bid: 51000, ask: 51010, timestamp: 1100)));
    await Future.delayed(bufferDuration * 3);

    expect(btcStream.value.timestamp, 1100);
  });

  test('model updates its connection state stream', () async {
    final states = <TickerConnectionState>[];
    final subscription = tickerModel.connectionStream.listen(states.add);

    await authModel.login();
    await pump();
    tickerService.addEvent(const TickerPingEvent());
    await pump();

    await authModel.logout();
    await pump();

    expect(
      states,
      containsAllInOrder([
        TickerConnectionState.connecting,
        TickerConnectionState.live,
        TickerConnectionState.disconnected,
      ]),
    );

    await subscription.cancel();
  });
}
