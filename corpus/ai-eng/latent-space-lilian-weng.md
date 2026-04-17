---
name: Latent Space + Lilian Weng
role: ai-eng
type: publication
researched: 2026-04-16
---

# Latent Space + Lilian Weng

## Why they matter to the AI Eng
*Latent Space* (swyx and Alessio's podcast/newsletter) is the working AI engineer's primary signal on what the frontier labs are actually shipping, what inference and tooling stacks the top AI-native companies use, and how agent architectures are evolving week to week. It's where you hear the Anthropic/OpenAI/Cursor/Replit/Cognition engineers explain their systems in their own words. Lilian Weng's blog (she led applied research at OpenAI and now runs Thinking Machines Lab) is the opposite register — slow, rigorous, canonical explainers on agents, hallucination, prompt patterns, reward hacking, that every AI engineer ends up citing. Together they give the AI Eng both the heartbeat of the industry and the foundational frameworks — the "What's new this week?" and the "How do agents actually work?" ends of the literature.

## Signature works & primary sources
- Latent Space podcast/newsletter — https://www.latent.space — Top-10 US tech podcast, 200k+ subscribers, weekly long-form interviews.
- Latent Space "AI Engineer" framing — https://www.latent.space/p/ai-engineer — swyx's coinage that defined the role.
- swyx's agent framework (IMPACT) — https://www.latent.space/p/agent — Intent, Memory, Planning, Control flow, Authority, Tools.
- Weng: "LLM Powered Autonomous Agents" — https://lilianweng.github.io/posts/2023-06-23-agent/ — The canonical agent-architecture post (Planning + Memory + Tool use).
- Weng: "Extrinsic Hallucinations in LLMs" — https://lilianweng.github.io/posts/2024-07-07-hallucination/ — Causes, detection, mitigation.
- Weng: "Prompt Engineering" — https://lilianweng.github.io/posts/2023-03-15-prompt-engineering/ — Zero-shot, few-shot, CoT, self-consistency, ToT.
- Weng: "Reward Hacking in RL" — https://lilianweng.github.io/posts/2024-11-28-reward-hacking/

## Core principles (recurring patterns)
- **Agents = Planning + Memory + Tool use.** Weng's three-component decomposition is the default mental model, and every modern agent (including Claude's) maps onto it.
- **Memory has layers.** Sensory (embeddings), short-term (in-context window), long-term (external vector/key-value store). Design each layer explicitly; don't conflate.
- **Extrinsic hallucination is a retrieval + verification problem.** RAG grounds, chain-of-verification checks, and citation training are the three active mitigations. Combine them.
- **Three failure modes of agents (Weng):** finite context windows, unreliable long-horizon planning, brittle natural-language interfaces between components.
- **IMPACT (swyx):** Intent, Memory, Planning, Control flow, Authority, Tools. The "Authority" axis — delegated trust — is underrated and load-bearing for production deployment.
- **Structured outputs + MCP = the new tool standard.** Latent Space tracks the consolidation of the field around these two primitives; design for them.
- **Read papers at the level of their diagrams, not their math.** swyx's weekly LLM paper club models this — understand the architecture and ablations, not every equation.

## Concrete templates, checklists, or artifacts the agent can reuse

**Weng's agent architecture as a Langfuse trace schema:**
```
trace:
  planning:
    subgoals: [...]
    method: "CoT" | "ToT" | "ReAct" | "Reflexion"
  memory_access:
    short_term_tokens: int
    long_term_hits: [{id, score, snippet}]
  tool_calls:
    - tool: str
      input: dict
      output: dict
      latency_ms: int
  reflection:
    self_eval: str
    next_action: "done" | "retry" | "replan"
```

**Hallucination-mitigation stack (Weng-derived, applied to generation pipeline):**
1. **Ground with retrieval** — every claim in the output must trace to a retrieved source.
2. **Chain-of-Verification** — after generation, emit verification questions, re-query retrieval, check consistency.
3. **Cite or abstain** — if no source found, say "I don't know" (configure the model to prefer this over guessing).
4. **Atomic-fact eval** — for generated memories, decompose output into atomic facts; score each against sources (FActScore-style).

**IMPACT checklist for new agent features (swyx):**
- [ ] **Intent** — Is the goal multimodal? Is there an eval for it?
- [ ] **Memory** — Short-term window size? Long-term store design? Compaction policy?
- [ ] **Planning** — Plan editable by user? Plan logged to Langfuse?
- [ ] **Control flow** — How much does the LLM decide vs. code? Logged as trace structure?
- [ ] **Authority** — What can this agent do without asking? What requires confirmation?
- [ ] **Tools** — RAG? Sandbox? Browser? Each with its own failure profile?

**Weekly AI-engineering intake (a working ritual):**
- Monday: skim Latent Space newsletter + top Hacker News AI threads
- Wednesday: listen to the week's Latent Space episode (agents/inference topics only, skip hype)
- Friday: read one Weng post or the paper it cites, take notes into the team memory

## Where they disagree with others
- **Weng vs. Anthropic on agent definition:** Weng's three-component (planning + memory + tool use) is architectural; Anthropic's (dynamic vs. predetermined control flow) is behavioral. Complementary, not contradictory — use both.
- **swyx vs. safety-first venues:** Latent Space deliberately de-emphasizes regulation and x-risk discourse, focusing on builders. Useful as a pragmatic lens; pair with safety-oriented sources for balance.
- **swyx's IMPACT vs. OpenAI's TRIM (Model + Instructions + Tools + Runtime):** swyx critiques TRIM for omitting memory, planning, and authority — his expanded frame is a better checklist for production agents.
- **Weng vs. framework maximalists:** Her posts describe agents from first principles, not via LangChain/LlamaIndex abstractions. That's the right level for designing — then pick tools.

## Pointers to source material
- latent.space (newsletter + podcast)
- lilianweng.github.io (blog — infrequent but canonical)
- youtube.com/@LatentSpacePod (full episodes)
- smol.ai (swyx's newsletter ecosystem — Smol AI News daily)
- Latent Space Discord — weekly LLM paper club
