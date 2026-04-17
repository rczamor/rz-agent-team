---
name: Carson Gross
role: ui-eng
type: individual
researched: 2026-04-16
---

# Carson Gross

## Why they matter to the UI Eng
Carson Gross created HTMX and wrote *Hypermedia Systems* (hypermedia.systems). For the UI Eng, Gross is the intellectual foundation of the **SIA stack** — Flask + Jinja + Pico.css + HTMX — which deliberately avoids React, build pipelines, and client-side state. Where Abramov and the Vercel team teach you to think about the *two* computers of RSC, Gross teaches you to treat the browser as a **hypermedia client** and let the server be the single source of truth. For productionizing Designer prototypes into SIA, Gross's writing is not optional background — it's the operating manual. His principles (hypermedia as engine of application state, locality of behavior, HTML over the wire) dictate how `hx-*` attributes are placed in Jinja templates, how partial re-renders are scoped, and why a form submit can update three regions of the page without a single line of JavaScript.

## Signature works & primary sources
- *Hypermedia Systems* (book) — https://hypermedia.systems — free online; the canonical explanation of HATEOAS, HDAs (Hypermedia-Driven Applications), and HTMX.
- HTMX docs — https://htmx.org/docs — reference for every `hx-*` attribute.
- *HATEOAS* essay — https://htmx.org/essays/hateoas — why REST-as-defined-by-Fielding requires hypermedia.
- *Locality of Behavior* — https://htmx.org/essays/locality-of-behaviour — the design principle that keeps interaction code next to the markup it affects.
- *How Did REST Come To Mean The Opposite of REST?* — https://htmx.org/essays/how-did-rest-come-to-mean-the-opposite-of-rest — why JSON APIs aren't REST.
- *Hypermedia-Driven Applications* — https://htmx.org/essays/hypermedia-driven-applications — the alternative to SPAs.
- *Why htmx Does Not Have a Build Step* — https://htmx.org/essays/no-build-step — simplicity as a design constraint.

## Core principles (recurring patterns)
- **Hypermedia as the engine of application state (HATEOAS).** The server returns HTML that describes what the user can do next; the client doesn't know business rules, just how to render and follow links.
- **Locality of Behavior.** The button that triggers an action has the attributes describing that action *on the button itself* (`hx-post`, `hx-target`, `hx-swap`) — not in a separate JS file.
- **HTML over the wire.** Responses are HTML fragments, not JSON. The server composes markup; the client swaps it into the DOM.
- **No build step.** A `<script src="htmx.org">` tag is the entire install. This is a feature: it removes Webpack/Vite/Turbopack from SIA's failure modes.
- **Progressive enhancement by default.** An HTMX form still works without HTMX loaded — `hx-post` layers on top of `action=`.
- **Smaller surface area = smaller bug surface.** No VDOM, no hydration, no client router, no state-sync.

## Concrete templates, checklists, or artifacts the agent can reuse
**Core `hx-*` attribute cheat-sheet (the SIA working set):**
- `hx-get="/url"` — issue a GET on trigger; swap response into target.
- `hx-post="/url"` — POST (forms, mutations).
- `hx-target="#id"` — CSS selector for the element that receives the response.
- `hx-swap="outerHTML|innerHTML|beforeend|afterbegin|none"` — how to merge the response.
- `hx-trigger="click|submit|change|keyup changed delay:300ms"` — what event fires the request.
- `hx-push-url="true"` — update the browser address bar (back/forward still work).
- `hx-indicator="#spinner"` — element shown with `.htmx-request` class during the in-flight request.
- `hx-boost="true"` — upgrade all descendant `<a>`/`<form>` to AJAX without rewriting them.
- `hx-vals='{"extra": "value"}'` — supplementary data to send.
- `hx-confirm="Are you sure?"` — native confirm dialog before firing.

**Jinja partial + HTMX pattern (SIA standard template for any "update this region" interaction):**
```html
<!-- base.html fragment -->
<button
  hx-post="/todos"
  hx-target="#todo-list"
  hx-swap="beforeend"
  hx-indicator="#adding"
>
  Add todo
</button>
<span id="adding" class="htmx-indicator">Adding…</span>
<ul id="todo-list">
  {% for todo in todos %}
    {% include "partials/_todo_item.html" %}
  {% endfor %}
</ul>
```
```python
# Flask route returns an HTML partial, not JSON
@app.post("/todos")
def create_todo():
    todo = Todo.create(...)
    return render_template("partials/_todo_item.html", todo=todo)
```

**SIA productionization checklist (prototype → production):**
1. Every interactive element has `hx-*` attributes *on the element*; no separate JS file.
2. Every HTMX endpoint has both a full-page and partial-fragment response path (or uses `HX-Request` header to branch).
3. Forms work without JS (have `action` and `method` fallback).
4. `hx-indicator` is present anywhere the request can exceed ~200ms.
5. `hx-confirm` or a server-side confirmation step on destructive actions.
6. `hx-push-url` on navigation-like interactions so back button works.

## Where they disagree with others
- **Gross vs. Abramov/Vercel:** Gross rejects the premise that the browser should run an app-sized JS runtime at all. Abramov's "two computers" is one program split across two machines; Gross's model is one program on the server with a hypermedia client.
- **Gross vs. the JSON-API+SPA mainstream:** he argues JSON APIs decoupled from a client are a decade-long industry detour away from REST-as-Fielding-meant-it.
- **Gross vs. component-library-centric UI (React, Vue):** HTMX has no components in the JS sense — partials are the unit of reuse, not closures-over-props.

## Pointers to source material
- HTMX: https://htmx.org
- Essays: https://htmx.org/essays
- Book: https://hypermedia.systems (free to read online; also on Amazon)
- GitHub: https://github.com/bigskysoftware/htmx
