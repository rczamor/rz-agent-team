---
name: Hamel Husain & Shreya Shankar
role: qa-eng
type: individual
researched: 2026-04-16
---

# Hamel Husain & Shreya Shankar

## Why they matter to the QA Eng
This team ships AI features. The uniquely hard QA problem for SIA is not "does the function return 200" — it's "does the LLM output actually satisfy the user intent, and does it still satisfy it after a prompt tweak, a model upgrade, or a RAG corpus update?" Hamel Husain (ex-Airbnb/GitHub, founder of Parlance Labs) and Shreya Shankar (UC Berkeley PhD, "Who Validates the Validators?", SPADE, EvalGen) are the two most-cited authorities on evaluating LLM systems in production. Their Maven course *AI Evals For Engineers & PMs* (co-taught; 4,500+ students, 500+ companies as of 2026) and companion O'Reilly book *Evals for AI Engineers* (Spring 2026) define the playbook this QA Eng should use for every LLM feature: error analysis, golden sets, LLM-as-judge with calibration, and the tight iteration loop between them.

## Signature works & primary sources
- "Your AI Product Needs Evals" — https://hamel.dev/blog/posts/evals/ — the foundational essay.
- "LLM Evals: Everything You Need to Know" (FAQ) — https://hamel.dev/blog/posts/evals-faq/ — the practical reference.
- Maven course: *AI Evals For Engineers & PMs* — https://maven.com/parlance-labs/evals
- O'Reilly book: *Evals for AI Engineers* (Husain & Shankar, 2026).
- Shreya Shankar, "Who Validates the Validators?" (UIST 2024) — LLM-as-judge alignment with human preferences.
- Shreya Shankar, "SPADE: Synthesizing Data Quality Assertions" (VLDB 2024).
- hamel.dev, https://www.sh-reya.com, parlance-labs.com.

## Core principles (recurring patterns)
- **Three-level eval framework:** (1) unit-test-style assertions (cheap, run every commit), (2) human + LLM-as-judge on traces (medium cost, run per-PR or nightly), (3) A/B tests with real users (mature products).
- **Error analysis is the foundation.** Before any automation, a human reads traces — all of them at first, sampled later — and builds a taxonomy of failure modes. Hamel's teams spend **60–80% of dev time** on error analysis and evals.
- **Golden sets of labeled traces.** A domain expert (not a random labeler) gives binary pass/fail plus a short critique. This is the ground truth the whole eval stack is calibrated against.
- **LLM-as-judge requires calibration.** A judge is just another model — measure its agreement with your golden set (precision/recall/Cohen's kappa) before trusting it. Shreya's "Who Validates the Validators?" is explicit: ~100+ labeled examples minimum, recalibrate weekly.
- **Eval infra = debug infra.** The same trace-viewing tool you use to grade outputs is the tool you use to diagnose regressions. Invest in a custom viewer if open source doesn't fit your domain.
- **Unit tests > LLM judges where possible.** If a failure mode can be caught by a regex or JSON-schema check, don't waste a judge call on it. Judges are for subjective/semantic failures only.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Golden-set row schema (JSONL):**
  ```json
  {"id": "ex-001", "input": "...", "output": "...", "label": "FAIL",
   "critique": "Hallucinated the 2024 earnings figure.",
   "failure_mode": "hallucination", "labeled_by": "expert-initials",
   "labeled_at": "2026-04-10"}
  ```
- **LLM-as-judge rubric template (binary + reason):** system prompt asks for `{"pass": bool, "reason": str, "failure_mode": enum}`. Keep the rubric under 5 failure modes; expand only after error analysis justifies it.
- **Error-analysis loop (weekly):** (1) sample 20–50 production traces, (2) read each, tag `pass|fail` + freeform note, (3) open-code notes into failure-mode categories, (4) count — the biggest bar is the next thing to fix, (5) if the category is automatable, write a unit-test assertion; otherwise add to the golden set and tune the judge.
- **Eval pytest skeleton:**
  ```python
  @pytest.mark.llm_eval
  @pytest.mark.parametrize("example", load_golden_set("goldens/chat.jsonl"))
  def test_chat_quality(example, judge):
      output = run_chain(example["input"])
      verdict = judge.grade(example, output)
      assert verdict["pass"], verdict["reason"]
  ```
- **Judge-calibration checklist:** ≥100 golden examples; compute judge-vs-human agreement (precision, recall, kappa); require agreement > 0.8 before trusting the judge unattended; recalibrate on every prompt or model change.

## Where they disagree with others
- **Husain vs. generic "LLM observability" vendors:** Hamel repeatedly argues that off-the-shelf metrics dashboards are a distraction — your eval set has to be built from your own traces; there's no shortcut.
- **Husain's "look at your data" vs. LLM-as-judge automation-first:** Shreya's research and Hamel's blog both insist human error-analysis comes BEFORE a judge exists. Teams that start with a judge tend to measure the judge's blind spots, not their app's.
- **Shreya (academic rigor on validator alignment) vs. quick-start eval libraries:** DeepEval, Ragas, and similar ship with canned metrics; Shreya's work shows those metrics often don't align with the specific user's notion of quality without per-app calibration.

## Pointers to source material
- Hamel's blog: https://hamel.dev
- Shreya's site + papers: https://www.sh-reya.com
- Course: https://maven.com/parlance-labs/evals
- Book: *Evals for AI Engineers* (O'Reilly, 2026).
- Parlance Labs: https://parlance-labs.com
