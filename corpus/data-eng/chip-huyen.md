---
name: Chip Huyen
role: data-eng
type: individual
researched: 2026-04-16
---

# Chip Huyen

## Why they matter to the Data Eng
For the Data Eng role, Chip Huyen's contribution is the **data side of ML systems**: pipeline design, data quality at production scale, training–serving skew, feature stores, and the gap between "batch data" and "real-time data" that ML workloads expose. *Designing Machine Learning Systems* (O'Reilly, 2022) devotes several chapters to the data pipeline — sources, formats, storage, ingestion, processing — before anything about models. Her blog posts on streaming for data scientists and real-time ML explicitly argue that batch and streaming should share one mental model. On a single-VPS Postgres, her value is diagnostic: she names failure modes (drift, skew, leakage, stale features) the Data Eng agent should instrument *before* the business asks for ML. (Huyen also appears in the AI Eng corpus; that file covers retrieval, evals, and prompts — this file stays on pipelines and data.)

## Signature works & primary sources
- *Designing Machine Learning Systems* (O'Reilly, 2022) — https://www.oreilly.com/library/view/designing-machine-learning/9781098107956/ — production-ML lifecycle with heavy emphasis on data.
- "Introduction to streaming for data scientists" (2022) — https://huyenchip.com/2022/08/03/stream-processing-for-data-scientists.html — why/when streaming matters in pipelines.
- "Real-time machine learning: challenges and solutions" (2022) — https://huyenchip.com/2022/01/02/real-time-machine-learning-challenges-and-solutions.html — online prediction + continual learning architecture.
- "Machine learning is going real-time" (2020) — https://huyenchip.com/2020/12/27/real-time-machine-learning.html — the shift from batch to real-time pipelines.
- MLOps guide — https://huyenchip.com/mlops/ — curated map of tooling and concepts.

## Core principles (recurring patterns)
- **Data quality dominates model quality**: most "model problems" in production are pipeline problems — bad joins, stale features, silent schema drift. Instrument the pipeline before tuning the model.
- **Training-serving skew is the default failure**: if training features and serving features are computed by different code paths, they will diverge. Unify via a feature store or a shared transformation library.
- **Treat static data as a bounded subset of streaming data**: one mental model (streams, windows, watermarks) subsumes batch. You don't need Kafka on a VPS, but the model of "events arriving over time" still applies to a Postgres `CREATED_AT` column.
- **Data drift vs. concept drift are different alarms**: input distribution changing ≠ input→output relationship changing. Monitor both, and respond differently (retrain vs. rethink).
- **Freshness is a tradeoff, not a virtue**: fresher features mean more complex pipelines. Pick the freshness each use case actually needs, not the ceiling.
- **Feature reusability is a social problem**: the same "user_7d_active_count" feature should have one definition, one owner, one monitor. Duplicated transforms are how training-serving skew sneaks in.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Data-quality check list (per-table, per-run)**: schema match, row-count delta vs. 7-day average, freshness SLA (max lag from source), null-rate per column, PK uniqueness, referential integrity on key foreign keys, value-range sanity check, distribution drift (PSI or KS test) on critical columns.
- **Feature-spec template**: name, owner, definition SQL, source tables, refresh cadence, freshness SLA, serving latency target, training-vs-serving parity test. One page per feature.
- **Skew-detection CI check**: before any model promotion, compute features on the same sample via both training and serving code paths and assert byte-equality (or tight tolerance).
- **Freshness tiers**: `realtime` (<1s), `near-realtime` (seconds–minutes), `hourly`, `daily`, `adhoc`. Tag every table. Any consumer claiming a stricter tier than the source provides is a latent bug.
- **Pipeline failure budget**: target % of runs per month that can fail without breaking the SLO. Drives how paranoid the retry/alert logic needs to be.

## Where they disagree with others
- vs. "offline batch is enough" (classic Beauchemin): Huyen argues that for many ML use cases, batch features go stale fast enough that streaming-style thinking becomes mandatory — even if the implementation is still batch.
- vs. "feature store = buy a vendor": she emphasizes that the *discipline* (one definition, one owner, training/serving parity) matters more than any specific product. A well-named dbt model + a shared Python function can be a feature store at small scale.
- vs. "monitoring = dashboards": she pushes instrumentation for drift, skew, and freshness, not vanity metrics; a green dashboard does not mean a healthy pipeline.

## Pointers to source material
- Blog: https://huyenchip.com/blog/
- Book: *Designing Machine Learning Systems* — https://www.oreilly.com/library/view/designing-machine-learning/9781098107956/
- Newer book (more relevant to AI Eng corpus): *AI Engineering* (O'Reilly, 2024) — deferred to that file.
- Personal site: https://huyenchip.com
