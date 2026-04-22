-- 0003: sessions archive + consolidation audit log
--
-- Enables the nightly consolidation cron (scripts/consolidate-agent-memory.sh):
--   1. Archive `sessions` older than 90 days to `sessions_archive`
--   2. Track per-run stats in `consolidation_runs`
--   3. (Pending pgvector availability): embed `decisions` + dedupe via cosine
--      similarity. Not included here because the `agent-memory-postgres`
--      container uses stock postgres:17 without pgvector. See TRZ-443 for the
--      follow-up ticket to swap to `pgvector/pgvector:pg17`.
--
-- Tracking: TRZ-441. Purely additive — no drops, no renames.
--
-- Apply with:
--   docker cp migrations/0003_sessions_archive_and_consolidation.sql \
--     agent-memory-postgres:/tmp/0003.sql
--   docker exec agent-memory-postgres psql -U agent_memory -d agent_memory \
--     -v ON_ERROR_STOP=1 -f /tmp/0003.sql

BEGIN;

-- ---- Decisions: tracking consolidation passes ------------------------------
-- The existing `superseded_by` column (from 0001) already links duplicates.
-- We add `consolidated_at` so the consolidation job can tell which rows it has
-- already evaluated (idempotent re-runs).
--
-- `embedding` column deferred until pgvector is available on the container.
-- When TRZ-443 lands, add via a follow-up migration 0004.

ALTER TABLE agent_memory.decisions
  ADD COLUMN IF NOT EXISTS consolidated_at TIMESTAMPTZ;

COMMENT ON COLUMN agent_memory.decisions.consolidated_at IS
  'Timestamp of last consolidation pass that evaluated this row. Used for incremental runs.';


-- ---- Sessions archive ------------------------------------------------------
-- Same schema as the live sessions table (plus an archived_at column), so the
-- consolidation job can MOVE rows wholesale without ALTER magic.

CREATE TABLE IF NOT EXISTS agent_memory.sessions_archive (
    LIKE agent_memory.sessions INCLUDING ALL
);

ALTER TABLE agent_memory.sessions_archive
  ADD COLUMN IF NOT EXISTS archived_at TIMESTAMPTZ DEFAULT now();

CREATE INDEX IF NOT EXISTS idx_sessions_archive_app
  ON agent_memory.sessions_archive (app_id);

CREATE INDEX IF NOT EXISTS idx_sessions_archive_date
  ON agent_memory.sessions_archive (session_date);

COMMENT ON TABLE agent_memory.sessions_archive IS
  'Sessions older than 90 days moved here by the nightly consolidation cron. Live queries read agent_memory.sessions only (fast hot path). Union both tables when historical reach is needed.';


-- ---- Consolidation audit log -----------------------------------------------
-- Every consolidation run appends one row here: grep-able trail of what the
-- cron did and when, plus weekly-report fodder.

CREATE TABLE IF NOT EXISTS agent_memory.consolidation_runs (
    id SERIAL PRIMARY KEY,
    started_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    finished_at TIMESTAMPTZ,
    mode TEXT NOT NULL CHECK (mode IN ('dry-run', 'apply')),
    decisions_scanned INTEGER NOT NULL DEFAULT 0,
    decisions_embedded INTEGER NOT NULL DEFAULT 0,   -- always 0 until pgvector lands
    decisions_deduped INTEGER NOT NULL DEFAULT 0,    -- always 0 until pgvector lands
    sessions_scanned INTEGER NOT NULL DEFAULT 0,
    sessions_archived INTEGER NOT NULL DEFAULT 0,
    errors TEXT[],
    notes TEXT
);

CREATE INDEX IF NOT EXISTS idx_consolidation_runs_started
  ON agent_memory.consolidation_runs (started_at DESC);

COMMENT ON TABLE agent_memory.consolidation_runs IS
  'One row per consolidation cron run. Provides a grep-able audit trail and data for the weekly memory health report.';

COMMIT;
