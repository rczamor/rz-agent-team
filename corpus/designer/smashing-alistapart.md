---
name: Smashing Magazine + A List Apart
role: designer
type: publication
researched: 2026-04-16
---

# Smashing Magazine + A List Apart

## Why they matter to the Designer
These are the two longest-running substantive publications for web design craft, and their article archives are a 20-year running commentary on the exact skills the Designer needs: modern CSS, accessibility, design systems as code, form UX, responsive patterns, typography, and handoff practices. Because the Designer works in code — not Figma — generic "UX thought leadership" is less useful than article-length walkthroughs of "here is a CSS Grid subgrid pattern for holy-grail layouts" or "modal vs. full page: a UX decision tree." Both publications reliably ship that kind of article. They are where the Designer goes to resolve a specific question ("what is the current best practice for skeleton loaders?") rather than read for general inspiration. A List Apart, in particular, has historically broken responsive web design (Ethan Marcotte, 2010) and content strategy as discipline.

## Signature works & primary sources
- Smashing Magazine — https://www.smashingmagazine.com/ — daily long-form articles on front-end, UX, design systems, accessibility.
- A List Apart — https://alistapart.com/ — less frequent but influential essays; historical home of responsive design, content strategy, progressive enhancement.
- Smashing Books — https://www.smashingmagazine.com/books/ — printed, edited collections (e.g., Vitaly Friedman's *Smart Interface Design Patterns*).
- A Book Apart (sibling imprint) — https://abookapart.com/ — short, focused books (Marcotte's *Responsive Web Design*, Keith's *HTML5 for Web Designers*, Wroblewski's *Mobile First*).
- ALA archive, especially "Responsive Web Design" (Marcotte, 2010) — https://alistapart.com/article/responsive-web-design/ — the essay that named the field.

## Core principles (recurring patterns)
- **Progressive enhancement.** Ship the HTML-first baseline that works everywhere; layer CSS, then JS, then fancy behavior. ALA has argued this for 20+ years; it maps exactly to the HTMX + Jinja + Pico stack (server-rendered first, HTMX enhances).
- **Responsive / fluid by default.** Marcotte's original thesis — fluid grids, flexible images, media queries — still defines the baseline. Modern extensions: container queries, `clamp()`-based fluid type, intrinsic layouts.
- **Accessibility as craft.** Both publications treat accessibility as design quality, not a compliance checklist. Recurring authors: Sara Soueidan, Léonie Watson, Eric Bailey.
- **Content-out, not layout-in.** Design decisions follow from the content and user need; grids are scaffolding, not the starting point.
- **Systems thinking.** Design systems as living code (not Figma libraries); component APIs as UX decisions; governance and contribution as hard as visual design.
- **Critical of hype.** Both publications routinely publish considered counter-arguments (e.g., "Design systems aren't component libraries," critiques of AI-generated aesthetics, Modal-vs-Separate-Page UX decision trees).

## Concrete templates, checklists, or artifacts the agent can reuse
- **Fluid typography formula** — `font-size: clamp(1rem, 0.5rem + 2vw, 1.5rem);` — readable at both 360px and 1440px without media queries. Smashing has multiple articles on `clamp()` sizing and type scales.
- **Modal-vs-separate-page decision tree** (Smashing) — if the task is quick + disposable + requires current context → modal. If it is long-form, bookmarkable, or a distinct flow → separate page. If destructive → confirmation dialog, never a modal wizard.
- **Responsive design checklist** — fluid grid (percentages/fr/`clamp()`), flexible images (`max-width: 100%; height: auto;`), mobile-first media queries (`min-width`, not `max-width`), touch-target minimum 44px, test at 320px / 768px / 1024px / 1440px.
- **Skeleton loader pattern** (Smashing) — match the shape of the content, not a generic spinner; respect `prefers-reduced-motion` by disabling the shimmer.
- **Content-first prototyping rule** (ALA) — before layout, write the real content at its real length. Prototypes that assume 30-character titles break when real titles are 90 characters.
- **"Is this article still current?" filter** — both archives go back a long time; anything CSS-related before ~2020 may pre-date Grid/container-queries/`:has()`. Prefer articles from the last 3 years unless reading a named classic (Marcotte's RWD, Keith on progressive enhancement).

## Where they disagree with others
- **ALA's progressive-enhancement stance vs. SPA-first thinking.** A List Apart has long argued for server-rendered HTML as the base layer — which aligns perfectly with the SIA stack (Jinja-rendered, HTMX-enhanced) but sits slightly against heavy-client React SPAs. Use ALA's instinct on richezamor.com too: ship readable HTML first, enhance.
- **Smashing vs. Tailwind orthodoxy.** Smashing often publishes articles using raw CSS, vanilla JS, and semantic class names — not wrong, but different from Tailwind's utility-first. The Designer reads for the pattern/reasoning, not necessarily the exact class names.
- **Publications vs. first-hand sources.** Articles are curated interpretations; for canonical positions on accessibility (Pickering, Roselli), CSS (Comeau), or utilities (Wathan), go to the source. Publications are best for "has anyone solved X yet?" and cross-pollination.

## Pointers to source material
- https://www.smashingmagazine.com/ — daily articles; filter by category (CSS, UX, Accessibility, Design Systems).
- https://alistapart.com/ — archives; search for topic keywords.
- https://alistapart.com/article/responsive-web-design/ — Ethan Marcotte, the original RWD essay.
- https://abookapart.com/ — sibling book imprint; short focused reads.
- https://www.smashingmagazine.com/smart-interface-design-patterns/ — Vitaly Friedman's pattern collection.
- https://smashingconf.com/ — conference talks, often posted free on YouTube.
