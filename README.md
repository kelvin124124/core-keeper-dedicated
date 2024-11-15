#### Status

- [x] Build
- [x] Run
- [x] Game
- [ ] Optimize

Some lag but is playable.

LLM analysis on log file:

The log reveals a recurring error related to a missing symbol `_ZSt28__throw_bad_array_new_lengthv` within the `libsentry.so` plugin, preventing its preloading. This suggests an incompatibility between the plugin and the current environment, likely due to a missing or mismatched library dependency. As a result, Sentry functionality will be unavailable.

\* Remarks: Sentry is for error tracking and monitoring, so it is not critical for the server's core functionality.

Despite this plugin issue, the Core Keeper server successfully initializes using the Unity engine (version 2022.3.20f1).  Steamworks integration is also successful, after initially attempting to use a local `steamclient.so` file before correctly loading the system's Steam client library.  The server then proceeds to load world data, including faction configurations, loot tables, fishing data, and spawn configurations from various JSON files.  The world file itself is decompressed and deserialized, and the server notes a seed mismatch, opting to use the seed from the world data.

Network connectivity establishes through Steam's relay network, with successful ping measurements and connections to various routing clusters. A player connects to the server and is successfully authenticated. A significant amount of data exchange occurs between the server and the client, as indicated by the numerous "Send Nagle" messages in the log.

After some gameplay, the player disconnects with the reason "App_Min". The server acknowledges the disconnection, resets the timescale, and cleans up the associated network sessions.  The log concludes with messages about discarding inactive sessions and clearing out records of port failures, which is part of the normal network cleanup process after a player disconnects.  The overall impression is that, aside from the Sentry plugin issue, the server functioned as expected.