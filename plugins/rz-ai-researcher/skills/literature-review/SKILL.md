---
name: literature-review
description: Survey the current SOTA on a topic with synthesis, gaps, and implications. Use when the ticket asks what's new in a space, what's state of the art, or wants orientation on a topic before method selection.
---

# literature-review

## When to invoke

Invoke when the ticket:
- Asks for SOTA on a topic (e.g., "what's current SOTA on retrieval for Q&A?")
- Wants orientation on a new area before deciding what to try
- Asks for a reading list or synthesis of recent work

For evaluating a single method, use `method-eval`. For comparing specific variants via experiment, use `ablation-study`.

## Template

```markdown
# Literature review — {topic}

**Date:** {YYYY-MM-DD}
**Target app(s):** {app_id, typically 'sia'}
**Triggering ticket:** [CAR-{n}]({URL})
**Scope:** {e.g., "retrieval for long-context Q&A, 2024–2026"}
**Confidence:** {low/medium/high}

## Executive summary

Three paragraphs:
1. Where the field is today
2. Where it's moving
3. What matters for Riché's setup specifically

## Taxonomy

How the field is organized. A few approach families with their signature methods:

### Family 1 — {name}
- **Core idea:** {one-sentence summary}
- **Signature methods / papers:** {2–3 references}
- **Strengths:** {}
- **Weaknesses:** {}

### Family 2 — {name}
…

### Family 3 — {name}
…

## Recent highlights (last 12 months)

Papers or results worth specific attention. 3–5 entries, not a dump.

### {Paper title}
- **Authors:** {list}, {year}, {venue}
- **Contribution:** One-sentence novelty.
- **Result:** Main metric + delta.
- **Why it matters:** Relevance to our setup.
- **Adoption readiness:** Is there a reference implementation? Battle-tested in production anywhere?

### {Second paper}
…

## Common benchmarks + leaderboards

- **{Benchmark}:** {URL} — what it measures, current leader, our eval's relationship to it
- **{Second benchmark}:** …

## What everyone agrees on

Points of consensus in the field. These are safe foundations.

## What's contested

Active debates or conflicting results. Areas where we shouldn't pick a side without evidence from our own setup.

## What's missing / gaps

Areas the field hasn't addressed well. Sometimes gaps are opportunities; sometimes they mean the problem is genuinely hard.

## Implications for Riché's portfolio

- Which apps this touches and how
- What to adopt now (if anything)
- What to watch
- What to defer until more mature

## Recommended follow-ups

- **Method eval:** If {technique X} is worth a deeper look → file `type:research` ticket
- **Ablation study:** If we want to test {specific variant} → file ticket
- **Implementation:** If {technique Y} is adoption-ready → hand to AI Engineer via `type:engineering`

## Sources

- {URL} — {paper title or blog post}
- {URL} — …
- {URL} — …

Organized by approach family or chronological as makes sense.

## Confidence: {low/medium/high}

Rationale: {e.g., "high on the taxonomy and consensus points; medium on leaderboard coverage because some benchmarks we haven't independently verified"}
```

## Output requirements

- Taxonomy section must organize the field into 3+ families. A flat list of papers isn't a review.
- "What everyone agrees on" AND "What's contested" sections mandatory — a review that glosses over disagreement misses the most useful part.
- Recent highlights: 3–5 papers with specific details, not a link dump.
- Implications section must name specific apps.
- Recommended follow-ups must point to specific next actions (method eval / ablation / implementation), not "we should look at this more."
- Confidence label mandatory.
