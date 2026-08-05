# Take-home: "Pulse" - a live market watchlist

You'll build a small Flutter app that displays live prices from a market data feed we provide. The feed intentionally exhibits common failure modes of real market data feeds; the app must remain correct and responsive despite them.

**Timebox: 5–7 hours.** Do not exceed it. If you're running out of time, cut scope deliberately and write down what you cut and why - scope-cutting judgment is part of what we evaluate. An incomplete-but-solid submission beats a complete-but-sloppy one.

AI tools (Claude Code, Copilot, etc.) are allowed. We evaluate the result and your understanding of it: there will be a 45–60 min follow-up call where you walk us through your code, answer questions about your decisions, and make a small change live.

---

## What we provide

- `feed_server.dart` - a self-contained feed server. Run it with:

  ```
  dart run feed_server.dart            # default: port 8080, misbehavior ON
  dart run feed_server.dart --calm     # misbehavior OFF (for early development)
  dart run feed_server.dart --port N --seed N
  ```

  Build against the **default (chaotic) mode**. `--calm` is only a convenience for getting started. 

- Credentials: `trader` / `password123`

### Server API

**`POST /login`** - body `{"username": "...", "password": "..."}` → `{"token": "...", "expiresIn": 60}`. Tokens expire after ~60 seconds. All other endpoints require `Authorization: Bearer <token>` and return `401` otherwise.

**`GET /instruments`** → JSON array of `{"symbol", "name", "decimals"}` (~40 instruments).

**`GET /stream`** - Server-Sent Events stream of price ticks:

```
id: 1042
event: tick
data: {"s":"EURUSD","b":1.08123,"a":1.08141,"ts":1752912000123}
```

- `id` is a global monotonically increasing sequence number.
- `ts` is the tick's epoch-milliseconds timestamp.
- Comment heartbeats (`: ping`) are sent every ~5s while the connection is healthy.
- If you reconnect with a `Last-Event-ID` header and the id is still in the server's buffer, missed events are replayed. If it's too old, the server sends one `event: gap` and continues live.

### Feed misbehavior

The list below is complete; the server has no undocumented behaviors:

1. **Disconnects.** The server closes your stream at random intervals.
2. **Silent stalls.** Sometimes the connection stays open but nothing arrives - no ticks, no heartbeats - for ~25s, then resumes. A stalled connection shows stale prices while looking "connected".
3. **Bursts.** Occasionally ~200+ ticks arrive within ~100ms.
4. **Duplicates.** Previously sent events are occasionally re-sent with the same `id`.
5. **Out-of-order ticks.** An event may carry a `ts` older than a tick you already received for that symbol.
6. **Malformed lines.** Occasionally the `data` payload is garbage that won't parse.
7. **Token expiry.** When your token expires mid-stream, the server drops you; reconnecting with the expired token gets `401`.

## Requirements

### 1. Watchlist screen
- All instruments with live bid/ask, formatted to each instrument's `decimals`.
- Visual flash (e.g. green/red) when a price moves up/down.
- A visible connection status: at minimum distinguish *connecting*, *live*, *reconnecting*, and *stalled/degraded*. The user must never look at frozen prices believing they're live.
- **The list must stay smooth during bursts.** We will open Flutter DevTools during grading and look at frame times and widget rebuild counts while the feed bursts. A full-list rebuild on every tick will not pass.

### 2. Resilience semantics
- Automatic reconnect with sensible backoff. Don't hammer the server; don't wait forever.
- Detect silent stalls and recover from them.
- A stale tick must never overwrite a newer price on screen.
- Duplicates must not cause visible artifacts (e.g. double flashes).
- Handle malformed events without killing the stream.
- Handle token expiry without user intervention after the initial login.

### 3. Native piece - one small plugin of your own
Write your own platform channel code (a local plugin or in-app channel - your call) for **one platform of your choice** (Android or iOS), providing:

- **MethodChannel**: store/read/delete the auth token in the platform's secure storage (Keychain on iOS, Keystore/EncryptedSharedPreferences on Android).
- **EventChannel**: native network reachability events (NWPathMonitor / ConnectivityManager), and use them in your reconnect logic - don't spin reconnect attempts while the device is known-offline.

You may not use `flutter_secure_storage`, `connectivity_plus`, or equivalents for these two pieces. Any other packages are fine. Design the Dart-side API as if the second platform would be added later.

### 4. Tests
Write the tests **you** think this codebase most needs - we care more about what you chose to test than about coverage numbers. Hints at what's most at risk: reconnect/backoff behavior, stall detection, ordering/dedup logic. Connection-lifecycle logic should be testable without a real server or real time.

### 5. Architecture
- Should be implemented using bloc and flutter_bloc library using BLoCs (not Cubits).
- Feed/connection logic must be independent of Flutter widgets and unit-testable.
- Use some form of dependency injection (we use get_it/injectable; anything reasonable is fine).

### Stretch (only if genuinely under time - do not sacrifice the above)
- Instrument detail screen with session high/low and a small sparkline of recent ticks.

## Deliverables

- A Git repository **with your real commit history** (don't squash to one commit).
- `NOTES.md`:
  - key decisions and tradeoffs (e.g. how you conflate bursts and why that rate; what "no data loss" can and cannot mean given the server's buffer);
  - what you cut for time and what you'd do next;
  - known gaps/bugs you're aware of;
  - roughly how you used AI tools.
- Run instructions (Flutter version, which platform your native piece targets).

## What happens next

A 45–60 min call: short walkthrough by you, then questions about your decisions, then one small live modification to your code. You can use AI tools on the call too - we want to see how you drive them.
