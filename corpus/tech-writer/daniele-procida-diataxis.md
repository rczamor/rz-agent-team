---
name: Daniele Procida (Diátaxis)
role: tech-writer
type: individual
researched: 2026-04-16
---

# Daniele Procida (Diátaxis)

## Why they matter to the Tech Writer
Diátaxis is the dominant modern framework for structuring technical documentation, and it is the single most useful mental model the Tech Writer can apply to Notion specs, READMEs, docstrings, API docs, and IDENTITY.md files. Procida's insight — that documentation fails because writers mix four fundamentally different user needs on the same page — maps cleanly onto the daily failure mode of Notion workspaces: a spec that is half tutorial, half reference, half rant, and serves nobody. Adopting Diátaxis as the skeleton for every new page gives the agent a principled answer to "what kind of doc is this?" before a word is written, and a principled answer to "why is this page confusing?" when triaging existing docs.

## Signature works & primary sources
- Diátaxis framework site — https://diataxis.fr/ — the canonical reference, written by Procida himself; the "five minutes" start page is the fastest onboarding.
- "What nobody tells you about documentation" — Procida's 2017 PyCon AU talk — the origin story and the clearest verbal explanation of the four-quadrant insight.
- Django documentation — Procida led the restructure that made Django docs the textbook example of Diátaxis in production.
- Canonical / Ubuntu docs — Procida's day job; Canonical's docs are being systematically migrated to Diátaxis and are a live case study.

## Core principles (recurring patterns)
- **Four irreducible documentation types**, each serving one user need:
  1. **Tutorials** — learning-oriented, for the beginner; goal is confidence, not completeness.
  2. **How-to guides** — task-oriented, for the competent user; a recipe to solve a specific problem.
  3. **Reference** — information-oriented; describes the machinery, austere and accurate.
  4. **Explanation** — understanding-oriented; discursive, answers "why".
- Two axes organize them: **practical vs. theoretical** (what the content does) and **studying vs. working** (what the user is doing).
- Each page serves ONE quadrant. Mixing is the primary cause of unusable docs.
- Reference must be strictly descriptive — no teaching, no opinions, no narrative.
- Tutorials must work on first read with zero prior knowledge. A tutorial that requires reference is broken.
- Documentation structure is not cosmetic — it is a feature of the product.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Diátaxis skeleton for a new doc folder**: `/tutorials/`, `/how-to/`, `/reference/`, `/explanation/` — four top-level dirs, no others. Applies equally to a Notion workspace (four top-level pages) or a repo `/docs/` tree.
- **Page-type sniff test** before writing: ask "what is the reader doing right now — studying or working?" and "do they want practical steps or theoretical understanding?" The answer picks the quadrant.
- **Tutorial template**: goal sentence, prerequisites, numbered steps that each produce visible success, final "what you built" paragraph, link to relevant how-to guides.
- **How-to template**: problem statement, prerequisites, numbered steps, verification, common failure modes.
- **Reference template**: signature/endpoint, parameters table, return/response shape, errors, one minimal example, no narrative.
- **Explanation template**: question being answered, context, discussion (may include tradeoffs, history, alternatives), links to relevant reference pages.

## Where they disagree with others
- Diátaxis vs. README-first pragmatism (WTD): Procida insists on four separate pages; pragmatists want one README that gets people started. Reconcile by treating the README as a tutorial + pointers, with the other three quadrants linked.
- Diátaxis vs. Good Docs Project templates: Good Docs has more granular types (quickstart, release notes, API overview). Diátaxis folds these into the four quadrants; Good Docs gives ready-made forms. Use Good Docs templates inside a Diátaxis folder structure.
- Diátaxis vs. Stripe/Twilio polished portals: Stripe mixes tutorial + reference on one page with interactive widgets. Procida would call this a mixed page; Stripe would call it a better UX. For small teams without interactive docs infra, Diátaxis separation is the safer default.

## Pointers to source material
- https://diataxis.fr/ — framework home
- https://diataxis.fr/start-here/ — 5-minute primer
- https://www.youtube.com/watch?v=t4vKPhjcMZg — "What nobody tells you about documentation" (PyCon AU 2017)
- https://idratherbewriting.com/blog/what-is-diataxis-documentation-framework — Tom Johnson's critical walkthrough
- Django docs (https://docs.djangoproject.com/) — live Diátaxis implementation
