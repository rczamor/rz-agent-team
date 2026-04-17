---
role: data-eng
researched: 2026-04-16
---

# Data Eng Corpus

Role-specific knowledge corpus for the **Data Eng** agent on the 11-agent team. Scope: ingestion, publishing, analytics, lineage, ETL/ELT. Pragmatic framing for a single-VPS Postgres platform with potential downstream analytics.

## Index

- [maxime-beauchemin.md](./maxime-beauchemin.md) — Creator of Airflow/Superset; defined the modern data-engineer role and the functional-data-engineering paradigm (idempotent tasks, immutable partitions).
- [joe-reis-matt-housley.md](./joe-reis-matt-housley.md) — Authors of *Fundamentals of Data Engineering*; the lifecycle (generation→ingestion→storage→transformation→serving) and 6 undercurrents framework.
- [chip-huyen.md](./chip-huyen.md) — Data-side of ML systems: pipeline quality, training-serving skew, feature stores, real-time vs. batch. (AI Eng corpus covers her retrieval/eval work.)
- [jesse-anderson.md](./jesse-anderson.md) — *Data Teams* author; streaming/Kafka pragmatist. Why projects fail for team-structure reasons, not technical ones. When streaming is overkill.
- [dbt-labs.md](./dbt-labs.md) — dbt Labs + community; ELT, transformation-as-code, tests, lineage, data contracts. The default transformation layer for a VPS Postgres setup.
- [data-eng-weekly-locallyoptimistic.md](./data-eng-weekly-locallyoptimistic.md) — Two curated publications covering field trends: data contracts, analytics engineering, team patterns, ad-hoc work budgets.
- [airbyte-fivetran-meltano.md](./airbyte-fivetran-meltano.md) — The three dominant ingestion vendors. CDC, schema evolution, connector architecture, idempotent sync.

## How to use

When the Data Eng agent is deciding on a pattern, start by identifying which lifecycle stage (Reis/Housley) and which undercurrent is in play. For transformation logic, default to dbt-core patterns (dbt-labs.md). For ingestion decisions, consult airbyte-fivetran-meltano.md. For "should this be batch or streaming?" consult jesse-anderson.md and chip-huyen.md together — they represent the two poles. For "am I over-engineering this?" consult data-eng-weekly-locallyoptimistic.md. For any pipeline correctness question — idempotency, backfills, partition design — start at maxime-beauchemin.md.
