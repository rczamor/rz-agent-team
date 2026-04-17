---
name: Airbyte + Fivetran + Meltano
role: data-eng
type: organization
researched: 2026-04-16
---

# Airbyte + Fivetran + Meltano

## Why they matter to the Data Eng
These three vendors dominate modern **ingestion** — the "E and L" of ELT. Their engineering blogs are the best open references for how to think about **connector design, CDC (change data capture), schema evolution, incremental sync, and sync reliability**. For a single-VPS Postgres setup, the choice among them is consequential: **Airbyte** (OSS, 600+ connectors, self-hostable in Docker on the same VPS, Debezium-based CDC) is typically the right default for a tight budget; **Fivetran** (fully managed SaaS, strong schema-drift handling) is where you go when engineering time costs more than vendor bills; **Meltano** (Singer-based, code-first, git-native, no CDC) fits teams that want ingestion in version control next to dbt. Reading all three blogs in rotation teaches the generic ingestion vocabulary — idempotent syncs, cursor-based vs. log-based, primary-key dedup, normalization strategies — that applies regardless of tool.

## Signature works & primary sources
- **Airbyte blog** — https://airbyte.com/blog — CDC internals (Debezium), connector development kit (CDK), schema change handling.
- **Fivetran blog** — https://www.fivetran.com/blog — schema drift handling, idempotent merges, "automated data movement" philosophy.
- Fivetran "CDC Tools" guide — https://www.fivetran.com/learn/cdc-tools — useful neutral-ish overview.
- **Meltano blog** — https://meltano.com/blog — Singer spec, plugin model, git-based ELT workflows.
- Singer spec — https://github.com/singer-io/getting-started — the underlying tap/target protocol Meltano uses.
- Debezium docs — https://debezium.io/documentation/ — what both Airbyte and many in-house CDC pipelines wrap.

## Core principles (recurring patterns)
- **ELT, not ETL at ingestion time**: land raw as-is; transform in the warehouse. Ingestion should not lose information or pre-aggregate.
- **Idempotent sync is the ground truth**: syncing the same data twice must produce the same result. Use primary keys + upsert, not blind inserts.
- **CDC > cursor-based sync for mutable sources**: log-based CDC (Postgres WAL via Debezium, MySQL binlog) captures deletes and updates; a `WHERE updated_at > ?` cursor misses both.
- **Schema evolution is inevitable, not exceptional**: connectors must detect added/removed/renamed columns and propagate without silently dropping data. Fivetran auto-adjusts; Airbyte surfaces explicit schema-change behavior per stream.
- **Separate extract from load from normalize**: the `E`, `L`, and any typing/unnesting are distinct concerns. Airbyte explicitly splits "raw" tables from "normalized" tables.
- **Backfill is a first-class operation**: a connector that can sync ongoing incrementals but not safely re-seed history is a time bomb.
- **Connector ownership cost matters**: community OSS connectors can break on API changes with no SLA. Fivetran pays for a team to fix theirs. Pick based on whose time you'd rather spend.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Pre-ingestion source-audit checklist** (run before adding any connector): (1) primary key(s) per table — are they stable? (2) update-timestamp column present and monotonic? (3) deletes — hard or soft? if hard, CDC required. (4) row volume (daily new + update rate). (5) PII columns — any? (6) schema-change cadence from the vendor. (7) API rate limits.
- **CDC setup checklist (Postgres source)**:
  - Create a dedicated replication role: `CREATE ROLE repl REPLICATION LOGIN PASSWORD '...';`
  - Set `wal_level = logical` in `postgresql.conf`, restart.
  - Create publication: `CREATE PUBLICATION airbyte_pub FOR TABLE ...;`
  - Create replication slot via connector (or `SELECT pg_create_logical_replication_slot(...)`).
  - Monitor slot lag: `SELECT slot_name, pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn) FROM pg_replication_slots;` — lag means your connector is behind.
  - Alert on slot lag > SLA; an abandoned slot will eventually fill the disk.
- **Schema-evolution playbook**: (1) new column — auto-add, default null. (2) dropped column — keep in warehouse, stop populating, tombstone after retention. (3) renamed column — treat as drop + add. (4) type widened (int→bigint) — warehouse follows. (5) type narrowed — blocked, requires human.
- **Connector choice decision tree**: need CDC + self-host + OSS → Airbyte. Need zero ops + vendor SLA → Fivetran. Need git-native ingestion alongside dbt, no CDC needed → Meltano. Need "just Postgres → Postgres" → consider native logical replication first.
- **Sync monitoring minimum**: per-stream last-success timestamp, row count, duration, error rate; alert on freshness SLA breach and on 3 consecutive failures.

## Where they disagree with others
- **Airbyte vs. Fivetran**: Airbyte's open-source-first stance vs. Fivetran's managed-service stance. Airbyte lets you fix a connector yourself; Fivetran lets you not think about it.
- **Fivetran vs. dbt/ELT purists**: Fivetran sometimes does light normalization during load (e.g., flattening JSON into typed columns), which some ELT purists see as transformation bleeding into ingestion. Airbyte splits this explicitly into "raw" and "normalized" outputs.
- **Meltano vs. Airbyte/Fivetran**: Meltano rejects the GUI/SaaS model entirely — ingestion config lives in `meltano.yml` in git. Good for code-first teams; bad for business users who want to click-configure a new source.
- **Log-based CDC vs. polling**: all three recommend CDC for mutable sources; Meltano's Singer ecosystem historically lags here, which is a real gap for OLTP sources.

## Pointers to source material
- Airbyte: https://airbyte.com/blog  |  docs: https://docs.airbyte.com  |  GitHub: https://github.com/airbytehq/airbyte
- Fivetran: https://www.fivetran.com/blog  |  docs: https://fivetran.com/docs
- Meltano: https://meltano.com/blog  |  docs: https://docs.meltano.com  |  GitHub: https://github.com/meltano/meltano
- Singer spec: https://github.com/singer-io/getting-started
- Debezium: https://debezium.io
