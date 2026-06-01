---
name: Percy Liang & Stanford CRFM
role: rz-ai-researcher
type: individual + organization
researched: 2026-04-18
---

# Percy Liang & Stanford CRFM (Center for Research on Foundation Models)

## Why they matter to the AI Researcher routine
Percy Liang directs Stanford's **CRFM** — the academic center that has produced more rigorous foundation-model research than any single industry lab. CRFM's flagship contribution is **HELM** (Holistic Evaluation of Language Models), the most methodologically careful eval framework in the field — covering accuracy, calibration, robustness, fairness, bias, toxicity, and efficiency across hundreds of scenarios. CRFM also published "On the Opportunities and Risks of Foundation Models" (2021), the field-defining paper that gave the term "foundation model" its meaning. Liang's research group originated **DSP** (Demonstrate-Search-Predict), the precursor framework to DSPy, and helped seed the modern programmatic-prompting ecosystem. For an AI Researcher routine that needs academic-rigor methodology — particularly for `eval-spec` and `ablation-study` skills — CRFM is the source of the gold-standard practice.

## Signature works & primary sources
- HELM benchmark — https://crfm.stanford.edu/helm/ — the holistic eval framework with 7 metrics (accuracy, calibration, robustness, fairness, bias, toxicity, efficiency) across hundreds of scenarios. Continuously updated.
- "On the Opportunities and Risks of Foundation Models" (Bommasani et al., Stanford CRFM, 2021) — https://arxiv.org/abs/2108.07258 — the field-defining survey paper.
- "Evaluating Human-Language Model Interaction" (CRFM, 2022) — methodology for evaluating LMs in interactive settings (vs. one-shot prompts).
- "Sketch of a Comprehensive Catalog of LLM Evaluations" — Liang et al., ongoing.
- HELM Lite, HELM Instruct, HELM Capabilities — different HELM scopes for different model classes.
- crfm.stanford.edu — center site.
- Percy Liang's Stanford page — https://cs.stanford.edu/~pliang/ — papers, courses (CS324: Large Language Models, CS329T: Trustworthy ML).

## Core principles (recurring patterns)
- **Holistic evaluation, not single-number leaderboards.** Single-metric benchmarks (accuracy on MMLU) hide critical model behavior (bias, toxicity, robustness, calibration). HELM's principle: measure many things, surface the tradeoffs, let the reader decide what matters for their context.
- **Scenarios, not just tasks.** A scenario specifies *who* is using the model, *for what purpose*, in *what context*. The same task (summarization) has very different evaluation needs depending on the scenario (legal documents vs. tweets). Eval design starts with scenario, not metric.
- **Robustness is under-measured.** Most benchmarks measure performance on clean, in-distribution data. CRFM emphasizes evaluating with perturbations (typos, paraphrases, distribution shift) — real-world inputs are messy, and benchmarks that assume cleanness over-estimate model capability.
- **Calibration matters as much as accuracy.** A model that's 80% accurate AND knows when it's likely wrong is more useful than a 90% accurate model that confidently fails the other 10%. Calibration metrics (does confidence correlate with correctness?) are first-class in HELM.
- **Foundation models warrant new evaluation paradigms.** Pre-2020 NLP eval (BLEU, ROUGE) doesn't work for general-purpose models. New approaches: behavioral testing, capability-specific evals, model-vs-model comparison, human evaluation with calibration.
- **Reproducibility is non-negotiable.** Every HELM scenario specifies prompt format, sampling parameters, evaluation harness, and version. Eval results without these are not reproducible and shouldn't be cited.
- **Foundation models have homogenization risks.** Because thousands of downstream applications inherit the same base model's biases and failure modes, a flaw in the base model propagates everywhere. Evaluation should anticipate this.

## Concrete templates, checklists, or artifacts the agent can reuse
- **HELM-style 7-metric eval scaffold** for any `eval-spec` the routine produces:
  - **Accuracy** — task-specific success metric
  - **Calibration** — does confidence track correctness?
  - **Robustness** — performance under perturbations (typos, paraphrases, distribution shift)
  - **Fairness** — performance gap across protected demographic groups (when applicable)
  - **Bias** — stereotypical associations in outputs
  - **Toxicity** — harmful content generation
  - **Efficiency** — latency, cost per inference
  - Even if not all 7 are scored quantitatively, address each as a category in the eval design
- **Scenario specification template** (start every eval design here):
  - Who is the user? (role, context)
  - What is the task they're using the model for?
  - What inputs do they realistically provide? (sample inputs)
  - What outputs do they expect? (success criteria from user's perspective)
  - What failure modes would be most costly? (rank-order)
- **Ablation-study design discipline** (CRFM-grade rigor):
  - State the research question as a falsifiable hypothesis
  - Identify the single variable being changed (true ablation isolates one variable)
  - Identify control conditions (baseline + variants)
  - Pre-register the analysis plan (what statistical test, what threshold)
  - Report effect size + confidence interval, not just p-value
  - Discuss what the result does and does not generalize to
- **Reproducibility checklist** for any reported eval result:
  - [ ] Prompt format documented verbatim
  - [ ] Sampling parameters (temperature, top-p, max tokens) specified
  - [ ] Model version + provider documented
  - [ ] Eval harness code linked (or scenario specified well enough to reimplement)
  - [ ] Sample size + selection criteria
  - [ ] Date of evaluation (model behavior drifts over time)
- **The "what does this NOT measure?" question** for any benchmark cited:
  - HELM has been clear about its limitations. The routine should adopt this discipline: when citing a benchmark, explicitly name what it's not measuring.

## Where they disagree with others
- CRFM vs. industry-lab leaderboard chasing: CRFM is critical of single-metric leaderboard culture (the current "best on MMLU" race). Argues holistic evaluation is more useful, even if less narratively compelling.
- CRFM vs. private-eval-suite culture (some labs keep their best evals proprietary): CRFM's stance is that evals should be open-source for reproducibility and community improvement. Industry counter: open evals get gamed by training data contamination. Real tension.
- CRFM vs. Anthropic / OpenAI / DeepMind on what's worth measuring: industry labs tend to weight capability evals (what can the model do?); CRFM weights more toward safety, robustness, fairness. Both lenses needed.
- Liang's group vs. pure-DL community on programmatic prompting: DSP and DSPy treat language models as components of larger programs that can be optimized with classical ML methods. Some pure-DL researchers prefer end-to-end fine-tuning. Hybrid approaches (compose + fine-tune) are increasingly common.

## Pointers to source material
- CRFM home: https://crfm.stanford.edu/
- HELM benchmark: https://crfm.stanford.edu/helm/
- Percy Liang's page: https://cs.stanford.edu/~pliang/
- Foundation Models report: https://arxiv.org/abs/2108.07258
- Stanford CS324 (Large Language Models course, free materials): https://stanford-cs324.github.io/winter2022/
- Stanford CS329T (Trustworthy ML): https://stanford-cs329t.github.io/
- Twitter/X: @percyliang
- DSPy framework (descended from Liang's lab): https://dspy.ai/
