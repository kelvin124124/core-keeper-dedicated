#### Status
- [x] Build
- [x] Run
- [ ] Game
- [ ] Optimize

Stuck with the following error:
```
[2024-11-12 10:39:01] Server setup completed
[2024-11-12 10:39:01] Starting server
[2024-11-12 10:39:01] Starting Xvfb
[2024-11-12 10:39:02] Starting Core Keeper Server
Running on Neoverse-N1 with 4 Cores
Warning, unsupported BOX64_DYNAREC_NATIVEFLAGS=0 for [*setup*] in /etc/box64.box64rc
Warning, unsupported BOX64_DYNAREC_NATIVEFLAGS=0 for [*install*] in /etc/box64.box64rc
Warning, unsupported BOX64_MAXCPU=4 for [3dsen.x86_64] in /etc/box64.box64rc
Warning, unsupported BOX64_DYNAREC_ALIGNED_ATOMICS=1 for [3dsen.x86_64] in /etc/box64.box64rc
Warning, unsupported BOX64_DYNAREC_ALIGNED_ATOMICS=1 for [7z] in /etc/box64.box64rc
Warning, unsupported BOX64_DYNAREC_ALIGNED_ATOMICS=1 for [7zz] in /etc/box64.box64rc
Warning, unsupported BOX64_MAXCPU=16 for [alienisolation] in /etc/box64.box64rc
Warning, unsupported BOX64_DYNAREC_ALIGNED_ATOMICS=1 for [bash] in /etc/box64.box64rc
Warning, unsupported BOX64_DYNAREC_ALIGNED_ATOMICS=1 for [box64-bash] in /etc/box64.box64rc
Warning, unsupported BOX64_MAXCPU=4 for [broforce.x86_64] in /etc/box64.box64rc
Warning, unsupported BOX64_DYNAREC_ALIGNED_ATOMICS=1 for [deadcells] in /etc/box64.box64rc
Warning, unsupported BOX64_MAXCPU=4 for [etg.x86_64] in /etc/box64.box64rc
Warning, unsupported BOX64_DYNAREC_ALIGNED_ATOMICS=1 for [factorio] in /etc/box64.box64rc
Warning, unsupported BOX64_ENV=BOX64_DYNAREC_STRONGMEM=3 for [geekbench6] in /etc/box64.box64rc
Warning, unsupported BOX64_ENV1=BOX64_RESERVE_HIGH=1 for [geekbench6] in /etc/box64.box64rc
Warning, unsupported BOX64_ENV=BOX64_DYNAREC_BIGBLOCK=2 for [geekbench5] in /etc/box64.box64rc
Warning, unsupported BOX64_ENV1=BOX64_DYNAREC_FORWARD=1024 for [geekbench5] in /etc/box64.box64rc
Warning, unsupported BOX64_ENV2=BOX64_DYNAREC_CALLRET=1 for [geekbench5] in /etc/box64.box64rc
Warning, unsupported BOX64_DYNAREC_ALIGNED_ATOMICS=1 for [gridautosport] in /etc/box64.box64rc
Warning, unsupported BOX64_MAXCPU=16 for [gridautosport] in /etc/box64.box64rc
Warning, unsupported BOX64_INPROCESSGPU=1 for [heroic] in /etc/box64.box64rc
Warning, unsupported BOX64_DYNAREC_ALIGNED_ATOMICS=1 for [heroic] in /etc/box64.box64rc
Warning, unsupported BOX64_MAXCPU=16 for [hue.x86_64] in /etc/box64.box64rc
Warning, unsupported BOX64_RESERVE_HIGH=1 for [kingdom rush origins] in /etc/box64.box64rc
Warning, unsupported BOX64_MAXCPU=4 for [kingdom.x86_64] in /etc/box64.box64rc
Warning, unsupported BOX64_ADDLIBS=libstdc++.so.6 for [mini metro] in /etc/box64.box64rc
Warning, unsupported BOX64_DYNAREC_ALIGNED_ATOMICS=1 for [nuclearblaze] in /etc/box64.box64rc
Warning, unsupported BOX64_DYNAREC_ALIGNED_ATOMICS=1 for [projectzomboid64] in /etc/box64.box64rc
Warning, unsupported BOX64_JVM=0 for [projectzomboid64] in /etc/box64.box64rc
Warning, unsupported BOX64_SSE42=0 for [projectzomboid64] in /etc/box64.box64rc
Warning, unsupported BOX64_MAXCPU=4 for [projectzomboid64] in /etc/box64.box64rc
Warning, unsupported BOX64_SDL2_JGUID=1 for [shovelknight] in /etc/box64.box64rc
Warning, unsupported BOX64_DYNAREC_ALIGNED_ATOMICS=1 for [shovelknight] in /etc/box64.box64rc
Warning, unsupported BOX64_INPROCESSGPU=1 for [spotify] in /etc/box64.box64rc
Warning, unsupported BOX64_DYNAREC_ALIGNED_ATOMICS=1 for [torchlight2.bin.x86_64] in /etc/box64.box64rc
Warning, unsupported BOX64_INPROCESSGPU=1 for [weixin] in /etc/box64.box64rc
Warning, unsupported BOX64_MAXCPU=64 for [wine] in /etc/box64.box64rc
Warning, unsupported BOX64_MAXCPU=64 for [wine64] in /etc/box64.box64rc
Warning, unsupported BOX64_DYNAREC_ALIGNED_ATOMICS=1 for [batmanak.exe] in /etc/box64.box64rc
Warning, unsupported BOX64_DYNAREC_ALIGNED_ATOMICS=0 for [battle.net.exe] in /etc/box64.box64rc
Warning, unsupported BOX64_SHAEXT=0 for [claybook-win64-shipping.exe] in /etc/box64.box64rc
Warning, unsupported BOX64_AVX=2 for [ds.exe] in /etc/box64.box64rc
Warning, unsupported BOX64_RDTSC_1GHZ=1 for [ds.exe] in /etc/box64.box64rc
Warning, unsupported BOX64_MAXCPU=4 for [fp2.exe] in /etc/box64.box64rc
Warning, unsupported BOX64_AVX=0 for [forzawebhelper.exe] in /etc/box64.box64rc
Warning, unsupported BOX64_RDTSC_1GHZ=1 for [horizonzerodawn.exe] in /etc/box64.box64rc
Warning, unsupported BOX64_ARGS=-cef-disable-breakpad -cef-disable-d3d11 -cef-disable-delaypageload -cef-force-occlusion -cef-disable-sandbox -cef-disable-seccomp-sandbox -no-cef-sandbox -disable-winh264 -cef-disable-gpu -vgui -oldtraymenu -cef-single-process for [steam.exe] in /etc/box64.box64rc
Params database has 97 entries
Using default BOX64_LD_LIBRARY_PATH: ./:lib/:lib64/:x86_64/:bin64/:libs64/
Using default BOX64_PATH: ./:bin/
Counted 38 Env var
Looking for ./CoreKeeperServer
argv[1]="-batchmode"
argv[2]="-extralog"
argv[3]="-logfile"
argv[4]="/home/steam/core-keeper-dedicated/logs/2024-11-12_10-39-01.log"
argv[5]="-world"
argv[6]="0"
argv[7]="-worldname"
argv[8]="Core"
argv[9]="Keeper"
argv[10]="ARM64"
argv[11]="-worldseed"
argv[12]="0"
argv[13]="-worldmode"
argv[14]="0"
argv[15]="-datapath"
argv[16]="/home/steam/core-keeper-data"
argv[17]="-maxplayers"
argv[18]="10"
Rename process to "CoreKeeperServer"
Using emulated UnityPlayer.so
Using native(wrapped) libm.so.6
Error loading needed lib libgcc_s.so.1
Using native(wrapped) libpthread.so.0
Using native(wrapped) libc.so.6
Using native(wrapped) ld-linux-x86-64.so.2
Using native(wrapped) libutil.so.1
Using native(wrapped) librt.so.1
Error loading one of needed lib
Error: loading needed libs in elf /home/steam/core-keeper-dedicated/CoreKeeperServer
```
