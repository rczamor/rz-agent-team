---
name: Gregor Hohpe
role: rz-architect
type: individual
researched: 2026-04-18
---

# Gregor Hohpe

## Why they matter to the Technical Architect routine
Hohpe wrote the foundational vocabulary for two things this routine does constantly: integration design and the strategic-architect role itself. *Enterprise Integration Patterns* is the dictionary every integration design reaches for — the named patterns (Message Channel, Content-Based Router, Aggregator, Saga, Idempotent Receiver) become a shorthand that compresses a 10-paragraph design into a single labeled sequence. *The Software Architect Elevator* defines the strategic architect as the person who rides between the C-suite (where decisions are made in business terms) and the engine room (where systems are built) — translating both directions. That's exactly what this routine does: it reads Riché's strategic intent in a Linear ticket and produces an artifact that engineers can implement.

## Signature works & primary sources
- *Enterprise Integration Patterns* (Hohpe & Woolf, 2003) — https://www.enterpriseintegrationpatterns.com/ — 65 named patterns for messaging-based integration, with iconography that's now standard.
- *The Software Architect Elevator* (O'Reilly, 2020) — https://architectelevator.com/book/ — the strategic-architect playbook; pairs technical chapters with org-design chapters.
- *Cloud Strategy: A Decision-Based Approach to Successful Cloud Migration* (2020) — decision frameworks for cloud architecture choices.
- *Platform Strategy* (2024) — building internal developer platforms.
- architectelevator.com — ongoing essays on architect-as-translator, cloud, integration.

## Core principles (recurring patterns)
- **Architects ride the elevator.** The job is translation: business → engineering → business. An architect who only goes one direction has stopped being an architect.
- **Patterns compress decisions.** Naming a pattern (e.g., "use a Saga here") shortens a design discussion from hours to minutes — assumes the audience knows the pattern. The routine's integration designs cite patterns by name to leverage this.
- **Selling options, not solutions.** Architecture decisions create options (the ability to change later); good architecture maximizes optionality without paying premiums for unused options. Tradeoff analysis is option pricing.
- **The cost of complexity is non-linear.** A second messaging system isn't 2x the operational cost of the first; it's 5–10x because of the cognitive overhead of maintaining two mental models.
- **Eventual consistency is not a flaw, it's a choice.** Most integration designs trade strong consistency for availability and latency. Make the trade explicit; don't sneak it in.
- **Documentation is a design tool, not a deliverable.** Writing the integration design clarifies the design. If the writeup feels hard, the design is wrong.

## Concrete templates, checklists, or artifacts the agent can reuse
- **EIP icon vocabulary for sequence diagrams:** when describing a message flow, label each hop with its EIP pattern (Message Channel, Filter, Router, Translator, Aggregator). Reduces ambiguity.
- **Saga pattern checklist** for any cross-service business transaction:
  1. Identify all participating services
  2. Define forward operations (what each does on success)
  3. Define compensating operations (what each does to undo)
  4. Specify orchestration vs. choreography
  5. Define idempotency keys for retries
  6. Specify failure modes (timeouts, partial failures, compensating-action failures)
- **Architect Elevator floors:** when writing an ADR, name the floor each consequence applies to (penthouse / business strategy, mid-floors / org structure, ground floor / system design, basement / infrastructure). Forces the routine to reason at the right level.
- **"Sketch then formalize" rule:** every integration design starts as a hand-drawn sequence (or pseudo-sequence in markdown), THEN gets formalized into the data contract and pattern names. Skipping the sketch produces over-specified designs.
- **Decision option-pricing:** when evaluating two architecture options, ask "what future decision does this make easier or harder?" Prefer options that preserve future optionality unless the cost of keeping options open is high.

## Where they disagree with others
- Hohpe vs. microservices maximalists (early Sam Newman): Hohpe is more cautious — argues that messaging complexity is often underestimated, and a well-structured monolith with internal modules can outperform a poorly-bounded set of services for years.
- Hohpe vs. Werner Vogels on consistency: Hohpe is more willing to insist on strong consistency where it matters; Vogels's "eventually consistent" framing leans toward AP defaults. Hohpe argues defaults should be context-driven, not philosophical.
- Hohpe vs. Eric Evans (DDD-purist takes): Hohpe is friendlier to integration patterns that DDD purists would call anti-corruption-layer-overuse; he sees integration as inevitable and worth doing well.

## Pointers to source material
- Primary site: https://architectelevator.com/
- Newsletter: Architect Elevator (Substack)
- Book site: https://www.enterpriseintegrationpatterns.com/ (full pattern catalog free online)
- LinkedIn: https://www.linkedin.com/in/ghohpe/
- Talks: search "Gregor Hohpe" on YouTube — many GOTO Conference and AWS re:Invent talks
