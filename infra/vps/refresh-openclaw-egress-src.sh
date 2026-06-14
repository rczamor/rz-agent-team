#!/usr/bin/env bash
# Rebuild the openclaw_egress_src ipset (hash:ip) from the 11 OpenClaw containers'
# current interface IPs. Atomic swap so there is never an empty-set window.
# Installed 2026-06-10 for the SNI egress-proxy containment (OPENCLAW_EGRESS chain).
set -uo pipefail
SET=openclaw_egress_src
TMP="${SET}_tmp"
ipset create -exist "$SET" hash:ip family inet
ipset create -exist "$TMP" hash:ip family inet
ipset flush "$TMP"
for r in conductor pm growth designer backend-eng data-eng ai-eng ui-eng qa-eng devops-eng tech-writer; do
  c="openclaw-${r}-openclaw-1"
  ips=$(docker inspect "$c" --format '{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' 2>/dev/null || true)
  for ip in $ips; do
    [ -n "$ip" ] && ipset add -exist "$TMP" "$ip"
  done
done
ipset swap "$TMP" "$SET"
ipset destroy "$TMP"
