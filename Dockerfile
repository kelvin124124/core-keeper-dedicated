# Dockerfile that builds a Core Keeper Gameserver

FROM cm2network/steamcmd:root AS base-amd64
# Ignoring --platform=arm64 as this is required for the multi-arch build to continue to work on amd64 hosts
FROM --platform=arm64 sonroyaalmerol/steamcmd-arm64:root AS base-arm64

# Set BOX64- & BOX86-Parameters for ARM64
ENV ARCHITECTURE=arm64 \
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
    BOX64_LOG=1 \
    BOX64_ROLLING_LOG=1 \
    BOX64_SHOWSEGV=1 \
    BOX64_SHOWBT=1 \
    BOX64_DLSYM_ERROR=1

ARG TARGETARCH
FROM base-${TARGETARCH}

# Steam app configuration
ENV STEAMAPPID=1007 \
    STEAMAPPID_TOOL=1963720 \
    STEAMAPP=core-keeper \
    STEAMAPPDIR="${HOMEDIR}/${STEAMAPP}-dedicated" \
    STEAMAPPDATADIR="${HOMEDIR}/${STEAMAPP}-data" \
    SCRIPTSDIR="${HOMEDIR}/scripts" \
    MODSDIR="${STEAMAPPDATADIR}/StreamingAssets/Mods"

# Add i386 architecture support
RUN dpkg --add-architecture i386

# Install dependencies
ARG TARGETARCH
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
    && if [[ "${TARGETARCH}" == "arm64" ]] ; then \
        apt-get install -y \
            box64 \
            libdbus-1-3 \
            libxcursor1 \
            libxss1 \
            libpulse-dev \
    ; fi \
    && rm -rf /var/lib/apt/lists/*

# Setup X11 Sockets folder
RUN mkdir /tmp/.X11-unix \
    && chmod 1777 /tmp/.X11-unix \
    && chown root /tmp/.X11-unix

# Setup application folders and scripts
COPY ./scripts ${SCRIPTSDIR}
RUN set -x \
    && chmod +x -R "${SCRIPTSDIR}" \
    && mkdir -p "${STEAMAPPDIR}" \
    && mkdir -p "${STEAMAPPDATADIR}" \
    && chown -R "${USER}:${USER}" "${SCRIPTSDIR}" "${STEAMAPPDIR}" "${STEAMAPPDATADIR}"

# Default configuration
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

# Set working directory
WORKDIR ${HOMEDIR}

# Use tini as the entrypoint for signal handling
ENTRYPOINT ["/usr/bin/tini", "--"]

# Default command
CMD ["bash", "scripts/entry.sh"]