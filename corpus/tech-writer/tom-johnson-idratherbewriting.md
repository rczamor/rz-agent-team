---
name: Tom Johnson (I'd Rather Be Writing)
role: tech-writer
type: individual
researched: 2026-04-16
---

# Tom Johnson (I'd Rather Be Writing)

## Why they matter to the Tech Writer
Tom Johnson runs the longest-running and most substantive technical-writing blog (I'd Rather Be Writing, since 2006) and maintains the most complete free course on API documentation on the public internet. For a Tech Writer touching API docs, docstrings, READMEs, and Notion specs, his site is the closest thing to a practitioner textbook — deeply opinionated, constantly updated, and covering the unsexy middle of the job (OpenAPI authoring, content reuse strategy, docs-as-code tooling, careers). His recent work on AI-augmented technical writing ("Cyborg Technical Writers — Augmented, Not Replaced, by AI") is directly relevant to how an AI agent should collaborate with human writers rather than substitute for them.

## Signature works & primary sources
- I'd Rather Be Writing blog — https://idratherbewriting.com/ — 18+ years of posts; the archive is searchable and organized by topic.
- Documenting APIs: A guide for technical writers and engineers — https://idratherbewriting.com/learnapidoc/ — free, book-length course; the default curriculum most API tech writers learn from.
- About page — https://idratherbewriting.com/aboutme/ — Tom's bio and positioning (Seattle, API tech writer at Google historically).
- AI + tech comm series — https://idratherbewriting.com/ai/ — ongoing posts on AI workflows in technical writing.
- Diátaxis critique — https://idratherbewriting.com/blog/what-is-diataxis-documentation-framework — the pragmatist counterpoint to Procida.

## Core principles (recurring patterns)
- **API docs have a repeatable shape**: overview → authentication → endpoints → parameters → request/response → status codes → code samples → SDKs → changelog. Skipping any section is a known failure mode.
- **OpenAPI is the source of truth for reference**; narrative pages live alongside but are generated from or cross-linked to the spec.
- **Docs-as-code is non-negotiable for developer docs** — version control, PRs, CI, static site generators (Jekyll, Hugo, Docusaurus, MkDocs, Sphinx).
- **The tech writer's job is shifting from author to curator/reviewer** in the AI era — prompt design, fact-checking generated drafts, maintaining canonical sources, and owning voice.
- **Content reuse (DITA, Hugo shortcodes, includes) pays off only past a threshold** of doc volume; small projects should not adopt it.
- **Developer personas are narrower than PMs think**: document for the developer writing their first request, not the architect planning their whole integration.

## Concrete templates, checklists, or artifacts the agent can reuse
- **API reference section template** (from the learnapidoc course): resource description → endpoint + HTTP method → path parameters → query parameters → request body schema → example request (cURL) → response schema → example response → error codes with meanings → sample code in 3+ languages.
- **"5 Cs" API docs quality rubric**: Clear, Concise, Complete, Correct, Consistent. Score each section before shipping.
- **Docs-as-code minimum stack for a new repo**: Markdown files in `/docs`, a static site generator, a CI job that builds on PR and fails on link breakage, a CODEOWNERS file naming doc reviewers.
- **AI-assist prompt patterns for the agent**: "Draft the reference entry for this endpoint from this OpenAPI spec, then flag any parameter whose description is missing or generic." "Rewrite this paragraph in second-person active voice; preserve all technical facts."
- **Career-stage reading list for human writers joining the team**: learnapidoc start page → Diátaxis 5-minute primer → Google Style Guide highlights → Write the Docs docs principles.

## Where they disagree with others
- Johnson vs. Procida (Diátaxis): Johnson is sympathetic but pragmatic — he has written that strict four-quadrant separation often doesn't survive contact with real projects; some pages legitimately mix modes. He'd rather ship a useful mixed page than an unshipped pure one.
- Johnson vs. "docs are for everyone" idealists: he argues the tech writer role is a real specialty requiring API literacy, not just writing skill — engineers writing docs produce systematically worse results without editing.
- Johnson vs. AI-replacement narratives: he rejects the view that LLMs obsolete tech writers; his "cyborg" model reframes the job around curation, prompting, and voice ownership.

## Pointers to source material
- https://idratherbewriting.com/ — main blog
- https://idratherbewriting.com/learnapidoc/ — API documentation course (free, book-length)
- https://idratherbewriting.com/ai/ — AI-in-tech-comm series
- https://idratherbewriting.com/blog/ — recent posts
- Podcast appearance: https://tenminutetechcomm.com/index.php/2022/04/12/tom-johnson-on-api-documentation/
