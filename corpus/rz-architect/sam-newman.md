---
name: Sam Newman
role: rz-architect
type: individual
researched: 2026-04-18
---

# Sam Newman

## Why they matter to the Technical Architect routine
Newman is the pragmatic voice on service decomposition and migration strategy. *Building Microservices* (1st ed 2015, 2nd ed 2021) is the most-cited modern reference on when, why, and how to split services — but his more recent work is increasingly about *how to NOT split prematurely*. *Monolith to Microservices* (2019) is structured around the migration patterns (strangler fig, branch-by-abstraction, parallel run, decorating collaborator, change data capture) that an architect needs when the answer is "not all at once." This routine uses Newman as the counterweight to "let's split this into services" enthusiasm — his work makes the case for monolith-first, then split when there's evidence rather than ideology.

## Signature works & primary sources
- *Building Microservices* (2nd ed, O'Reilly, 2021) — the practitioner reference. Significantly revised from the 2015 edition; reflects a decade of seeing teams over-split.
- *Monolith to Microservices* (O'Reilly, 2019) — migration patterns, the strangler fig, parallel-run technique, change data capture for splits.
- samnewman.io blog — long-running essays on service design, deployment patterns, organizational coupling.
- "When to Use Microservices (and When Not To)" talks — search YouTube for QCon, GOTO, and NDC talks.
- *Building Microservices* sample chapters: https://samnewman.io/books/

## Core principles (recurring patterns)
- **Microservices are not a goal; they're a means.** The question is never "should we adopt microservices?" — it's "what problem are we solving by splitting this monolith?" If the answer is fuzzy, don't split.
- **Independent deployability is the defining characteristic.** If two "services" can't be deployed independently, they're not actually separate services — they're a distributed monolith with extra latency.
- **Data ownership is the hard part.** Splitting code is easy; splitting data without breaking transactional invariants is where most splits fail. Plan data first.
- **Strangle the monolith, don't rewrite it.** Use the strangler fig pattern: route new requests to the new service while the old monolith continues to serve everything else, gradually migrating functionality. Big-bang rewrites usually fail.
- **Evolutionary architecture over revolutionary.** Make small, reversible changes. Each split should be small enough to revert if it doesn't work.
- **Change data capture (CDC) over dual writes** when migrating data across a split. Dual writes are a distributed-transaction problem in disguise; CDC sidesteps it.
- **Coupling is fine; tight coupling at the wrong boundary is the problem.** Services share too little (causing chatty APIs) or too much (sharing schemas across teams) more often than they share at appropriate boundaries.
- **Conway's Law is operational, not theoretical.** Service boundaries follow team boundaries because communication paths constrain technical paths. Plan team structure before service structure if possible.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Microservices readiness checklist** (apply before recommending a split):
  - [ ] Clear bounded context (per DDD) for the proposed service
  - [ ] Owned data store (no shared DB with the monolith)
  - [ ] Identified deployment / on-call ownership
  - [ ] Defined API contract with versioning strategy
  - [ ] Operational maturity: monitoring, logging, alerting in place
  - [ ] Team bandwidth for ongoing maintenance
  - If 3+ items are "no," monolith-first is the right call
- **The five strangler fig steps** for incremental migration:
  1. Identify a slice of functionality to extract
  2. Build the new service to handle that slice
  3. Route requests for that slice to the new service via a router (HTTP proxy, message router, etc.)
  4. Verify the new service handles the slice in isolation (parallel run if risky)
  5. Decommission the slice in the monolith
- **Decomposition pattern selection** (from *Monolith to Microservices*):
  - **Strangler fig** — new functionality routed to new service; old continues
  - **UI composition** — split at the UI layer, leave backend alone for now
  - **Branch by abstraction** — introduce abstraction layer, swap implementation
  - **Parallel run** — both old and new run, compare outputs, validate before cutover
  - **Decorating collaborator** — wrap monolith calls to add new behavior without modifying monolith
  - **Change data capture** — read change stream from monolith DB, build new service's DB from it
- **The "smallest viable split" rule:** for any proposed decomposition, ask "what's the smallest piece we can extract first to validate the approach?" Extract that, learn, then decide whether to continue.
- **Pre-split ADR template extension:**
  - Why split now (not later)?
  - What's the smallest first slice?
  - What's the rollback plan if the split fails?
  - What's the deployment / on-call model for the new service?

## Where they disagree with others
- Newman vs. early-2010s microservices enthusiasm: Newman has spent the last 5 years walking back the over-enthusiasm. *Building Microservices* 2nd ed is significantly more cautious than the 1st ed.
- Newman vs. monolith-forever camp (DHH on monoliths): Newman accepts monoliths as legitimate but argues for *modular monoliths* with clear internal boundaries that make future splits possible. DHH-style "the monolith is the answer" is too absolute for Newman.
- Newman vs. service-mesh-first advocates: Newman is skeptical of complex infrastructure (Istio, etc.) for small teams. The operational tax should match the team size and actual scale needs.
- Newman vs. orchestration-only camp: Newman is comfortable with both orchestration (a central service coordinating) and choreography (services react to events) — depends on the use case. Pure-choreography purists argue against orchestration as too tightly-coupled.

## Pointers to source material
- Personal site: https://samnewman.io/
- Books: *Building Microservices* (2nd ed) and *Monolith to Microservices* — O'Reilly catalog
- Newsletter / mailing list: signup at samnewman.io
- LinkedIn: https://www.linkedin.com/in/samnewman1979/
- Talks: many on YouTube — recommended starters: "Microservices Done Right" (NDC), "When to Use Microservices (and When Not To)" (GOTO)
- Speaking schedule: samnewman.io/talks
