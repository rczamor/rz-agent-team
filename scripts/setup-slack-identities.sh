#!/usr/bin/env bash
# ==============================================================================
# setup-slack-identities.sh
# ------------------------------------------------------------------------------
# One-off helper for TRZ-322. Wires the 11 agent bots into the 9 hybrid
# channels and smoke-tests each.
#
# What this script does NOT do:
#   * It does NOT create the 9 channels. Channel creation requires the human
#     decision of public vs. private + who to invite. Create them manually in
#     the Slack UI first:
#       #agent-team
#       #agent-sia
#       #agent-website
#       #agent-recipe-remix
#       #agent-ploppy
#       #agent-blocade
#       #agent-ascend
#       #agent-trend-analyzer
#       #agent-ai-onboarding
#   * It does NOT create the 11 Slack apps. Each bot identity needs its own
#     app with a unique name + avatar. Create them at api.slack.com/apps with
#     Bot Token Scopes: chat:write, channels:join, channels:read.
#   * It does NOT set display names/avatars. Those are Slack-app-level config.
#
# What this script DOES:
#   1. For each of 11 bot tokens, resolves the 9 channel IDs.
#   2. Joins each bot to each channel via conversations.join.
#   3. Posts one STATUS message per bot to #agent-team as a smoke test.
#   4. Reports a success/failure grid.
#
# Usage:
#   # Populate all 11 token env vars first (e.g. from deploy/.env):
#   export SLACK_BOT_TOKEN_CONDUCTOR=xoxb-...
#   export SLACK_BOT_TOKEN_PM=xoxb-...
#   ...
#   bash scripts/setup-slack-identities.sh              # full run
#   bash scripts/setup-slack-identities.sh --dry-run    # resolve + report only
#   bash scripts/setup-slack-identities.sh --skip-smoke # join only, no message
#
# Requires: curl, jq.
# ==============================================================================

set -euo pipefail

# ------------------------------------------------------------------------------
# Config
# ------------------------------------------------------------------------------
ROLES=(
  conductor
  pm
  designer
  backend-eng
  data-eng
  ai-eng
  ui-eng
  qa-eng
  devops-eng
  tech-writer
  growth
)

CHANNELS=(
  agent-team
  agent-sia
  agent-website
  agent-recipe-remix
  agent-ploppy
  agent-blocade
  agent-ascend
  agent-trend-analyzer
  agent-ai-onboarding
)

SLACK_API="https://slack.com/api"

DRY_RUN=0
SKIP_SMOKE=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)    DRY_RUN=1; shift ;;
    --skip-smoke) SKIP_SMOKE=1; shift ;;
    -h|--help)
      sed -n '2,40p' "$0"
      exit 0
      ;;
    *) echo "error: unknown arg: $1" >&2; exit 2 ;;
  esac
done

# ------------------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------------------
# Map role -> env var name holding its bot token.
token_var() {
  local role="$1"
  echo "SLACK_BOT_TOKEN_$(echo "$role" | tr '[:lower:]-' '[:upper:]_')"
}

# GET / POST wrapper. Echoes response body to stdout; returns non-zero on API error.
slack_call() {
  local method="$1"  # GET or POST
  local endpoint="$2"
  local token="$3"
  shift 3
  local response
  if [[ "$method" == "GET" ]]; then
    response=$(curl -sS -H "Authorization: Bearer ${token}" \
      "${SLACK_API}/${endpoint}?$*")
  else
    response=$(curl -sS -H "Authorization: Bearer ${token}" \
      -H "Content-type: application/json; charset=utf-8" \
      -d "$1" \
      "${SLACK_API}/${endpoint}")
  fi
  echo "$response"
  local ok
  ok=$(echo "$response" | jq -r '.ok // false')
  if [[ "$ok" != "true" ]]; then
    local err
    err=$(echo "$response" | jq -r '.error // "unknown"')
    echo "  [slack-api-error] ${endpoint}: ${err}" >&2
    return 1
  fi
  return 0
}

# Preflight: every role must have a token set.
preflight() {
  local missing=0
  for role in "${ROLES[@]}"; do
    local var
    var="$(token_var "$role")"
    if [[ -z "${!var:-}" ]]; then
      echo "[preflight] missing env var: ${var}" >&2
      missing=$((missing + 1))
    fi
  done
  [[ "$missing" -eq 0 ]] || { echo "[preflight] ${missing} tokens missing — aborting." >&2; exit 1; }
  command -v curl >/dev/null || { echo "curl required" >&2; exit 1; }
  command -v jq   >/dev/null || { echo "jq required"   >&2; exit 1; }
}

# Resolve all 9 channel names to IDs using one token. Echoes TSV: name<TAB>id.
resolve_channel_ids() {
  local token="$1"
  local cursor="" id
  local all_json="[]"
  while :; do
    local args="limit=200&types=public_channel"
    [[ -n "$cursor" ]] && args="${args}&cursor=${cursor}"
    local page
    page=$(slack_call GET "conversations.list" "$token" "$args") \
      || { echo "[resolve] conversations.list failed" >&2; return 1; }
    all_json=$(jq -s '.[0] + .[1].channels' <(echo "$all_json") <(echo "$page"))
    cursor=$(echo "$page" | jq -r '.response_metadata.next_cursor // ""')
    [[ -z "$cursor" ]] && break
  done
  for ch in "${CHANNELS[@]}"; do
    id=$(echo "$all_json" | jq -r --arg n "$ch" '.[] | select(.name == $n) | .id' | head -1)
    if [[ -z "$id" ]]; then
      echo "[resolve] channel not found: #${ch} — create it in Slack before re-running" >&2
      return 1
    fi
    printf "%s\t%s\n" "$ch" "$id"
  done
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
preflight

# Step 1 — resolve channel IDs via conductor's token (any token works, conductor is convention).
CONDUCTOR_TOKEN="$(eval echo \$"$(token_var conductor)")"
echo "[step 1] resolving 9 channel IDs"
CHANNEL_MAP=$(resolve_channel_ids "$CONDUCTOR_TOKEN")
echo "$CHANNEL_MAP" | awk -F'\t' '{ printf "  %-22s %s\n", "#"$1, $2 }'

if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "[dry-run] stopping before any writes."
  exit 0
fi

# Step 2 — join each bot to each channel. Results stored as TSV in a tempfile
# (bash 3.2 compatible — no associative arrays).
echo "[step 2] joining 11 bots × 9 channels = 99 joins"
RESULTS_FILE="$(mktemp)"
trap 'rm -f "$RESULTS_FILE"' EXIT

for role in "${ROLES[@]}"; do
  var="$(token_var "$role")"
  token="${!var}"
  while IFS=$'\t' read -r ch_name ch_id; do
    [[ -z "$ch_id" ]] && continue
    if slack_call POST "conversations.join" "$token" "{\"channel\":\"${ch_id}\"}" >/dev/null; then
      printf '%s\t%s\tok\n'   "$role" "$ch_name" >> "$RESULTS_FILE"
    else
      printf '%s\t%s\tFAIL\n' "$role" "$ch_name" >> "$RESULTS_FILE"
    fi
  done <<< "$CHANNEL_MAP"
done

# Step 3 — smoke test: each bot posts a STATUS to #agent-team.
if [[ "$SKIP_SMOKE" -eq 0 ]]; then
  echo "[step 3] smoke test — STATUS from each bot to #agent-team"
  AGENT_TEAM_ID=$(echo "$CHANNEL_MAP" | awk -F'\t' '$1=="agent-team"{print $2; exit}')
  for role in "${ROLES[@]}"; do
    var="$(token_var "$role")"
    token="${!var}"
    body=$(jq -nc --arg ch "$AGENT_TEAM_ID" --arg t "STATUS: @${role} bot online — TRZ-322 setup smoke test." \
      '{channel:$ch, text:$t}')
    if slack_call POST "chat.postMessage" "$token" "$body" >/dev/null; then
      printf '%s\tsmoke\tok\n'   "$role" >> "$RESULTS_FILE"
    else
      printf '%s\tsmoke\tFAIL\n' "$role" >> "$RESULTS_FILE"
    fi
  done
fi

# ------------------------------------------------------------------------------
# Report
# ------------------------------------------------------------------------------
lookup() {
  awk -v r="$1" -v k="$2" -F'\t' '$1==r && $2==k {print $3; exit}' "$RESULTS_FILE"
}

echo ""
echo "[report] results grid:"
printf "%-14s" "role"
for ch in "${CHANNELS[@]}"; do printf " %-5s" "${ch:6:5}"; done
printf " %-5s\n" "smoke"
for role in "${ROLES[@]}"; do
  printf "%-14s" "$role"
  for ch in "${CHANNELS[@]}"; do
    result="$(lookup "$role" "$ch")"
    printf " %-5s" "${result:--}"
  done
  result="$(lookup "$role" "smoke")"
  printf " %-5s\n" "${result:--}"
done

fail_count=$(awk -F'\t' '$3=="FAIL"{n++} END{print n+0}' "$RESULTS_FILE")
echo ""
if [[ "$fail_count" -eq 0 ]]; then
  echo "[done] all operations succeeded."
  exit 0
else
  echo "[done] ${fail_count} operation(s) failed — see errors above." >&2
  exit 1
fi
