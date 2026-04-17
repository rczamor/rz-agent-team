---
name: Lenny Rachitsky
role: pm-lite
type: individual
researched: 2026-04-16
---

# Lenny Rachitsky

## Why they matter to the PM-lite
Lenny runs the biggest PM-practitioner newsletter on the planet (~1.2M subscribers) and has done the single most useful thing for PM-lite: he's curated a public library of the actual PRD, 1-pager, and spec templates that top product teams use — Square's, Figma's, Asana's, Intercom's, Amazon's PR/FAQ, his own 1-pager. For PM-lite, Lenny is essentially the template shelf. Instead of inventing a spec format from scratch, PM-lite should pull the right template for the situation (1-pager for a small bet, Kevin Yien's PRD for a staged project, Amazon PR/FAQ for a big new product). Lenny's repeated emphasis on *nailing the problem statement* and *writing Non-Goals* maps directly to the spec-hygiene work PM-lite owns. Lenny does not tell PM-lite what to build — he shows PM-lite how to write up what Riché has decided to build.

## Signature works & primary sources
- "My favorite product management templates" — https://www.lennysnewsletter.com/p/my-favorite-templates-issue-37 — the core curated list.
- "Examples and templates of 1-Pagers and PRDs" — https://www.lennysnewsletter.com/p/prds-1-pagers-examples — side-by-side comparisons with commentary.
- "Lenny's Product Requirements template" (Confluence marketplace) — https://www.atlassian.com/software/confluence/templates/lennys-product-requirements — his own 1-pager, Confluence-ready.
- *Lenny's Podcast* — https://www.lennysnewsletter.com/podcast — long-form interviews with top PMs.
- Lenny's Notion template marketplace — https://www.notion.com/@lenny

## Core principles (recurring patterns)
1. **Nail the problem statement first.** Lenny: "the single most important step in solving any problem. Deceptively easy to get wrong." Re-reference the problem in every design review and stakeholder update.
2. **Non-Goals are as important as Goals.** Every elite template (Kevin Yien's PRD, Shape Up pitches, Amazon PR/FAQ) has an explicit "what we are NOT doing" section. PM-lite should never ship a spec without it.
3. **Separate problem understanding from solution design.** Keep them as distinct sections of the doc so reviewers can agree on the problem before arguing about the solution.
4. **Match doc weight to project weight.** 1-pager for most tickets. Staged PRD for scaled projects. PR/FAQ only for big new product bets. Don't use a heavyweight template for a 3-day fix.
5. **Re-review the problem in every update.** Stakeholder and design reviews should always begin by restating the problem — prevents scope drift.

## Concrete templates, checklists, or artifacts the agent can reuse

**Lenny 1-Pager (PM-lite default for most tickets):**
```
TL;DR: <3 sentences max>
Problem: <who, what pain, evidence>
Why now:
Goals: <measurable, 1-3 max>
Non-Goals: <explicit list>
Proposed solution: <1 paragraph>
Open questions: <route to Riché if strategic>
Success metric(s):
Rollout plan:
```

**Kevin Yien PRD skeleton (for staged, larger projects):**
```
1. Background / context
2. Problem statement
3. Goals / Non-Goals
4. Stage 1: ship this
5. Stage 2: ship this
6. Stage 3: ship this (each stage shippable on its own)
7. Risks
8. Appendix: research, data, prior art
```
Use when: the project spans >2 sprints or >3 engineers.

**Amazon PR/FAQ (reserve for net-new product bets — probably rare for PM-lite):**
Write the press release first (5 paragraphs), then an internal FAQ, then a customer FAQ. Forces you to work backwards from the customer outcome.

**Problem-statement sharpness test (run before shipping any spec):**
- [ ] Names a specific user or segment
- [ ] States what they are trying to do
- [ ] States why it's currently hard/broken
- [ ] Cites evidence (ticket, interview, metric)
- [ ] Is written in plain English a non-PM would understand

**"Which template?" decision rule:**
- 1 engineer, <1 week → Linear issue only, no separate doc
- 1-2 engineers, 1-2 sprints → Lenny 1-pager
- 3+ engineers OR cross-team OR >2 sprints → Kevin Yien staged PRD
- Net-new product line → PR/FAQ + PRD

## Where they disagree with others
- **Lenny vs. Linear:** Lenny is template-heavy; Linear argues "write issues, not user stories" and prefers minimal prose. Reconcile: rich spec in Notion, minimal ticket in Linear that links back.
- **Lenny vs. Cagan:** Lenny is pluralistic (15 templates can all work); Cagan is prescriptive about the product model. PM-lite should default to Lenny's pragmatism.
- **Lenny vs. Doshi:** Lenny gives format; Doshi gives prioritization. They complement — use Lenny's template structure with Doshi's LNO time allocation when writing it.

## Pointers to source material
- lennysnewsletter.com — primary
- Lenny's Podcast (Spotify, Apple)
- Notion marketplace: notion.com/@lenny
- Twitter/X: @lennysan
