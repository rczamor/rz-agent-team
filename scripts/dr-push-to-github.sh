#!/usr/bin/env bash
# ==============================================================================
# dr-push-to-github.sh  (TRZ-440 — private-repo offsite backup)
# ------------------------------------------------------------------------------
# Runs on the VPS. Once a week:
#   1. Bundle the irreplaceable tiny bits (env files + pg_dump of agent_memory)
#   2. Encrypt with gpg (AES-256, passphrase from /root/.agent-team-dr/passphrase)
#   3. Commit + push to a PRIVATE GitHub repo (rczamor/rz-agent-team-dr-backups)
#
# Why private GitHub:
#   - GitHub persists independently of Hostinger (true offsite)
#   - Versioned history + you already control access
#   - Durable if the laptop dies (superior to a laptop-resident backup)
#   - Free within 1 GB for this kind of tiny blob
#
# Why this runs on the VPS and NOT as a Claude Code Routine:
#   Claude Code Routines execute on Anthropic's cloud. They can reach GitHub
#   (via the GitHub connector) but CANNOT SSH into the VPS. Since the backup
#   source IS the VPS state, the script has to run where the data lives.
#
# Optional Claude involvement: a separate weekly Claude Code Routine can use
# its GitHub connector to CHECK that a recent backup exists in the private
# repo, and alert on staleness. See the "Monitoring via Claude Code Routine"
# section at the bottom of this file.
#
# Deps on VPS: git, tar, gzip, gpg, docker (for pg_dump), ssh client
# Secrets (mode 600, not in git):
#   /root/.agent-team-dr/passphrase   — backup encryption passphrase
#   /root/.agent-team-dr/ssh-key      — GitHub deploy-key private half (ed25519),
#                                       registered as a read/write deploy key
#                                       on the destination repo. Scoped to that
#                                       repo only — least-privilege vs. a PAT.
#
# Schedule:
#   /etc/cron.d/agent-team-dr  →  weekly Sundays 03:30 UTC
# ==============================================================================

set -euo pipefail

# ---- Config ------------------------------------------------------------------
# SSH URL, consumed with GIT_SSH_COMMAND pointing at the deploy key below.
BACKUP_REPO="${BACKUP_REPO:-git@github.com:rczamor/rz-agent-team-dr-backups.git}"
BACKUP_BRANCH="${BACKUP_BRANCH:-main}"
RETAIN_WEEKS="${DR_RETAIN_WEEKS:-12}"

DR_DIR="${DR_DIR:-/root/.agent-team-dr}"
PASS_FILE="$DR_DIR/passphrase"
SSH_KEY_FILE="$DR_DIR/ssh-key"

log() {
  printf '%s [dr-push] %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*"
}

# ---- Preflight ---------------------------------------------------------------
[[ -f "$PASS_FILE"    ]] || { log "FATAL: $PASS_FILE missing (gpg passphrase)";         exit 1; }
[[ -f "$SSH_KEY_FILE" ]] || { log "FATAL: $SSH_KEY_FILE missing (deploy-key private)";  exit 1; }
[[ "$(stat -c %a "$PASS_FILE")" == "600" ]]    || { log "FATAL: $PASS_FILE must be chmod 600";    exit 1; }
[[ "$(stat -c %a "$SSH_KEY_FILE")" == "600" ]] || { log "FATAL: $SSH_KEY_FILE must be chmod 600"; exit 1; }

PASS=$(cat "$PASS_FILE")

# Use the deploy key for all git operations in this script. Pinning
# StrictHostKeyChecking=accept-new avoids interactive prompts on first run
# while still protecting against later MITM.
export GIT_SSH_COMMAND="ssh -i $SSH_KEY_FILE -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new"

command -v git >/dev/null || { log "FATAL: git missing"; exit 1; }
command -v gpg >/dev/null || { log "FATAL: gpg missing"; exit 1; }
command -v tar >/dev/null || { log "FATAL: tar missing"; exit 1; }
docker ps --format '{{.Names}}' | grep -qx agent-memory-postgres || {
  log "FATAL: agent-memory-postgres not running"; exit 1
}

STAGING=$(mktemp -d)
trap 'rm -rf "$STAGING"' EXIT

STAMP=$(date -u +%Y-%m-%d)
YEAR=$(date -u +%Y)

log "bundle -> encrypt -> push (stamp=$STAMP)"

# ---- Stage payload -----------------------------------------------------------
mkdir -p "$STAGING/env"

# 1. env files (the irreplaceable bit)
# `cp /docker/*/.env $STAGING/env/` would overwrite itself on each iteration —
# they all share the same basename (`.env`). Copy each with its project name
# encoded in the filename so the bundle preserves all of them:
#   /docker/agent-memory/.env  →  env/agent-memory.env
for env_file in /docker/*/.env; do
  [[ -f "$env_file" ]] || continue
  project=$(basename "$(dirname "$env_file")")
  cp "$env_file" "$STAGING/env/${project}.env"
done
ls -1 /docker/*/.env 2>/dev/null > "$STAGING/env/_manifest.txt"

# 2. pg_dump agent_memory (portable SQL, restorable anywhere)
docker exec agent-memory-postgres pg_dump -U agent_memory agent_memory \
  > "$STAGING/agent_memory.sql" 2>/dev/null

# 3. pg_dump paperclip (optional; its embedded PG lives inside the paperclip container)
# Skip if the schema isn't cleanly dumpable — it's an audit log, loss is tolerable
docker exec paperclip-hxtc-paperclip-1 sh -c 'which pg_dump >/dev/null 2>&1 && pg_dump -U paperclip paperclip' \
  > "$STAGING/paperclip.sql" 2>/dev/null || {
  echo '(paperclip dump not available — skipped)' > "$STAGING/paperclip.sql"
}

# 4. brief metadata
cat > "$STAGING/_metadata.json" <<EOF
{
  "stamp": "$STAMP",
  "vm_id": 1535988,
  "hostname": "$(hostname)",
  "backup_generator": "dr-push-to-github.sh",
  "bundle_contents": [
    "env/ — all /docker/*/.env files + _manifest.txt",
    "agent_memory.sql — pg_dump of agent_memory database",
    "paperclip.sql — pg_dump of paperclip (best effort)"
  ]
}
EOF

# ---- Bundle + encrypt --------------------------------------------------------
BUNDLE="$STAGING/$STAMP.tar.gz.gpg"
tar -czf - -C "$STAGING" env agent_memory.sql paperclip.sql _metadata.json \
  | gpg --batch --symmetric --cipher-algo AES256 --passphrase "$PASS" --output "$BUNDLE"

SIZE=$(stat -c%s "$BUNDLE")
log "encrypted bundle size_bytes=$SIZE"

# ---- Git push to private repo ------------------------------------------------
REPO_DIR="$STAGING/repo"
git clone --depth 1 --branch "$BACKUP_BRANCH" "$BACKUP_REPO" "$REPO_DIR" 2>&1 | tail -3

mkdir -p "$REPO_DIR/backups/$YEAR"
cp "$BUNDLE" "$REPO_DIR/backups/$YEAR/$STAMP.tar.gz.gpg"

cd "$REPO_DIR"
git config user.name "agent-team-dr"
git config user.email "agent-team-dr@srv1535988.hstgr.cloud"

# Retention: keep last RETAIN_WEEKS, drop older
mapfile -t all_backups < <(find backups -type f -name '*.tar.gz.gpg' | sort -r)
if [[ "${#all_backups[@]}" -gt "$RETAIN_WEEKS" ]]; then
  for stale in "${all_backups[@]:$RETAIN_WEEKS}"; do
    log "pruning $stale"
    git rm -f "$stale" >/dev/null
  done
fi

git add backups/
if git diff --cached --quiet; then
  log "nothing to commit (already up to date?) — skipping push"
else
  git commit -m "backup $STAMP (size=${SIZE}B, vm=1535988)" --quiet
  git push origin "$BACKUP_BRANCH" 2>&1 | tail -3
  log "pushed stamp=$STAMP"
fi

log "done"

# ==============================================================================
# RESTORE (run on a recovery VPS or any machine with gpg + the passphrase):
# ==============================================================================
#   # If you have gh CLI + repo access:
#   gh api repos/rczamor/rz-agent-team-dr-backups/contents/backups/2026/2026-04-22.tar.gz.gpg \
#        -H 'Accept: application/vnd.github.raw' > /tmp/restore.tar.gz.gpg
#   # Or via git + deploy key:
#   GIT_SSH_COMMAND="ssh -i /root/.agent-team-dr/ssh-key" \
#     git clone --depth 1 git@github.com:rczamor/rz-agent-team-dr-backups.git /tmp/rzdr
#   cp /tmp/rzdr/backups/2026/2026-04-22.tar.gz.gpg /tmp/restore.tar.gz.gpg
#
#   gpg --batch --passphrase "$(cat /root/.agent-team-dr/passphrase)" --decrypt /tmp/restore.tar.gz.gpg \
#     | tar -xzf - -C /tmp/restored
#   # Inspect /tmp/restored/env/*.env and agent_memory.sql before applying.
#   # Restore env files: cp /tmp/restored/env/*.env /docker/<project>/
#   # Restore agent_memory: docker exec -i agent-memory-postgres psql -U agent_memory agent_memory < /tmp/restored/agent_memory.sql

# ==============================================================================
# Monitoring via Claude Code Routine (OPTIONAL — not implemented here)
# ==============================================================================
# Create a weekly Claude Code Routine called "dr-backup-monitor" at
# claude.ai/code/routines with the GitHub connector attached. Prompt:
#
#   You are the DR backup monitor. Each week, check the private repo
#   rczamor/rz-agent-team-dr-backups at the backups/ path. Find the most
#   recent file (sorted by date in filename, YYYY-MM-DD.tar.gz.gpg).
#
#   If the newest backup is:
#     - < 8 days old → post "✅ agent-team DR backup healthy: $filename"
#                      to #agent-team Slack. Include size + age in days.
#     - > 8 days old → post "🚨 agent-team DR backup STALE: last was $filename
#                      ($age days old). VPS cron may be broken — check
#                      /var/log/agent-team/dr-push.log"
#     - No backups at all → post "🚨 agent-team DR: NO BACKUPS FOUND"
#
# Schedule: weekly, Monday 08:00 UTC (about 52h after the VPS cron runs).
# Connectors needed: GitHub (read rczamor/rz-agent-team-dr-backups), Slack.
