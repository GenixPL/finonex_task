// TODO(genix): there might be inconsistencies between stalled and disconnected
enum TickerConnectionState {
  connecting,
  live,
  reconnecting,
  stalled,
  disconnected,
}
