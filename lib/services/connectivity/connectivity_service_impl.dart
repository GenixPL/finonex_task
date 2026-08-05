import 'dart:async';

import 'package:finonex_task/services/_services.dart';
import 'package:rxdart/rxdart.dart';

// TODO(genix): we could make it check if we actually can reach the internet instead of just having wifi/cellular on
class ConnectivityServiceImpl extends ConnectivityService {
  ConnectivityServiceImpl() {
    _init();
  }

  final BehaviorSubject<ConnectivityState> _stream = BehaviorSubject.seeded(ConnectivityState.unknown);

  @override
  ValueStream<ConnectivityState> get stateStream {
    return _stream.stream;
  }

  void dispose() {
    unawaited(_stream.close());
  }

  void _init() {
    
  }
}
