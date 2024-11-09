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

# Quick validation of critical env vars
if [[ -z "$STEAMAPPID" ]] || [[ -z "$STEAMAPPID_TOOL" ]] || [[ -z "$STEAMAPPDIR" ]] || [[ -z "$STEAMCMDDIR" ]]; then
    log error "Missing required environment variables"
    exit 1
fi

# Create necessary directories
log action "Creating directories"
mkdir -p "${STEAMAPPDIR}" "${STEAMAPPDATADIR}" "${MODSDIR}"

# Run SteamCMD update
log action "Running SteamCMD update"
"${STEAMCMDDIR}/steamcmd.sh" \
    +force_install_dir "${STEAMAPPDIR}" \
    +login anonymous \
    +app_update "${STEAMAPPID}" validate \
    +app_update "${STEAMAPPID_TOOL}" validate \
    ${STEAMCMD_UPDATE_ARGS} \
    +quit || {
    log error "SteamCMD update failed"
    exit 1
}

# Verify and prepare server binary
if [ ! -f "${STEAMAPPDIR}/CoreKeeperServer" ]; then
    log error "Server binary not found after installation"
    exit 1
fi

chmod +x "${STEAMAPPDIR}/CoreKeeperServer"
log success "Server setup completed"

# Launch the server
log action "Starting server"
exec bash "${SCRIPTSDIR}/launch.sh"