#!/bin/bash
set -e

# Minimal logging function
log() {
    local type=$1 msg=$2
    local color='\033[1;36m' # Default cyan
    case "$type" in
        error) color='\033[1;31m' ;;
        success) color='\033[1;32m' ;;
    esac
    printf "${color}[%s] %s\033[0m\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$msg"
}

# X11 cleanup from entry.sh
rm -f /tmp/.X99-lock

# Switch to working directory
cd "${STEAMAPPDIR}" || {
    log error "Failed to change directory"
    exit 1
}

# Compile server parameters (merged from compile-parameters.sh)
mkdir -p "${STEAMAPPDIR}/logs"
logfile="${STEAMAPPDIR}/logs/$(date '+%Y-%m-%d_%H-%M-%S').log"

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

# Cleanup function
cleanup() {
    log action "Shutting down..."
    pkill -f CoreKeeperServer || true
    pkill Xvfb || true
    log success "Shutdown complete"
}

trap cleanup EXIT

# Start Xvfb and server
log action "Starting Xvfb"
Xvfb :99 -screen 0 1x1x24 -nolisten tcp &
sleep 1

export DISPLAY=:99
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${STEAMCMDDIR}/linux64/"

# Clean up any existing files
rm -f GameID.txt EXIT.txt

log action "Starting Core Keeper Server"
if [ "${ARCHITECTURE}" == "arm64" ]; then
    box64 ./CoreKeeperServer $params &
else
    ./CoreKeeperServer $params &
fi

# Monitor server
server_pid=$!
while kill -0 $server_pid 2>/dev/null; do
    sleep 5
done

# Wait for final EXIT.txt
while [ ! -f "EXIT.txt" ]; do
    sleep 5
done

log success "Server shutdown completed"