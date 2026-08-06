### TODO:

#### Watchlist screen
- [x] All instruments with live bid/ask, formatted to each instrument's decimals.
- [x] Visual flash (e.g. green/red) when a price moves up/down.
- [x] A visible connection status: at minimum distinguish connecting, live, reconnecting, and stalled/degraded. The user must never look at frozen prices believing they're live.
  - [x] UI
  - [x] Model side 
- [x] The list must stay smooth during bursts. We will open Flutter DevTools during grading and look at frame times and widget rebuild counts while the feed bursts. A full-list rebuild on every tick will not pass.

#### Resilience semantics
- [x] Automatic reconnect with sensible backoff. Don't hammer the server; don't wait forever.
- [x] Detect silent stalls and recover from them.
- [] A stale tick must never overwrite a newer price on screen.
- [x] Duplicates must not cause visible artifacts (e.g. double flashes).
- [x] Handle malformed events without killing the stream.
- [x] Handle token expiry without user intervention after the initial login.

#### Native piece
- [x] MethodChannel: store/read/delete the auth token in the platform's secure storage (Keychain on iOS, Keystore/EncryptedSharedPreferences on Android).
- [x] EventChannel: native network reachability events (NWPathMonitor / ConnectivityManager), and use them in your reconnect logic - don't spin reconnect attempts while the device is known-offline.

#### Tests
- [] Add

#### Architecture
- [x] Should be implemented using bloc and flutter_bloc library using BLoCs (not Cubits).
- [x] Feed/connection logic must be independent of Flutter widgets and unit-testable.
- [x] Use some form of dependency injection (we use get_it/injectable; anything reasonable is fine).
