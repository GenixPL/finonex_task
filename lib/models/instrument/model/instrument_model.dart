import 'package:finonex_task/models/instrument/model/instrument_data.dart';

abstract class InstrumentModel {
  // TODO(genix): this model could use storage

  Future<List<InstrumentData>?> getInstruments();
}
