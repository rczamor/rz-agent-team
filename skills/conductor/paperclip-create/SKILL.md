---
name: paperclip-create
description: Create a Paperclip issue from Linear ticket context — the Conductor's write path into the immutable execution/audit layer
allowed-tools: Bash, mcp__linear__save_comment
---

## Purpose

Paperclip is the execution layer and immutable audit log. Every dispatched piece of work becomes a Paperclip issue with a full work brief: target `app_id`, file paths from the app's ownership map, acceptance criteria (copied verbatim from Linear), and the assigned agent role. This skill turns a Linear ticket + loaded app config into a Paperclip issue and writes the resulting issue ID back to the Linear ticket as a comment — closing the planning ↔ execution loop.

## When to invoke

- After `linear-read` + `app-config-load` have both returned, and the Conductor is ready to dispatch.
- Before posting the per-app Slack `STATUS: Starting work on {app}/{ticket}` message — the message must reference the Paperclip issue ID.
- Once per dispatched agent per ticket. Cross-agent work creates N Paperclip issues linked by `portfolio_action_id`.

## Required env vars

- `PAPERCLIP_API_URL` — public: `https://paperclip-hxtc.srv1535988.hstgr.cloud`. Inside the VPS docker network, prefer `http://paperclip-hxtc-paperclip-1:3100` (internal HTTP — Traefik serves a self-signed cert, so internal HTTPS fails without `-k`). This is what n8n uses.
- `PAPERCLIP_COMPANY_ID` — `6f2a7481-7f8e-41e8-a236-e0fabfe6ef6d` (company "riche-zamor", issue prefix `RIC`). Live since 2026-04-17, bootstrapped via the container's entrypoint script.
- `PAPERCLIP_API_KEY` — bearer token scoped to the Conductor agent (id `36fefc07-315a-449b-91bf-03b9113ad788` in the above company). Tokens start with `pcp_` (not `pc_`); generated via `POST /api/agents/:agentId/keys` while authenticated as admin. Stored in `/docker/n8n/.env` on the VPS.
- `LINEAR_API_KEY` — needed to post the back-reference comment on the Linear ticket.

**Admin credentials** (for generating new tokens or claiming board access): email `rczamor@gmail.com`, password in `/docker/paperclip-hxtc/.env` on the VPS under `ADMIN_PASSWORD`. Log in via `POST /api/auth/sign-in/email` (better-auth) over HTTPS with a matching `Origin` header — HTTP-only sessions won't work because the cookie uses the `__Secure-` prefix. For board-level mutations (like minting agent keys), either drive the session over the public HTTPS URL with `-k`, or use an existing board-key bearer.

## Input (what the skill caller passes)

```json
{
  "linear_issue_id": "CAR-198",
  "app_id": "sia",
  "assigned_role": "backend-eng",
  "work_brief_md": "...",
  "target_files": [
    "apps/api/routes/context_layer.py",
    "apps/api/services/retrieval.py"
  ],
  "acceptance_criteria": [
    "POST /api/context returns 200 with ranked chunks",
    "New retrieval path traced in Langfuse"
  ],
  "langfuse_session_id": "lf_sess_01h...",
  "portfolio_action_id": null
}
```

## Paperclip payload (what actually hits the API)

`createIssueSchema` (from `@paperclipai/shared/validators/issue.js`) only accepts these fields: `title` (required), `description`, `status`, `priority`, `assigneeAgentId`, `assigneeUserId`, `projectId`, `projectWorkspaceId`, `goalId`, `parentId`, `labelIds`, `billingCode`, and a few workspace/execution fields. **Extra fields are silently dropped** — `linear_issue_id`, `app_id`, `linear_ticket_id`, `assigned_role`, etc. are not stored unless you embed them in `description` as serialized markdown.

Recommended mapping:

| Input field | Paperclip field |
|---|---|
| `"[{linear_issue_id}] " + linear_issue_title` | `title` |
| Structured markdown containing `app_id`, `linear_url`, `assigned_role`, `target_files`, `acceptance_criteria`, `langfuse_session_id`, `portfolio_action_id` | `description` |
| map priority label (`P0`/`P1`/…) | `priority` (`low` / `medium` / `high` / `urgent`) |
| (none) | `assigneeAgentId` — use the role-matching agent UUID from the agents list in the company |
| `[<linear:{identifier} label UUID>]` | `labelIds` — persists the Linear ↔ Paperclip link so the reconciler can query `GET /issues?labelId=<uuid>`. Find-or-create the label via `GET /labels` then `POST /labels {name: "linear:RIC-17", color: "#5E6AD2"}` if missing. See n8n `linear-router.json` for the canonical implementation. |

## Output

```json
{
  "paperclip_issue_id": "34223352-73e6-4ca2-b1b5-19f333794c3f",
  "paperclip_identifier": "RIC-1",
  "paperclip_url": "https://paperclip-hxtc.srv1535988.hstgr.cloud/issues/RIC-1",
  "linear_comment_id": "cmt_abc123",
  "created_at": "2026-04-21T..."
}
```

The API response returns both a `id` (UUID) and an `identifier` (`RIC-{n}`, based on company `issuePrefix` + `issueCounter`). Use the UUID for API lookups, the identifier for human-readable references.

## Example invocation

```
/skill paperclip-create \
  --linear_issue_id CAR-198 \
  --app_id sia \
  --assigned_role backend-eng \
  --work_brief_md "$(cat brief.md)" \
  --target_files apps/api/routes/context_layer.py,apps/api/services/retrieval.py \
  --acceptance_criteria "POST /api/context returns 200;Retrieval traced in Langfuse" \
  --langfuse_session_id lf_sess_01h...
```

## Implementation notes

- **`app_id` is skill-level, not Paperclip-level.** The skill's caller should still reject missing/unknown `app_id` (it has to match one of the 8 registered values from `USER.md`), but Paperclip's own schema does *not* enforce this — `app_id` must be serialized into the `description` or encoded in `labelIds` the caller creates via `POST /api/companies/:id/labels` first.
- POST to `${PAPERCLIP_API_URL}/api/companies/${PAPERCLIP_COMPANY_ID}/issues` with `Authorization: Bearer ${PAPERCLIP_API_KEY}`. Retry 3x on 5xx (1s, 3s, 9s). Never retry on 4xx. **Note:** earlier drafts of this skill used `/api/issues` — that endpoint returns 400 pointing at the correct company-scoped path. Verified 2026-04-21.
- Response shape: `{ id: UUID, identifier: "RIC-N", title, description, createdByAgentId, createdAt, ... }`. `createdByAgentId` is filled in automatically from the bearer token — the Conductor agent that owns the key.
- After Paperclip returns, write a Linear comment: `Paperclip: {paperclip_url} · Langfuse session: {langfuse_session_id}`. This satisfies the "every Linear comment references Paperclip + Langfuse" rule.
- If `portfolio_action_id` is non-null, tag the Paperclip issue with it and ensure the row exists in `agent_memory.sessions` (cross-app work tracking).
- Log the Paperclip creation itself to Langfuse: tags `conductor` + `app_id` + `paperclip-create`, with the Paperclip issue ID as the output.
- Target-file list should come from the app config's ownership map (loaded by `app-config-load`) — do not let the caller invent paths.

## Live setup (2026-04-21)

- Company: `6f2a7481-7f8e-41e8-a236-e0fabfe6ef6d` ("riche-zamor", issue prefix `RIC`). A duplicate `Riche Zamor` company was deleted on 2026-04-21 after temporarily enabling `PAPERCLIP_ENABLE_COMPANY_DELETION=true`.
- Conductor agent (holder of the API key): `36fefc07-315a-449b-91bf-03b9113ad788` (role `ceo`, name "Conductor"). Sibling agents in the same company map the role taxonomy: `pm` (PM-lite), `designer`, `engineer` (Backend/Data/AI/UI), `qa`, `devops`, `general` (Tech Writer).
- Integration verified: smoke-test `RIC-1` created via direct `curl` with bearer token; `RIC-2` created by the n8n linear-router workflow (`Ready for agent build` status branch) on 2026-04-21, proving the full Linear-webhook → Paperclip path end-to-end.
- n8n container runs on both `n8n_default` and `paperclip-hxtc_default` networks (wired via docker-compose, not an ad-hoc `docker network connect`). This is required because Traefik serves a self-signed cert for `paperclip-hxtc.srv1535988.hstgr.cloud` and n8n's HTTP-Request node does not tolerate self-signed by default; the internal `http://paperclip-hxtc-paperclip-1:3100` bypasses the issue.

## Known gaps to address

- ~~**Reconciler bug (CAR-370):** `reconciler.json` queried `GET /api/companies/:id/issues?linear_ticket_id=…` but Paperclip's schema has no `linear_ticket_id` field, so the query param was silently dropped and every reconciler poll returned "no task exists" — forcing the router to re-fire indefinitely.~~ **Fixed 2026-04-21** via option (b): the linear-router now find-or-creates a `linear:{identifier}` label before issue creation and attaches it via `labelIds`; the reconciler resolves the label UUID and filters with `?labelId=<uuid>`. If the label itself is missing, the reconciler treats the ticket as missed and re-fires directly. Paperclip's `createIssueSchema`/`updateIssueSchema` were not modified — this is pure n8n-side.
- **Linear-comment step runs regardless of Linear issue existence:** the n8n `Comment — Paperclip issue created` node uses Linear's `commentCreate` mutation with `issueId`. A fake/nonexistent UUID returns `{success: false}` (HTTP 200), so the workflow records success. If you need hard verification, add a post-step check on `commentCreate.success`.
- **Label proliferation:** each distinct Linear ticket gets its own `linear:TICKET-ID` label in Paperclip. At expected volumes (tens per week) this is fine for a long time, but `GET /labels` has no pagination in Paperclip today — when label count grows large enough that the listing slows down, either add pagination upstream or switch to a label-detail lookup-by-name endpoint.
