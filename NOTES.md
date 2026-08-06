# Known issues

- no failure indication upon failed login
- auth doesnt restore previous session
- InstrumentModel is just a mock
- android's secure storage is swamped with deprecated warnings, "fix the deprecation warning in android's secure storage" burned through all my tokens, and i didn't have time to actually read documentation and debug (i assume such a thing would take a few days normally)

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
