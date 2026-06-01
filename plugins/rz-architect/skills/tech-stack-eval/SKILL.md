---
name: tech-stack-eval
description: Compare three or more candidate technologies against weighted criteria. Produces a scored matrix and a recommendation. Use when the ticket asks "which of these should we use" with a list of candidates — if there are only two options, use adr-author instead.
---

# tech-stack-eval — weighted comparison

## When to invoke

Invoke when the ticket:
- Lists 3+ candidate technologies (e.g., "compare LanceDB, Qdrant, and Weaviate for SIA's vector store")
- Asks for a scored comparison across multiple dimensions
- Needs a defensible recommendation, not just a gut call

For 2 options, use `adr-author` (options-and-recommendation is the same shape with less ceremony).

## Template

```markdown
# Tech stack eval — {category}

**Date:** {YYYY-MM-DD}
**Target app(s):** {ids}
**Triggering ticket:** [CAR-{n}]({URL})
**Candidates:** {A, B, C, …}
**Recommendation:** {winner} — see rationale below.

## Decision criteria

Weighted 0–100. Sum = 100.

| Criterion | Weight | Why it matters here |
|---|---|---|
| Performance | 25 | App X has latency SLO of Ymms |
| Operational cost | 20 | Self-hosted on 16GB VPS, shared with N other services |
| Ecosystem / community | 15 | ... |
| License compatibility | 10 | ... |
| Integration complexity | 15 | Time to get to production |
| Failure mode maturity | 10 | ... |
| Future scalability | 5 | ... |

Weights must match the app's actual priorities. Justify each weight in plain language.

## Scored matrix

Score each candidate 1–5 per criterion.

| Criterion | Weight | Candidate A | Candidate B | Candidate C |
|---|---|---|---|---|
| Performance (25) | 25 | 4 | 5 | 3 |
| Cost (20) | 20 | 3 | 2 | 5 |
| Ecosystem (15) | 15 | 5 | 3 | 4 |
| License (10) | 10 | 5 | 5 | 5 |
| Integration (15) | 15 | 4 | 2 | 3 |
| Failure modes (10) | 10 | 3 | 4 | 3 |
| Scalability (5) | 5 | 3 | 5 | 2 |
| **Weighted total** | **100** | **3.85** | **3.45** | **3.60** |

## Candidate notes

### Candidate A
- **Score rationale:** Why 4 on performance (cite benchmarks, your testing, or authoritative source). Why 3 on cost. Etc.
- **Sharp edges:** Known failure modes, license quirks, community concerns.
- **Best fit scenarios:** Where this candidate shines.

### Candidate B
...

### Candidate C
...

## Recommendation

**Choose {winner}** because {top 2 reasons grounded in weights and scores}.

The score gap between winner and second place is {narrow / moderate / wide}. If the gap is narrow, name the specific criterion that swung it.

## What would change this recommendation

- If {criterion A} dropped in weight (e.g., performance stops mattering), the winner would shift to {candidate}.
- If candidate {X} shipped feature {Y}, re-evaluate.
- If we need to support N+ apps on this stack (vs. just this one), reassess — scores may not scale.

## Implementation plan

- **Prototype phase:** {N days} on the winner. Concrete milestones.
- **Decision point:** {criteria to proceed to production}.
- **Rollback:** {what we'd do if prototype reveals a blocker}.

## Open questions
- ...

## Sources
- Benchmarks: {URLs}
- Docs: {URLs}
- Community feedback: {URLs}
```

## Output requirements

- Weights MUST sum to 100. Double-check before publishing.
- Every score must have a rationale sentence; no unexplained numbers.
- Weighted total to 2 decimal places.
- "What would change this recommendation" section is mandatory — a single-axis decision is brittle.
- Implementation plan must name a rollback path.
- If any candidate was eliminated before scoring, include a brief note on why (one line).
