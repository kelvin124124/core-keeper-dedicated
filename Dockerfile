###########################################################
# Dockerfile that builds a Core Keeper Gameserver
###########################################################
FROM cm2network/steamcmd:root as base-amd64
# Ignoring --platform=arm64 as this is required for the multi-arch build to continue to work on amd64 hosts
FROM --platform=arm64 sonroyaalmerol/steamcmd-arm64:root as base-arm64
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
    BOX86_DYNAREC_BLEEDING_EDGE=0 

ARG TARGETARCH
FROM base-${TARGETARCH}

LABEL maintainer="leandro.martin@protonmail.com"

ENV STEAMAPPID=1007
ENV STEAMAPPID_TOOL=1963720
ENV STEAMAPP=core-keeper
ENV STEAMAPPDIR="${HOMEDIR}/${STEAMAPP}-dedicated"
ENV STEAMAPPDATADIR="${HOMEDIR}/${STEAMAPP}-data"
ENV SCRIPTSDIR="${HOMEDIR}/scripts"
ENV MODSDIR="${STEAMAPPDATADIR}/StreamingAssets/Mods"
ENV DLURL=https://raw.githubusercontent.com/escapingnetwork/core-keeper-dedicated

RUN dpkg --add-architecture i386

# Install Core Keeper server dependencies and clean up
RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
	xvfb mesa-utils libx32gcc-s1-amd64-cross lib32gcc-s1-amd64-cross build-essential libxi6 x11-utils tini \
	&& if [[ "${TARGETARCH}" == "arm64" ]] ; then apt-get install -y box64 libdbus-1-3 libxcursor1 libxss1 libpulse-dev; fi \
	&& mkdir -p "${STEAMAPPDIR}" \
	&& mkdir -p "${STEAMAPPDATADIR}" \
	&& chmod +x "${HOMEDIR}/entry.sh" \
	&& chmod +x "${HOMEDIR}/launch.sh" \
	&& chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${HOMEDIR}/launch.sh" "${STEAMAPPDIR}" "${STEAMAPPDATADIR}" \
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
    DISCORD_WEBHOOK_URL="" \
    # Player Join
    DISCORD_PLAYER_JOIN_ENABLED=true \
    DISCORD_PLAYER_JOIN_MESSAGE='${char_name} (${steamid}) has joined the server.' \
    DISCORD_PLAYER_JOIN_TITLE="Player Joined" \
    DISCORD_PLAYER_JOIN_COLOR="47456" \
    # Player Leave
    DISCORD_PLAYER_LEAVE_ENABLED=true \
    DISCORD_PLAYER_LEAVE_MESSAGE='${char_name} (${steamid}) has disconnected. Reason: ${reason}.' \
    DISCORD_PLAYER_LEAVE_TITLE="Player Left" \
    DISCORD_PLAYER_LEAVE_COLOR="11477760" \
    # Server Start
    DISCORD_SERVER_START_ENABLED=true \
    DISCORD_SERVER_START_MESSAGE='**World:** ${world_name}\n**GameID:** ${gameid}' \
    DISCORD_SERVER_START_TITLE="Server Started" \
    DISCORD_SERVER_START_COLOR="2013440" \
    # Server Stop
    DISCORD_SERVER_STOP_ENABLED=true \
    DISCORD_SERVER_STOP_MESSAGE="" \
    DISCORD_SERVER_STOP_TITLE="Server Stopped" \
    DISCORD_SERVER_STOP_COLOR="12779520"

# Switch to workdir
WORKDIR ${HOMEDIR}

# Use tini as the entrypoint for signal handling
ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["bash", "scripts/entry.sh"]
