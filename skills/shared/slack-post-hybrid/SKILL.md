---
name: slack-post-hybrid
description: Post a structured agent message to Slack with hybrid channel routing — #agent-{app_id} for per-app work, #agent-team for portfolio-wide. Use for every required message type STATUS, HANDOFF, QUESTION, BLOCKER, REVIEW, DESIGN, RESEARCH, NEW APP, CROSS-APP.
allowed-tools: Bash
---

# slack-post-hybrid

## Purpose
Single entrypoint for every Slack message. Enforces the hybrid channel model from `TEAM.md`: per-app messages to `#agent-{app_id}`, portfolio/global to `#agent-team`. Enforces the required message-type schema so Riché's Slack stays parseable.

## When to invoke
- **STATUS** — starting or completing work.
- **HANDOFF** — passing work to the next agent.
- **QUESTION** — ambiguity needing Conductor/Riché input.
- **BLOCKER** — blocked; name owner and ask.
- **REVIEW** — PR ready for Conductor.
- **DESIGN** (Designer) / **RESEARCH** (Researcher) — deliverable ready.
- **NEW APP** / **CROSS-APP** (Conductor only) — portfolio-level.

Silent agents are broken agents.

## Required env vars
- `SLACK_BOT_TOKEN` — bot token for the agent-team workspace.
- `SESSION_APP_ID` — current app; determines channel unless `--channel global`.
- `AGENT_HANDLE` — posting agent's Slack handle (e.g. `@conductor`).

## Input
Flags to `scripts/slack_post_hybrid.sh`:
- `--type <STATUS|HANDOFF|QUESTION|BLOCKER|REVIEW|DESIGN|RESEARCH|NEW_APP|CROSS_APP>` (required).
- `--app-id <id>` (required) — session app; routes to `#agent-{id}`. Pass `global` to target `#agent-team`.
- `--ticket <app/ticket>` (required except NEW_APP, CROSS_APP) — e.g. `sia/CAR-198`.
- `--body <text>` (required) — message body matching the type's schema in `TEAM.md`.
- `--thread-ts <ts>` (optional) — reply in thread.

## Output
JSON on stdout: `{ "ok": true, "channel": "#agent-sia", "ts": "1713268800.000100", "permalink": "https://..." }`. Non-zero exit on API failure.

## Example invocation
```bash
bash scripts/slack_post_hybrid.sh \
  --type STATUS \
  --app-id sia \
  --ticket sia/CAR-198 \
  --body "Starting work on sia/CAR-198 — adding pgvector HNSW index to embeddings table."
```

Cross-app (Conductor) — post sub-steps in per-app channels plus a summary in `#agent-team`:
```bash
bash scripts/slack_post_hybrid.sh --type CROSS_APP --app-id global --body "CROSS-APP: ..."
```

## Implementation notes
- Channel: `app-id=global` → `#agent-team`; else `#agent-{app-id}`.
- Body must start with the type token (`STATUS: ...`); reject mismatches.
- Enforce ticket regex `^[a-z0-9-]+/[A-Z]+-\d+$` on `--ticket`.
- Retry on Slack 429 with `Retry-After`; 3 attempts then fail loud.
- Log channel + ts to stderr for Paperclip.
- Never DM Riché — always channels.
- NEW_APP and CROSS_APP are Conductor-only; enforced by role IDENTITY.md, not this skill.
