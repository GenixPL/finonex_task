import 'package:finonex_task/services/connectivity/_connectivity.dart';
import 'package:rxdart/rxdart.dart';

abstract class ConnectivityService {
  // TODO(genix): we could consider providing our own ValueStream interface to no make the code dependent on rxdart
  ValueStream<ConnectivityState> get stateStream;
}
