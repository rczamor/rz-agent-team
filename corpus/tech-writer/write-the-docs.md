---
name: Write the Docs
role: tech-writer
type: community
researched: 2026-04-16
---

# Write the Docs

## Why they matter to the Tech Writer
Write the Docs (WTD) is the global center of gravity for modern technical writing practice. For a Tech Writer maintaining Notion specs, READMEs, docstrings, API docs, and IDENTITY.md files, WTD is the default source for "how do real doc teams do this?" — their Slack, conference talks, and community-authored guides supply the vocabulary (docs-as-code, documentarian, information architecture, minimum viable docs) that every other source in this corpus builds on. Their stance that "documentation is a product of the same engineering process as the code it describes" is exactly the operating assumption the Tech Writer needs when deciding where a doc lives (Notion vs. repo), who reviews it, and how it gets versioned.

## Signature works & primary sources
- Documentation Principles — https://www.writethedocs.org/guide/writing/docs-principles/ — the short list most doc teams quote verbatim (ARID, skimmable, accurate, consistent, findable).
- Docs as Code guide — https://www.writethedocs.org/guide/docs-as-code/ — plain-text sources, version control, automated builds, tested like code; the baseline operating model.
- WTD Conferences (Portland, EU, Australia, India) — https://www.writethedocs.org/conf/ — recorded talks are the single best library of modern docs case studies.
- WTD Slack (~15,000 documentarians) — https://www.writethedocs.org/slack/ — the place to check how others solved a specific doc problem this week.
- Software documentation guide — https://www.writethedocs.org/guide/ — a curated overview covering writing, tooling, and organizing doc teams.

## Core principles (recurring patterns)
- ARID (Accept (some) Repetition In Docs) — don't over-DRY docs; a little duplication is cheaper than broken cross-references.
- Docs live next to code in version control; PRs change docs and code together or neither.
- Every page must be skimmable — headings, short paragraphs, front-loaded conclusions.
- Documentarians are a role, not a function: engineers, PMs, and designers all write docs; the Tech Writer's job is to raise the quality bar, not gatekeep.
- "Start with why" — every doc opens with audience + purpose, not implementation.
- Minimum viable docs beat perfect-and-absent docs.

## Concrete templates, checklists, or artifacts the agent can reuse
- **WTD "docs PR" checklist** before merging any Notion spec or README update: (1) audience named, (2) purpose stated in one sentence, (3) skimmable (H2s + short paras), (4) code examples runnable, (5) links not broken, (6) owner assigned, (7) last-reviewed date updated.
- **Docs-as-code repo layout** for a new service: `/docs/README.md` (what/why), `/docs/how-to/`, `/docs/reference/`, `/docs/explanation/`, `/docs/IDENTITY.md` (owners, review cadence), CI job that fails on broken links and lint errors.
- **Doc kickoff template**: one-line purpose, primary audience, one secondary audience, top 3 questions this doc must answer, what it explicitly does NOT cover.

## Where they disagree with others
- WTD is pragmatic; unlike Diátaxis purists, they accept hybrid pages (a tutorial that bleeds into explanation) when the audience is small.
- WTD leans docs-in-repo (like GitLab) rather than a walled dedicated-docs-site (like Stripe's polished portal). Both ship — the choice is about ownership and review flow.
- They are softer than Google/Microsoft style guides on prescriptive word choice — WTD emphasizes community and process over the dictionary.

## Pointers to source material
- https://www.writethedocs.org/
- https://www.writethedocs.org/guide/
- https://www.writethedocs.org/videos/ (full archive of conference talks — "Docs as Code: The Missing Manual" by Margaret Eker and Jennifer Rondeau is the canonical intro)
- Slack signup: https://www.writethedocs.org/slack/
- Newsletter + job board linked from the main site.
