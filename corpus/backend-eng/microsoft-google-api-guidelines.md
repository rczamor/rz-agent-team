---
name: Microsoft REST API Guidelines + Google AIP
role: backend-eng
type: organization
researched: 2026-04-16
---

# Microsoft REST API Guidelines + Google AIP

## Why they matter to the Backend Eng
These two document sets are the most mature public specs for building REST APIs at scale. Microsoft's guidelines (via Azure) encode what a global platform provider learned about versioning, long-running operations, and error shapes. Google's AIPs (API Improvement Proposals) are numbered, narrowly-scoped design rules that together define "Google-style" resource-oriented design. For SIA's FastAPI endpoints, using these as the design reference gets you consistency for free — naming, pagination, error responses, field masks, versioning — without reinventing conventions every sprint. We don't need to match them 100%, but when we deviate we should know why.

## Signature works & primary sources
- **Microsoft Azure REST API Guidelines** — https://github.com/microsoft/api-guidelines/blob/vNext/azure/Guidelines.md — the current canonical Microsoft guide (the generic version is deprecated).
- **Microsoft Graph REST API Guidelines** — https://github.com/microsoft/api-guidelines/blob/vNext/graph/GuidelinesGraph.md — applied variant for Graph APIs.
- **Google AIP index** — https://google.aip.dev — numbered API design proposals.
- **Key AIPs to know:**
  - **AIP-121: Resource-oriented design** — nouns over verbs, resources form a hierarchy.
  - **AIP-122: Resource names** — `projects/{project}/widgets/{widget}` hierarchical pattern.
  - **AIP-131–135: Standard methods** — Get, List, Create, Update, Delete with consistent semantics.
  - **AIP-151: Long-running operations** — 202 Accepted + operation polling pattern.
  - **AIP-158: Pagination** — `page_size` + `page_token` + `next_page_token`.
  - **AIP-161: Field masks** — partial responses / updates via field_mask.
  - **AIP-180: Backwards compatibility** — what counts as a breaking change.
  - **AIP-185: API versioning** — v1, v1beta1 semantics.
  - **AIP-193: Errors** — canonical error shape: `{code, message, details[]}`.
- **API Linter** — https://linter.aip.dev — tool enforcing AIPs on protobuf APIs.

## Core principles (recurring patterns)
- **Resource-oriented design.** URLs are nouns (`/users/{id}/widgets`, not `/getWidgets`); HTTP methods are the verbs. Collections are plural.
- **Standard methods with standard status codes.**
  - `GET /widgets` → 200 (list)
  - `GET /widgets/{id}` → 200 | 404
  - `POST /widgets` → 201 + Location header
  - `PUT /widgets/{id}` → 200 | 201 (full replace, idempotent)
  - `PATCH /widgets/{id}` → 200 (partial update, JSON Merge Patch or field_mask)
  - `DELETE /widgets/{id}` → 204 (no body)
- **Version from day one.** Microsoft: `?api-version=2026-04-16` dated query param. Google: `/v1/` path segment. Pick one and commit. Never break within a version.
- **Canonical error shape.** `{error: {code, message, target, details, innererror}}` (Microsoft) or `{error: {code, message, details[]}}` (Google/gRPC mapping). Include a stable `code` string (e.g., `WIDGET_NOT_FOUND`) separate from the HTTP status.
- **Pagination is cursor-based, not offset-based.** `page_size` + opaque `page_token`/`next_page_token`. Offset pagination breaks on mutations.
- **Long-running operations return 202 + status endpoint.** Body includes an `Operation` resource; client polls `GET /operations/{id}` for completion.
- **Idempotency where it matters.** PUT is naturally idempotent. POST needs an `Idempotency-Key` header pattern (see Brandur / Stripe).
- **camelCase in JSON, kebab-case in URL segments, snake_case in query params** (Google convention); Microsoft uses camelCase for both URL and JSON consistently. Pick one and document.
- **Field masks for partial responses/updates.** `?fields=id,name` or body `updateMask`. Keeps payloads small, updates precise.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Standard REST resource skeleton (SIA FastAPI):**
  ```
  GET    /api/v1/widgets?page_size=50&page_token=xxx       → 200 {items, next_page_token}
  GET    /api/v1/widgets/{id}                              → 200 | 404
  POST   /api/v1/widgets        (Idempotency-Key header)   → 201 + Location
  PATCH  /api/v1/widgets/{id}                              → 200 | 404
  DELETE /api/v1/widgets/{id}                              → 204 | 404
  ```
- **Canonical error response (Pydantic model):**
  ```python
  class ErrorDetail(BaseModel):
      reason: str            # stable machine-readable, e.g. "QUOTA_EXCEEDED"
      domain: str            # e.g. "widgets.sia.app"
      metadata: dict[str, str] = {}

  class ErrorResponse(BaseModel):
      code: int              # HTTP status echoed
      message: str           # human-readable
      status: str            # e.g. "NOT_FOUND", "INVALID_ARGUMENT"
      details: list[ErrorDetail] = []
  ```
- **Pagination pattern:**
  ```python
  @router.get("/widgets", response_model=WidgetList)
  def list_widgets(page_size: int = Query(50, le=200), page_token: str | None = None):
      cursor = decode_token(page_token) if page_token else None
      items, next_cursor = repo.list(cursor=cursor, limit=page_size + 1)
      return {"items": items[:page_size], "next_page_token": encode_token(next_cursor) if next_cursor else None}
  ```
- **Versioning ADR template:**
  - Current version: v1 (path prefix `/api/v1`)
  - Breaking-change definition (per AIP-180): removing/renaming a field, changing a field type, changing the default behavior of an existing field, changing HTTP status codes.
  - Process: breaking change → new version path (`/v2`); old version supported for N months after deprecation notice.
- **Long-running operation pattern:** `POST /reports/generate` → 202 `{operation_id, status: "RUNNING", created_at}` → client polls `GET /operations/{id}` → eventually `{status: "SUCCEEDED", result: {...}}`.

## Where they disagree with others
- **Microsoft (dated query-param versioning)** vs. **Google (path-segment versioning):** both work; pick one. Dated versions encourage continuous-compatibility thinking; path versions encourage clean breaks.
- **Google AIP (strict resource hierarchy)** vs. **REST as "loose URL style":** AIP pushes a rigor most internal APIs don't need. Use the parts that apply; don't adopt the full regime for a 20-endpoint API.
- **REST orthodoxy (Microsoft/Google)** vs. **GraphQL camps (Brandur has written on this):** REST wins on caching, tooling maturity, and HTTP primitives; GraphQL wins on client-shape flexibility. For SIA, REST is the right default.

## Pointers to source material
- Azure Guidelines: https://github.com/microsoft/api-guidelines/blob/vNext/azure/Guidelines.md
- Microsoft Graph: https://github.com/microsoft/api-guidelines/blob/vNext/graph/GuidelinesGraph.md
- Google AIP home: https://google.aip.dev
- API Linter: https://linter.aip.dev
- Related: Roy Fielding's REST dissertation (2000); JSON:API spec (https://jsonapi.org) as a third alternative for consistency.
