---
name: Sebastián Ramírez (tiangolo)
role: backend-eng
type: individual
researched: 2026-04-16
---

# Sebastián Ramírez (tiangolo)

## Why they matter to the Backend Eng
tiangolo is the creator of FastAPI, which is the backend framework for SIA. Every Python endpoint we ship routes through decisions he's already made: Pydantic v2 for validation, Starlette for ASGI, dependency injection via `Depends()`, OpenAPI generation from type hints, and async-first I/O. His docs aren't just reference — they're the opinionated style guide. When we disagree with tiangolo's defaults we should have a load-bearing reason. His adjacent projects (SQLModel, Typer) also shape our stack: SQLModel if we want one class for Pydantic + SQLAlchemy, Typer for any CLI we build around SIA.

## Signature works & primary sources
- **FastAPI docs** — https://fastapi.tiangolo.com — the canonical tutorial + reference; read the full tutorial top to bottom at least once.
- **Advanced User Guide** — https://fastapi.tiangolo.com/advanced/ — sub-applications, middleware, lifespan, WebSockets, background tasks.
- **SQLModel** — https://sqlmodel.tiangolo.com — SQLAlchemy + Pydantic unified; trades some SQLAlchemy power for DRYness.
- **Typer** — https://typer.tiangolo.com — same type-hint philosophy for CLIs; use it for SIA admin scripts.
- **tiangolo.com blog + talks** — interviews explaining the design rationale (types as source of truth, standards over invention).

## Core principles (recurring patterns)
- **Declare once, use everywhere.** A Pydantic model is the request schema, response schema, OpenAPI definition, and editor autocomplete in one place. Don't duplicate it as a TypedDict or dataclass elsewhere.
- **Types are the contract.** If a field is `Optional[str]`, FastAPI and the client both know. Never use `Any` as a shortcut.
- **Dependency injection over globals.** Database sessions, current user, settings, rate limiters — everything flows through `Depends()`. This makes testing trivial (override with `app.dependency_overrides`).
- **`response_model=` is not optional.** It's how you prevent accidentally leaking `password_hash` or internal fields. Always specify, even for simple endpoints.
- **Async by default for I/O, sync for CPU.** Use `async def` for routes that hit DB/HTTP; drop `def` (FastAPI runs it in a threadpool) only when the library is sync-only.
- **Standards over invention.** OpenAPI, JSON Schema, OAuth2, JWT — use the spec, don't roll your own.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Idiomatic FastAPI route skeleton:**
  ```python
  from fastapi import APIRouter, Depends, status, HTTPException
  from sqlalchemy.orm import Session

  router = APIRouter(prefix="/widgets", tags=["widgets"])

  @router.post("", response_model=WidgetRead, status_code=status.HTTP_201_CREATED)
  def create_widget(
      payload: WidgetCreate,
      db: Session = Depends(get_db),
      current_user: User = Depends(get_current_user),
  ) -> WidgetRead:
      widget = Widget(**payload.model_dump(), owner_id=current_user.id)
      db.add(widget); db.commit(); db.refresh(widget)
      return widget
  ```
- **DB session dependency pattern (uses `yield` for cleanup):**
  ```python
  def get_db():
      db = SessionLocal()
      try: yield db
      finally: db.close()
  ```
- **Auth dependency chain:** `get_token` → `decode_jwt` → `get_current_user` → `require_role("admin")`. Each is a `Depends()` that composes.
- **Pydantic v2 schema trio per resource:** `WidgetBase` (shared fields), `WidgetCreate` (input), `WidgetRead` (output with `id`, `created_at`). Use `model_config = ConfigDict(from_attributes=True)` for ORM mode.
- **Error-response convention:** `HTTPException(status_code=404, detail="Widget not found")` for 4xx; custom exception handlers for 5xx that log + return RFC 7807 problem details.

## Where they disagree with others
- **tiangolo (type-hints-as-contract) vs. Flask/Django REST Framework (decorators + serializers):** FastAPI is opinionated that the Python type system IS the schema; DRF keeps a separate serializer class.
- **tiangolo (SQLModel) vs. Mike Bayer (pure SQLAlchemy):** Bayer prefers separation of table models from transport schemas; SQLModel unifies them. For complex queries, Bayer wins; for CRUD, SQLModel is faster to ship.
- **FastAPI async-first** vs. Django's sync-first history: FastAPI assumes you know the difference; misusing `async def` with a sync DB driver is a footgun the framework won't catch.

## Pointers to source material
- https://fastapi.tiangolo.com (tutorial, advanced guide, reference)
- https://sqlmodel.tiangolo.com
- https://typer.tiangolo.com
- https://github.com/tiangolo/fastapi (issues, discussions)
- Talks: "FastAPI from the ground up" (PyCon), various podcast interviews with tiangolo on the design of type-driven frameworks.
