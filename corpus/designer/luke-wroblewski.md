---
name: Luke Wroblewski
role: designer
type: individual
researched: 2026-04-16
---

# Luke Wroblewski

## Why they matter to the Designer
Forms are where most real product value is transacted — sign-ups, purchases, settings, data entry — and LukeW has spent two decades writing the definitive practical literature on them. For the Designer who writes prototypes in HTML/CSS, Luke's work is directly executable: every recommendation is a concrete attribute (`inputmode="numeric"`, `autocomplete="one-time-code"`), a layout decision (label-above vs. label-inside), or a progressive-disclosure pattern (stepped forms, accordion sections). The SIA stack (HTMX + Jinja + Pico CSS) is particularly form-heavy, and Luke's "Mobile First" thesis forces the Designer to prototype at the narrow viewport before desktop — the discipline that surfaces bad hierarchy and bloated fields. Handoff to UI Eng is cleaner because Luke's patterns are already the production patterns.

## Signature works & primary sources
- *Web Form Design: Filling in the Blanks* (Rosenfeld, 2008) — https://rosenfeldmedia.com/books/web-form-design/ — the reference text on every form decision from label placement to error recovery.
- *Mobile First* (A Book Apart, 2011) — https://abookapart.com/products/mobile-first — the book that reframed responsive design as a constraint-driven prioritization exercise.
- LukeW blog — https://www.lukew.com/ff/ — 20+ years of annotated articles, often with eye-tracking and conversion data.
- LukeW "Input Masks" and "Drop-down Usability" posts — https://www.lukew.com/ff/entry.asp?1950 and similar — original research on input patterns still cited today.

## Core principles (recurring patterns)
- **Mobile first, content first.** Design the narrow viewport first; whatever survives is the real priority. What you can't fit is probably not critical.
- **Top-aligned labels beat inline/left-aligned labels.** Faster completion, better scan, better for i18n and long label text. (Web Form Design, Chapter 4.)
- **Match input type to data.** `type="email"`, `type="tel"`, `type="number"`, `inputmode="decimal"`, `autocomplete` tokens — the mobile keyboard and browser autofill do huge work for free.
- **One thing per screen / step.** Long forms become sequential single-question screens on mobile; desktop can collapse them into sections.
- **Obvious always wins.** Conventional patterns out-convert clever ones. Standard login forms, standard cart flows, standard error placement.
- **Reduce required fields aggressively.** Every field is friction. "Required unless provably necessary" is the default stance.

## Concrete templates, checklists, or artifacts the agent can reuse
- **LukeW form-design checklist** — for every form in a prototype: labels above fields; correct `type`/`inputmode`/`autocomplete`; inline validation on blur (not on every keystroke); submit disabled until valid; errors shown inline next to the field in red with an icon; success state clearly communicated; no "clear form" button next to "submit."
- **Mobile-first viewport order** — prototype at 360px, then 768px, then 1024px+. The Tailwind default breakpoint order (`sm:`, `md:`, `lg:`) is literally this. Don't write desktop classes first.
- **Field-reduction pass** — list every field in a form, annotate each: required-or-optional, can-we-infer-it, can-we-ask-later, can-we-split-across-steps. Kill or defer every non-essential field.
- **Touch target template** — minimum 44x44px tap targets (Tailwind: `min-h-11 min-w-11` or `p-3` on the button). Adjacent targets need gap (`gap-2` minimum).
- **Password/OTP pattern** — password visibility toggle (`<button type="button">Show</button>`), `autocomplete="one-time-code"` for OTP fields, `autocomplete="new-password"` vs `"current-password"` on signup vs. login.

## Where they disagree with others
- **Luke vs. Norman on novelty.** Luke will champion novel-but-tested patterns (single-field credit cards, numeric steppers, gesture shortcuts) where Norman favors pure convention. Designer rule: only adopt Luke's novel patterns if richezamor.com/SIA has a mobile-heavy context where the gain is measurable.
- **Luke vs. ornamental minimalism.** Luke's forms are utilitarian — functional affordances over aesthetic restraint. Conflicts with Refactoring UI's preference for visual polish at the cost of input density.
- **Luke vs. "desktop first because that's what I'm coding on."** Luke is uncompromising: start mobile. Many developers (and AI code suggestions) default to desktop layouts and retrofit responsive classes, which is the opposite of what Luke teaches.

## Pointers to source material
- https://www.lukew.com/ff/ — the blog; search by tag for "forms," "mobile," "input."
- *Web Form Design: Filling in the Blanks* (2008).
- *Mobile First* (2011).
- https://www.lukew.com/ff/entry.asp?1950 — "Web Form Design Best Practices" summary post.
- https://rosenfeldmedia.com/books/web-form-design/ — publisher page with sample chapters.
