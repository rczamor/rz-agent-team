---
name: Sebastian Raschka
role: rz-ai-researcher
type: individual
researched: 2026-04-18
---

# Sebastian Raschka

## Why they matter to the AI Researcher routine
Raschka writes the deepest practitioner-accessible explanations of LLM internals working today. *Build a Large Language Model (From Scratch)* (2024) walks through implementing a working GPT-2-class transformer line by line with thorough explanations of attention, embeddings, training, fine-tuning, and inference — making the architecture choices visible that papers usually abstract away. *Machine Learning Q and AI* (2023) is a Q&A-format reference covering 30 advanced ML topics (LoRA, quantization, RLHF, evaluation methods) at a level that most "from-scratch" books don't reach. His **Ahead of AI** newsletter is the most consistent practitioner-level coverage of new LLM research papers, with code examples and honest assessment of what's worth implementing. For the AI Researcher routine — particularly when evaluating proposed architectural changes, fine-tuning strategies, or method-evaluation work — Raschka is the go-to source for understanding *what's actually going on under the hood*.

## Signature works & primary sources
- *Build a Large Language Model (From Scratch)* (Manning, 2024) — the canonical "implement a transformer to actually understand it" book. Covers architecture, training, fine-tuning, RLHF.
- *Machine Learning Q and AI: 30 Essential Questions and Answers on Machine Learning and AI* (No Starch Press, 2023) — Q&A format reference; covers LoRA, quantization, mixture of experts, contrastive learning, RLHF mechanics.
- *Machine Learning with PyTorch and Scikit-Learn* (Packt, 2022; with Yuxi Liu and Vahid Mirjalili) — the broader ML reference.
- **Ahead of AI** newsletter — https://magazine.sebastianraschka.com/ — biweekly research-paper roundups with implementation notes and code.
- sebastianraschka.com — blog, course materials, GitHub repos.
- LLMs-from-scratch GitHub — https://github.com/rasbt/LLMs-from-scratch — companion code for the book; one of the most-starred ML educational repos.

## Core principles (recurring patterns)
- **Implementing forces understanding.** Most ML practitioners can't actually implement what they describe. Raschka's whole pedagogy: write the code yourself, even if it's slow, and the concepts become operational rather than abstract.
- **Tradeoffs, not magic.** Every architecture choice (attention variant, position encoding, normalization placement) is a tradeoff. Raschka consistently explains *why* a choice was made and what alternatives exist, rather than treating canonical architectures as given.
- **From-scratch first, libraries second.** Build the inefficient hand-rolled version first to understand it; then use the library version (PyTorch, Hugging Face) for production. Skipping the from-scratch step produces practitioners who treat libraries as black boxes.
- **Recent papers warrant skepticism.** The bench is being raised every week, but most papers don't replicate cleanly. Raschka's newsletter consistently distinguishes "paper claims X" from "I implemented X and observed Y." This honest reporting is the right posture for the AI Researcher routine.
- **Fine-tuning is more art than science.** LoRA, QLoRA, full fine-tuning, instruction tuning, RLHF — the choice depends on data size, compute budget, base model, target task. Raschka's writing on fine-tuning emphasizes empirical validation over recipe-following.
- **Quantization changes the math.** Most modern LLM deployment uses 4-bit or 8-bit quantization. Understanding what's lost (and what isn't) is essential for any model-evaluation work. Raschka covers this with unusual care.
- **Mechanistic understanding > performance numbers.** Knowing *why* model X outperforms model Y on task Z is more useful than knowing the gap. Raschka's writing prioritizes the why.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Architecture-change evaluation checklist** when assessing a proposed model architecture variant (rotary embeddings, MoE, sliding-window attention, etc.):
  - What does this change in computational cost (FLOPs, memory, latency)?
  - What does it change in capability (which benchmarks improve, which don't)?
  - What's the empirical evidence — does it replicate on independent setups?
  - What's the implementation cost in our setup?
  - Is this a stable production technique or research-stage?
- **Fine-tuning strategy decision tree** (paraphrased from Raschka):
  - **No data, want to steer behavior** → in-context learning with examples in the prompt
  - **<1k examples, capability-focused** → LoRA or QLoRA on a strong base model
  - **1k–100k examples, instruction following** → full fine-tuning or LoRA on instruction-tuned base
  - **100k+ examples, novel task** → consider full fine-tuning if compute allows
  - **Pre-training data scale, novel domain** → continued pre-training or domain-adaptive pre-training
- **The "from-scratch or library?" question** for any AI-engineering recommendation:
  - If the routine recommends a technique, can the AI Engineer implement the simplest version from scratch first to validate understanding?
  - If not, the recommendation should include a reference implementation (Hugging Face, PyTorch, etc.) the AI Engineer can audit
- **Quantization audit template** when proposing a deployed model:
  - At what precision will the model run? (FP32, FP16, BF16, INT8, INT4, mixed)
  - Which weights are quantized? (all, attention only, FFN only)
  - What's the empirical capability loss vs. unquantized? (always evaluate this)
  - What's the inference cost saving?
  - Is this acceptable for the use case?
- **Paper-replication caveat** for any literature review citing recent (< 6 months) results:
  - Has anyone independently replicated the result?
  - Are there known failure modes from community replication attempts?
  - What's the appropriate confidence level given replication status?

## Where they disagree with others
- Raschka vs. AutoML / "just use the API" camp: Raschka's stance is that practitioners should understand the underlying mechanics even when using high-level libraries. Black-box usage produces brittle production systems.
- Raschka vs. theoretical-only ML researchers: Raschka prioritizes implementations and empirical results over theoretical proofs. Theoretical researchers prefer the inverse. Both useful; Raschka's posture is more aligned with the AI Researcher routine's practitioner-implementer focus.
- Raschka vs. some industry-lab posture (results without code): Raschka consistently publishes code for everything he covers. Some labs publish papers without releasing implementations or full hyperparameters, which Raschka has critiqued. This is a culture issue the AI Researcher routine should track when evaluating papers.
- Raschka on RLHF: he's written critically about RLHF complexity vs. simpler alternatives (DPO, IPO, ORPO). Not anti-RLHF, but skeptical of treating it as the only path. Useful counterweight when evaluating fine-tuning strategy.

## Pointers to source material
- Personal site: https://sebastianraschka.com/
- Ahead of AI newsletter: https://magazine.sebastianraschka.com/
- Books: *Build a Large Language Model (From Scratch)* (Manning), *Machine Learning Q and AI* (No Starch Press), *Machine Learning with PyTorch and Scikit-Learn* (Packt)
- LLMs-from-scratch GitHub: https://github.com/rasbt/LLMs-from-scratch
- LinkedIn: https://www.linkedin.com/in/sebastianraschka/
- Twitter/X: @rasbt
- GitHub: https://github.com/rasbt
- YouTube channel: search "Sebastian Raschka" — courses + paper walkthroughs
