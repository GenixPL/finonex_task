import 'package:finonex_task/models/instrument/_instrument.dart';

abstract class InstrumentService {
  Future<List<InstrumentData>?> getInstruments();
}
