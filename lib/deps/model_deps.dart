import 'package:finonex_task/models/_models.dart';

class ModelDeps {
  final AuthModel authModel;
  final InstrumentModel instrumentModel;
  final TickerModel tickerModel;

  const ModelDeps({
    required this.authModel,
    required this.instrumentModel,
    required this.tickerModel,
  });
}
