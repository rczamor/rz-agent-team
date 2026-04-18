#!/usr/bin/env bash
# agent-team-status.sh — print a compact state-of-the-world report for the agent team.
#
# Designed to run on the Hostinger VPS (187.124.155.172). Safe from any cwd.
# Exits 0 on success regardless of service health — the output tells the story.
#
# Usage:  bash scripts/agent-team-status.sh
#         (or place at /usr/local/bin/agent-team-status if you want it on PATH)

set -u  # don't use -e; we want to keep reporting even if a check fails

# Color codes
G="\033[32m"; Y="\033[33m"; R="\033[31m"; D="\033[2m"; N="\033[0m"
OK="${G}✓${N}"; WARN="${Y}⚠${N}"; FAIL="${R}✗${N}"

expected_roles=(conductor pm designer backend-eng data-eng ai-eng ui-eng qa-eng devops-eng tech-writer)

echo ""
echo -e "${D}Agent Team Status — $(date -u +'%Y-%m-%d %H:%M UTC')${N}"
echo ""

# ---------- Execution layer (OpenClaw) ----------
echo "Execution layer (OpenClaw):"
running_openclaws=$(docker ps --format '{{.Names}}' 2>/dev/null | grep -oE 'openclaw-[a-z-]+-openclaw' | sed 's/-openclaw$//' | sed 's/^openclaw-//' | sort -u)
running_count=$(echo "$running_openclaws" | grep -c . || echo 0)

missing=()
for role in "${expected_roles[@]}"; do
  if ! echo "$running_openclaws" | grep -qx "$role"; then
    missing+=("$role")
  fi
done

if [ ${#missing[@]} -eq 0 ]; then
  echo -e "  ${OK} 10 core instances running: $(echo "${expected_roles[*]}" | tr ' ' ', ')"
else
  echo -e "  ${WARN} Expected 10 core instances; missing: ${missing[*]}"
  echo -e "       Running: $(echo "$running_openclaws" | tr '\n' ' ')"
fi

# @growth check (optional — not yet deployed per CAR-367)
if echo "$running_openclaws" | grep -qx "growth"; then
  echo -e "  ${OK} openclaw-growth (narrow-scope exception) running"
else
  echo -e "  ${D}  openclaw-growth not deployed yet — see CAR-367${N}"
fi

# openclaw-researcher (should be retired per CAR-356)
if echo "$running_openclaws" | grep -qx "researcher"; then
  echo -e "  ${FAIL} openclaw-researcher is running — should be retired (CAR-356)"
fi

echo ""

# ---------- Services ----------
echo "Services:"

check_http() {
  local url="$1"
  local label="$2"
  local expected_code="${3:-200}"
  local timeout="${4:-5}"
  local code
  code=$(curl -sSL --max-time "$timeout" -o /dev/null -w '%{http_code}' "$url" 2>/dev/null || echo "000")
  if [ "$code" = "$expected_code" ]; then
    echo -e "  ${OK} $label (${D}HTTP $code${N})"
  else
    echo -e "  ${FAIL} $label — got HTTP $code from $url"
  fi
}

check_http "http://localhost:3000/api/public/health" "Langfuse web"
check_http "http://localhost:3100" "Paperclip" "200"
check_http "http://localhost:5678/healthz" "n8n"

# agent_memory Postgres — just check TCP connect
if command -v nc >/dev/null 2>&1; then
  if nc -z 127.0.0.1 54330 2>/dev/null; then
    echo -e "  ${OK} agent_memory Postgres accepting connections on 127.0.0.1:54330"
  else
    echo -e "  ${FAIL} agent_memory Postgres not reachable on 127.0.0.1:54330"
  fi
else
  echo -e "  ${WARN} nc not installed — skip agent_memory TCP check"
fi

# Ollama (embedding only)
check_http "http://localhost:32768/api/tags" "Ollama (embedding)"

echo ""

# ---------- n8n workflows ----------
echo "n8n workflows:"

# We can't query n8n without API token; list expected workflow names
expected_workflows=("Linear Router — Routines + Paperclip" "Linear Router — Reconciler" "Linear Router — Deferred Fire Drainer")
if [ -n "${N8N_API_TOKEN:-}" ]; then
  list=$(curl -sSL --max-time 5 -H "X-N8N-API-KEY: $N8N_API_TOKEN" http://localhost:5678/api/v1/workflows 2>/dev/null)
  for wf in "${expected_workflows[@]}"; do
    if echo "$list" | grep -qF "$wf"; then
      active=$(echo "$list" | python3 -c "import json,sys; d=json.load(sys.stdin); print([w for w in d.get('data',[]) if w['name']==sys.argv[1]][0].get('active',False))" "$wf" 2>/dev/null || echo "unknown")
      if [ "$active" = "True" ]; then
        echo -e "  ${OK} ${wf} — active"
      else
        echo -e "  ${WARN} ${wf} — present but inactive"
      fi
    else
      echo -e "  ${FAIL} ${wf} — not imported"
    fi
  done
else
  echo -e "  ${D}N8N_API_TOKEN not set — listing expected names only${N}"
  for wf in "${expected_workflows[@]}"; do
    echo -e "  ${D}  · ${wf}${N}"
  done
fi

echo ""

# ---------- VPS resources ----------
echo "VPS:"

ram_info=$(free -h 2>/dev/null | awk 'NR==2 {print $3 " / " $2}')
ram_pct=$(free 2>/dev/null | awk 'NR==2 {printf "%.0f", ($3/$2)*100}')
if [ -n "$ram_info" ]; then
  if [ "$ram_pct" -lt 75 ]; then STATUS=$OK
  elif [ "$ram_pct" -lt 90 ]; then STATUS=$WARN
  else STATUS=$FAIL
  fi
  echo -e "  ${STATUS} RAM: ${ram_info} (${ram_pct}%)"
fi

disk_info=$(df -h / 2>/dev/null | awk 'NR==2 {print $3 " / " $2 " (" $5 ")"}')
disk_pct=$(df / 2>/dev/null | awk 'NR==2 {print $5}' | tr -d '%')
if [ -n "$disk_info" ]; then
  if [ "$disk_pct" -lt 75 ]; then STATUS=$OK
  elif [ "$disk_pct" -lt 90 ]; then STATUS=$WARN
  else STATUS=$FAIL
  fi
  echo -e "  ${STATUS} Disk /: ${disk_info}"
fi

echo ""
echo -e "${D}Tip: set N8N_API_TOKEN for live workflow status; retire warnings → check the mapped Linear ticket${N}"
echo ""
