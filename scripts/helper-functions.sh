#!/bin/bash

# Terminal color definitions
declare -A COLORS=(
    ["RESET"]='\033[0m'
    ["WHITE"]='\033[0;37m'
    ["RED_BOLD"]='\033[1;31m'
    ["GREEN_BOLD"]='\033[1;32m'
    ["YELLOW_BOLD"]='\033[1;33m'
    ["CYAN_BOLD"]='\033[1;36m'
    ["BLUE"]='\033[0;34m'
)

# Generic logging function with timestamp
# Usage: Log "message" "${COLORS[COLOR_NAME]}"
Log() {
    local message="$1"
    local color="$2"
    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    printf "${color}[%s] %s${COLORS[RESET]}\n" "$timestamp" "$message"
}

# Specific logging functions for different message types
LogInfo() {
    Log "$1" "${COLORS[WHITE]}"
}

LogWarn() {
    Log "$1" "${COLORS[YELLOW_BOLD]}"
}

LogError() {
    Log "$1" "${COLORS[RED_BOLD]}" >&2
}

LogSuccess() {
    Log "$1" "${COLORS[GREEN_BOLD]}"
}

LogAction() {
    Log "$1" "${COLORS[CYAN_BOLD]}"
}

# Debug logging with conditional output
# Only prints if DEBUG environment variable is set to 'true' (case insensitive)
LogDebug() {
    if [[ "${DEBUG,,}" == "true" ]]; then
        Log "$1" "${COLORS[BLUE]}"
    fi
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if a variable is set and not empty
is_set() {
    [[ -n "${!1-}" ]]
}

# Function to validate a port number
is_valid_port() {
    local port=$1
    [[ "$port" =~ ^[0-9]+$ ]] && \
    (( port >= 1 && port <= 65535 ))
}

# Function to ensure a directory exists and is writable
ensure_directory() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir" || {
            LogError "Failed to create directory: $dir"
            return 1
        }
    fi
    if [[ ! -w "$dir" ]]; then
        LogError "Directory not writable: $dir"
        return 1
    fi
    return 0
}

# Export functions that need to be available to other scripts
export -f Log LogInfo LogWarn LogError LogSuccess LogAction LogDebug
export -f command_exists is_set is_valid_port ensure_directory