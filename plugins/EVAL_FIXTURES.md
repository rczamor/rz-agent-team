# Eval fixtures — smoke-test harness for the 16 output skills

Each of the 4 strategic-routine plugins has 4 output skills (`adr-author`, `integration-design`, etc.). Each output skill has a `fixture.json` next to its `SKILL.md` — a mock input ticket + expected output structure + smoke-test questions.

## Purpose

Verify that when a routine is fired with a realistic Linear ticket, the output it writes to Notion actually matches the template the skill commits to. Catches template drift, role-boundary violations, missing required sections, or lazy outputs before they land in a real Notion hub.

## Structure per fixture

```json
{
  "skill": "rz-{role}-{output-name}",
  "description": "what this fixture tests",
  "input_ticket": {
    "identifier": "CAR-EVAL-N",
    "title": "...",
    "description": "...",
    "labels": ["type:X", "app-id"],
    "app_id": "..."
  },
  "expected_output_structure": [ /* list of required H1/H2 headings */ ],
  "expected_output_fields": { /* enforceable structural assertions */ },
  "smoke_questions": [ /* 3–5 yes/no calibration questions for a reviewer */ ],
  "success_criteria": "one-line pass condition"
}
```

## How to run a fixture (manual, pre-CI)

1. Fire the target routine manually with the fixture's `input_ticket.description` as the `text` argument:
   ```bash
   curl -X POST "$ROUTINE_{ROLE}_URL" \
     -H "Authorization: Bearer $ROUTINE_{ROLE}_TOKEN" \
     -H "anthropic-beta: experimental-cc-routine-2026-04-01" \
     -H "anthropic-version: 2023-06-01" \
     -H "Content-Type: application/json" \
     -d "$(jq -r '{text: .input_ticket.description}' fixture.json)"
   ```
2. Watch the routine session (URL returned in response)
3. Inspect the Notion artifact it wrote
4. Check each item in `expected_output_structure` is present
5. Answer each `smoke_questions` yes/no
6. Pass if all structure items present AND all smoke questions yes

## Known limitation

Fixtures don't specify the exact content the output should have — only the shape and key behavioral requirements. That's intentional: the routine should have latitude to phrase things naturally, and enforcing exact text would make fixtures brittle. The structural requirements + smoke questions are the contract.

## Expansion path

A future CI job could:
1. Read every `fixture.json` under `plugins/`
2. Fire the corresponding routine with the input ticket
3. Fetch the resulting Notion page
4. Parse for expected sections + fields
5. Use an LLM-as-judge to answer the smoke questions
6. Report pass/fail per fixture

For now, fixtures are a manual smoke-test tool. Run at least once per fixture after routine creation (CAR-353) to verify the round-trip actually works end-to-end.

## Index

### rz-architect
- `rz-architect/skills/adr-author/fixture.json` — ADR for vector-store decision
- `rz-architect/skills/integration-design/fixture.json` — SIA MCP ↔ website chatbot integration
- `rz-architect/skills/architecture-review/fixture.json` — Review of proposed Redis session cache
- `rz-architect/skills/tech-stack-eval/fixture.json` — Job queue comparison (pg-boss / BullMQ / Cloudflare)

### rz-analyst
- `rz-analyst/skills/competitive-matrix/fixture.json` — Personal AI knowledge systems landscape
- `rz-analyst/skills/market-analysis/fixture.json` — AI-powered recipe apps market
- `rz-analyst/skills/pricing-study/fixture.json` — Chatbot widget pricing
- `rz-analyst/skills/opportunity-brief/fixture.json` — Ploppy enterprise-tier opportunity

### rz-ux-researcher
- `rz-ux-researcher/skills/interview-synthesis/fixture.json` — SIA knowledge capture workflow
- `rz-ux-researcher/skills/persona/fixture.json` — Recipe Remix primary persona
- `rz-ux-researcher/skills/journey-map/fixture.json` — SIA URL ingestion journey
- `rz-ux-researcher/skills/usability-audit/fixture.json` — richezamor.com speaking page

### rz-ai-researcher
- `rz-ai-researcher/skills/method-eval/fixture.json` — ColBERTv2 adoption decision
- `rz-ai-researcher/skills/eval-spec/fixture.json` — SIA consolidation quality eval
- `rz-ai-researcher/skills/ablation-study/fixture.json` — Rerank stage A/B study
- `rz-ai-researcher/skills/literature-review/fixture.json` — Long-context retrieval SOTA

## Tracking

Filed as a follow-up to CAR-361. When routines land (CAR-353), the first-fire validation loop should use these fixtures as the smoke-test set.
