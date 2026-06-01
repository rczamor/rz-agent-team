---
name: Ministry of Testing
role: qa-eng
type: community
researched: 2026-04-16
---

# Ministry of Testing

## Why they matter to the QA Eng
Ministry of Testing (MoT) is the largest global community for software testers — hundreds of thousands of members, the TestBash conference series, the Dojo learning platform, and The Club forum. Where Beck, Dodds, and the pytest/Playwright teams come from a developer-writes-tests worldview, MoT is the voice of **testing as its own discipline** — exploratory testing, heuristics, risk-based test strategy, investigative skills, and the human side of QA. For a single-QA team shipping AI features, this is the corpus to lean on for the questions that automated test suites don't answer: "what should we even be testing?", "what could go wrong that no ticket mentions?", "how do we communicate quality risk to the team?". MoT's heuristics cheat sheets and the *Modern Testing Principles* are immediately usable artifacts.

## Signature works & primary sources
- ministryoftesting.com — community, articles, Dojo courses, events.
- **Modern Testing Principles** (Alan Page & Brent Jensen) — https://www.moderntesting.org/ — 7 principles, widely republished by MoT.
- **Test Heuristics Cheat Sheet** — https://www.ministryoftesting.com/articles/test-heuristics-cheat-sheet — one-page compendium (SFDIPOT, FEW HICCUPPS, etc.).
- **TestBash** conferences — recorded talks at https://www.ministryoftesting.com/testbash-sessions
- **The Club** — https://club.ministryoftesting.com/ — Q&A forum.
- The Dojo — structured courses including *99 Second Talks* and Whole Team Approach material.

## Core principles (recurring patterns)
- **Heuristics over best practices.** "Best practice" is context-blind. Heuristics (SFDIPOT, FEW HICCUPPS, CRUSSPIC STMPL) are prompts that surface risks specific to *this* product.
- **Modern Testing Principles (Page & Jensen):**
  1. Accelerate the achievement of shippable quality.
  2. Enable the team through coaching, not gatekeeping.
  3. Advocate for the customer; own quality as a team.
  4. Obsess over the customer's actual experience.
  5. Focus on continual improvement over process compliance.
  6. Build models for understanding our product, users, and data.
  7. Use data to drive where attention goes.
- **Exploratory testing is a first-class activity.** Charter-based sessions (James Bach's Session-Based Test Management) are not "ad-hoc clicking around" — they are structured, time-boxed, and recorded.
- **Test is an activity, not a phase.** Whole-team approach: everyone tests; the QA Eng amplifies capacity, doesn't own a gate.
- **Risk-based prioritization.** You cannot test everything. Name the risks, map them to coverage, leave the rest as explicit known gaps.

## Concrete templates, checklists, or artifacts the agent can reuse
- **SFDIPOT heuristic** (James Bach; MoT popularizes) for test coverage brainstorming: **S**tructure, **F**unction, **D**ata, **I**nterfaces, **P**latform, **O**perations, **T**ime — walk each axis and ask "what could go wrong here?". Use on every new feature before writing a test plan.
- **FEW HICCUPPS** (Michael Bolton, via MoT) oracle heuristic: Familiar, Explainable, World, History, Image, Claims, Comparable products, User expectations, Product (self-consistency), Purpose, Standards. Use when asking "how do I know this output is correct?" — especially useful for LLM features where the "expected" answer is fuzzy.
- **Session-based exploratory test charter template:** `Explore [target] with [resources] to discover [information]` — 60–90 min, screen-recorded, produces a debrief note with bugs, questions, and new test ideas.
- **Risk-register-to-test-coverage mapping:** two-column doc — each named risk (e.g. "hallucinated citation") maps to (a) automated check if possible, (b) exploratory charter if not, (c) known-gap if neither.
- **Bug advocacy format (MoT-recommended):** What happened / Why it matters / How to reproduce / Impact on the user. Not "here's a broken thing" — a brief persuasive case.

## Where they disagree with others
- **MoT vs. "QA as a developer discipline":** MoT explicitly defends testing as a skilled craft separate from coding — some dev-first communities (TDD purists, some Google practices) implicitly treat QA as redundant once unit coverage is high. MoT's position: automation covers the known-expected; testers find the unknown-unexpected.
- **MoT (heuristics) vs. ISTQB-style certifications (procedural):** MoT is broadly skeptical of checklist-driven, certification-heavy testing. Context-Driven Testing school.
- **Modern Testing vs. traditional "test gate" QA:** Page & Jensen argue QA should disband the gate and coach the team; traditional QA orgs still treat sign-off as the QA role.

## Pointers to source material
- Site: https://www.ministryoftesting.com
- Forum: https://club.ministryoftesting.com
- Modern Testing Principles: https://www.moderntesting.org
- Heuristics cheat sheet: https://www.ministryoftesting.com/articles/test-heuristics-cheat-sheet
- TestBash sessions: https://www.ministryoftesting.com/testbash-sessions
