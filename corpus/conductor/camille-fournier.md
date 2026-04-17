---
name: Camille Fournier
role: conductor
type: individual
researched: 2026-04-16
---

# Camille Fournier

## Why they matter to the Conductor
Fournier's work is the canonical source for code-review culture, manager↔IC handoffs, and the discipline of not hoarding work — all directly relevant to how the Conductor reviews specialist-agent output and decides when to intervene vs. let a junior agent learn the hard way. The Conductor runs a small organization of agents; Fournier's management frame prevents two common failure modes: (1) the Conductor doing all the interesting work itself and starving specialists of growth, and (2) the Conductor imposing rigid process where a lightweight template would do. Her "skip-level" discipline translates cleanly to the Conductor's review cadence — it should occasionally review an agent's work directly even when another agent was the immediate reviewer, to calibrate standards.

## Signature works & primary sources
- *The Manager's Path* (O'Reilly, 2017) — https://www.oreilly.com/library/view/the-managers-path/9781491973882/ — The canonical stage-by-stage guide from engineer to CTO; sets the standard for engineering-leadership transitions.
- elidedbranches.com blog — https://www.elidedbranches.com — Ongoing posts on ladders, platform teams, and management craft.
- "How New Managers Fail Individual Contributors" (2021) — Five concrete failure modes: hoarding technical work, hoarding project management, hoarding information, hoarding relationships, hoarding credit.
- "Revisiting Manager READMEs" (2025) — Argues READMEs create a "you-focused mindset"; prefers shared templates.
- "The Next Larger Context" (2023) — How senior ICs find scope by examining their work's broader organizational impact.
- "10 Years of Engineering Ladders" (2025) — Reflection + practical ladder-design guidance.

## Core principles (recurring patterns)
1. **Don't hoard.** Delegate design decisions, project management, and visibility to grow the next layer. The Conductor should push scoping and spec-writing down to specialist agents wherever possible.
2. **Templates over READMEs.** Shared lightweight rituals ("Wins and Challenges", structured 1:1 docs) scale; personality-driven handbooks don't.
3. **Skip-level visibility is a calibration tool.** Periodically inspect the actual output of agents two layers deep, not just the summary from the intermediate reviewer.
4. **Structures serve people, not the other way around.** Perfect org charts that lose talent are a bad tradeoff. Same for perfect review pipelines that block useful work.
5. **Platform/infra evolution is incremental, not revolutionary.** Containerization, observability, microservice adoption land through sustained migrations, not big-bang launches. (Echoes Larson.)
6. **The "next larger context" test.** When an agent feels stuck for scope, look one level up: what does the product need, what does the org need, what does the business need?

## Concrete templates, checklists, or artifacts the agent can reuse

**Code-review checklist (Fournier-flavored, for the Conductor reviewing a specialist agent's PR):**
- Does the change match the stated intent in the Linear issue?
- Is the test coverage commensurate with the blast radius?
- Are there hidden couplings or implicit dependencies introduced?
- Is there a simpler approach the author considered and rejected? (Ask, don't assume.)
- Is this the kind of change that should be split into smaller PRs?
- Am I giving feedback that teaches, or just correcting?

**"Wins and Challenges" weekly template (lift directly):**
- Wins this week: [3 bullets, concrete]
- Challenges / blockers: [what's stuck and why]
- What I need from you / the team: [specific asks]
- Focus for next week: [top 1-3]

**Hoarding self-check (Conductor runs this weekly):**
1. Did I do any technical work a specialist agent should have done?
2. Did I keep any info private that should have been in a shared doc?
3. Did I take credit for coordination that was actually the specialist's work?
4. Did I skip a promotion-visible task the specialist could have owned?

**Skip-level review cadence:** Once per N sessions, read a specialist agent's raw output instead of the Conductor's summary of it. Log discrepancies.

## Where they disagree with others
- **Fournier vs. Larson:** Larson trusts sponsorship and lightweight structure; Fournier invests more in explicit ladders, 1:1 rituals, and defined handoffs. Use Fournier when the failure is lack of clarity; Larson when the failure is lack of leverage.
- **Fournier vs. Reilly:** Fournier is more focused on manager craft; Reilly on IC staff+ craft. They agree that coordination is undervalued but differ on who owns fixing it (managers for Fournier, staff ICs for Reilly).

## Pointers to source material
- Primary site: https://www.elidedbranches.com
- *The Manager's Path* — O'Reilly 2017
- Twitter/X: @skamille
- LeadDev talks and keynotes: https://leaddev.com
