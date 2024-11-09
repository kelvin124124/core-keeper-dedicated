#### Status
- [x] Build
- [ ] Run
- [ ] Game
- [ ] Optimize

Stuck with the following error:
```
core-keeper  | Loading Steam API...Error: Symbol execvpe not found, cannot apply R_386_JMP_SLOT 0x66cfb324 (0x1308f6) in /home/steam/steamcmd/linux32/steamclient.so
core-keeper  | Error: relocating Plt symbols in elf steamclient.so
core-keeper  | dlmopen steamclient.so failed: Cannot dlopen("steamclient.so"/0x641dd8e0, 2)
core-keeper  | 
core-keeper  | Error: Symbol execvpe not found, cannot apply R_386_JMP_SLOT 0x66cfb324 (0x1308f6) in /home/steam/.steam/sdk32/steamclient.so
core-keeper  | Error: relocating Plt symbols in elf steamclient.so
core-keeper  | dlmopen /home/steam/.steam/sdk32/steamclient.so failed: Cannot dlopen("/home/steam/.steam/sdk32/steamclient.so"/0x641dd8e0, 2)
core-keeper  | 
core-keeper  | Error: Symbol execvpe not found, cannot apply R_386_JMP_SLOT 0x67bab324 (0x1308f6) in /home/steam/steamcmd/linux32/steamclient.so
core-keeper  | Error: relocating Plt symbols in elf steamclient.so
core-keeper  | dlmopen steamclient.so failed: Cannot dlopen("steamclient.so"/0x641dd8e0, 2)
core-keeper  | 
core-keeper  | src/common/steam/client_api.cpp (587) : ClientAPI_InitGlobalInstance: InternalAPI_Init_Internal failed, most likely because you are missing a 32-bit dependency of steamclient.so (the Steam client is a 32-bit app).
core-keeper  | 
core-keeper  | [2024-11-09 13:36:03] Server binary not found after installation
```