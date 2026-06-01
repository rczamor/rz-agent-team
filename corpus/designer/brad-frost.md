---
name: Brad Frost
role: designer
type: individual
researched: 2026-04-16
---

# Brad Frost

## Why they matter to the Designer
Atomic Design is the mental model that turns a pile of HTML into a reusable component system — which is exactly what a `design-prototype/` directory should hand to UI Eng. Because the Designer builds in code, Frost's atoms/molecules/organisms map one-to-one onto real files: `Button.jsx`, `SearchForm.jsx`, `SiteHeader.jsx` for the Tailwind + React site, and `_button.html`, `_search.html`, `_header.html` Jinja partials for SIA. The atomic vocabulary also gives the Designer and UI Eng a shared language at handoff — "this is an organism with two molecules inside" is precise in a way that "the top thing" is not. Frost's insistence that pattern libraries be *living* (not dead PDFs) aligns with the team's principle that design artifacts are running code.

## Signature works & primary sources
- *Atomic Design* (free online book) — https://atomicdesign.bradfrost.com/ — the canonical reference, freely readable.
- *Atomic Design* (print, 2016) — the paperback version.
- Pattern Lab — https://patternlab.io/ — open-source tool for building atomic design systems; the spiritual ancestor of Storybook.
- bradfrost.com — https://bradfrost.com/blog/ — ongoing essays on design systems, governance, and front-end architecture.
- *Frostapalooza* and talks — YouTube archive of conference talks on design system maturity.

## Core principles (recurring patterns)
- **Five-stage hierarchy.** Atoms (primitive HTML — button, input, label) → molecules (small combinations — labelled input, search bar) → organisms (full sections — site header, product card grid) → templates (page-level layout skeletons) → pages (real-content instances).
- **Single responsibility at the molecule level.** A molecule does one thing well. If a "molecule" is doing two jobs, it is really an organism wrapping two molecules.
- **Mental model, not linear process.** Atomic design is not a waterfall — you move between abstract and concrete constantly. Build an organism to discover you need two new atoms; that is normal.
- **Pattern libraries must be living code.** Static style guide PDFs die. The pattern library must be the same code that ships to production.
- **Templates describe structure; pages prove it.** Templates are content-agnostic skeletons; pages fill them with real content and are where you catch "this pattern breaks when the title is 80 characters long."
- **Design systems are governance, not just components.** Frost's later work emphasizes the human/org side: naming, contribution model, versioning, deprecation.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Atomic hierarchy map for Tailwind + React** — `/components/atoms/` (Button, Input, Label, Icon), `/components/molecules/` (FormField, SearchBar, Card), `/components/organisms/` (SiteHeader, Footer, ProjectGrid), `/templates/` (MarketingPage, ArticlePage), `/pages/` (actual route components). Naming: PascalCase for React, match file to export.
- **Atomic hierarchy map for HTMX + Jinja + Pico (SIA)** — `templates/atoms/_button.html`, `templates/molecules/_field.html`, `templates/organisms/_nav.html`, `templates/layouts/base.html`, `templates/pages/dashboard.html`. Use Jinja `{% include %}` and `{% macro %}` to compose.
- **Pattern-library index template** — a `/prototype/index.html` (or `/styleguide` route) that renders every atom/molecule/organism in isolation with variant states (default, hover, focus, disabled, loading, error, empty). This is the handoff deliverable.
- **Molecule-vs-organism test** — ask: "does this component make sense on its own with one responsibility?" If yes, molecule. If it orchestrates several responsibilities (e.g., a header with nav + search + auth), organism.
- **Naming checklist** — name by function not appearance (`PrimaryButton` not `BlueButton`; `CardGrid` not `ThreeColumnGrid`); consistent across React and Jinja (same `Card` concept → `Card.jsx` and `_card.html`).

## Where they disagree with others
- **Frost (component abstraction) vs. Wathan (utility-first).** Atomic Design assumes you name and abstract components early; Tailwind's utility-first says resist premature abstraction — duplicate utilities first, extract components only when the pattern is proven. In practice both coexist: utilities inside a component, component boundaries where the Designer draws them.
- **Frost vs. "just use Storybook."** Frost argues the pattern library should be the same codebase and routes as production (Pattern Lab's model), not a parallel sandbox that drifts. Storybook-heavy teams often let docs rot.
- **Frost vs. Figma-centric workflows.** Frost's whole thesis is that the component source of truth is code, not design files — which aligns perfectly with the Designer's no-Figma mandate.

## Pointers to source material
- https://atomicdesign.bradfrost.com/ — full free book.
- *Atomic Design* (Brad Frost, 2016).
- https://bradfrost.com/blog/ — blog, especially posts tagged "design systems."
- https://patternlab.io/ — Pattern Lab tool.
- https://bradfrost.com/blog/post/atomic-web-design/ — original 2013 essay.
