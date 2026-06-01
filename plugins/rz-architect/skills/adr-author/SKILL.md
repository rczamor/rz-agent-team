---
name: adr-author
description: Author an Architecture Decision Record when the ticket asks for a documented decision with context, options considered, a recommendation, and consequences. Default output type for Technical Architect sessions when scope is a single decision.
---

# adr-author — Architecture Decision Record

## When to invoke

Invoke when the ticket:
- Asks "should we use X or Y?"
- Proposes a change that will be hard to reverse
- References an existing pattern that needs to be documented as a decision
- Asks for the "right way" to do something across the portfolio

If the ticket is about integration between systems, use `integration-design` instead. If it's comparing three or more candidates across criteria, use `tech-stack-eval`.

## Template

```markdown
# ADR-{next-number} — {short decision title}

**Status:** Proposed | Accepted | Superseded by ADR-{n}
**Date:** {YYYY-MM-DD}
**Target app(s):** {app_id or 'global'}
**Triggering ticket:** [CAR-{n}]({Linear URL})
**Decision owner:** Riché

## Context
What forces are at play? What constraints exist? What makes this decision necessary now? Include the non-obvious pressures (deadlines, cost, prior commitments). One or two paragraphs.

## Decision
The single decision, stated plainly. One paragraph. No hedging.

## Options considered

### Option A: {name}
- Summary
- Pros
- Cons
- Cost/complexity estimate (low/med/high)

### Option B: {name}
...

### Option C: {name}
...

## Recommendation
Which option and why. If this is the architect's call, recommend. If it's a product decision dressed as architecture, hand to Riché and explain why.

## Consequences
- What becomes easier
- What becomes harder
- What future decisions does this foreclose
- Revisit criteria: what would trigger reopening this ADR

## Open questions
- What the decision does NOT resolve

## References
- Prior ADRs (link)
- External sources (URLs)
- Related Notion pages
```

## Numbering

ADRs are sequentially numbered across the portfolio. Before writing, query the ADR Log hub in Notion and use the next available number.

## Output requirements

- Title format: `ADR-{n} — {short decision title}` (kebab-case not required, just readable)
- Status starts as `Proposed` unless Riché has already approved in the ticket thread
- Every "Cost/complexity estimate" must commit to low/med/high — no "depends"
- At least 2 options. 3+ is better. A one-option ADR is a fait accompli, not a decision.
- Open questions section should be non-empty unless the decision is genuinely complete
