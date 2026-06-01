#!/usr/bin/env bash
# ==============================================================================
# corpus-refresh-weekly.sh
# ------------------------------------------------------------------------------
# Runs on the Hostinger VPS (via cron/systemd) to refresh each OpenClaw
# instance's corpus + identity + shared context from the GitHub repo. This is
# what delivers on the "agents study the corpus weekly" contract -- fresh
# content lands in their workspaces automatically.
#
# For each of the 11 roles:
#   - Sync corpus/<role>/        -> /docker/openclaw-<role>/data/.openclaw/workspace/corpus/
#   - Sync TEAM.md, USER.md      -> /docker/openclaw-<role>/data/.openclaw/workspace/
#   - Sync identities/<role>.md  -> /docker/openclaw-<role>/data/.openclaw/workspace/IDENTITY.md
#   - Write .last-refresh receipt with ISO-8601 timestamp + git sha
#
# Missing instance directories are skipped with a warning. Only a failing
# clone/pull causes non-zero exit.
#
# Log rotation: keeps the last 12 weekly rotations alongside the active log.
# ==============================================================================

set -euo pipefail

# ------------------------------------------------------------------------------
# Config
# ------------------------------------------------------------------------------
REPO_URL="${AGENT_TEAM_REPO_URL:-https://github.com/rczamor/rz-agent-team.git}"
REPO_BRANCH="${AGENT_TEAM_REPO_BRANCH:-main}"
REPO_DIR="${AGENT_TEAM_REPO_DIR:-/var/agent-team-repo}"

LOG_DIR="${AGENT_TEAM_LOG_DIR:-/var/log/agent-team}"
LOG_FILE="${LOG_DIR}/corpus-refresh.log"
LOG_ROTATIONS="${AGENT_TEAM_LOG_ROTATIONS:-12}"

# Post-2026-04-18: researcher role retired (TRZ-356), split into 4 strategic
# routines that run on Anthropic's cloud. @growth (TRZ-367) added as the 11th
# role. Keep this list in sync with repo/TEAM.md and repo/identities/.
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

# ------------------------------------------------------------------------------
# Logging
# ------------------------------------------------------------------------------
mkdir -p "$LOG_DIR"

log() {
  printf '%s [corpus-refresh] %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*"
}

rotate_logs() {
  # Rotate weekly: log -> log.1 -> log.2 -> ... -> log.N, dropping oldest.
  [[ -f "$LOG_FILE" ]] || return 0
  local i
  for ((i=LOG_ROTATIONS-1; i>=1; i--)); do
    if [[ -f "${LOG_FILE}.${i}" ]]; then
      mv -f "${LOG_FILE}.${i}" "${LOG_FILE}.$((i+1))"
    fi
  done
  mv -f "$LOG_FILE" "${LOG_FILE}.1"
  # Drop anything past the retention window.
  find "$LOG_DIR" -maxdepth 1 -name 'corpus-refresh.log.*' \
    -type f | sort -V | head -n -"$LOG_ROTATIONS" | xargs -r rm -f
}

rotate_logs

# From here on, tee everything to the log.
exec > >(tee -a "$LOG_FILE") 2>&1

log "starting weekly corpus refresh"
log "repo=$REPO_URL branch=$REPO_BRANCH repo_dir=$REPO_DIR"

# ------------------------------------------------------------------------------
# Preflight
# ------------------------------------------------------------------------------
command -v git >/dev/null 2>&1 || { log "FATAL: git not installed"; exit 1; }
command -v rsync >/dev/null 2>&1 || { log "FATAL: rsync not installed"; exit 1; }

# ------------------------------------------------------------------------------
# Clone or pull repo
# ------------------------------------------------------------------------------
if [[ -d "${REPO_DIR}/.git" ]]; then
  log "updating existing clone at ${REPO_DIR}"
  if ! git -C "$REPO_DIR" fetch --quiet --prune origin; then
    log "FATAL: git fetch failed"
    exit 1
  fi
  if ! git -C "$REPO_DIR" reset --hard "origin/${REPO_BRANCH}"; then
    log "FATAL: git reset failed"
    exit 1
  fi
else
  log "cloning ${REPO_URL} -> ${REPO_DIR}"
  mkdir -p "$(dirname "$REPO_DIR")"
  if ! git clone --branch "$REPO_BRANCH" --depth 1 "$REPO_URL" "$REPO_DIR"; then
    log "FATAL: git clone failed"
    exit 1
  fi
fi

GIT_SHA="$(git -C "$REPO_DIR" rev-parse HEAD)"
log "repo sha=${GIT_SHA}"

# ------------------------------------------------------------------------------
# Sync each role
# ------------------------------------------------------------------------------
overall_status=0

for role in "${ROLES[@]}"; do
  remote_base="/docker/openclaw-${role}"
  workspace="${remote_base}/data/.openclaw/workspace"

  if [[ ! -d "$remote_base" ]]; then
    log "role=${role} status=skipped reason=instance-missing path=${remote_base}"
    continue
  fi

  mkdir -p "${workspace}/corpus"

  # TEAM.md
  if [[ -f "${REPO_DIR}/TEAM.md" ]]; then
    cp -f "${REPO_DIR}/TEAM.md" "${workspace}/TEAM.md"
  fi

  # USER.md
  if [[ -f "${REPO_DIR}/USER.md" ]]; then
    cp -f "${REPO_DIR}/USER.md" "${workspace}/USER.md"
  fi

  # IDENTITY.md
  identity_src="${REPO_DIR}/identities/${role}.md"
  if [[ -f "$identity_src" ]]; then
    cp -f "$identity_src" "${workspace}/IDENTITY.md"
  else
    log "role=${role} warn=no-identity-file path=${identity_src}"
  fi

  # corpus/<role>/
  corpus_src="${REPO_DIR}/corpus/${role}/"
  if [[ -d "$corpus_src" ]]; then
    if rsync -az --delete "$corpus_src" "${workspace}/corpus/"; then
      log "role=${role} step=corpus status=ok"
    else
      log "role=${role} step=corpus status=failed"
      overall_status=1
    fi
  else
    log "role=${role} step=corpus status=skipped reason=no-source"
  fi

  # Write receipt
  printf '%s\n%s\n' \
    "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    "$GIT_SHA" \
    > "${workspace}/corpus/.last-refresh"

  log "role=${role} step=refresh status=ok"
done

log "weekly corpus refresh complete (overall=${overall_status})"
exit "$overall_status"
