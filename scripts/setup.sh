#!/bin/bash
set -e

chown -R ${PUID}:${PGID} "${STEAMAPPDATADIR}" "${STEAMAPPDIR}" "${SCRIPTSDIR}"
exec gosu steam bash "${SCRIPTSDIR}/entry.sh"