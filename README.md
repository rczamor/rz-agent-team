# rz-agent-team

Versioned configuration for Riché's 11-agent OpenClaw team. The agents build and maintain the app portfolio: SIA, [richezamor.com](http://richezamor.com), and 6 prototypes (Recipe Remix, Ploppy, Blocade, Ascend, Trend Analyzer, AI Onboarding).

The authoritative design lives in Notion under [🤖 Agent Team](https://www.notion.so/33eac0ea4f65817eb04eec533c9946f2). This repo is the **deployable artifact** — the markdown each OpenClaw instance reads at startup.

## What's in here

```
.
├── README.md                  This file
├── TEAM.md                    Full roster — identical copy on every instance
├── USER.md                    Riché's working context + app registry pointers — identical copy on every instance
├── identities/                One IDENTITY.md per agent (11 total)
│   ├── conductor.md
│   ├── pm-lite.md
│   ├── researcher.md
│   ├── designer.md
│   ├── backend-eng.md
│   ├── data-eng.md
│   ├── ai-eng.md
│   ├── ui-eng.md
│   ├── qa-eng.md
│   ├── devops-eng.md
│   └── tech-writer.md
├── corpus/                    Knowledge corpus seeds for each role (Cowork research input)
├── connect.sh                 SSH helper for the Hostinger VPS
└── .env.local.example         Template for local connection vars
```

## How OpenClaw consumes these files

Each of the 11 OpenClaw instances on the Hostinger VPS (`/docker/openclaw-*/`) loads three identity files at startup:

- `TEAM.md` → identical across all instances
- `USER.md` → identical across all instances
- `IDENTITY.md` → the role-specific file from `identities/{role}.md`, copied to the instance's working directory as `IDENTITY.md`

A future deployment script will sync these files from this repo to each `/docker/openclaw-{role}/` directory on the VPS. Until that script exists, propagate by hand:

```bash
# Example for the conductor instance
scp identities/conductor.md root@srv1535988.hstgr.cloud:/docker/openclaw-<conductor-instance>/data/IDENTITY.md
scp TEAM.md USER.md root@srv1535988.hstgr.cloud:/docker/openclaw-<conductor-instance>/data/
docker compose -f /docker/openclaw-<conductor-instance>/docker-compose.yml restart
```

## Required environment per instance

Every `/docker/openclaw-*/.env` on the VPS must contain:

```bash
ANTHROPIC_API_KEY=...   # Opus 4.7 — primary for Conductor + AI Eng, escalation for everyone else
OLLAMA_API_KEY=...      # Ollama Cloud — workhorse inference for the other 9 roles
```

**Local Ollama (`ollama-apvg` container) on the VPS is reserved for embeddings only** (`nomic-embed-text` model). Do not configure agents to use it for chat completion.

## Operating model recap

- Session-based, human-triggered. No 24/7 autonomous operation.
- Every session targets exactly one app (`app_id`). Cross-app work splits into sequential sub-sessions.
- Two-layer orchestration: **Linear** = planning, **Paperclip** = execution + audit.
- Three-layer memory: identity files (static), Slack channels (live), Postgres `agent_memory` schema (persistent, partitioned by `app_id`).
- Observability: Langfuse traces every LLM call, tagged with `app_id` + agent role + session ID.

Full operating rules live in the Notion [Operating Rules & Conventions](https://www.notion.so/33eac0ea4f65811680d9d64c1d3080ff) page.

## Setup prerequisites

1. **Anthropic API key** — Claude Opus 4.7 access. Required by every instance.
2. **Ollama Cloud API key** — sign up at [ollama.com](https://ollama.com), generate a key. Required by the 9 workhorse instances.
3. **Slack workspace** — bot tokens for each of the 11 agent identities (`@conductor`, `@pm`, `@researcher`, `@designer`, `@backend-eng`, `@data-eng`, `@ai-eng`, `@ui-eng`, `@qa-eng`, `@devops-eng`, `@tech-writer`).
4. **Linear API token** — Conductor + PM-lite need write access; other agents read-only.
5. **GitHub access** — agents work directly on each app's repo (see Notion app registry for the 8 repo URLs).
6. **Notion API token** — agents read product specs and design pages.

## Deferred work (not in this repo yet)

- Sync/deploy script (`scripts/deploy-identities.sh`)
- 6 additional openclaw instances to reach the design's target of 11 (currently 5 deployed)
- `agent_memory` Postgres schema migrations
- Slack channel + bot provisioning script
- Conductor's Linear ↔ Paperclip bridge implementation
