---
name: Brandur Leach
role: backend-eng
type: individual
researched: 2026-04-16
---

# Brandur Leach

## Why they matter to the Backend Eng
Brandur spent years at Stripe and Heroku and writes the most practically useful backend essays on the internet. His specialty is Postgres-first production engineering: idempotency keys, atomic transactional APIs, job queues built on Postgres (the `River` library is his), canonical log lines, webhook design, API versioning strategy, and the boring-but-critical operational discipline that keeps money-moving systems correct. Everything on brandur.org maps directly to decisions we make on SIA's FastAPI + Postgres stack. When in doubt on an API design question, check whether Brandur already wrote the essay — he usually has.

## Signature works & primary sources
- **"Implementing Stripe-like Idempotency Keys in Postgres"** — https://brandur.org/idempotency-keys — the canonical reference for idempotency key middleware; SIA's payment-adjacent endpoints should follow this pattern.
- **"Using Atomic Transactions to Power an Idempotent API"** — https://brandur.org/http-transactions — wrap the entire request in one Postgres transaction, including side effects via staged jobs.
- **"Transactionally Staged Job Drains in Postgres"** — https://brandur.org/job-drain — how to guarantee at-least-once job delivery without two-phase commit: stage jobs in the same transaction, drain them separately.
- **"Postgres Job Queues & Failure By MVCC"** — https://brandur.org/postgres-queues — why naive Postgres queues fall over, and how `SELECT ... FOR UPDATE SKIP LOCKED` fixes it.
- **"Canonical Log Lines"** — https://brandur.org/canonical-log-lines — one structured log line per request containing everything you need to debug; the foundation of Stripe's observability.
- **"Web APIs: Enriched DX By Disallowing Unknown Fields"** — https://brandur.org/api-strictness — reject unknown request fields; it catches typos and prevents silent no-ops.
- **"Why Doesn't Stripe Automatically Upgrade API Versions?"** — https://brandur.org/api-upgrades — version pinning protects customers.
- **River** — https://github.com/riverqueue/river — Brandur's Go + Postgres job queue; the pattern applies to Python (arq, dramatiq) too.
- **"logfmt"** — https://brandur.org/logfmt — key=value structured logging that's both human and machine parseable.
- **"Soft Deletion Probably Isn't Worth It"** — https://brandur.org/soft-deletion — prefer event logs to `deleted_at`.

## Core principles (recurring patterns)
- **Idempotency keys on every non-idempotent endpoint.** Client sends `Idempotency-Key: <uuid>`; server persists (key, request hash, response) and replays the response on retry. Non-negotiable for money, account creation, notifications.
- **One transaction per HTTP request, side effects via staged jobs.** No external API calls mid-transaction. Stage jobs in a `staged_jobs` table within the same transaction; a separate drainer enqueues them after commit.
- **Postgres is the answer until it isn't.** Use it as your DB, queue, cache (`UNLOGGED` tables), pub/sub (`LISTEN/NOTIFY`), and audit log before reaching for Kafka/Redis/SQS.
- **Canonical log line per request.** One structured line with request_id, user_id, endpoint, status, latency, db_ms, external_ms, error. Grep-able, metric-able, index-able.
- **Strict input validation.** Reject unknown fields (FastAPI: `model_config = ConfigDict(extra="forbid")`); fail fast on malformed payloads. Permissiveness compounds into bugs.
- **Version APIs by date, pin customers.** Never silently break a client. New version = new dated endpoint; old versions supported until customers migrate.
- **Prefer constraints over application-level checks.** A UNIQUE index beats a "check then insert" that races. Let Postgres do what it's good at.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Idempotency-key middleware (FastAPI sketch):**
  ```python
  @app.middleware("http")
  async def idempotency(request, call_next):
      key = request.headers.get("Idempotency-Key")
      if key and request.method in ("POST", "PUT", "PATCH"):
          with db.begin():
              row = db.execute(select(IdempotencyKey).where(IdempotencyKey.key == key).with_for_update()).scalar()
              if row and row.response_code:
                  return Response(row.response_body, status_code=row.response_code)
              response = await call_next(request)
              db.add(IdempotencyKey(key=key, request_hash=hash_req(request), response_code=response.status_code, response_body=body))
              return response
      return await call_next(request)
  ```
- **Staged-jobs table:**
  ```sql
  CREATE TABLE staged_jobs (
    id bigserial PRIMARY KEY,
    job_name text NOT NULL,
    job_args jsonb NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now()
  );
  -- Producer INSERTs in same tx as business logic. Drainer SELECTs, enqueues to real queue, DELETEs.
  ```
- **Postgres job queue with SKIP LOCKED:**
  ```sql
  SELECT * FROM jobs
  WHERE state = 'available' AND run_at <= now()
  ORDER BY run_at
  LIMIT 1
  FOR UPDATE SKIP LOCKED;
  ```
- **Canonical log line schema:** `request_id`, `user_id`, `route`, `method`, `status`, `duration_ms`, `db_queries`, `db_ms`, `external_calls`, `error_class`, `error_message`. One line per request, emitted at the end.
- **API-versioning ADR:** Use date strings (`2026-04-16`), clients send `Stripe-Version: 2026-04-16`, server routes to a version-specific transformer; old versions remain live indefinitely until deprecation notice.

## Where they disagree with others
- **Brandur (Postgres-for-everything)** vs. **Alex Xu (purpose-built microservices):** Brandur argues most teams reach for Redis/Kafka/SQS too early; Postgres with the right patterns handles it. Xu's diagrams assume you're already at scale where that's no longer true.
- **Brandur (strict input validation, disallow unknown fields)** vs. **Postel's Law ("be liberal in what you accept"):** Brandur argues Postel was wrong for modern APIs — permissiveness hides client bugs.
- **Brandur (soft deletion isn't worth it)** vs. **common ORM practice (`deleted_at` column):** he'd rather have an immutable event log and real deletes; soft delete pollutes every query.

## Pointers to source material
- Site: https://brandur.org (Articles, Atoms, Fragments, Nanoglyphs)
- Newsletter: Nanoglyph — https://brandur.org/nanoglyphs
- River job queue: https://riverqueue.com
- Background: ex-Stripe engineer; his essays encode Stripe's operational culture.
