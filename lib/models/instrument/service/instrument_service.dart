import 'package:finonex_task/models/_models.dart';

abstract class InstrumentService {
  Future<List<InstrumentData>?> getInstruments();
}
