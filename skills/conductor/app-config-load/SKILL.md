---
name: app-config-load
description: Load the full config (stack, repo, file ownership, conventions, overrides) for a given app_id from the Notion app registry
allowed-tools: mcp__notion__notion-fetch, mcp__notion__notion-search
---

## Purpose

The Notion page [Apps & Per-App Configuration](https://www.notion.so/344ac0ea4f65810bb4a8f6331c85a2e9) is the authoritative registry for all 8 apps in Riché's portfolio. Stack details, repo URLs, file-ownership maps, per-app conventions, and override rules live there. The Conductor must read this every session — agents never memorize stack assumptions. This skill fetches one app's row, parses the sub-page, and returns a structured JSON blob the Conductor feeds into `paperclip-create` and agent-dispatch context.

## When to invoke

- Immediately after `linear-read` resolves the target `app_id`, before assembling a work brief.
- On re-dispatch if the session spans multiple tickets in the same app — cache for the session, re-fetch if older than 30 minutes.
- During cross-app coordination — call once per `app_id` involved in the `portfolio_action_id`.

## Required env vars

- `NOTION_API_KEY` — integration has read access to the Apps & Per-App Configuration database.
- `NOTION_APP_REGISTRY_PAGE_ID` — `344ac0ea4f65810bb4a8f6331c85a2e9`

## Input

```json
{
  "app_id": "sia"
}
```

Valid values: `sia`, `website` (alias `rzcom`), `recipe-remix`, `ploppy`, `blocade`, `ascend`, `trend-analyzer`, `ai-onboarding`.

## Output

```json
{
  "app_id": "sia",
  "aliases": [],
  "description": "Personal AI knowledge system / Context Layer Engine",
  "stack": {
    "language": "python",
    "framework": "fastapi",
    "templating": "jinja2",
    "frontend": "htmx + pico css",
    "database": "postgres + pgvector"
  },
  "repo": {
    "url": "https://github.com/rczamor/sia",
    "default_branch": "main",
    "branch_convention": "agent/{role}/{app}-{ticket}-{slug}"
  },
  "hosting": "hostinger-vps",
  "linear_project_url": "https://linear.app/riche-life/project/sia-2b129975749f",
  "slack_channel": "#agent-sia",
  "file_ownership": {
    "backend-eng": ["apps/api/**", "services/**"],
    "ui-eng": ["apps/web/templates/**", "apps/web/static/**"],
    "data-eng": ["pipelines/**", "migrations/**"],
    "ai-eng": ["prompts/**", "mcp_tools/**"]
  },
  "conventions": {
    "commit_prefix": "sia/{ticket}:",
    "test_command": "pytest -q",
    "lint_command": "ruff check .",
    "deploy": "docker compose up -d on srv1535988.hstgr.cloud"
  },
  "overrides": {},
  "fetched_at": "2026-04-16T..."
}
```

## Example invocation

```
/skill app-config-load --app_id sia
/skill app-config-load --app_id website     # also accepts alias "rzcom"
```

## Implementation notes

- Resolve `app_id` against the registry's primary key column; if an alias matches (e.g. `rzcom` → `website`), populate `aliases` and use the canonical `app_id` in output.
- Reject unknown `app_id` values — Paperclip's `app_id` enum must match exactly. No fuzzy matches.
- Cache responses in-session for 30 minutes keyed on `app_id`. The registry changes rarely; a re-fetch every session start is enough.
- Retry Notion API up to 3x (1s, 2s, 4s) on 5xx or `rate_limited`. On persistent failure, fail the session — the Conductor cannot dispatch without file ownership.
- Log the fetch to Langfuse with tags `conductor` + `app_id` + `app-config-load`.
- Emit a Paperclip tool-call entry capturing the config hash — downstream agents can verify they received the same config the Conductor loaded.
- Do NOT log stack details to Slack. The config is session-scoped; exposing it clutters per-app channels.
