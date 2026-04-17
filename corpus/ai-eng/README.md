---
role: ai-eng
researched: 2026-04-16
---

# AI Eng Corpus

Role-specific knowledge sources for the AI Eng agent. AI Eng owns Langfuse prompts, consolidation/generation pipelines, search tuning, and MCP tools. Primary model: Claude Opus 4.7. Observability is mandatory — every LLM call to Langfuse with prompt/response/model/tokens/cost, extended thinking enabled.

## Index

- [anthropic-applied-ai.md](./anthropic-applied-ai.md) — Direct source for Claude behavior, prompt engineering, tool use, MCP, and the "Building effective agents" workflow-vs-agent taxonomy. The spine of the role.
- [hamel-husain.md](./hamel-husain.md) — The canonical voice on LLM evals. Three-level eval hierarchy, error analysis as the loop, LLM-as-judge alignment, "remove all friction from looking at data."
- [jason-liu.md](./jason-liu.md) — Instructor (Pydantic + LLM structured outputs), systematic RAG improvement, the 6 RAG evals, "simple tools win" for search. Load-bearing for consolidation pipeline + search tuning.
- [simon-willison.md](./simon-willison.md) — The `llm` CLI, daily frontier tracking, and the *lethal trifecta* framing (private data + untrusted content + external communication) that governs MCP tool design security.
- [chip-huyen.md](./chip-huyen.md) — *AI Engineering* (2024) reference for retrieval, agents, evals, and inference. Tool taxonomy, failure-mode taxonomy, plan/validate/execute/reflect decomposition. (Tilted away from pipeline/data-quality content that lives in Data Eng.)
- [langchain-llamaindex.md](./langchain-llamaindex.md) — Largest public corpus on RAG patterns and agent architectures. LangGraph when durable execution matters; LlamaIndex primitives (nodes/metadata/query engine) as mental model even without the library.
- [latent-space-lilian-weng.md](./latent-space-lilian-weng.md) — Latent Space (swyx + Alessio) for weekly signal on what AI-native companies ship; Lilian Weng's blog for canonical explainers on agents, hallucination, prompt patterns.

## How to use this corpus
1. Start with **anthropic-applied-ai.md** for any agent-design decision — Claude is the primary model and their guidance is authoritative.
2. Reach for **hamel-husain.md** before writing a new prompt or adding a feature — the eval set comes first.
3. Reach for **jason-liu.md** when a tool output feeds code (structured outputs) or when tuning search.
4. Reach for **simon-willison.md** when designing an MCP tool — run the lethal-trifecta audit.
5. Reach for **chip-huyen.md** for a second opinion on agent architecture, failure taxonomies, and eval metrics.
6. Reach for **langchain-llamaindex.md** for RAG pattern libraries and when considering LangGraph for durable execution.
7. Reach for **latent-space-lilian-weng.md** for weekly industry signal and foundational explainers.
