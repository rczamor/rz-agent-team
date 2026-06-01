---
name: Adam Wathan / Tailwind Labs
role: designer
type: individual
researched: 2026-04-16
---

# Adam Wathan / Tailwind Labs

## Why they matter to the Designer
Tailwind is the design system for richezamor.com. Every prototype for that stack is literally a sequence of Tailwind utility classes on JSX elements, so the Designer must think in Tailwind's design-token vocabulary (`text-lg`, `bg-slate-900`, `p-6`, `rounded-xl`, `shadow-md`) rather than in Figma layers. Adam Wathan's thinking — utility-first CSS, sensible design-system defaults, the "extract a component when the pattern repeats" discipline — defines how the Designer works day-to-day. *Refactoring UI* (with Steve Schoger) is the complementary half: the visual-design taste that keeps utility-heavy markup from devolving into arbitrary spacing and colors. Handoff to UI Eng is nearly zero-friction because the prototype and production share the same class vocabulary.

## Signature works & primary sources
- Tailwind CSS docs — https://tailwindcss.com/docs — the canonical reference; read the "Core Concepts" section cover to cover.
- *Refactoring UI* (2018, with Steve Schoger) — https://www.refactoringui.com/ — applied visual design for developers; the other half of design-in-code craft.
- Tailwind UI / Catalyst — https://tailwindui.com/ — official component patterns demonstrating idiomatic Tailwind.
- Adam Wathan's blog — https://adamwathan.me/ — especially "CSS Utility Classes and 'Separation of Concerns'" (the utility-first manifesto).
- Headless UI — https://headlessui.com/ — unstyled accessible primitives; what you compose with when you need behavior beyond raw HTML.

## Core principles (recurring patterns)
- **Utility-first, not inline styles.** Utilities pull from a constrained design system (spacing scale, color palette, type scale), which inline styles do not. Utilities support states (`hover:`, `focus-visible:`, `disabled:`) and breakpoints (`sm:`, `md:`, `lg:`). Inline styles do neither.
- **Design constraints win.** The Tailwind default scale (`0, 1, 2, 4, 8, 16...`) prevents arbitrary 13px margins. Never reach for arbitrary values (`w-[437px]`) unless you have exhausted the scale.
- **Mobile-first breakpoints.** Unprefixed utilities = mobile. `md:` and up = progressive enhancement. (Aligns directly with Luke Wroblewski's Mobile First.)
- **Extract components when the pattern repeats, not before.** Duplicate first; notice the repetition; extract a React component or Jinja macro. Premature abstraction creates brittle APIs.
- **Refactoring UI "big ideas" — hierarchy, whitespace, color.** Not every element deserves equal weight; whitespace is a design tool (start generous); color systems are deliberate (plan 9 shades per hue, not 3).
- **Start with black-and-white, then layer color.** Forces real hierarchy from type weight, size, and spacing before color can mask weak structure.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Refactoring UI "big ideas" checklist** — (1) establish hierarchy with size/weight/color, not just color; (2) use generous whitespace, tighten later; (3) don't use grey text on colored backgrounds; (4) use color to reinforce hierarchy; (5) design with real content, never lorem ipsum; (6) build the mobile layout first; (7) use shadows to communicate elevation; (8) don't rely on borders alone for structure.
- **Tailwind component template (React)** — functional component taking `children` and variant props (`variant`, `size`); compose class list with `clsx`/`cva`; expose `className` for override; ship stateful variants (`:hover`, `:focus-visible`, `:disabled`, `aria-expanded`).
- **Design-token audit** — before writing `w-[437px]` or `#3a7bd5`, check if an existing scale value works. If it doesn't, extend `tailwind.config.ts` (don't sprinkle arbitrary values).
- **"Mobile defaults, desktop adds" rule** — write the base classes for 360px viewport; add `md:` and `lg:` only to upgrade. Never write `md:hidden` on the mobile layout.
- **Stateful-variant checklist for every interactive element** — `hover:`, `focus-visible:`, `active:`, `disabled:`, `aria-expanded:`, `aria-selected:`. Missing `focus-visible` is the most common accessibility regression in utility-first code.

## Where they disagree with others
- **Wathan vs. Frost on abstraction timing.** Frost's atomic model suggests you name components early; Wathan says duplicate utilities until the pattern is proven, then extract. The Designer resolves this by letting the file structure be atomic (Frost) while keeping class composition utility-first inside each component (Wathan).
- **Wathan vs. traditional CSS / BEM.** Semantic class names (`.btn-primary`, `.card__title`) are explicitly rejected — Wathan argues they create a second coupling between markup and CSS that slows change. Not a concern for the SIA stack, which uses Pico's default semantic CSS.
- **Wathan vs. Comeau on CSS-in-JS / bespoke CSS.** Josh Comeau teaches raw modern CSS and styled-components; Tailwind's position is that utilities solve 95% of cases and raw CSS is an escape hatch. Both are valid for the richezamor.com stack; the Designer should lean Tailwind-first and drop to raw CSS only for complex animations or container queries Tailwind cannot express ergonomically.

## Pointers to source material
- https://tailwindcss.com/docs — read "Utility-First Fundamentals," "Handling Hover/Focus," "Responsive Design," "Dark Mode," "Customizing."
- *Refactoring UI* (Adam Wathan & Steve Schoger, 2018) — https://www.refactoringui.com/book.
- https://adamwathan.me/css-utility-classes-and-separation-of-concerns/ — the foundational essay.
- https://tailwindui.com/ — Tailwind UI patterns for idiomatic composition.
- https://headlessui.com/ — accessible primitives for behavior Tailwind alone cannot provide (modals, menus, tabs).
