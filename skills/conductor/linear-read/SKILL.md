---
name: linear-read
description: Read Linear tickets, list by project/status/priority, pull comments — the Conductor's read path into Riché's planning layer
allowed-tools: mcp__linear__get_issue, mcp__linear__list_issues, mcp__linear__list_comments, mcp__linear__get_project, mcp__linear__list_projects, mcp__linear__get_issue_status, mcp__linear__list_issue_statuses
---

## Purpose

Linear is Riché's planning surface. Every Conductor session starts by reading a Linear ticket (or scanning a project) to understand what was asked for. This skill wraps the Linear MCP read operations with the Conductor's conventions — app-scoped filtering, deterministic output shape, and automatic Paperclip cross-referencing — so downstream skills (`paperclip-create`, `app-config-load`) receive predictable input.

## When to invoke

- **Session start, single ticket:** Riché references `sia/CAR-198` in Slack — fetch that ticket before loading app config.
- **Session start, project sweep:** Riché says "pick up the next Sia thing" — list open tickets in the `sia` Linear project filtered by status + priority.
- **Review pass:** before approving a Paperclip-completed ticket, re-read the Linear ticket + comments to confirm acceptance criteria haven't shifted.
- **Handoff capture:** when closing a session, read the latest comment thread to pick up any last-minute Riché input.

## Required env vars

- `LINEAR_API_KEY` — Conductor instance has write scope (comments, status transitions). Other roles are read-only.

## Input

```json
{
  "mode": "get_issue | list_issues | list_comments",
  "issue_id": "CAR-198",              // get_issue, list_comments
  "project_id": "sia-2b129975749f",   // list_issues
  "status": ["Todo", "In Progress"],  // list_issues, optional
  "priority": [1, 2],                 // list_issues, optional (1=urgent, 2=high)
  "since": "2026-04-01T00:00:00Z"     // list_comments, optional
}
```

## Output

```json
{
  "mode": "get_issue",
  "issue": {
    "id": "CAR-198",
    "app_id": "sia",
    "title": "...",
    "description_md": "...",
    "status": "Todo",
    "priority": 2,
    "project": "Sia",
    "labels": ["backend", "context-layer"],
    "url": "https://linear.app/riche-life/issue/CAR-198",
    "paperclip_issue_id": null,
    "langfuse_session_id": null
  },
  "fetched_at": "2026-04-16T..."
}
```

For `list_issues` return `{ issues: [...] }`. For `list_comments` return `{ comments: [{ author, created_at, body_md, references: { paperclip_ids, langfuse_ids } }] }` — parse comment bodies for `paperclip:` and `langfuse:` tokens.

## Example invocation

```
/skill linear-read --mode get_issue --issue_id CAR-198
/skill linear-read --mode list_issues --project_id sia-2b129975749f --status "Todo,In Progress" --priority 1,2
```

## Implementation notes

- Derive `app_id` from the Linear project slug (see `USER.md` project URLs) — never trust a free-text field.
- Retry Linear API calls up to 3x with exponential backoff (1s, 2s, 4s). Rate limit: 1500 req/hr per token.
- Log every call to Langfuse with tags `conductor` + `app_id` + `linear-read`.
- Emit a Paperclip tool-call entry: `tool=linear-read, input=<args>, output_hash=<sha256>` so the audit log captures what the Conductor read.
- If a ticket's body or latest comment references a Paperclip issue ID, surface it in the output — downstream `paperclip-create` uses it to detect duplicates.
