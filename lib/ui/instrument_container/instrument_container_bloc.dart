import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finonex_task/models/instrument/_instrument.dart';

part 'instrument_container_event.dart';
part 'instrument_container_state.dart';

class InstrumentContainerBloc extends Bloc<InstrumentContainerEvent, InstrumentContainerState> {
  InstrumentContainerBloc({
    required this._instrumentModel,
  }) : super(Loading()) {
    on<Init>(_init);
  }

  final InstrumentModel _instrumentModel;

  Future<void> _init(
    Init event,
    Emitter<InstrumentContainerState> emit,
  ) async {
    final List<InstrumentData>? instruments = await _instrumentModel.getInstruments();
    if (instruments == null) {
      emit(FailedToLoad());
    } else {
      emit(Loaded(instruments));
    }
  }
}
