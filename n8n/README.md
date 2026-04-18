# n8n workflow — Linear Router

Source-controlled n8n workflow that routes Linear ticket status changes to either Claude Code Routines (strategic layer) or Paperclip (execution layer). Paired with [CAR-354](https://linear.app/riche-life/issue/CAR-354) (install) and [CAR-362](https://linear.app/riche-life/issue/CAR-362) (this draft).

## What it does

```
Linear issue status change webhook
  ↓
  ├─ dedup (issueId + updatedAt)
  │
  ├─ If status = "Ready for Claude routines"
  │    → read type:* label
  │    → POST to matching routine fire endpoint (bearer auth)
  │    → comment session URL back on Linear
  │
  ├─ If status = "Ready for agent build"
  │    → POST to Paperclip API (creates task)
  │    → comment task ID back on Linear
  │
  └─ Error → Slack alert to #agent-team
```

## Files

- `linear-router.json` — n8n workflow export, import-ready
- `README.md` — this file

## Install (see [CAR-354](https://linear.app/riche-life/issue/CAR-354) for full steps)

1. In n8n UI: **Workflows → Import from File** → pick `linear-router.json`
2. Wire credentials (see env vars below)
3. Activate the workflow
4. In Linear: configure a webhook pointing at the n8n webhook URL (`https://n8n.srv1535988.hstgr.cloud/webhook/linear-router`)
5. Smoke test: move a test Linear ticket through each trigger status

## Required env vars

Set in `/docker/n8n/.env` on the VPS:

```
ROUTINE_ARCHITECT_URL=https://api.anthropic.com/v1/.../{routine_id}/fire
ROUTINE_ARCHITECT_TOKEN=sk-...
ROUTINE_ANALYST_URL=...
ROUTINE_ANALYST_TOKEN=...
ROUTINE_UX_URL=...
ROUTINE_UX_TOKEN=...
ROUTINE_RESEARCH_URL=...
ROUTINE_RESEARCH_TOKEN=...

PAPERCLIP_API_URL=https://paperclip-hxtc.srv1535988.hstgr.cloud
PAPERCLIP_API_KEY=pc_...

LINEAR_API_TOKEN=lin_api_...
```

Fire URLs and tokens come from [CAR-353](https://linear.app/riche-life/issue/CAR-353) (routines creation).

## Credential nodes (n8n UI)

The workflow uses env vars directly for most auth, but the Slack error node uses an n8n Slack credential. Create:
- **Slack — #agent-team** (OAuth) and replace `REPLACE-WITH-SLACK-CRED-ID` in the import with the actual credential ID, or set it in the UI after import.

## Dedup

The `Dedup + Parse` code node uses workflow static data keyed on `issueId:updatedAt`. Retries of the same status change are no-ops. The cache is pruned to the last 500 entries to stay bounded.

## Expected Linear webhook payload shape

The workflow expects Linear's standard issue-update webhook payload:

```json
{
  "action": "update",
  "data": {
    "id": "uuid",
    "identifier": "CAR-360",
    "title": "...",
    "description": "...",
    "url": "https://linear.app/...",
    "updatedAt": "2026-04-18T...",
    "state": { "name": "Ready for Claude routines" },
    "labels": [
      { "name": "type:architect" },
      { "name": "sia" }
    ]
  }
}
```

The first non-`type:*` label is taken as `app_id`. If none is present, `app_id` defaults to `global`.

## Smoke test checklist

After import + credentials + activation:

- [ ] Create a test Linear ticket in the Agent Team project
- [ ] Add label `type:architect` + move to `Ready for Claude routines` → verify Architect routine fires, Linear comment posts
- [ ] Add label `type:analyst` + same status → Analyst fires
- [ ] Add label `type:ux` + same status → UX Researcher fires
- [ ] Add label `type:research` + same status → AI Researcher fires
- [ ] Add label `type:engineering` + move to `Ready for agent build` → Paperclip task created, Linear comment posts
- [ ] Retry same status change → second invocation is a no-op (dedup works)
- [ ] Force an error (temporarily break a token) → Slack alert lands in `#agent-team`

## Notes for Riché at install time

- The `onError: continueRegularOutput` on the Slack node means a Slack outage won't block the main flow — but you won't be alerted. Consider adding a secondary alert channel.
- The routine fire response shape (`session_url`, `langfuse_trace_url`) is assumed based on the Claude Code Routines API docs. Verify after first smoke test and update the comment template if the fields differ.
- The Paperclip API response shape (`task_id` or `id`) is assumed. Verify after first smoke test.
- 15 runs/day cap for routines — the router will fire without rate limiting from n8n side. If you hit the cap, add a counter node upstream of the fire (out of scope for this initial workflow).
