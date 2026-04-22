#!/usr/bin/env bash
# ==============================================================================
# memory-health-report.sh  (TRZ-441 part 3)
# ------------------------------------------------------------------------------
# Weekly report of agent_memory table health. Intended for the Monday morning
# Slack post to #agent-team.
#
# Output is pure text on stdout — intended to be piped to a Slack webhook by
# n8n, or posted by the DevOps agent.
#
# Run from the VPS. Designed for cron:
#   # Mondays at 08:00 UTC
#   0 8 * * 1  /usr/local/bin/memory-health-report.sh | curl -sS -X POST \
#              -H 'Content-Type: application/json' \
#              --data-binary @- "$SLACK_WEBHOOK_URL"
# ==============================================================================

set -euo pipefail

PG_CONTAINER="${AGENT_MEMORY_PG_CONTAINER:-agent-memory-postgres}"
PG_USER="${AGENT_MEMORY_PG_USER:-agent_memory}"
PG_DB="${AGENT_MEMORY_PG_DB:-agent_memory}"

q() {
  docker exec -i "$PG_CONTAINER" psql -U "$PG_USER" -d "$PG_DB" -At -F '|' "$@"
}

DATE=$(date -u +%Y-%m-%d)

DECISIONS=$(q <<SQL
SELECT COUNT(*) FROM agent_memory.decisions;
SQL
)
DECISIONS_DUPED=$(q <<SQL
SELECT COUNT(*) FROM agent_memory.decisions WHERE superseded_by IS NOT NULL;
SQL
)
DECISIONS_WEEK=$(q <<SQL
SELECT COUNT(*) FROM agent_memory.decisions
WHERE decided_at >= now() - INTERVAL '7 days';
SQL
)
PATTERNS=$(q <<SQL
SELECT COUNT(*) FROM agent_memory.patterns;
SQL
)
FINDINGS=$(q <<SQL
SELECT COUNT(*) FROM agent_memory.findings_references;
SQL
)
SESSIONS_LIVE=$(q <<SQL
SELECT COUNT(*) FROM agent_memory.sessions;
SQL
)
SESSIONS_ARCHIVED_WEEK=$(q <<SQL
SELECT COUNT(*) FROM agent_memory.sessions_archive
WHERE archived_at >= now() - INTERVAL '7 days';
SQL
)

TOP_APPS=$(q <<SQL
SELECT app_id || '=' || COUNT(*)
FROM agent_memory.decisions
GROUP BY app_id
ORDER BY COUNT(*) DESC
LIMIT 5;
SQL
)
TOP_APPS_JOINED=$(printf '%s, ' $TOP_APPS | sed 's/, $//')

RECENT_RUN=$(q <<SQL
SELECT
  to_char(started_at, 'YYYY-MM-DD HH24:MI') ||
  ' mode=' || mode ||
  ' embedded=' || decisions_embedded ||
  ' deduped=' || decisions_deduped ||
  ' archived=' || sessions_archived
FROM agent_memory.consolidation_runs
ORDER BY started_at DESC
LIMIT 1;
SQL
)

# Emit JSON body suitable for Slack's incoming webhook.
# (If posting via n8n Slack node instead, wrap the text in a .blocks array there.)
jq -n --arg text "\
:chart_with_upwards_trend: *agent_memory health — ${DATE}*
• decisions: ${DECISIONS} total (${DECISIONS_WEEK} new this week, ${DECISIONS_DUPED} deduped)
• patterns: ${PATTERNS}
• findings_references: ${FINDINGS}
• sessions: ${SESSIONS_LIVE} live, ${SESSIONS_ARCHIVED_WEEK} archived this week
• top apps by decision count: ${TOP_APPS_JOINED:-none}
• last consolidation run: ${RECENT_RUN:-never}
" '{text: $text}'
