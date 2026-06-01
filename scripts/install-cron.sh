#!/usr/bin/env bash
# ==============================================================================
# install-cron.sh
# ------------------------------------------------------------------------------
# Installs the weekly corpus-refresh automation on the VPS. Run ONCE manually
# (on the VPS itself, as root).
#
# Default path: cron. A systemd timer variant is also written but NOT enabled.
# Pick one:
#   cron (default):  systemd stays idle, cron runs the job
#   systemd:         disable/remove the cron entry, enable the timer
#
# Idempotent -- safe to re-run.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REFRESH_SRC="${SCRIPT_DIR}/corpus-refresh-weekly.sh"

INSTALL_BIN="/usr/local/bin/corpus-refresh-weekly.sh"
CRON_FILE="/etc/cron.d/agent-team-corpus"
SYSTEMD_SERVICE="/etc/systemd/system/agent-team-corpus-refresh.service"
SYSTEMD_TIMER="/etc/systemd/system/agent-team-corpus-refresh.timer"
LOG_DIR="/var/log/agent-team"

if [[ $EUID -ne 0 ]]; then
  echo "error: install-cron.sh must run as root" >&2
  exit 1
fi

if [[ ! -f "$REFRESH_SRC" ]]; then
  echo "error: refresh script not found at $REFRESH_SRC" >&2
  exit 1
fi

echo "[install-cron] installing ${REFRESH_SRC} -> ${INSTALL_BIN}"
install -m 755 "$REFRESH_SRC" "$INSTALL_BIN"

echo "[install-cron] ensuring log dir ${LOG_DIR}"
mkdir -p "$LOG_DIR"
chmod 755 "$LOG_DIR"

echo "[install-cron] writing ${CRON_FILE}"
cat > "$CRON_FILE" <<'EOF'
# Weekly corpus refresh for OpenClaw fleet
PATH=/usr/local/bin:/usr/bin:/bin
SHELL=/bin/bash
5 3 * * MON root /usr/local/bin/corpus-refresh-weekly.sh >> /var/log/agent-team/corpus-refresh.log 2>&1
EOF
chmod 644 "$CRON_FILE"

# Some distros need cron reloaded after dropping a file in /etc/cron.d; most
# modern ones (Debian/Ubuntu) pick it up automatically. Best-effort reload:
if systemctl list-unit-files --type=service 2>/dev/null | grep -q '^cron\.service'; then
  systemctl reload cron.service || systemctl restart cron.service || true
fi

echo "[install-cron] writing systemd variant (service + timer, NOT enabled by default)"
cat > "$SYSTEMD_SERVICE" <<EOF
[Unit]
Description=Agent-team weekly corpus refresh (oneshot)
Documentation=https://github.com/rczamor/rz-agent-team
After=network-online.target docker.service
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=${INSTALL_BIN}
StandardOutput=append:/var/log/agent-team/corpus-refresh.log
StandardError=append:/var/log/agent-team/corpus-refresh.log
EOF

cat > "$SYSTEMD_TIMER" <<'EOF'
[Unit]
Description=Run agent-team corpus refresh weekly (Mon 03:05)

[Timer]
OnCalendar=Mon *-*-* 03:05:00
Persistent=true
AccuracySec=1min
Unit=agent-team-corpus-refresh.service

[Install]
WantedBy=timers.target
EOF

# Just make systemd aware of the units; don't enable them (cron is the
# default path). User can opt in with: systemctl enable --now agent-team-corpus-refresh.timer
systemctl daemon-reload

cat <<EOF

[install-cron] done.

Active schedule: cron (via ${CRON_FILE})
   Weekly on Monday at 03:05 UTC.

To switch to systemd instead:
  sudo rm -f ${CRON_FILE}
  sudo systemctl enable --now agent-team-corpus-refresh.timer

To verify:
  systemctl list-timers | grep agent-team
  cat /var/log/agent-team/corpus-refresh.log | tail -n 50

EOF
