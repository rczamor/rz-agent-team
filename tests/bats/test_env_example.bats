#!/usr/bin/env bats
# .env.example must define every ${VAR} that docker-compose.yml references,
# and must include the documented key placeholders (Anthropic, Ollama,
# Langfuse, agent memory DSN, per-role Slack tokens).

load '_helpers.bash'

COMPOSE="$REPO_ROOT/deploy/docker-compose.yml"
ENV_EXAMPLE="$REPO_ROOT/deploy/.env.example"

REQUIRED_KEYS=(
  ANTHROPIC_API_KEY
  OLLAMA_API_KEY
  OLLAMA_HOST
  AGENT_MEMORY_DSN
  LANGFUSE_PUBLIC_KEY
  LANGFUSE_SECRET_KEY
  LANGFUSE_HOST
  SLACK_BOT_TOKEN_CONDUCTOR
  SLACK_BOT_TOKEN_PM
  SLACK_BOT_TOKEN_RESEARCHER
  SLACK_BOT_TOKEN_DESIGNER
  SLACK_BOT_TOKEN_BACKEND_ENG
  SLACK_BOT_TOKEN_DATA_ENG
  SLACK_BOT_TOKEN_AI_ENG
  SLACK_BOT_TOKEN_UI_ENG
  SLACK_BOT_TOKEN_QA_ENG
  SLACK_BOT_TOKEN_DEVOPS_ENG
  SLACK_BOT_TOKEN_TECH_WRITER
)

@test "deploy/.env.example exists" {
  [ -f "$ENV_EXAMPLE" ]
}

@test "every \${VAR} in docker-compose.yml is declared in .env.example" {
  local missing=0
  local vars
  vars="$(extract_compose_vars "$COMPOSE")"
  while IFS= read -r v; do
    [ -z "$v" ] && continue
    if ! grep -qE "^${v}=" "$ENV_EXAMPLE"; then
      echo "missing in .env.example: $v"
      missing=$((missing + 1))
    fi
  done <<< "$vars"
  [ "$missing" = "0" ] || return 1
}

@test ".env.example declares every documented placeholder key" {
  local missing=0
  for key in "${REQUIRED_KEYS[@]}"; do
    if ! grep -qE "^${key}=" "$ENV_EXAMPLE"; then
      echo "missing $key"
      missing=$((missing + 1))
    fi
  done
  [ "$missing" = "0" ] || return 1
}

@test ".env.example placeholders are not real secrets" {
  # Every value should either contain REPLACE-ME, or be one of the safe
  # non-secret defaults below. Anything else is suspicious.
  local bad
  bad="$(awk -F= '
    /^[A-Z_][A-Z0-9_]*=/ {
      val = $0
      sub(/^[A-Z_][A-Z0-9_]*=/, "", val)
      if (val == "clickhouse") next
      if (val == "minio") next
      if (val == "agent_memory") next
      if (val == "agent-team.example.com") next
      if (val == "ops@example.com") next
      if (val == "http://langfuse-web:3000") next
      if (val == "https://ollama.com") next
      if (val ~ /REPLACE-ME/) next
      print $0
    }
  ' "$ENV_EXAMPLE")"
  if [ -n "$bad" ]; then
    echo "suspicious non-placeholder values:"
    echo "$bad"
    return 1
  fi
}
