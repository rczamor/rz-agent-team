# First-fire seed ticket

A well-formed Linear ticket to use for the **first real production routine fire** once CAR-353 (create routines) and CAR-354 (deploy n8n) are both done. Use this to validate the end-to-end flow.

## Which routine to fire first

Recommended: **rz-architect** (Technical Architect). Reasons:
- The output (an ADR) is tangible and easy to validate.
- You have a pending real decision you can legitimately ground this on.
- The skills are the most mature in the plugin set (Fowler + Nygard + Ford/Richards are the most established vocabularies).
- Output goes to a hub (ADR Log) that's already created and expected to accumulate entries.

## Ticket template

Create a new ticket in the Agent Team Linear project:

```
Title:     First-fire validation — choose job-queue implementation for SIA async ingestion

Project:   Agent Team
Labels:    type:architect, sia
Priority:  High
Status:    Backlog (move to "Ready for Claude routines" to fire)

Description:
---
SIA needs an async job queue for:
- URL ingestion (fetch + embed + store — 5–30s per URL)
- Publishing (periodic syncs to external destinations)
- Analytics rollups (scheduled hourly)

Three candidate approaches to evaluate:

1. **pg-boss** — Postgres-backed queue (reuses existing Neon Postgres)
2. **BullMQ + Redis** — proven, requires adding Redis to VPS stack
3. **Cloudflare Queues** — managed, but adds cross-cloud dependency

Constraints:
- VPS has ~6 GB RAM headroom
- SIA runs single-instance (no horizontal scaling yet)
- Riché prefers operational simplicity over raw throughput
- Target: p95 end-to-end job latency under 30s; throughput <100 jobs/min

Produce an ADR or tech-stack eval (architect routine's call). Output to ADR Log hub.
This is also serving as the first-fire validation of the rz-architect routine — so please be
explicit about your reasoning chain and decision criteria.

References:
- Agent Team design: https://www.notion.so/33eac0ea4f65817eb04eec533c9946f2
- ADR Log hub: https://www.notion.so/346ac0ea4f6581d480e4d9633a6cafe6
---
```

## Validation checklist (run after first fire)

Once the routine completes:

### Routine-side (strategic layer)
- [ ] Routine fired successfully (2xx from `/fire` endpoint)
- [ ] `claude_code_session_url` in the response works, session ran without errors
- [ ] Langfuse session has traces grouped under `session_id = Linear ticket ID`
- [ ] Notion artifact created under ADR Log hub
- [ ] Linear ticket received the "⚙ Technical Architect routine fired" comment with session URL
- [ ] Linear ticket received a final summary comment from the routine (outcome + artifact URL)

### Content quality (cross-reference `rz-architect/skills/tech-stack-eval/fixture.json`)
- [ ] Artifact has all required sections (decision criteria, scored matrix, candidate notes, recommendation, what-would-change-this, implementation plan)
- [ ] Weights in decision criteria sum to 100
- [ ] Every score has a one-sentence rationale
- [ ] Recommendation is singular, not a hedge
- [ ] Implementation plan has a rollback path
- [ ] Sources cited with URLs (not hallucinated)

### Integration-side (n8n + state management)
- [ ] `deferred_fires` static data unchanged (no 429 on first fire)
- [ ] Dedup cache has one new entry keyed on `issueId:updatedAt`
- [ ] If you retry moving the ticket to `Ready for Claude routines` (no updatedAt change), dedup kicks in — second fire doesn't happen

### Scope-boundary check (most likely failure mode)
- [ ] Routine did NOT push code to any repo (strategic routines don't ship code)
- [ ] Routine did NOT write to `agent_memory` Postgres (execution-layer only)
- [ ] Routine did NOT post to Slack operationally (only Notion + Linear comment)
- [ ] If the artifact included a recommendation to implement, a `type:engineering` ticket was filed for AI Eng (or Backend Eng in this case) — NOT the routine itself taking implementation action

### If anything fails
- Screenshot the failure, capture the Langfuse session URL + Claude Code session URL
- Update the affected skill or routine prompt
- Commit the fix to `main`
- Re-fire by updating the ticket description or moving through statuses again (creates a new `updatedAt` so dedup lets it through)

## Why this ticket is a good first fire

- **Real decision, real stakes, real output.** Not a toy "please write an ADR about ADRs" test.
- **Bounded scope.** Three specific candidates, clear constraints — easy to validate whether the output is useful.
- **Covers the full pipeline.** Tests webhook → routine → skill routing → Notion write → Linear comment.
- **Observable.** You can read the artifact and know whether it passed the fixture's smoke questions.
- **The answer matters.** You'll actually use the result (SIA does need a job queue decision).

## After validation

Once the first fire passes all checklist items, file follow-up tickets to:
- [ ] Smoke-test the other 3 routines with their corresponding fixtures
- [ ] Close CAR-369 (@growth smoke test) — separate from this one, runs on prototype
- [ ] Document any gaps found in skills or routine prompts

## Notes

- Skill fixes don't require routine recreation. The routine clones `main` at each fire, so pushing a skill update to `main` is enough.
- Routine prompt fixes DO require editing the routine in the Claude Code UI. Keep the paste-able prompt text in `plugins/ROUTINE_SETUP.md` as the source of truth.
- If this first fire takes > 10 minutes from trigger to Notion write, something is wrong — check Langfuse trace for where it's stuck.
