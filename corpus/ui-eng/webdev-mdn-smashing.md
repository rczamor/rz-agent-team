---
name: web.dev + MDN + Smashing Magazine
role: ui-eng
type: publication
researched: 2026-04-16
---

# web.dev + MDN + Smashing Magazine

## Why they matter to the UI Eng
These are the three **platform-level references** every UI Eng should treat as canonical:
- **web.dev** (Google/Chrome team) — the authoritative source for Core Web Vitals, performance techniques, rendering patterns, and platform features that ship in Chromium. Runs the `Learn` tracks (Learn HTML, Learn CSS, Learn JS, Learn Performance, Learn Accessibility, Learn PWA).
- **MDN Web Docs** (Mozilla + community) — the neutral, cross-browser reference for every HTML element, CSS property, JS API, and browser compat matrix. When in doubt about *what a property actually does across browsers*, MDN is the answer.
- **Smashing Magazine** — long-form practitioner writing that goes deeper than a blog post and broader than a spec — accessibility case studies, CSS feature deep-dives, design-system essays, and interview content.

Whenever UI Eng is productionizing a Designer prototype and hits "does this CSS property do what I think it does on Safari?" or "what's the a11y contract of `aria-live`?" or "is `<dialog>` production-ready yet?" — this trio is where the answer comes from. Unlike personality-driven blogs, these sources are *durable*: the URLs don't rot, and the content is corrected as browsers evolve.

## Signature works & primary sources
- **Learn Accessibility (web.dev)** — https://web.dev/learn/accessibility — structured progression through WCAG-relevant patterns, ARIA, keyboard interaction.
- **Learn Performance (web.dev)** — https://web.dev/learn/performance — Core Web Vitals, metrics, and the practices that improve them.
- **Learn CSS (web.dev)** — https://web.dev/learn/css — the 34-module modern CSS curriculum (box model, selectors, color, layout, animation, accessibility).
- **Core Web Vitals article** — https://web.dev/articles/vitals — the normative thresholds (LCP ≤ 2.5s, INP ≤ 200ms, CLS ≤ 0.1 at p75).
- **MDN HTML / CSS / JS references** — https://developer.mozilla.org — every element/property/API with spec links and browser-compat tables.
- **MDN ARIA reference** — https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA — role/state/property definitions; use this, not folklore.
- **Smashing Magazine CSS & Accessibility archives** — https://www.smashingmagazine.com/category/css, /category/accessibility — deep-dive articles on modern techniques.
- **Smashing Books** — *Image Optimization* (Osmani), *Inclusive Components* (Pickering), *Accessible UX Patterns*.

## Core principles (recurring patterns)
- **Cite the platform, not the trend.** MDN and web.dev outlive frameworks; a link to an MDN page will still be correct in 5 years.
- **Check browser compat on MDN before shipping a new CSS/JS feature.** "BCD tables" at the bottom of every MDN page tell you Safari/Chrome/Firefox support.
- **Use semantic HTML first; reach for ARIA only when the platform doesn't have the element.** ARIA's first rule: *don't use ARIA if a native element would work*.
- **Follow WCAG 2.1 AA as the baseline, WCAG 2.2 for new work.** Contrast ≥ 4.5:1 for body text; focus visible; keyboard navigable; no keyboard trap; labels on inputs.
- **Progressive enhancement is the posture.** Content → semantic HTML → CSS enhancement → JS enhancement. Each layer must not break the layer below.
- **Measurement over anecdote.** web.dev's framing: performance and a11y are both *measurable* and must be measured.

## Concrete templates, checklists, or artifacts the agent can reuse
**a11y component checklist (run on every component before merging a Designer prototype to prod):**
1. Native element where possible (`<button>`, not `<div onClick>`; `<a>` for navigation, `<button>` for actions).
2. Every form control has an associated `<label>` (either `for`/`id` or wrapping).
3. Keyboard: Tab reaches it, Enter/Space activate it, Escape closes modals, arrow keys within composite widgets.
4. Focus is visible (`:focus-visible` ring, ≥ 2px, contrast ≥ 3:1).
5. `alt` on every `<img>` (empty `alt=""` for decorative).
6. Color contrast ≥ 4.5:1 for text, 3:1 for large text and UI components.
7. ARIA only where native HTML doesn't express the semantics (`role="tablist"`, `aria-live="polite"`, `aria-expanded`).
8. Respect `prefers-reduced-motion` and `prefers-color-scheme`.
9. Test with keyboard only, then VoiceOver (macOS Cmd+F5) or NVDA.
10. Automated pass: `axe-core` / `@axe-core/react` / Lighthouse accessibility score.

**Responsive image snippet (platform, framework-agnostic):**
```html
<img
  src="/img-800.webp"
  srcset="/img-400.webp 400w, /img-800.webp 800w, /img-1600.webp 1600w"
  sizes="(max-width: 600px) 100vw, 800px"
  width="800" height="450"
  alt="..."
  loading="lazy"
  decoding="async"
/>
```

**Accessible modal pattern (native `<dialog>` — now baseline-supported):**
```html
<button type="button" onclick="dlg.showModal()">Open</button>
<dialog id="dlg" aria-labelledby="dlg-title">
  <h2 id="dlg-title">Confirm delete</h2>
  <form method="dialog">
    <button value="cancel">Cancel</button>
    <button value="ok">Delete</button>
  </form>
</dialog>
```

**Before-you-ship reference lookups:** for any CSS property → MDN browser-compat table; for any metric → web.dev/articles/vitals; for any ARIA role → MDN ARIA reference; for any pattern deep-dive → Smashing archives.

## Where they disagree with others
- **web.dev (Chrome-leaning) vs. MDN (neutral):** web.dev may promote a Chromium feature before Safari ships it; MDN will flag the compat gap. When they disagree, trust MDN for cross-browser decisions.
- **Smashing (practitioner, opinionated) vs. web.dev/MDN (reference, neutral):** Smashing articles are deeper but may reflect one author's workflow. Good for ideas, not for spec truth.
- **Platform-native patterns vs. framework-imported patterns:** these publications increasingly push *use the platform* (native `<dialog>`, `popover` attribute, `:has()`, CSS nesting) — often at odds with "install a library" culture.

## Pointers to source material
- https://web.dev — learn paths, articles, Core Web Vitals.
- https://developer.mozilla.org — references, compat tables, ARIA.
- https://www.smashingmagazine.com — articles, books, newsletters.
- Smashing Books: https://www.smashingmagazine.com/printed-books/
- a11y-specific: https://www.a11yproject.com (community sibling to this trio).
