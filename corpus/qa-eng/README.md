---
role: qa-eng
researched: 2026-04-16
---

# QA Eng Corpus

Role-specific knowledge corpus for the QA Eng on an 11-agent team. QA Eng owns test suites, integration + E2E, and work validation against acceptance criteria. Primary stacks: **pytest** (SIA backend) and **Playwright** (E2E for the Next.js website). Unique challenge: the team ships AI features, so LLM evals are first-class.

## Index

- **[kent-beck.md](./kent-beck.md)** — Inventor of TDD. Canon TDD loop (test list → one test → green → refactor), red-green-refactor discipline, and "Tidy First?" on separating structural from behavioral changes. Foundation for how pytest suites should grow.
- **[kent-c-dodds.md](./kent-c-dodds.md)** — The Testing Trophy and "Write tests. Not too many. Mostly integration." Test behavior not implementation; Testing Library query-priority (`getByRole` first, `data-testid` last). Load-bearing for the Next.js test suite.
- **[playwright-team.md](./playwright-team.md)** — Microsoft's Playwright team: the E2E framework for our website. Web-first auto-retrying assertions, role-based locators, trace viewer for CI debugging, storageState auth, network mocking via `page.route`.
- **[pytest-core-team.md](./pytest-core-team.md)** — Bruno Oliveira, Raphael Pierzina, Florian Bruhin. The idiomatic pytest style for SIA: fixtures over setUp, parametrize over loops, plain `assert`, markers for taxonomy, conftest.py for sharing.
- **[hamel-husain-shreya-shankar.md](./hamel-husain-shreya-shankar.md)** — Modern authority on LLM evals. Three-level framework (unit asserts → human + LLM-as-judge → A/B), golden-set schema, error-analysis weekly loop, judge calibration (kappa > 0.8). The playbook for SIA's AI features.
- **[ministry-of-testing.md](./ministry-of-testing.md)** — Largest global testing community. Heuristics (SFDIPOT, FEW HICCUPPS), Modern Testing Principles (Page & Jensen), session-based exploratory testing, risk-based coverage. Covers the investigative side automation doesn't.
- **[google-testing.md](./google-testing.md)** — Google Testing Blog and Eng Practices. Test sizes (small/medium/large), hermeticity as a contract, flakiness-is-a-bug doctrine, "just say no to more E2E tests," code review for testability. Scaling discipline for the test suite.

## How these sources relate

- **Pyramid vs. trophy:** Beck + Google lean pyramid (unit-heavy); Dodds leans trophy (integration-heavy). Use pyramid for SIA (Python backend, many pure functions); use trophy for the Next.js website.
- **Deterministic vs. AI testing:** Beck/Dodds/Playwright/pytest/Google cover deterministic code. Husain/Shankar cover the LLM-eval layer that sits ON TOP of those suites.
- **Automation vs. exploration:** All technical sources above automate. MoT covers the exploratory and heuristic work that automation cannot replace — especially valuable for AI features where the oracle is fuzzy.
