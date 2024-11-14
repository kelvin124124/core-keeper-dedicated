# launch.sh
#!/bin/bash
set -e

log() {
    printf '\033[1;36m[%s] %s\033[0m\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1"
}

cd "${STEAMAPPDIR}" || exit 1

# Build server parameters
params=""
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

log "Starting Core Keeper Server"
./_launch.sh $params

log "Server shutdown completed"