#!/bin/bash
set -e

log() {
    printf '\033[1;36m[%s] %s\033[0m\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1"
}

# Check directory permissions
for dir in "${STEAMAPPDIR}" "${STEAMAPPDATADIR}"; do
    if ! [ -w "${dir}" ]; then
        echo "Error: ${dir} is not writable. Current permissions: $(ls -ld ${dir})" >&2
        while true; do sleep 3600; done
    fi
done

# Download server files
log "Downloading Core Keeper Dedicated Server files..."
/opt/depotdownloader/DepotDownloader -app ${STEAMAPPID} -dir "${STEAMAPPDIR}" -validate

log "Downloading Core Keeper Dedicated Server tool files..."
/opt/depotdownloader/DepotDownloader -app ${STEAMAPPID_TOOL} -dir "${STEAMAPPDIR}" -validate

if [ ! -f "${STEAMAPPDIR}/CoreKeeperServer" ]; then
    log "CoreKeeperServer not found. Download may have failed."
    while true; do sleep 3600; done
fi

chmod +x "${STEAMAPPDIR}"/*.sh "${STEAMAPPDIR}"/CoreKeeperServer

mkdir -p ~/.steam/sdk{32,64}/
ln -sf "${STEAMAPPDIR}/linux32/steamclient.so" ~/.steam/sdk32/steamclient.so
ln -sf "${STEAMAPPDIR}/linux64/steamclient.so" ~/.steam/sdk64/steamclient.so

exec bash "${SCRIPTSDIR}/launch.sh"