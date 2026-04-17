# Shared OpenClaw Skills

Four skills loaded by **every** agent on the 11-agent team at session start. These are not role-specific — the Conductor, PM-lite, Researcher, Designer, Backend Eng, Data Eng, AI Eng, UI Eng, QA Eng, DevOps, and Tech Writer all run them.

## Skills

| Skill | Purpose |
|---|---|
| [`memory-read`](./memory-read/SKILL.md) | Query `agent_memory` Postgres at session start, filtered by `app_id IN ('{session_app}', 'global')`. Returns decisions, patterns, findings, design_decisions, handoffs, blockers, sessions. |
| [`slack-post-hybrid`](./slack-post-hybrid/SKILL.md) | Post structured STATUS / HANDOFF / QUESTION / BLOCKER / REVIEW / DESIGN / RESEARCH / NEW APP / CROSS-APP messages with hybrid routing: `#agent-{app_id}` per-app, `#agent-team` portfolio-wide. |
| [`notion-read`](./notion-read/SKILL.md) | Fetch Notion pages by URL or ID with retry + pagination. Used to load the app registry, spec pages, design/research docs. |
| [`langfuse-trace`](./langfuse-trace/SKILL.md) | Start, span, event, and finalize Langfuse traces tagged with the three required labels `app_id`, `agent_role`, `session_id`. Wraps every LLM and tool call. |

## Install path

Each skill directory is copied into the per-agent OpenClaw data dir at build/deploy time:

```
/docker/openclaw-{role}/data/.openclaw/skills/shared/{skill-name}/SKILL.md
```

where `{role}` is one of: `conductor`, `pm-lite`, `researcher`, `designer`, `backend-eng`, `data-eng`, `ai-eng`, `ui-eng`, `qa-eng`, `devops-eng`, `tech-writer`.

All 11 instances get the same copy — there is no role-specific divergence in `skills/shared/`. Role-specific skills, when they exist, live under `skills/{role}/` and override nothing.

## Loading contract

Every agent loads these four skills on session start, before any other work. They back the four non-negotiable rules from `repo/TEAM.md`:

1. **Full reasoning logs** — `langfuse-trace` wraps every LLM/tool call.
2. **Shared memory check at session start** — `memory-read` is the first call after the Conductor declares `app_id`.
3. **Slack communication** — `slack-post-hybrid` is the only sanctioned way to post; silent agents are broken agents.
4. **App scoping** — every skill requires `SESSION_APP_ID` and fails loud without it.
