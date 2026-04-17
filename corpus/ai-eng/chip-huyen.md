---
name: Chip Huyen
role: ai-eng
type: individual
researched: 2026-04-16
---

# Chip Huyen

## Why they matter to the AI Eng
Chip Huyen's *AI Engineering* (2024) is the most comprehensive practitioner-oriented book on building LLM applications — and for the AI Eng role specifically, the relevant chapters are on retrieval, evaluation, agents, and inference. Her framing is distinctive: she separates *tools* (knowledge augmentation, capability extension, write actions), *planning* (generation → validation → execution → reflection), and *failure modes* (tool-selection errors, parameter errors, goal violations, reflection errors) in a way that maps cleanly onto what the AI Eng needs to debug in Langfuse traces. Her agents post and evaluation chapters provide the vocabulary for writing eval rubrics and failure taxonomies that are precise enough to act on. (Note: her pipeline/data-quality content overlaps Data Eng territory — here we tilt toward her retrieval/evals/agents/inference material.)

## Signature works & primary sources
- *AI Engineering* (O'Reilly, 2024) — https://www.oreilly.com/library/view/ai-engineering/9781098166298/ — The comprehensive reference. Chapters 5 (RAG + Agents), 6 (Finetuning), 7 (Dataset Engineering), 9 (Inference), 10 (AI Engineering Architecture) are core for AI Eng.
- "Agents" (blog post, 2025) — https://huyenchip.com/2025/01/07/agents.html — Tool taxonomy, planning architecture, failure modes.
- "Building LLM applications for production" — https://huyenchip.com/2023/04/11/llm-engineering.html — Still foundational; eval and latency sections hold up.
- "RLHF: Reinforcement Learning from Human Feedback" — https://huyenchip.com/2023/05/02/rlhf.html
- *Designing Machine Learning Systems* (O'Reilly, 2022) — The evaluation and monitoring chapters still apply.

## Core principles (recurring patterns)
- **Agent success = tools × planner.** Both halves must be strong. A great planner with bad tools flails; great tools with a weak planner misuse them.
- **Three tool categories, three different failure profiles.** Knowledge-augmentation tools fail on *recall*; capability-extension tools fail on *correctness*; write-action tools fail catastrophically and need human oversight.
- **Decouple plan generation, validation, and execution.** Don't let the planner both propose and execute in one step — you lose your ability to catch invalid plans cheaply.
- **Natural-language plans over function-call sequences.** More robust to tool API changes, easier to debug, easier to eval.
- **Evaluate on plan quality, not just task success.** Valid-plan rate, plans-per-solution, tool-call accuracy (valid tool? valid params? correct values?), cost, latency.
- **Hierarchical planning beats flat planning for long-horizon tasks.** High-level plan → subplan decomposition → tool calls.
- **Reflection needs its own scaffolding.** Models don't reliably reflect just because you tell them to — Reflexion-style separate evaluator + self-reflection modules beat inline "think harder."

## Concrete templates, checklists, or artifacts the agent can reuse

**Tool taxonomy (use when designing MCP tools):**
| Category | Purpose | Failure profile | Human gate? |
|---|---|---|---|
| Knowledge augmentation | retrievers, SQL, web, APIs | recall/precision | no |
| Capability extension | calculator, code exec, translators | correctness | no |
| Write actions | DB writes, email, payments | catastrophic | **yes** |

**Agent failure taxonomy (use as Langfuse trace tags):**
```
planning_failure:
  - invalid_tool (tool doesn't exist)
  - wrong_tool (exists but wrong for task)
  - bad_params (correct tool, wrong schema)
  - bad_values (correct schema, wrong values)
  - goal_violation (ignored constraint)
  - reflection_error (false completion claim)
tool_failure:
  - incorrect_output (tool bug, not agent)
  - translation_error (plan → command gap)
  - missing_tool (no tool for this subgoal)
efficiency:
  - step_count
  - total_cost
  - latency
```

**Plan-then-validate pattern (consolidation pipeline):**
```
1. Planner (Opus): generate natural-language plan for how to consolidate these memories
2. Validator (Haiku, cheaper): check plan — does it preserve all facts? any tool calls impossible?
3. If valid → executor runs tool calls
4. Reflector (Opus): does the output match the plan's intent?
5. Log all four steps to Langfuse with shared trace_id
```

**Eval metrics for an agent pipeline:**
- Valid plan rate (plans that pass validator on first try)
- Plans per valid solution (ideally 1.0–1.2)
- Tool call accuracy per category
- Cost per completed task (P50, P95)
- Latency per completed task
- Human-judged task success rate on a held-out set

## Where they disagree with others
- **Chip vs. Anthropic's "just use tool calls":** She insists on natural-language plans as an intermediate layer; Anthropic's examples often go prompt → tool call directly. For long-horizon tasks her layered approach pays off.
- **Chip vs. "autoregressive LLMs can't plan" camp (LeCun et al.):** She engages the debate but is pragmatic — planning *works well enough* with strong models plus validators, even if it's not "real" planning.
- **Chip vs. framework-first authors (LangChain):** Her writing is framework-agnostic and often recommends building from primitives; she treats frameworks as implementation details, not architecture.
- **Note vs. Data Eng corpus:** In the Data Eng role Chip is read for feature stores, monitoring, and data quality; here she is read for RAG, evals, agent design, and inference optimization. Don't conflate.

## Pointers to source material
- huyenchip.com (blog — dense long-form posts)
- *AI Engineering* book (2024) — the canonical reference
- github.com/chiphuyen (MLOps tools list, eval repos)
- twitter.com/chipro
- youtube — talks from Stanford CS329S, MLOps World
