---
name: Mike Bayer (zzzeek)
role: backend-eng
type: individual
researched: 2026-04-16
---

# Mike Bayer (zzzeek)

## Why they matter to the Backend Eng
Mike Bayer created SQLAlchemy and Alembic — the ORM and migration tool underpinning SIA's Postgres layer. Every model, query, and migration we ship goes through his design. Bayer is unusual in that he publishes not just docs but the *rationale* for API changes, the session/unit-of-work model, and why certain patterns (like async SQLAlchemy) were added cautiously. For anything harder than a CRUD query — eager loading, transaction scoping, async sessions, bulk operations, complex joins — his docs and zzzeek.org essays are the authoritative source. SQLAlchemy 2.0 style is the current idiom; mixing 1.x and 2.0 patterns is a common bug source.

## Signature works & primary sources
- **SQLAlchemy 2.0 docs** — https://docs.sqlalchemy.org/en/20/ — read the Unified Tutorial end-to-end once.
- **Alembic docs** — https://alembic.sqlalchemy.org — migrations, autogenerate, branching, stamp.
- **zzzeek.org blog** — https://techspot.zzzeek.org — deep essays on ORM tradeoffs, "asyncio is not faster," Session patterns.
- **Session Basics** — https://docs.sqlalchemy.org/en/20/orm/session_basics.html — the single most important page for avoiding production bugs.
- **"Asynchronous IO and Databases"** (zzzeek blog) — explains why async SQLAlchemy is *not* automatically faster; concurrency model matters more than async keyword.

## Core principles (recurring patterns)
- **The Session is a unit of work, not a cache.** It tracks changes between `begin` and `commit/rollback`. Don't use it to cache results across requests.
- **One Session per request/task, full stop.** Web request = one Session (dependency-injected). Background job = one Session. Never share across threads or async tasks.
- **Transaction boundary = business boundary.** Open a transaction when the business operation starts; commit when it succeeds; rollback on any exception. Use `with Session.begin():` to get this automatically.
- **Prefer the 2.0 style `select()` + `session.execute()` / `session.scalars()`** over the legacy `session.query()`. All new code is 2.0 style.
- **Eager-load explicitly** with `selectinload()` / `joinedload()` to avoid N+1. Never rely on lazy loading in response serialization — it fails when the session is closed.
- **Migrations are code; test them.** Always run `alembic upgrade head && alembic downgrade -1 && alembic upgrade head` locally before merging. Autogenerate is a draft, not a finished migration.
- **Don't hide SQL.** SQLAlchemy's value is giving you the full power of SQL, not abstracting it away. When a query gets complex, write `select()` statements explicitly; don't chain obscure ORM filters.

## Concrete templates, checklists, or artifacts the agent can reuse
- **FastAPI + SQLAlchemy 2.0 session dependency:**
  ```python
  engine = create_engine(DATABASE_URL, pool_pre_ping=True)
  SessionLocal = sessionmaker(engine, expire_on_commit=False)

  def get_db():
      with SessionLocal() as session:
          with session.begin():
              yield session
  # session.begin() commits on success, rolls back on exception — no manual try/except.
  ```
- **2.0-style query template:**
  ```python
  stmt = (
      select(Widget)
      .where(Widget.owner_id == user_id)
      .options(selectinload(Widget.parts))
      .order_by(Widget.created_at.desc())
      .limit(50)
  )
  widgets = db.scalars(stmt).all()
  ```
- **Alembic migration checklist:** (1) autogenerate, (2) read every generated op, (3) add data backfills if columns become NOT NULL, (4) test `upgrade → downgrade → upgrade`, (5) use `op.execute()` with explicit SQL for anything autogenerate can't detect (check constraints, partial indexes), (6) never edit a migration that's landed on main.
- **Alembic migration template:**
  ```python
  """add idempotency_key to payments"""
  revision = "a1b2c3d4"
  down_revision = "previous_rev"

  def upgrade():
      op.add_column("payments", sa.Column("idempotency_key", sa.String(255), nullable=True))
      op.create_index("ix_payments_idem", "payments", ["idempotency_key"], unique=True)

  def downgrade():
      op.drop_index("ix_payments_idem", table_name="payments")
      op.drop_column("payments", "idempotency_key")
  ```
- **Bulk-insert pattern:** `session.execute(insert(Widget), [dict1, dict2, ...])` — not `session.add_all()` for large batches.

## Where they disagree with others
- **Bayer (Core + ORM separation)** vs. **tiangolo (SQLModel unifies them):** Bayer designed SQLAlchemy so you can drop to raw SQL when the ORM is wrong for the task; SQLModel hides that seam. Use SQLModel for simple apps, pure SQLAlchemy once queries get real.
- **Bayer (async isn't magic)** vs. FastAPI community ("just add async"): zzzeek's "asyncio is not faster" essay argues sync SQLAlchemy + threadpool is often simpler and fast enough. Choose deliberately.
- **Bayer (explicit sessions)** vs. Django ORM (implicit global connection): SQLAlchemy requires you to think about session scope; Django hides it. SQLAlchemy's approach prevents a whole class of transaction-leak bugs.

## Pointers to source material
- Docs: https://docs.sqlalchemy.org/en/20/
- Alembic: https://alembic.sqlalchemy.org
- Blog: https://techspot.zzzeek.org
- GitHub: https://github.com/sqlalchemy/sqlalchemy
- Talks: "The SQLAlchemy Session in Depth" (PyCon), various FOSDEM/PyGotham talks on ORM internals.
