-- 0002: findings → findings_references
--
-- Per the 2026-04-17 architecture refactor (Agent Memory & Context Management Notion page):
-- research now lives in Notion, owned by the AI Researcher and User Researcher strategic routines.
-- The agent_memory schema keeps only a lightweight index pointing at the Notion artifacts.
--
-- Context: the original `findings` table (0001) stored full research content; it's replaced
-- by `findings_references` which stores (topic, summary, notion_page_url, referenced_in).
-- Execution agents store a reference and fetch the full document from Notion on demand.
--
-- Tracking: CAR-359. Applied to VPS 2026-04-18.
--
-- Apply with:
--   docker exec -i agent-memory-postgres psql -U agent_memory -d agent_memory \
--     -v ON_ERROR_STOP=1 -f 0002_rename_findings_to_references.sql
--
-- NOTE: If `agent_memory.findings` has rows, this migration will drop them. Verify empty first:
--   docker exec agent-memory-postgres psql -U agent_memory -d agent_memory \
--     -c 'SELECT COUNT(*) FROM agent_memory.findings;'
-- If non-zero, do not run this file — back up rows and design a data migration first.

BEGIN;

CREATE TABLE agent_memory.findings_references (
    id SERIAL PRIMARY KEY,
    app_id TEXT NOT NULL,
    topic TEXT NOT NULL,
    summary TEXT NOT NULL,
    notion_page_url TEXT NOT NULL,
    referenced_in TEXT[],
    created_at TIMESTAMPTZ DEFAULT now(),
    tags TEXT[]
);

CREATE INDEX idx_findings_refs_app ON agent_memory.findings_references (app_id);
CREATE INDEX idx_findings_refs_tags ON agent_memory.findings_references USING GIN (tags);

DROP TABLE agent_memory.findings;

COMMENT ON TABLE agent_memory.findings_references IS
  'Lightweight pointer to Notion research artifacts (strategic routines write the full document; execution agents store an index entry here). Replaces the old findings table per CAR-359 (2026-04-18).';

-- The handoffs.findings_referenced column name is preserved deliberately: its value is an
-- integer array of ids in the referenced table, and many identity files already refer to it
-- as 'findings_referenced'. The column now points to findings_references.id values.
COMMENT ON COLUMN agent_memory.handoffs.findings_referenced IS
  'Array of findings_references.id (renamed target, unchanged column name for compatibility).';

COMMIT;
