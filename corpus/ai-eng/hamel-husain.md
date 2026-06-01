---
name: Hamel Husain
role: ai-eng
type: individual
researched: 2026-04-16
---

# Hamel Husain

## Why they matter to the AI Eng
Hamel is the sharpest living voice on *how to actually evaluate LLM systems*, which is the single biggest bottleneck between a cool demo and a production agent. His core thesis — that teams over-invest in prompt tweaks and under-invest in looking at data — maps directly onto the AI Eng's job of running a consolidation/generation pipeline where every Langfuse trace is a data point. His eval-first mental model (unit tests → human/model eval → A/B) tells the AI Eng exactly how to grow the eval suite over time, and his insistence on *domain-expert-reviewed golden sets* is the right counterweight to the temptation to auto-generate everything with an LLM-as-judge and call it done.

## Signature works & primary sources
- "Your AI Product Needs Evals" — https://hamel.dev/blog/posts/evals/ — The canonical article. Three-level eval hierarchy, LLM-as-judge alignment, error analysis as the core loop.
- "A Field Guide to Rapidly Improving AI Products" — https://hamel.dev/blog/posts/field-guide/ — Error analysis and iteration loops.
- "Creating a LLM-as-a-Judge That Drives Business Results" — https://hamel.dev/blog/posts/llm-judge/ — How to iterate an LLM judge against human labels.
- AI Evals course with Shreya Shankar — https://maven.com/parlance-labs/evals — Hands-on cohort-based.
- Parlance Labs blog — https://parlance-labs.com/

## Core principles (recurring patterns)
- **"You are doing it wrong if you aren't looking at lots of data."** Looking at traces is the job, not a chore. Build the lowest-friction trace viewer you can — Langfuse filters plus a domain-specific view.
- **Remove ALL friction from looking at data.** Embed CRM links, prompt diffs, tool-call context, user ids. Every click between you and the raw example loses you an insight.
- **Three-level eval hierarchy:** Level 1 unit tests (cheap, on every commit), Level 2 human + model eval (weekly, curated), Level 3 A/B (after significant shifts). Don't skip L1 to do fancy L2.
- **Binary labels beat Likert scales.** "Good / bad" with a short rationale — less inter-rater noise, faster labeling, cleaner judge training signal.
- **LLM-as-judge requires meta-eval.** Track precision & recall of your judge against human labels, not just agreement. Imbalanced classes make raw agreement meaningless.
- **Keep it simple. Don't buy fancy LLM tools.** Spreadsheets + Jupyter beat most eval platforms for early-stage iteration. (He uses Langfuse for traces, not for scoring.)
- **Error analysis drives everything downstream.** The same labeled traces feed evals, fine-tuning data, and prompt fixes — one flywheel, not three silos.

## Concrete templates, checklists, or artifacts the agent can reuse

**Eval-set skeleton (per task):**
```yaml
task: consolidate_memories
golden_examples:
  - id: mem-001
    input: {raw_traces: [...], user_context: "..."}
    expected_output: {consolidation_type: "merge", ...}
    labels:
      correctness: pass
      grounding: pass
    reviewer: rz
    notes: "Merges two near-duplicate gym notes from same week"
```

**LLM-as-judge rubric (binary + rationale):**
```
You are grading whether a consolidated memory is FAITHFUL to the source traces.

PASS if every fact in <consolidation> appears in <sources>.
FAIL if any fact is added, dropped with losing information, or contradicts a source.

Return JSON: {"label": "pass"|"fail", "rationale": "<one sentence>"}
```

**Error-analysis loop (weekly ritual):**
1. Pull 50 Langfuse traces from prod (stratified: errors, low-confidence, random).
2. Open each trace in Langfuse + your domain view side by side.
3. Tag each with a failure category (new categories allowed — cluster later).
4. Count categories. Fix the top 2 root causes *before* tweaking prompts.
5. Add 3–5 new golden examples covering the new categories.

**Judge-alignment spreadsheet columns:**
`trace_id | input | output | human_label | judge_label | agree | reviewer_notes`
Recompute precision/recall per class after every judge-prompt change.

## Where they disagree with others
- **Husain vs. Weights & Biases / Langfuse dashboards-as-product:** He'll use the tools for storage and filtering but insists the *thinking* happens in spreadsheets and notebooks you own. Don't let dashboard UX dictate your eval design.
- **Husain vs. "just use LLM-as-judge":** Pure model grading without human-aligned meta-eval is worse than no eval — it gives false confidence. Always align the judge to human labels on a held-out set first.
- **Husain vs. prompt-optimizer tooling:** DSPy / auto-prompt tools are downstream of evals, not a substitute. Without a golden set you're optimizing against vibes.

## Pointers to source material
- hamel.dev (blog, the canonical source)
- parlance-labs.com (his consultancy)
- maven.com/parlance-labs/evals (paid course with Shreya Shankar)
- twitter.com/HamelHusain (daily commentary, thread-heavy)
- github.com/hamelsmu
