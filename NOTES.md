# Known issues

- no failure indication upon failed login
- auth doesnt restore previous session
- InstrumentModel is just a mock
- android's secure storage is swamped with deprecated warnings, "fix the deprecation warning in android's secure storage" burned through all my tokens, and i didn't have time to actually read documentation and debug (i assume such a thing would take a few days normally)
- there's slight jank every now and then, no more time to play to play with isolates and other things though
- the app seems to sometimes enter "disconnected" mode despite user being logged in (only app restart helps) (no more time to debug, fix and test, probably "recent" test generation, and associated model changes, have caused it) 
```
I/flutter ( 5089): Waiting 500ms before reconnecting
I/flutter ( 5089): start streaming
I/flutter ( 5089): ping, resetting stalled timer
I/flutter ( 5089): ping, resetting stalled timer
I/flutter ( 5089): marking stalled
I/flutter ( 5089): stop streaming
I/flutter ( 5089): Waiting 500ms before reconnecting
I/flutter ( 5089): start streaming
I/flutter ( 5089): ping, resetting stalled timer
I/flutter ( 5089): ping, resetting stalled timer
I/flutter ( 5089): stop streaming

I/flutter ( 6071): AuthModelImpl, log in
I/flutter ( 6071): AuthModelImpl, log out
I/flutter ( 6071): stop streaming
I/flutter ( 6071): stop streaming
I/flutter ( 6071): AuthModelImpl, log in
I/flutter ( 6071): AuthModelImpl, log out
I/flutter ( 6071): stop streaming
I/flutter ( 6071): stop streaming
```

# Would improve

- logic layers, especially models, would return sealed result classes that would better differentiate between success results and failures included in their requirements (they wouldn't throw in expected cases)
- i assume mentioning things like monitoring, other platforms, etc, is obsolete
- i would prepare test version/flavor of ModelDeps, so that the whole business logic layer can be integration tested without UI
- and another version/flavor(s) for test env, local dev, production, and whatever 
- i would prepare test wrapper with controllable async zone
- add more tests
- add documentation to the interfaces, especially if they can do stuff that isn't "visible", like throw
- i would refactor out the native code to separate plugins
- some more cleaning of the generated code, and generally some cleaning and standardization
- better UI
- potentially abstract ValueStream, but rxdart isn't really something that changes a lot
- the ConnectivityService, on the dart side, could add some logic checking whether we actually have access to the internet
- do some more profiling
- test on older, and weaker, devices
- better commit messages (probably during pr and squashing)

# Decision

- throttled TickerModel to emitting every 500ms, it seems enough give that it's a mobile app for manual interactions and not a high-frequency rust system, but could reconsider

# AI usage

- generated whole native-side code (outside a few cleanups, especially class splits)
- generated most test code (ran out of time for more manual setup)
- initially built UI with StreamBuilders, refactored one manually, and used AI for the rest (based on the one) (with adjustments)
- generated some service code
- gave the TickerModel some desired structured - empty methods, the maps, etc, and asked sequentially to provide implementations (with some cleanup along the way)
- asked some questions regarding the server and generally
