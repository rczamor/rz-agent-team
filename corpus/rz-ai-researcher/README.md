---
role: rz-ai-researcher
researched: 2026-04-18
---

# rz-ai-researcher (AI Researcher) corpus index

Role-specific knowledge for the AI Researcher strategic routine. The routine produces method evaluations, eval specs, ablation study designs, and literature reviews — primarily for SIA but applicable to any app using AI. Stateless between runs; writes durable artifacts to the [AI Research Library Notion hub](https://www.notion.so/346ac0ea4f658165b27eed3e781ffab4). Plugin lives at `plugins/rz-ai-researcher/`.

## Files

- [anthropic-applied-ai.md](./anthropic-applied-ai.md) *(symlink to ai-eng)* — Direct source for Claude capabilities, tool use, MCP, agent patterns, and recent research papers. Primary reference since the routines run on Claude.
- [hamel-husain.md](./hamel-husain.md) *(symlink to ai-eng)* — LLM evals: rubric design, LLM-as-judge calibration, error analysis. The bottleneck discipline for any AI product.
- [chip-huyen.md](./chip-huyen.md) *(symlink to ai-eng)* — *AI Engineering* (2024) is the most comprehensive practitioner treatment of retrieval, evals, fine-tuning, and agents.
- [simon-willison.md](./simon-willison.md) *(symlink to ai-eng)* — Daily LLM ecosystem coverage; clearest tutorials on prompt injection, structured outputs, eval patterns.
- [latent-space-lilian-weng.md](./latent-space-lilian-weng.md) *(symlink to ai-eng)* — Latent Space podcast/newsletter + Lilian Weng's technically rigorous LLM-method explainers (agent loops, hallucination taxonomy, prompt patterns).
- [percy-liang-crfm.md](./percy-liang-crfm.md) — Stanford CRFM's HELM (the gold-standard holistic eval framework) + foundation-models research. Methodology source for eval-spec rigor.
- [sebastian-raschka.md](./sebastian-raschka.md) — *Build an LLM From Scratch* + Ahead of AI newsletter. The deepest practitioner-accessible coverage of model internals; essential for understanding architectural-change proposals and fine-tuning strategy.
- [omar-khattab-dspy.md](./omar-khattab-dspy.md) — DSPy framework + ColBERT retrieval + Compound AI Systems thesis. Modern research-grade vocabulary for programmatic LLM systems and retrieval architecture decisions.

## How the routine uses these

At session start, the routine's `session` skill reads this README to orient. For specific output skills:

- **method-eval** → Anthropic + Khattab/DSPy (for compound-AI-system patterns) + Raschka (for understanding architectural changes) + Hamel (for required eval-plan rigor)
- **eval-spec** → Percy Liang/CRFM (HELM 7-metric scaffold + scenario specification) + Hamel (rubric construction + LLM-as-judge calibration) + Chip Huyen (production eval methodology)
- **ablation-study** → Percy Liang/CRFM (academic-rigor design) + Raschka (mechanistic understanding of what's being ablated) + Hamel (statistical treatment + reproducibility)
- **literature-review** → Lilian Weng (the gold standard for LLM-explainer essays) + Anthropic research papers + Raschka's Ahead of AI for paper triage + Simon Willison for daily-current ecosystem awareness

## Inheritance from the AI Engineer corpus

Five of the eight entries (Anthropic, Hamel, Chip Huyen, Simon Willison, Latent Space/Lilian Weng) are symlinks to the AI Engineer corpus that predates the strategic-routines architecture. The thinking applies regardless of which routine reads it — the role-frontmatter difference doesn't affect the substance.

The three new entries (Percy Liang/CRFM, Sebastian Raschka, Omar Khattab/DSPy) add **academic-research-grade voices** that the practitioner-focused AI Engineer corpus didn't cover. These are the sources the AI Researcher needs when its job is to evaluate methods, design evals, and survey literature — not to ship production AI code.

## Handoff to AI Engineer

The AI Researcher routine consistently produces artifacts that AI Engineer (execution layer) implements. The handoff contract is documented in the routine's session skill: when the recommendation is Adopt or Trial, the AI Researcher files a `type:engineering` Linear ticket with implementation scope. The AI Engineer corpus (corpus/ai-eng/) covers the implementation craft; this corpus covers the research craft that precedes implementation.
