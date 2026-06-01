---
name: Google Testing Blog & Google Engineering Practices
role: qa-eng
type: publication
researched: 2026-04-16
---

# Google Testing Blog & Google Engineering Practices

## Why they matter to the QA Eng
Google has been running one of the largest test suites on Earth for nearly two decades, and the lessons they've published — via the Google Testing Blog (testing.googleblog.com, since 2007) and the public Google Engineering Practices docs (google.github.io/eng-practices) — are the most battle-tested source for how to keep a large test suite **fast, hermetic, and non-flaky**. For this QA Eng, Google's vocabulary (small/medium/large tests, hermetic, flakiness mitigation, "just say no to more end-to-end tests") is the reference frame for scaling decisions: how many E2E vs. integration vs. unit tests, how to isolate DB-touching tests, and how to stop the test suite from rotting. Contributors like Misko Hevery (dependency injection for testability) and James Whittaker shaped the practice; the blog still publishes regularly (e.g. "The Way of TDD", March 2026).

## Signature works & primary sources
- testing.googleblog.com — archives from 2007, TotT ("Testing on the Toilet") series, flaky-tests posts.
- "Just Say No to More End-to-End Tests" (Mike Wacker, 2015) — https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html — the canonical argument against the inverted pyramid.
- "Flaky Tests at Google and How We Mitigate Them" (2016) — https://testing.googleblog.com/2016/05/flaky-tests-at-google-and-how-we.html
- Google Engineering Practices (Code Review) — https://google.github.io/eng-practices/
- *Software Engineering at Google* (O'Reilly, 2020) — chapters 11–14 on testing, larger tests, test doubles, deprecation. The authoritative book-length treatment.
- Hermetic/ephemeral test environments — Carlos Arguelles' write-ups.

## Core principles (recurring patterns)
- **Test sizes: Small, Medium, Large.** Small = single-process, no network, no disk, < 100ms (unit). Medium = localhost only, < 1s (integration). Large = multi-process or remote, minutes (E2E). The sizes are the contract — smaller tests run on every commit; larger tests run less often.
- **Test pyramid: ~70% small, ~20% medium, ~10% large.** Inverted pyramids (lots of E2E, few units) are the canonical failure mode. "Just say no to more end-to-end tests" is the Google rallying cry.
- **Hermeticity is mandatory.** A hermetic test has zero dependency on shared infra — no shared DB, no network to a real service, no `/tmp` collision. Ephemeral containers per test run.
- **Flakiness is a bug, not a cost of doing business.** Google quarantines flaky tests automatically, tracks the top flakes, and owners fix or delete. A flake rate over ~1% corrupts the trustworthiness of the whole suite.
- **Code review for testability.** Reviewers are explicitly asked to check that code is testable, that tests exist for new behavior, and that the test shape matches the change size.
- **Prefer fakes to mocks.** For external deps, a maintained fake (in-memory DB, fake cloud client) gives better fidelity than mocks tied to call signatures. "Don't Overuse Mocks" (TotT).
- **Functional core, imperative shell.** Architect code so that the bulk of logic is pure and unit-testable; side effects live at the edge.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Test-size marker taxonomy (pytest port of Google sizes):**
  ```
  @pytest.mark.small      # <100ms, no I/O
  @pytest.mark.medium     # <1s, localhost only
  @pytest.mark.large      # >1s or external, E2E
  ```
  CI runs `-m small` on every push, `small or medium` on PR, full suite nightly.
- **Hermetic test checklist:** no shared DB (use `tmp_path`/ephemeral container), no network (requests mocked or blocked), no time-of-day dependency (`freezegun`), no env-var reliance, no shared files.
- **Flaky test triage protocol:** (1) reproduce with `--count=20` / `--repeat`, (2) if <100% repro, tag `@pytest.mark.flaky` and open a ticket in 24h, (3) if not fixed in 1 week, delete the test — do not let unreliable signal accumulate.
- **Code-review-for-testability prompts:** "Is this function pure enough to unit test without mocks?" "Does the new behavior have a test at the right size?" "Does this PR introduce any non-hermetic test?"
- **Large-test budget:** cap the number of E2E tests per feature area (e.g. ≤10 on the website). New E2E tests require removing an old one OR a written justification — the pyramid doesn't maintain itself.

## Where they disagree with others
- **Google (pyramid, ~70% small) vs. Kent C. Dodds (trophy, integration-heavy):** Google's argument is written at a scale (millions of tests) where E2E is ruinously expensive; Dodds' argument is written at web-app scale where integration is cheap. Both are right in context.
- **Google (prefer fakes) vs. mock-heavy unit testing cultures:** Google explicitly calls out over-mocking as a bigger risk than under-testing.
- **Google (tests are a code-review artifact) vs. QA-owns-testing cultures:** Google embeds testing in the review loop; untested code is (generally) unreviewable.

## Pointers to source material
- Blog: https://testing.googleblog.com
- Eng practices: https://google.github.io/eng-practices/
- Book: *Software Engineering at Google* (O'Reilly, 2020) — free online at https://abseil.io/resources/swe-book
- Key post: "Just Say No to More E2E Tests" — https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html
- Key post: "Flaky Tests at Google" — https://testing.googleblog.com/2016/05/flaky-tests-at-google-and-how-we.html
