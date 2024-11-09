#!/bin/bash
set -e

# Source helper functions for logging
source "${SCRIPTSDIR}/helper-functions.sh"

# Check if running as root and handle UID/GID updates
check_and_update_user() {
    if [[ "$(id -u)" -eq 0 ]] && [[ "$(id -g)" -eq 0 ]]; then
        if [[ "${PUID}" -ne 0 ]] && [[ "${PGID}" -ne 0 ]]; then
            LogAction "Updating UID/GID for user ${USER}"
            usermod -o -u "${PUID}" "${USER}"
            groupmod -o -g "${PGID}" "${USER}"
            chown -R "${USER}:${USER}" "${HOMEDIR}"
            return 0
        else
            LogError "Running as root is not supported, please fix your PUID and PGID!"
            return 1
        fi
    elif [[ "$(id -u)" -eq 0 ]] || [[ "$(id -g)" -eq 0 ]]; then
        LogError "Running as root is not supported, please fix your user!"
        return 1
    fi
    return 0
}

# Check directory permissions
check_directories() {
    local dirs=("${STEAMAPPDIR}" "${STEAMAPPDATADIR}")
    
    for dir in "${dirs[@]}"; do
        if ! [ -w "${dir}" ]; then
            LogError "${dir} is not writable"
            return 1
        fi
    done
    return 0
}

# Cleanup any leftover X11 locks
cleanup_x11() {
    if [ -f "/tmp/.X99-lock" ]; then
        LogAction "Removing stale X11 lock file"
        rm "/tmp/.X99-lock"
    fi
}

# Main execution
main() {
    # Perform all checks
    check_and_update_user || exit 1
    check_directories || exit 1
    cleanup_x11

    # Execute setup script with appropriate user
    if [[ "$(id -u)" -eq 0 ]]; then
        LogAction "Executing setup as user ${USER}"
        exec gosu "${USER}" bash "${SCRIPTSDIR}/setup.sh"
    else
        LogAction "Executing setup"
        exec bash "${SCRIPTSDIR}/setup.sh"
    fi
}

main