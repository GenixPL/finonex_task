part of 'instrument_widget_bloc.dart';

sealed class InstrumentWidgetState with Equatable {}

class NoData extends InstrumentWidgetState {
  @override
  List<Object?> get props => [];
}

class FailedToGetInstrumentData extends InstrumentWidgetState {
  @override
  List<Object?> get props => [];
}

// TODO(genix): add ==
class DataLoaded extends InstrumentWidgetState {
  DataLoaded({
    required this.symbol,
    required this.bid,
    required this.ask,
    required this.decimals,
  });

  final String symbol;
  final double bid;
  final double ask;
  final int decimals;

  @override
  List<Object?> get props => [
    symbol,
    bid,
    ask,
    decimals,
  ];
}
