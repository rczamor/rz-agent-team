---
role: ui-eng
researched: 2026-04-16
---

# UI Eng corpus

Knowledge corpus for the **UI Eng** agent on the 11-agent team. Role scope: productionize Designer prototypes into React/Next.js (richezamor.com) or HTMX/Jinja/Pico (SIA), with responsibility for templates, components, accessibility, and performance. UI Eng does **not** design from scratch.

## Files

- **[dan-abramov.md](./dan-abramov.md)** — Foundational React thinking; the *Two Reacts* / *React for Two Computers* mental model that governs every Server/Client Component boundary on richezamor.com.
- **[kent-c-dodds.md](./kent-c-dodds.md)** — React architecture focus (not testing): state colocation, server-cache vs. UI-state, compound components, composition-before-Context-before-Redux.
- **[vercel-team.md](./vercel-team.md)** — Lee Robinson, Delba de Oliveira, Guillermo Rauch. Normative source for Next.js App Router, RSC, caching (`use cache`, `cacheLife`, `cacheTag`), Server Actions, streaming, edge patterns.
- **[carson-gross-htmx.md](./carson-gross-htmx.md)** — Creator of HTMX and author of *Hypermedia Systems*. The intellectual foundation of the SIA stack (Flask + Jinja + Pico + HTMX): HATEOAS, locality of behavior, HTML over the wire, `hx-*` attribute cheat-sheet.
- **[josh-comeau.md](./josh-comeau.md)** — Production CSS and interaction polish (not design): modern CSS reset, CSS custom properties for React state, `linear()` spring animations, reduced-motion discipline, production animation checklist.
- **[addy-osmani.md](./addy-osmani.md)** — Core Web Vitals thresholds (LCP ≤ 2.5s, INP ≤ 200ms, CLS ≤ 0.1), image optimization, rendering patterns (SSG/ISR/SSR/islands), *Learning Patterns*, performance budgets.
- **[webdev-mdn-smashing.md](./webdev-mdn-smashing.md)** — Three platform-level references: web.dev (Chrome-authored performance/a11y/CSS curricula), MDN (neutral cross-browser spec reference + compat tables), Smashing Magazine (long-form practitioner articles and books).

## How to use
Prefer framework-specific sources first for the stack in play (Vercel for Next.js, Gross for SIA/HTMX), then reach for cross-cutting sources (Abramov for model, KCD for patterns, Comeau for CSS, Osmani for perf, the web.dev/MDN/Smashing trio for platform truth).
