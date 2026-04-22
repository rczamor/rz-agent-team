#!/usr/bin/env bash
# ==============================================================================
# consolidate-agent-memory.sh  (TRZ-441)
# ------------------------------------------------------------------------------
# Nightly consolidation pass over the `agent_memory` Postgres schema.
#
# Steps:
#   1. Archive `sessions` older than 90 days to `sessions_archive`.
#   2. Write one row to `consolidation_runs` summarizing the pass.
#
# DEFERRED (pending TRZ-443, which swaps agent-memory-postgres to pgvector):
#   - Embed any new `decisions` rows (nomic-embed-text via Ollama)
#   - Within each `app_id`, find near-duplicate decisions by cosine similarity
#     and link the older one via `superseded_by` to the newer one.
# Those steps no-op until pgvector is installed; the audit-log tracks them as 0.
#
# Default is --dry-run (reports what would change; applies nothing).
# Pass --apply to actually mutate.
#
# Run from the VPS. Designed for cron:
#   # Nightly at 02:30 UTC, dry-run first 7 days then flip to apply
#   30 2 * * *  /usr/local/bin/consolidate-agent-memory.sh --apply >> /var/log/agent-team/consolidate.log 2>&1
#
# Deps: docker, curl, jq, psql (via docker into agent-memory-postgres)
# ==============================================================================

set -euo pipefail

PG_CONTAINER="${AGENT_MEMORY_PG_CONTAINER:-agent-memory-postgres}"
PG_USER="${AGENT_MEMORY_PG_USER:-agent_memory}"
PG_DB="${AGENT_MEMORY_PG_DB:-agent_memory}"

OLLAMA_CONTAINER="${OLLAMA_CONTAINER:-ollama-apvg-ollama-1}"
EMBED_MODEL="${EMBED_MODEL:-nomic-embed-text}"

SIM_THRESHOLD="${SIM_THRESHOLD:-0.92}"
ARCHIVE_AGE_DAYS="${ARCHIVE_AGE_DAYS:-90}"

MODE="dry-run"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) MODE="dry-run"; shift ;;
    --apply)   MODE="apply"; shift ;;
    -h|--help) sed -n '2,25p' "$0"; exit 0 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

log() {
  printf '%s [consolidate] mode=%s %s\n' \
    "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$MODE" "$*"
}

# Run SQL via the agent-memory-postgres container. Uses docker to avoid
# needing psql on the host; ON_ERROR_STOP=1 ensures any SQL failure aborts.
pgquery() {
  docker run --rm -i --network agent-memory_default \
    -e PGPASSWORD="$(grep ^POSTGRES_PASSWORD /docker/agent-memory/.env | cut -d= -f2)" \
    postgres:17 psql -h "$PG_CONTAINER" -U "$PG_USER" -d "$PG_DB" \
    -v ON_ERROR_STOP=1 -At -F '|' "$@" 2>&1
}

# Alternative path when running on the VPS where docker network access is
# cheap: just shell in via the existing container.
pgquery_local() {
  docker container "$PG_CONTAINER" >/dev/null 2>&1 || true
  # shellcheck disable=SC2086
  printf '%s' "$(cat)" | \
    $(which docker) container run --rm -i postgres:17 true >/dev/null 2>&1 || \
    docker $(echo "container") exec -i "$PG_CONTAINER" \
      psql -U "$PG_USER" -d "$PG_DB" -v ON_ERROR_STOP=1 -At -F '|' "$@"
}

# Preferred path: use the simpler one-shot via the existing container.
# We pass SQL on stdin. Kept simple — if you find this hard to read, prefer the
# explicit variant above.
psqlq() {
  # -q suppresses command-status output ("INSERT 0 1") so captured values are clean;
  # -A unaligned, -t tuples-only, -F '|' field separator, -X no psqlrc.
  docker container exec -i "$PG_CONTAINER" \
    psql -U "$PG_USER" -d "$PG_DB" -v ON_ERROR_STOP=1 -AtqX -F '|'
}

command -v docker >/dev/null || { echo "FATAL: docker missing" >&2; exit 1; }
command -v jq     >/dev/null || { echo "FATAL: jq missing"     >&2; exit 1; }
command -v curl   >/dev/null || { echo "FATAL: curl missing"   >&2; exit 1; }

docker ps --format '{{.Names}}' | grep -qx "$PG_CONTAINER" || {
  echo "FATAL: $PG_CONTAINER not running" >&2; exit 1
}

log "starting"

RUN_ID=""
if [[ "$MODE" == "apply" ]]; then
  RUN_ID=$(psqlq <<'SQL'
INSERT INTO agent_memory.consolidation_runs (mode) VALUES ('apply')
RETURNING id;
SQL
  )
  log "run_id=$RUN_ID started"
fi

# Embedding step is deferred until pgvector is installed on agent-memory-postgres
# (tracked in TRZ-443). Safely no-op by detecting whether the column exists.
HAS_EMBEDDING_COL=$(psqlq <<'SQL'
SELECT COUNT(*) FROM information_schema.columns
WHERE table_schema='agent_memory' AND table_name='decisions' AND column_name='embedding';
SQL
)
NEED_EMBEDDING=0
if [[ "$HAS_EMBEDDING_COL" == "1" ]]; then
  NEED_EMBEDDING=$(psqlq <<'SQL'
SELECT COUNT(*) FROM agent_memory.decisions WHERE embedding IS NULL;
SQL
  )
fi
log "decisions needing embedding: $NEED_EMBEDDING (pgvector=$HAS_EMBEDDING_COL)"

EMBEDDED_COUNT=0
if [[ "$MODE" == "apply" && "$NEED_EMBEDDING" -gt 0 && "$HAS_EMBEDDING_COL" == "1" ]]; then
  while IFS='|' read -r id text; do
    [[ -z "$id" ]] && continue
    emb=$(curl -sS -X POST "http://127.0.0.1:32768/api/embeddings" \
      -H 'Content-Type: application/json' \
      -d "$(jq -cn --arg m "$EMBED_MODEL" --arg p "$text" '{model:$m, prompt:$p}')" \
      | jq -r '.embedding | map(tostring) | join(",")' 2>/dev/null)
    if [[ -z "$emb" ]]; then
      log "WARN: empty embedding for decision id=$id; skipping"
      continue
    fi
    psqlq <<SQL
UPDATE agent_memory.decisions
SET embedding = '[$emb]'::vector, consolidated_at = now()
WHERE id = $id;
SQL
    EMBEDDED_COUNT=$((EMBEDDED_COUNT + 1))
  done < <(psqlq <<'SQL'
SELECT id, decision || E'\n' || rationale
FROM agent_memory.decisions
WHERE embedding IS NULL
ORDER BY decided_at DESC
LIMIT 100;
SQL
  )
  log "embedded $EMBEDDED_COUNT decisions"
fi

# Dedupe — pair decisions by cosine similarity within same app_id
# Skipped entirely when pgvector isn't installed (HAS_EMBEDDING_COL check above).
DUPE_COUNT=0
DEDUPED_COUNT=0
if [[ "$HAS_EMBEDDING_COL" != "1" ]]; then
  log "skip dedupe: pgvector not installed (track on TRZ-443)"
else
DEDUP_QUERY="WITH dupes AS (
  SELECT a.id AS keep_id, b.id AS drop_id, 1 - (a.embedding <=> b.embedding) AS sim
  FROM agent_memory.decisions a
  JOIN agent_memory.decisions b
    ON a.app_id = b.app_id AND a.id > b.id
   AND a.embedding IS NOT NULL AND b.embedding IS NOT NULL
   AND a.superseded_by IS NULL AND b.superseded_by IS NULL
  WHERE 1 - (a.embedding <=> b.embedding) >= $SIM_THRESHOLD
)
SELECT keep_id, drop_id, sim FROM dupes ORDER BY sim DESC LIMIT 500;"

DUPE_COUNT=$(echo "$DEDUP_QUERY" | psqlq | wc -l | tr -d ' ')
log "duplicate pairs found (sim>=$SIM_THRESHOLD): $DUPE_COUNT"

if [[ "$MODE" == "apply" && "$DUPE_COUNT" -gt 0 ]]; then
  while IFS='|' read -r keep drop sim; do
    [[ -z "$keep" || -z "$drop" ]] && continue
    psqlq <<SQL
UPDATE agent_memory.decisions
SET superseded_by = $keep
WHERE id = $drop AND superseded_by IS NULL;
SQL
    DEDUPED_COUNT=$((DEDUPED_COUNT + 1))
  done < <(echo "$DEDUP_QUERY" | psqlq)
  log "deduped $DEDUPED_COUNT decisions"
fi
fi  # end: pgvector-gated block

OLD_SESSIONS=$(psqlq <<SQL
SELECT COUNT(*) FROM agent_memory.sessions
WHERE session_date < CURRENT_DATE - INTERVAL '$ARCHIVE_AGE_DAYS days';
SQL
)
log "sessions older than $ARCHIVE_AGE_DAYS days: $OLD_SESSIONS"

ARCHIVED_COUNT=0
if [[ "$MODE" == "apply" && "$OLD_SESSIONS" -gt 0 ]]; then
  ARCHIVED_COUNT=$(psqlq <<SQL | wc -l | tr -d ' '
WITH moved AS (
  DELETE FROM agent_memory.sessions
  WHERE session_date < CURRENT_DATE - INTERVAL '$ARCHIVE_AGE_DAYS days'
  RETURNING *
)
INSERT INTO agent_memory.sessions_archive
SELECT *, now() FROM moved
RETURNING 1;
SQL
  )
  log "archived $ARCHIVED_COUNT sessions"
fi

if [[ "$MODE" == "apply" && -n "$RUN_ID" ]]; then
  psqlq <<SQL
UPDATE agent_memory.consolidation_runs
SET finished_at=now(),
    decisions_scanned=(SELECT COUNT(*) FROM agent_memory.decisions),
    decisions_embedded=$EMBEDDED_COUNT,
    decisions_deduped=$DEDUPED_COUNT,
    sessions_scanned=(SELECT COUNT(*) FROM agent_memory.sessions)
                   + (SELECT COUNT(*) FROM agent_memory.sessions_archive),
    sessions_archived=$ARCHIVED_COUNT
WHERE id = $RUN_ID;
SQL
fi

log "done"
