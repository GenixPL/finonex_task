import 'package:finonex_task/models/auth/_auth.dart';
import 'package:finonex_task/models/instrument/_instrument.dart';
import 'package:finonex_task/models/ticker/_ticker.dart';

class ModelDeps {
  const ModelDeps({
    required this.authModel,
    required this.instrumentModel,
    required this.tickerModel,
  });

  final AuthModel authModel;
  final InstrumentModel instrumentModel;
  final TickerModel tickerModel;
}
