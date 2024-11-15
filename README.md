#### Status

- [x] Build
- [x] Run
- [x] Game
- [ ] Optimize

Running with the following errors and warnings:

```
core-keeper  | Error: Symbol _ZSt28__throw_bad_array_new_lengthv not found, cannot apply R_X86_64_JUMP_SLOT @0x7fff14054200 (0x6400) in /home/steam/core-keeper-dedicated/CoreKeeperServer_Data/Plugins/libsentry.so
core-keeper  | Error: relocating Plt symbols in elf libsentry.so
core-keeper  | Preloaded 'libsteam_api.so'
core-keeper  | Error: Symbol _ZSt28__throw_bad_array_new_lengthv not found, cannot apply R_X86_64_JUMP_SLOT @0x7fff16054200 (0x6400) in /home/steam/core-keeper-dedicated/CoreKeeperServer_Data/Plugins/libsentry.so
core-keeper  | Error: relocating Plt symbols in elf libsentry.so
core-keeper  | Unable to preload the following plugins:
core-keeper  |  libsentry.so
...
core-keeper  | Error: Symbol _ZSt28__throw_bad_array_new_lengthv not found, cannot apply R_X86_64_JUMP_SLOT @0x7fff18054200 (0x6400) in /home/steam/core-keeper-dedicated/CoreKeeperServer_Data/Plugins/libsentry.so
core-keeper  | Error: relocating Plt symbols in elf libsentry.so
core-keeper  | Fallback handler could not load library /home/steam/core-keeper-dedicated/CoreKeeperServer_Data/MonoBleedingEdge/x86_64/sentry
core-keeper  | PlatformConfiguration: loading platform configuration for variant Linux.
core-keeper  | PlatformConfiguration: platform configuration for variant Linux was not found.
core-keeper  | PlatformConfiguration: loading platform configuration for variant PC.
core-keeper  | Fallback handler could not load library /home/steam/core-keeper-dedicated/CoreKeeperServer_Data/MonoBleedingEdge/x86_64/data-0x44d461f0.so
core-keeper  | Fallback handler could not load library /home/steam/core-keeper-dedicated/CoreKeeperServer_Data/MonoBleedingEdge/x86_64/data-0x44edc600.so
core-keeper  | Initializing Steamworks with AppID 1621690
core-keeper  | dlopen failed trying to load:
core-keeper  | steamclient.so
core-keeper  | with error:
core-keeper  | Cannot dlopen("steamclient.so"/0x7fff1503fe85, 2)
core-keeper  | 
core-keeper  | [S_API] SteamAPI_Init(): Loaded '/home/steam/.steam/sdk64/steamclient.so' OK.  (First tried local 'steamclient.so')
core-keeper  | CAppInfoCacheReadFromDiskThread took 1 milliseconds to initialize
core-keeper  | Setting breakpad minidump AppID = 1621690
core-keeper  | [S_API FAIL] Tried to access Steam interface SteamNetworkingUtils004 before SteamAPI_Init succeeded.
core-keeper  | Steam API initialized
```

Some lag but is playable.