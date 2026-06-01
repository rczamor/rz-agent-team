---
name: Neal Ford & Mark Richards
role: rz-architect
type: individuals
researched: 2026-04-18
---

# Neal Ford & Mark Richards

## Why they matter to the Technical Architect routine
Ford and Richards co-authored the modern textbook trilogy on software architecture: *Fundamentals of Software Architecture* (2020), *Software Architecture: The Hard Parts* (2021), and (with Rebecca Parsons + Pat Kua) *Building Evolutionary Architectures* (2017, 2nd ed 2023). Together these books introduce the vocabulary every modern architect uses: **architecture characteristics** (the "-ilities" — scalability, performance, reliability, observability, deployability, etc.), **fitness functions** (objective measures that the architecture preserves its desired characteristics over time), **architecture quanta** (the smallest deployable unit with high cohesion and shared lifecycle), and the **trade-off matrix** for the hard parts (data ownership, distributed transactions, workflow). This routine's `tech-stack-eval` and `architecture-review` skills owe their structure directly to Ford + Richards.

## Signature works & primary sources
- *Fundamentals of Software Architecture* (O'Reilly, 2020) — the textbook on architecture characteristics, decision-making, and tradeoff analysis. Required reading before designing.
- *Software Architecture: The Hard Parts* (O'Reilly, 2021) — service granularity, data decomposition, distributed transactions, workflow ownership. Each chapter is a scenario with multiple architecture options scored against trade-offs.
- *Building Evolutionary Architectures* (Ford, Parsons, Kua, O'Reilly, 1st ed 2017, 2nd ed 2023) — fitness functions, the strangler fig migration pattern, evolutionary architecture quanta.
- nealford.com — articles, talks, conference recordings.
- Mark Richards's developertoarchitect.com — free architecture training videos.

## Core principles (recurring patterns)
- **Architecture characteristics are the architect's primary tool.** Before choosing patterns, name the top 3–5 characteristics this system must optimize for (e.g., reliability, scalability, simplicity). Most decisions follow.
- **Trade-offs are the only constants.** "Architecture is the stuff you can't Google." Every decision trades one characteristic against another. Naming the trade explicitly is half the work.
- **Fitness functions make characteristics testable.** A characteristic without a fitness function is a wish. "We value performance" → "p95 latency must stay below 200ms; CI runs the load test on every PR." The fitness function is what keeps the characteristic from rotting.
- **The architecture quantum is the right unit of analysis.** Not "the whole system" or "individual services" — the quantum is the smallest unit that has cohesive characteristics and an independent lifecycle.
- **Service granularity is a spectrum, not a binary.** "Microservices vs. monolith" is the wrong question. Pick the granularity that fits the architecture characteristics you need; expect to migrate over time.
- **Hard parts are about data, not services.** Decomposing services is mechanical; decomposing the data and workflow is where designs actually fail. Plan data ownership and distributed transactions first.
- **The first law of software architecture:** "Everything in software architecture is a trade-off."
- **The second law of software architecture:** "Why is more important than how."

## Concrete templates, checklists, or artifacts the agent can reuse
- **Architecture characteristics worksheet** (use at the start of any tech-stack eval or major ADR):
  - List candidate characteristics (full list in *Fundamentals*, ch. 4): availability, scalability, elasticity, deployability, testability, modularity, evolvability, simplicity, abstraction, agility, observability, reliability, performance, security, cost, etc.
  - Pick top 3 (force-rank). These dominate every subsequent decision.
  - For each chosen characteristic, name a fitness function (concrete measure + threshold + test cadence)
- **Trade-off matrix template** for `tech-stack-eval`:
  - Rows = candidate options
  - Columns = top 3–5 architecture characteristics + cost + integration complexity
  - Cells = score 1–5 with one-line rationale
  - Weighted total at bottom
- **The "what would change my mind?" question** for every ADR's recommendation: name the criterion that, if it shifted, would flip the recommendation. If you can't name one, the recommendation is too soft.
- **Hard parts decomposition checklist** before splitting a service:
  - [ ] Where does the data live, and who owns writes?
  - [ ] What transactions cross the proposed split?
  - [ ] What workflow state machines cross the split, and where do they live?
  - [ ] What's the failure mode if the cross-split call fails mid-transaction?
  - [ ] How do we test the split end-to-end without touching production?
- **Evolutionary architecture quantum sketch:** for any new design, draw the quanta — group components by shared lifecycle, shared deploy unit, and shared characteristic priorities. Quanta that don't share characteristics shouldn't share a deployable.

## Where they disagree with others
- Ford + Richards vs. classic Fowler on enterprise patterns: Ford + Richards are more willing to declare patterns "obsolete" or context-bound (e.g., they're more skeptical of monolithic ESBs than 2003-era Fowler). They argue patterns must be re-evaluated as platforms evolve.
- Ford + Richards vs. DDD purists: they treat DDD as one of several decomposition tools, not the universal answer. Bounded contexts get pulled into the broader characteristic-driven decomposition rather than driving it.
- Ford + Richards vs. "best practices" advocates: their framing is allergic to universal best practices. Every recommendation in *Fundamentals* and *Hard Parts* is conditional — "if the system has characteristic X, then pattern Y; if Z, then W." This is a useful posture for the routine to model.

## Pointers to source material
- Neal Ford: https://nealford.com/
- Mark Richards: https://developertoarchitect.com/
- *Fundamentals of Software Architecture*: O'Reilly catalog
- *Software Architecture: The Hard Parts*: O'Reilly catalog
- *Building Evolutionary Architectures* (2nd ed): O'Reilly catalog
- Free training: developertoarchitect.com/lessons (Mark Richards's video library, ~150 short lessons organized by architecture topic)
- Talks: O'Reilly Architecture Conference recordings (now folded into O'Reilly Online Learning)
