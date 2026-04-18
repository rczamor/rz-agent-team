# n8n workflows — Agent Team routing

Source-controlled n8n workflows for the Agent Team's Linear → Routines/Paperclip routing, plus reliability workflows (reconciler, deferred-fire drainer).

## Files

| File | Workflow | Trigger | Ticket |
|---|---|---|---|
| `linear-router.json` | Main router | Linear webhook (issue status change) | [CAR-362](https://linear.app/riche-life/issue/CAR-362) |
| `reconciler.json` | Catch missed webhooks | Schedule — every 15 min | [CAR-370](https://linear.app/riche-life/issue/CAR-370) |
| `deferred-fire-drainer.json` | Retry capped fires | Schedule — daily 00:05 UTC | [CAR-371](https://linear.app/riche-life/issue/CAR-371) |

All 3 are paired with [CAR-354](https://linear.app/riche-life/issue/CAR-354) for deployment.

---

## 1. Main router (`linear-router.json`)

Routes Linear ticket status changes to either Claude Code Routines (strategic) or Paperclip (execution).

```
Linear issue status change webhook
  ↓
  ├─ Dedup (issueId + updatedAt)
  │
  ├─ If status = "Ready for Claude routines"
  │    → read type:* label → POST to matching routine fire endpoint
  │      └─ Classify response:
  │           ├─ 200 OK → post session URL as Linear comment
  │           ├─ 429 (cap reached) → append to deferred_fires queue + Linear comment + Slack alert
  │           └─ other error → Slack alert, no retry
  │
  ├─ If status = "Ready for agent build"
  │    → POST to Paperclip API → comment task ID back on Linear
  │
  └─ Respond OK to Linear webhook
```

### 429 handling

The `Fire routine` node uses `neverError: true, fullResponse: true` so the workflow can inspect the status code. On 429 (Claude Code Routines 15/day Max plan cap), the ticket is pushed onto `deferred_fires` static data. The drainer workflow retries it tomorrow.

---

## 2. Reconciler (`reconciler.json`)

Safety net: catches Linear tickets that got stuck in a trigger status because the original webhook was dropped (n8n down, Linear webhook delivery failure, etc.).

```
Every 15 min
  ↓
Query Linear: issues in trigger statuses, updatedAt > 10 min ago
  ↓
For each ticket, check evidence of prior processing:
  ├─ Ready for Claude routines → Linear comments contain "⚙ {Routine} routine fired"
  └─ Ready for agent build → Paperclip task exists with linear_ticket_id
  ↓
If no evidence → POST to main router's webhook URL (synthetic Linear payload)
  → main router's dedup cache handles idempotency
  ↓
Slack summary to #agent-team if any reconciliations happened (silent otherwise)
```

The 10-min threshold avoids racing with in-flight main-router runs. The main router's dedup cache prevents double-firing on the rare case where a webhook arrived after the reconciler already synthesized one.

---

## 3. Deferred-fire drainer (`deferred-fire-drainer.json`)

Drains the `deferred_fires` queue (populated by the main router when it gets 429s).

```
Daily 00:05 UTC (5 min after Anthropic's daily counter resets)
  ↓
Load deferred_fires from static data
  ↓
Expire entries older than 7 days → Slack alert "❌ Expired"
  ↓
For each live entry (FIFO, oldest first):
  → POST to routine fire endpoint
  → 200: remove from queue + Linear comment "🟢 Deferred fire completed"
  → 429: stop (still at cap); entry stays in queue for next day
  → other error: remove from queue + Slack alert
  ↓
Final Slack summary: "🟢 Drained X/Y deferred fires"
```

Stop-on-429 is intentional — keeps FIFO order, doesn't burn retries when clearly still over cap.

---

## Install (see [CAR-354](https://linear.app/riche-life/issue/CAR-354) for full steps)

1. In n8n UI: **Workflows → Import from File** — import all 3 JSON files
2. Wire credentials (see env vars below) and replace `REPLACE-WITH-SLACK-CRED-ID` on every Slack node with the actual n8n Slack credential ID
3. Activate all 3 workflows
4. In Linear: configure a webhook pointing at `https://n8n.srv1535988.hstgr.cloud/webhook/linear-router`
5. Smoke test (see checklist below)

## Required env vars

Set in `/docker/n8n/.env` on the VPS:

```
# Routine fire URLs + bearer tokens — from CAR-353
# URL format per https://code.claude.com/docs/en/routines:
#   https://api.anthropic.com/v1/claude_code/routines/trig_01ABC.../fire
# Tokens are shown once in the Claude Code UI when you click "Generate token"
ROUTINE_ARCHITECT_URL=https://api.anthropic.com/v1/claude_code/routines/trig_.../fire
ROUTINE_ARCHITECT_TOKEN=sk-ant-oat01-...
ROUTINE_ANALYST_URL=...
ROUTINE_ANALYST_TOKEN=...
ROUTINE_UX_URL=...
ROUTINE_UX_TOKEN=...
ROUTINE_RESEARCH_URL=...
ROUTINE_RESEARCH_TOKEN=...

# Paperclip (multi-tenant — endpoint is /api/companies/{companyId}/issues)
PAPERCLIP_API_URL=https://paperclip-hxtc.srv1535988.hstgr.cloud
PAPERCLIP_COMPANY_ID=<companyId>   # discover from Paperclip admin UI or GET /api/companies with auth
PAPERCLIP_API_KEY=pc_...

# Linear
LINEAR_API_TOKEN=lin_api_...

# Reconciler — optional; defaults to localhost
N8N_ROUTER_WEBHOOK_URL=http://localhost:5678/webhook/linear-router
```

## Dedup + back-pressure state

Two pieces of workflow static data are used:

- `seen` (main router) — keyed on `issueId:updatedAt`. LRU-pruned to last 500 entries.
- `deferred_fires` (main router + drainer) — array of entries `{issueId, issueIdentifier, ..., routineUrl, routineToken, firePayloadText, deferredAt}`. Drained daily. Entries > 7 days old auto-expire.

Both survive workflow executions but reset on workflow delete/recreate.

## Credential nodes (n8n UI)

All Slack nodes reference credential ID `REPLACE-WITH-SLACK-CRED-ID`. Create one Slack OAuth credential named **"Slack — #agent-team"** and replace the placeholder after import (use n8n's Find & Replace in the workflow JSON, or set each node via the UI).

⚠️ **Activating before replacement silently suppresses all Slack alerts.** Every Slack node has `onError: continueRegularOutput`, so a bad credential reference won't break the main flow — but the alerts you rely on for routine-fire failures, reconciler recoveries, and drainer summaries will drop silently. **Replace the placeholder before activation.**

Pre-import sanity check (run from the repo root before importing):

```bash
if grep -R "REPLACE-WITH-SLACK-CRED-ID" n8n/*.json; then
  echo "❌ Slack credential placeholder still present — replace before activation"
  exit 1
fi
```

## Expected Linear webhook payload shape

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

After import + credentials + activation of all 3 workflows:

### Main router
- [ ] Create a test Linear ticket in the Agent Team project
- [ ] Add label `type:architect` + move to `Ready for Claude routines` → verify Architect routine fires, Linear comment posts
- [ ] Add label `type:analyst` + same status → Analyst fires
- [ ] Add label `type:ux` + same status → UX Researcher fires
- [ ] Add label `type:research` + same status → AI Researcher fires
- [ ] Add label `type:engineering` + move to `Ready for agent build` → Paperclip task created, Linear comment posts
- [ ] Retry same status change → dedup no-op (no second fire)
- [ ] Force an error (temporarily break a token, non-429) → Slack "fire failed" lands in `#agent-team`

### 429 path (harder to test without actually hitting the cap)
- [ ] If you hit 15/day: verify ticket gets "🕐 deferred" Linear comment + `#agent-team` Slack alert
- [ ] Check `deferred_fires` static data in the n8n UI (Workflows → Static Data)

### Reconciler
- [ ] Disable the main router workflow temporarily
- [ ] Move a ticket to `Ready for Claude routines` — nothing fires (expected)
- [ ] Wait 10+ minutes, re-enable the main router
- [ ] Wait for the next 15-min reconciler tick → ticket gets picked up, routine fires, Slack "🔁 reconciled" alert

### Drainer
- [ ] Manually populate `deferred_fires` with a test entry (via n8n UI static data editor) OR trigger an actual 429
- [ ] Manually run the drainer workflow (trigger → execute)
- [ ] Verify: 200 path gets Linear "🟢 drained" comment, entry removed from queue
- [ ] Verify: 429 path keeps entry, stops processing subsequent entries
- [ ] Verify: summary Slack message posts

## Notes for Riché at install time

- The `onError: continueRegularOutput` on every Slack node means a Slack outage won't block the main flow — but you won't be alerted during the outage. Consider a secondary alert channel (email?) if Slack reliability becomes a concern.
- Routine fire response shape confirmed 2026-04-18 from https://code.claude.com/docs/en/routines: `{type: "routine_fire", claude_code_session_id, claude_code_session_url}`. The `Classify fire response` node extracts these. No Langfuse trace URL is returned — the routine itself posts that when the session completes.
- Paperclip uses multi-tenant routes: `/api/companies/{companyId}/issues`. The `PAPERCLIP_COMPANY_ID` env var is required. Verified 2026-04-18 by probing the live instance (`GET /api/issues` → 400 with error message pointing at the company-scoped path).
- Paperclip issue-create response shape is not yet confirmed — the workflow's `Comment — Paperclip issue created` node tolerates `id`, `issue_id`, or `paperclip_issue_id` in the response. Inspect the first real response and tighten if needed.
- 15 runs/day cap for Claude Code Routines on Max plan. When you hit the cap the main router defers; the drainer retries at 00:05 UTC. If you're routinely hitting the cap, consider requesting additional usage billing from Anthropic.
- The reconciler calls the main router's own webhook URL. If n8n is reachable only via Traefik/HTTPS externally, the reconciler may need `N8N_ROUTER_WEBHOOK_URL` pointing at the internal Docker service name (`http://n8n:5678/webhook/linear-router`) — adjust if localhost doesn't work.
