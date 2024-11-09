# Dockerfile that builds a Core Keeper Gameserver

FROM cm2network/steamcmd:root AS base-amd64
# Ignoring --platform=arm64 as this is required for the multi-arch build to continue to work on amd64 hosts
FROM --platform=arm64 sonroyaalmerol/steamcmd-arm64:root AS base-arm64
# Set BOX64- & BOX86-Parameters
# Thanks to @hsau / https://github.com/escapingnetwork/core-keeper-dedicated/issues/45
ENV ARCHITECTURE=arm64\
    BOX64_DYNAREC_BIGBLOCK=0 \
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
    BOX86_DYNAREC_BLEEDING_EDGE=0 \
#   Extralogs from box64 issues 1782
    BOX64_LOG=1 \
    BOX64_ROLLING_LOG=1 \
    BOX64_SHOWSEGV=1 \
    BOX64_SHOWBT=1 \
    BOX64_DLSYM_ERROR=1

ARG TARGETARCH
FROM base-${TARGETARCH}

ENV STEAMAPPID=1007
ENV STEAMAPPID_TOOL=1963720
ENV STEAMAPP=core-keeper
ENV STEAMAPPDIR="${HOMEDIR}/${STEAMAPP}-dedicated"
ENV STEAMAPPDATADIR="${HOMEDIR}/${STEAMAPP}-data"
ENV SCRIPTSDIR="${HOMEDIR}/scripts"
ENV MODSDIR="${STEAMAPPDATADIR}/StreamingAssets/Mods"

RUN dpkg --add-architecture i386

# Install Core Keeper server dependencies and clean up
ARG TARGETARCH
RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        xvfb \
        libxi6 \
        tini \
        tzdata \
        gosu \
        jo \
        gettext-base \
#   xvfb mesa-utils libx32gcc-s1-amd64-cross lib32gcc-s1-amd64-cross build-essential libxi6 x11-utils tini \
    && if [[ "${TARGETARCH}" == "arm64" ]] ; then apt-get install -y box64 libdbus-1-3 libxcursor1 libxss1 libpulse-dev; fi \
    && rm -rf /var/lib/apt/lists/*

# Setup X11 Sockets folder
RUN mkdir /tmp/.X11-unix \
    && chmod 1777 /tmp/.X11-unix \
    && chown root /tmp/.X11-unix

# Setup folders
COPY ./scripts ${SCRIPTSDIR}
RUN set -x \
    && chmod +x -R "${SCRIPTSDIR}" \
    && mkdir -p "${STEAMAPPDIR}" \
    && mkdir -p "${STEAMAPPDATADIR}" \
    && chown -R "${USER}:${USER}" "${SCRIPTSDIR}" "${STEAMAPPDIR}" "${STEAMAPPDATADIR}"

# Declare envs and their default values
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
    SERVER_PORT="" \

# Switch to workdir
WORKDIR ${HOMEDIR}

# Use tini as the entrypoint for signal handling
ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["bash", "scripts/entry.sh"]
