---
name: Heydon Pickering + Adrian Roselli
role: designer
type: individual
researched: 2026-04-16
---

# Heydon Pickering + Adrian Roselli

## Why they matter to the Designer
Accessibility is not a post-hoc audit in this team — the Designer bakes it into the prototype, because UI Eng productionizes what they receive. Heydon Pickering's *Inclusive Components* is the best catalog of accessible interaction patterns with working code: every pattern is delivered as actual HTML/CSS/JS you can paste into a prototype. Adrian Roselli is the empirical conscience — he tests ARIA patterns across real screen-reader/browser pairs and publishes what actually works vs. what the spec claims. Together they give the Designer a pair of rules: (1) the pattern exists and works, here is Heydon's version; (2) before you ship, here is what Adrian has measured fails in JAWS+Chrome or VoiceOver+Safari. For both the Tailwind + React site and the HTMX + Jinja + Pico SIA app, their guidance is directly runnable.

## Signature works & primary sources
- *Inclusive Components* (Heydon Pickering) — https://inclusive-components.design/ — pattern library covering accordion, tabs, menu button, modal, cards, data tables, notifications, toggle button, tooltip/toggletip, content slider, theme switcher, todo list.
- *Inclusive Design Patterns* (Heydon Pickering, Smashing, 2016) — the book version; broader than *Inclusive Components*.
- adrianroselli.com — https://adrianroselli.com/ — 800+ posts, many on specific patterns, WCAG interpretation, and ARIA pitfalls.
- Adrian Roselli's ARIA posts — https://adrianroselli.com/tag/aria — e.g. "Under-Engineered Toggles," "Be Wary of ARIA Live Regions," "Don't Turn a Table into an ARIA Grid."
- WebAIM + W3C WAI-ARIA Authoring Practices — cross-reference, but prefer Heydon/Adrian when they conflict (WAI APG has shipped patterns that fail in real AT).

## Core principles (recurring patterns)
- **Use the right HTML element first.** `<button>` for buttons, `<a>` for navigation, `<input type="checkbox">` for toggles. Heydon/Adrian both: "no `<div>` with `role="button"` and JS — you will forget keyboard handling, focus styles, or disabled semantics."
- **ARIA is a last resort, not an enhancement.** "No ARIA is better than bad ARIA" (WAI). Adrian repeatedly shows ARIA patterns that actively harm screen-reader users (e.g., `role="grid"` on a data table, `aria-label` overriding visible text).
- **Visible focus is non-negotiable.** Every interactive element needs a `:focus-visible` style that passes 3:1 contrast against its background. Never `outline: none` without a replacement.
- **Keyboard parity.** Every action doable with a pointer must be doable with keyboard alone. Tab order matches reading order. `Esc` closes modals. Arrow keys for radio groups, menus, tabs.
- **Live regions sparingly.** `aria-live="polite"` for toasts; `aria-live="assertive"` almost never. Announce changes once; don't make live regions scream.
- **Inclusive, not just accessible.** Heydon's framing: designing for the widest variety of humans — low vision, motor impairment, cognitive load, temporary impairment, slow connection — not just a checklist of WCAG pass/fail.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Heydon's accessible accordion pattern** — `<button aria-expanded="true/false" aria-controls="panel-id">` + `<div id="panel-id" hidden>`; toggle `aria-expanded` and the `hidden` attribute; no `role="region"` needed. https://inclusive-components.design/collapsible-sections/
- **Heydon's accessible modal pattern** — `<dialog>` element where supported; trap focus inside; return focus to the opener on close; `Esc` closes; backdrop click closes (optional); `aria-modal="true"` + `aria-labelledby`. https://inclusive-components.design/dialog-modal/
- **Heydon's accessible tabs pattern** — `role="tablist"` + `role="tab"` with `aria-selected` + `role="tabpanel"` with `aria-labelledby`; arrow keys move tab focus; tabs are buttons, not links. https://inclusive-components.design/tabbed-interfaces/
- **Heydon's toggle-button pattern** — `<button aria-pressed="true/false">` with a visible state change beyond color; never a bare `<div>`. https://inclusive-components.design/toggle-button/
- **Adrian's under-engineered checklist** — prefer native over custom: `<details>`/`<summary>` over JS accordion; `<input type="checkbox">` over toggle div; `<select>` over combobox (unless you really need type-ahead search of thousands of options).
- **Focus-style recipe** — `:focus-visible { outline: 3px solid; outline-offset: 2px; }` with a color that contrasts 3:1 against the element's background *and* the page background. In Tailwind: `focus-visible:outline-3 focus-visible:outline-offset-2 focus-visible:outline-blue-600`.
- **Pre-handoff a11y checklist** — (1) every interactive element is the right HTML element; (2) every image has meaningful `alt` or `alt=""`; (3) form inputs have associated `<label>`; (4) focus is visible and order is logical; (5) color contrast passes 4.5:1 (text) / 3:1 (UI); (6) works with keyboard only; (7) works with 200% zoom; (8) tested once in VoiceOver or NVDA.

## Where they disagree with others
- **Pickering/Roselli vs. "just use divs."** Where some patterns (and some AI code suggestions) reach for `<div role="button">` with JS click handlers, both reject this categorically. Button semantics are free with `<button>`; rebuilding them is how bugs ship.
- **Pickering/Roselli vs. WAI-ARIA Authoring Practices Guide.** Adrian has demonstrated multiple APG patterns (e.g., the combobox, the grid) that fail in real AT. When in doubt: Adrian's tested code > the APG example.
- **Roselli vs. Comeau on motion.** Adrian pushes stricter defaults — assume reduced motion. Comeau embraces motion with `prefers-reduced-motion` as the escape hatch. The Designer's rule: default Adrian (stillness), opt in to Comeau (motion) only at moments of delight.
- **Pickering vs. aesthetic polish at the cost of semantics.** Heydon will sacrifice a visual flourish rather than use a wrong element. "Pretty but inaccessible" is a failure.

## Pointers to source material
- https://inclusive-components.design/ — the full pattern catalog (free online).
- *Inclusive Design Patterns* (Heydon Pickering, Smashing Magazine Books).
- https://adrianroselli.com/ — the archive; use the tag navigation.
- https://adrianroselli.com/2024/ and later — keep current with evolving AT behavior.
- https://www.w3.org/WAI/ARIA/apg/ — WAI-ARIA Authoring Practices (cross-reference, but defer to Adrian when they diverge).
- https://webaim.org/ — screen-reader survey data and WCAG interpretation.
