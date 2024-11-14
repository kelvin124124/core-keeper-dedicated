#!/bin/bash
# launch.sh
set -e

log() {
    printf '\033[1;36m[%s] %s\033[0m\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1"
}

cd "${STEAMAPPDIR}" || exit 1

# Prepare logging
mkdir -p "${STEAMAPPDIR}/logs"
logfile="${STEAMAPPDIR}/logs/$(date '+%Y-%m-%d_%H-%M-%S').log"

# Build server parameters
params="-batchmode -extralog -logfile $logfile"
[ -n "$WORLD_INDEX" ] && params+=" -world $WORLD_INDEX"
[ -n "$WORLD_NAME" ] && params+=" -worldname $WORLD_NAME"
[ -n "$WORLD_SEED" ] && params+=" -worldseed $WORLD_SEED"
[ -n "$WORLD_MODE" ] && params+=" -worldmode $WORLD_MODE"
[ -n "$GAME_ID" ] && params+=" -gameid $GAME_ID"
[ -n "$DATA_PATH" ] && params+=" -datapath ${DATA_PATH:-${STEAMAPPDATADIR}}"
[ -n "$MAX_PLAYERS" ] && params+=" -maxplayers $MAX_PLAYERS"
[ -n "$SEASON" ] && params+=" -season $SEASON"
[ -n "$SERVER_IP" ] && params+=" -ip $SERVER_IP"
[ -n "$SERVER_PORT" ] && params+=" -port $SERVER_PORT"

cleanup() {
    log "Shutting down..."
    pkill -f CoreKeeperServer || true
    pkill Xvfb || true
    log "Shutdown complete"
}

trap cleanup EXIT

# Start Xvfb
log "Starting Xvfb"
Xvfb :99 -screen 0 1x1x24 -nolisten tcp &
sleep 1

export DISPLAY=:99
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${STEAMAPPDIR}/linux64/"

# Clean up existing files
rm -f GameID.txt EXIT.txt

log "Starting Core Keeper Server"
box64 ./CoreKeeperServer $params

# Monitor server
while [ ! -f "EXIT.txt" ]; do
    sleep 5
done

log "Server shutdown completed"