---
name: Addy Osmani
role: ui-eng
type: individual
researched: 2026-04-16
---

# Addy Osmani

## Why they matter to the UI Eng
Addy Osmani spent ~14 years on the Chrome team leading developer experience around DevTools, Lighthouse, and Core Web Vitals. He is the authoritative voice on **web performance as a measurable, user-facing concern** — LCP, INP, CLS, TTFB, image optimization, and rendering patterns (SSR, SSG, ISR, islands, streaming). For a UI Eng productionizing prototypes, Osmani's work is the standard against which richezamor.com and SIA's performance are measured. His books — *Image Optimization*, *Learning Patterns*, *Learning JavaScript Design Patterns (2nd)* — and his web.dev articles provide both the metrics-level targets ("LCP under 2.5s at p75") and the implementation-level patterns (responsive images, priority hints, fetchpriority, lazy loading, preload critical CSS).

## Signature works & primary sources
- *Image Optimization* (Smashing Magazine book) — https://images.guide — the reference on image formats, responsive images, LCP image strategy.
- *Learning Patterns* — https://www.patterns.dev — co-authored with Lydia Hallie; rendering patterns, design patterns, performance patterns.
- *Learning JavaScript Design Patterns, 2nd Edition* — https://www.patterns.dev/vanilla/js-design-patterns — canonical patterns reference (singleton, factory, observer, module) applied to modern JS/React.
- web.dev articles on Core Web Vitals — https://web.dev/articles/vitals — the normative thresholds.
- Blog — https://addyosmani.com — essays on performance, rendering, and recently on AI-assisted engineering.
- *The 100% correct way to optimize images* — images.guide patterns translated into ready-to-use snippets.

## Core principles (recurring patterns)
- **Measure first, optimize second.** Lighthouse and field data (CrUX) tell you what to fix; hunches don't.
- **LCP is usually an image problem.** The largest contentful paint element on 70% of pages is an image — optimize *that* image before anything else.
- **INP replaced FID in 2024.** Target < 200ms at p75. Long tasks on the main thread are the enemy; break them up with `scheduler.yield()`, `isInputPending`, or Web Workers.
- **CLS is a CSS/markup problem, not a runtime problem.** Reserve space for every async element — dimensions on images, min-height on ad slots, skeleton heights matching content.
- **Ship less JavaScript.** The cheapest optimization is the code you don't send. Code-split, tree-shake, and prefer platform (HTML/CSS) over JS when possible.
- **Rendering pattern should match the content pattern.** Marketing pages → SSG. News → ISR / PPR. Personalized → SSR. Dashboards → CSR with Suspense streaming. Mixed → islands.

## Concrete templates, checklists, or artifacts the agent can reuse
**Core Web Vitals performance budget (attach to every project as a non-negotiable):**
| Metric | Good (p75) | Poor (p75) |
|---|---|---|
| LCP | ≤ 2.5s | > 4.0s |
| INP | ≤ 200ms | > 500ms |
| CLS | ≤ 0.1 | > 0.25 |
| TTFB | ≤ 0.8s | > 1.8s |

**Production image component pattern (Next.js):**
```tsx
import Image from 'next/image'

<Image
  src="/hero.jpg"
  alt="Descriptive alt, not decorative"
  width={1200}
  height={630}
  priority          // only on above-the-fold LCP image
  fetchPriority="high"
  sizes="(max-width: 768px) 100vw, 1200px"
/>
```

**Production image pattern (SIA / plain HTML — no framework):**
```html
<img
  src="/hero-800.webp"
  srcset="/hero-400.webp 400w, /hero-800.webp 800w, /hero-1600.webp 1600w"
  sizes="(max-width: 768px) 100vw, 800px"
  width="800" height="420"
  alt="..."
  fetchpriority="high"  <!-- or loading="lazy" for below-the-fold -->
  decoding="async"
/>
```

**INP hot-fix checklist (when p75 INP is red):**
1. Find the slow interaction in DevTools Performance panel.
2. Break any >50ms task with `await scheduler.yield()` or `setTimeout(0)`.
3. Defer non-critical work (analytics, 3rd-party scripts) with `requestIdleCallback`.
4. Move heavy compute (markdown, sync, filtering thousands of rows) to a Web Worker.
5. Virtualize long lists (`react-virtuoso`, `tanstack-virtual`).

**Rendering pattern decision table:**
- Fully static, same for everyone → SSG (`next build`).
- Mostly static, some freshness → ISR (`revalidate: 3600`) or PPR.
- User-specific → SSR (Server Component with `cookies()` / dynamic functions).
- Interactive shell, data over time → Client + Suspense streaming.
- Email → zero JS, inline CSS.

## Where they disagree with others
- **Osmani vs. "just use Next.js defaults":** he'd push back that defaults are a starting line, not a finish; you still owe the team measurement and a budget.
- **Osmani vs. performance-as-aesthetic:** he insists on *field data* (CrUX, RUM) over lab data (Lighthouse alone). A page can be 100 in Lighthouse and red in CrUX.
- **Osmani vs. framework-performance-is-solved-ism:** his recent writing (*Web Performance in the Age of AI*, *Beyond Vibe Coding*) warns that AI-generated code frequently regresses performance unless budgets are enforced in CI.

## Pointers to source material
- Blog: https://addyosmani.com
- Patterns.dev: https://www.patterns.dev
- Image Optimization: https://images.guide
- web.dev: https://web.dev (many articles co-authored or reviewed)
- Books on Amazon: *Learning JavaScript Design Patterns (2nd)*, *Image Optimization*, *Learning Patterns*.
