#!/bin/bash
set -e

cd "${STEAMAPPDIR}"

# Start Xvfb
Xvfb :99 -screen 0 1x1x24 -nolisten tcp &
xvfb_pid=$!
export DISPLAY=:99

# Setup params
logfile="CoreKeeperServerLog.txt"

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

chmod +x ./CoreKeeperServer
box64 ./CoreKeeperServer $params &
ck_pid=$!

cleanup() {
    kill $xvfb_pid $ck_pid 2>/dev/null
}
trap cleanup EXIT

# Wait for log file to be created
while [ ! -f CoreKeeperServerLog.txt ]; do
    sleep 1
done

exec tail -f CoreKeeperServerLog.txt