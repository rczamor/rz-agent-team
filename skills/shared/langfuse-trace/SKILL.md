---
name: langfuse-trace
description: Start and finalize a Langfuse trace tagged with app_id, agent_role, session_id. Wraps every LLM call, tool call, and session-level event. Required on every reasoning step per the non-negotiable full-reasoning-logs rule.
allowed-tools: Bash
---

# langfuse-trace

## Purpose
Emit observability so every LLM call and tool call is traceable back to app, role, and session. Enforces the three required labels — `app_id`, `agent_role`, `session_id` — on every trace. This is rule #1 in `TEAM.md`.

## When to invoke
- `--action start` at session top; returns a `trace_id` reused for child spans.
- `--action span` around each LLM call (prompt, response, tokens, model, cost) and non-trivial tool call.
- `--action event` for handoffs, memory writes, BLOCKER posts.
- `--action finalize` at session end with status + summary.

Every agent, every session.

## Required env vars
- `LANGFUSE_HOST` — internal `http://langfuse-web:3000` or external `https://langfuse-<suffix>.srv1535988.hstgr.cloud`.
- `LANGFUSE_PUBLIC_KEY` / `LANGFUSE_SECRET_KEY` — API keys from `/docker/langfuse/.env` on VPS.
- `SESSION_APP_ID` — app tag (required label).
- `AGENT_ROLE` — one of the 11 roster roles (required label).
- `SESSION_ID` — Conductor-assigned session UUID (required label).

## Input
Flags to `scripts/langfuse_trace.sh`:
- `--action <start|span|event|finalize>` (required).
- `--name <string>` (required) — e.g. `"session.conductor.dispatch"`, `"llm.plan-review"`.
- `--trace-id <id>` (required for span/event/finalize; returned by start).
- `--parent-id <id>` (optional) — nest under another span.
- `--input <json>` / `--output <json>` (optional) — payloads for LLM/tool spans.
- `--metadata <json>` (optional) — model, tokens, cost, latency_ms, tool_name.
- `--status <success|error>` (finalize only).

## Output
JSON on stdout: `{ "trace_id": "...", "span_id": "...", "url": "https://langfuse.../trace/..." }`. Non-zero exit on API failure.

## Example invocation
```bash
TRACE=$(bash scripts/langfuse_trace.sh --action start --name "session.backend-eng.sia-CAR-198")
TRACE_ID=$(echo "$TRACE" | jq -r .trace_id)

bash scripts/langfuse_trace.sh --action span --trace-id "$TRACE_ID" \
  --name "llm.generate-migration" \
  --input '{"prompt":"..."}' --output '{"response":"..."}' \
  --metadata '{"model":"claude-opus-4-7","input_tokens":2100,"output_tokens":540,"cost_usd":0.042}'

bash scripts/langfuse_trace.sh --action finalize --trace-id "$TRACE_ID" --status success
```

## Implementation notes
- Attach `tags: [app_id, agent_role, session_id]` on the root trace; propagate to children.
- Use Langfuse SDK if available, else `curl` against `/api/public/ingestion`.
- Batch spans and flush every 5s or on `finalize`.
- Retry 5xx with backoff 1s/2s/4s; fail loud after 3 attempts.
- Prefer internal `langfuse-web:3000` from inside Docker; external URL only from outside the VPS.
- Redact `authorization` headers in stderr logs.
- Always include `cost_usd` when known — drives DevOps cost reports.
