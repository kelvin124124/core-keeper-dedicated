#### Status
- [x] Build
- [x] Run
- [ ] Game
- [ ] Optimize

To solve the steamclient.so error, build the base steamcmd-arm image with box64 v2.4.  
See: https://github.com/ptitSeb/box64/issues/1782

Stuck with the following error:
```
ubuntu@instance-20240129-2146:~/server/core-k/core-keeper-dedicated/steamcmd-box64$ sudo docker logs -f core-keeper
[2024-11-12 10:53:20] Executing setup
[2024-11-12 10:53:20] Creating directories
[2024-11-12 10:53:20] Running SteamCMD update
...
Rename process to "steamcmd"
Using native(wrapped) libdl.so.2
Using native(wrapped) libc.so.6
Using native(wrapped) ld-linux.so.2
Using native(wrapped) libpthread.so.0
Using native(wrapped) librt.so.1
Using native(wrapped) libbsd.so.0
Using native(wrapped) libm.so.6
Using emulated /home/steam/steamcmd/linux32/crashhandler.so
Warning: Weak Symbol _ZGTtnaj not found, cannot apply R_386_JMP_SLOT 0x6009bac0 (0x81b6)
Redirecting stderr to '/home/steam/Steam/logs/stderr.txt'
Logging directory: '/home/steam/Steam/logs'
[  0%] Checking for available updates...
[----] Verifying installation...
UpdateUI: skip show logoUsing emulated /home/steam/steamcmd/linux32/steamconsole.so
Using emulated /home/steam/steamcmd/linux32/libtier0_s.so
Using emulated /home/steam/steamcmd/linux32/libvstdlib_s.so
Warning: Weak Symbol _ZGTtnaj not found, cannot apply R_386_JMP_SLOT 0x60454dd0 (0xd536)
Warning: Weak Symbol _ZGTtnaj not found, cannot apply R_386_JMP_SLOT 0x606a9aa4 (0xb1c6)
Warning: Weak Symbol _ZGTtnaj not found, cannot apply R_386_JMP_SLOT 0x602ce948 (0x9246)
Steam Console Client (c) Valve Corporation - version 1730854361
-- type 'quit' to exit --
Loading Steam API...Using emulated /home/steam/steamcmd/linux32/steamclient.so
Warning: Weak Symbol _ZGTtnaj not found, cannot apply R_386_JMP_SLOT 0x687e94d0 (0x130fa6)
IPC function call IClientUtils::GetSteamRealm took too long: 148 msec
OK

Connecting anonymously to Steam Public...OK
Waiting for client config...OK
Waiting for user info...OK
 Update state (0x3) reconfiguring, progress: 0.00 (0 / 0)
 Update state (0x61) downloading, progress: 0.00 (0 / 78382436)
Error loading needed lib libSDL3.so.0
Warning: Cannot dlopen("libSDL3.so.0"/0x67d7ae38, 2)
 Update state (0x61) downloading, progress: 61.20 (47973732 / 78382436)
IPC function call IClientAppManager::GetUpdateInfo took too long: 53 msec
Success! App '1007' fully installed.
 Update state (0x3) reconfiguring, progress: 0.00 (0 / 0)
 Update state (0x3) reconfiguring, progress: 0.00 (0 / 0)
 Update state (0x61) downloading, progress: 17.63 (111599828 / 632979172)
 Update state (0x61) downloading, progress: 33.69 (213268228 / 632979172)
 Update state (0x61) downloading, progress: 60.69 (384147051 / 632979172)
 Update state (0x61) downloading, progress: 78.53 (497107437 / 632979172)
 Update state (0x61) downloading, progress: 99.50 (629833444 / 632979172)
 Update state (0x81) verifying update, progress: 35.04 (221767885 / 632979172)
IPC function call IClientAppManager::GetUpdateInfo took too long: 60 msec
Success! App '1963720' fully installed.
CWorkThreadPool::~CWorkThreadPool: work processing queue not empty: 1 items discarded.
Sigfault/Segbus while quitting, exiting silently
[2024-11-12 10:53:56] Server setup completed
[2024-11-12 10:53:56] Starting server
[2024-11-12 10:53:56] Starting Xvfb
[2024-11-12 10:53:57] Starting Core Keeper Server
Running on Neoverse-N1 with 4 Cores
Warning, unsupported BOX64_DYNAREC_NATIVEFLAGS=0 for [*setup*] in /etc/box64.box64rc
...
Warning, unsupported BOX64_ARGS=-cef-disable-breakpad -cef-disable-d3d11 -cef-disable-delaypageload -cef-force-occlusion -cef-disable-sandbox -cef-disable-seccomp-sandbox -no-cef-sandbox -disable-winh264 -cef-disable-gpu -vgui -oldtraymenu -cef-single-process for [steam.exe] in /etc/box64.box64rc
Params database has 97 entries
BOX64_LD_LIBRARY_PATH: /home/steam/core-keeper-dedicated/:/home/steam/core-keeper-dedicated/lib64/:/usr/lib/x86_64-linux-gnu/:/lib/x86_64-linux-gnu/:/home/steam/.steam/sdk64/
Using default BOX64_PATH: ./:bin/
Counted 38 Env var
Looking for ./CoreKeeperServer
...
Rename process to "CoreKeeperServer"
Using emulated UnityPlayer.so
Using native(wrapped) libm.so.6
Using emulated /usr/lib/x86_64-linux-gnu/libgcc_s.so.1
Using native(wrapped) libpthread.so.0
Using native(wrapped) libc.so.6
Using native(wrapped) ld-linux-x86-64.so.2
Using native(wrapped) libutil.so.1
Using native(wrapped) librt.so.1
Using native(wrapped) libdl.so.2
Warning: Global Symbol _ZTH15gDeferredAction not found, cannot apply R_X86_64_GLOB_DAT @0x103f4b730 ((nil)) in UnityPlayer.so
[UnityMemory] Configuration Parameters - Can be set up in boot.config
    "memorysetup-bucket-allocator-granularity=16"
    "memorysetup-bucket-allocator-bucket-count=8"
    "memorysetup-bucket-allocator-block-size=4194304"
    "memorysetup-bucket-allocator-block-count=1"
    "memorysetup-main-allocator-block-size=16777216"
    "memorysetup-thread-allocator-block-size=16777216"
    "memorysetup-gfx-main-allocator-block-size=16777216"
    "memorysetup-gfx-thread-allocator-block-size=16777216"
    "memorysetup-cache-allocator-block-size=4194304"
    "memorysetup-typetree-allocator-block-size=2097152"
    "memorysetup-profiler-bucket-allocator-granularity=16"
    "memorysetup-profiler-bucket-allocator-bucket-count=8"
    "memorysetup-profiler-bucket-allocator-block-size=4194304"
    "memorysetup-profiler-bucket-allocator-block-count=1"
    "memorysetup-profiler-allocator-block-size=16777216"
    "memorysetup-profiler-editor-allocator-block-size=1048576"
    "memorysetup-temp-allocator-size-main=4194304"
    "memorysetup-job-temp-allocator-block-size=2097152"
    "memorysetup-job-temp-allocator-block-size-background=1048576"
    "memorysetup-job-temp-allocator-reduction-small-platforms=262144"
    "memorysetup-allocator-temp-initial-block-size-main=262144"
    "memorysetup-allocator-temp-initial-block-size-worker=262144"
    "memorysetup-temp-allocator-size-background-worker=32768"
    "memorysetup-temp-allocator-size-job-worker=262144"
    "memorysetup-temp-allocator-size-preload-manager=262144"
    "memorysetup-temp-allocator-size-nav-mesh-worker=65536"
    "memorysetup-temp-allocator-size-audio-worker=65536"
    "memorysetup-temp-allocator-size-cloud-worker=32768"
    "memorysetup-temp-allocator-size-gfx=262144"
Using native(wrapped) libdbus-1.so.3
Using native(wrapped) libX11.so.6
Using native(wrapped) libXext.so.6
Using native(wrapped) libxcb.so.1
Using native(wrapped) libXau.so.6
Using native(wrapped) libXdmcp.so.6
Using native(wrapped) libXcursor.so.1
Error initializing native libXinerama.so.1 (last dlerror is libXinerama.so.1: cannot open shared object file: No such file or directory)
Error loading needed lib libXinerama.so.1
Warning: Cannot dlopen("libXinerama.so.1"/0x1021e0c35, 2)
Using native(wrapped) libXi.so.6
Using native(wrapped) libXrandr.so.2
Using native(wrapped) libXrender.so.1
Using native(wrapped) libXss.so.1
Using native(wrapped) libXxf86vm.so.1
Using native(wrapped) libudev.so.1
```
