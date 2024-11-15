FROM arm64v8/debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive \
    STEAMAPPID=1007 \
    STEAMAPPID_TOOL=1963720 \
    STEAMAPPDIR="/home/steam/core-keeper-dedicated" \
    STEAMAPPDATADIR="/home/steam/core-keeper-data" \
    SCRIPTSDIR="/home/steam/scripts" \
    MODSDIR="/home/steam/core-keeper-data/StreamingAssets/Mods" \
    PUID=1000 \
    PGID=1000 \
    USER=steam \
    HOMEDIR=/home/steam

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

# Add x86_64 architecture support
RUN dpkg --add-architecture amd64 && \
    apt-get update

# Base dependencies
RUN apt-get install -y --no-install-recommends \
    wget unzip xvfb libglib2.0-0 libx11-6 libxcursor1 libxrandr2 \
    libasound2 gpg software-properties-common sudo \
    libxfixes3 libxrender1 libxinerama1 libxi6 libxss1 libxtst6 \
    libatomic1 libpulse0 libpulse-mainloop-glib0 libicu-dev \
    libdbus-1-3 tini tzdata gosu \
    mono-complete libsdl2-2.0-0 \
    libc6:amd64 libstdc++6:amd64 libgcc1:amd64 \
    && rm -rf /var/lib/apt/lists/*

# Box64 setup
RUN wget -qO- https://pi-apps-coders.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /usr/share/keyrings/box64-archive-keyring.gpg && \
    echo "Types: deb\nURIs: https://Pi-Apps-Coders.github.io/box64-debs/debian\nSuites: ./\nSigned-By: /usr/share/keyrings/box64-archive-keyring.gpg" | tee /etc/apt/sources.list.d/box64.sources && \
    apt-get update && \
    apt-get install -y box64-generic-arm && \
    rm -rf /var/lib/apt/lists/*

# Box86 setup
RUN dpkg --add-architecture armhf && \
    apt-get update && \
    apt-get install -y libc6:armhf && \
    wget -qO- https://pi-apps-coders.github.io/box86-debs/KEY.gpg | gpg --dearmor -o /usr/share/keyrings/box86-archive-keyring.gpg && \
    echo "Types: deb\nURIs: https://Pi-Apps-Coders.github.io/box86-debs/debian\nSuites: ./\nSigned-By: /usr/share/keyrings/box86-archive-keyring.gpg" | tee /etc/apt/sources.list.d/box86.sources && \
    apt-get update && \
    apt-get install -y box86-generic-arm:armhf && \
    rm -rf /var/lib/apt/lists/*

# DepotDownloader setup
RUN mkdir -p /opt/depotdownloader && \
    wget -q https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_2.7.4/DepotDownloader-linux-arm64.zip && \
    unzip DepotDownloader-linux-arm64.zip -d /opt/depotdownloader && \
    rm DepotDownloader-linux-arm64.zip

# Create steam user and setup directories
RUN groupadd -g ${PGID} steam && \
    useradd -u ${PUID} -g steam -m steam && \
    mkdir -p "${STEAMAPPDIR}" "${STEAMAPPDATADIR}" "${MODSDIR}" "${SCRIPTSDIR}" /tmp/.X11-unix && \
    chown -R steam:steam /home/steam "${STEAMAPPDIR}" "${STEAMAPPDATADIR}" "${SCRIPTSDIR}" && \
    chmod -R 755 "${STEAMAPPDIR}" "${STEAMAPPDATADIR}" "${SCRIPTSDIR}" && \
    chmod 1777 /tmp/.X11-unix

# Create entry script
COPY --chown=root:root ./scripts/* ${SCRIPTSDIR}/
RUN chmod +x ${SCRIPTSDIR}/* && \
    mkdir -p "${STEAMAPPDATADIR}/StreamingAssets/Mods"

WORKDIR /home/steam

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["bash", "scripts/docker-init.sh"]