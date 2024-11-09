#!/bin/bash
set -e

# Source helper functions
source "${SCRIPTSDIR}/helper-functions.sh"

# Ensure required directories exist
ensure_directories() {
    local dirs=(
        "${STEAMAPPDIR}"
        "${STEAMAPPDATADIR}"
        "${MODSDIR}"
    )
    
    for dir in "${dirs[@]}"; do
        LogAction "Creating directory: ${dir}"
        ensure_directory "${dir}" || {
            LogError "Failed to create/verify directory: ${dir}"
            return 1
        }
    done
    return 0
}

# Validate required environment variables
validate_environment() {
    local required_vars=(
        "STEAMAPPID"
        "STEAMAPPID_TOOL"
        "STEAMAPPDIR"
        "STEAMCMDDIR"
    )
    
    for var in "${required_vars[@]}"; do
        if ! is_set "${var}"; then
            LogError "Required environment variable not set: ${var}"
            return 1
        fi
    done
    return 0
}

# Setup SteamCMD arguments
setup_steamcmd_args() {
    local -a args=(
        "+force_install_dir" "${STEAMAPPDIR}"
        "+login" "anonymous"
        "+app_update" "${STEAMAPPID}" "validate"
        "+app_update" "${STEAMAPPID_TOOL}" "validate"
    )
    
    # Add custom update args if specified
    if [ -n "${STEAMCMD_UPDATE_ARGS}" ]; then
        LogDebug "Adding custom update arguments: ${STEAMCMD_UPDATE_ARGS}"
        # Split string into array while preserving quoted strings
        readarray -t custom_args <<< "${STEAMCMD_UPDATE_ARGS}"
        args+=("${custom_args[@]}")
    fi
    
    # Add quit command
    args+=("+quit")
    
    echo "${args[@]}"
}

# Run SteamCMD install/update
run_steamcmd() {
    local args=("$@")
    local steamcmd_path="${STEAMCMDDIR}/steamcmd.sh"
    
    if [ ! -x "${steamcmd_path}" ]; then
        LogError "SteamCMD not found or not executable: ${steamcmd_path}"
        return 1
    }
    
    LogAction "Running SteamCMD update..."
    LogDebug "SteamCMD arguments: ${args[*]}"
    
    if ! bash "${steamcmd_path}" "${args[@]}"; then
        LogError "SteamCMD update failed"
        return 1
    }
    
    LogSuccess "SteamCMD update completed successfully"
    return 0
}

# Main execution function
main() {
    LogAction "Starting server setup..."
    
    # Validate environment
    validate_environment || exit 1
    
    # Ensure directories exist
    ensure_directories || exit 1
    
    # Get SteamCMD arguments
    local steam_args
    steam_args=($(setup_steamcmd_args))
    
    # Run SteamCMD update
    run_steamcmd "${steam_args[@]}" || exit 1
    
    # Verify server files exist
    if [ ! -f "${STEAMAPPDIR}/CoreKeeperServer" ]; then
        LogError "Server binary not found after installation"
        exit 1
    fi
    
    # Make server binary executable
    chmod +x "${STEAMAPPDIR}/CoreKeeperServer" || {
        LogError "Failed to make server binary executable"
        exit 1
    }
    
    LogSuccess "Server setup completed successfully"
    
    # Launch the server
    LogAction "Starting server..."
    exec bash "${SCRIPTSDIR}/launch.sh"
}

main