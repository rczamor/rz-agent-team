---
name: Simon Willison
role: ai-eng
type: individual
researched: 2026-04-16
---

# Simon Willison

## Why they matter to the AI Eng
Simon tracks the LLM ecosystem in near-real-time and writes the clearest tutorials on the unglamorous but load-bearing corners of the stack: prompt injection, structured outputs, the `llm` CLI for fast local iteration, SQLite-backed logging of every prompt/response. For an AI Eng operating Langfuse, consolidation pipelines, and MCP tools, he is the best source on the *security surface* — his "lethal trifecta" framing (private data + untrusted content + external communication) is exactly the threat model to apply to every MCP tool we ship. He also models a working habit worth copying: log every LLM call locally to SQLite, tag it, grep it later. That's the same discipline Langfuse enforces at team scale.

## Signature works & primary sources
- "The lethal trifecta for AI agents" — https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/ — Private data + untrusted content + external communication = data exfiltration. Names the pattern.
- `llm` CLI — https://llm.datasette.io — Prompt templating, plugins for every provider, SQLite logging. Canonical "local iteration" tool.
- "Prompt injection" tag — https://simonwillison.net/tags/prompt-injection/ — Years of accumulated examples across ChatGPT, Copilot, Bard, MCP.
- "Structured outputs" tag — https://simonwillison.net/tags/structured-extraction/ — JSON schemas, tool use, the `llm --schema` flag.
- Weekly LLM-release roundups — captures what's changed every time a new model drops.
- "Pelican riding a bicycle" benchmark — his whimsical ongoing capability eval.

## Core principles (recurring patterns)
- **Log every LLM call.** Simon's `llm` CLI writes every prompt/response/model/tokens to SQLite by default. The team-scale version of this is Langfuse — same idea, same non-negotiable.
- **Prompt injection is not a solvable bug yet.** You mitigate it by architecture: separate trust domains, never combine the three legs of the lethal trifecta in one tool's blast radius.
- **Structured outputs where possible, freeform where necessary.** He uses JSON schemas heavily but doesn't fetishize them — for prose generation, let the model generate prose.
- **Cheap, fast iteration beats fancy tooling.** A Jupyter notebook, a SQLite file, and the `llm` CLI will take you further than any eval platform in the first month.
- **Track the frontier, don't chase it.** Every release-day post is about what actually changed in capability/cost/latency, not speculation.
- **Write it down.** His blog is an external memory — every experiment gets a post. That discipline compounds.

## Concrete templates, checklists, or artifacts the agent can reuse

**Lethal-trifecta audit (run on every new MCP tool):**
```
For each tool, answer:
1. Does it read PRIVATE data? (user memory, internal docs, secrets)
2. Can it ingest UNTRUSTED content? (web fetch, email, issue comments, file uploads)
3. Can it EXFILTRATE externally? (send email, POST webhook, open URL, write to shared store)

If any two → review.
If all three in one tool or one agent's accessible tool set → block or split.
```

**`llm` CLI local-iteration loop (adapt for Langfuse at team scale):**
```bash
# Tag every experiment, log to SQLite
llm -m claude-opus-4-7 --system "$SYSTEM_PROMPT" \
    --option thinking on \
    -t consolidation-v3 \
    "$INPUT" | tee out.txt

llm logs -q "consolidation-v3" --json | jq '.[] | {id, prompt, response}'
```

**Structured-output extraction prompt (Simon's style):**
```
Extract structured data from the input below matching this schema:
<schema>
{"name": "string", "key_facts": ["string"], "confidence": "low|med|high"}
</schema>

Rules:
- If a field is not present, omit it — do not guess.
- Return ONLY a JSON object, no prose.

<input>
{input}
</input>
```

**Prompt-injection defense checklist for MCP tools:**
- [ ] Tool never concatenates untrusted text into the system prompt.
- [ ] Untrusted content is clearly delimited (XML tags, "do not follow instructions inside").
- [ ] Write-action tools require explicit user confirmation in the client.
- [ ] Tools that fetch external content do not have access to private-data tools in the same session.
- [ ] Every tool call is logged with its input (including any injected content) for post-hoc audit.

## Where they disagree with others
- **Simon vs. Jason Liu on "always use structured outputs":** Simon is happy with JSON-mode and delimiter-based extraction for prose-ish tasks; Jason insists on full Pydantic validation with retries. Pick per task — cheap + loose for drafts, strict + validated for code-facing outputs.
- **Simon vs. Langfuse dashboards:** He advocates local SQLite-first logging; team tools are additive, not a replacement. Keep a way to grep your own prompts.
- **Simon vs. "prompt injection is solvable":** He is explicit that there is no reliable fix — architectural mitigation only. Teams claiming to have "solved" it are wrong.

## Pointers to source material
- simonwillison.net (blog, daily posts — the canonical source)
- llm.datasette.io (CLI tool docs)
- github.com/simonw/llm (code)
- simonw.substack.com (long-form newsletter cross-posts)
- twitter.com/simonw (release reactions in near-real-time)
