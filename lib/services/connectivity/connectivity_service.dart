import 'package:finonex_task/services/_services.dart';

abstract class ConnectivityService {
  Stream<ConnectivityState> get stateStream;
}
