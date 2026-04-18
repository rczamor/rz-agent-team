#!/usr/bin/env bash
# ==============================================================================
# deploy-identities.sh
# ------------------------------------------------------------------------------
# Pushes identity + shared context to each OpenClaw instance on the Hostinger
# VPS (10 core execution agents + @growth if deployed). For each role:
#
#   TEAM.md                 -> /docker/openclaw-<role>/data/.openclaw/workspace/TEAM.md
#   USER.md                 -> /docker/openclaw-<role>/data/.openclaw/workspace/USER.md
#   identities/<role>.md    -> /docker/openclaw-<role>/data/.openclaw/workspace/IDENTITY.md
#   corpus/<role>/          -> /docker/openclaw-<role>/data/.openclaw/workspace/corpus/
#   skills/shared/          -> /docker/openclaw-<role>/data/.openclaw/skills/shared/
#   skills/conductor/       -> /docker/openclaw-conductor/data/.openclaw/skills/conductor/   (conductor only)
#
# Idempotent and tolerant: if an instance directory doesn't yet exist on the
# VPS, the role is skipped (warning, not error).
#
# Usage:
#   ./scripts/deploy-identities.sh
#   ./scripts/deploy-identities.sh --role ai-eng
#   ./scripts/deploy-identities.sh --dry-run
#   ./scripts/deploy-identities.sh --no-restart
#
# Env:
#   REPO_ROOT   Override repo root (defaults to two dirs up from this script).
# ==============================================================================

set -euo pipefail

# ------------------------------------------------------------------------------
# Resolve paths
# ------------------------------------------------------------------------------
SCRIPT_PATH="${BASH_SOURCE[0]}"
SCRIPT_DIR="$(cd "$(dirname "${SCRIPT_PATH}")" && pwd)"
REPO_ROOT="${REPO_ROOT:-$(cd "${SCRIPT_DIR}/.." && pwd)}"
# connect.sh lives two directories up from this script (outer agent-team dir)
CONNECT_SH="${CONNECT_SH:-$(cd "${REPO_ROOT}/.." && pwd)/connect.sh}"

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

# Map OpenClaw instance slug (VPS dir /docker/openclaw-<slug>/) to the identity
# file stem (identities/<stem>.md). Needed because a few instance names are
# abbreviated relative to the identity filenames.
declare -A IDENTITY_FILE=(
  [conductor]=conductor
  [pm]=pm-lite
  [designer]=designer
  [backend-eng]=backend-eng
  [data-eng]=data-eng
  [ai-eng]=ai-eng
  [ui-eng]=ui-eng
  [qa-eng]=qa-eng
  [devops-eng]=devops-eng
  [tech-writer]=tech-writer
  [growth]=growth
)

# Note on retired roles: "researcher" was split into 4 Claude Code Routines
# (rz-architect, rz-analyst, rz-ux-researcher, rz-ai-researcher) on 2026-04-17
# and the openclaw-researcher instance was retired in CAR-356. Do not re-add.

DRY_RUN=0
NO_RESTART=0
ROLE_FILTER=""

# ------------------------------------------------------------------------------
# Arg parsing
# ------------------------------------------------------------------------------
usage() {
  cat <<EOF
Usage: $(basename "$0") [--dry-run] [--no-restart] [--role <role>]

Options:
  --dry-run      Print actions without executing them.
  --no-restart   Skip 'docker compose restart' after sync.
  --role ROLE    Deploy to just one role (one of: ${ROLES[*]}).
  -h, --help     Show this help.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --no-restart) NO_RESTART=1; shift ;;
    --role)
      [[ $# -ge 2 ]] || { echo "error: --role requires an argument" >&2; exit 2; }
      ROLE_FILTER="$2"
      shift 2
      ;;
    -h|--help) usage; exit 0 ;;
    *) echo "error: unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

# ------------------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------------------
log() {
  # log role step status [extra]
  local role="$1" step="$2" status="$3" extra="${4:-}"
  if [[ -n "$extra" ]]; then
    printf '[deploy-identities] role=%s step=%s status=%s %s\n' "$role" "$step" "$status" "$extra"
  else
    printf '[deploy-identities] role=%s step=%s status=%s\n' "$role" "$step" "$status"
  fi
}

die() {
  echo "error: $*" >&2
  exit 1
}

# Runs a command on the remote VPS via connect.sh. Returns the command's exit code.
remote() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf '[dry-run] remote: %s\n' "$*"
    return 0
  fi
  "$CONNECT_SH" "$*"
}

# rsync a local path to the VPS. Uses ssh -i via the .env.local connection info.
# We shell out through a small wrapper so rsync uses the same key / user / port.
# Arg 1: local path, Arg 2: remote path.
#
# In --dry-run mode we print what would be rsynced and return success WITHOUT
# opening an SSH connection (the mock test harness has no real VPS to reach,
# and real dry-run users want fast feedback, not a 30s timeout).
remote_rsync() {
  local src="$1" dest="$2"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] rsync -az --delete ${src} -> VPS:${dest}"
    return 0
  fi

  # Load connection info from .env.local (same file connect.sh reads).
  local env_file
  env_file="$(cd "$(dirname "$CONNECT_SH")" && pwd)/.env.local"
  [[ -f "$env_file" ]] || die "missing $env_file (needed for rsync connection)"
  set -a
  # shellcheck source=/dev/null
  . "$env_file"
  set +a

  local key_path="${HOSTINGER_SSH_KEY:-}"
  key_path="$(eval echo "$key_path")"
  local host="${HOSTINGER_HOST:?HOSTINGER_HOST not set}"
  local user="${HOSTINGER_USER:?HOSTINGER_USER not set}"
  local port="${HOSTINGER_PORT:-22}"

  rsync -az --delete \
    -e "ssh -i ${key_path} -p ${port} -o ServerAliveInterval=30 -o StrictHostKeyChecking=accept-new" \
    "$src" "${user}@${host}:${dest}"
}

# Check that a remote directory exists. Returns 0 if yes, non-zero if no.
remote_dir_exists() {
  local path="$1"
  # In dry-run we optimistically assume yes so we can show what would happen.
  if [[ "$DRY_RUN" -eq 1 ]]; then
    return 0
  fi
  "$CONNECT_SH" "test -d '$path'" >/dev/null 2>&1
}

# ------------------------------------------------------------------------------
# Preflight
# ------------------------------------------------------------------------------
[[ -x "$CONNECT_SH" ]] || die "connect.sh not found or not executable at: $CONNECT_SH"
[[ -f "$REPO_ROOT/TEAM.md" ]] || die "missing TEAM.md at $REPO_ROOT/TEAM.md"
[[ -f "$REPO_ROOT/USER.md" ]] || die "missing USER.md at $REPO_ROOT/USER.md"
command -v rsync >/dev/null 2>&1 || die "rsync not found on PATH"

if [[ -n "$ROLE_FILTER" ]]; then
  local_found=0
  for r in "${ROLES[@]}"; do
    [[ "$r" == "$ROLE_FILTER" ]] && local_found=1
  done
  [[ "$local_found" -eq 1 ]] || die "--role '$ROLE_FILTER' not in ${ROLES[*]}"
fi

# ------------------------------------------------------------------------------
# Main loop
# ------------------------------------------------------------------------------
overall_status=0

for role in "${ROLES[@]}"; do
  if [[ -n "$ROLE_FILTER" && "$ROLE_FILTER" != "$role" ]]; then
    continue
  fi

  remote_base="/docker/openclaw-${role}"
  workspace="${remote_base}/data/.openclaw/workspace"
  skills_dir="${remote_base}/data/.openclaw/skills"

  # Check instance exists on VPS -- tolerate missing (target instances may not
  # have been bootstrapped yet; openclaw-growth is optional per CAR-367).
  if ! remote_dir_exists "$remote_base"; then
    log "$role" "instance-check" "skipped" "(no ${remote_base} on VPS)"
    continue
  fi
  log "$role" "instance-check" "ok"

  # Resolve identity file stem (handles pm -> pm-lite.md).
  identity_file="${IDENTITY_FILE[$role]:-$role}"

  # --- TEAM.md --------------------------------------------------------------
  if remote_rsync "${REPO_ROOT}/TEAM.md" "${workspace}/TEAM.md"; then
    log "$role" "team-md" "ok"
  else
    log "$role" "team-md" "failed"
    overall_status=1
    continue
  fi

  # --- USER.md --------------------------------------------------------------
  if remote_rsync "${REPO_ROOT}/USER.md" "${workspace}/USER.md"; then
    log "$role" "user-md" "ok"
  else
    log "$role" "user-md" "failed"
    overall_status=1
    continue
  fi

  # --- IDENTITY.md ----------------------------------------------------------
  identity_src="${REPO_ROOT}/identities/${identity_file}.md"
  if [[ ! -f "$identity_src" ]]; then
    log "$role" "identity-md" "skipped" "(no ${identity_src})"
  elif remote_rsync "$identity_src" "${workspace}/IDENTITY.md"; then
    log "$role" "identity-md" "ok"
  else
    log "$role" "identity-md" "failed"
    overall_status=1
  fi

  # --- corpus/<role>/ -------------------------------------------------------
  corpus_src="${REPO_ROOT}/corpus/${role}/"
  if [[ ! -d "$corpus_src" ]]; then
    log "$role" "corpus" "skipped" "(no ${corpus_src})"
  else
    # Ensure remote target exists (ok if it already does).
    remote "mkdir -p '${workspace}/corpus'" >/dev/null || true
    if remote_rsync "$corpus_src" "${workspace}/corpus/"; then
      log "$role" "corpus" "ok"
    else
      log "$role" "corpus" "failed"
      overall_status=1
    fi
  fi

  # --- skills/shared/ -------------------------------------------------------
  shared_src="${REPO_ROOT}/skills/shared/"
  if [[ ! -d "$shared_src" ]]; then
    log "$role" "skills-shared" "skipped" "(no ${shared_src})"
  else
    remote "mkdir -p '${skills_dir}/shared'" >/dev/null || true
    if remote_rsync "$shared_src" "${skills_dir}/shared/"; then
      log "$role" "skills-shared" "ok"
    else
      log "$role" "skills-shared" "failed"
      overall_status=1
    fi
  fi

  # --- skills/conductor/ (conductor only) -----------------------------------
  if [[ "$role" == "conductor" ]]; then
    conductor_src="${REPO_ROOT}/skills/conductor/"
    if [[ ! -d "$conductor_src" ]]; then
      log "$role" "skills-conductor" "skipped" "(no ${conductor_src})"
    else
      remote "mkdir -p '${skills_dir}/conductor'" >/dev/null || true
      if remote_rsync "$conductor_src" "${skills_dir}/conductor/"; then
        log "$role" "skills-conductor" "ok"
      else
        log "$role" "skills-conductor" "failed"
        overall_status=1
      fi
    fi
  fi

  # --- Restart container ----------------------------------------------------
  if [[ "$NO_RESTART" -eq 1 ]]; then
    log "$role" "restart" "skipped" "(--no-restart)"
    continue
  fi

  compose_file="${remote_base}/docker-compose.yml"
  if ! remote "test -f '$compose_file'"; then
    log "$role" "restart" "skipped" "(no $compose_file)"
    continue
  fi

  if remote "docker compose -f '$compose_file' restart"; then
    log "$role" "restart" "ok"
  else
    log "$role" "restart" "failed"
    overall_status=1
  fi
done

exit "$overall_status"
