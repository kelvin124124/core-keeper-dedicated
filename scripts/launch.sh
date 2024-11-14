#!/bin/bash
set -e

cd "${STEAMAPPDIR}"

# Start Xvfb
Xvfb :99 -screen 0 1x1x24 -nolisten tcp &
xvfb_pid=$!
export DISPLAY=:99

# Download depot first
/opt/depotdownloader/DepotDownloader -app ${STEAMAPPID} -dir "${STEAMAPPDIR}" -validate
/opt/depotdownloader/DepotDownloader -app ${STEAMAPPID_TOOL} -dir "${STEAMAPPDIR}" -validate

chmod +x ./CoreKeeperServer
box64 ./CoreKeeperServer -batchmode -logfile CoreKeeperServerLog.txt ${SERVER_PARAMS[@]} &
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