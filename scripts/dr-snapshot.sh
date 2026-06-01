#!/usr/bin/env bash
# ==============================================================================
# dr-snapshot.sh  (TRZ-440 — Part 1 of 3)
# ------------------------------------------------------------------------------
# Creates a Hostinger VPS snapshot via the public API. Intended to run from
# the VPS itself via cron.
#
# Retention policy is enforced by Hostinger — this script only creates one
# new snapshot per run. Hostinger keeps the last N depending on plan.
#
# Run from the VPS. Designed for cron:
#   # Nightly at 03:00 UTC
#   0 3 * * *  /usr/local/bin/dr-snapshot.sh >> /var/log/agent-team/dr-snapshot.log 2>&1
#
# Deps: curl, jq
# Env:
#   HOSTINGER_API_TOKEN   — PAT from Hostinger Panel (required)
#   HOSTINGER_VM_ID       — VPS numeric id from Hostinger Panel (required)
# ==============================================================================

set -euo pipefail

log() {
  printf '%s [dr-snapshot] %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*"
}

: "${HOSTINGER_API_TOKEN:?must be set (see Hostinger Panel → API)}"
: "${HOSTINGER_VM_ID:?must be set (VPS numeric id)}"

API="https://developers.hostinger.com"

log "creating snapshot for vm=$HOSTINGER_VM_ID"

resp=$(curl -sS -X POST \
  "${API}/api/vps/v1/virtual-machines/${HOSTINGER_VM_ID}/snapshots" \
  -H "Authorization: Bearer $HOSTINGER_API_TOKEN" \
  -H 'Content-Type: application/json' \
  -w '\n%{http_code}')

body=$(echo "$resp" | sed '$d')
code=$(echo "$resp" | tail -n1)

if [[ "$code" -ge 200 && "$code" -lt 300 ]]; then
  snap_id=$(echo "$body" | jq -r '.id // .snapshot.id // "unknown"')
  log "ok snapshot_id=$snap_id http=$code"
  exit 0
else
  log "FAIL http=$code body=$(echo "$body" | head -c 400)"
  exit 1
fi
