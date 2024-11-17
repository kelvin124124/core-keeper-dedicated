FROM arm64v8/debian:bullseye-slim

# Environmental variables
ENV DEBIAN_FRONTEND=noninteractive \
    # User config
    PUID=1000 \
    PGID=1000 \
    USER=steam \
    HOMEDIR=/home/steam \
    # Steam config
    STEAMAPPID=1963720 \
    STEAMAPPID_TOOL=1007 \
    STEAMAPPDIR="/home/steam/core-keeper-dedicated" \
    STEAMAPPDATADIR="/home/steam/core-keeper-data" \
    SCRIPTSDIR="/home/steam/scripts" \
    MODSDIR="/home/steam/core-keeper-data/StreamingAssets/Mods" \
    # Box86/64 settings
    BOX64_DYNAREC_BIGBLOCK=1 \
    BOX64_DYNAREC_SAFEFLAGS=1 \
    BOX64_DYNAREC_STRONGMEM=2 \
    BOX64_DYNAREC_X87DOUBLE=1 \
    BOX64_MALLOC_HACK=1 \
    BOX64_DYNAREC_FASTROUND=0 \
    BOX64_DYNAREC_FASTNAN=0 \
    BOX64_DYNAREC_BLEEDING_EDGE=0 \
    BOX86_DYNAREC_BIGBLOCK=1 \
    BOX86_DYNAREC_SAFEFLAGS=1 \
    BOX86_DYNAREC_STRONGMEM=2 \
    BOX86_DYNAREC_X87DOUBLE=1 \
    BOX86_MALLOC_HACK=1 \
    BOX86_DYNAREC_FASTROUND=0 \
    BOX86_DYNAREC_FASTNAN=0 \
    BOX86_DYNAREC_BLEEDING_EDGE=0

# Install all dependencies
RUN dpkg --add-architecture amd64 && \
    dpkg --add-architecture armhf && \
    apt-get update -o Acquire::http::Pipeline-Depth=10 \
        -o Acquire::http::Parallel-Queue-Size=10 \
        -o Acquire::Languages=none && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        gpg \
        unzip \
        tini \
        gosu \
        xvfb \
        libx11-6 \
        libglib2.0-0 \
        libatomic1 \
        mono-complete \
        libsdl2-2.0-0 \
        libc6:amd64 \
        libstdc++6:amd64 \
        libgcc1:amd64 \
        libc6:armhf && \
    # Setup Box86/64
    wget -qO- https://pi-apps-coders.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /usr/share/keyrings/box64-archive-keyring.gpg && \
    echo "Types: deb\nURIs: https://Pi-Apps-Coders.github.io/box64-debs/debian\nSuites: ./\nSigned-By: /usr/share/keyrings/box64-archive-keyring.gpg" | tee /etc/apt/sources.list.d/box64.sources && \
    wget -qO- https://pi-apps-coders.github.io/box86-debs/KEY.gpg | gpg --dearmor -o /usr/share/keyrings/box86-archive-keyring.gpg && \
    echo "Types: deb\nURIs: https://Pi-Apps-Coders.github.io/box86-debs/debian\nSuites: ./\nSigned-By: /usr/share/keyrings/box86-archive-keyring.gpg" | tee /etc/apt/sources.list.d/box86.sources && \
    apt-get update && \
    apt-get install -y box64-generic-arm box86-generic-arm:armhf && \
    # Setup DepotDownloader
    mkdir -p /opt/depotdownloader && \
    wget -q https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_2.7.4/DepotDownloader-linux-arm64.zip && \
    unzip DepotDownloader-linux-arm64.zip -d /opt/depotdownloader && \
    rm DepotDownloader-linux-arm64.zip && \
    # Cleanup
    rm -rf /var/lib/apt/lists/*

# Setup user and directories
RUN groupadd -g ${PGID} steam && \
    useradd -u ${PUID} -g steam -m steam && \
    mkdir -p "${STEAMAPPDIR}" "${STEAMAPPDATADIR}" "${MODSDIR}" "${SCRIPTSDIR}" /tmp/.X11-unix && \
    mkdir -p "${STEAMAPPDATADIR}/StreamingAssets/Mods" && \
    chown -R steam:steam /home/steam "${STEAMAPPDIR}" "${STEAMAPPDATADIR}" "${SCRIPTSDIR}" && \
    chmod -R 755 "${STEAMAPPDIR}" "${STEAMAPPDATADIR}" "${SCRIPTSDIR}" && \
    chmod 1777 /tmp/.X11-unix

COPY --chown=root:root ./scripts/* ${SCRIPTSDIR}/
RUN chmod +x ${SCRIPTSDIR}/*

WORKDIR /home/steam

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["bash", "scripts/setup.sh"]