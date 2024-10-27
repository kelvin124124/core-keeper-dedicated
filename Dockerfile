###########################################################
# Dockerfile that builds a Core Keeper Gameserver
###########################################################
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
    BOX86_DYNAREC_BLEEDING_EDGE=0 

ARG TARGETARCH
FROM base-${TARGETARCH}

LABEL maintainer="leandro.martin@protonmail.com"

ENV STEAMAPPID 1007
ENV STEAMAPPID_TOOL 1963720
ENV STEAMAPP core-keeper
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"
ENV STEAMAPPDATADIR "${HOMEDIR}/${STEAMAPP}-data"
ENV DLURL https://raw.githubusercontent.com/escapingnetwork/core-keeper-dedicated

COPY ./entry.sh ${HOMEDIR}/entry.sh
COPY ./launch.sh ${HOMEDIR}/launch.sh

RUN dpkg --add-architecture i386

# Install Core Keeper server dependencies and clean up
# libx32gcc-s1 lib32gcc-s1 build-essential <- fixes tile generation bug (obsidian wall around spawn) without graphic cards mounted to server
# need all 3 + dpkg i do not know why but every other combination would run the server at an extreme speed - that combination worked for me.
# Thanks to https://www.reddit.com/r/CoreKeeperGame/comments/uym86p/comment/iays04w/?utm_source=share&utm_medium=web2x&context=3
ARG TARGETARCH
RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
	xvfb mesa-utils libx32gcc-s1-amd64-cross lib32gcc-s1-amd64-cross build-essential libxi6 x11-utils tini \
	&& if [[ "${TARGETARCH}" == "arm64" ]] ; then apt-get install -y libdbus-1-3 libxcursor1 libxss1 libpulse-dev libmonosgen-2.0 libmonosgen-2.0-1 ; fi \
	&& apt-get upgrade -y \
	&& mkdir -p "${STEAMAPPDIR}" \
	&& mkdir -p "${STEAMAPPDATADIR}" \
	&& chmod +x "${HOMEDIR}/entry.sh" \
	&& chmod +x "${HOMEDIR}/launch.sh" \
	&& chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${HOMEDIR}/launch.sh" "${STEAMAPPDIR}" "${STEAMAPPDATADIR}" \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir /tmp/.X11-unix \
	&& chown -R "${USER}:${USER}" /tmp/.X11-unix

ENV WORLD_INDEX=0 \
	WORLD_NAME="Core Keeper Server" \
	WORLD_SEED=0 \
	WORLD_MODE=0 \
	GAME_ID="" \
	DATA_PATH="${STEAMAPPDATADIR}" \
	MAX_PLAYERS=10 \
	SEASON=-1 \
	SERVER_IP="" \
    SERVER_PORT=""

# Switch to user
USER ${USER}

# Switch to workdir
WORKDIR ${HOMEDIR}

VOLUME ${STEAMAPPDIR}

# Use tini as the entrypoint for signal handling
ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["bash", "entry.sh"]
