#!/bin/bash
set -e

# Source required scripts
source "${SCRIPTSDIR}/helper-functions.sh"

# Switch to working directory
cd "${STEAMAPPDIR}" || {
    LogError "Failed to change to directory: ${STEAMAPPDIR}"
    exit 1
}

# Process management variables
declare -g ckpid=""
declare -g xvfbpid=""

# Cleanup function for graceful shutdown
cleanup() {
    LogAction "Initiating shutdown sequence..."
    
    if [[ -n "${ckpid}" ]]; then
        LogAction "Stopping Core Keeper Server (PID: ${ckpid})"
        kill -TERM "${ckpid}" 2>/dev/null || true
        wait "${ckpid}" 2>/dev/null || true
    fi
    
    if [[ -n "${xvfbpid}" ]]; then
        LogAction "Stopping Xvfb (PID: ${xvfbpid})"
        kill -TERM "${xvfbpid}" 2>/dev/null || true
        wait "${xvfbpid}" 2>/dev/null || true
    fi
    
    LogSuccess "Shutdown complete"
}

# Set up trap for cleanup
trap cleanup EXIT TERM INT

# Clean up any existing GameID file
if [ -f "GameID.txt" ]; then
    rm "GameID.txt"
fi

# Compile server parameters
source "${SCRIPTSDIR}/compile-parameters.sh"

# Start Xvfb
LogAction "Starting Xvfb"
Xvfb :99 -screen 0 1x1x24 -nolisten tcp &
xvfbpid="$!"

# Wait for Xvfb to be ready
sleep 1

# Verify Xvfb is running
if ! kill -0 "${xvfbpid}" 2>/dev/null; then
    LogError "Failed to start Xvfb"
    exit 1
fi

LogSuccess "Xvfb started successfully"

# Start Core Keeper Server
LogAction "Starting Core Keeper Server"
export DISPLAY=:99
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${STEAMCMDDIR}/linux64/"

if [ "${ARCHITECTURE}" == "arm64" ]; then
    box64 ./CoreKeeperServer "${params[@]}" &
else
    ./CoreKeeperServer "${params[@]}" &
fi

ckpid="$!"

LogSuccess "Server started with PID: ${ckpid}"
LogDebug "Launch parameters: ${params[*]}"

# Monitor server process
while kill -0 "${ckpid}" 2>/dev/null; do
    sleep 5
done

# Clean up EXIT.txt file
if [ -f "EXIT.txt" ]; then
    rm "EXIT.txt"
fi

# Wait for EXIT.txt to be created (backup exit condition)
LogInfo "Server process ended, waiting for EXIT.txt"
while [ ! -f "EXIT.txt" ]; do
    sleep 5
done

LogSuccess "Server shutdown completed successfully"