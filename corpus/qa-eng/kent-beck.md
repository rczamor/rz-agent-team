---
name: Kent Beck
role: qa-eng
type: individual
researched: 2026-04-16
---

# Kent Beck

## Why they matter to the QA Eng
Kent Beck invented Test-Driven Development and wrote *Test-Driven Development: By Example* (2002), the book that turned "tests before code" from a niche practice into a professional norm. For this QA Eng, Beck is the primary reference for the red-green-refactor cycle that SIA's pytest suite should enforce, for how to decompose acceptance criteria into a "test list" before writing implementation, and for the discipline of separating interface design (what a behavior looks like to callers) from implementation design (how that behavior runs). His recent "Tidy First?" writing extends the same discipline to refactoring — small, reversible structural changes separated from behavior changes — which directly informs how to review PRs against test coverage and how to triage flaky or slow tests without entangling the fix with feature work.

## Signature works & primary sources
- *Test-Driven Development: By Example* (Addison-Wesley, 2002) — the canonical TDD text; worked examples in money and xUnit.
- *Extreme Programming Explained* (2nd ed., 2004) — situates TDD inside a broader engineering practice.
- *Tidy First?* (O'Reilly, 2023) — separates structural changes from behavioral changes; essential for refactoring with a green test suite.
- "Canon TDD" — https://tidyfirst.substack.com/p/canon-tdd — Beck's own current definition of TDD, five steps.
- tidyfirst.substack.com — ongoing essays on design, TDD, and team dynamics.

## Core principles (recurring patterns)
- **Canon TDD loop:** (1) write a test list, (2) write ONE test, (3) make it pass, (4) optionally refactor, (5) repeat. The test list is behavioral, not implementation.
- **Red-green-refactor:** never refactor on a red bar. Only change structure while tests are green.
- **Separate structure changes from behavior changes.** Two different commits, two different PRs if possible. Tests act as the guarantee that structure changes are neutral.
- **Design emerges from tests.** The first test forces an interface decision; subsequent tests force generalization. Don't pre-design elaborate abstractions before the tests demand them.
- **Fake it till you make it / triangulation / obvious implementation** — three escalating strategies for getting to green. Use the simplest that works.
- **"Make the change easy, then make the easy change."** Tidying first is a prerequisite to fast, safe feature work.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Test-list template (derived from acceptance criteria):** a flat list of one-liner behavioral cases per AC bullet. Check each off as a test is written. No case is complete until it has a test.
- **Red-green-refactor commit triplet:** `test: failing test for X` → `feat: make X pass` → `refactor: tidy Y (no behavior change)`. Enforce in PR review.
- **"Tidy first?" decision prompt** for any code-review comment: is this a structural tidy or a behavioral change? If both, split.
- **Triangulation pattern:** when a single test would permit a hardcoded return, add a second test with different inputs to force generalization before implementing.

## Where they disagree with others
- Beck is pyramid-leaning (many fast unit tests, fewer slow end-to-end) where Kent C. Dodds argues for a trophy (integration-heavy). For SIA's pytest suite Beck's pyramid fits better; for the Next.js website Dodds' trophy fits better.
- Beck treats TDD as design discipline first, regression safety second. The Ministry of Testing community often treats testing as an investigative activity separate from coding — Beck would call that complementary, not a substitute for TDD.
- Beck's TDD is human-paced and incremental; Google's large-test/hermetic-test doctrine is institutional and scale-oriented. Different problems, both valid.

## Pointers to source material
- Book: *Test-Driven Development: By Example* (Addison-Wesley).
- Book: *Tidy First?* (O'Reilly).
- Substack: https://tidyfirst.substack.com/
- Canon TDD post: https://tidyfirst.substack.com/p/canon-tdd
