---
name: Josh Comeau
role: ui-eng
type: individual
researched: 2026-04-16
---

# Josh Comeau

## Why they matter to the UI Eng
Josh Comeau also appears in the Designer corpus — **here the focus is productionization**: taking a Designer prototype and shipping CSS and interactions that are fast, accessible, reduced-motion-aware, and maintainable. Comeau writes the clearest production-grade CSS on the internet: his Modern CSS Reset is a drop-in starting point, his articles on `linear()` timing, subgrid, `text-wrap: pretty/balance`, and CSS custom properties map directly to features UI Eng actually ships. Unlike decorative CSS writing, Comeau's articles always include: (1) the browser-compatibility caveat, (2) the reduced-motion branch, (3) the performance cost, and (4) the React-specific integration pattern. That combination is exactly what productionizing requires.

## Signature works & primary sources
- *A Modern CSS Reset* — https://www.joshwcomeau.com/css/custom-css-reset — the starting point for every new project; replaces Eric Meyer's reset and Normalize.
- *CSS Variables for React Devs* — https://www.joshwcomeau.com/css/css-variables-for-react-devs — how to plumb runtime values from React state into CSS.
- *An Interactive Guide to CSS Transitions* — https://www.joshwcomeau.com/animation/css-transitions — foundational animation reference with interactive demos.
- *Springs and Bounces in Native CSS* — https://www.joshwcomeau.com/animation/linear-timing-function — using `linear()` for physics motion without JS libraries.
- *Squash and Stretch* — https://www.joshwcomeau.com/animation/squash-and-stretch — Disney animation principles applied to SVG micro-interactions.
- *Why React Re-Renders* — https://www.joshwcomeau.com/react/why-react-re-renders — practical re-render mental model.
- *Designing Beautiful Shadows in CSS* — https://www.joshwcomeau.com/css/designing-shadows — layered shadows that don't look cheap.
- *The Height Enigma* — https://www.joshwcomeau.com/css/height-enigma — why `height: 100%` fails and what to do about it.
- *Brand New Layouts with CSS Subgrid* — https://www.joshwcomeau.com/css/subgrid — production subgrid patterns.
- *The Joy of React* / CSS for JS Devs — https://www.joyofreact.com, https://css-for-js.dev — the courses.

## Core principles (recurring patterns)
- **Always ship a reset.** Browser defaults are hostile to design systems; start from a known baseline.
- **Respect `prefers-reduced-motion`.** Every animation has a branch that either disables or drastically reduces it for users who've asked.
- **Use CSS custom properties as the bridge between React state and CSS.** Inline `style={{ '--x': x }}` is cheaper than re-computing styled-component variants and re-orders the re-render cost.
- **Pick the right layout primitive.** Flexbox for 1D, Grid for 2D, Subgrid when children need to align to the parent's tracks. Don't force one to do the other's job.
- **Design tokens > magic numbers.** Spacing, color, shadow, radius, and motion should all be variables; one-off values are debt.
- **Animation timing communicates meaning.** Easing, duration, and physics (`linear()` with spring curves) should map to the interaction's feel — not be default `ease-in-out 300ms`.
- **CLS is a CSS concern.** Explicit `width`/`height`/`aspect-ratio` on media is non-negotiable.

## Concrete templates, checklists, or artifacts the agent can reuse
**Josh's modern CSS reset (drop in at the top of global CSS — the SIA and Next.js projects should both start here):**
```css
*, *::before, *::after { box-sizing: border-box; }
* { margin: 0; }
html, body { height: 100%; }
body { line-height: 1.5; -webkit-font-smoothing: antialiased; }
img, picture, video, canvas, svg { display: block; max-width: 100%; }
input, button, textarea, select { font: inherit; }
p, h1, h2, h3, h4, h5, h6 { overflow-wrap: break-word; }
p { text-wrap: pretty; }
h1, h2, h3, h4, h5, h6 { text-wrap: balance; }
#root, #__next { isolation: isolate; }
```

**React + CSS custom property pattern (pass runtime values to CSS without re-rendering style objects):**
```tsx
function Tilt({ rotation }: { rotation: number }) {
  return (
    <div
      className="tilt"
      style={{ '--rotation': `${rotation}deg` } as React.CSSProperties}
    />
  )
}
```
```css
.tilt { transform: rotate(var(--rotation)); transition: transform 200ms ease-out; }
@media (prefers-reduced-motion: reduce) { .tilt { transition: none; } }
```

**Reduced-motion wrapper:**
```css
@media (prefers-reduced-motion: no-preference) {
  .animated { animation: slide-in 400ms linear(/* spring */); }
}
```

**Animation productionization checklist:** every animation in a Designer prototype must have: (1) a `prefers-reduced-motion` fallback, (2) an explicit duration + easing token, (3) `will-change` only if profiled, never as a default, (4) no layout-triggering properties (`width`, `top`, `left`) — transform/opacity only, (5) pauses if the element leaves the viewport.

## Where they disagree with others
- **Comeau vs. Tailwind-first dogma:** he's pro-Tailwind but emphasizes that CSS *understanding* is what produces quality — Tailwind is a productivity layer, not a substitute for learning the cascade and the box model.
- **Comeau vs. "CSS-in-JS everywhere":** prefers vanilla CSS + CSS custom properties for runtime values over styled-components/emotion runtime cost.
- **Comeau vs. Comeau-the-designer:** in this corpus he is referenced for production, not design — the Designer corpus covers his taste and aesthetic framing separately.

## Pointers to source material
- Blog: https://www.joshwcomeau.com
- CSS for JS Devs: https://css-for-js.dev
- The Joy of React: https://www.joyofreact.com
- Newsletter: subscribe via joshwcomeau.com
