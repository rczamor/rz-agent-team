---
name: Eric Evans & Vaughn Vernon (Domain-Driven Design)
role: rz-architect
type: individuals
researched: 2026-04-18
---

# Eric Evans & Vaughn Vernon (Domain-Driven Design)

## Why they matter to the Technical Architect routine
DDD is the strategic-design vocabulary the Architect routine uses to scope integrations and argue against premature coupling. Two concepts dominate: **bounded contexts** (the boundaries inside which a domain model is consistent — an `Order` in fulfillment is not the same `Order` as in customer-support, and pretending otherwise creates corruption) and **context maps** (the explicit relationships between bounded contexts: shared kernel, customer/supplier, conformist, anticorruption layer, separate ways). For an architect deciding "should service A and service B share a database table?" or "should we build an integration or a shared library?", DDD gives the deciding vocabulary. Vernon's *Implementing Domain-Driven Design* is the more accessible practitioner reference; Evans's original 2003 book is the foundational text.

## Signature works & primary sources
- *Domain-Driven Design: Tackling Complexity in the Heart of Software* (Eric Evans, Addison-Wesley, 2003) — the foundational text. Strategic design (Part IV) is the section the Architect routine cites most often.
- *Implementing Domain-Driven Design* (Vaughn Vernon, Addison-Wesley, 2013) — the practitioner manual; bridges Evans's abstractions to working code.
- *Domain-Driven Design Distilled* (Vaughn Vernon, 2016) — short, fast intro for architects who need the vocabulary without committing to 500 pages.
- domainlanguage.com (Evans's site) — articles, talks, training.
- vaughnvernon.com — DDD talks, IDDD samples, more recent reactive-architecture material.
- DDD Crew (community): github.com/ddd-crew — context mapping templates, bounded context canvas.

## Core principles (recurring patterns)
- **Ubiquitous language is the deliverable.** Architects don't ship code; they ship terms that the team uses consistently. If "Order" means three different things across teams, the system has a strategic-design bug regardless of implementation quality.
- **Bounded contexts are the unit of model consistency.** Inside a context, terms have one meaning and the model is unified. Across contexts, translation is required and explicit. Most legacy-system pain is from contexts that pretend to share a model but don't.
- **Context maps name the integration.** When two contexts must integrate, name the relationship: shared kernel (rare), customer-supplier (upstream/downstream), conformist (downstream accepts upstream model), anticorruption layer (downstream isolates upstream model), open host service (upstream publishes a stable contract for many consumers), separate ways (refuse to integrate).
- **The big ball of mud is the default.** Without strategic design, every system collapses into a tangled mess. The architect's job is to push back on the entropy continuously, not to draw clean diagrams once.
- **Aggregates set transactional boundaries.** Inside an aggregate, invariants are enforced atomically. Across aggregates, eventual consistency is the rule. Mixing these levels is the most common DDD-violation in microservices designs.
- **Strategic before tactical.** The bounded context decisions matter more than the entity / value object / aggregate decisions. Get the boundaries right and tactical patterns follow; get them wrong and no amount of clean code helps.
- **Subdomain types tell you where to invest.** Core domain (the differentiator — invest engineering depth here), supporting domain (necessary but not differentiating — buy or simplify), generic domain (commodity — buy off the shelf). Mis-classifying these wastes engineering budget.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Bounded context canvas** (from DDD Crew, https://github.com/ddd-crew/bounded-context-canvas) — one-page template for documenting a bounded context. Use this whenever the routine writes an integration design that touches multiple contexts.
- **Context map template** for any integration design:
  - Identify the contexts involved
  - For each pairwise relationship, name the integration pattern (customer-supplier / conformist / ACL / open host / shared kernel / separate ways)
  - Direction of dependency (upstream / downstream)
  - Translation point: where the model boundary is enforced
- **Subdomain classification check** before any major build-vs-buy ADR:
  - Is this core domain? → invest, build custom, hire deeply
  - Is this supporting? → simplify aggressively, buy if available
  - Is this generic? → buy off the shelf, never custom-build
- **Anticorruption layer pattern** when integrating with a legacy or external system whose model would corrupt yours:
  - Define the downstream model first (your context's terms)
  - Build a translation layer that converts upstream-model → your-model
  - Never let upstream-model leak into downstream code
  - Test the translation layer in isolation
- **The "ubiquitous language" review** for every major ADR: list the domain terms used, verify each has a single agreed definition, flag any that mean different things in different contexts. If a term is overloaded, the ADR may be solving the wrong problem.
- **Strategic-design questions for any service-split ADR:**
  - What bounded context is each side of the split?
  - What's the integration pattern (from the context-map list)?
  - Where does data ownership live, and what triggers cross-context transactions?
  - What aggregates straddle the split (warning sign)?

## Where they disagree with others
- Evans/Vernon vs. anti-DDD-overhead camp (Sam Newman occasionally, Hohpe sometimes): Evans/Vernon advocate spending real time on strategic design before coding; critics argue this is over-investment for small teams or simple domains. Routine's stance: scale DDD effort to domain complexity — for a prototype, identify the bounded contexts informally; for SIA-scale or website-scale, do the full canvas.
- Evans/Vernon vs. CRUD/data-model-first design: DDD privileges behavior and language over data. The data model emerges from the model, not vice versa. Database-first designs often violate DDD principles invisibly until the system grows.
- Evans/Vernon vs. microservices-as-DDD-implementation: DDD predates microservices and is independent of them. A monolith with proper bounded contexts is fine; microservices with overlapping models are not. Don't conflate the two.

## Pointers to source material
- Domain Language Inc. (Evans): https://www.domainlanguage.com/
- Vaughn Vernon: https://vaughnvernon.com/
- DDD Crew (community templates): https://github.com/ddd-crew
- Bounded Context Canvas: https://github.com/ddd-crew/bounded-context-canvas
- DDD Europe conference: https://dddeurope.com/ — annual community gathering, talks on YouTube
- DDD reference (free Evans summary): https://www.domainlanguage.com/ddd/reference/
- *Patterns, Principles, and Practices of Domain-Driven Design* (Scott Millett & Nick Tune, 2015) — accessible alternative to Evans's original
