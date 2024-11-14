#!/bin/bash
# entry.sh
set -e

log() {
    printf '\033[1;36m[%s] %s\033[0m\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1"
}

setup_checks() {
    if [[ "$(id -u)" -eq 0 ]]; then
        if [[ "${PUID}" -ne 0 ]] && [[ "${PGID}" -ne 0 ]]; then
            usermod -o -u "${PUID}" "${USER}"
            groupmod -o -g "${PGID}" "${USER}"
            chown -R "${USER}:${USER}" "/home/${USER}"
        else
            echo "Error: Running as root is not supported. Fix PUID/PGID!" >&2
            exit 1
        fi
    fi

    for dir in "${STEAMAPPDIR}" "${STEAMAPPDATADIR}"; do
        if ! [ -w "${dir}" ]; then
            echo "Error: ${dir} is not writable" >&2
            exit 1
        fi
    done
}

log "Downloading Core Keeper Dedicated Server files..."
/opt/depotdownloader/DepotDownloader -app ${STEAMAPPID} -dir "${STEAMAPPDIR}" -validate

log "Downloading Core Keeper Dedicated Server tool files..."
/opt/depotdownloader/DepotDownloader -app ${STEAMAPPID_TOOL} -dir "${STEAMAPPDIR}" -validate

if [ ! -f "${STEAMAPPDIR}/CoreKeeperServer" ]; then
    log "CoreKeeperServer not found. Download may have failed."
    exit 1
fi

# Create steam directories and symlinks
mkdir -p ~/.steam/sdk32/ ~/.steam/sdk64/
ln -sf "${STEAMAPPDIR}/linux32/steamclient.so" ~/.steam/sdk32/steamclient.so
ln -sf "${STEAMAPPDIR}/linux64/steamclient.so" ~/.steam/sdk64/steamclient.so

setup_checks
exec bash "${SCRIPTSDIR}/launch.sh"