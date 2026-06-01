-- 0004: pgvector embeddings for decisions
--
-- Unlocks the deferred embed + dedupe path in the nightly consolidation cron
-- (scripts/consolidate-agent-memory.sh):
--   1. Enable the pgvector extension (`vector` type + operators)
--   2. Add a 768-dim `embedding` column to `decisions` (nomic-embed-text dims)
--   3. Add an HNSW index over the embeddings using cosine distance (`<=>`),
--      matching the dedupe query's `1 - (a.embedding <=> b.embedding)` similarity
--
-- PREREQUISITE: the agent-memory-postgres container must run an image with
-- pgvector available. Migration 0001-0003 ran on stock `postgres:17`, which
-- lacks the extension. TRZ-443 swaps the image to `pgvector/pgvector:pg17`
-- (same Postgres 17, pgvector baked in) — do that BEFORE applying this file,
-- otherwise `CREATE EXTENSION vector` fails with "extension not available".
--
-- Tracking: TRZ-443. Purely additive — no drops, no renames. Idempotent.
--
-- Apply with:
--   docker cp migrations/0004_pgvector_embeddings.sql \
--     agent-memory-postgres:/tmp/0004.sql
--   docker exec agent-memory-postgres psql -U agent_memory -d agent_memory \
--     -v ON_ERROR_STOP=1 -f /tmp/0004.sql

BEGIN;

-- ---- Extension -------------------------------------------------------------
-- Requires an image that ships pgvector (pgvector/pgvector:pg17). The data
-- volume persists across the image swap, so no reload is needed.
CREATE EXTENSION IF NOT EXISTS vector;

-- ---- Embedding column ------------------------------------------------------
-- 768 dimensions to match the local Ollama embed model (nomic-embed-text,
-- 768-dim F16) the consolidation cron calls at http://127.0.0.1:32768.
ALTER TABLE agent_memory.decisions
  ADD COLUMN IF NOT EXISTS embedding vector(768);

COMMENT ON COLUMN agent_memory.decisions.embedding IS
  'nomic-embed-text (768-dim) embedding of decision || rationale. Populated by the nightly consolidation cron; used for cosine-similarity dedupe.';

-- ---- HNSW index ------------------------------------------------------------
-- vector_cosine_ops to match the cron's cosine-distance operator (`<=>`).
-- Partial index (WHERE embedding IS NOT NULL) keeps it lean while most rows
-- are still unembedded on first rollout.
CREATE INDEX IF NOT EXISTS idx_decisions_embedding
  ON agent_memory.decisions USING hnsw (embedding vector_cosine_ops)
  WHERE embedding IS NOT NULL;

COMMIT;
