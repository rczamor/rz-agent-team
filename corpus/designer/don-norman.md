---
name: Don Norman
role: designer
type: individual
researched: 2026-04-16
---

# Don Norman

## Why they matter to the Designer
Norman is the load-bearing wall of interaction design. Every button, form, empty state, and error message in a `design-prototype/` directory — whether it is a Tailwind + React component on richezamor.com or a HTMX + Jinja + Pico template in SIA — answers Norman's questions: Can the user see what to do? Do they know it worked? Can they recover when they are wrong? Because the Designer writes HTML/CSS directly (not Figma mocks), Norman's vocabulary — affordances, signifiers, feedback, mapping, constraints — is the vocabulary of the actual attributes the Designer writes: `<button>` vs `<div>`, `aria-live`, `:hover`/`:focus-visible`, `disabled`, `inputmode`, the difference between an icon and a labelled icon. UI Eng productionizes prototypes, so the Norman-grade decisions about "what does this element promise the user" must already be baked into the prototype, not bolted on later.

## Signature works & primary sources
- *The Design of Everyday Things* (revised edition, 2013) — https://jnd.org/books/ — the canonical source for affordances, signifiers, feedback, mapping, and the seven stages of action.
- *Emotional Design* (2004) — visceral, behavioral, reflective levels; explains why a prototype that "works" can still feel wrong.
- *Living with Complexity* (2010) — argues that hiding complexity badly is worse than exposing it well; relevant to dense admin UIs in SIA.
- jnd.org essays — https://jnd.org/ — ongoing commentary on human-centered design, now "humanity-centered."
- NN/g articles (co-founder) — https://www.nngroup.com/articles/author/don-norman/ — heuristics written for practitioners.

## Core principles (recurring patterns)
- **Affordances vs. signifiers.** An affordance is what an element *can* do; a signifier is how the user *knows* it. A `<button>` with no visible border has an affordance but no signifier. The Designer's rule: every interactive element must render a visible signifier in its default state (not only on hover).
- **Feedback within 100ms.** Every action must produce immediate, perceivable feedback — a `:active` state, a loading spinner, an `aria-live` toast. Silence = the user clicks again = double-submit.
- **Mapping.** The spatial/logical relationship between control and effect. Toggle sitting next to the thing it toggles; destructive actions visually separated from confirmatory ones; form field order matching the mental model of the task.
- **Constraints over instructions.** A disabled submit button, an `<input type="email">`, a `maxlength`, a `<select>` with only valid options — all prevent errors better than helper text explaining the rules.
- **Error prevention > error recovery > error messages.** Design out the error first; if unavoidable, make recovery cheap (undo, autosave); only then write the error copy.
- **Discoverability.** Users should be able to figure out what to do without a tutorial. If the prototype needs a README for a user to complete a task, the prototype is wrong.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Norman 7-stage audit** — for any primary flow in the prototype, walk: Goal → Plan → Specify → Perform → Perceive → Interpret → Compare. Flag any stage the user cannot complete without guessing.
- **Affordance/signifier pass** — for every interactive element: (1) Is it the right HTML element? (2) Does its default state look clickable/editable/draggable? (3) Does `:hover`, `:focus-visible`, and `:active` each produce a distinct visual change?
- **Feedback matrix** — for every async action, specify: optimistic state, loading state, success state (toast/inline), error state (inline with recovery action), empty state.
- **Constraint checklist for forms** — correct `type` (email, tel, number, url), `inputmode`, `autocomplete`, `pattern`, `min`/`max`, `required`, `disabled` submit until valid. Pico CSS gives these for free when you use native inputs.
- **"Would a new user get stuck?" review** — before handoff, write the smallest user story that should work and dry-run it through the prototype in-browser, not in your head.

## Where they disagree with others
- **Norman vs. flat/minimalist trends.** Norman has repeatedly criticized flat design for stripping signifiers — ghost buttons, borderless inputs, and icon-only controls fail his affordance test. When Refactoring UI recommends subtle borders and Tailwind's defaults lean minimal, Norman's pressure is: err on the side of the visible signifier.
- **Norman vs. novelty interaction patterns.** Where Luke Wroblewski will sometimes propose a novel input (single-field credit cards, gesture controls), Norman biases toward conventional patterns users already know.
- **Norman vs. aesthetic-first design.** *Emotional Design* concedes beauty matters, but Norman's priority order is usable → understandable → pleasurable. Pretty prototypes that fail a usability task are failures.

## Pointers to source material
- https://jnd.org/ — Norman's site, essays, and book list.
- *The Design of Everyday Things*, revised edition (Basic Books, 2013).
- *Emotional Design* (Basic Books, 2004).
- https://www.nngroup.com/articles/author/don-norman/ — Nielsen Norman Group articles.
- https://www.interaction-design.org/literature/book/the-encyclopedia-of-human-computer-interaction-2nd-ed — Norman's chapter on affordances.
