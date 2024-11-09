# Dockerfile that builds a Core Keeper Gameserver
FROM sonroyaalmerol/steamcmd-arm64:root

ENV ARCHITECTURE=arm64 \
    BOX64_DYNAREC_STRONGMEM=3 \
    STEAMAPPID=1007 \
    STEAMAPPID_TOOL=1963720 \
    STEAMAPP="core-keeper" \
    STEAMAPPDIR="/home/steam/core-keeper-dedicated" \
    STEAMAPPDATADIR="/home/steam/core-keeper-data" \
    SCRIPTSDIR="/home/steam/scripts" \
    MODSDIR="/home/steam/core-keeper-data/StreamingAssets/Mods"

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        libxi6 \
        tini \
        tzdata \
        gosu \
        jo \
        gettext-base \
        xvfb \
        libdbus-1-3 \
        libxcursor1 \
        libxss1 \
        libpulse-dev \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /tmp/.X11-unix \
    && chmod 1777 /tmp/.X11-unix \
    && chown root /tmp/.X11-unix

COPY ./scripts ${SCRIPTSDIR}
RUN set -x \
    && chmod +x -R "${SCRIPTSDIR}" \
    && mkdir -p "${STEAMAPPDIR}" \
    && mkdir -p "${STEAMAPPDATADIR}" \
    && mkdir -p "${MODSDIR}" \
    && chown -R steam:steam "${SCRIPTSDIR}" "${STEAMAPPDIR}" "${STEAMAPPDATADIR}"

ENV PUID=1000 \
    PGID=1000 \
    WORLD_INDEX=0 \
    WORLD_NAME="Core Keeper Server" \
    WORLD_SEED=0 \
    WORLD_MODE=0 \
    GAME_ID="" \
    DATA_PATH="${STEAMAPPDATADIR}" \
    MAX_PLAYERS=10 \
    SEASON="" \
    SERVER_IP="" \
    SERVER_PORT=""

USER steam
WORKDIR /home/steam

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["bash", "scripts/entry.sh"]