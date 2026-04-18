---
name: eval-spec
description: Design an evaluation for an AI capability — rubric, dataset, methodology, success criteria. Use when the ticket asks how to measure something (prompt quality, retrieval relevance, consolidation, etc.) without pre-selecting a specific technique.
---

# eval-spec

## When to invoke

Invoke when the ticket:
- Asks "how do we measure X?"
- Needs an eval to unblock a downstream decision
- Proposes a new AI capability and asks what "good" looks like

For comparing variants, use `ablation-study` (which uses an eval but has additional structure). For evaluating a specific named technique, use `method-eval`.

## Template

```markdown
# Eval spec — {what we're measuring}

**Date:** {YYYY-MM-DD}
**Target app:** {app_id}
**Triggering ticket:** [CAR-{n}]({URL})
**Confidence:** {low/medium/high}

## What we're measuring

Plain-language statement. E.g., "Quality of SIA's consolidation output given N raw sources covering the same topic."

## Why this eval matters

What decision does this eval unblock? Without this eval, what risk remains?

## Rubric

### Dimension 1 — {name}
- **5:** {specific, observable behavior}
- **4:** {slightly below ideal}
- **3:** {acceptable baseline}
- **2:** {clear issue}
- **1:** {broken}

### Dimension 2 — {name}
- 5: …
- 3: …
- 1: …

### Dimension 3 — …

### Overall score

How dimensions compose into overall:
- **Gated:** Fail one = fail all. Use when a dimension is non-negotiable.
- **Weighted:** Weighted sum with weights summing to 100. Use when tradeoffs are acceptable.

Say which and why.

## Dataset

- **Source of inputs:** e.g., "50 sampled consolidation tasks from Langfuse traces, Mar–Apr 2026, stratified by source count"
- **Ground truth:** How determined. Options:
  - Human-labeled (how many labelers? agreement threshold?)
  - LLM-as-judge (which judge model? prompt template?)
  - Synthetic / programmatic
  - Held-out reference (if one exists)
- **Class balance / coverage:** Stratification across important dimensions (e.g., short vs. long inputs, English vs. other, etc.)
- **Size:** Starting N; plan for growth.

## Methodology

### Judge model (if LLM-as-judge)
- **Model:** {Opus / Sonnet / other}
- **Prompt:** (paste full prompt or link to Langfuse prompt ID)
- **Calibration:** Human vs. judge agreement check on a golden subset ({N} samples)

### Statistical treatment
- Confidence intervals (bootstrap, assumption)
- Significance thresholds for comparing variants (e.g., p < 0.05)
- Multiple comparison correction if needed

### Reproducibility
- Seed control
- Eval infrastructure (where it runs, how to rerun)

## Success criteria

- **Absolute thresholds:** e.g., "overall ≥ 4.0 across the dataset"
- **Relative thresholds** (for comparing variants): "new variant must beat baseline by ≥ 0.3 overall with p < 0.05"
- **Minimum coverage:** what fraction of inputs must score ≥ threshold

## Failure modes to watch for

- **Judge drift:** Same judge scoring differently over time or for similar inputs
- **Dataset bias:** Eval set doesn't represent production distribution
- **Overfitting to eval:** Developers tune to the eval set, regressing on held-out real inputs
- **Gaming the rubric:** A variant scores well but doesn't solve the actual problem (specification gaming)

## Calibration plan

Before putting this eval into production gating:
1. Human-label {N} golden samples
2. Run judge on same samples
3. Measure inter-rater reliability + judge-human agreement
4. Target: {Cohen's kappa ≥ 0.7} or equivalent

Recalibrate every {quarter / as drift is detected}.

## Implementation handoff

AI Engineer ticket scope: {bullet list of what to build}.

## Confidence: {low/medium/high}
```

## Output requirements

- At least 3 rubric dimensions.
- Each dimension's 1–5 scale must have concrete, observable behaviors at 5, 3, and 1 (anchor points).
- Overall score composition (gated vs. weighted) must be specified with rationale.
- Dataset section must commit to a size and ground-truth method.
- Failure modes section mandatory — helps AI Engineer know what to watch.
- Calibration plan mandatory before the eval is gating anything.
