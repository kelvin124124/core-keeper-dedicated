#!/bin/bash
set -e

# Minimal logging function
log() {
    printf '\033[1;36m[%s] %s\033[0m\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1"
}

# Combined setup checks
setup_checks() {
    # Check for root/uid/gid issues
    if [[ "$(id -u)" -eq 0 ]]; then
        if [[ "${PUID}" -ne 0 ]] && [[ "${PGID}" -ne 0 ]]; then
            usermod -o -u "${PUID}" "${USER}"
            groupmod -o -g "${PGID}" "${USER}"
            chown -R "${USER}:${USER}" "${HOMEDIR}"
        else
            echo "Error: Running as root is not supported. Fix PUID/PGID!" >&2
            exit 1
        fi
    fi

    # Verify directory permissions
    for dir in "${STEAMAPPDIR}" "${STEAMAPPDATADIR}"; do
        if ! [ -w "${dir}" ]; then
            echo "Error: ${dir} is not writable" >&2
            exit 1
        fi
    done
}

# Run setup and launch
setup_checks

if [[ "$(id -u)" -eq 0 ]]; then
    log "Executing setup as user ${USER}"
    exec gosu "${USER}" bash "${SCRIPTSDIR}/setup.sh"
else
    log "Executing setup"
    exec bash "${SCRIPTSDIR}/setup.sh"
fi