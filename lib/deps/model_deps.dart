import 'package:finonex_task/models/_models.dart';

class ModelDeps {
  const ModelDeps({
    required this.authModel,
    required this.instrumentModel,
    required this.tickerModel,
    required this.connectivityModel,
  });

  final AuthModel authModel;
  final InstrumentModel instrumentModel;
  final TickerModel tickerModel;
  final ConnectivityModel connectivityModel;
}
