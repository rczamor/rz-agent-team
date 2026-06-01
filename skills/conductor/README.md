# Conductor skills

Conductor-only OpenClaw skills. These are installed exclusively in the Conductor instance at:

```
/docker/openclaw-conductor/data/.openclaw/skills/
```

They are not copied to any other of the 10 OpenClaw instances — worker agents have no business reading Linear directly, creating Paperclip issues, or loading the app registry. That path runs through the Conductor every time.

## Skills in this directory

| Skill | One-line purpose |
|---|---|
| [`linear-read`](./linear-read/SKILL.md) | Fetch a ticket by ID, list tickets by project/status/priority, read comments — the Conductor's read path into Riché's planning layer. |
| [`paperclip-create`](./paperclip-create/SKILL.md) | Create a Paperclip issue from Linear ticket context, with `app_id`, target files, acceptance criteria, and assigned role — the write path into the immutable execution/audit log. |
| [`app-config-load`](./app-config-load/SKILL.md) | Load a given `app_id`'s full config (stack, repo, file ownership, conventions, overrides) from the Notion app registry. |

## How they compose in a session

1. Riché posts a ticket reference in a per-app Slack channel.
2. Conductor invokes `linear-read` → resolves ticket + `app_id`.
3. Conductor invokes `app-config-load` → returns stack/files/conventions.
4. Conductor assembles work brief, invokes `paperclip-create` → gets Paperclip issue ID.
5. Conductor posts `STATUS: Starting work on {app}/{ticket}` to the per-app channel, referencing the Paperclip issue + Langfuse session (see message formats in [`TEAM.md`](../../TEAM.md)).
6. Conductor dispatches the assigned agent.

## Related skills

Shared skills used by every role (including the Conductor) live at [`../shared/`](../shared/). See the top-level skills README for installation conventions across the 11 OpenClaw instances.
