import 'package:collection/collection.dart';
import 'package:finonex_task/models/instrument/_instrument.dart';

class InstrumentModelImpl extends InstrumentModel {
  InstrumentModelImpl({
    required this._service,
  });

  final InstrumentService _service;

  @override
  Future<List<InstrumentData>?> getInstruments() {
    return _service.getInstruments();
  }

  @override
  Future<InstrumentData?> getInstrument(String symbol) async {
    final all = await getInstruments();
    return all?.firstWhereOrNull((element) => element.symbol == symbol);
  }
}
