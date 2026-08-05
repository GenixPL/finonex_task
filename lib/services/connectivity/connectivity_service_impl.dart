import 'dart:async';

import 'package:finonex_task/services/_services.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

// TODO(genix): we could make it check if we actually can reach the internet instead of just having wifi/cellular on
class ConnectivityServiceImpl extends ConnectivityService {
  ConnectivityServiceImpl() {
    _init();
  }

  static const _eventChannel = EventChannel('com.example.finonex_task/connectivity');
  final BehaviorSubject<ConnectivityState> _stream = BehaviorSubject.seeded(ConnectivityState.unknown);
  StreamSubscription? _subscription;

  @override
  ValueStream<ConnectivityState> get stateStream {
    return _stream.stream;
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _stream.close();
  }

  void _init() {
    _subscription = _eventChannel.receiveBroadcastStream().listen(
      (event) {
        if (event == 'connected') {
          _stream.add(ConnectivityState.connected);
        } else if (event == 'notConnected') {
          _stream.add(ConnectivityState.notConnected);
        }
      },
      onError: (error) {
        // Handle error
      },
    );
  }
}
