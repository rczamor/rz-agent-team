---
name: Will Larson
role: conductor
type: individual
researched: 2026-04-16
---

# Will Larson

## Why they matter to the Conductor
Larson is the closest thing to a definitive modern playbook for the work the Conductor does every day: orchestrating multi-step technical work, writing engineering strategy, and deciding when to invest in migrations vs. incremental fixes. His staff-engineer archetypes give the Conductor a vocabulary for deciding which specialist agent to route a piece of work to (Tech Lead pattern for team-scoped execution, Solver for a deep knotty bug, Architect for cross-cutting design). His "good strategy is boring" thesis is directly load-bearing when the Conductor has to arbitrate between two engineer agents proposing competing approaches — Larson's frame forces a diagnosis before a recommendation, which is exactly the tiebreaker posture the Conductor needs.

## Signature works & primary sources
- *An Elegant Puzzle* (2019) — https://lethain.com/elegant-puzzle/ — Systems approach to engineering management; the source of the "four states of a team" model and the migration playbook.
- *Staff Engineer* (2021) — https://staffeng.com/book — Defines the four archetypes (Tech Lead, Architect, Solver, Right Hand) and how staff+ engineers actually create impact without authority.
- *The Engineering Executive's Primer* (2023) — Executive-level framing for setting strategy and allocating engineering capacity.
- *Crafting Engineering Strategy* (2026) — https://lethain.com/ — His current book on strategy design fundamentals.
- "Migrations: the sole scalable fix to tech debt" — https://lethain.com/migrations/ — The canonical argument that migrations, not rewrites, are how real orgs move.
- "Work on what matters" — https://lethain.com/work-on-what-matters/ — Prioritization heuristic the Conductor should run against every proposed task.

## Core principles (recurring patterns)
1. **Diagnosis before recommendation.** Good strategy is a diagnosis of the current situation plus a policy, not a vision statement. If the Conductor can't articulate what's actually broken, it shouldn't propose a fix.
2. **Migrations are the only scalable fix to tech debt.** Rewrites fail; migrations succeed because they preserve working state while moving incrementally. Bias toward migration-shaped plans over big-bang rewrites.
3. **Work on what matters.** Impact compounds when aligned with organizational priorities. Always check: is this the highest-leverage thing this agent could be doing right now?
4. **Archetypes determine scope.** A Tech Lead problem is not a Solver problem. Misrouting is a common failure mode; match the work to the right shape of specialist.
5. **Systems, not heroics.** Durable throughput comes from process quality, not individual brilliance. When an agent keeps firefighting, the Conductor's job is to find the system gap.
6. **Boring strategy beats clever strategy.** Clarity and executability dominate novelty.

## Concrete templates, checklists, or artifacts the agent can reuse

**Engineering strategy doc skeleton (Larson-style):**
1. Diagnosis — What's the specific situation? What are the constraints? (no fluff)
2. Guiding policy — The approach we'll take given the diagnosis
3. Coherent actions — Concrete steps, owners, sequencing
4. Tradeoffs accepted — What we're explicitly choosing not to do

**"Four states of a team" triage:** When routing work, classify the receiving agent's state first — Falling behind, Treading water, Repaying debt, or Innovating. Only innovators can take on scope expansion; the rest need load reduction or debt paydown, not new features.

**Work-on-what-matters filter (run before dispatch):**
- Does this advance a stated org priority?
- Is there a cheaper intervention that gets 80%?
- Who is uniquely positioned to do this? (if "anyone" — defer)
- What's the smallest useful version we could ship this week?

**Migration playbook (for any large refactor/refactor-like task):**
1. Land the new thing alongside the old
2. Migrate one real workload
3. Build the migration tooling
4. Migrate the long tail
5. Delete the old

## Where they disagree with others
- **Larson vs. Fowler/Tech Radar:** Larson leans "pick boring tech" and treat novelty as a cost. The Tech Radar actively encourages Trial and Assess rings. Conductor's tiebreaker: default Larson for production-critical paths, lean Radar for exploratory work where learning is the point.
- **Larson vs. Reilly:** Larson's archetype framing can understate how much glue work staff engineers actually do. Use Reilly's lens to credit coordination and mentoring even when it doesn't fit a clean archetype.
- **Larson vs. Fournier:** Larson is more skeptical of management intervention ("sponsorship over process"); Fournier invests more in explicit structures. Calibrate based on whether the team is failing on clarity (Fournier) or on leverage (Larson).

## Pointers to source material
- Primary site: https://lethain.com
- Substack: Irrational Exuberance (via lethain.com)
- Staff Engineer book + site: https://staffeng.com
- Key posts: "Write five, then synthesize"; "Migrations: the sole scalable fix to tech debt"; "Staying on the path to high performing teams"; "Measuring an engineering organization"; "How to evolve an engineering organization"
