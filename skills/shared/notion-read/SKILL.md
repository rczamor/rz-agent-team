---
name: notion-read
description: Fetch Notion pages by URL or ID and return structured content (title, blocks, child databases). Use to load the app registry, spec pages, design docs, or any Notion source referenced by URL during a session.
allowed-tools: Bash
---

# notion-read

## Purpose
Read-only Notion fetch. Primary use: load the [Apps & Per-App Configuration](https://www.notion.so/344ac0ea4f65810bb4a8f6331c85a2e9) registry at session start to resolve `app_id` to stack, repo, channel, file ownership. Also per-app specs, design decisions, research briefs. Never writes.

## When to invoke
- Conductor at session start: load app registry.
- Any agent when a Linear ticket, handoff, or Slack message references a Notion URL.
- Researcher verifying prior briefs; Designer loading prior design decisions; Tech Writer resolving spec URLs.

## Required env vars
- `NOTION_API_TOKEN` — integration token with read access to Riché's workspace. Sourced from VPS secrets.
- `NOTION_API_VERSION` — defaults to `2022-06-28` if unset.

## Input
Flags to `scripts/notion_read.sh`:
- `--url <notion-url>` OR `--id <page-or-database-id>` (one required). URL is normalized to ID.
- `--include <csv>` (optional) — `blocks,children,database_rows`. Default: `blocks,children`.
- `--max-depth <n>` (optional) — recursion depth for nested blocks. Default: 2.
- `--format <json|md>` (optional) — default `json`.

## Output
JSON on stdout:
```json
{
  "id": "344ac0ea4f65810bb4a8f6331c85a2e9",
  "type": "page|database",
  "title": "Apps & Per-App Configuration",
  "url": "https://www.notion.so/...",
  "last_edited": "2026-04-15T...",
  "properties": { ... },
  "blocks": [ { "type": "...", "text": "...", "children": [...] } ],
  "child_databases": [ { "id": "...", "title": "..." } ]
}
```
Markdown mode returns the page rendered to `# Title` + block text. No HTML.

## Example invocation
```bash
bash scripts/notion_read.sh \
  --url "https://www.notion.so/344ac0ea4f65810bb4a8f6331c85a2e9" \
  --include blocks,children,database_rows \
  --format json
```

## Implementation notes
- Extract the 32-char page ID from any Notion URL (last path segment, strip dashes).
- Rate limit: Notion caps at ~3 req/s. Implement exponential backoff on 429 (1s, 2s, 4s) — 5 retries then fail loud.
- Paginate `blocks.children.list` via `next_cursor` until exhausted.
- For database pages, also fetch `databases.query` with `page_size=100` when `database_rows` included.
- Log the fetched ID + block count to stderr for Paperclip.
- Do not cache across sessions — app registry changes frequently; always fetch fresh at session start.
- Redact any `properties.email` / token-like fields before returning — pages may contain secrets.
