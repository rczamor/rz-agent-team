---
name: Michael Nygard
role: rz-architect
type: individual
researched: 2026-04-18
---

# Michael Nygard

## Why they matter to the Technical Architect routine
Nygard gave the industry two things this routine relies on. First, *Release It!* — the production-architecture playbook covering the failure patterns that look fine in dev and burn down in production (cascading failures, blocked threads, integration point timeouts) and the stability patterns that prevent them (timeouts, circuit breakers, bulkheads, steady state, fail fast). Second, the ADR format itself: his 2011 blog post "Documenting Architecture Decisions" introduced the 4-section structure (Context, Decision, Status, Consequences) that became the industry-standard ADR template. This routine's `adr-author` skill template is a direct descendant.

## Signature works & primary sources
- *Release It!: Design and Deploy Production-Ready Software* (1st ed 2007, 2nd ed 2018) — pragmatic-bookshelf.com — the canonical production-architecture book; required reading for architects shipping to real users.
- "Documenting Architecture Decisions" (Nov 2011 blog post) — http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions — the ADR origin essay.
- *Wide Awake Developers* blog — http://michaelnygard.com/blog/ — long-running technical essays.
- "Architecture Without Architects" + "Failures of Generality" essays.
- Cognitect (his employer) tech talks on YouTube.

## Core principles (recurring patterns)
- **Production looks nothing like development.** Every load you don't simulate becomes a failure mode in production. Architecture must assume cascading failures, not happy paths.
- **Stability patterns are non-negotiable.** Every integration point gets a timeout. Every dependency gets a circuit breaker. Every queue gets a bulkhead. These are defaults, not optimizations.
- **The 5 stability anti-patterns:** integration points without timeouts, chain reactions, cascading failures, users (yes — *users* are an anti-pattern when you don't shape their input), blocked threads. Watch for these in every design review.
- **Architecture decisions are time-bound.** An ADR captures the decision *as of the date it was written* — context shifts, and the decision should be revisited when context changes meaningfully. ADRs aren't tombstones; they're snapshots.
- **The decision is the artifact.** The value of an ADR is in the *Decision* section's clarity and the *Consequences* section's honesty. Skipping consequences (especially the negative ones) produces ADRs that age badly.
- **Status transitions matter.** Proposed → Accepted → Superseded by ADR-N. Never delete an ADR; supersede it. The history is the lineage of why the system looks the way it does.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Original Nygard ADR template** (the routine's template is an extension of this):
  - Title: short noun phrase
  - Status: Proposed | Accepted | Superseded by ADR-N
  - Context: forces in tension that the decision must resolve
  - Decision: the change being made, in active voice
  - Consequences: positive, negative, and neutral outcomes; what becomes easier and harder
- **Stability checklist for integration designs** (apply to every external dependency in an integration design):
  - [ ] Timeout configured (NOT default infinite)
  - [ ] Circuit breaker around the call
  - [ ] Bulkhead (resource pool isolation)
  - [ ] Steady state (expected error rate, not just success rate)
  - [ ] Fail fast (don't queue indefinitely)
  - [ ] Test harness that simulates the failure mode
- **Pre-mortem prompt for architecture reviews:** "It's six months from now and this design has failed in production. What's the most likely failure mode? What's the second most likely?" Force two answers.
- **The "ought to fail" question:** for any integration design, ask "what should this system do when downstream component X is wrong but returns 200 OK?" If the answer is "we trust 200 OK," the design has a failure mode.
- **ADR review cadence:** quarterly review of "Accepted" ADRs to flag ones whose context has shifted enough to revisit. Don't supersede on a whim; do supersede when the original context no longer holds.

## Where they disagree with others
- Nygard vs. Fowler on documentation weight: Nygard is more skeptical of long-form architecture documents; ADRs are the primary durable artifact, with everything else being living code or runbooks. Fowler is more comfortable with extended architecture documents.
- Nygard vs. cloud-native distributed-systems camp: Nygard is more willing to argue for monoliths-with-discipline. The complexity tax of distributed systems is real and most teams underestimate it.
- Nygard vs. "tests are documentation" camp: Nygard insists architecture decisions need their own document — tests show *what* the system does but not *why* it was designed that way. ADRs answer the *why*.

## Pointers to source material
- Personal site: http://michaelnygard.com/
- Book: *Release It!*, Pragmatic Bookshelf, 2nd ed 2018
- Original ADR essay: http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions
- ADR-tools (community): https://github.com/npryce/adr-tools (CLI for managing ADRs in markdown, descended from Nygard's format)
- Talks: search "Michael Nygard" on YouTube — many GOTO Conference and Strange Loop talks on architecture, organizational structure, distributed systems
