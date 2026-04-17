-- agent_memory schema initialization
-- Mirrors the design in Notion "Agent Memory & Context Management" page.
--
-- Target: dedicated `agent-memory-postgres` container on the VPS
--   - Compose project: /docker/agent-memory/
--   - Image: postgres:17
--   - Bind: 127.0.0.1:54330 -> container 5432
--   - Database: agent_memory
--   - User: agent_memory (owner)
--   - Password: see /docker/agent-memory/.env on the VPS (not committed)
--
-- Apply with:
--   docker exec agent-memory-postgres psql -U agent_memory -d agent_memory \
--     -v ON_ERROR_STOP=1 -f /tmp/init.sql

CREATE SCHEMA IF NOT EXISTS agent_memory;

-- Architectural and design decisions that all agents must respect
CREATE TABLE IF NOT EXISTS agent_memory.decisions (
    id SERIAL PRIMARY KEY,
    app_id TEXT NOT NULL,
    ticket_id TEXT,
    decision TEXT NOT NULL,
    rationale TEXT NOT NULL,
    alternatives_considered TEXT,
    decided_by TEXT NOT NULL,
    decided_at TIMESTAMPTZ DEFAULT now(),
    superseded_by INTEGER REFERENCES agent_memory.decisions(id),
    tags TEXT[]
);

-- Code patterns and conventions established during implementation
CREATE TABLE IF NOT EXISTS agent_memory.patterns (
    id SERIAL PRIMARY KEY,
    app_id TEXT NOT NULL,
    pattern_name TEXT NOT NULL,
    description TEXT NOT NULL,
    example_file TEXT,
    established_by TEXT NOT NULL,
    established_at TIMESTAMPTZ DEFAULT now(),
    tags TEXT[]
);

-- Research findings from Researcher agent
CREATE TABLE IF NOT EXISTS agent_memory.findings (
    id SERIAL PRIMARY KEY,
    app_id TEXT NOT NULL,
    ticket_id TEXT,
    topic TEXT NOT NULL,
    question TEXT NOT NULL,
    summary TEXT NOT NULL,
    details TEXT,
    sources JSONB,
    notion_page_url TEXT,
    researched_by TEXT NOT NULL DEFAULT 'researcher',
    researched_at TIMESTAMPTZ DEFAULT now(),
    confidence TEXT CHECK (confidence IN ('low', 'medium', 'high')),
    superseded_by INTEGER REFERENCES agent_memory.findings(id),
    tags TEXT[]
);

-- Design decisions from Designer agent
CREATE TABLE IF NOT EXISTS agent_memory.design_decisions (
    id SERIAL PRIMARY KEY,
    app_id TEXT NOT NULL,
    ticket_id TEXT,
    surface TEXT NOT NULL,
    decision TEXT NOT NULL,
    rationale TEXT NOT NULL,
    alternatives_considered TEXT,
    notion_page_url TEXT,
    decided_by TEXT NOT NULL DEFAULT 'designer',
    decided_at TIMESTAMPTZ DEFAULT now(),
    superseded_by INTEGER REFERENCES agent_memory.design_decisions(id),
    tags TEXT[]
);

-- Work context transferred between agents
CREATE TABLE IF NOT EXISTS agent_memory.handoffs (
    id SERIAL PRIMARY KEY,
    app_id TEXT NOT NULL,
    from_agent TEXT NOT NULL,
    to_agent TEXT NOT NULL,
    ticket_id TEXT,
    context TEXT NOT NULL,
    files_changed TEXT[],
    decisions_referenced INTEGER[],
    findings_referenced INTEGER[],
    design_decisions_referenced INTEGER[],
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'picked_up', 'completed')),
    created_at TIMESTAMPTZ DEFAULT now(),
    picked_up_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ
);

-- Known issues, blockers, and things to watch out for
CREATE TABLE IF NOT EXISTS agent_memory.blockers (
    id SERIAL PRIMARY KEY,
    app_id TEXT NOT NULL,
    description TEXT NOT NULL,
    severity TEXT CHECK (severity IN ('minor', 'major', 'critical')),
    reported_by TEXT NOT NULL,
    ticket_id TEXT,
    resolved BOOLEAN DEFAULT FALSE,
    resolved_by TEXT,
    resolved_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Session summaries — what happened in each work session
CREATE TABLE IF NOT EXISTS agent_memory.sessions (
    id SERIAL PRIMARY KEY,
    app_id TEXT NOT NULL,
    session_date DATE DEFAULT CURRENT_DATE,
    conductor_summary TEXT NOT NULL,
    tickets_worked TEXT[],
    agents_active TEXT[],
    decisions_made INTEGER[],
    findings_produced INTEGER[],
    design_decisions_made INTEGER[],
    langfuse_session_id TEXT,
    paperclip_issue_ids TEXT[],
    related_session_id INTEGER REFERENCES agent_memory.sessions(id),
    portfolio_action_id TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_decisions_app ON agent_memory.decisions (app_id);
CREATE INDEX IF NOT EXISTS idx_decisions_tags ON agent_memory.decisions USING GIN (tags);
CREATE INDEX IF NOT EXISTS idx_decisions_ticket ON agent_memory.decisions (ticket_id);
CREATE INDEX IF NOT EXISTS idx_patterns_app ON agent_memory.patterns (app_id);
CREATE INDEX IF NOT EXISTS idx_patterns_tags ON agent_memory.patterns USING GIN (tags);
CREATE INDEX IF NOT EXISTS idx_findings_app ON agent_memory.findings (app_id);
CREATE INDEX IF NOT EXISTS idx_findings_tags ON agent_memory.findings USING GIN (tags);
CREATE INDEX IF NOT EXISTS idx_design_decisions_app ON agent_memory.design_decisions (app_id);
CREATE INDEX IF NOT EXISTS idx_design_decisions_surface ON agent_memory.design_decisions (surface);
CREATE INDEX IF NOT EXISTS idx_handoffs_app ON agent_memory.handoffs (app_id);
CREATE INDEX IF NOT EXISTS idx_handoffs_status ON agent_memory.handoffs (status);
CREATE INDEX IF NOT EXISTS idx_handoffs_to ON agent_memory.handoffs (to_agent);
CREATE INDEX IF NOT EXISTS idx_blockers_app ON agent_memory.blockers (app_id);
CREATE INDEX IF NOT EXISTS idx_blockers_resolved ON agent_memory.blockers (resolved);
CREATE INDEX IF NOT EXISTS idx_sessions_app ON agent_memory.sessions (app_id);
CREATE INDEX IF NOT EXISTS idx_sessions_date ON agent_memory.sessions (session_date);
CREATE INDEX IF NOT EXISTS idx_sessions_portfolio ON agent_memory.sessions (portfolio_action_id);
