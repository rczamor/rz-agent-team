---
role: rz-architect
researched: 2026-04-18
---

# rz-architect (Technical Architect) corpus index

Role-specific knowledge for the Technical Architect strategic routine. The routine produces ADRs, integration designs, architecture reviews, and tech-stack evaluations. Stateless between runs; writes durable artifacts to the [ADR Log Notion hub](https://www.notion.so/346ac0ea4f6581d480e4d9633a6cafe6). Plugin lives at `plugins/rz-architect/`.

## Files

- [martin-fowler-thoughtworks.md](./martin-fowler-thoughtworks.md) *(symlink to conductor)* — ADR practice, evolutionary architecture, ThoughtWorks Radar as the paired adopt/hold signal.
- [gregor-hohpe.md](./gregor-hohpe.md) — Enterprise Integration Patterns vocabulary; the *Architect Elevator* model of riding between strategy and engine room (this routine's literal job).
- [michael-nygard.md](./michael-nygard.md) — Origin of the ADR format the routine's `adr-author` skill descends from; *Release It!* stability patterns (timeouts, circuit breakers, bulkheads) for production-grade integration designs.
- [ford-richards.md](./ford-richards.md) — Architecture characteristics (the "-ilities"), fitness functions, trade-off matrices; the structural backbone of `tech-stack-eval` and `architecture-review`.
- [evans-vernon.md](./evans-vernon.md) — Domain-Driven Design strategic vocabulary: bounded contexts, context maps, integration patterns. The deciding language for "should A and B share a model or not."
- [sam-newman.md](./sam-newman.md) — Pragmatic decomposition: when to split, when to leave monoliths alone, the strangler fig migration pattern. Counterweight to premature-microservices enthusiasm.
- [vogels-aws-well-architected.md](./vogels-aws-well-architected.md) — Distributed-systems wisdom + the 6-pillar Well-Architected Framework as a default `architecture-review` checklist.

## How the routine uses these

At session start, the routine's `session` skill reads this README to orient. For specific ticket types:

- **ADRs** → Nygard for format + Fowler for evolution-aware framing + Ford/Richards for "what would change my mind"
- **Integration designs** → Hohpe (EIP vocabulary) + Nygard (stability patterns) + Evans/Vernon (context-map relationship)
- **Architecture reviews** → Vogels Well-Architected (6 pillars) + Ford/Richards (architecture characteristics) + Newman (decomposition critique)
- **Tech stack evals** → Ford/Richards (weighted matrix) + Fowler (Radar's adopt/trial/assess/hold model)
