#!/usr/bin/env bash
# setup.sh — first-time-setup walkthrough for the rz-agent-team repo.
# Usage: bash scripts/setup.sh [--skip-install]
#
# Verifies prerequisites, installs the 4 strategic plugins via claude plugin install,
# and runs a status check. Safe to re-run.

set -u

G="\033[32m"; Y="\033[33m"; R="\033[31m"; D="\033[2m"; N="\033[0m"
OK="${G}✓${N}"; WARN="${Y}⚠${N}"; FAIL="${R}✗${N}"

SKIP_INSTALL=false
[[ "${1:-}" == "--skip-install" ]] && SKIP_INSTALL=true

echo ""
echo -e "${D}rz-agent-team first-time setup${N}"
echo ""

# --- 1. Prereqs ---
echo "Checking prerequisites..."
missing=0
check() {
  local name="$1"
  local cmd="$2"
  if command -v "$cmd" >/dev/null 2>&1; then
    echo -e "  ${OK} $name"
  else
    echo -e "  ${FAIL} $name not found (install $cmd)"
    missing=$((missing+1))
  fi
}

check "git" "git"
check "python3" "python3"
check "jq" "jq"
check "docker" "docker"
check "claude CLI" "claude"

if [ "$missing" -gt 0 ]; then
  echo ""
  echo -e "${R}$missing prerequisite(s) missing — install those first${N}"
  exit 1
fi

# --- 2. Git + repo state ---
echo ""
echo "Checking repo state..."

if [ ! -d ".git" ]; then
  echo -e "  ${FAIL} not inside a git repo — cd to the rz-agent-team repo first"
  exit 1
fi

branch=$(git rev-parse --abbrev-ref HEAD)
remote=$(git remote get-url origin 2>/dev/null || echo "no-origin")
if [[ "$remote" != *"rczamor/rz-agent-team"* ]]; then
  echo -e "  ${WARN} origin is $remote — expected rczamor/rz-agent-team"
fi
echo -e "  ${OK} branch: $branch ($(git rev-list --count HEAD) commits)"

# Fetch to check behind/ahead
git fetch origin --quiet 2>/dev/null && {
  behind=$(git rev-list --count HEAD..origin/main 2>/dev/null || echo 0)
  ahead=$(git rev-list --count origin/main..HEAD 2>/dev/null || echo 0)
  if [ "$behind" -gt 0 ]; then
    echo -e "  ${WARN} behind origin/main by $behind commit(s) — consider pulling"
  else
    echo -e "  ${OK} up to date with origin/main (ahead: $ahead)"
  fi
}

# --- 3. Validate JSON + plugin manifests ---
echo ""
echo "Validating config..."

for f in n8n/*.json plugins/*/.claude-plugin/plugin.json .claude-plugin/marketplace.json; do
  if [ -f "$f" ]; then
    python3 -c "import json; json.load(open('$f'))" 2>/dev/null \
      && echo -e "  ${OK} $f" \
      || echo -e "  ${FAIL} invalid JSON: $f"
  fi
done

# --- 4. Claude plugin install ---
if [ "$SKIP_INSTALL" = false ]; then
  echo ""
  echo "Installing strategic plugins (marketplace: rz-agent-team)..."

  # Check if marketplace is already added
  if claude plugin marketplace list 2>/dev/null | grep -q "rz-agent-team"; then
    echo -e "  ${OK} marketplace 'rz-agent-team' already added"
  else
    echo "  Adding marketplace..."
    claude plugin marketplace add rczamor/rz-agent-team 2>&1 | tail -3
  fi

  # Install each plugin
  for plugin in rz-architect rz-analyst rz-ux-researcher rz-ai-researcher; do
    if claude plugin list 2>/dev/null | grep -q "$plugin@rz-agent-team"; then
      echo -e "  ${OK} $plugin already installed"
    else
      echo "  Installing $plugin..."
      claude plugin install "$plugin@rz-agent-team" 2>&1 | tail -2
    fi
  done
else
  echo ""
  echo -e "${D}Skipping plugin install (--skip-install)${N}"
fi

# --- 5. Next steps ---
echo ""
echo -e "${G}Setup complete.${N}"
echo ""
echo "Next steps:"
echo "  1. Read: README.md for the architecture overview"
echo "  2. Read: plugins/ROUTINE_SETUP.md to create the 4 Claude Code Routines"
echo "  3. Read: n8n/README.md to deploy the n8n workflows"
echo "  4. Check: bash scripts/agent-team-status.sh (must be run on the VPS)"
echo ""
echo "Outstanding Linear tickets (for Riché, blocked on external action):"
echo "  - CAR-353: Create 4 Claude Code Routines (see plugins/ROUTINE_SETUP.md)"
echo "  - CAR-354: Deploy n8n workflows"
echo "  - CAR-355: Add Linear workflow statuses"
echo "  - CAR-357: Install identity files to VPS volumes (use scripts/deploy-identities.sh)"
echo "  - CAR-358: Re-register Paperclip org chart"
echo "  - CAR-365, CAR-367, CAR-369: Growth Agent stack (optional, prototype-only)"
echo ""
