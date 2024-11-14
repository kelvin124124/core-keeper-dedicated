#### Status

Running with the following error and warnings:

```
core-keeper  | Using emulated /home/steam/core-keeper-dedicated/CoreKeeperServer_Data/Plugins/libPlayFabMultiplayer.so
core-keeper  | Using emulated /usr/lib/box64-x86_64-linux-gnu/libstdc++.so.6
core-keeper  | Warning: Weak Symbol _ITM_memcpyRtWn not found, cannot apply R_X86_64_JUMP_SLOT @0x7fff0924f060 (0x9c0f6)
core-keeper  | Warning: Weak Symbol _ITM_RU1 not found, cannot apply R_X86_64_JUMP_SLOT @0x7fff0924f6a0 (0x9cd76)
core-keeper  | Warning: Weak Symbol _ZGTtdlPv not found, cannot apply R_X86_64_JUMP_SLOT @0x7fff0924fb00 (0x9d636)
core-keeper  | Warning: Weak Symbol _ITM_RU8 not found, cannot apply R_X86_64_JUMP_SLOT @0x7fff0924fff8 (0x9e026)
core-keeper  | Warning: Weak Symbol _ITM_memcpyRnWt not found, cannot apply R_X86_64_JUMP_SLOT @0x7fff092504a8 (0x9e986)
core-keeper  | Warning: Weak Symbol _ZGTtnam not found, cannot apply R_X86_64_JUMP_SLOT @0x7fff09250c88 (0x9f946)
...
core-keeper  | pthread_attr_getstack gives (0) 0xffed4ae00000 0x200000
core-keeper  | PlatformConfiguration: loading platform configuration for variant Linux.
core-keeper  | PlatformConfiguration: platform configuration for variant Linux was not found.
core-keeper  | PlatformConfiguration: loading platform configuration for variant PC.
core-keeper  | Error loading needed lib libmonosgen-2.0.so
core-keeper  | Warning: Cannot dlopen("libmonosgen-2.0.so"/0x3db30270, 102)
core-keeper  | Using emulated /home/steam/core-keeper-dedicated/CoreKeeperServer_Data/MonoBleedingEdge/x86_64/libMonoPosixHelper.so
core-keeper  | Error loading needed lib data-0x3df7c290.so
core-keeper  | Warning: Cannot dlopen("data-0x3df7c290.so"/0x3dff7990, 101)
core-keeper  | Fallback handler could not load library /home/steam/core-keeper-dedicated/CoreKeeperServer_Data/MonoBleedingEdge/x86_64/data-0x3df7c290.so
core-keeper  | Error loading needed lib data-0x3e1218c0.so
core-keeper  | Warning: Cannot dlopen("data-0x3e1218c0.so"/0x3e09d320, 101)
core-keeper  | Fallback handler could not load library /home/steam/core-keeper-dedicated/CoreKeeperServer_Data/MonoBleedingEdge/x86_64/data-0x3e1218c0.so
core-keeper  | Initializing Steamworks with AppID 1621690
core-keeper  | Error loading needed lib steamclient.so
core-keeper  | Warning: Cannot dlopen("steamclient.so"/0x7fff1503fe85, 2)
core-keeper  | dlopen failed trying to load:
core-keeper  | steamclient.so
core-keeper  | with error:
core-keeper  | Cannot dlopen("steamclient.so"/0x7fff1503fe85, 2)
core-keeper  | 
core-keeper  | Using emulated /home/steam/.steam/sdk64/steamclient.so
core-keeper  | Warning: Weak Symbol _ITM_RU1 not found, cannot apply R_X86_64_JUMP_SLOT @0x7fff1a2dd158 (0xb4fa90)
core-keeper  | Warning: Weak Symbol _ZGTtnam not found, cannot apply R_X86_64_JUMP_SLOT @0x7fff1a2dd160 (0xb4fa90)
core-keeper  | Warning: Weak Symbol _ITM_memcpyRtWn not found, cannot apply R_X86_64_JUMP_SLOT @0x7fff1a2dd168 (0xb4fa90)
core-keeper  | Warning: Weak Symbol _ITM_RU8 not found, cannot apply R_X86_64_JUMP_SLOT @0x7fff1a2dd170 (0xb4fa90)
core-keeper  | [S_API] SteamAPI_Init(): Loaded '/home/steam/.steam/sdk64/steamclient.so' OK.  (First tried local 'steamclient.so')
core-keeper  | CAppInfoCacheReadFromDiskThread took 2 milliseconds to initialize
core-keeper  | Setting breakpad minidump AppID = 1621690
core-keeper  | Error loading needed lib libsteam.so
core-keeper  | Warning: Cannot dlopen("libsteam.so"/0x7fff1503fe79, 2)
core-keeper  | [S_API FAIL] Tried to access Steam interface SteamNetworkingUtils004 before SteamAPI_Init succeeded.
core-keeper  | Steam API initialized
...
core-keeper  | Initialize global manager
core-keeper  | Global manager Resources.Load
core-keeper  | Error loading needed lib libSDL3.so.0
core-keeper  | Warning: Cannot dlopen("libSDL3.so.0"/0x7fff18aea16a, 2)
...
core-keeper  | Error loading needed lib libsteamwebrtc.so
core-keeper  | Warning: Cannot dlopen("libsteamwebrtc.so"/0x7fff18984390, 1)
core-keeper  | Accepted connection from 76561198355238595 with result OK awaiting authentication
core-keeper  | SteamNet Warning: [#3892763356 P2P steamid:76561198355238595 vport 0] Relay candidates enabled by P2P_Transport_ICE_Enable, but P2P_TURN_ServerList is empty
```