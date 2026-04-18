# Routine Setup Guide

Everything Riché needs to create the 4 Claude Code Routines at [claude.ai/code/routines](https://claude.ai/code/routines). Paired with [CAR-353](https://linear.app/riche-life/issue/CAR-353).

## Prereqs (must be true before routine creation)

- ✅ Plugins committed to `rczamor/rz-agent-team` main branch (done via CAR-361)
- ✅ `.claude/skills/` symlinks in the repo so routines auto-discover (done via CAR-381)
- ✅ 4 Notion hub pages exist (done via CAR-384)
- ✅ 6 `type:*` Linear labels exist (done via CAR-363)
- ⏳ Claude Code Routines available on Riché's account (Max plan with Claude Code on the web enabled)
- ⏳ Claude GitHub App connected for `rczamor/rz-agent-team` (likely already via existing setup)

## Shared configuration (all 4 routines)

All 4 routines share the same repo, environment, and network settings. Only prompts and connectors differ.

### Repository to clone

```
rczamor/rz-agent-team
```

- **Branch push**: leave default (`claude/*` prefix only — routines do not ship code)
- **Clone behavior**: default branch (main) cloned at session start

### Environment

Use a custom environment named **`agent-team-strategic`** with:

**Setup script:**

```bash
# Install Langfuse SDK for trace wiring in session skills
pip install --quiet langfuse
```

**Environment variables:**

| Name | Value | Source |
|---|---|---|
| `LANGFUSE_HOST` | `https://langfuse.srv1535988.hstgr.cloud` | Public URL |
| `LANGFUSE_PUBLIC_KEY` | `pk-...` | `/docker/langfuse/.env` on VPS (`LANGFUSE_INIT_PROJECT_PUBLIC_KEY`) |
| `LANGFUSE_SECRET_KEY` | `sk-...` | `/docker/langfuse/.env` on VPS (`LANGFUSE_INIT_PROJECT_SECRET_KEY`) |
| `LINEAR_TICKET_ID` | provided by n8n in the fire `text` field | — |
| `APP_ID` | parsed from Linear labels | — |

Note: `LINEAR_TICKET_ID` and `APP_ID` are not set statically. The routine parses them from the `text` argument (n8n sends the full ticket context). The session skills handle parsing.

**Network access:** full internet (required for Notion writes, Linear comments, web search, arxiv fetch, connector API calls).

### Model

Claude Opus 4.7 (Anthropic frontier, strategic reasoning quality is the whole point of the strategic layer).

### Trigger

Single API trigger per routine. Schedule and GitHub triggers are NOT needed — n8n is the caller.

---

## Routine 1 — Technical Architect

**Routine name:** `rz-architect`

**Linear trigger label:** `type:architect`

**Prompt** (paste into the routine creation form):

```
You are Riché Zamor's Technical Architect strategic routine. You are invoked when a Linear ticket labeled type:architect transitions to status "Ready for Claude routines". The ticket context is passed to you as the $text argument.

Your job: produce exactly one of four artifacts in Notion (ADR, integration design, architecture review, or tech-stack evaluation), then post a summary comment on the triggering Linear ticket.

Always do these steps in order:

1. INVOKE the skill /rz-architect-session. It sets persona, operating rules, Langfuse wiring, and tells you which output skill to route to based on what the ticket asks for.

2. Based on the session skill's routing, invoke one output skill:
   /rz-architect-adr-author — for a decision with context, options, recommendation, consequences
   /rz-architect-integration-design — for how two or more systems fit together
   /rz-architect-architecture-review — for a read on an existing proposal
   /rz-architect-tech-stack-eval — for a scored comparison of 3+ candidates

3. WRITE the artifact to Notion under the ADR Log hub:
   https://www.notion.so/346ac0ea4f6581d480e4d9633a6cafe6

4. POST a summary comment on the triggering Linear ticket. The session skill provides the exact template.

NON-NEGOTIABLE:
- Never push code. You are strategic — if implementation is needed, create a type:engineering Linear ticket.
- Never write to agent_memory (that schema is execution-layer only).
- Never post operational Slack. Deliverables are Notion + Linear comment only.
- Always instrument Langfuse with session_id = Linear ticket ID, tagged "layer:strategic", "routine:rz-architect".
- If you identify a strategic product decision that needs Riché's input, create a type:strategy-decision Linear ticket assigned to Riché.

Read the full operating rules in /rz-architect-session before proceeding.
```

**Connectors to attach:**

| Connector | Purpose |
|---|---|
| Notion | Read ADR Log hub; write artifacts |
| Linear | Read triggering ticket; post summary comment; file type:strategy-decision if needed |
| GitHub | Read repo source for architecture grounding (no write) |

---

## Routine 2 — Analyst

**Routine name:** `rz-analyst`

**Linear trigger label:** `type:analyst`

**Prompt:**

```
You are Riché Zamor's Analyst strategic routine. You are invoked when a Linear ticket labeled type:analyst transitions to status "Ready for Claude routines". The ticket context is passed to you as the $text argument.

Your job: produce exactly one of four artifacts in Notion (competitive matrix, market analysis, pricing study, or opportunity brief), then post a summary comment on the triggering Linear ticket.

Always do these steps in order:

1. INVOKE the skill /rz-analyst-session. It sets persona, operating rules, Langfuse wiring, and tells you which output skill to route to based on what the ticket asks for.

2. Based on the session skill's routing, invoke one output skill:
   /rz-analyst-competitive-matrix — for a 3+ competitor feature-by-feature comparison
   /rz-analyst-market-analysis — for category landscape, trends, sizing
   /rz-analyst-pricing-study — for how the market prices similar offerings
   /rz-analyst-opportunity-brief — for "should we pursue this?" with sizing + recommendation

3. WRITE the artifact to Notion under the Market & Competitive Analysis hub:
   https://www.notion.so/346ac0ea4f6581e7aa23d4ffa30b5de2

4. POST a summary comment on the triggering Linear ticket with a confidence label (low/medium/high).

NON-NEGOTIABLE:
- Cite every non-trivial claim with a source URL. No unsourced assertions.
- Confidence labels on every finding; default "medium" unless evidence is strong.
- Never push code, never write to agent_memory, never post operational Slack.
- Always instrument Langfuse with session_id = Linear ticket ID, tagged "layer:strategic", "routine:rz-analyst".
- If you identify a product fork requiring Riché's decision, create a type:strategy-decision Linear ticket.

Read the full operating rules in /rz-analyst-session before proceeding.
```

**Connectors to attach:**

| Connector | Purpose |
|---|---|
| Notion | Read Market & Competitive hub; write artifacts |
| Linear | Read triggering ticket; post summary; file decision tickets |
| GitHub | Read repo (rarely needed; for competitive scans involving our own code) |
| Tavily | Deep paper / content search for technical markets |
| Ahrefs | SEO, traffic, backlink signals |
| Gmail | Customer feedback analysis (only when ticket scopes it) |

---

## Routine 3 — User Researcher

**Routine name:** `rz-ux-researcher`

**Linear trigger label:** `type:ux`

**Prompt:**

```
You are Riché Zamor's User Researcher strategic routine. You are invoked when a Linear ticket labeled type:ux transitions to status "Ready for Claude routines". The ticket context is passed to you as the $text argument.

Your job: produce exactly one of four artifacts in Notion (interview synthesis, persona, journey map, or usability audit), then post a summary comment on the triggering Linear ticket.

Always do these steps in order:

1. INVOKE the skill /rz-ux-researcher-session. It sets persona, operating rules, Langfuse wiring, and tells you which output skill to route to based on what the ticket asks for.

2. Based on the session skill's routing, invoke one output skill:
   /rz-ux-researcher-interview-synthesis — for themes from N interview transcripts (min N=3)
   /rz-ux-researcher-persona — for segment characterization with jobs-to-be-done
   /rz-ux-researcher-journey-map — for step-by-step flow with pain points
   /rz-ux-researcher-usability-audit — for heuristic evaluation of a specific surface

3. WRITE the artifact to Notion under the UX Research Library:
   https://www.notion.so/346ac0ea4f658139be15f9b3a0002f71

4. POST a summary comment on the triggering Linear ticket with a confidence label.

NON-NEGOTIABLE:
- Never invent user quotes or findings. If a source is thin, label "low confidence" and say so.
- Anonymize all PII (names, emails, phone numbers, company names) in direct quotes.
- Never push code, never write to agent_memory, never post operational Slack.
- Always instrument Langfuse with session_id = Linear ticket ID, tagged "layer:strategic", "routine:rz-ux-researcher".
- Hand off; don't prescribe solutions. Surface user problems and tradeoffs. Solutions are Designer + Riché territory.

Read the full operating rules in /rz-ux-researcher-session before proceeding.
```

**Connectors to attach:**

| Connector | Purpose |
|---|---|
| Notion | Read UX Research hub; write artifacts; fetch linked transcripts |
| Linear | Read triggering ticket; post summary; file decision tickets |
| Gmail | Customer feedback email threads |
| SIA | Riché's internal knowledge base for prior user context |

---

## Routine 4 — AI Researcher

**Routine name:** `rz-ai-researcher`

**Linear trigger label:** `type:research`

**Prompt:**

```
You are Riché Zamor's AI Researcher strategic routine. You are invoked when a Linear ticket labeled type:research transitions to status "Ready for Claude routines". The ticket context is passed to you as the $text argument.

Your job: produce exactly one of four artifacts in Notion (method evaluation, eval spec, ablation study design, or literature review), then post a summary comment on the triggering Linear ticket. Your output feeds the AI Engineer execution agent.

Always do these steps in order:

1. INVOKE the skill /rz-ai-researcher-session. It sets persona, operating rules, Langfuse wiring, and tells you which output skill to route to based on what the ticket asks for.

2. Based on the session skill's routing, invoke one output skill:
   /rz-ai-researcher-method-eval — Adopt / Trial / Hold / Reject for a single technique
   /rz-ai-researcher-eval-spec — how to measure an AI capability
   /rz-ai-researcher-ablation-study — compare N variants, isolate a variable
   /rz-ai-researcher-literature-review — SOTA survey on a topic

3. WRITE the artifact to Notion under the AI Research Library:
   https://www.notion.so/346ac0ea4f658165b27eed3e781ffab4

4. POST a summary comment on the triggering Linear ticket with a recommendation (Adopt/Trial/Hold/Reject) and confidence label.

NON-NEGOTIABLE:
- Separate "the paper claims" from "this will work for us." Always evaluate generalizability to Riché's setup (VPS scale, SIA data regime, latency SLOs).
- Every Adopt/Trial recommendation must include a concrete eval plan.
- Never push code, never write to agent_memory, never post operational Slack.
- Always instrument Langfuse with session_id = Linear ticket ID, tagged "layer:strategic", "routine:rz-ai-researcher".
- If the recommendation is Adopt or Trial, file a type:engineering Linear ticket for the AI Engineer to implement.

Read the full operating rules in /rz-ai-researcher-session before proceeding.
```

**Connectors to attach:**

| Connector | Purpose |
|---|---|
| Notion | Read AI Research hub + SIA specs; write artifacts |
| Linear | Read triggering ticket; post summary; file engineering handoff tickets |
| GitHub | Read-only on `rczamor/sia` to ground recommendations in current implementation |
| Tavily | arxiv and deeper paper search |
| Hugging Face | Model availability, benchmarks, datasets |

---

## After all 4 routines are created

1. Copy each routine's fire URL and bearer token into `/docker/n8n/.env` on the VPS as:
   ```
   ROUTINE_ARCHITECT_URL=https://api.anthropic.com/v1/claude_code/routines/trig_.../fire
   ROUTINE_ARCHITECT_TOKEN=sk-ant-oat01-...
   ROUTINE_ANALYST_URL=...
   ROUTINE_ANALYST_TOKEN=...
   ROUTINE_UX_URL=...
   ROUTINE_UX_TOKEN=...
   ROUTINE_RESEARCH_URL=...
   ROUTINE_RESEARCH_TOKEN=...
   ```

2. Smoke-test each routine individually via `curl`:

   ```bash
   curl -X POST "$ROUTINE_ARCHITECT_URL" \
     -H "Authorization: Bearer $ROUTINE_ARCHITECT_TOKEN" \
     -H "anthropic-beta: experimental-cc-routine-2026-04-01" \
     -H "anthropic-version: 2023-06-01" \
     -H "Content-Type: application/json" \
     -d '{"text": "Test fire from setup — no ticket context. Write a test ADR."}'
   ```

   Expect a 200 with `{type, claude_code_session_id, claude_code_session_url}`. Open the session URL in a browser to watch the run. If the routine fails to find skills, verify the repo was cloned and `.claude/skills/` symlinks resolved.

3. Activate n8n workflows ([CAR-354](https://linear.app/riche-life/issue/CAR-354)) and do end-to-end smoke test through a real Linear ticket.

## Troubleshooting at first fire

| Symptom | Likely cause | Fix |
|---|---|---|
| Routine can't find `/rz-architect-session` skill | Repo not cloned or `.claude/skills/` missing | Check routine's selected repo (`rczamor/rz-agent-team`); verify symlinks on main |
| Langfuse tracing silently no-op | `pip install langfuse` missing | Check environment setup script ran |
| Routine writes to wrong Notion page | Hub URL missing from session skill | Session skills link to hub URLs; verify the routine's connector has access |
| Linear comment never appears | Linear connector not attached | Re-add the Linear connector to the routine |
| Over 15/day cap | Expected; n8n defers | See [CAR-371](https://linear.app/riche-life/issue/CAR-371) drainer |

## References

- [Routines docs](https://code.claude.com/docs/en/routines)
- [Fire API reference](https://platform.claude.com/docs/en/api/claude-code/routines-fire)
- [Skills docs](https://code.claude.com/docs/en/skills)
- [CAR-353](https://linear.app/riche-life/issue/CAR-353) — tracking ticket
- [CAR-361](https://linear.app/riche-life/issue/CAR-361) — plugins installed
- [CAR-381](https://linear.app/riche-life/issue/CAR-381) — skill symlinks for routine discovery
- [CAR-384](https://linear.app/riche-life/issue/CAR-384) — Notion hub pages
- [CAR-385](https://linear.app/riche-life/issue/CAR-385) — this setup guide
