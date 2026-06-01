---
name: Kent C. Dodds
role: qa-eng
type: individual
researched: 2026-04-16
---

# Kent C. Dodds

## Why they matter to the QA Eng
Kent C. Dodds reshaped how frontend teams think about testing by inventing the **Testing Trophy** and by authoring the Testing Library ecosystem (React Testing Library, DOM Testing Library, jest-dom, user-event). For the Next.js website this team ships, his framework is load-bearing: it tells us which tests to write, in what proportion, and — critically — which tests NOT to write. His core thesis, *"The more your tests resemble the way your software is used, the more confidence they can give you,"* is the rule this QA Eng should apply when reviewing any frontend PR. He is also the clearest voice against testing implementation details, which is the single most common failure mode in a brittle test suite.

Note: Dodds also appears in the UI Eng corpus. Here we focus strictly on testing philosophy — not React patterns, component design, or hooks.

## Signature works & primary sources
- "Write tests. Not too many. Mostly integration." — https://kentcdodds.com/blog/write-tests — the foundational post.
- "The Testing Trophy and Testing Classifications" — https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications — defines the shape.
- "Testing Implementation Details" — https://kentcdodds.com/blog/testing-implementation-details — the anti-pattern.
- testing-library.com — the family of libraries that encode his principles.
- "Common mistakes with React Testing Library" — https://kentcdodds.com/blog/common-mistakes-with-react-testing-library

## Core principles (recurring patterns)
- **The Testing Trophy (bottom → top):** Static (TypeScript, ESLint) → Unit → **Integration (the bulk)** → E2E. Integration sits in the middle because it gives the best confidence-per-dollar.
- **"The more your tests resemble the way your software is used, the more confidence they can give you."** Query the DOM by role, label, and text — the same affordances a user perceives.
- **Test behavior, not implementation.** Don't assert on component state, private methods, or CSS class names. Render, interact, assert on visible output.
- **Avoid shallow rendering and excessive mocking.** Mocks erase the integration you're trying to verify. Mock only at system boundaries (network, time, randomness).
- **Stop chasing 100% coverage.** Past ~70% the returns are brittle tests, not safety. Prioritize user-critical paths.
- **Query priority:** `getByRole` > `getByLabelText` > `getByPlaceholderText` > `getByText` > `getByTestId`. `data-testid` is the escape hatch, not the default.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Integration test skeleton (React Testing Library):** render the component tree with real providers, drive it with `userEvent` (not `fireEvent`), assert on `screen.getByRole(...)`. Mock only fetch/network.
- **Implementation-details review checklist:** flag any test that (a) reads component internal state, (b) uses `.instance()` or shallow rendering, (c) asserts on CSS class names, (d) imports private/non-exported helpers, (e) breaks on every refactor.
- **"Would a user see this?" gate:** before writing an assertion, ask whether the thing being asserted is visible/audible to an end user or consumable by a calling developer. If neither, don't assert on it.
- **Mocking decision table:** network → mock (MSW); time → mock (vi.useFakeTimers); randomness → mock; internal modules → do not mock.

## Where they disagree with others
- **Dodds (trophy, integration-heavy) vs. Kent Beck / Google (pyramid, unit-heavy):** Dodds argues the pyramid is a legacy of slow, expensive integration tests and that modern tooling (jsdom, MSW, Playwright component testing) has made integration cheap enough to be the majority. Beck and Google still favor many tiny unit tests.
- **Dodds vs. Enzyme-era React testing:** Dodds explicitly rejects shallow rendering, `wrapper.state()`, and snapshot-dominant suites.
- **Dodds vs. "100% coverage" mandates:** he argues coverage targets incentivize the wrong tests.

## Pointers to source material
- Primary site: https://kentcdodds.com (blog archive, especially the `/blog/testing-*` posts).
- Library docs: https://testing-library.com (React, DOM, Vue, Svelte variants).
- Course: EpicReact.dev and TestingJavaScript.com (paid, but the free blog posts cover the philosophy).
