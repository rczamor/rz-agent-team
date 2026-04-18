---
name: market-analysis
description: Produce a market analysis brief covering category size, trends, buyer behavior, and implications for the portfolio. Use when the ticket asks about category dynamics rather than specific competitors. For competitor-by-competitor comparison, use competitive-matrix.
---

# market-analysis

## When to invoke

Invoke when the ticket:
- Asks about a market or category size (TAM/SAM/SOM)
- Wants trends shaping a category
- Asks how buyers behave in a segment
- Needs category-level strategic framing

For named competitor comparison, use `competitive-matrix`.

## Template

```markdown
# Market analysis — {category}

**Date:** {YYYY-MM-DD}
**Triggering ticket:** [CAR-{n}]({URL})
**Confidence:** {low/medium/high}

## Executive summary

Three bullets:
- What this market is
- What's happening (trends in motion)
- What it implies for Riché's portfolio

## Market size

- **TAM** (total addressable): ${X}B, source {citation}
- **SAM** (serviceable addressable): ${Y}B, source {citation}, reasoning {how we narrowed from TAM}
- **SOM** (serviceable obtainable): ${Z}M, source {citation or estimation}
- **Growth rate:** {X}% CAGR, source {citation}
- **Trajectory:** {early / mid / mature / declining}

## Key segments

| Segment | Approx. share | Growth | Key attributes |
|---|---|---|---|
| Enterprise | 40% | slow | long sales cycles, integration focus |
| Mid-market | 35% | moderate | hybrid buy/build, ROI pressure |
| SMB | 25% | fast | PLG-driven, price-sensitive |

## Trends

### Trend 1 — {name}
**Evidence:** Specific data points + sources
**Direction:** {accelerating / plateauing / reversing}
**Implications:** What it means for this category and for us

### Trend 2 — …
…

### Trend 3 — …
…

## Buyer behavior

- **Who buys:** Role, level
- **What triggers purchase:** Event or pain point that surfaces the need
- **Decision process:** Individual vs. committee, time-to-decide
- **What kills a deal:** Common blockers
- **Where they discover:** Channels (analyst reports, peer networks, content, search)

## Competitive landscape overview

3–5 major players at a category level. For detailed comparison, see `competitive-matrix` output.

## Disruption vectors

- AI-native entrants
- Adjacent category encroachment
- Regulatory shifts
- Open-source / commoditization

## Implications for Riché's portfolio

- Which app(s) this affects and how
- What we should do, not do, or revisit
- Decisions that would benefit from a `type:strategy-decision` ticket

## Open questions

- What we don't know that would change the brief

## Sources

- [Source 1]({URL}) — {analyst report / news / primary research}
- …

## Confidence: {low/medium/high}

Rationale: {e.g., "high on TAM because analyst reports align; medium on trends because data lags 6 months"}
```

## Output requirements

- TAM/SAM/SOM must each be attempted. If a number can't be sourced, explain why in place of the number.
- Every trend needs evidence and a direction.
- Buyer behavior section mandatory — a market brief without buyer insight is a trade press summary.
- Implications section must name specific apps, not "our business."
- Confidence label mandatory.
