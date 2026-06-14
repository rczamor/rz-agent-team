#!/usr/bin/env bash
# Anti-drift guard (TRZ-541): assert mode 600 on every OpenClaw agent's openclaw.json.
# Some fleet config edits rewrite openclaw.json with umask-default 0644, which exposes
# the config (tokens/paths) to non-owner reads. This re-asserts 600 and logs any drift.
# Deployed to /usr/local/sbin/assert-openclaw-perms.sh on the VPS; run hourly via cron.
set -uo pipefail

ROLES="conductor pm growth designer backend-eng data-eng ai-eng ui-eng qa-eng devops-eng tech-writer"
LOG="/var/log/openclaw-perms.log"
ts() { date -u +%FT%TZ; }

fixed=0
for r in $ROLES; do
  f="/docker/openclaw-${r}/data/.openclaw/openclaw.json"
  [ -f "$f" ] || continue
  m=$(stat -c '%a' "$f" 2>/dev/null || echo "")
  if [ "$m" != "600" ]; then
    if chmod 600 "$f"; then
      echo "$(ts) DRIFT-FIXED ${r}/openclaw.json was ${m} -> 600" >> "$LOG"
      fixed=$((fixed + 1))
    else
      echo "$(ts) DRIFT-FAILED ${r}/openclaw.json could not chmod (was ${m})" >> "$LOG"
    fi
  fi
done

if [ "$fixed" -gt 0 ]; then
  echo "$(ts) assert-openclaw-perms: re-asserted 600 on ${fixed} drifted file(s)" >> "$LOG"
fi
exit 0
