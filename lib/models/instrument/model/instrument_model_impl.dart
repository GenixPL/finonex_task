import 'package:finonex_task/models/_models.dart';

class InstrumentModelImpl extends InstrumentModel {
  InstrumentModelImpl({
    required this._service,
  });

  final InstrumentService _service;

  @override
  Future<List<InstrumentData>?> getInstruments() {
    return _service.getInstruments();
  }
}
