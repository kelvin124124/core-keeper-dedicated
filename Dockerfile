FROM arm64v8/debian:bullseye-slim AS downloader
RUN mkdir -p /opt/depotdownloader && \
    apt-get update && \
    apt-get install -y wget unzip && \
    wget -q https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_2.7.4/DepotDownloader-linux-arm64.zip && \
    unzip DepotDownloader-linux-arm64.zip -d /opt/depotdownloader && \
    rm DepotDownloader-linux-arm64.zip

FROM arm64v8/debian:bullseye-slim AS box-installer
RUN apt-get update && \
    apt-get install -y wget gpg && \
    # Box64 setup
    wget -qO- https://pi-apps-coders.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /usr/share/keyrings/box64-archive-keyring.gpg && \
    echo "Types: deb\nURIs: https://Pi-Apps-Coders.github.io/box64-debs/debian\nSuites: ./\nSigned-By: /usr/share/keyrings/box64-archive-keyring.gpg" | tee /etc/apt/sources.list.d/box64.sources && \
    # Box86 setup
    wget -qO- https://pi-apps-coders.github.io/box86-debs/KEY.gpg | gpg --dearmor -o /usr/share/keyrings/box86-archive-keyring.gpg && \
    echo "Types: deb\nURIs: https://Pi-Apps-Coders.github.io/box86-debs/debian\nSuites: ./\nSigned-By: /usr/share/keyrings/box86-archive-keyring.gpg" | tee /etc/apt/sources.list.d/box86.sources

FROM arm64v8/debian:bullseye-slim

# System configuration
ENV DEBIAN_FRONTEND=noninteractive \
    PUID=1000 \
    PGID=1000 \
    USER=steam \
    HOMEDIR=/home/steam

# Steam configuration
ENV STEAMAPPID=1007 \
    STEAMAPPID_TOOL=1963720 \
    STEAMAPPDIR="/home/steam/core-keeper-dedicated" \
    STEAMAPPDATADIR="/home/steam/core-keeper-data" \
    SCRIPTSDIR="/home/steam/scripts" \
    MODSDIR="/home/steam/core-keeper-data/StreamingAssets/Mods"

# Box86/64 optimization settings
ENV BOX64_DYNAREC_BIGBLOCK=0 \
    BOX64_DYNAREC_SAFEFLAGS=2 \
    BOX64_DYNAREC_STRONGMEM=3 \
    BOX64_DYNAREC_FASTROUND=0 \
    BOX64_DYNAREC_FASTNAN=0 \
    BOX64_DYNAREC_X87DOUBLE=1 \
    BOX64_DYNAREC_BLEEDING_EDGE=0 \
    BOX86_DYNAREC_BIGBLOCK=0 \
    BOX86_DYNAREC_SAFEFLAGS=2 \
    BOX86_DYNAREC_STRONGMEM=3 \
    BOX86_DYNAREC_FASTROUND=0 \
    BOX86_DYNAREC_FASTNAN=0 \
    BOX86_DYNAREC_X87DOUBLE=1 \
    BOX86_DYNAREC_BLEEDING_EDGE=0

# Copy Box repository configurations from box-installer stage
COPY --from=box-installer /usr/share/keyrings/box64-archive-keyring.gpg /usr/share/keyrings/
COPY --from=box-installer /usr/share/keyrings/box86-archive-keyring.gpg /usr/share/keyrings/
COPY --from=box-installer /etc/apt/sources.list.d/box64.sources /etc/apt/sources.list.d/
COPY --from=box-installer /etc/apt/sources.list.d/box86.sources /etc/apt/sources.list.d/

# Add architectures and install dependencies in parallel groups
RUN dpkg --add-architecture amd64 && \
    dpkg --add-architecture armhf && \
    apt-get update && \
    # Install dependencies in parallel groups to optimize layer caching
    apt-get install -y --no-install-recommends \
        # Group 1: Essential utilities
        tini \
        gosu \
        sudo \
        tzdata \
        # Group 2: X11 and display
        xvfb \
        libx11-6 \
        libxcursor1 \
        libxrandr2 \
        libxfixes3 \
        libxrender1 \
        libxinerama1 \
        libxi6 \
        libxss1 \
        libxtst6 \
        # Group 3: Audio
        libasound2 \
        libpulse0 \
        libpulse-mainloop-glib0 \
        # Group 4: Core system
        libglib2.0-0 \
        libatomic1 \
        libicu-dev \
        libdbus-1-3 \
        mono-complete \
        libsdl2-2.0-0 \
        # Group 5: Architecture-specific
        libc6:amd64 \
        libstdc++6:amd64 \
        libgcc1:amd64 \
        libc6:armhf \
        # Group 6: Box86/64
        box64-generic-arm \
        box86-generic-arm:armhf && \
    # Cleanup
    rm -rf /var/lib/apt/lists/*

# Copy DepotDownloader from downloader stage
COPY --from=downloader /opt/depotdownloader /opt/depotdownloader

# Setup user and directories (parallelized where possible)
RUN groupadd -g ${PGID} steam && \
    useradd -u ${PUID} -g steam -m steam && \
    mkdir -p \
        "${STEAMAPPDIR}" \
        "${STEAMAPPDATADIR}" \
        "${MODSDIR}" \
        "${SCRIPTSDIR}" \
        /tmp/.X11-unix \
        "${STEAMAPPDATADIR}/StreamingAssets/Mods" && \
    chown -R steam:steam \
        /home/steam \
        "${STEAMAPPDIR}" \
        "${STEAMAPPDATADIR}" \
        "${SCRIPTSDIR}" && \
    chmod -R 755 \
        "${STEAMAPPDIR}" \
        "${STEAMAPPDATADIR}" \
        "${SCRIPTSDIR}" && \
    chmod 1777 /tmp/.X11-unix

COPY --chown=root:root ./scripts/* ${SCRIPTSDIR}/
RUN chmod +x ${SCRIPTSDIR}/*

WORKDIR /home/steam

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["bash", "scripts/setup.sh"]