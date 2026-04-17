---
name: memory-read
description: Query agent_memory Postgres at session start, filtered by app_id per the 2026-04-16 memory contract. Invoke when starting any session or needing prior decisions, patterns, findings, design_decisions, handoffs, blockers, or sessions for the current app.
allowed-tools: Bash, Read
---

# memory-read

## Purpose
Load prior team knowledge for the current app at session start. Every agent in the 11-agent roster runs this before doing work. Enforces the app-scoping rule: `WHERE app_id IN ('{session_app}', 'global')` — never returns rows from other apps. Output is the starting context the agent reasons against.

## When to invoke
- First action of every session, after the Conductor declares `app_id`.
- Before making any architectural decision (check `decisions` + `design_decisions`).
- Before starting work a prior agent handed off (check `handoffs`).
- When resuming after a blocker (check `blockers`).
- When the Conductor writes a session summary (read last `sessions` row for the app).

## Required env vars
- `AGENT_MEMORY_DSN` — Postgres connection string. Internal VPS form: `postgresql://agent_memory:{pw}@agent-memory-postgres:5432/agent_memory`. Sourced from `/docker/agent-memory/.env` on VPS. Never hardcode.
- `SESSION_APP_ID` — current session's app (e.g. `sia`, `website`, `global`).
- `SESSION_ID` — conductor-assigned session UUID (used for logging only).

## Input
Flags to `scripts/memory_read.sh`:
- `--app-id <id>` (required) — session app.
- `--tables <csv>` (optional) — subset of `decisions,patterns,findings,design_decisions,handoffs,blockers,sessions`. Default: all.
- `--days <n>` (optional) — lookback window. Default: 30.
- `--limit <n>` (optional) — per-table row cap. Default: 50.

## Output
JSON on stdout:
```json
{
  "app_id": "sia",
  "queried_at": "2026-04-16T12:00:00Z",
  "decisions": [...],
  "patterns": [...],
  "findings": [...],
  "design_decisions": [...],
  "handoffs": [...],
  "blockers": [...],
  "sessions": [...]
}
```
Each row preserves its table's columns. Empty arrays if no rows.

## Example invocation
```bash
AGENT_MEMORY_DSN="$(grep AGENT_MEMORY_DSN /docker/agent-memory/.env | cut -d= -f2-)" \
SESSION_APP_ID=sia \
bash scripts/memory_read.sh --app-id sia --tables decisions,patterns,handoffs --days 14
```

## Implementation notes
- Always filter `WHERE app_id IN ('{SESSION_APP_ID}', 'global')`. Never query without this clause.
- Order each result `ORDER BY created_at DESC LIMIT {limit}`.
- Use `psql --csv` piped through `jq` to build JSON; psycopg acceptable if available.
- Log query shape + row counts to stderr so Paperclip captures the read.
- Fail loud if `SESSION_APP_ID` is unset — silent empty reads are a bug.
- `sessions` table: return only the last 5 rows regardless of `--limit`.
