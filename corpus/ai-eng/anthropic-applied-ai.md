---
name: Anthropic (Applied AI + docs)
role: ai-eng
type: organization
researched: 2026-04-16
---

# Anthropic (Applied AI + docs)

## Why they matter to the AI Eng
Anthropic is the direct source for the models this agent runs on (Claude Opus 4.7) and for the protocol (MCP) that defines how tools are exposed. Every design decision — prompt structure, extended-thinking budgets, tool schemas, agent loops, MCP server shape — has a canonical Anthropic answer. The "Building effective agents" post is the single most important piece of writing for anyone shipping Claude-based agents, because it names the difference between a *workflow* (LLMs orchestrated through predefined code paths) and an *agent* (LLM dynamically directs its own process), and tells you when each is appropriate. For the AI Eng owning Langfuse prompts, consolidation/generation pipelines, and MCP tools, Anthropic's engineering guidance is the spine.

## Signature works & primary sources
- "Building effective agents" — https://www.anthropic.com/engineering/building-effective-agents — Names the six patterns (prompt chaining, routing, parallelization, orchestrator-workers, evaluator-optimizer, autonomous agents) and argues for simple workflows over agents whenever possible.
- Prompt engineering guide — https://docs.claude.com/en/docs/build-with-claude/prompt-engineering — The canonical XML-tagged prompt structure, chain-of-thought, prefill, few-shot.
- Tool use docs — https://docs.claude.com/en/docs/agents-and-tools/tool-use — `tools=[{name, description, input_schema}]` shape, parallel tool calls, `tool_choice`.
- Extended thinking — https://docs.claude.com/en/docs/build-with-claude/extended-thinking — Reasoning budgets, interleaved-thinking tool use.
- Model Context Protocol spec — https://modelcontextprotocol.io — The open protocol for tools/resources/prompts, servers exposing capabilities to any MCP client.
- Claude Code best practices — https://code.claude.com/docs/en/best-practices — CLAUDE.md, thinking tools, subagents.

## Core principles (recurring patterns)
- **Start with the simplest thing that works.** A single well-crafted prompt beats a chain; a chain beats an agent. Don't reach for autonomy until predictable code paths fail.
- **Workflow vs. agent is a deliberate choice.** Workflows = predictable tasks, bounded cost, easy to eval. Agents = open-ended problems where you can't predict the step count.
- **ACI (agent-computer interface) is product design.** Treat tool definitions like API docs written for a new engineer: natural formats, clear names, example usage, no exotic escaping.
- **Give the model tokens to think.** Both chain-of-thought in the prompt and extended-thinking for reasoning budgets. Budget thinking explicitly when cost matters.
- **XML tags over markdown for structure.** `<instructions>`, `<context>`, `<examples>`, `<input>` — Claude was trained to attend to these and they survive long contexts better than headers.
- **Every tool call is observable.** Trace prompt, response, model, tokens, cost, thinking blocks, and tool I/O. This is non-negotiable for Langfuse instrumentation.

## Concrete templates, checklists, or artifacts the agent can reuse

**Canonical Anthropic prompt structure:**
```
<instructions>
You are {role}. Your task is to {goal}.
</instructions>

<context>
{relevant background, stable across calls — cache this}
</context>

<examples>
<example>
<input>...</input>
<output>...</output>
</example>
</examples>

<input>
{the actual user query, changes every call}
</input>

Think step by step inside <thinking> tags before answering.
```

**MCP tool definition pattern (server-side):**
```python
@server.tool()
async def search_memory(query: str, top_k: int = 5) -> list[Memory]:
    """Search the user's memory corpus by semantic similarity.

    Args:
        query: Natural-language query. Be specific.
        top_k: Max results. Default 5, max 20.
    """
```

**Agent-loop skeleton (autonomous agent pattern):**
```
while not done:
    response = claude.messages.create(
        model="claude-opus-4-7",
        tools=tools,
        messages=history,
        thinking={"type": "enabled", "budget_tokens": 8000},
    )
    langfuse.trace(...)  # every turn
    if response.stop_reason == "end_turn": break
    for block in response.content:
        if block.type == "tool_use":
            result = execute(block)
            history.append(tool_result(block.id, result))
```

**When to reach for each pattern (decision checklist):**
- One shot works? Use prompt chaining with a validator step.
- Task splits by category? Router.
- Independent subtasks? Parallelization (sectioning or voting).
- Unknown step count, LLM should decide? Orchestrator-workers or autonomous agent — and invest heavily in evals before shipping.

## Where they disagree with others
- **Anthropic vs. LangChain/LangGraph:** Anthropic explicitly argues against framework lock-in — "start with direct API calls" — while LangGraph sells a graph abstraction as the primitive. For the AI Eng, prefer thin wrappers over the Anthropic SDK; reach for frameworks only when durable-execution or checkpointing becomes the bottleneck.
- **Agents vs. workflows (their own framing):** Anthropic publicly pushes back on the "everything should be an agent" hype — most production systems are workflows plus one or two agentic escape hatches.
- **Extended thinking vs. bolt-on CoT:** Anthropic treats thinking as a first-class API feature with reasoning budgets; others simulate via prompt tricks. Use the native feature.

## Pointers to source material
- docs.claude.com/en/docs (official API docs, migrated from docs.anthropic.com)
- anthropic.com/engineering (applied AI posts — "Building effective agents," "Writing tools for agents," Claude Code internals)
- modelcontextprotocol.io + github.com/modelcontextprotocol (spec + reference servers)
- anthropic.com/news (model cards, Claude 4.x release notes)
