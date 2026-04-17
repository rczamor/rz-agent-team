---
name: The Good Docs Project and GitLab Handbook
role: tech-writer
type: organization
researched: 2026-04-16
---

# The Good Docs Project and GitLab Handbook

## Why they matter to the Tech Writer
These two sources give the agent the two artifacts it most needs in daily work: **reusable templates** (Good Docs) and **a living example of docs-as-source-of-truth at scale** (GitLab Handbook). The Good Docs Project ships open-source, MIT-licensed Markdown templates for every common doc type — concept, task, reference, tutorial, API overview, release notes, README — which the agent can drop directly into a new Notion page, README, or IDENTITY.md without reinventing structure. GitLab's public handbook is the largest real-world proof that company-wide documentation can be treated as the canonical source of truth for operations, not just code — directly applicable to how the agent should shape IDENTITY.md files and the team's Notion workspace.

## Signature works & primary sources
- The Good Docs Project — https://www.thegooddocsproject.dev/ — home page, mission, and community links.
- TGDP Templates repository (GitLab) — https://gitlab.com/tgdp/templates — the canonical template source.
- TGDP Templates (GitHub mirror) — https://github.com/thegooddocsproject/templates — same content, searchable.
- GitLab Handbook — https://handbook.gitlab.com/ — the full public handbook (2,000+ pages).
- "Handbook-first approach" — https://about.gitlab.com/company/culture/all-remote/handbook-first-documentation/ — GitLab's own explanation of why the handbook is the single source of truth.
- GitLab Documentation Style Guide — https://docs.gitlab.com/development/documentation/styleguide/ — how GitLab writes its product docs; a second reference after Google/Microsoft.

## Core principles (recurring patterns)
- **Every doc type has a template.** Good Docs ships skeletons for README, quickstart, tutorial, how-to, concept, reference, API overview, release notes, troubleshooting, and more. Writers should not start from a blank page.
- **Three-type taxonomy at minimum**: Concept (what is it?), Task (how do I do it?), Reference (specifications). Good Docs uses these as the top-level organization, with finer subtypes under each.
- **Handbook-first**: if it is not written down in the canonical source, it does not exist. Verbal decisions and DM discussions are not decisions until they are documented.
- **Docs are public by default** inside GitLab — the company handbook is visible to the world; internal Notion specs should default to team-visible, private only by exception.
- **Merge requests (PRs) are how docs change.** No separate doc-review track — docs are edited like code, reviewed like code, shipped like code.
- **Short toes**: anyone can edit anyone's doc. Ownership is stewardship, not gatekeeping (GitLab's "short toes" value).
- **Templates encode an implicit checklist.** Filling a template to completion is the definition of done.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Good Docs template names** (the agent should know these by name): `concept.md`, `task.md`, `reference.md`, `tutorial.md`, `how-to.md`, `api-overview.md`, `quickstart.md`, `release-notes.md`, `troubleshooting.md`, `readme.md`. Pull from https://gitlab.com/tgdp/templates.
- **README skeleton** (Good Docs README template distilled): project name + one-line description → what problem it solves → prerequisites → install → minimal usage example → links to deeper docs → how to contribute → license → maintainers.
- **IDENTITY.md skeleton** (handbook-inspired): purpose of this unit → scope (in/out) → owners and on-call → decision-making process → canonical artifacts (links) → review cadence → last reviewed date.
- **Handbook page pattern** (GitLab): one-line summary at top → table of contents → sections in declining specificity → "last updated" → explicit owner. Apply to any Notion spec longer than one screen.
- **Doc-merge-request checklist**: (1) uses the correct Good Docs template? (2) owner named? (3) last-reviewed date set? (4) linked from parent index? (5) search-findable (keywords in H1 and first paragraph)?

## Where they disagree with others
- GitLab (docs-in-repo, plain Markdown, public by default) vs. Stripe (polished custom portal, staff-gated): different trade-offs between scale/polish and transparency/contribution friction. The agent should default to GitLab's model for internal docs and Stripe's for external developer-facing docs.
- Good Docs Project (many named templates) vs. Diátaxis (four quadrants): Good Docs is more granular and more practical; Diátaxis is more architectural. Use Good Docs templates inside a Diátaxis folder structure — they compose.
- Handbook-first (GitLab) vs. chat-first (most startups): GitLab's discipline is hard to adopt mid-stream; the agent can nudge toward handbook-first by consistently asking "where is this written down?" and converting Slack/Notion decisions into permanent pages.

## Pointers to source material
- https://www.thegooddocsproject.dev/
- https://www.thegooddocsproject.dev/template — browsable template index
- https://gitlab.com/tgdp/templates — canonical source
- https://handbook.gitlab.com/ — the handbook itself
- https://about.gitlab.com/company/culture/all-remote/handbook-first-documentation/
- https://docs.gitlab.com/development/documentation/styleguide/ — GitLab's product-docs style guide
