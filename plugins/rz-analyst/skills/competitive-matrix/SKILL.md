---
name: competitive-matrix
description: Produce a feature-by-feature comparison of 3+ competitors in a category. Use when the ticket asks who competes in a space, what they offer, and where the white space is. Output is a structured matrix plus positioning analysis.
---

# competitive-matrix

## When to invoke

Invoke when the ticket:
- Asks for a competitive landscape in a specific category
- Names specific competitors to compare
- Needs to identify positioning gaps

For broader category trends / sizing, use `market-analysis` instead. For pricing-specific work, use `pricing-study`.

## Template

```markdown
# Competitive matrix — {category}

**Date:** {YYYY-MM-DD}
**Target app(s):** {app_id or 'global'}
**Triggering ticket:** [CAR-{n}]({URL})
**Confidence:** {low/medium/high}

## Competitors evaluated

1. **{Company A}** — one-line positioning. Founded {year}. Stage ({seed/Series A/public/etc.}).
2. **{Company B}** — …
3. **{Company C}** — …

(Include 3–7 competitors. Fewer than 3 is not a matrix; more than 7 is noise.)

## Feature comparison

| Feature | Company A | Company B | Company C | Us |
|---|---|---|---|---|
| Core feature 1 | ✓ strong | ✓ basic | ✗ | {status} |
| Core feature 2 | ✗ | ✓ | ✓ | {status} |
| Feature 3 | ... | ... | ... | ... |
| Pricing entry point | $X/mo | $Y/mo | Free + $Z/mo | {status} |
| Target segment | SMB | Enterprise | Consumer | {us} |
| Go-to-market | PLG | Sales-led | Community | {us} |
| Open source? | No | Partial | Yes | {us} |

Each cell must be verifiable — cite sources below. Prefer ✓/✗ + one word over long descriptions.

## Positioning map

Two axes that matter most for this category:
- X-axis: {axis name}
- Y-axis: {axis name}

```
                    {Y-high}
                       |
  Company B  ○         |         ● Company A
                       |
  ─────────────────────┼─────────────────────
             {X-low}   |   {X-high}
                       |
       ○ Company C     |
                       |
                    {Y-low}
```

## White space

Quadrants or feature combinations that are unclaimed:
- {combination A}
- {combination B}

## Direct competitive threats (ranked)

1. **{Company}** — why they're the biggest threat. How close they are to our position.
2. **{Company}** — …

## Our positioning implications

- What we should emphasize (differentiators we actually own)
- What we should de-emphasize (claims others do better)
- Product gaps that need investment
- Messaging pivots to consider (hand to Brand/Content in Cowork — don't prescribe messaging yourself)

## Sources

- [Source 1]({URL}) — what this source covers
- [Source 2]({URL}) — …
- Research date range: {start} to {end}

## Confidence: {low/medium/high}

Rationale: {what makes this confidence level — e.g., "public data only, no win/loss interviews" = medium}
```

## Output requirements

- Every cell in the feature comparison must be verifiable. If a source doesn't confirm, mark `?` and note it.
- Positioning map requires two axes, not one. Pick the two that drive differentiation.
- Direct threats section ranks — not just lists.
- Must include "what we should emphasize" AND "what we should de-emphasize" — a one-sided read is incomplete.
- Confidence label mandatory; default `medium`.
