#!/bin/bash
set -e

# Set correct permissions as root
chown -R ${PUID}:${PGID} "${STEAMAPPDATADIR}"
chown -R ${PUID}:${PGID} "${STEAMAPPDIR}"
chown -R ${PUID}:${PGID} "${SCRIPTSDIR}"

# Switch to steam user and run the entry script
exec gosu steam bash "${SCRIPTSDIR}/entry.sh"