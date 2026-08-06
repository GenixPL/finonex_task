part of 'instrument_container_bloc.dart';

sealed class InstrumentContainerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loading extends InstrumentContainerState {}

class Loaded extends InstrumentContainerState {
  Loaded(this.instruments);

  final List<InstrumentData> instruments;

  @override
  List<Object?> get props => [instruments];
}

class FailedToLoad extends InstrumentContainerState {}
