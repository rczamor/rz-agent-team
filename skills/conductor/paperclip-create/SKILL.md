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

- `PAPERCLIP_API_URL` — `https://paperclip-hxtc.srv1535988.hstgr.cloud`
- `PAPERCLIP_COMPANY_ID` — multi-tenancy identifier. Discover once at setup time from the Paperclip admin UI (or `GET /api/companies` with auth) and store in VPS secrets.
- `PAPERCLIP_API_TOKEN` — bearer token scoped to the Conductor instance (admin user `rczamor@gmail.com`)
- `LINEAR_API_KEY` — needed to post the back-reference comment on the Linear ticket

## Input

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

## Output

```json
{
  "paperclip_issue_id": "pc-7821",
  "paperclip_url": "https://paperclip-hxtc.srv1535988.hstgr.cloud/issues/pc-7821",
  "linear_comment_id": "cmt_abc123",
  "created_at": "2026-04-16T..."
}
```

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

- **`app_id` is non-negotiable.** Reject the call if `app_id` is missing or not one of the 8 registered values from `USER.md`. Paperclip's schema enforces this; fail fast before the POST.
- POST to `${PAPERCLIP_API_URL}/api/companies/${PAPERCLIP_COMPANY_ID}/issues` with `Authorization: Bearer ${PAPERCLIP_API_TOKEN}`. Retry 3x on 5xx (1s, 3s, 9s). Never retry on 4xx. **Note:** earlier drafts of this skill used `/api/issues` — that endpoint returns 400 with a message pointing at the correct company-scoped path. Verified 2026-04-18.
- After Paperclip returns, write a Linear comment: `Paperclip: {paperclip_url} · Langfuse session: {langfuse_session_id}`. This satisfies the "every Linear comment references Paperclip + Langfuse" rule.
- If `portfolio_action_id` is non-null, tag the Paperclip issue with it and ensure the row exists in `agent_memory.sessions` (cross-app work tracking).
- Log the Paperclip creation itself to Langfuse: tags `conductor` + `app_id` + `paperclip-create`, with the Paperclip issue ID as the output.
- Target-file list should come from the app config's ownership map (loaded by `app-config-load`) — do not let the caller invent paths.
