---
name: Josh Comeau
role: designer
type: individual
researched: 2026-04-16
---

# Josh Comeau

## Why they matter to the Designer
Josh Comeau is the modern practitioner who best explains *why* CSS behaves the way it does — stacking contexts, flexbox min-content, percentage heights, easing functions, `transform` vs. `top/left` for animation. For a Designer who writes prototypes in code, this is not optional trivia: it is the difference between a prototype that "almost works but jumps weirdly when the sidebar opens" and one that feels production-grade. Comeau's interactive blog posts and *CSS for JS Developers* course give the Designer the vocabulary to reason about layout bugs, build delightful micro-interactions that UI Eng can productionize as-is, and make Tailwind's utility output actually behave. For richezamor.com, his animation and layout articles are nearly one-to-one applicable.

## Signature works & primary sources
- joshwcomeau.com blog — https://www.joshwcomeau.com/ — interactive, deeply explained articles. Start with "An Interactive Guide to Flexbox" and "An Interactive Guide to CSS Grid."
- *CSS for JS Developers* — https://css-for-js.dev/ — paid course; the most comprehensive modern CSS curriculum.
- *The Joy of React* — https://www.joyofreact.com/ — React fundamentals with the same teaching style.
- "A Modern CSS Reset" — https://www.joshwcomeau.com/css/custom-css-reset/ — the reset many teams (and Tailwind's Preflight) borrow from.
- "Designing Beautiful Shadows in CSS" — https://www.joshwcomeau.com/css/designing-shadows/ — layered shadows that match a consistent light source.

## Core principles (recurring patterns)
- **Understand the mechanism, not just the recipe.** Know *why* `height: 100%` needs a parent height, *why* flex items shrink below their content by default (`min-width: auto`), *why* `transform` animations are cheap and `top/left` are expensive. Recipes break; mechanisms compose.
- **Physics-based motion.** Animations should feel like they obey mass and friction. Springs > linear easings for most micro-interactions. Use `cubic-bezier` curves that have overshoot for playful moments, ease-out for arrivals, ease-in for exits.
- **Layered, realistic shadows.** One soft + one crisp shadow, both respecting a consistent light source, beats a single `box-shadow: 0 4px 6px rgba(0,0,0,0.1)`.
- **Reduce motion, respect users.** Always wrap non-decorative animation in `@media (prefers-reduced-motion: no-preference)` or the Tailwind `motion-safe:` variant.
- **Stacking context is a feature, not a bug.** `z-index` wars come from misunderstanding stacking contexts. Create new ones deliberately (`isolation: isolate`) to contain `z-index` inside components.
- **Flexbox for 1D, Grid for 2D; Subgrid for alignment across parent boundaries.** Pick the right tool; don't nest flex inside flex when grid is cleaner.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Josh's CSS reset** — drop https://www.joshwcomeau.com/css/custom-css-reset/ into every prototype that isn't already using Tailwind's Preflight. It sets `box-sizing: border-box`, removes default margin, improves text rendering, makes images responsive.
- **Shadow scale** — define three elevation tiers in `tailwind.config.ts` (`shadow-sm`, `shadow-md`, `shadow-lg`), each a layered pair (ambient + key). Use consistently across cards, modals, dropdowns.
- **Animation timing guide** — micro-interactions 150–250ms ease-out; larger transitions 300–400ms spring; page-level transitions 400–600ms; never animate `top`/`left`/`width`/`height` — use `transform` and `opacity`.
- **`prefers-reduced-motion` template** — wrap any non-decorative animation: `@media (prefers-reduced-motion: reduce) { * { animation-duration: 0.01ms !important; transition-duration: 0.01ms !important; } }` at the reset level, plus `motion-safe:` prefixes on delight animations.
- **Focus-visible style recipe** — `:focus-visible` with a 2–3px offset ring (`outline: 2px solid`; `outline-offset: 2px`) rather than the browser default outline inside the element. In Tailwind: `focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-500`.
- **Layout debug template** — when a layout misbehaves, add `outline: 1px solid red` to the suspect element and its ancestors; nine times out of ten the bug is a parent without a defined height, or a flex container with an unexpected `min-width: auto`.

## Where they disagree with others
- **Comeau vs. Tailwind purists.** Comeau teaches raw CSS as the primary skill; Tailwind advocates lean on utilities first. Both can coexist: Comeau's knowledge explains *what* Tailwind utilities compile to, which makes debugging trivial.
- **Comeau vs. minimalism dogma.** Comeau's aesthetic leans toward tasteful delight — spring animations, rich shadows, subtle gradients — where flat-design maximalists would strip all of it. The Designer's rule: delight in moments of reward (submit success, state change), restraint in default chrome.
- **Comeau vs. "animations are accessibility risk, skip them."** Comeau argues motion is a legitimate design tool *provided* you respect `prefers-reduced-motion`. Adrian Roselli / Heydon Pickering are stricter — when in doubt, default to stillness.

## Pointers to source material
- https://www.joshwcomeau.com/ — blog, especially tagged "CSS," "animation," "react."
- https://css-for-js.dev/ — *CSS for JS Developers* course.
- https://www.joshwcomeau.com/css/custom-css-reset/ — the reset.
- https://www.joshwcomeau.com/css/designing-shadows/ — shadows.
- https://www.joshwcomeau.com/animation/easing/ — easing primer.
- https://www.joshwcomeau.com/css/interactive-guide-to-flexbox/ — flexbox deep dive.
