---
name: opportunity-brief
description: Produce a sized opportunity brief with problem, solution direction, size, readiness, and recommendation. Default output type for Analyst sessions when the ticket is broad and needs a "should we pursue this" answer.
---

# opportunity-brief

## When to invoke

Invoke when the ticket:
- Asks "should we pursue X?"
- Proposes a new product direction, feature, or market move
- Needs sizing + recommendation, not just analysis

Default to this skill when the ticket is ambiguous. Most analyst work is an opportunity assessment in disguise.

## Template

```markdown
# Opportunity brief — {short name}

**Date:** {YYYY-MM-DD}
**Target app(s):** {app_id or 'global'}
**Triggering ticket:** [CAR-{n}]({URL})
**Recommendation:** Pursue | Pursue narrow | Defer | Pass
**Confidence:** {low/medium/high}

## Executive summary

Three sentences max. The opportunity, the recommendation, the single most important reason.

## Problem

Who has the pain, and what is it? Describe in user terms, not feature terms. Evidence from research, support tickets, market signals, or Riché's own observation.

## Current alternatives

How do affected users solve this today?
- **Solution A** ({existing product or workaround}) — why it's insufficient
- **Solution B** — …
- **DIY / do nothing** — rationale

Understanding alternatives clarifies what "good enough" looks like.

## Solution direction

Not a spec — that's PM-lite's job. A directional statement about how we'd solve the problem, and what makes our approach different or right.

## Size

### How big is this?

- **Total addressable:** {N users / ${X}M revenue / both}, source
- **Initial addressable:** {who we could realistically reach in 12 months}, source
- **Willingness to pay (if commercial):** inferred from benchmarks or validated

### What's a winning outcome?

Define success criteria in numbers:
- 12-month: {N users or ${X} or {other metric}}
- 24-month: {…}

## Readiness

| Dimension | Status | Gap |
|---|---|---|
| Product (can we build it?) | {green/yellow/red} | … |
| Distribution (can we reach buyers?) | {color} | … |
| Monetization (can we capture value?) | {color} | … |
| Team (do we have the capacity?) | {color} | … |
| Timing (is the market ready?) | {color} | … |

Overall readiness: {green / yellow / red}.

## Competitive dynamics

Who else is (or will be) attacking this? How quickly? What's our defensible wedge?

## Strategic fit

- Does this fit Riché's portfolio direction?
- Does it strengthen or dilute focus?
- What's the opportunity cost (what else we'd trade off)?

## Recommendation

### Pursue
Proceed now with {specific scope}. First step: {action}.

### Pursue narrow
Pursue a focused wedge: {what}. Defer broader scope until we've proven {assumption}.

### Defer
Right opportunity, wrong time. Revisit when {trigger condition}.

### Pass
The math / fit doesn't work. Here's what would change our mind: {trigger}.

Pick one. Be clear about scope if "Pursue narrow."

## Risks

- **Market risk:** What if buyers don't materialize
- **Execution risk:** What makes this hard to build or ship
- **Competitive risk:** What if competitors move faster
- **Opportunity cost:** What we're not doing by doing this

## Decision needed from Riché

If any, file a `type:strategy-decision` ticket with this brief linked. State the decision in one sentence: "Should we {commit / invest / pass}?"

## Sources

- {URL} — {what it contributes}
- …

## Confidence: {low/medium/high}
```

## Output requirements

- Recommendation is mandatory and singular (one of four). No "it depends" without committing to scope narrowing.
- Size section must attempt specific numbers. "Large" is not a size.
- Readiness table must color-code all 5 dimensions.
- If recommendation is "Pass," the "what would change our mind" trigger is mandatory.
- Decision request to Riché: state as a yes/no or among named options.
