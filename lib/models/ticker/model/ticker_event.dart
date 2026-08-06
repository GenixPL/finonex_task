import 'package:finonex_task/models/ticker/model/ticker_data.dart';

sealed class TickerEvent {
  const TickerEvent();
}

class TickerTickEvent extends TickerEvent {
  final TickerData data;
  const TickerTickEvent(this.data);

  @override
  String toString() => 'TickerTickEvent(data: $data)';
}

class TickerGapEvent extends TickerEvent {
  final int resumeFrom;
  const TickerGapEvent(this.resumeFrom);

  @override
  String toString() => 'TickerGapEvent(resumeFrom: $resumeFrom)';
}

class TickerPingEvent extends TickerEvent {
  const TickerPingEvent();

  @override
  String toString() => 'TickerPingEvent()';
}

class TickerUnknownEvent extends TickerEvent {
  final String? event;
  final String? data;
  const TickerUnknownEvent({this.event, this.data});

  @override
  String toString() => 'TickerUnknownEvent(event: $event, data: $data)';
}
