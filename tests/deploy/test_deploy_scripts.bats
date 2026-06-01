#!/usr/bin/env bats
# ==============================================================================
# Tests for scripts/ deployment automation.
#
# Run with: bats tests/deploy/test_deploy_scripts.bats
# Requires: bats-core. Optional: shellcheck, docker compose (for compose
#           config validation).
# ==============================================================================

setup() {
  REPO_ROOT="$(cd "$(dirname "${BATS_TEST_FILENAME}")/../.." && pwd)"
  export REPO_ROOT
  SCRIPTS_DIR="${REPO_ROOT}/scripts"
  export SCRIPTS_DIR
}

# ------------------------------------------------------------------------------
# File presence + executable bit
# ------------------------------------------------------------------------------

@test "deploy-identities.sh exists and is executable (mode 755)" {
  [ -f "${SCRIPTS_DIR}/deploy-identities.sh" ]
  [ -x "${SCRIPTS_DIR}/deploy-identities.sh" ]
  mode="$(stat -f '%A' "${SCRIPTS_DIR}/deploy-identities.sh" 2>/dev/null \
         || stat -c '%a' "${SCRIPTS_DIR}/deploy-identities.sh")"
  [ "$mode" = "755" ]
}

@test "corpus-refresh-weekly.sh exists and is executable (mode 755)" {
  [ -f "${SCRIPTS_DIR}/corpus-refresh-weekly.sh" ]
  [ -x "${SCRIPTS_DIR}/corpus-refresh-weekly.sh" ]
  mode="$(stat -f '%A' "${SCRIPTS_DIR}/corpus-refresh-weekly.sh" 2>/dev/null \
         || stat -c '%a' "${SCRIPTS_DIR}/corpus-refresh-weekly.sh")"
  [ "$mode" = "755" ]
}

@test "install-cron.sh exists and is executable (mode 755)" {
  [ -f "${SCRIPTS_DIR}/install-cron.sh" ]
  [ -x "${SCRIPTS_DIR}/install-cron.sh" ]
  mode="$(stat -f '%A' "${SCRIPTS_DIR}/install-cron.sh" 2>/dev/null \
         || stat -c '%a' "${SCRIPTS_DIR}/install-cron.sh")"
  [ "$mode" = "755" ]
}

@test "bootstrap-openclaw-instance.sh exists and is executable (mode 755)" {
  [ -f "${SCRIPTS_DIR}/bootstrap-openclaw-instance.sh" ]
  [ -x "${SCRIPTS_DIR}/bootstrap-openclaw-instance.sh" ]
  mode="$(stat -f '%A' "${SCRIPTS_DIR}/bootstrap-openclaw-instance.sh" 2>/dev/null \
         || stat -c '%a' "${SCRIPTS_DIR}/bootstrap-openclaw-instance.sh")"
  [ "$mode" = "755" ]
}

@test "scripts/README.md exists" {
  [ -f "${SCRIPTS_DIR}/README.md" ]
}

# ------------------------------------------------------------------------------
# shellcheck (optional -- skips if not installed)
# ------------------------------------------------------------------------------

@test "deploy-identities.sh passes shellcheck" {
  if ! command -v shellcheck >/dev/null 2>&1; then
    skip "shellcheck not installed"
  fi
  run shellcheck -s bash -S error "${SCRIPTS_DIR}/deploy-identities.sh"
  [ "$status" -eq 0 ]
}

@test "corpus-refresh-weekly.sh passes shellcheck" {
  if ! command -v shellcheck >/dev/null 2>&1; then
    skip "shellcheck not installed"
  fi
  run shellcheck -s bash -S error "${SCRIPTS_DIR}/corpus-refresh-weekly.sh"
  [ "$status" -eq 0 ]
}

@test "install-cron.sh passes shellcheck" {
  if ! command -v shellcheck >/dev/null 2>&1; then
    skip "shellcheck not installed"
  fi
  run shellcheck -s bash -S error "${SCRIPTS_DIR}/install-cron.sh"
  [ "$status" -eq 0 ]
}

@test "bootstrap-openclaw-instance.sh passes shellcheck" {
  if ! command -v shellcheck >/dev/null 2>&1; then
    skip "shellcheck not installed"
  fi
  run shellcheck -s bash -S error "${SCRIPTS_DIR}/bootstrap-openclaw-instance.sh"
  [ "$status" -eq 0 ]
}

# ------------------------------------------------------------------------------
# deploy-identities.sh --help / arg validation
# ------------------------------------------------------------------------------

@test "deploy-identities.sh --help prints usage" {
  run "${SCRIPTS_DIR}/deploy-identities.sh" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
}

@test "deploy-identities.sh rejects unknown flag" {
  run "${SCRIPTS_DIR}/deploy-identities.sh" --bogus
  [ "$status" -ne 0 ]
}

@test "deploy-identities.sh rejects unknown --role" {
  # Stub CONNECT_SH to something executable so the preflight passes before arg
  # validation matters. Use a mock repo root with the required top-level files.
  local tmp
  tmp="$(mktemp -d)"
  touch "${tmp}/TEAM.md" "${tmp}/USER.md"
  mkdir -p "${tmp}/identities" "${tmp}/corpus" "${tmp}/skills/shared"
  echo '#!/bin/sh' > "${tmp}/connect.sh"
  echo 'echo "mock ssh: $*"' >> "${tmp}/connect.sh"
  chmod 755 "${tmp}/connect.sh"

  run env REPO_ROOT="$tmp" CONNECT_SH="${tmp}/connect.sh" \
    "${SCRIPTS_DIR}/deploy-identities.sh" --role not-a-real-role --dry-run
  [ "$status" -ne 0 ]
  [[ "$output" == *"not in"* ]]
  rm -rf "$tmp"
}

# ------------------------------------------------------------------------------
# deploy-identities.sh --dry-run against a mocked role environment
# ------------------------------------------------------------------------------

@test "deploy-identities.sh --dry-run --no-restart emits structured output for mocked role" {
  local tmp
  tmp="$(mktemp -d)"

  # Minimal mock repo root -- just enough to satisfy preflight + rsync sources.
  touch "${tmp}/TEAM.md" "${tmp}/USER.md"
  mkdir -p "${tmp}/identities"
  cat > "${tmp}/identities/ai-eng.md" <<EOF
# AI Engineer identity
EOF
  mkdir -p "${tmp}/corpus/ai-eng"
  echo "seed" > "${tmp}/corpus/ai-eng/README.md"
  mkdir -p "${tmp}/skills/shared"
  echo "shared" > "${tmp}/skills/shared/SKILL.md"

  # Mock .env.local + connect.sh so the rsync helper can read connection vars
  # without failing, and so remote() calls just echo.
  mkdir -p "${tmp}/outer"
  cat > "${tmp}/outer/.env.local" <<EOF
HOSTINGER_HOST=mock.example.com
HOSTINGER_USER=mockuser
HOSTINGER_SSH_KEY=/tmp/mock-key
HOSTINGER_PORT=22
EOF
  cat > "${tmp}/outer/connect.sh" <<'EOF'
#!/usr/bin/env bash
# Mock connect.sh -- accept any remote cmd and print what we'd have run.
# For `test -d` probes we return success so dry-run proceeds.
case "$*" in
  *"test -d"*) exit 0 ;;
  *) echo "[mock connect.sh] $*" ;;
esac
EOF
  chmod 755 "${tmp}/outer/connect.sh"

  run env REPO_ROOT="$tmp" CONNECT_SH="${tmp}/outer/connect.sh" \
    "${SCRIPTS_DIR}/deploy-identities.sh" --dry-run --no-restart --role ai-eng
  [ "$status" -eq 0 ]
  [[ "$output" == *"role=ai-eng"* ]]
  [[ "$output" == *"step=team-md"* ]]
  [[ "$output" == *"step=user-md"* ]]
  [[ "$output" == *"step=identity-md"* ]]
  [[ "$output" == *"step=corpus"* ]]
  [[ "$output" == *"step=skills-shared"* ]]
  [[ "$output" == *"step=restart status=skipped"* ]]
  rm -rf "$tmp"
}

# Regression for TRZ-501: associative-array refactor must keep the pm -> pm-lite
# mapping working AND the script must boot cleanly under bash 3.2 (stock macOS).
@test "deploy-identities.sh --role pm resolves to identities/pm-lite.md and boots on bash 3.2" {
  local tmp
  tmp="$(mktemp -d)"
  touch "${tmp}/TEAM.md" "${tmp}/USER.md"
  mkdir -p "${tmp}/identities" "${tmp}/skills/shared"
  echo "# PM identity (lite)" > "${tmp}/identities/pm-lite.md"
  echo "shared" > "${tmp}/skills/shared/SKILL.md"

  mkdir -p "${tmp}/outer"
  cat > "${tmp}/outer/.env.local" <<EOF
HOSTINGER_HOST=mock.example.com
HOSTINGER_USER=mockuser
HOSTINGER_SSH_KEY=/tmp/mock-key
HOSTINGER_PORT=22
EOF
  cat > "${tmp}/outer/connect.sh" <<'EOF'
#!/usr/bin/env bash
case "$*" in
  *"test -d"*) exit 0 ;;
  *) echo "[mock connect.sh] $*" ;;
esac
EOF
  chmod 755 "${tmp}/outer/connect.sh"

  # Force /bin/bash (3.2.57 on stock macOS) so we exercise the portability fix
  # even on dev boxes that have homebrew bash on PATH.
  run env REPO_ROOT="$tmp" CONNECT_SH="${tmp}/outer/connect.sh" \
    /bin/bash "${SCRIPTS_DIR}/deploy-identities.sh" --dry-run --no-restart --role pm
  [ "$status" -eq 0 ]
  [[ "$output" == *"role=pm"* ]]
  [[ "$output" == *"step=identity-md status=ok"* ]]
  [[ "$output" != *"unbound variable"* ]]
  [[ "$output" != *"declare: -A"* ]]
  rm -rf "$tmp"
}

# ------------------------------------------------------------------------------
# bootstrap-openclaw-instance.sh generates a parseable compose file
# ------------------------------------------------------------------------------

@test "bootstrap-openclaw-instance.sh rejects unknown role" {
  run "${SCRIPTS_DIR}/bootstrap-openclaw-instance.sh" bogus-role --out /tmp/unused
  [ "$status" -ne 0 ]
}

@test "bootstrap-openclaw-instance.sh writes docker-compose.yml and .env for a valid role" {
  local tmp
  tmp="$(mktemp -d)"
  run "${SCRIPTS_DIR}/bootstrap-openclaw-instance.sh" ai-eng --out "${tmp}/openclaw-ai-eng"
  [ "$status" -eq 0 ]
  [ -f "${tmp}/openclaw-ai-eng/docker-compose.yml" ]
  [ -f "${tmp}/openclaw-ai-eng/.env" ]
  [ -d "${tmp}/openclaw-ai-eng/data/.openclaw/workspace/corpus" ]
  [ -d "${tmp}/openclaw-ai-eng/data/.openclaw/skills" ]

  # .env should seed AGENT_ROLE and the role-specific Slack token var.
  grep -q '^AGENT_ROLE=ai-eng$' "${tmp}/openclaw-ai-eng/.env"
  grep -q '^SLACK_BOT_TOKEN_AI_ENG=' "${tmp}/openclaw-ai-eng/.env"

  rm -rf "$tmp"
}

@test "bootstrap-openclaw-instance.sh output is valid YAML parseable by docker compose config" {
  if ! command -v docker >/dev/null 2>&1; then
    skip "docker not installed"
  fi
  if ! docker compose version >/dev/null 2>&1; then
    skip "docker compose plugin not installed"
  fi

  local tmp
  tmp="$(mktemp -d)"
  run "${SCRIPTS_DIR}/bootstrap-openclaw-instance.sh" conductor --out "${tmp}/openclaw-conductor"
  [ "$status" -eq 0 ]

  # Provide env vars that `docker compose config` needs to interpolate, or it
  # will complain about missing variables (non-fatal warnings are ok).
  run env \
    ANTHROPIC_API_KEY=x OLLAMA_API_KEY=x OLLAMA_HOST=https://ollama.com \
    AGENT_MEMORY_DSN=postgres://u:p@h:5432/d \
    docker compose -f "${tmp}/openclaw-conductor/docker-compose.yml" config --quiet
  [ "$status" -eq 0 ]

  rm -rf "$tmp"
}
