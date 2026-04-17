---
name: Martin Fowler / ThoughtWorks
role: conductor
type: organization
researched: 2026-04-16
---

# Martin Fowler / ThoughtWorks

## Why they matter to the Conductor
Fowler and ThoughtWorks are the Conductor's canonical reference for three concrete activities it performs constantly: (1) judging refactoring proposals from specialist agents, (2) structuring architectural decisions, and (3) adjudicating "should we adopt this technology" questions. The Technology Radar is the single most useful external signal for adopt/avoid tiebreakers — when two agents disagree on whether to use a library or pattern, the Radar's ring plus Fowler's enterprise-patterns vocabulary gives the Conductor a defensible, widely-accepted basis for the call. Fowler's refactoring catalog (the "two hats" rule: you're either adding behavior OR refactoring, never both in the same commit) is directly enforceable in code review.

## Signature works & primary sources
- *Refactoring: Improving the Design of Existing Code* (2nd ed., 2018) — https://martinfowler.com/books/refactoring.html — The canonical catalog of named refactorings + the "two hats" discipline.
- *Patterns of Enterprise Application Architecture* (2002) — https://martinfowler.com/books/eaa.html — Vocabulary for Repository, Unit of Work, Service Layer, Domain Model, etc.
- *Continuous Delivery* (Humble & Farley, Fowler signature series) — The deployment-pipeline canon.
- Technology Radar — https://www.thoughtworks.com/radar — Twice-yearly Adopt / Trial / Assess / Hold rings across Techniques, Tools, Platforms, Languages & Frameworks.
- bliki — https://martinfowler.com/bliki — Short entries on concepts: StranglerFigApplication, CircuitBreaker, FeatureToggle, MonolithFirst, TestPyramid.
- "Microservices" article (Fowler & Lewis, 2014) — https://martinfowler.com/articles/microservices.html

## Core principles (recurring patterns)
1. **Two hats for code change.** Either add behavior or refactor — never both in the same commit. Enforceable in PR review.
2. **Evolutionary architecture beats big up-front design.** Systems that defer decisions and keep options open outlast systems that over-specified early.
3. **Strangler Fig for legacy replacement.** Don't rewrite in place; wrap, migrate path by path, delete the old. Directly compatible with Larson's migration playbook.
4. **Test pyramid: lots of unit, fewer integration, very few end-to-end.** Inverted pyramids ("ice cream cone") are a smell the Conductor should flag immediately.
5. **Monolith first.** Most "start with microservices" projects fail; extract services only once you understand the seams.
6. **Radar ring discipline:** "Adopt" = use by default; "Trial" = pilot in production with eyes open; "Assess" = read and experiment; "Hold" = stop starting new work here.

## Concrete templates, checklists, or artifacts the agent can reuse

**Refactoring-vs-feature guard (two-hats check on every PR):**
- Does this PR change observable behavior AND restructure internals? If yes → split.
- Is the refactor claim testable? (i.e., all tests still pass unchanged)
- If extracting a method/class, does the new name make the code self-documenting?

**ADR (Architecture Decision Record) template:**
```
# ADR-NNN: [Short title]
Status: [Proposed | Accepted | Deprecated | Superseded by ADR-X]
Date: YYYY-MM-DD

## Context
What is the issue we're addressing? What forces are at play?

## Decision
The change we're making.

## Consequences
What becomes easier. What becomes harder. What risks we accept.

## Alternatives considered
Option A — why rejected
Option B — why rejected
```

**Technology-adoption decision filter (Radar-flavored):**
1. What ring would this land in on the Radar (or actually: where is it)?
2. Who on the team has shipped this in production before?
3. What's our rollback path if this fails at 6-month mark?
4. Is this a reversible or irreversible choice?
5. Does this replace or complement our existing stack?

**Strangler Fig migration checklist:**
1. Identify a seam (one route, one workflow, one data entity)
2. Build the new implementation alongside the old
3. Route a small fraction of real traffic to the new path
4. Compare outputs (shadow mode if risk is high)
5. Cut over fully; leave old path running N weeks as fallback
6. Delete the old

**Microservice extraction smell-check (before any split):**
- Do we have a clear bounded context?
- Do we have deployment automation that can handle N services?
- Do we have distributed-system observability?
- If any answer is no → stay monolithic, revisit in 6 months.

## Where they disagree with others
- **Fowler/Radar vs. Larson:** Radar actively surfaces Trial-ring novelty; Larson's "pick boring tech" treats novelty as a tax. Conductor tiebreaker: Radar for learning-oriented work, Larson for revenue-critical paths.
- **ThoughtWorks vs. Orosz:** ThoughtWorks' methodology branding (Agile, CD, BDD) can feel heavier than what top product companies actually run (per Orosz). Use Fowler for the vocabulary and patterns, Orosz to check the ceremony load.
- **Fowler vs. "rewrite" advocates:** Fowler is firmly on the side of incremental migration (Strangler Fig, branch-by-abstraction). Anytime an agent proposes a full rewrite, the Conductor should reach for this frame first.

## Pointers to source material
- Primary site: https://martinfowler.com
- bliki (short concept entries): https://martinfowler.com/bliki
- Technology Radar: https://www.thoughtworks.com/radar
- Refactoring catalog: https://refactoring.com
- Books: *Refactoring* (2nd ed), *PoEAA*, *UML Distilled*, *Continuous Delivery* (signature series)
