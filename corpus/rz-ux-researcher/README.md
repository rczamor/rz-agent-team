---
role: rz-ux-researcher
researched: 2026-04-18
---

# rz-ux-researcher (User Researcher) corpus index

Role-specific knowledge for the User Researcher strategic routine. The routine produces interview synthesis, personas, journey maps, and usability audits. Stateless between runs; writes durable artifacts to the [UX Research Library Notion hub](https://www.notion.so/346ac0ea4f658139be15f9b3a0002f71). Plugin lives at `plugins/rz-ux-researcher/`.

## Files

- [teresa-torres.md](./teresa-torres.md) *(symlink to researcher)* — Continuous discovery and the opportunity-solution tree; how interview findings become structured product inputs.
- [erika-hall.md](./erika-hall.md) *(symlink to researcher)* — *Just Enough Research* methods, four research types, bias-aware interview design, and the "never hold a focus group" stance.
- [nngroup-rohrer.md](./nngroup-rohrer.md) *(symlink to researcher)* — NN/g's method-selection framework + the 10 usability heuristics — the citable foundation for usability audits.
- [steve-portigal.md](./steve-portigal.md) — Interview craft: how to elicit stories rather than opinions, embrace silence, follow surprises, escape confirmation bias. Quality of input data for the synthesis skill.
- [kim-goodwin.md](./kim-goodwin.md) — Goal-directed design and rigorous persona construction. Three goal types (experience / end / life), behavioral variables (not demographics), and the discipline of personas grounded in observed behavior.
- [indi-young.md](./indi-young.md) — Mental models + listening deeply. Mapping how users *think* about a problem space (not just what they do); the cognitive-structure complement to behavior-focused methods.
- [researchops-community.md](./researchops-community.md) *(symlink to researcher)* — The Eight Pillars of ReOps + repository patterns for how this routine's artifacts are stored, tagged, and retrieved.

## How the routine uses these

At session start, the routine's `session` skill reads this README to orient. For specific output skills:

- **interview-synthesis** → Portigal (interview-quality input) + Torres (opportunity framing for synthesis output) + Young (listening for cognitive patterns) + Hall (bias-aware methodology)
- **persona** → Goodwin (canonical persona structure with goals + behavioral variables) + Young (cognitive-style sampling) + Hall (research scope) + ResearchOps (persona maintenance discipline)
- **journey-map** → Torres (opportunity mapping at flow level) + Young (mental-model diagram as alternative when cognitive structure dominates) + Goodwin (scenarios + decision points)
- **usability-audit** → NN/g (10 heuristics + cognitive walkthrough) + Hall (small-N audit methodology) + Portigal (interviewing affected users when an audit needs validation)

## Inheritance from the (retired) generic Researcher corpus

Four of the seven entries (Torres, Hall, NN/g, ResearchOps) are symlinks to the original Researcher corpus that predates the April 17 architectural split. The methodology applies regardless of which routine reads it — the role-frontmatter difference doesn't affect the substance. The three new entries (Portigal, Goodwin, Young) are UX-research-specific voices the original Researcher corpus didn't cover.

The retired generic Researcher's other entries (Tomer Sharon for product validation, Pew/Gartner/CB Insights for secondary data, ThoughtWorks Radar for technical evaluation) moved to the Analyst and Architect corpora respectively, where they fit better.

## PII handling

All four output skills require anonymizing direct quotes (no names, emails, phone numbers, company names). For small-N findings (where one person's signal could identify them), the routine aggregates or labels the finding `low confidence` and flags for replication. ResearchOps practices on participant data handling are non-negotiable.
