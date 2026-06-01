---
role: conductor
researched: 2026-04-16
---

# Conductor Corpus

Role-specific knowledge corpus for the Conductor agent — owner of orchestration, dispatch, review, and the Linear ↔ Paperclip bridge. Built to support staff/principal-level judgment: system design, architectural tradeoffs, code review discipline, multi-step orchestration, and tiebreaker decisions.

## Index

- **[will-larson.md](./will-larson.md)** — Engineering strategy, staff archetypes, migrations as the only scalable fix to tech debt. Primary reference for strategy doc structure and work-on-what-matters dispatch filter.
- **[tanya-reilly.md](./tanya-reilly.md)** — Glue work named and credited; the Staff Engineer's Path. Primary reference for making coordination visible and avoiding the "Conductor absorbs all glue" failure mode.
- **[camille-fournier.md](./camille-fournier.md)** — *The Manager's Path*, code review culture, delegation discipline. Primary reference for not hoarding work and for skip-level calibration of specialist-agent output.
- **[gergely-orosz.md](./gergely-orosz.md)** — Pragmatic Engineer newsletter; how real teams at top companies actually ship. Primary benchmarking source for PR size, incident reviews, and lightweight project management.
- **[martin-fowler-thoughtworks.md](./martin-fowler-thoughtworks.md)** — Refactoring catalog, enterprise patterns, Technology Radar. Primary reference for ADRs, strangler-fig migrations, two-hats refactoring discipline, and adopt/trial/hold tiebreakers.
- **[leaddev.md](./leaddev.md)** — Engineering-leadership community and research. Primary source for "what's normal?" benchmarks and current industry practice.
- **[staffeng.md](./staffeng.md)** — Staff engineer archetypes, stories, and scope guides. Primary dispatcher reference for matching incoming issues to the right specialist pattern (Tech Lead / Architect / Solver / Right Hand).

## How to use this corpus

1. **Dispatching work** — Start with staffeng.md archetype classifier, then apply will-larson.md's work-on-what-matters filter.
2. **Reviewing a PR** — Run the camille-fournier.md review checklist + martin-fowler-thoughtworks.md two-hats check.
3. **Arbitrating a tech choice** — Consult martin-fowler-thoughtworks.md (Radar ring + Strangler Fig); cross-check with will-larson.md's "boring tech" default.
4. **Writing strategy or an ADR** — Use will-larson.md's four-part strategy skeleton and martin-fowler-thoughtworks.md's ADR template.
5. **Benchmarking cadence/quality disputes** — Pull numbers from leaddev.md reports + gergely-orosz.md patterns.
6. **Self-audit** — Run tanya-reilly.md's weekly glue audit and camille-fournier.md's hoarding self-check.
