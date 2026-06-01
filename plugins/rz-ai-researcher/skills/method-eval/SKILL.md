---
name: method-eval
description: Evaluate a single AI technique against Riché's setup and produce an adopt/trial/hold/reject recommendation. Use when the ticket asks whether a specific method (new retrieval technique, prompting pattern, model, fine-tuning approach) is worth adopting.
---

# method-eval

## When to invoke

Invoke when the ticket:
- Names a specific AI technique and asks if we should adopt it
- References a paper and asks for a read on production applicability
- Asks for a recommendation on a specific model or technique

For comparing several variants, use `ablation-study`. For SOTA surveys, use `literature-review`.

## Template

```markdown
# Method eval — {technique name}

**Date:** {YYYY-MM-DD}
**Target app(s):** {app_id, typically 'sia'}
**Triggering ticket:** [CAR-{n}]({URL})
**Recommendation:** Adopt | Trial | Hold | Reject
**Confidence:** {low/medium/high}

## What the technique is

Short technical summary. Assume the reader (AI Engineer or Riché) has ML fluency but may not have read this specific paper.

## Source paper(s) / reference implementation

- [Paper title]({arxiv URL}) — {authors, date, venue}
- [Reference implementation]({repo URL}) — {state: official? fork? production?}

## What it claims

- **Main result:** {metric + delta vs. baseline}
- **Benchmarks:** {which ones, numbers}
- **Conditions under which it works:** {data regime, scale, compute}

## How it would map to our setup

- **Where it would live:** e.g., "replace current rerank stage in `sia/app/services/knowledge_store.py`"
- **What it replaces / augments:** {specific code paths}
- **Dependencies:** Model size, compute, data quality, new libraries
- **Integration cost:** Hours / complexity (low / med / high)
- **Affects which other components:** ripple analysis

## Why it might NOT work for us

- **Data regime differences:** Paper used X, we have Y
- **Scale differences:** Paper ran on H100s, we're VPS
- **Infrastructure constraints:** Our latency SLO is Z, this technique's latency floor is W
- **Prior art we've tried:** We previously tried {related thing}, didn't generalize because {reason}

## Proposed eval

### Metric(s)
- Primary: {specific number we'd target}
- Guardrails: {what cannot regress}

### Dataset
- {existing eval set or new set needed}
- Size: {N samples}
- Coverage: {what types of inputs}

### Baseline
- {current SIA behavior with specific numbers}

### Sample size / runs
- {N runs; variance target}

### Success criteria
- {specific threshold for "keep" — e.g., "primary metric +10% with no guardrail regression > 2%"}

## Recommendation

### Adopt
The eval plan is expected to show clear win, integration cost is bounded, risk is manageable. File `type:engineering` ticket for AI Engineer with scope.

### Trial
Prototype → measure → decide. File ticket for prototype with explicit success criteria.

### Hold
Right idea, wrong time. Revisit when {trigger, e.g., "we have X eval set" or "the technique matures to production reference impl"}.

### Reject
Unlikely to help given our constraints. Here's what would change our mind: {trigger}.

Pick one.

## Open questions

- What we don't know that would change the recommendation

## Handoff to AI Engineer

If adopting or trialing, a follow-up `type:engineering` ticket for AI Engineer with:
- **Scope:** What to prototype/build
- **Acceptance criteria:** The eval plan above (verbatim)
- **Upstream reference:** This brief (Notion URL)
- **Out of scope:** {anything AI Engineer should NOT do in this first pass}

## Confidence: {low/medium/high}
```

## Output requirements

- Recommendation is mandatory and singular (one of Adopt/Trial/Hold/Reject).
- "Why it might NOT work for us" section mandatory — the single most valuable part of the brief.
- Eval plan mandatory; cannot recommend Adopt or Trial without one.
- Handoff to AI Engineer section required when recommendation is Adopt or Trial.
- "What would change our mind" required when recommendation is Hold or Reject.
- Confidence label mandatory.
