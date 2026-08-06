import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:finonex_task/models/ticker/_ticker.dart';

part 'connectivity_indicator_event.dart';

class ConnectivityIndicatorBloc extends Bloc<ConnectivityIndicatorEvent, TickerConnectionState> {
  ConnectivityIndicatorBloc({
    required this._tickerModel,
  }) : super(_tickerModel.connectionStream.value) {
    on<SubRequested>(_sub);
  }

  final TickerModel _tickerModel;

  Future<void> _sub(
    SubRequested event,
    Emitter<TickerConnectionState> emit,
  ) async {
    return emit.onEach(
      _tickerModel.connectionStream,
      onData: (state) => emit(state),
    );
  }
}
