#!/bin/bash
# This script compiles parameters from ENV variables into an array
# This should be run with source to make the params array available

# Function to add arguments to parameter array if value is not empty
# Usage: add_param <param_name> <param_value>
add_param() {
    local param_name="$1"
    local param_value="$2"

    if [ -n "$param_value" ]; then
        params+=("$param_name" "$param_value")
    fi
}

# Create log file path and ensure directory exists
mkdir -p "${STEAMAPPDIR}/logs"
logfile="${STEAMAPPDIR}/logs/$(date '+%Y-%m-%d_%H-%M-%S').log"
export logfile

# Initialize base parameters
params=(
    "-batchmode"
    "-extralog"
    "-logfile" "$logfile"
)

# Add optional parameters if they have values
add_param "-world"      "${WORLD_INDEX}"
add_param "-worldname"  "${WORLD_NAME}"
add_param "-worldseed"  "${WORLD_SEED}"
add_param "-worldmode"  "${WORLD_MODE}"
add_param "-gameid"     "${GAME_ID}"
add_param "-datapath"   "${DATA_PATH:-${STEAMAPPDATADIR}}"
add_param "-maxplayers" "${MAX_PLAYERS}"
add_param "-season"     "${SEASON}"
add_param "-ip"         "${SERVER_IP}"
add_param "-port"       "${SERVER_PORT}"

# Output parameters for debugging
if [[ "${DEBUG,,}" == "true" ]]; then
    echo "Server parameters: ${params[*]}"
fi