import 'package:finonex_task/services/_services.dart';
import 'package:rxdart/rxdart.dart';

class ConnectivityModel {
  ConnectivityModel({
    required this._service,
  });

  final ConnectivityService _service;

  ValueStream<ConnectivityState> get stateStream {
    return _service.stateStream;
  }
}
