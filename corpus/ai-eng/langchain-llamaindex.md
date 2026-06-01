---
name: LangChain + LlamaIndex
role: ai-eng
type: organization
researched: 2026-04-16
---

# LangChain + LlamaIndex

## Why they matter to the AI Eng
Even if the team builds directly on the Anthropic SDK (which Anthropic itself recommends for most cases), LangChain and LlamaIndex docs and blogs are the most extensive public corpus on RAG patterns, retrieval techniques, and agent architectures. For the AI Eng tuning search on a memory corpus, their documentation covers every chunking, reranking, hybrid-search, and metadata-filter variant that's been tried in production — with working code. LangGraph's graph abstraction is genuinely useful when the consolidation/generation pipeline needs durable execution, checkpointing, or human-in-the-loop steps; that's a real capability the Anthropic SDK alone doesn't give you. LlamaIndex's node/metadata/query-engine primitives are also worth stealing-the-concepts-from even when not using the library, because they force clean separation between ingestion, retrieval, and synthesis — exactly the separation the memory pipeline needs.

## Signature works & primary sources
- LangChain overview — https://docs.langchain.com/oss/python/langchain/overview — Standard model interface, prebuilt agent architecture.
- LangGraph docs — https://langchain-ai.github.io/langgraph/ — Durable execution, streaming, human-in-the-loop, persistence for agents.
- LangChain blog — https://blog.langchain.dev — Pattern posts, especially on "cognitive architectures" (Harrison Chase).
- LlamaIndex framework docs — https://developers.llamaindex.ai/python/framework/ — Documents, nodes, indexes, retrievers, query engines, workflows, agents.
- LlamaIndex blog — https://www.llamaindex.ai/blog — Advanced RAG patterns, scoring, multi-doc agents.
- "Cognitive architectures" (Harrison Chase) — https://blog.langchain.dev/what-is-a-cognitive-architecture/ — The router/state-machine/agent spectrum.

## Core principles (recurring patterns)
- **Separate ingestion from retrieval from synthesis.** LlamaIndex's node/retriever/query-engine split is the right mental model even if you don't use the library.
- **Metadata is half the retrieval system.** Every chunk carries source, timestamp, author, type, permissions — filter first, embed second.
- **Hybrid > semantic-only.** Semantic + BM25 + metadata filters + reranker is the default production stack. Pure vector search is almost always under-specified.
- **Rerankers are high-ROI.** Cross-encoder rerank on top-20 → top-5 is cheap relative to generation and usually moves the needle.
- **Agent as state machine (LangGraph POV).** Model the agent as nodes (steps) + edges (transitions) + shared state, and you get checkpointing, replay, and human-in-the-loop for free.
- **Durable execution matters when it matters.** For one-shot queries, skip it. For long-running consolidation jobs that must survive a restart → use graph/workflow tooling.

## Concrete templates, checklists, or artifacts the agent can reuse

**RAG chunking + metadata schema (LlamaIndex-style, adapt for memory corpus):**
```python
class MemoryNode:
    id: str
    text: str  # chunk content, target 200-500 tokens for memory prose
    embedding: list[float]  # text-embedding-3-large or voyage-3
    metadata: {
        "source_trace_id": str,
        "user_id": str,
        "captured_at": datetime,
        "memory_type": "event" | "preference" | "fact" | "relationship",
        "confidence": float,
        "superseded_by": str | None,
    }
```

**Hybrid-search query pattern:**
```python
# 1. Rewrite query (LLM, cheap model)
rewritten = rewrite_for_retrieval(user_query)

# 2. Parallel retrieve
semantic = vector_store.query(rewritten, top_k=20, filter=metadata_filter)
lexical = bm25_index.query(rewritten, top_k=20, filter=metadata_filter)

# 3. Reciprocal rank fusion
fused = rrf(semantic, lexical, k=60)

# 4. Rerank top-20 -> top-5
reranked = cross_encoder.rerank(rewritten, fused[:20])[:5]

# 5. Pass to generator with citations
```

**LangGraph state-machine skeleton for consolidation pipeline:**
```python
from langgraph.graph import StateGraph

class ConsolidationState(TypedDict):
    raw_traces: list[dict]
    plan: str | None
    validated_plan: str | None
    consolidated: list[dict] | None
    reflection: dict | None

g = StateGraph(ConsolidationState)
g.add_node("plan", planner_node)
g.add_node("validate", validator_node)
g.add_node("execute", executor_node)
g.add_node("reflect", reflector_node)
g.add_edge("plan", "validate")
g.add_conditional_edges("validate", lambda s: "execute" if s["validated_plan"] else "plan")
g.add_edge("execute", "reflect")
g.add_conditional_edges("reflect", lambda s: END if s["reflection"]["ok"] else "plan")
# Checkpointer enables resume, human-in-the-loop, replay for debugging
```

**"Before you pick a framework" decision checklist:**
- [ ] Is this a one-shot prompt? -> Anthropic SDK directly.
- [ ] Is this a fixed pipeline? -> SDK + functions + Langfuse traces.
- [ ] Do you need durable execution / checkpointing / HITL? -> LangGraph.
- [ ] Are you prototyping RAG variants? -> LlamaIndex for primitives, graduate to your own code.
- [ ] Do you need to swap model providers regularly? -> LangChain model interface is handy.

## Where they disagree with others
- **LangChain vs. Anthropic:** Anthropic explicitly recommends starting with direct API calls and reaching for frameworks only when needed. LangChain's position is that the framework *is* the right starting point for teams that will eventually need observability and multi-model support. Both have merit — decide per project.
- **LangChain vs. LlamaIndex:** Historically LangChain = agents/chains, LlamaIndex = retrieval/RAG. They've converged; both now do both. Pick the one whose primitive vocabulary fits your head.
- **LangGraph vs. Anthropic's "workflow patterns":** Same ideas, different abstraction levels. Anthropic describes patterns in plain code; LangGraph gives you a state-machine runtime. Use the runtime when you actually need persistence.
- **Framework scoring vs. Langfuse:** LangChain/LlamaIndex have their own scoring tooling (LangSmith, LlamaIndex scoring). Good for framework-integrated debugging, but Langfuse is model/framework-agnostic — prefer Langfuse as the system of record.

## Pointers to source material
- docs.langchain.com (LangChain + LangGraph docs)
- blog.langchain.dev (patterns, "cognitive architectures")
- developers.llamaindex.ai (framework docs, migrated from docs.llamaindex.ai)
- www.llamaindex.ai/blog (advanced RAG + agent patterns)
- github.com/langchain-ai, github.com/run-llama (source, examples)
