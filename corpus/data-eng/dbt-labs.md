---
name: dbt Labs + the dbt community
role: data-eng
type: organization
researched: 2026-04-16
---

# dbt Labs + the dbt community

## Why they matter to the Data Eng
dbt (founded 2016 as Fishtown Analytics, now dbt Labs) defined the modern **ELT + transformation-as-code** paradigm. Before dbt, SQL transformations lived as ad-hoc scripts or stored procedures; dbt reframed them as software — version controlled, modular, tested, documented, and lineage-aware. For a single-VPS Postgres setup, **dbt-core** is very likely the right default transformation layer: it runs against Postgres natively, needs no extra infrastructure, produces a lineage graph from the model DAG, and brings schema tests (`not_null`, `unique`, `accepted_values`, `relationships`) without any bolt-on tool. The dbt community (Slack, discourse, dbt Coalesce talks) is also where most modern-data-stack patterns — data contracts, the analytics engineer role, semantic layers — are hashed out in public.

## Signature works & primary sources
- dbt docs — https://docs.getdbt.com — the canonical reference; start with "How we structure our dbt projects" and "Data build tool best practices."
- getdbt.com blog — https://www.getdbt.com/blog — patterns, case studies, product releases.
- dbt Discourse — https://discourse.getdbt.com — archived long-form discussion; many "how do I …" answers live here.
- dbt Community Slack — https://www.getdbt.com/community — real-time Q&A; ~100k+ practitioners.
- *The Analytics Engineer* (Kaminsky / Handy / dbt Labs writings, 2019+) — popularized the role the tool enables.
- Coalesce conference talks — https://coalesce.getdbt.com — annual field snapshot.

## Core principles (recurring patterns)
- **ELT over ETL**: load raw data first, transform in-warehouse with SQL. Leverages the warehouse's compute; keeps raw auditable; makes transformations debuggable.
- **Transformations are software**: models live in git, reviewed via PR, tested in CI, deployed via tagged releases. "Analytics is engineering."
- **Staging → intermediate → marts layering**: `stg_*` renames and types raw; `int_*` joins business logic; `fct_*`/`dim_*` serve consumers. Each layer is a clear abstraction.
- **Tests as first-class citizens**: schema tests declared in YAML alongside models; singular SQL tests for business rules. `dbt build` fails loudly on violations.
- **Docs + lineage are emitted, not written**: `dbt docs generate` builds a browsable site and DAG from the code. No separate documentation project.
- **Ref, don't hardcode**: `{{ ref('model_name') }}` instead of raw table names — this is what makes lineage, deferred compilation, and environment-aware builds work.
- **Incremental models for scale**: `{% if is_incremental() %}` filters let a model grow beyond what a full-refresh can handle, without leaving SQL.
- **Data contracts (dbt 1.5+)**: declare a model's public schema, enforce column types and constraints, version breaking changes — codifies producer↔consumer agreements.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Minimum dbt model skeleton**:
  ```sql
  -- models/marts/fct_orders.sql
  {{ config(materialized='table') }}
  SELECT
    order_id,
    customer_id,
    order_date,
    total_amount
  FROM {{ ref('stg_orders') }}
  WHERE order_date >= '2020-01-01'
  ```
  With `schema.yml`:
  ```yaml
  version: 2
  models:
    - name: fct_orders
      description: "One row per completed order."
      columns:
        - name: order_id
          tests: [not_null, unique]
        - name: customer_id
          tests:
            - not_null
            - relationships: { to: ref('dim_customers'), field: customer_id }
  ```
- **Incremental model template** (Postgres-safe): unique key + `WHERE updated_at > (SELECT max(updated_at) FROM {{ this }})` guarded by `is_incremental()`.
- **Project structure** (official): `models/staging/<source>/`, `models/intermediate/<domain>/`, `models/marts/<domain>/`, plus `tests/`, `macros/`, `seeds/`, `snapshots/`.
- **dbt test taxonomy to adopt on day one**: `not_null` + `unique` on every primary key; `relationships` on every FK; `accepted_values` on every enum; a custom SQL test for at least one end-to-end business invariant per mart.
- **CI recipe**: on PR, run `dbt build --select state:modified+ --defer --state ./prod-manifest` — builds only changed models and their descendants against prod artifacts. Fast and safe.
- **Data-contract stub** (dbt 1.5+): `contract: {enforced: true}` in the model config + typed columns in YAML.

## Where they disagree with others
- vs. ETL-first vendors (classic Fivetran-only, Informatica): dbt's thesis is that transformation belongs *in* the warehouse, not before it. Pre-transformed data is harder to audit and re-derive.
- vs. notebook-driven analytics (Jupyter, Hex as source-of-truth): dbt insists transformations live in git-versioned, tested SQL files — notebooks are for exploration, not production logic.
- vs. "one giant model" orthodoxy: dbt's layering (stg/int/marts) pushes against sprawling CTEs and encourages many small, testable models.

## Pointers to source material
- Docs: https://docs.getdbt.com
- Blog: https://www.getdbt.com/blog
- Discourse: https://discourse.getdbt.com
- Slack: https://www.getdbt.com/community
- GitHub: https://github.com/dbt-labs/dbt-core
- Coalesce: https://coalesce.getdbt.com
