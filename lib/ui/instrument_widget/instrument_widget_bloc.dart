import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:finonex_task/models/instrument/_instrument.dart';
import 'package:finonex_task/models/ticker/model/_model.dart';
import 'package:equatable/equatable.dart';

part 'instrument_widget_event.dart';
part 'instrument_widget_state.dart';

class InstrumentWidgetBloc extends Bloc<InstrumentWidgetEvent, InstrumentWidgetState> {
  InstrumentWidgetBloc({
    required this._tickerModel,
    required this._instrumentModel,
    required this._symbol,
  }) : super(NoData()) {
    on<SubRequested>(_sub);
  }

  final TickerModel _tickerModel;
  final InstrumentModel _instrumentModel;
  final String _symbol;

  Future<void> _sub(
    SubRequested event,
    Emitter<InstrumentWidgetState> emit,
  ) async {
    final InstrumentData? instrumentData = await _instrumentModel.getInstrument(_symbol);
    if (instrumentData == null) {
      emit(FailedToGetInstrumentData());
      return;
    }

    return emit.onEach(
      _tickerModel.getTickerStream(_symbol),
      onData: (TickerData tickerData) => emit(
        DataLoaded(
          symbol: tickerData.symbol,
          bid: tickerData.bid,
          ask: tickerData.ask,
          decimals: instrumentData.decimals,
        ),
      ),
    );
  }
}
