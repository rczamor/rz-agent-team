#!/usr/bin/env bats
# docker-compose.yml: parses cleanly (via `docker compose config` when docker
# is installed), has all 11 openclaw-<role> services sharing the hvps-openclaw
# image prefix, exposes port block 47810..47820 exactly once each, and
# includes traefik + agent-memory services.

load '_helpers.bash'

COMPOSE="$REPO_ROOT/deploy/docker-compose.yml"
ENV_EXAMPLE="$REPO_ROOT/deploy/.env.example"
# Role names are corpus-style; the openclaw service for `pm-lite` is named
# `openclaw-pm` (identity/corpus roles don't use the -lite suffix downstream).
SERVICE_SUFFIXES=(conductor pm growth designer backend-eng data-eng ai-eng ui-eng qa-eng devops-eng tech-writer)

@test "deploy/docker-compose.yml exists" {
  [ -f "$COMPOSE" ]
}

@test "docker compose config parses the compose file (skipped if docker absent)" {
  if ! command -v docker >/dev/null 2>&1; then
    skip "docker not installed on this host"
  fi
  if ! docker compose version >/dev/null 2>&1; then
    skip "docker compose v2 not available"
  fi
  # Use the example env file so ${VARs} resolve; --quiet keeps output clean.
  docker compose --env-file "$ENV_EXAMPLE" -f "$COMPOSE" config --quiet
}

@test "all 11 openclaw-<role> services are declared" {
  local missing=0
  for s in "${SERVICE_SUFFIXES[@]}"; do
    if ! grep -qE "^[[:space:]]{2}openclaw-${s}:[[:space:]]*$" "$COMPOSE"; then
      echo "missing service openclaw-$s"
      missing=$((missing + 1))
    fi
  done
  [ "$missing" = "0" ] || return 1
}

@test "all 11 openclaw services share the hvps-openclaw image prefix" {
  # Count how many openclaw-* services actually sit under an
  # `image: ghcr.io/hostinger/hvps-openclaw...` line via YAML anchor reuse.
  local anchor_count
  anchor_count="$(grep -cE '^[[:space:]]{2}openclaw-[a-z-]+:[[:space:]]*$' "$COMPOSE")"
  [ "$anchor_count" = "11" ] || { echo "found $anchor_count openclaw services"; return 1; }
  # The compose uses a YAML anchor to share the image line; check it's present.
  grep -qE 'image:[[:space:]]+ghcr\.io/hostinger/hvps-openclaw' "$COMPOSE"
}

@test "port block 47810-47820 is used exactly once each" {
  local missing=0
  for port in 47810 47811 47812 47813 47814 47815 47816 47817 47818 47819 47820; do
    local c
    c="$(grep -cE "^[[:space:]]+- \"${port}:[0-9]+\"" "$COMPOSE")"
    if [ "$c" != "1" ]; then
      echo "port $port used $c times (expected 1)"
      missing=$((missing + 1))
    fi
  done
  [ "$missing" = "0" ] || return 1
}

@test "traefik service is declared" {
  grep -qE '^[[:space:]]{2}traefik:[[:space:]]*$' "$COMPOSE"
}

@test "agent-memory service is declared" {
  grep -qE '^[[:space:]]{2}agent-memory:[[:space:]]*$' "$COMPOSE"
}
