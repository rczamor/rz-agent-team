# n8n workflows — Agent Team routing + watchdog

Source-controlled n8n workflows for the Agent Team's Linear → Routines/Paperclip routing, reliability workflows (reconciler, deferred-fire drainer), and the cost/health watchdog (TRZ-439).

## Files

| File | Workflow | Trigger | Ticket |
|---|---|---|---|
| `linear-router.json` | Main router | Linear webhook (issue status change) | [CAR-362](https://linear.app/riche-life/issue/CAR-362) |
| `reconciler.json` | Catch missed webhooks | Schedule — every 15 min | [CAR-370](https://linear.app/riche-life/issue/CAR-370) |
| `deferred-fire-drainer.json` | Retry capped fires | Schedule — daily 00:05 UTC | [CAR-371](https://linear.app/riche-life/issue/CAR-371) |
| `watchdog-health.json` | Hourly agent health scraper | Schedule — every 1h | [TRZ-439](https://linear.app/riche-life/issue/TRZ-439) |
| `watchdog-cost.json` | Daily cost summary | Schedule — daily 08:05 UTC | [TRZ-439](https://linear.app/riche-life/issue/TRZ-439) |
| `watchdog-canary.json` | Weekly strategic-routine canary | Schedule — Mondays 09:00 UTC | [TRZ-439](https://linear.app/riche-life/issue/TRZ-439) |

Routing workflows (first 3) are paired with [CAR-354](https://linear.app/riche-life/issue/CAR-354) for deployment. Watchdog workflows (last 3) are paired with TRZ-439.

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
  │    → Find-or-create a `linear:{identifier}` label in Paperclip
  │    → POST to Paperclip API with `labelIds: [<that-label-uuid>]`
  │    → comment task ID back on Linear
  │
  └─ Respond OK to Linear webhook
```

### Why the `linear:{identifier}` label

Paperclip's `createIssueSchema` (`@paperclipai/shared/validators/issue.js`) only accepts a narrow set of fields — `title`, `description`, `priority`, `labelIds`, etc. Extra fields like `linear_ticket_id` are silently dropped. To preserve the Linear ↔ Paperclip link in a way the reconciler can query, the router creates a one-off label per Linear ticket (`linear:RIC-17` style) and tags the Paperclip issue with it. The reconciler then filters issues via `GET /api/companies/:id/issues?labelId=<uuid>`. Find-or-create is done in two steps (`GET /labels` → search by name → `POST /labels` if missing) because Paperclip's label-create endpoint is a plain insert with no upsert semantics.

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
  └─ Ready for agent build → A `linear:{identifier}` label exists in Paperclip
                              AND at least one issue is tagged with it
                              (GET /labels → resolve UUID → GET /issues?labelId=UUID)
                              If the label doesn't exist, the ticket is treated as
                              missed and re-fired.
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

---

## 4. Watchdog — Hourly Health (`watchdog-health.json`)

Polls Langfuse for the last hour's traces, tallies errors per agent role, alerts if any role has 3+ errors.

```
Every 1h
  ↓
GET /api/public/traces?fromTimestamp=<1h ago>   (Langfuse, HTTP Basic auth with PK/SK)
  ↓
Group by metadata.agent_role → count traces where level=ERROR
  ↓
If any role has ≥ 3 errors → Slack #agent-team alert with role + error count + sample message
Silent on happy path
```

**Why Langfuse rather than docker logs:** every LLM call is already traced with agent_role, app_id, error level, and cost — no SSH / docker exec needed from n8n. Cleaner, fewer moving parts.

---

## 5. Watchdog — Daily Cost Summary (`watchdog-cost.json`)

```
Daily 08:05 UTC
  ↓
GET /api/public/traces?fromTimestamp=<24h ago>   (Langfuse)
  ↓
Sum totalCost grouped by agent_role
  ↓
Slack #agent-team: "💸 Agent team yesterday: $X total. Top roles: conductor=$a, ai-eng=$b, ..."
If total > $10/day threshold → escalate with 🚨 prefix
```

Threshold is `alertThreshold` in the Code node (default `10`). Adjust per your comfort.

---

## 6. Watchdog — Weekly Strategic-Routine Canary (`watchdog-canary.json`)

Smoke-tests the 4 strategic routines end-to-end every Monday. Catches drift in routine setup (expired tokens, Notion permission changes, Langfuse creds, etc.).

```
Mondays 09:00 UTC
  ↓
For each of the 4 routines (architect, analyst, ux, research):
  1. Linear GraphQL: create a known-good canary ticket with matching type:* label
  2. Linear GraphQL: flip to "Ready for Claude routines" (fires main router → routine)
  3. Wait 30 min
  4. Linear GraphQL: fetch ticket comments
  5. Check for: "routine fired" marker, "✓ complete" marker, Notion URL
  6. If any marker missing → Slack #agent-team alert with which step failed
```

Canary tickets stay in Linear (not archived automatically). Cleanup is a manual step — filter by `[Canary <date>]` in the title.

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

# REQUIRED: allow Code and HTTP Request nodes to read $env.* variables.
# n8n 1.x blocks this by default. Without it, Pick routine errors with
# "access to env vars denied" and the workflow fails silently into the
# fire-failed Slack alert with blank placeholders.
N8N_BLOCK_ENV_ACCESS_IN_NODE=false

# --- Watchdog (TRZ-439) additional env vars ---

# Linear team ID (Riche Zamor team — `TRZ` prefix). Used by weekly canary workflow.
LINEAR_TEAM_ID=<uuid from Linear Settings → API>

# Linear state ID for "Ready for Claude routines" on the TRZ team.
LINEAR_STATE_ID_READY_FOR_CLAUDE_ROUTINES=<uuid>

# Linear label IDs for each type:* label (canary needs to attach the right one per routine).
LINEAR_LABEL_ID_ARCHITECT=<uuid>
LINEAR_LABEL_ID_ANALYST=<uuid>
LINEAR_LABEL_ID_UX=<uuid>
LINEAR_LABEL_ID_RESEARCH=<uuid>
```

Langfuse credential (n8n HTTP Basic Auth): create an n8n credential with username = `LANGFUSE_PUBLIC_KEY`, password = `LANGFUSE_SECRET_KEY` (both from `/docker/openclaw-conductor/.env`). Reference ID in `watchdog-health.json` and `watchdog-cost.json` (placeholder `REPLACE-WITH-LANGFUSE-BASIC-AUTH-CRED-ID`).

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

## Known transient failure modes (and how to handle them)

### "API Error: Stream idle timeout - partial response received"
Appears mid-session in the Claude Code dashboard. The Anthropic streaming connection timed out between tokens — typically because the model paused too long while drafting a long artifact.

**Recovery:** move the triggering Linear ticket to a different status and back to the trigger status (e.g., Backlog → Ready for Claude routines). Dedup is keyed on `issueId:updatedAt`, so the status bounce creates a new `updatedAt` and lets the re-fire through. Partial outputs from the failed run are not persisted (the session dies before writing to Notion), so the retry starts clean.

**If it recurs on the same ticket 2+ times:** the skill prompt may be producing unusually long/slow responses. Tighten the output template to generate more incrementally — shorter sections, fewer nested requirements per section, less "think step by step" preamble.

First observed: 2026-04-21 on TRZ-421 first fire, during ADR-1 draft.

### n8n log: `Unknown filter parameter operator "boolean:notEqual"`
Emitted by the reconciler's `If any stuck tickets` node. n8n's If-v2 boolean operator set does **not** include `notEqual` — the valid operators are `equals`, `true` (unary), and `false` (unary). Until fixed, the reconciler errors out immediately after `Flatten tickets`, silently swallowing any stuck Linear ticket it was meant to re-fire. Looks like a Linear GraphQL error but it's actually n8n's `FilterParameter` validation (the `boolean:` prefix is operator-type : operation-name, a tell-tale).

**Recovery:** pull the latest `n8n/reconciler.json` from the repo and re-import it into the n8n UI (Workflows → Import from File → overwrite). The `Flatten tickets` code now sets `empty: false` explicitly on ticket items and the If node uses `equals false`. After overwrite, re-activate the workflow (Linear/n8n will log `Deregistered all crons for workflow` on deactivate and re-register on activate — expected).

**Sibling symptom — Linear webhook silent on a repeat Todo→Ready flip:** Linear can debounce identical status transitions fired close together, and any workflow edit that deactivates the workflow also drops the webhook registration n8n had pushed to Linear. Check Linear Settings → API → Webhooks → n8n's `Last Fired` timestamp. If it's stale, re-save the webhook (or bounce the toggle) to refresh registration, then bounce the ticket status to force a new `updatedAt`.

First observed: 2026-04-21 on TRZ-424 (`Ready for agent build` path, Growth agent smoke test).

### Paperclip `/labels` returns `[]` → `List Paperclip labels` emits zero items
When a Linear ticket is seen for the first time (no `linear:{identifier}` label exists in Paperclip yet), Paperclip's `GET /api/companies/:id/labels` returns a literal empty JSON array `[]`. n8n's HTTP Request v4.2 node **auto-splits any JSON-array response into one item per element** — for `[]` that's zero items — and every downstream node is silently skipped. `alwaysOutputData: true` only kicks in on errors, not on a 200-with-empty-array response, and `response.response.fullResponse: true` didn't change the behavior either on n8n 2.13.4. Net effect: the first fire of every new Linear ticket on the `Ready for agent build` path dropped silently after `Switch on status` — zero Paperclip issues created, but no error surfaced.

**Fix shipped (2026-04-22):** replaced `List Paperclip labels` and (in the reconciler) `Check Paperclip task exists` with Code nodes that use `this.helpers.httpRequest` and return exactly one item regardless of response shape. The downstream `Resolve linear label` and `Paperclip evidence check` Code nodes were simplified to read `$input.first().json.labels` / `.issues` directly. See `linear-router.json` / `reconciler.json` in this directory.

### Critical deploy gotcha: **n8n 2.13.4 runs `workflow_history[activeVersionId]`, not `workflow_entity.nodes`**
Any tooling that patches n8n workflows via direct SQLite writes needs to update BOTH `workflow_entity` (the draft the UI shows) AND the `workflow_history` row referenced by `workflow_entity.activeVersionId` (what actually executes). Updating only `workflow_entity.nodes` and restarting will look like it worked — the UI reflects the change — but the runtime behavior is unchanged and executions continue running the old code. For repo-driven updates prefer:

1. **UI import** (Workflows → Import from File → overwrite) — n8n correctly promotes the import to a new history row and repoints `activeVersionId`.
2. **REST API** — `PATCH /api/v1/workflows/:id` with an n8n API key does the same.
3. **Direct SQLite** — if you must, update the row in `workflow_history` whose `versionId` matches `workflow_entity.activeVersionId`, then `docker restart n8n-n8n-1`. Syncing `workflow_entity.nodes` separately is optional but keeps the UI consistent.

Confirmed 2026-04-22 by patching the history row with a marker-returning Code node and seeing the marker appear in the next execution's runData (previous draft-only patches left runtime unchanged across multiple restarts).
