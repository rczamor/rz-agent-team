---
name: Jason Liu
role: ai-eng
type: individual
researched: 2026-04-16
---

# Jason Liu

## Why they matter to the AI Eng
Jason is the person to read on two problems the AI Eng faces every day: (1) getting *structured outputs* out of an LLM reliably enough to be downstream of code, and (2) making RAG/search work at the level required by a real product instead of a demo. Instructor, his Python library, is the de facto answer to "how do I turn a Pydantic schema into a typed LLM call with retries" — which is exactly what consolidation/generation pipelines need when they hand off to validators and writers. His *Systematically Improving RAG* course and blog series are the clearest articulation of the eval → segment → fix loop for retrieval, directly applicable to search tuning for the memory corpus. He also writes sharp, counterintuitive pieces ("Grep beat embeddings," "I stopped using RAG for coding agents") that keep you honest about when retrieval actually helps.

## Signature works & primary sources
- Instructor library — https://github.com/jxnl/instructor — Pydantic + LLM = typed structured outputs with automatic retries.
- "Systematically Improving Your RAG" — https://jxnl.co/writing/2024/05/22/systematically-improving-your-rag/ — The segment-measure-improve loop.
- "There Are Only 6 RAG Evals" — https://jxnl.co/writing/2025/05/19/there-are-only-6-rag-evals/ — Collapses RAG eval into a tractable set.
- "Low-Hanging Fruit for RAG Search" — https://jxnl.co/writing/2024/05/11/low-hanging-fruit-for-rag-search/ — Query rewriting, metadata filters, reranking.
- "Why Grep Beat Embeddings" — https://jxnl.co/writing/2025/09/11/why-grep-beat-embeddings-in-our-swe-bench-agent-lessons-from-augment/ — Lexical search still wins for code.
- Systematically Improving RAG course — https://maven.com/applied-llms/rag-playbook

## Core principles (recurring patterns)
- **If you can't validate it, you can't trust it.** Every LLM output that feeds code should be a Pydantic schema with retries on validation failure.
- **RAG is a measurement problem first.** Before tuning chunk size or switching embedding models, build an eval set that segments queries by intent. Tuning without segmentation is noise.
- **Simple tools win.** Grep, BM25, metadata filters, and cheap rerankers beat exotic vector tricks more often than anyone admits.
- **Queries have shapes — retrieval must too.** Question-answering, fact lookup, and broad summarization all want different indexes. One retriever to rule them all is a smell.
- **Context over distribution.** Multi-agent architectures usually mask a context-management problem. Fix the context first.
- **Synthetic data is fine for schemas, not for judges.** Generate diverse test queries with an LLM; label ground-truth with humans.

## Concrete templates, checklists, or artifacts the agent can reuse

**Instructor schema example (consolidation pipeline output):**
```python
from pydantic import BaseModel, Field
from typing import Literal
import instructor

class MemoryConsolidation(BaseModel):
    action: Literal["merge", "supersede", "keep_both", "drop"]
    target_ids: list[str] = Field(..., min_length=1)
    consolidated_text: str
    rationale: str = Field(..., max_length=200)
    confidence: float = Field(..., ge=0, le=1)

client = instructor.from_anthropic(anthropic.Anthropic())
result = client.messages.create(
    model="claude-opus-4-7",
    response_model=MemoryConsolidation,
    max_retries=2,
    messages=[{"role": "user", "content": prompt}],
)
```

**The 6 RAG evals (Jason's collapse):**
1. Retrieval recall (did the right chunk make top-k?)
2. Retrieval precision (was the top-k clean?)
3. Answer correctness (end-to-end)
4. Answer faithfulness (grounded in retrieved context?)
5. Answer completeness (did it use all relevant chunks?)
6. Latency / cost per query (operational)
Build one scorer per eval; track as independent time series.

**Query-segmentation template for search tuning:**
```
For each failed query, tag:
- intent: {fact_lookup | broad_summary | comparison | how_to | ambiguous}
- failure_mode: {no_relevant_chunk | wrong_chunk_top | correct_chunk_bad_answer}
- fix_class: {rewrite_query | add_metadata | rerank | chunk_differently}
```

**"Before you embed" checklist:**
- [ ] Can grep or metadata filter solve 80% of queries?
- [ ] Do you have ≥50 labeled query → expected-chunk pairs?
- [ ] Is chunk size tuned to your answer length, not a default 512?
- [ ] Does each chunk carry enough metadata to filter by source/date/user?
- [ ] Is there a cheap reranker on top-20 → top-5?

## Where they disagree with others
- **Jason vs. vector-everything orthodoxy:** Semantic similarity is often the *worst* retrieval method for the actual query distribution. Lexical + metadata + reranker is the production default.
- **Jason vs. multi-agent frameworks (CrewAI, AutoGen):** He argues most multi-agent setups are context-engineering failures dressed up as architecture — one agent with better context management usually wins.
- **Jason vs. "just prompt it":** If your output feeds code, unvalidated prose is a bug. He pushes structured outputs hard where Simon Willison might accept looser JSON-mode.

## Pointers to source material
- jxnl.co (blog — dense, code-heavy)
- github.com/jxnl/instructor (library)
- maven.com/applied-llms/rag-playbook (course)
- twitter.com/jxnlco (short takes, often counterintuitive)
- youtube.com/@jxnlco (talks and course clips)
