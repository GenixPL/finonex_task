import 'package:finonex_task/services/_services.dart';
import 'package:rxdart/rxdart.dart';

abstract class ConnectivityService {
  // TODO(genix): we could consider providing our own ValueStream interface to no make the code dependent on rxdart
  ValueStream<ConnectivityState> get stateStream;
}
