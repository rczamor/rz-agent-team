---
name: ablation-study
description: Design an ablation or comparative study — isolate variables, compare variants, produce a recommendation grounded in eval results. Use when the ticket asks which of several variants (prompt versions, hyperparameters, architecture choices) works best.
---

# ablation-study

## When to invoke

Invoke when the ticket:
- Names multiple variants and asks which is best
- Asks to isolate the impact of a specific variable (e.g., "does the rerank stage help?")
- Needs a structured comparison that controls for confounds

For evaluating a single named technique, use `method-eval`. For designing the eval harness itself, use `eval-spec` (which may precede this).

## Template

```markdown
# Ablation study — {what we're ablating}

**Date:** {YYYY-MM-DD}
**Target app:** {app_id}
**Triggering ticket:** [CAR-{n}]({URL})
**Confidence:** {low/medium/high}

## Research question

Specific, testable. E.g., "Does adding a rerank stage after bi-encoder retrieval improve consolidation relevance at our current corpus size?"

## Hypothesis

What we expect to find, and why. Explicit hypothesis makes the study falsifiable.
- **H1:** Adding rerank improves relevance by ≥ 10% on our eval set.
- **H0 (null):** No meaningful difference (< 3% change, within noise).

## Variables

### Independent variable (what we're changing)
- {Variable} with {N} levels: {A, B, C}

### Dependent variables (what we're measuring)
- Primary: {metric}
- Secondary: {metrics}
- Guardrails: {latency, cost, failure rate}

### Control (what we're holding constant)
- Model: {fixed}
- Dataset: {fixed}
- Prompt: {fixed except for the independent variable}
- Infrastructure: {fixed}

### Confounds to watch for
- {e.g., "rerank adds latency; if latency matters, we're confounding quality with speed"}

## Experimental design

- **Variants:** {N}
- **Trials per variant:** {N}
- **Randomization:** {how inputs are assigned to variants — paired? randomized?}
- **Blinding:** {is the judge blind to which variant produced each output?}

## Eval rubric

Link to `eval-spec` output (the rubric being used). If no existing eval fits, run `eval-spec` first before this study.

## Statistical plan

- **Primary analysis:** Paired t-test / Mann-Whitney U / etc. between pairs of variants
- **Significance threshold:** p < 0.05 (or Bonferroni-corrected for N comparisons)
- **Effect size:** Cohen's d or equivalent — practical significance, not just statistical
- **Power analysis:** Sample size needed to detect the hypothesized effect

## Results

(Populate after running.)

### Primary metric

| Variant | Mean | 95% CI | vs. Baseline | p-value |
|---|---|---|---|---|
| Baseline | ... | ... | - | - |
| A | ... | ... | ... | ... |
| B | ... | ... | ... | ... |
| C | ... | ... | ... | ... |

### Guardrails

| Variant | Latency p95 | Cost per run | Failure rate |
|---|---|---|---|
| Baseline | ... | ... | ... |
| A | ... | ... | ... |
| ... | ... | ... | ... |

### Per-slice analysis

Does the effect hold across important slices (e.g., input length, language, topic)? Or is it driven by a subset?

## Interpretation

- Does H1 hold? H0?
- Is the effect size practically meaningful, or just statistically significant?
- Which variant wins, and is the gap robust?
- Where does the effect NOT hold (slices where variants tie or lose)?

## Recommendation

- **Adopt variant {X}** — why, with specific conditions
- **Continue baseline** — why
- **Run follow-up study** — what new question this raised

## Limitations

- Sample size constraints
- Eval set coverage gaps
- Distribution shift from production
- Time-bounded observation

## Handoff to AI Engineer

Implementation ticket scope if adopting a variant.

## Confidence: {low/medium/high}
```

## Output requirements

- Research question must be one sentence, testable.
- Hypothesis mandatory (both H1 and H0).
- Control section must list what's held constant.
- Statistical plan specified BEFORE running (pre-registration discipline).
- Results section has per-slice analysis — aggregate results can hide failures.
- Limitations section mandatory.
- Confidence label mandatory.
