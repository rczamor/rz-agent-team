---
name: Martin Kleppmann
role: backend-eng
type: individual
researched: 2026-04-16
---

# Martin Kleppmann

## Why they matter to the Backend Eng
Kleppmann's *Designing Data-Intensive Applications* (DDIA) is the reference text for every backend decision that touches a database — which is nearly all of them. For the SIA FastAPI/Postgres stack and the richezamor.com Next.js/Node stack, DDIA is the lens for choosing serialization formats, understanding SQLAlchemy's isolation guarantees, reasoning about retry safety, and knowing when "eventual consistency" is a footgun. Before reaching for Kafka, Redis, or a second service, consult DDIA to confirm a single Postgres instance with the right isolation level isn't already the right answer. His CRDT research also informs any collaborative/offline features (local-first) we add to the personal site.

## Signature works & primary sources
- *Designing Data-Intensive Applications* (O'Reilly, 2017) — https://dataintensive.net — the canonical backend engineering text; mandatory for anyone building durable APIs.
- *Local-First Software* (with Ink & Switch) — https://www.inkandswitch.com/local-first/ — seven ideals for software that works offline and syncs when connected.
- Kleppmann's blog & research — https://martin.kleppmann.com — distributed systems essays, Automerge CRDT, JSON CRDT papers.
- "Please stop calling databases CP or AP" — https://martin.kleppmann.com/2015/05/11/please-stop-calling-databases-cp-or-ap.html — CAP is less useful than people think; use real tools (PACELC, linearizability).
- "Notes on Distributed Systems for Young Bloods" (recommended reading) and "A Critique of the CAP Theorem" — academic but load-bearing.

## Core principles (recurring patterns)
- **Reliability, scalability, maintainability** are the only three metrics worth optimizing for at the architecture level. Everything else is a proxy.
- **Pick the weakest consistency model that still meets the business requirement.** Serializable → snapshot isolation → read committed. Postgres defaults (read committed) are often too weak for money; use `SERIALIZABLE` or explicit `SELECT ... FOR UPDATE`.
- **Logs are the universal abstraction.** Write-ahead logs, replication logs, Kafka topics, event sourcing — they're all the same idea. Prefer append-only, ordered event streams.
- **Idempotency is a property of the handler, not the request.** Design every endpoint so a retry produces the same state (see Brandur on idempotency keys).
- **Distributed systems lie by default.** Clocks drift, packets duplicate, nodes partition. If you can keep it on one Postgres node, do.
- **Schemas evolve; design for backward and forward compatibility.** Avro/Protobuf over JSON when you control both ends; always version API payloads.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Consistency-level checklist for a new endpoint:** (1) What's the worst that happens if two writers race? (2) Can the client retry safely? (3) What isolation level does this need? (4) Would a unique constraint + ON CONFLICT do the job before I reach for a lock?
- **DDIA-driven ADR template:** Problem → Reliability requirements → Scalability requirements → Chosen storage → Consistency model → Failure modes considered (network partition, duplicate delivery, crash during commit) → Rejected alternatives.
- **"Can we do this in one Postgres?" gate:** Before adding Kafka/Redis/SQS, write out the DDIA-style argument. Most SIA-scale workloads never need more than Postgres + LISTEN/NOTIFY + a job queue table.
- **Event-sourcing skeleton:** append-only `events` table (id, aggregate_id, type, payload_jsonb, created_at) + projections rebuilt from the log. Use only when audit/replay requirements justify the complexity.

## Where they disagree with others
- **Kleppmann (rigor) vs. Brandur/practitioner (pragmatism):** DDIA teaches you every failure mode; Brandur teaches you which ones actually matter for a Stripe-scale Postgres app. Use DDIA to know what you're giving up; use Brandur to decide you can live with it.
- **Kleppmann (local-first, CRDTs) vs. REST/CRUD orthodoxy (Microsoft/Google):** He argues cloud-centric CRUD is a local maximum; collaborative/offline apps need CRDTs and sync protocols, not REST.
- **Kleppmann (skeptical of microservices)** vs. system-design-interview orthodoxy (Alex Xu): DDIA pushes back on premature distribution; a well-indexed Postgres handles more than most "scale" talks suggest.

## Pointers to source material
- Book: *Designing Data-Intensive Applications* — https://dataintensive.net
- Site: https://martin.kleppmann.com
- Talks: "Turning the database inside out," "Transactions: myths, surprises, and opportunities" (Strange Loop, YouTube)
- Research: Automerge (CRDT library) — https://automerge.org
- Local-first essay — https://www.inkandswitch.com/local-first/
